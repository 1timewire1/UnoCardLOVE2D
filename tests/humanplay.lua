-- Simulated human player test.  Run with:   love . --test=humanplay [games-per-config]
--
-- Like selfplay.lua, but YOU are played by a script that only uses mouse
-- clicks on the real hit-boxes: select a card, click it again to play it,
-- pick a color on the wheel, draw from the deck, answer the challenge /
-- keep-the-drawn-card questions, choose a 7-0 swap target, and sometimes hit
-- <AUTO>. This exercises every human-input status of the game flow.

local D = require("src.defs")
local common = require("tests.common")

local M = {}

local rnd = function(lo, hi) return love.math.random(lo, hi) end

local function runAll(Game)
    local T = Game._test
    local C = T.constants
    local uno, ai = T.uno(), T.ai()

    love.filesystem.setIdentity("UnoCard-test")
    T.mute()
    T.setFast(true)

    local gamesPerConfig = 3

    for _, a in ipairs(arg or {}) do
        if tonumber(a) then gamesPerConfig = tonumber(a) end
    end

    local ctx = common.install(T)
    local fail = ctx.fail
    local seen = {}
    local games = 0

    -- Centers of the wheel's sectors (1600x900 space)
    local SECTOR = { [D.RED] = { 350, 350 }, [D.BLUE] = { 450, 350 }, [D.YELLOW] = { 350, 450 }, [D.GREEN] = { 450, 450 } }
    local YES, NO = { 400, 350 }, { 400, 450 }

    local function click(pos)
        T.click(pos[1], pos[2])
    end

    --- Click, and return whether the click had any effect. The game flow
    -- runs (through setStatus) after every effective click; a click that hits
    -- nothing does not. (The status can't be used: after answering a
    -- question, the AI turns run until the next question, which may be of
    -- the same kind.)
    local function effective(x, y)
        local before = ctx.steps()

        T.click(x, y)
        return ctx.steps() ~= before
    end

    local function handX(index)
        local size = #uno:getHandCardsOf(D.YOU)

        return 800 - math.floor((44 * size + 76) / 2) + 44 * (index - 1) + 20
    end

    local function count(name)
        seen[name] = (seen[name] or 0) + 1
    end

    --- Do one action of the simulated human. Returns false if the game is over.
    local function humanAction()
        local st = T.status()

        -- When you are asked about a card (keep-or-play / color wheel), the
        -- selected card must be a legal card in your hand (a wild card for
        -- the wheel).
        if st == C.STAT_ASK_KEEP_PLAY or st == C.STAT_WILD_COLOR then
            local card = uno:getHandCardsOf(D.YOU)[T.selected()]

            if not card or not uno:isLegalToPlay(card) then
                fail("asked about a card that is not a legal card in your hand")
            elseif st == C.STAT_WILD_COLOR and not card:isWild() then
                fail("the color wheel is shown for a card that is not a wild card")
            end
        end

        if st == C.STAT_GAME_OVER then
            return false
        elseif st == C.STAT_IDLE then
            fail("game is idle while waiting for a click")
            return false
        elseif st == D.YOU then
            count("your turn")
            local hand = uno:getHandCardsOf(D.YOU)

            -- Sometimes hit <AUTO>: the AI plays the rest of the game
            if rnd(1, 40) == 1 then
                count("<AUTO>")
                T.click(1500, 860)
                return true
            end

            -- Sometimes click an illegal card first (must only select it)
            for i, card in ipairs(hand) do
                if not uno:isLegalToPlay(card) and rnd(1, 6) == 1 then
                    T.click(handX(i), 790)
                    count("selected an illegal card")
                    if T.selected() ~= i then fail("clicking a card did not select it") end
                    T.click(handX(i), 790)
                    if T.status() ~= D.YOU then fail("an illegal card was played") end
                    break
                end
            end

            -- Choose a card: the AI's choice, or a random legal card
            local idx, color = ai:easyAI_bestCardIndex4NowPlayer()

            if rnd(1, 3) == 1 then
                local legal = {}

                for i, card in ipairs(hand) do
                    if uno:isLegalToPlay(card) then legal[#legal + 1] = i end
                end

                idx, color = legal[rnd(1, #legal)], rnd(1, 4)
            end

            if idx == 0 or rnd(1, 12) == 1 then
                -- Draw a card from the deck
                count("drew a card")

                if not effective(400, 450) then fail("clicking the deck did nothing") end
            else
                T.click(handX(idx), 790) -- select
                if T.selected() ~= idx then fail("clicking a card did not select it") end
                T.click(handX(idx), 790) -- click again to play
                count("played a card")
            end

            ctx.lastColor = color
        elseif st == C.STAT_WILD_COLOR then
            count("wild color wheel")
            local color = ctx.lastColor and ctx.lastColor >= 1 and ctx.lastColor <= 4 and ctx.lastColor or rnd(1, 4)

            if not effective(SECTOR[color][1], SECTOR[color][2]) then fail("clicking a wheel sector did nothing") end
        elseif st == C.STAT_DOUBT_WILD4 then
            count("challenge question")
            local pos = rnd(1, 2) == 1 and YES or NO

            if not effective(pos[1], pos[2]) then fail("answering the challenge did nothing") end
        elseif st == C.STAT_ASK_KEEP_PLAY then
            count("keep-or-play question")
            local how = rnd(1, 3)
            local x, y

            if how == 1 then
                x, y = NO[1], NO[2]
            elseif how == 2 then
                x, y = YES[1], YES[2]
            else
                -- Click the drawn card (it is raised) in your hand
                x, y = handX(T.selected()), 790
            end

            if not effective(x, y) then fail("answering keep-or-play did nothing") end
        elseif st == C.STAT_SEVEN_TARGET then
            count("swap target question")
            if uno:getPlayers() == 3 and effective(405, 330) then
                -- The north sector is drawn but must do nothing in 3P
                fail("north was selectable in a 3-player game")
            end

            local t = rnd(1, uno:getPlayers() == 4 and 3 or 2)
            local x, y = 450, 450 -- east

            if t == 3 then
                x, y = 405, 330 -- north
            elseif t == 1 then
                x, y = 350, 450 -- west
            end

            if not effective(x, y) then fail("choosing a swap target did nothing") end
        elseif st == C.STAT_BULLSEYE_TARGET then
            count("bullseye target question")
            if uno:getPlayers() == 3 and effective(405, 330) then
                -- The north sector is drawn but must do nothing in 3P
                fail("north was selectable in a 3-player game (bullseye)")
            end

            local t = rnd(1, uno:getPlayers() == 4 and 3 or 2)
            local x, y = 450, 450 -- east

            if t == 3 then
                x, y = 405, 330 -- north
            elseif t == 1 then
                x, y = 350, 450 -- west
            end

            if not effective(x, y) then fail("choosing a bullseye target did nothing") end
        else
            fail("unexpected status " .. st)
            return false
        end

        return true
    end

    -- Cycled (not crossed) across games within each config, same reasoning
    -- as selfplay.lua's EXTRA_PRESETS.
    local EXTRA_PRESETS = {
        { drawToMatch = false, noChallenge = false, bullseye = false, swapPack = false },
        { drawToMatch = true, noChallenge = false, bullseye = false, swapPack = false },
        { drawToMatch = false, noChallenge = true, bullseye = false, swapPack = false },
        { drawToMatch = false, noChallenge = false, bullseye = true, swapPack = false },
        { drawToMatch = true, noChallenge = true, bullseye = true, swapPack = false },
        { drawToMatch = false, noChallenge = false, bullseye = false, swapPack = true },
        { drawToMatch = true, noChallenge = true, bullseye = true, swapPack = true },
    }

    local function config(mode, stack, force, level, initial, extraIdx)
        uno:setGameMode(mode)
        uno:setStackRule(stack)
        uno:setForcePlayRule(force)
        uno:setDifficulty(level)
        while uno:getInitialCards() < initial do uno:increaseInitialCards() end
        while uno:getInitialCards() > initial do uno:decreaseInitialCards() end

        local extra = EXTRA_PRESETS[extraIdx or 1]

        uno:setDrawToMatchRule(extra.drawToMatch)
        uno:setWildDraw4NoChallengeRule(extra.noChallenge)
        uno:setBullseyeRule(extra.bullseye)
        uno:setSwapPackRule(extra.swapPack)
    end

    local modeName = { [0] = "2P", [1] = "7-0", [2] = "2vs2", [3] = "3P", [4] = "4P" }
    local t0 = os.clock()
    local replaysChecked = 0

    for _, mode in ipairs({ 3, 4, 1, 2, 0 }) do
        for stack = 0, 2 do
            for force = 0, 2 do
                for level = 0, 1 do
                    for g = 1, gamesPerConfig do
                        local initial = ({ 7, 5, 12 })[g % 3 + 1]
                        local extraIdx = (g - 1) % #EXTRA_PRESETS + 1
                        local label = string.format("%s stack=%d force=%d level=%d initial=%d extra=%d",
                            modeName[mode], stack, force, level, initial, extraIdx)

                        config(mode, stack, force, level, initial, extraIdx)
                        love.math.setRandomSeed(games + 1)
                        games = games + 1
                        T.setAuto(false)
                        ctx.live(true)
                        ctx.resetSteps()

                        local ok, err = pcall(function()
                            T.click(T.status() == C.STAT_GAME_OVER and 400 or 800, 450)

                            local actions = 0

                            -- Scaled up alongside common.lua's per-game step
                            -- ceiling: 2-player games run legitimately much
                            -- longer (Reverse gives the same player another
                            -- turn instead of passing it on), and roughly
                            -- half of all turns are "your turn" there.
                            while humanAction() do
                                actions = actions + 1
                                if actions > 30000 then
                                    error("too many actions")
                                end
                            end
                        end)

                        ctx.live(false)
                        if not ok then
                            fail(label .. ": " .. tostring(err))
                        elseif T.status() ~= C.STAT_GAME_OVER then
                            fail(label .. ": game did not end (status " .. T.status() .. ")")
                        else
                            local before = common.snapshot(uno)

                            T.setAuto(false)
                            local okr, errr = pcall(T.startReplay, table.concat(uno.replay, ";"), "test.sav")

                            if not okr then
                                fail(label .. ": replay error: " .. tostring(errr))
                            else
                                local after = common.snapshot(uno)

                                for i = 0, 3 do
                                    if before[i] ~= after[i] then
                                        fail(label .. ": replay: hand of player " .. i .. " differs")
                                    end
                                end

                                replaysChecked = replaysChecked + 1
                            end
                        end

                        coroutine.yield()
                    end
                end
            end
        end
    end

    print(string.format("games: %d, replays verified: %d, time: %.1fs", games, replaysChecked, os.clock() - t0))
    local names = {}

    for k in pairs(seen) do names[#names + 1] = k end
    table.sort(names)
    for _, k in ipairs(names) do
        print(string.format("  %-28s %d", k, seen[k]))
    end

    print(ctx.failures() == 0 and "ALL PASSED" or (ctx.failures() .. " FAILURE(S)"))
    love.event.quit(ctx.failures() == 0 and 0 or 1)
end

function M.run(Game)
    common.perFrame(function() runAll(Game) end)
end

return M
