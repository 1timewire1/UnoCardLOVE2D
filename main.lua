-- Uno Card Game for LOVE2D
--
-- Lua port of "UnoCard" by Hikari Toyama (Apache License 2.0).
-- Original: https://github.com/shiawasenahikari/UnoCard
--
-- Run with:  love .  [seed] [--lang=en|zh|ja]
-- (Developer option: --test=<name> runs tests/<name>.lua instead of playing.)

local Game = require("src.game")

function love.load(args)
    local gameArgs, testName = {}, nil

    for _, a in ipairs(args or {}) do
        local t = a:match("^%-%-test=([%w_]+)$")

        if t then
            testName = t
        else
            gameArgs[#gameArgs + 1] = a
        end
    end

    Game.load(gameArgs)
    if testName then
        -- Tests run with strict globals: an accidental global (a typo, or a
        -- local that was forgotten) raises an error instead of being nil.
        setmetatable(_G, {
            __newindex = function(_, k) error("assignment to undeclared global '" .. tostring(k) .. "'", 2) end,
            __index = function(_, k) error("read of undeclared global '" .. tostring(k) .. "'", 2) end,
        })

        require("tests." .. testName).run(Game)
    end
end

function love.update(dt)
    Game.update(dt)
end

function love.draw()
    Game.draw()
end

function love.mousepressed(x, y, button)
    Game.mousepressed(x, y, button)
end

function love.filedropped(file)
    Game.filedropped(file)
end

function love.keypressed(key)
    Game.keypressed(key)
end

function love.quit()
    return Game.quit()
end
