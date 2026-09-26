-- Shared checks for the headless tests.

local D = require("src.defs")

local M = {}

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
            for id = 0, 53 do
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

        if steps > 20000 then
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

            if players == 3 and i == D.COM2 and n > 0 then
                ctx.fail("north holds cards in a 3-player game")
            end

            if #uno.player[i].open ~= n then
                ctx.fail("open[] out of sync with the hand of player " .. i)
            end
        end

        if total ~= 108 then
            ctx.fail("card count is " .. total .. " instead of 108 (status " .. status .. ")")
        end

        if players == 3 and status == D.COM2 then
            ctx.fail("turn of north in a 3-player game")
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
