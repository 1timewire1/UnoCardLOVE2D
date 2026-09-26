-- Headless self-play test.  Run with:   love . --test=selfplay [games-per-config]
--
-- Plays whole games (all four seats controlled by the AI, through the real
-- game flow in fast-forward mode) for every combination of game mode, stack
-- rule, force-play rule and difficulty, and checks (see common.lua):
--   * card conservation (108 cards) and hand limits at every step,
--   * that nobody but the players in game holds cards,
--   * that the legality table agrees with an independent spec of the rules,
--     and the AI never picks an illegal card,
--   * that every game terminates with exactly one winner,
--   * that the saved replay, played back, reproduces the final position.
--
-- Options: a number = games per config (default 6); "verbose" prints every
-- game; "from=N" skips to game number N (games are seeded by their number,
-- so a failing game can be reproduced).

local common = require("tests.common")

local M = {}

local function runAll(Game)
    local T = Game._test
    local C = T.constants
    local uno = T.uno()

    -- Never touch the real save directory (score & settings of a player)
    love.filesystem.setIdentity("UnoCard-test")
    T.mute()
    T.setFast(true)

    local gamesPerConfig, verbose, fromGame = 6, false, 0

    for _, a in ipairs(arg or {}) do
        if tonumber(a) then gamesPerConfig = tonumber(a) end
        if a == "verbose" then verbose = true end
        if a:match("^from=%d+$") then fromGame = tonumber(a:match("%d+")) end
    end

    local ctx = common.install(T)
    local fail = ctx.fail
    local games, replaysChecked = 0, 0
    local stats = {}

    -- Cycled (not crossed, to avoid a combinatorial explosion) across games
    -- within each mode/stack/force/level config, so the new independent
    -- rules still get broad exercise without multiplying the matrix size.
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

    local function startGame()
        -- Click the deck: welcome screen / game over screen
        if T.status() == C.STAT_GAME_OVER then
            T.click(400, 450)
        else
            T.click(800, 450)
        end
    end

    local modes = { 3, 4, 1, 2, 0 }
    local modeName = { [0] = "2P", [1] = "7-0", [2] = "2vs2", [3] = "3P", [4] = "4P" }
    local t0 = os.clock()

    for _, mode in ipairs(modes) do
        for stack = 0, 2 do
            print(string.format("[%.0fs] %s stack=%d (games so far: %d)", os.clock() - t0, modeName[mode], stack, games))
            io.stdout:flush()
            for force = 0, 2 do
                for level = 0, 1 do
                    for g = 1, gamesPerConfig do
                        if games + 1 < fromGame then
                            games = games + 1
                            goto continue
                        end

                        local initial = ({ 7, 5, 20, 7, 12 })[g % 5 + 1]
                        local extraIdx = (g - 1) % #EXTRA_PRESETS + 1
                        local label = string.format("%s stack=%d force=%d level=%d initial=%d extra=%d",
                            modeName[mode], stack, force, level, initial, extraIdx)

                        config(mode, stack, force, level, initial, extraIdx)
                        T.setAuto(true)
                        ctx.live(true)
                        ctx.resetSteps()

                        -- Deterministic: game number n can be reproduced
                        love.math.setRandomSeed(games + 1)
                        if verbose then
                            print(string.format("game %d: %s", games + 1, label))
                            io.stdout:flush()
                        end

                        local ok, err = pcall(startGame)

                        ctx.live(false)
                        games = games + 1
                        if not ok then
                            fail(label .. ": error: " .. tostring(err))
                        elseif T.status() ~= C.STAT_GAME_OVER then
                            fail(label .. ": game did not end (status " .. T.status() .. ")")
                        else
                            -- Exactly one winner, holding no cards
                            local empty = 0

                            for i = 0, 3 do
                                if #uno:getHandCardsOf(i) == 0 and common.isActiveSeat(uno:getPlayers(), i) then
                                    empty = empty + 1
                                end
                            end

                            if empty ~= 1 then
                                fail(label .. ": " .. empty .. " players have no cards at game over")
                            end

                            if T.score() < -999 or T.score() > 9999 then
                                fail(label .. ": score out of range " .. T.score())
                            end

                            local key = modeName[mode] .. " level=" .. level

                            stats[key] = (stats[key] or 0) + ctx.steps()

                            -- Replay round trip
                            local before = common.snapshot(uno)
                            local text = table.concat(uno.replay, ";")

                            T.setAuto(false)
                            local okr, errr = pcall(T.startReplay, text, "test.sav")

                            if not okr then
                                fail(label .. ": replay error: " .. tostring(errr))
                            else
                                local after = common.snapshot(uno)

                                for i = 0, 3 do
                                    if before[i] ~= after[i] then
                                        fail(label .. ": replay: hand of player " .. i .. " differs: ["
                                            .. before[i] .. "] vs [" .. after[i] .. "]")
                                    end
                                end

                                if before.last ~= after.last then
                                    fail(label .. ": replay: last card differs")
                                end

                                replaysChecked = replaysChecked + 1
                            end

                            -- Back to a state where a new game can be started
                            config(mode, stack, force, level, initial, extraIdx)
                            if T.status() ~= C.STAT_WELCOME then
                                fail(label .. ": not on the welcome screen after replay (" .. T.status() .. ")")
                            end
                        end

                        -- One game per frame, like the real game presents frames
                        coroutine.yield()

                        ::continue::
                    end
                end
            end
        end
    end

    print(string.format("games: %d, replays verified: %d, AI decisions checked: %d, time: %.1fs",
        games, replaysChecked, ctx.aiChecks(), os.clock() - t0))
    for k, v in pairs(stats) do
        print(string.format("  %-16s average status steps/game: %.0f", k, v / (gamesPerConfig * 9)))
    end

    print(ctx.failures() == 0 and "ALL PASSED" or (ctx.failures() .. " FAILURE(S)"))
    love.event.quit(ctx.failures() == 0 and 0 or 1)
end

--- The test runs in a coroutine that is resumed once per frame.
function M.run(Game)
    common.perFrame(function() runAll(Game) end)
end

return M
