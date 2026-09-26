-- Settings / replay file test.  Run with:   love . --test=persist
--
-- Checks that settings survive a restart (the original's UnoCard.stat), that a
-- replay file dropped onto the window is played, and that broken replay files
-- are rejected without crashing.

local common = require("tests.common")

local M = {}

function M.run(Game)
    local T = Game._test
    local C = T.constants
    local failures = 0

    local function check(cond, msg)
        if not cond then
            failures = failures + 1
            print("FAIL: " .. msg)
        end
    end

    love.filesystem.setIdentity("UnoCard-persist-test")
    love.filesystem.remove("UnoCard.stat")
    T.mute()
    T.setFast(true)

    common.perFrame(function()
        local uno = T.uno()

        -- 0. Mouse mapping in a window that is not 16:9. The 1600x900 screen is
        -- letterboxed: scale = 0.625, so it is 1000x562.5 with 118.75px bars
        -- above and below. The UNO card (virtual 800,450) is at (500, 400).
        love.window.updateMode(1000, 800)
        coroutine.yield()
        Game.mousepressed(500, 50, 1) -- in the top bar
        check(T.status() == C.STAT_WELCOME and not T.busy(), "a click in the letterbox bar did something")
        Game.mousepressed(500, 400, 1, false)
        check(T.status() ~= C.STAT_WELCOME, "clicking the UNO card in a letterboxed window did not start a game")
        Game.mousepressed(500, 400, 2) -- other buttons are ignored
        T.setStatus(C.STAT_WELCOME)
        love.window.updateMode(1280, 720)
        coroutine.yield()

        -- 1. Change settings the way a player does: options screen + clicks
        T.click(100, 860) -- <SETTINGS>
        T.click(1500, 860) -- <LANG>: en -> zh
        T.click(1330, 100) -- speed 3
        T.click(270, 100) -- BGM off
        T.click(670, 100) -- SND toggle
        T.click(100, 860)
        uno:setGameMode(1)
        uno:setStackRule(2)
        uno:setForcePlayRule(0)
        uno:setDifficulty(1)
        uno:setDrawToMatchRule(true)
        uno:setWildDraw4NoChallengeRule(true)
        uno:setBullseyeRule(true)
        while uno:getInitialCards() < 12 do uno:increaseInitialCards() end

        -- Play a game for the score to change
        T.setAuto(true)
        T.click(800, 450)
        local score = T.score()

        check(score ~= 0, "the score did not change after a game")
        check(love.filesystem.getInfo("UnoCard.stat") ~= nil, "settings were not saved at game over")
        print("saved settings:\n" .. tostring(love.filesystem.read("UnoCard.stat")))

        -- 2. "Restart": load everything again from the file
        Game.load({})
        T.setFast(true)
        T.mute()
        uno = T.uno()
        check(T.status() == C.STAT_WELCOME, "not on the welcome screen after loading")
        check(uno:getGameMode() == 1 and uno:isSevenZeroRule() and uno:getPlayers() == 4, "game mode (7-0) not restored")
        check(uno:getStackRule() == 2, "stack rule not restored")
        check(uno:getForcePlayRule() == 0, "force play rule not restored")
        check(uno:getDifficulty() == 1, "difficulty not restored")
        check(uno:isDrawToMatchRule(), "draw-to-match rule not restored")
        check(uno:isWildDraw4NoChallengeRule(), "wild +4 no-challenge rule not restored")
        check(uno:isBullseyeRule(), "bullseye rule not restored")
        check(uno:getInitialCards() == 12, "initial cards not restored (" .. uno:getInitialCards() .. ")")
        check(T.lang() == "zh", "language not restored (" .. tostring(T.lang()) .. ")")
        check(T.speed() == 3, "speed not restored")
        check(T.bgmVolume() == 0, "bgm volume not restored")
        check(T.score() == score, "score not restored: " .. T.score() .. " vs " .. score)

        -- 3. A replay dropped onto the window is played
        T.setAuto(true)
        T.click(800, 450)
        local before = common.snapshot(uno)

        love.filesystem.createDirectory("replays")
        love.filesystem.write("replays/dropped.sav", table.concat(uno.replay, ";"))
        T.setStatus(C.STAT_WELCOME)
        Game.filedropped(love.filesystem.newFile("replays/dropped.sav"))

        local after = common.snapshot(uno)

        for i = 0, 3 do
            check(before[i] == after[i], "dropped replay: hand of player " .. i .. " differs")
        end

        check(T.status() == C.STAT_WELCOME, "not back on the welcome screen after the dropped replay")

        -- 4. Broken replay files are rejected without crashing
        for name, text in pairs({
            empty = "",
            garbage = "hello world",
            noStart = "DR,0,5;PL,0,5,1",
            twoStarts = "ST,0,3,5;ST,0,3,5",
            badParam = "ST,0,9,5",
            badCard = "ST,0,3,5;DR,0,99",
            unknown = "ST,0,3,5;XX,1,2",
            swapSelf = "ST,0,4,5;SW,1,1",
        }) do
            love.filesystem.write("replays/bad.sav", text)
            local ok, err = pcall(Game.filedropped, love.filesystem.newFile("replays/bad.sav"))

            check(ok, "broken replay '" .. name .. "' crashed: " .. tostring(err))
            check(T.status() == C.STAT_WELCOME, "broken replay '" .. name .. "' left status " .. T.status())
        end

        -- 5. A replay with a trailing newline (e.g. edited by hand) still loads
        love.filesystem.write("replays/newline.sav", table.concat(uno.replay, ";") .. "\n")
        Game.filedropped(love.filesystem.newFile("replays/newline.sav"))
        check(common.snapshot(uno).last == before.last, "replay with trailing newline did not play")

        love.filesystem.remove("replays/bad.sav")
        love.filesystem.remove("replays/newline.sav")
        love.filesystem.remove("replays/dropped.sav")
        love.filesystem.remove("UnoCard.stat")
        print(failures == 0 and "ALL PASSED" or (failures .. " FAILURE(S)"))
        io.stdout:flush()
        love.event.quit(failures == 0 and 0 or 1)
    end)
end

return M
