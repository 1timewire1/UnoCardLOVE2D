-- Uno Card Game for LOVE2D
--
-- Lua port of "UnoCard" by Hikari Toyama (Apache License 2.0).
-- Original: https://github.com/shiawasenahikari/UnoCard

function love.conf(t)
    -- Replays (replays/*.sav) and settings (UnoCard.stat) are stored in the
    -- LOVE save directory named after this identity.
    t.identity = "UnoCard"
    t.version = "11.0"
    t.console = false

    t.window.title = "UNO Card Game"
    t.window.icon = "resource/icon.png"
    t.window.width = 1280
    t.window.height = 720
    t.window.minwidth = 640
    t.window.minheight = 360
    t.window.resizable = true
    t.window.vsync = 1

    t.modules.joystick = false
    t.modules.physics = false
    t.modules.video = false
end
