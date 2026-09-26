-- Real-time test.  Run with:   love . --test=realtime
--
-- Plays one whole game in real time (no fast-forward) with <AUTO> at speed 3,
-- to check the coroutine timing, the animations and the click blocking:
--   * a screenshot is taken while a card is flying (shots/rt_animation.png),
--   * a click while the game is busy must be ignored,
--   * the game must reach the game over screen in a sane time.

local common = require("tests.common")

local M = {}

function M.run(Game)
    local T = Game._test
    local C = T.constants
    local original = love.update
    local failures = 0

    love.filesystem.setIdentity("UnoCard-test")
    love.filesystem.createDirectory("shots")
    T.mute()
    love.window.setVSync(1)

    local function fail(msg)
        failures = failures + 1
        print("FAIL: " .. msg)
    end

    local co = coroutine.create(function()
        local function frames(n)
            for _ = 1, n do coroutine.yield() end
        end

        -- Speed 3 (in the options), back to the game
        T.click(100, 860)
        T.click(1330, 100)
        T.click(100, 860)
        love.math.setRandomSeed(3)
        T.setAuto(true)

        local uno = T.uno()

        uno:setGameMode(4)
        uno:setDifficulty(1)
        T.click(800, 450)
        frames(1)

        local t0 = love.timer.getTime()
        local shotDone, blockedChecked = false, false
        local moves = 0

        while T.status() ~= C.STAT_GAME_OVER do
            if love.timer.getTime() - t0 > 240 then
                fail("the game did not finish within 240 seconds")
                break
            end

            if T.animating() and not shotDone and love.timer.getTime() - t0 > 3 then
                shotDone = true
                love.graphics.captureScreenshot("shots/rt_animation.png")
            end

            if T.busy() and not blockedChecked and love.timer.getTime() - t0 > 1 then
                -- Click <SETTINGS> and the deck while the game is running:
                -- both must be ignored (the original's STAT_IDLE)
                blockedChecked = true
                local w, h = love.graphics.getDimensions()

                Game.mousepressed(w * 0.06, h * 0.955, 1)
                Game.mousepressed(w * 0.25, h * 0.5, 1)
                if not T.busy() then fail("busy flow was replaced by a click") end
            end

            moves = moves + 1
            coroutine.yield()
        end

        local elapsed = love.timer.getTime() - t0

        print(string.format("real-time game finished in %.1fs (%d frames)", elapsed, moves))
        if not shotDone then fail("no animation was ever seen") end
        if not blockedChecked then fail("click blocking was not checked") end
        if elapsed < 3 then fail("game ended suspiciously fast") end

        frames(3)
        print(failures == 0 and "ALL PASSED" or (failures .. " FAILURE(S)"))
        io.stdout:flush()
        love.event.quit(failures == 0 and 0 or 1)
    end)

    love.update = function(dt)
        original(dt) -- the game itself (runs the flows)
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
