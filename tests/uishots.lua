-- Screenshot driver.  Run with:   love . --test=uishots
--
-- Walks through the game's screens by simulating clicks, and saves PNGs to
-- the "UnoCard-test" save directory (shots/). Meant for eyeballing the UI.

local D = require("src.defs")

local M = {}

function M.run(Game)
    local T = Game._test
    local C = T.constants
    local uno = T.uno()

    love.filesystem.setIdentity("UnoCard-test")
    love.filesystem.createDirectory("shots")
    T.mute()
    T.setFast(true)
    love.window.setVSync(0)

    local function shot(name)
        local done = false

        coroutine.yield() -- let a frame be drawn with the current screen
        love.graphics.captureScreenshot(function(img)
            img:encode("png", "shots/" .. name .. ".png")
            done = true
        end)

        while not done do
            coroutine.yield()
        end
    end

    local function config(mode, initial)
        uno:setGameMode(mode)
        while uno:getInitialCards() < initial do uno:increaseInitialCards() end
        while uno:getInitialCards() > initial do uno:decreaseInitialCards() end
    end

    --- Click the position of hand card `index` (1-based) of your hand.
    local function clickHandCard(index)
        local size = #uno:getHandCardsOf(D.YOU)
        local startX = 800 - math.floor((44 * size + 76) / 2)

        T.click(startX + 44 * (index - 1) + 20, 790)
    end

    local co = coroutine.create(function()
        love.math.setRandomSeed(7)

        -- Welcome & options screens, in the three languages
        shot("01_welcome")
        T.click(100, 860)
        shot("02_options_en")
        T.click(1500, 860)
        shot("03_options_zh")
        T.click(1500, 860)
        shot("04_options_ja")
        T.click(1500, 860)
        T.click(100, 860)

        -- A 4-player game, waiting for your input
        config(4, 7)
        T.click(800, 450)
        shot("05_your_turn_status_" .. T.status())

        local hand = uno:getHandCardsOf(D.YOU)

        for i, card in ipairs(hand) do
            if uno:isLegalToPlay(card) then
                clickHandCard(i)
                break
            end
        end

        shot("06_card_selected")

        -- The pickers (their screens only; the status is not run)
        T.render(C.STAT_WILD_COLOR, "^ Specify the following legal color", 1)
        shot("07_wild_color")
        T.render(C.STAT_DOUBT_WILD4, "^ Do you think your previous player still has [R]RED?", 0)
        shot("08_doubt")
        T.render(C.STAT_ASK_KEEP_PLAY, "^ Play the drawn card?", 1)
        shot("09_ask_keep")
        T.render(C.STAT_SEVEN_TARGET, "^ Specify the target to swap hand cards with", 0)
        shot("10_seven_target")
        T.render(C.STAT_IDLE, "")
        T.setStatus(C.STAT_IDLE)

        -- A finished game (everyone is AI): game over screen, then save
        T.setStatus(C.STAT_WELCOME)
        T.setAuto(true)
        T.click(800, 450)
        shot("11_game_over")
        T.click(1500, 860)
        shot("12_replay_saved")

        -- Replay picker, then play the newest replay
        T.setStatus(C.STAT_WELCOME)
        T.click(1500, 860)
        shot("13_replay_picker")
        T.click(800, 200)
        shot("14_after_replay")

        -- 3 players, 20 initial cards: two columns for west & east
        config(3, 20)
        T.setAuto(false)
        T.click(800, 450)
        shot("15_three_players_20_cards")

        -- 7-0 rule game over (everyone's cards revealed)
        config(1, 7)
        T.setAuto(true)
        T.setStatus(C.STAT_WELCOME)
        T.click(800, 450)
        shot("16_seven_zero_game_over")

        love.event.quit(0)
    end)

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
