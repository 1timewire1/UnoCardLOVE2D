-- Shared checks for the headless tests.

local D = require("src.defs")

local M = {}

--- Whether seat `i` is actually in play at this player count (2P sits out
-- COM1/COM3, 3P sits out COM2). Used to tell a genuine empty-handed winner
-- apart from a seat that was never dealt any cards to begin with.
function M.isActiveSeat(players, i)
    if players == 4 then
        return true
    elseif players == 3 then
        return i ~= D.COM2
    else -- players == 2
        return i == D.YOU or i == D.COM2
    end
end

--- An independent spec of which cards are legal to play (not derived from the
-- legality table of the Uno class, which is what it is checked against).
function M.specLegal(uno, card)
    local last = uno:getRecentInfo()[3]

    if uno:getDraw2StackCount() == 0 then
        return card:isWild()
            or card.color == last.color
            or (not last.card:isWild() and card.content == last.card.content)
    elseif uno:getStackRule() == 1 then
        return card.content == D.DRAW2
    end

    -- Stack rule 2: +2 / +4 stack. A +4 leaves the color unchanged.
    if card.content == D.WILD_DRAW4 then
        return true
    elseif card.content ~= D.DRAW2 then
        return false
    end

    return last.card.content ~= D.WILD_DRAW4 or card.color == last.color
end

--- Sorted card ids of everyone's hands + the last played card.
function M.snapshot(uno)
    local s = {}

    for p = 0, 3 do
        local ids = {}

        for _, c in ipairs(uno:getHandCardsOf(p)) do
            ids[#ids + 1] = c.id
        end

        table.sort(ids)
        s[p] = table.concat(ids, ",")
    end

    s.last = uno:getRecentInfo()[3].card.id
    return s
end

--- Install the per-step invariant checks (through the game's test hook) and
-- wrap the AI so that its picks are verified.
-- @return A context table: fail(msg), failures(), live(bool), resetSteps(),
--         steps(), aiChecks().
function M.install(T)
    local C = T.constants
    local uno, ai = T.uno(), T.ai()
    local failures, aiChecks, steps, live = 0, 0, 0, false
    local ctx = {}

    function ctx.fail(msg)
        failures = failures + 1
        if failures <= 25 then
            print("FAIL: " .. msg)
        end
    end

    function ctx.failures() return failures end
    function ctx.live(v) live = v end
    function ctx.resetSteps() steps = 0 end
    function ctx.steps() return steps end
    function ctx.aiChecks() return aiChecks end

    -- Wrap the AI: it must never pick an illegal card
    for _, name in ipairs({
        "easyAI_bestCardIndex4NowPlayer", "hardAI_bestCardIndex4NowPlayer",
        "teamAI_bestCardIndex4NowPlayer", "sevenZeroAI_bestCardIndex4NowPlayer",
    }) do
        local orig = ai[name]

        ai[name] = function(self)
            local idx, color = orig(self)
            local hand = uno:getCurrPlayer():getHandCards()

            aiChecks = aiChecks + 1
            for id = 0, 55 do
                local card = uno:findCardById(id)

                if uno:isLegalToPlay(card) ~= (M.specLegal(uno, card) and true or false) then
                    ctx.fail(string.format("%s: legality of %s differs from spec (stack=%d count=%d last=%s/%d)",
                        name, card.name, uno:getStackRule(), uno:getDraw2StackCount(),
                        uno:getRecentInfo()[3].card.name, uno:getRecentInfo()[3].color))
                    break
                end
            end

            if idx < 0 or idx > #hand then
                ctx.fail(name .. ": index out of range " .. idx)
            elseif idx > 0 and not uno:isLegalToPlay(hand[idx]) then
                ctx.fail(name .. ": picked illegal card " .. hand[idx].name)
            end

            -- (With a single card left the game ends, and the color is moot)
            if idx > 0 and #hand > 1 and hand[idx]:isWild() and (color < 1 or color > 4) then
                ctx.fail(name .. ": wild card without a color")
            end

            return idx, color
        end
    end

    T.setHook(function(status)
        steps = steps + 1

        -- (At STAT_NEW_GAME the previous game's state is still in place)
        if not live or status == C.STAT_NEW_GAME then
            return
        end

        -- 2-player games can legitimately run much longer than 3-4 player
        -- ones: Reverse gives the same player another turn instead of just
        -- changing whose turn is next, which compounds with stacking and
        -- (in humanplay.lua) a not-always-optimal simulated human into a
        -- heavy-tailed but still finite distribution of game lengths.
        -- Simulating this rule combination directly against the real
        -- engine (outside this test) found games up to ~4500 steps well
        -- within a few thousand random seeds, so this ceiling has real
        -- headroom above that rather than just clearing one observed case.
        if steps > 200000 then
            ctx.fail("game does not terminate")
            error("aborted")
        end

        local total = uno:getDeckCount() + #uno.used
        local players = uno:getPlayers()

        for i = 0, 3 do
            local n = #uno:getHandCardsOf(i)

            total = total + n
            if uno:getRecentInfo()[i].card ~= nil then
                total = total + 1
            end

            if n > 26 then
                ctx.fail("hand of player " .. i .. " has " .. n .. " cards")
            end

            if n > 0 and not M.isActiveSeat(players, i) then
                ctx.fail("player " .. i .. " holds cards but sits out a " .. players .. "-player game")
            end

            if #uno.player[i].open ~= n then
                ctx.fail("open[] out of sync with the hand of player " .. i)
            end
        end

        -- Swap Pack adds 4 copies each of 2 cards to the deck when enabled
        -- (see uno.lua's start()); the base deck is otherwise always 108.
        local expected = 108 + (uno:isSwapPackRule() and 8 or 0)

        if total ~= expected then
            ctx.fail("card count is " .. total .. " instead of " .. expected .. " (status " .. status .. ")")
        end

        if (status == D.YOU or status == D.COM1 or status == D.COM2 or status == D.COM3)
            and not M.isActiveSeat(players, status) then
            ctx.fail("turn of player " .. status .. " who sits out a " .. players .. "-player game")
        end
    end)

    return ctx
end

--- Run fn (a function that may yield) as a coroutine, resumed once per frame
-- so that frames get presented (see selfplay.lua for why that matters).
function M.perFrame(fn)
    local co = coroutine.create(fn)

    love.window.setVSync(0)
    love.update = function()
        if coroutine.status(co) ~= "dead" then
            local ok, err = coroutine.resume(co)

            if not ok then
                print("ERROR: " .. debug.traceback(co, tostring(err)))
                io.stdout:flush()
                love.event.quit(1)
            end
        end
    end
end

return M
