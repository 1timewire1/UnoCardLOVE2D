-- Uno Card Game for LOVE2D
--
-- Lua port of "UnoCard" by Hikari Toyama (Apache License 2.0).
-- Original: https://github.com/shiawasenahikari/UnoCard
--
-- Game UI and game flow (the port of main.cpp).
--
-- How the port maps to the Qt original:
--   * The original paints into a retained 1600x900 image (sScreen) with
--     partial, area-masked repaints, and shows it stretched over the window.
--     Here sScreen is a Canvas that is painted the same way by refreshScreen()
--     and shown letterboxed. Partial repaints matter: the game relies on
--     regions that are deliberately NOT repainted.
--   * The original blocks inside threadWait() with a nested event loop. Here
--     every click starts a coroutine ("flow"), and threadWait()/animate()
--     yield to love.update(). Clicks are ignored while a flow is running,
--     which is what the original's STAT_IDLE status does.
--   * Hand card indices are 1-based (see uno.lua); sSelectedIdx == 0 means
--     "no selection" (it was -1). Drawing code still uses 0-based positions
--     internally, because the layout formulas depend on it.

local bit = require("bit")
local utf8 = require("utf8")

local D = require("src.defs")
local Uno = require("src.uno")
local AI = require("src.ai")
local I18N = require("src.i18n")

local NONE, RED, BLUE, GREEN, YELLOW = D.NONE, D.RED, D.BLUE, D.GREEN, D.YELLOW
local NUM0, NUM7, DRAW2, REV, SKIP, WILD, WILD_DRAW4 =
    D.NUM0, D.NUM7, D.DRAW2, D.REV, D.SKIP, D.WILD, D.WILD_DRAW4
local YOU, COM1, COM2, COM3 = D.YOU, D.COM1, D.COM2, D.COM3

local band, lshift, rshift = bit.band, bit.lshift, bit.rshift

local Game = {}

--------------------------------------------------------------------------------
-- Constants
--------------------------------------------------------------------------------

local STAT_IDLE = 0x1111
local STAT_WELCOME = 0x2222
local STAT_NEW_GAME = 0x3333
local STAT_GAME_OVER = 0x4444
local STAT_WILD_COLOR = 0x5555
local STAT_DOUBT_WILD4 = 0x6666
local STAT_SEVEN_TARGET = 0x7777
local STAT_ASK_KEEP_PLAY = 0x8888
local STAT_PICK_REPLAY = 0x9999 -- (new: replaces the original's file dialog)

local SCREEN_W, SCREEN_H = 1600, 900
local SETTINGS_FILE = "UnoCard.stat"
local MAX_REPLAY_ROWS = 8

local function rgb(r, g, b)
    return { r / 255, g / 255, b / 255, 1 }
end

local BRUSH = {
    [RED] = rgb(0xFF, 0x55, 0x55),
    [BLUE] = rgb(0x55, 0x55, 0xFF),
    [GREEN] = rgb(0x55, 0xAA, 0x55),
    [YELLOW] = rgb(0xFF, 0xAA, 0x11),
}

-- Text colors selected by the [R] [B] [G] [W] [Y] marks
local PEN = {
    R = rgb(0xFF, 0x77, 0x77),
    B = rgb(0x77, 0x77, 0xFF),
    G = rgb(0x77, 0xCC, 0x77),
    W = rgb(0xCC, 0xCC, 0xCC),
    Y = rgb(0xFF, 0xCC, 0x11),
}

-- Where hidden hands are (for swapping / rotating animations)
local POS_X = { [0] = 740, 160, 740, 1320 }
local POS_Y = { [0] = 670, 360, 50, 360 }

--------------------------------------------------------------------------------
-- Global variables (the s* naming follows the original)
--------------------------------------------------------------------------------

local sAI, sUno, i18n, sLang
local sAuto = false
local sStatus = STAT_IDLE
local sWinner = YOU
local sHideFlag = 0x00
local sSpeed = 1
local sGameSaved = false
local sSelectedIdx = 0
local sScore, sDiff = 0, 0
local sAdjustOptions = false
local sSndEnabled = true
local sBgmVolume = 50 -- 0 ~ 100
local sReplayList = {}

local screen -- the Canvas that is sScreen in the original
local font, fontBaseline
local sounds = {}
local bgm

local flow -- the running coroutine, if any (see runFlow)
local anim -- the animation in progress, if any (see animate)
local fastForward = false -- tests: skip all waits & animations
local testHook -- tests: called at every step of setStatus

--------------------------------------------------------------------------------
-- Small helpers
--------------------------------------------------------------------------------

--- C-style integer division (truncates toward zero).
local function idiv(a, b)
    if (a >= 0) == (b >= 0) then
        return math.floor(a / b)
    end

    return -math.floor(-a / b)
end

local function clamp(v, lo, hi)
    return math.max(lo, math.min(hi, v))
end

--- The flag bit of a player (1 << id), for hide flags & refresh areas.
local function bitOf(player)
    return lshift(1, player)
end

local function playSound(name)
    local s = sounds[name]

    if sSndEnabled and s then
        s:stop()
        s:play()
    end
end

local function setBgmVolume(v)
    sBgmVolume = v
    if bgm then
        bgm:setVolume(v / 100)
    end
end

-- Forward declarations (the flow functions call each other)
local setStatus, doDraw, doPlay, requestAI, onChallenge, swapWith, cycle
local refreshScreen

--------------------------------------------------------------------------------
-- Flows (coroutines) and waiting
--------------------------------------------------------------------------------

local function resumeFlow(dt)
    if flow then
        local ok, err = coroutine.resume(flow, dt)

        if not ok then
            error(debug.traceback(flow, tostring(err)), 0)
        end

        if coroutine.status(flow) == "dead" then
            flow = nil
        end
    end
end

--- Run fn as a flow. It runs until its first wait, and continues in update().
local function runFlow(fn)
    flow = coroutine.create(fn)
    resumeFlow(0)
end

--- Let our UI wait the number of specified milli seconds.
-- (Must be called inside a flow.)
local function threadWait(millis)
    if fastForward then
        return
    end

    local remaining = millis / 1000 / sSpeed

    while remaining > 0 do
        remaining = remaining - coroutine.yield()
    end
end

--- Do uniform motion for objects from somewhere to somewhere. The layers are
-- drawn over sScreen by Game.draw() while this function waits. After the
-- animation, you need to call refreshScreen() to draw the last frame.
--
-- @param layers Array of {elem, startLeft, startTop, endLeft, endTop}.
local function animate(layers)
    if fastForward then
        return
    end

    local duration = 0.22 / sSpeed
    local t = 0

    while t < duration do
        anim = { layers = layers, progress = t / duration }
        t = t + coroutine.yield()
    end

    anim = nil
end

--------------------------------------------------------------------------------
-- Text rendering
--------------------------------------------------------------------------------

local function splitChars(text)
    local chars = {}

    for _, cp in utf8.codes(text) do
        chars[#chars + 1] = utf8.char(cp)
    end

    return chars
end

--- The original uses a monospaced font: 17 pixels for ASCII characters and
-- 33 pixels for anything else. Text is laid out character by character.
local function charAdvance(ch)
    local b = ch:byte(1)

    return 32 <= b and b <= 126 and 17 or 33
end

--- Measure the text width, using our custom font.
-- SPECIAL: In the text string, you can use color marks ([R], [B], [G], [W] and
-- [Y]) to control the color of the remaining text. COLOR MARKS SHOULD NOT BE
-- TREATED AS PRINTABLE CHARACTERS.
local function getTextWidth(text)
    local chars = splitChars(text)
    local n, width, i = #chars, 0, 1

    while i <= n do
        if chars[i] == "[" and i + 2 <= n and chars[i + 2] == "]" then
            i = i + 3
        else
            width = width + charAdvance(chars[i])
            i = i + 1
        end
    end

    return width
end

--- Put text on sScreen, using our custom font. (x, y) is the left end of the
-- text's baseline. Color marks are supported, see getTextWidth().
local function putText(text, x, y)
    local chars = splitChars(text)
    local n, i = #chars, 1
    local pen = PEN.W

    while i <= n do
        local ch = chars[i]

        if ch == "[" and i + 2 <= n and chars[i + 2] == "]" then
            pen = PEN[chars[i + 1]] or pen
            i = i + 3
        else
            love.graphics.setColor(pen)
            love.graphics.print(ch, x, y - fontBaseline)
            x = x + charAdvance(ch)
            i = i + 1
        end
    end

    love.graphics.setColor(1, 1, 1, 1)
end

--- Draw an image on sScreen.
local function drawImage(image, x, y)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(image, x, y)
end

-- Quads for drawRegion(), cached per image: quads[image][x .. "," .. y ...]
local quads = setmetatable({}, { __mode = "k" })

--- Copy a region of an image (of the same position and size) onto sScreen.
local function drawRegion(image, x, y, w, h)
    local cache = quads[image]

    if not cache then
        cache = {}
        quads[image] = cache
    end

    local key = x .. "," .. y .. "," .. w .. "," .. h
    local quad = cache[key]

    if not quad then
        quad = love.graphics.newQuad(x, y, w, h, image:getDimensions())
        cache[key] = quad
    end

    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(image, quad, x, y)
end

--- Fill a pie in the middle of the screen. The angles are Qt's: in degrees,
-- 0 is at 3 o'clock, positive angles are counter-clockwise.
local function drawPie(color, startDeg, spanDeg)
    -- LOVE measures angles clockwise on screen
    local a1, a2 = -math.rad(startDeg), -math.rad(startDeg + spanDeg)

    if a1 > a2 then
        a1, a2 = a2, a1
    end

    love.graphics.setColor(color)
    love.graphics.arc("fill", "pie", 405.5, 405.5, 135.5, a1, a2, 96)
    love.graphics.setColor(1, 1, 1, 1)
end

--------------------------------------------------------------------------------
-- Screen
--------------------------------------------------------------------------------

--- The 0-based position of a hand card (i = 0 ~ size - 1), for the layout of
-- the west (COM1) and east (COM3) hands, and the north / your hand.
local function westPos(i, size)
    local width = 44 * math.min(size, 13) + 136

    return 20 + idiv(i, 13) * 44, 450 - idiv(width, 2) + i % 13 * 44
end

local function eastPos(i, size)
    local width = 44 * math.min(size, 13) + 136

    return i < 13 and 1460 or 1416, 450 - idiv(width, 2) + (i < 13 and i or i - 13) * 44
end

local function rowPos(i, size)
    local width = 44 * size + 76

    return 800 - idiv(width, 2) + 44 * i
end

local function drawWin(cx, y)
    putText("[G]WIN", cx - idiv(getTextWidth("WIN"), 2), y)
end

--- Refresh the screen display. The content of sScreen will be changed after
-- calling this function.
--
-- @param message Extra message to show.
-- @param area    Refresh which area. Use bit or to select multiple areas.
--                0x01 = Your hand card area
--                0x02 = WEST's hand card area
--                0x04 = NORTH's hand card area
--                0x08 = EAST's hand card area
--                0x10 = (Reversed bit, not used yet)
--                0x20 = Left-bottom & Right-bottom corner
--                0x40 = Center deck area
--                0x80 = Recent card area
--                0xff = Full screen (default)
function refreshScreen(message, area)
    message = message or ""
    area = band(area or 0xff, 0xff)

    -- Lock the value of global variable [sStatus]
    local status = sStatus
    local bg = sUno:getBackground()
    local width, info

    love.graphics.setCanvas(screen)
    love.graphics.setFont(font)
    love.graphics.setColor(1, 1, 1, 1)

    -- Clear
    if area == 0xff then
        drawImage(bg, 0, 0)
    else
        drawRegion(bg, 200, 584, 1200, 48)
    end

    -- Message area
    width = getTextWidth(message)
    putText(message, 800 - idiv(width, 2), 620)

    -- Left-bottom & Right-bottom corner
    if band(area, 0x20) ~= 0 then
        if area ~= 0xff then
            drawRegion(bg, 20, 844, 170, 48)
            drawRegion(bg, 1427, 844, 153, 48)
        end

        -- Left-bottom corner: <OPTIONS> button
        -- Shows only when game is not in process
        if status == YOU or status == STAT_WELCOME or status == STAT_GAME_OVER then
            putText(i18n.btn_settings(sAdjustOptions), 20, 880)
        elseif status == STAT_PICK_REPLAY then
            putText(i18n.btn_back(), 20, 880)
        end

        -- Right-bottom corner: <AUTO> / <LOAD> / <SAVE> (or <LANG> in options)
        if sAdjustOptions then
            info = i18n.btn_lang()
            putText(info, 1580 - getTextWidth(info), 880)
        elseif status == YOU and not sAuto then
            info = i18n.btn_auto()
            putText(info, 1580 - getTextWidth(info), 880)
        elseif status == STAT_WELCOME then
            info = i18n.btn_load()
            putText(info, 1580 - getTextWidth(info), 880)
        elseif status == STAT_GAME_OVER and not sGameSaved then
            info = i18n.btn_save()
            putText(info, 1580 - getTextWidth(info), 880)
        end
    end

    if sAdjustOptions then
        -- Show special screen when configuring game options
        -- BGM switch
        info = i18n.label_bgm()
        putText(info, 268 - idiv(getTextWidth(info), 2), 60)
        local rev = sUno:findCard(GREEN, REV)
        drawImage(sBgmVolume > 0 and rev.image or rev.darkImg, 208, 80)

        -- Sound effect switch
        info = i18n.label_snd()
        putText(info, 670 - idiv(getTextWidth(info), 2), 60)
        rev = sUno:findCard(BLUE, REV)
        drawImage(sSndEnabled and rev.image or rev.darkImg, 610, 80)

        -- Speed
        info = i18n.label_speed()
        putText(info, 1202 - idiv(getTextWidth(info), 2), 60)
        local c1, c2, c3 = sUno:findCard(RED, D.NUM1), sUno:findCard(YELLOW, D.NUM2), sUno:findCard(GREEN, D.NUM3)
        drawImage(sSpeed < 2 and c1.image or c1.darkImg, 1012, 80)
        drawImage(sSpeed == 2 and c2.image or c2.darkImg, 1142, 80)
        drawImage(sSpeed > 2 and c3.image or c3.darkImg, 1272, 80)

        if status ~= YOU then
            -- [Level] option: easy / hard
            info = i18n.label_level(sUno:getDifficulty())
            putText(i18n.label_leftArrow(), 208, 690)
            putText(info, 456 - idiv(getTextWidth(info), 2), 690)
            putText(i18n.label_rightArrow(), 638, 690)

            -- Rule settings
            -- Initial cards
            info = i18n.label_initialCards(sUno:getInitialCards())
            putText(i18n.label_leftArrow(), 896, 690)
            putText(info, 1144 - idiv(getTextWidth(info), 2), 690)
            putText(i18n.label_rightArrow(), 1326, 690)

            -- Game Mode
            info = i18n.label_gameMode(sUno:getGameMode())
            putText(i18n.label_leftArrow(), 208, 760)
            putText(info, 456 - idiv(getTextWidth(info), 2), 760)
            putText(i18n.label_rightArrow(), 638, 760)

            -- Stacking
            info = i18n.label_stackRule(sUno:getStackRule())
            putText(i18n.label_leftArrow(), 896, 760)
            putText(info, 1144 - idiv(getTextWidth(info), 2), 760)
            putText(i18n.label_rightArrow(), 1326, 760)

            -- Force play switch
            local rule = sUno:getForcePlayRule()
            putText(i18n.label_forcePlay(), 208, 830)
            putText(i18n.btn_keep(rule == 0), 896, 830)
            putText(i18n.btn_ask(rule == 1), 1110, 830)
            putText(i18n.btn_play(rule == 2), 1290, 830)
        end
    elseif status == STAT_PICK_REPLAY then
        -- Replay picker (replaces the original's file dialog)
        for k = 1, math.min(#sReplayList, MAX_REPLAY_ROWS) do
            info = sReplayList[k].label
            putText(info, 800 - idiv(getTextWidth(info), 2), 150 + 50 * k)
        end
    elseif status == STAT_WELCOME then
        -- For welcome screen, show the start button and your score
        drawImage(sUno:getBackImage(), 740, 360)
        info = i18n.label_score()
        putText(info, 500 - getTextWidth(info), 800)
        if sScore < 0 then
            drawImage(sUno:getColoredWildImage(NONE), 520, 700)
        else
            drawImage(sUno:findCard(RED, idiv(sScore, 1000)).image, 520, 700)
        end

        drawImage(sUno:findCard(BLUE, math.abs(math.fmod(idiv(sScore, 100), 10))).image, 660, 700)
        drawImage(sUno:findCard(GREEN, math.abs(math.fmod(idiv(sScore, 10), 10))).image, 800, 700)
        drawImage(sUno:findCard(YELLOW, math.abs(math.fmod(sScore, 10))).image, 940, 700)
    else
        -- Center: card deck & recent played card
        if band(area, 0x40) ~= 0 then
            if area ~= 0xff then
                drawRegion(bg, 270, 270, 271, 271)
            end

            drawImage(sUno:getBackImage(), 338, 360)
        end

        if band(area, 0x80) ~= 0 then
            local recent = sUno:getRecentInfo()
            local x = 986

            for i = 0, 3 do
                local r = recent[i]

                if r.card ~= nil then
                    local image

                    if r.card.content == WILD then
                        image = sUno:getColoredWildImage(r.color)
                    elseif r.card.content == WILD_DRAW4 then
                        image = sUno:getColoredWildDraw4Image(r.color)
                    else
                        image = r.card.image
                    end

                    drawImage(image, x, 360)
                end

                x = x + 44
            end
        end

        -- Left-top corner: remain / used
        if area ~= 0xff then
            drawRegion(bg, 20, 6, 170, 48)
        end

        putText(i18n.label_remain_used(sUno:getDeckCount(), sUno:getUsedCount()), 20, 42)

        -- Right-top corner: lacks
        if area ~= 0xff then
            drawRegion(bg, 1427, 6, 153, 48)
        end

        info = i18n.label_lacks(
            sUno:getPlayer(COM2):getWeakColor(),
            sUno:getPlayer(COM3):getWeakColor(),
            sUno:getPlayer(COM1):getWeakColor(),
            sUno:getPlayer(YOU):getWeakColor())
        putText(info, 1580 - getTextWidth(info), 42)

        -- Left-center: Hand cards of Player West (COM1)
        if band(area, 0x02) ~= 0 then
            if area ~= 0xff then
                drawRegion(bg, 20, 96, 165, 709)
            end

            if status == STAT_GAME_OVER and sWinner == COM1 then
                -- Played all hand cards, it's winner
                drawWin(80, 461)
            elseif band(rshift(sHideFlag, 1), 0x01) == 0x00 then
                local p = sUno:getPlayer(COM1)
                local hand = p:getHandCards()
                local size = #hand

                for i = 0, size - 1 do
                    local x, y = westPos(i, size)

                    drawImage(p:isOpen(i + 1) and hand[i + 1].image or sUno:getBackImage(), x, y)
                end

                if size == 1 then
                    -- Show "UNO" warning when only one card in hand
                    putText("[Y]UNO", 80 - idiv(getTextWidth("UNO"), 2), 584)
                end
            end
        end

        -- Top-center: Hand cards of Player North (COM2)
        if band(area, 0x04) ~= 0 then
            if area ~= 0xff then
                drawRegion(bg, 190, 20, 1221, 181)
            end

            if status == STAT_GAME_OVER and sWinner == COM2 then
                drawWin(800, 121)
            elseif band(rshift(sHideFlag, 2), 0x01) == 0x00 then
                local p = sUno:getPlayer(COM2)
                local hand = p:getHandCards()
                local size = #hand

                for i = 0, size - 1 do
                    drawImage(p:isOpen(i + 1) and hand[i + 1].image or sUno:getBackImage(), rowPos(i, size), 20)
                end

                if size == 1 then
                    putText("[Y]UNO", 720 - getTextWidth("UNO"), 121)
                end
            end
        end

        -- Right-center: Hand cards of Player East (COM3)
        if band(area, 0x08) ~= 0 then
            if area ~= 0xff then
                drawRegion(bg, 1416, 96, 165, 709)
            end

            if status == STAT_GAME_OVER and sWinner == COM3 then
                drawWin(1520, 461)
            elseif band(rshift(sHideFlag, 3), 0x01) == 0x00 then
                local p = sUno:getPlayer(COM3)
                local hand = p:getHandCards()
                local size = #hand

                -- The second column (i >= 13) is drawn first, under the first
                for i = 13, size - 1 do
                    local x, y = eastPos(i, size)

                    drawImage(p:isOpen(i + 1) and hand[i + 1].image or sUno:getBackImage(), x, y)
                end

                for i = 0, math.min(size, 13) - 1 do
                    local x, y = eastPos(i, size)

                    drawImage(p:isOpen(i + 1) and hand[i + 1].image or sUno:getBackImage(), x, y)
                end

                if size == 1 then
                    putText("[Y]UNO", 1520 - idiv(getTextWidth("UNO"), 2), 584)
                end
            end
        end

        -- Bottom: Your hand cards
        if band(area, 0x01) ~= 0 then
            if area ~= 0xff then
                drawRegion(bg, 190, 680, 1221, 201)
            end

            if status == STAT_GAME_OVER and sWinner == YOU then
                drawWin(800, 801)
            elseif band(sHideFlag, 0x01) == 0x00 then
                -- Show your all hand cards
                local hand = sUno:getHandCardsOf(YOU)
                local size = #hand

                for i = 0, size - 1 do
                    local card = hand[i + 1]
                    local lit = status == STAT_GAME_OVER
                        or (status == YOU and sUno:isLegalToPlay(card))
                        or (status == STAT_ASK_KEEP_PLAY and i + 1 == sSelectedIdx)

                    drawImage(lit and card.image or card.darkImg, rowPos(i, size), i + 1 == sSelectedIdx and 680 or 700)
                end

                if size == 1 then
                    putText("[Y]UNO", 880, 801)
                end
            end
        end

        -- Extra sectors in special status
        if status == STAT_WILD_COLOR then
            -- Need to specify the following legal color after played a
            -- wild card. Draw color sectors in the center of screen
            drawPie(BRUSH[BLUE], 0, 90)
            drawPie(BRUSH[GREEN], 0, -90)
            drawPie(BRUSH[RED], 180, -90)
            drawPie(BRUSH[YELLOW], 180, 90)
        elseif status == STAT_DOUBT_WILD4 or status == STAT_ASK_KEEP_PLAY then
            -- Ask whether you want to challenge your previous player
            -- Draw YES button
            drawPie(BRUSH[GREEN], 0, 180)
            info = i18n.label_yes()
            putText(info, 405 - idiv(getTextWidth(info), 2), 358)

            -- Draw NO button
            drawPie(BRUSH[RED], 0, -180)
            info = i18n.label_no()
            putText(info, 405 - idiv(getTextWidth(info), 2), 472)
        elseif status == STAT_SEVEN_TARGET then
            -- Ask the target you want to swap hand cards with
            -- Draw west sector (red)
            drawPie(BRUSH[RED], -90, -120)
            putText("W", 338 - idiv(getTextWidth("W"), 2), 440)

            -- Draw east sector (green)
            drawPie(BRUSH[GREEN], -90, 120)
            putText("E", 472 - idiv(getTextWidth("E"), 2), 440)

            -- Draw north sector (yellow)
            drawPie(BRUSH[YELLOW], 150, -120)
            putText("N", 405 - idiv(getTextWidth("N"), 2), 360)
        end
    end

    love.graphics.setCanvas()
end

--------------------------------------------------------------------------------
-- Game flow
--------------------------------------------------------------------------------

--- Change the value of global variable [sStatus] and do the following
-- operations when necessary.
-- @param status New status value.
function setStatus(status)
    repeat
        sStatus = status
        if testHook then
            testHook(status)
        end

        if status == STAT_WELCOME then
            refreshScreen(sAdjustOptions and i18n.info_ruleSettings() or i18n.info_welcome())
        elseif status == STAT_NEW_GAME then
            -- New game
            sStatus = STAT_IDLE -- block mouse click events when idle

            -- You will lose 200 points if you quit during the game
            sScore = sScore - 200
            sUno:start()
            sSelectedIdx = 0
            refreshScreen(i18n.info_ready())
            threadWait(2000)

            local content = sUno:getRecentInfo()[3].card.content

            if content == DRAW2 then
                -- If starting with a [+2], let dealer draw 2 cards.
                status = doDraw(2, true)
            elseif content == SKIP then
                -- If starting with a [skip], skip dealer's turn.
                refreshScreen(i18n.info_skipped(sUno:getNow()), 0x00)
                threadWait(1500)
                status = sUno:switchNow()
            elseif content == REV then
                -- If starting with a [reverse], change the action
                -- sequence to COUNTER CLOCKWISE.
                sUno:switchDirection()
                refreshScreen(i18n.info_dirChanged())
                threadWait(1500)
                status = sUno:getNow()
            else
                -- Otherwise, go to dealer's turn.
                status = sUno:getNow()
            end
        elseif status == YOU then
            -- Your turn, select a hand card to play, or draw a card
            if sAuto then
                status = requestAI()
            elseif sAdjustOptions then
                refreshScreen()
            elseif sUno:legalCardsCount4NowPlayer() == 0 then
                status = doDraw()
            elseif #sUno:getHandCardsOf(YOU) == 1 then
                status = doPlay(1)
            elseif sSelectedIdx < 1 then
                local c = sUno:getDraw2StackCount()

                refreshScreen(c == 0 and i18n.info_yourTurn()
                    or sUno:getStackRule() ~= 2 and i18n.info_yourTurn_stackDraw2(c)
                    or i18n.info_yourTurn_stackDraw2(c, 2))
            else
                local card = sUno:getHandCardsOf(YOU)[sSelectedIdx]

                refreshScreen(sUno:isLegalToPlay(card)
                    and i18n.info_clickAgainToPlay(card.name)
                    or i18n.info_cannotPlay(card.name))
            end
        elseif status == STAT_WILD_COLOR then
            -- Need to specify the following legal color after played a
            -- wild card. Draw color sectors in the center of screen
            refreshScreen(i18n.ask_color(), 0x21)
        elseif status == STAT_DOUBT_WILD4 then
            if sUno:getNext() == YOU and not sAuto then
                -- Challenge or not is decided by you
                refreshScreen(i18n.ask_challenge(sUno:next2lastColor()), 0x00)
            elseif sAI:needToChallenge() then
                -- Challenge or not is decided by AI
                status = onChallenge()
            else
                sUno:switchNow()
                status = doDraw(4, true)
            end
        elseif status == STAT_SEVEN_TARGET then
            -- In 7-0 rule, when someone put down a seven card, the player
            -- must swap hand cards with another player immediately.
            if sAuto or sUno:getNow() ~= YOU then
                -- Seven-card is played by AI. Select target automatically.
                status = swapWith(sAI:calcBestSwapTarget4NowPlayer())
            else
                -- Seven-card is played by you. Select target manually.
                refreshScreen(i18n.ask_target(), 0x00)
            end
        elseif status == STAT_ASK_KEEP_PLAY then
            if sAuto then
                status = doPlay(sSelectedIdx, sAI:calcBestColor4NowPlayer())
            else
                refreshScreen(i18n.ask_keep_play(), 0x01)
            end
        elseif status == COM1 or status == COM2 or status == COM3 then
            -- AI players' turn
            status = requestAI()
        elseif status == STAT_GAME_OVER then
            -- Game over
            refreshScreen(sAdjustOptions and i18n.info_ruleSettings() or i18n.info_gameOver(sScore, sDiff))
        end
    until sStatus == status
end

--- The unique AI entry point.
-- @return Next status value.
function requestAI()
    local idxBest, bestColor

    setStatus(STAT_IDLE) -- block mouse click events when idle
    if sUno:getDifficulty() == Uno.LV_EASY then
        idxBest, bestColor = sAI:easyAI_bestCardIndex4NowPlayer()
    elseif sUno:isSevenZeroRule() then
        idxBest, bestColor = sAI:sevenZeroAI_bestCardIndex4NowPlayer()
    elseif sUno:is2vs2() then
        idxBest, bestColor = sAI:teamAI_bestCardIndex4NowPlayer()
    else
        idxBest, bestColor = sAI:hardAI_bestCardIndex4NowPlayer()
    end

    if idxBest > 0 then
        -- Found an appropriate card to play
        return doPlay(idxBest, bestColor)
    end

    -- No appropriate cards to play, or no card to play
    return doDraw()
end

--- The player in action draw one or more cards.
-- @param count How many cards to draw.
-- @param force Pass true if the specified player is required to draw cards,
--              i.e. previous player played a [+2] or [wild +4] to let this
--              player draw cards. Or false if the specified player draws a
--              card by itself in its action.
-- @return Next status value.
function doDraw(count, force)
    count = count or 1
    force = force or false
    setStatus(STAT_IDLE) -- block mouse click events when idle

    local c = sUno:getDraw2StackCount()

    if c > 0 then
        count = c
        force = true
    end

    local index, drawn, message = 0, nil, nil
    local now = sUno:getNow()
    local flag = now == YOU and 0xff or lshift(1, now)

    sSelectedIdx = 0
    for _ = 1, count do
        index = sUno:draw(now, force)
        if index > 0 then
            local p = sUno:getCurrPlayer()
            local size = p:getHandSize()
            local i = index - 1 -- 0-based position
            local layer = { startLeft = 338, startTop = 360 }

            drawn = p:getHandCards()[index]
            if now == COM1 then
                layer.elem = sUno:getBackImage()
                layer.endLeft, layer.endTop = westPos(i, size)
                message = i18n.act_drawCardCount(now, count)
            elseif now == COM2 then
                layer.elem = sUno:getBackImage()
                layer.endLeft, layer.endTop = rowPos(i, size), 20
                message = i18n.act_drawCardCount(now, count)
            elseif now == COM3 then
                layer.elem = sUno:getBackImage()
                layer.endLeft = 1460 - idiv(i, 13) * 44
                layer.endTop = 450 - idiv(44 * math.min(size, 13) + 136, 2) + i % 13 * 44
                message = i18n.act_drawCardCount(now, count)
            else
                layer.elem = drawn.image
                layer.endLeft, layer.endTop = rowPos(i, size), 700
                message = i18n.act_drawCard(now, drawn.name)
            end

            playSound("draw")
            animate({ layer })
            refreshScreen(message, flag)
            threadWait(300)
        else
            message = i18n.info_cannotDraw(now, Uno.MAX_HOLD_CARDS)
            refreshScreen(message, flag)
            break
        end
    end

    threadWait(750)
    if count == 1 and drawn ~= nil and sUno:getForcePlayRule() ~= 0 and sUno:isLegalToPlay(drawn) then
        -- Player drew one card by itself, the drawn card
        -- can be played immediately if it's legal to play
        if sAuto or now ~= YOU then
            now = doPlay(index, sAI:calcBestColor4NowPlayer())
        elseif sUno:getForcePlayRule() == 1 then
            -- Store index value as global value. This value
            -- will be used after the wild color determined.
            sSelectedIdx = index
            now = STAT_ASK_KEEP_PLAY
        elseif not drawn:isWild() then
            -- Force play a non-wild card
            now = doPlay(index, drawn.color)
        elseif sUno:getStackRule() == 2 and drawn.content == WILD_DRAW4 then
            -- Force play a Wild +4 card, but do not change the next color
            now = doPlay(index, sUno:lastColor())
        else
            -- Force play a Wild / Wild +4 card, and change the next color
            sSelectedIdx = index
            now = STAT_WILD_COLOR
        end
    else
        refreshScreen(i18n.act_pass(now), 0x00)
        threadWait(750)
        now = sUno:switchNow()
    end

    return now
end

--- The player in action play a card.
-- @param index Play which card. Pass the corresponding card's index of the
--              player's hand cards.
-- @param color Optional, available when the card to play is a wild card.
--              Pass the specified following legal color.
-- @return Next status value.
function doPlay(index, color)
    color = color or NONE
    setStatus(STAT_IDLE) -- block mouse click events when idle

    local now = sUno:getNow()
    local size = sUno:getCurrPlayer():getHandSize()

    if sUno:getStackRule() == 2 and sUno:getCurrPlayer():getHandCards()[index].content == WILD_DRAW4 then
        color = sUno:lastColor()
    end

    local card = sUno:play(now, index, color)

    sSelectedIdx = 0
    playSound("play")
    if size == 2 then
        playSound("uno")
    end

    if card ~= nil then
        local i = index - 1 -- 0-based position
        local layer = { elem = card.image, endLeft = 1118, endTop = 360 }

        if now == COM1 then
            local width = 44 * math.min(size, 13) + 136

            layer.startLeft = 160 + idiv(i, 13) * 44
            layer.startTop = 450 - idiv(width, 2) + i % 13 * 44
        elseif now == COM2 then
            layer.startLeft = rowPos(i, size)
            layer.startTop = 50
        elseif now == COM3 then
            local width = 44 * math.min(size, 13) + 136

            layer.startLeft = 1320 - idiv(i, 13) * 44
            layer.startTop = 450 - idiv(width, 2) + i % 13 * 44
        else
            layer.startLeft = rowPos(i, size)
            layer.startTop = 680
        end

        animate({ layer })
        if size == 1 then
            -- The player in action becomes winner when it played the
            -- final card in its hand successfully
            if sUno:is2vs2() then
                if now == YOU or now == COM2 then
                    sDiff = 2 * (sUno:getPlayer(COM1):getHandScore() + sUno:getPlayer(COM3):getHandScore())
                    sScore = math.min(9999, 200 + sScore + sDiff)
                    playSound("win")
                else
                    sDiff = -2 * (sUno:getPlayer(YOU):getHandScore() + sUno:getPlayer(COM2):getHandScore())
                    sScore = math.max(-999, 200 + sScore + sDiff)
                    playSound("lose")
                end
            elseif now == YOU then
                sDiff = sUno:getPlayer(COM1):getHandScore()
                    + sUno:getPlayer(COM2):getHandScore()
                    + sUno:getPlayer(COM3):getHandScore()
                sScore = math.min(9999, 200 + sScore + sDiff)
                playSound("win")
            else
                sDiff = -sUno:getPlayer(YOU):getHandScore()
                sScore = math.max(-999, 200 + sScore + sDiff)
                playSound("lose")
            end

            sAuto = false -- Force disable the AUTO switch
            sWinner = now
            now = STAT_GAME_OVER
            Game.saveSettings() -- (the original saves when the window closes)
        else
            -- When the played card is an action card or a wild card,
            -- do the necessary things according to the game rule
            local flag = now == YOU and 0xe1 or bit.bor(bitOf(now), 0x80)
            local content = card.content
            local next

            if content == DRAW2 then
                next = sUno:switchNow()
                if sUno:getStackRule() ~= 0 then
                    refreshScreen(i18n.act_playDraw2(now, next, sUno:getDraw2StackCount()), flag)
                    threadWait(1500)
                    now = next
                else
                    refreshScreen(i18n.act_playDraw2(now, next, 2), flag)
                    threadWait(1500)
                    now = doDraw(2, true)
                end
            elseif content == SKIP then
                next = sUno:switchNow()
                refreshScreen(i18n.act_playSkip(now, next), flag)
                threadWait(1500)
                now = sUno:switchNow()
            elseif content == REV then
                sUno:switchDirection()
                refreshScreen(i18n.act_playRev(now))
                threadWait(1500)
                now = sUno:switchNow()
            elseif content == WILD then
                refreshScreen(i18n.act_playWild(now, color), flag)
                threadWait(1500)
                now = sUno:switchNow()
            elseif content == WILD_DRAW4 then
                if sUno:getStackRule() == 2 then
                    next = sUno:switchNow()
                    refreshScreen(i18n.act_playDraw2(now, next, sUno:getDraw2StackCount()), flag)
                    threadWait(1500)
                    now = next
                else
                    next = sUno:getNext()
                    refreshScreen(i18n.act_playWildDraw4(now, next), flag)
                    threadWait(1500)
                    now = STAT_DOUBT_WILD4
                end
            elseif content == NUM7 and sUno:isSevenZeroRule() then
                refreshScreen(i18n.act_playCard(now, card.name), flag)
                threadWait(750)
                now = STAT_SEVEN_TARGET
            elseif content == NUM0 and sUno:isSevenZeroRule() then
                refreshScreen(i18n.act_playCard(now, card.name), flag)
                threadWait(750)
                now = cycle()
            else
                refreshScreen(i18n.act_playCard(now, card.name), flag)
                threadWait(1500)
                now = sUno:switchNow()
            end
        end
    end

    return now
end

--- Triggered on challenge chance. When a player played a [wild +4], the next
-- player can challenge its legality. Only when you have no cards that match
-- the previous played card's color, you can play a [wild +4].
-- Next player does not challenge: next player draw 4 cards;
-- Challenge success: current player draw 4 cards;
-- Challenge failure: next player draw 6 cards.
-- @return Next status value.
function onChallenge()
    setStatus(STAT_IDLE) -- block mouse click events when idle

    local now = sUno:getNow()
    local challenger = sUno:getNext()
    local challengeSuccess = sUno:challenge(now)

    refreshScreen(i18n.info_challenge(challenger, now, sUno:next2lastColor()), bit.bor(bitOf(now), 0x40))
    threadWait(1500)
    if challengeSuccess then
        -- Challenge success, who played [wild +4] draws 4 cards
        refreshScreen(i18n.info_challengeSuccess(now), 0x00)
        threadWait(1500)
        now = doDraw(4, true)
    else
        -- Challenge failure, challenger draws 6 cards
        refreshScreen(i18n.info_challengeFailure(challenger), 0x00)
        threadWait(1500)
        sUno:switchNow()
        now = doDraw(6, true)
    end

    return now
end

--- The player in action swap hand cards with another player.
-- @param whom Swap with whom (0 ~ 3).
-- @return Next status value.
function swapWith(whom)
    setStatus(STAT_IDLE)

    local curr = sUno:getNow()
    local flag = bit.bor(bitOf(curr), bitOf(whom), curr == YOU and 0x40 or 0x00)
    local back = sUno:getBackImage()

    sHideFlag = bit.bor(bitOf(curr), bitOf(whom))
    refreshScreen(i18n.info_7_swap(curr, whom), flag)
    animate({
        { elem = back, startLeft = POS_X[curr], startTop = POS_Y[curr], endLeft = POS_X[whom], endTop = POS_Y[whom] },
        { elem = back, startLeft = POS_X[whom], startTop = POS_Y[whom], endLeft = POS_X[curr], endTop = POS_Y[curr] },
    })
    sHideFlag = 0x00
    sUno:swap(curr, whom)
    refreshScreen(i18n.info_7_swap(curr, whom), band(flag, bit.bnot(0x40)))
    threadWait(1500)
    return sUno:switchNow()
end

--- The hand cards travel one step along the players (used by 7-0 rule and
-- replays): a ring current -> next -> opposite (-> previous) -> current.
local function rotateLayers(curr, nxt, oppo, prev)
    local back = sUno:getBackImage()
    local ring = sUno:getPlayers() == 3 and { curr, nxt, oppo } or { curr, nxt, oppo, prev }
    local layers = {}

    for k = 1, #ring do
        local from, to = ring[k], ring[k % #ring + 1]

        layers[k] = { elem = back, startLeft = POS_X[from], startTop = POS_Y[from], endLeft = POS_X[to], endTop = POS_Y[to] }
    end

    return layers
end

--- In 7-0 rule, when a zero card is put down, everyone need to pass the hand
-- cards to the next player.
-- @return Next status value.
function cycle()
    setStatus(STAT_IDLE)
    sHideFlag = 0x0f
    refreshScreen(i18n.info_0_rotate(), 0x0f)
    animate(rotateLayers(sUno:getNow(), sUno:getNext(), sUno:getOppo(), sUno:getPrev()))
    sHideFlag = 0x00
    sUno:cycle()
    refreshScreen(i18n.info_0_rotate(), 0x0f)
    threadWait(1500)
    return sUno:switchNow()
end

--- Load & play a replay.
-- @param text Content of the replay file.
-- @param name Name of the replay file (for error messages).
local function loadReplay(text, name)
    if sUno:loadReplay(text) then
        setStatus(STAT_IDLE)
        while true do
            local cmd, a, b, c = sUno:forwardReplay()

            if cmd == "ST" then
                refreshScreen(i18n.info_ready())
                threadWait(1000)
            elseif cmd == "DR" then
                local h = sUno:getHandCardsOf(a)
                local card = sUno:findCardById(b)
                local i = 0 -- 0-based position of the drawn card in hand
                local size = #h
                local layer = { elem = card.image, startLeft = 338, startTop = 360 }

                for _, x in ipairs(h) do
                    if x.id < card.id then i = i + 1 else break end
                end

                if a == COM1 then
                    layer.endLeft, layer.endTop = westPos(i, size)
                elseif a == COM2 then
                    layer.endLeft, layer.endTop = rowPos(i, size), 20
                elseif a == COM3 then
                    layer.endLeft = 1460 - idiv(i, 13) * 44
                    layer.endTop = 450 - idiv(44 * math.min(size, 13) + 136, 2) + i % 13 * 44
                else
                    layer.endLeft, layer.endTop = rowPos(i, size), 700
                end

                -- Animation
                playSound("draw")
                animate({ layer })
                refreshScreen(i18n.act_drawCard(a, card.name))
                threadWait(300)
            elseif cmd == "PL" then
                local h = sUno:getHandCardsOf(a)
                local card = sUno:findCardById(b)
                local i = 0 -- 0-based position the played card had in hand
                local size = #h + 1
                local layer = { elem = card.image, endLeft = 1118, endTop = 360 }

                for _, x in ipairs(h) do
                    if x.id < card.id then i = i + 1 else break end
                end

                threadWait(750)
                playSound("play")
                if a == COM1 then
                    layer.startLeft = 160 + idiv(i, 13) * 44
                    layer.startTop = 450 - idiv(44 * math.min(size, 13) + 136, 2) + i % 13 * 44
                elseif a == COM2 then
                    layer.startLeft, layer.startTop = rowPos(i, size), 50
                elseif a == COM3 then
                    layer.startLeft = 1320 - idiv(i, 13) * 44
                    layer.startTop = 450 - idiv(44 * math.min(size, 13) + 136, 2) + i % 13 * 44
                else
                    layer.startLeft, layer.startTop = rowPos(i, size), 680
                end

                -- Animation
                animate({ layer })
                if size == 2 then
                    playSound("uno")
                end

                refreshScreen(i18n.act_playCard(a, card.name))
                threadWait(750)
            elseif cmd == "DF" then
                refreshScreen(i18n.info_cannotDraw(a, Uno.MAX_HOLD_CARDS))
                threadWait(750)
            elseif cmd == "CH" then
                threadWait(750)
                if sUno:challenge(a) then
                    refreshScreen(i18n.info_challengeSuccess(a))
                else
                    refreshScreen(i18n.info_challengeFailure(sUno:getNext()))
                end

                threadWait(750)
            elseif cmd == "SW" then
                local back = sUno:getBackImage()

                -- Animation
                sHideFlag = bit.bor(bitOf(a), bitOf(b))
                refreshScreen(i18n.info_7_swap(a, b))
                animate({
                    { elem = back, startLeft = POS_X[a], startTop = POS_Y[a], endLeft = POS_X[b], endTop = POS_Y[b] },
                    { elem = back, startLeft = POS_X[b], startTop = POS_Y[b], endLeft = POS_X[a], endTop = POS_Y[a] },
                })
                sHideFlag = 0x00
                refreshScreen(i18n.info_7_swap(a, b))
                threadWait(750)
            elseif cmd == "CY" then
                -- Animation
                sHideFlag = 0x0f
                refreshScreen(i18n.info_0_rotate())
                animate(rotateLayers(sUno:getNow(), sUno:getNext(), sUno:getOppo(), sUno:getPrev()))
                sHideFlag = 0x00
                refreshScreen(i18n.info_0_rotate())
                threadWait(750)
            else
                break
            end
        end

        local won = (sUno:is2vs2() and #sUno:getHandCardsOf(COM2) == 0) or #sUno:getHandCardsOf(YOU) == 0

        playSound(won and "win" or "lose")
        threadWait(3000)
        setStatus(STAT_WELCOME)
    else
        refreshScreen(i18n.info_loadFailed(name))
    end
end

--------------------------------------------------------------------------------
-- Input
--------------------------------------------------------------------------------

--- Play the replay that has been chosen (inside a flow).
local function playReplay(text, name)
    sAdjustOptions = false
    sStatus = STAT_WELCOME
    loadReplay(text, name)
end

--- Play the replay that has been dropped onto the window (outside any flow).
local function startReplay(text, name)
    runFlow(function() playReplay(text, name) end)
end

--- Collect the saved replays (newest first) for the picker.
local function listReplays()
    local list = {}

    for _, file in ipairs(love.filesystem.getDirectoryItems("replays")) do
        if file:match("%.sav$") then
            local ts = tonumber(file:match("^(%d+)%.sav$"))

            list[#list + 1] = {
                file = "replays/" .. file,
                name = file,
                ts = ts or 0,
                label = "[Y]" .. (ts and os.date("%Y-%m-%d  %H:%M:%S", ts) or file),
            }
        end
    end

    table.sort(list, function(x, y)
        return x.ts ~= y.ts and x.ts > y.ts or x.name > y.name
    end)

    return list
end

--- Triggered when a mouse press event occurred. Coordinates are in the
-- 1600x900 space of sScreen. (Runs inside a flow.)
local function onClick(x, y)
    if sStatus == STAT_PICK_REPLAY then
        -- Replay picker: pick a replay, or go back
        if 844 <= y and y <= 880 and 20 <= x and x <= 200 then
            setStatus(STAT_WELCOME)
        else
            for k = 1, math.min(#sReplayList, MAX_REPLAY_ROWS) do
                local base = 150 + 50 * k
                local half = idiv(getTextWidth(sReplayList[k].label), 2)

                if base - 36 <= y and y <= base + 8 and 800 - half <= x and x <= 800 + half then
                    local entry = sReplayList[k]
                    local text = love.filesystem.read(entry.file)

                    if text then
                        playReplay(text, entry.name)
                    else
                        setStatus(STAT_WELCOME)
                        refreshScreen(i18n.info_loadFailed(entry.name))
                    end

                    return
                end
            end
        end

        return
    end

    if 844 <= y and y <= 880 and 20 <= x and x <= 200 then
        -- <OPTIONS> button
        if sStatus == YOU or sStatus == STAT_WELCOME or sStatus == STAT_GAME_OVER then
            sAdjustOptions = not sAdjustOptions
            setStatus(sStatus)
        end
    elseif sAdjustOptions then
        -- Do special behaviors when configuring game options
        if 844 <= y and y <= 880 and 1450 <= x and x <= 1580 then
            -- <LANG> button (new)
            local nextLang = 1

            for k, code in ipairs(I18N.order) do
                if code == sLang then
                    nextLang = k % #I18N.order + 1
                end
            end

            sLang = I18N.order[nextLang]
            i18n = I18N[sLang]
            setStatus(sStatus)
        elseif 80 <= y and y <= 260 then
            if 208 <= x and x <= 328 then
                -- BGM switch
                setBgmVolume(sBgmVolume > 0 and 0 or 50)
                setStatus(sStatus)
            elseif 610 <= x and x <= 730 then
                -- SND switch
                sSndEnabled = not sSndEnabled
                if sSndEnabled then
                    playSound("play")
                end

                setStatus(sStatus)
            elseif 1012 <= x and x <= 1132 then
                -- Speed = 1
                sSpeed = 1
                setStatus(sStatus)
            elseif 1142 <= x and x <= 1262 then
                -- Speed = 2
                sSpeed = 2
                setStatus(sStatus)
            elseif 1272 <= x and x <= 1392 then
                -- Speed = 3
                sSpeed = 3
                setStatus(sStatus)
            end
        elseif 654 <= y and y <= 690 and sStatus ~= YOU then
            if 208 <= x and x <= 273 then
                -- Level EASY
                sUno:setDifficulty(Uno.LV_EASY)
                setStatus(sStatus)
            elseif 638 <= x and x <= 703 then
                -- Level HARD
                sUno:setDifficulty(Uno.LV_HARD)
                setStatus(sStatus)
            end

            if 896 <= x and x <= 961 then
                -- Decrease initial cards
                sUno:decreaseInitialCards()
                setStatus(sStatus)
            elseif 1326 <= x and x <= 1391 then
                -- Increase initial cards
                sUno:increaseInitialCards()
                setStatus(sStatus)
            end
        elseif 724 <= y and y <= 760 and sStatus ~= YOU then
            if 208 <= x and x <= 273 then
                -- Game mode, backward
                sUno:setGameMode(sUno:getGameMode() - 1)
                setStatus(sStatus)
            elseif 638 <= x and x <= 703 then
                -- Game mode, forward
                sUno:setGameMode(sUno:getGameMode() + 1)
                setStatus(sStatus)
            elseif 896 <= x and x <= 961 then
                -- Stacking, backward
                sUno:setStackRule(sUno:getStackRule() - 1)
                setStatus(sStatus)
            elseif 1326 <= x and x <= 1391 then
                -- Stacking, forward
                sUno:setStackRule(sUno:getStackRule() + 1)
                setStatus(sStatus)
            end
        elseif 794 <= y and y <= 830 and sStatus ~= YOU then
            if 896 <= x and x <= 997 then
                -- Force play, <KEEP> button
                sUno:setForcePlayRule(0)
                setStatus(sStatus)
            elseif 1110 <= x and x <= 1194 then
                -- Force play, <ASK> button
                sUno:setForcePlayRule(1)
                setStatus(sStatus)
            elseif 1290 <= x and x <= 1391 then
                -- Force play, <PLAY> button
                sUno:setForcePlayRule(2)
                setStatus(sStatus)
            end
        end
    elseif 844 <= y and y <= 880 and 1450 <= x and x <= 1580 then
        -- <AUTO> button
        -- In player's action, automatically play or draw cards by AI
        if sStatus == YOU and not sAuto then
            sAuto = true
            setStatus(sStatus)
        elseif sStatus == STAT_WELCOME then
            -- When in welcome screen, it's the <LOAD> button
            sReplayList = listReplays()
            sStatus = STAT_PICK_REPLAY
            refreshScreen(#sReplayList > 0 and i18n.info_pickReplay() or i18n.info_noReplays())
        elseif sStatus == STAT_GAME_OVER and not sGameSaved then
            -- When game over, it's the <SAVE> button
            local replayName = sUno:save()

            sGameSaved = replayName ~= ""
            refreshScreen(i18n.info_save(replayName), 0x20)
        end
    elseif sStatus == STAT_WELCOME then
        if 360 <= y and y <= 540 and 740 <= x and x <= 860 then
            -- UNO button, start a new game
            sGameSaved = false
            setStatus(STAT_NEW_GAME)
        end
    elseif sStatus == YOU then
        if sAuto then
            -- Do operations automatically by AI strategies
            return
        elseif 700 <= y and y <= 880 then
            local hand = sUno:getHandCardsOf(YOU)
            local size = #hand
            local width = 44 * size + 76
            local startX = 800 - idiv(width, 2)

            if startX <= x and x <= startX + width then
                -- Hand card area
                -- Calculate which card clicked by the X-coordinate
                local index = math.min(idiv(x - startX, 44), size - 1) + 1
                local card = hand[index]

                -- Try to play it
                if index ~= sSelectedIdx then
                    sSelectedIdx = index
                    setStatus(sStatus)
                elseif sUno:isLegalToPlay(card) then
                    if not card:isWild() or size < 2 then
                        setStatus(doPlay(index))
                    elseif sUno:getStackRule() ~= 2 or card.content ~= WILD_DRAW4 then
                        setStatus(STAT_WILD_COLOR)
                    else
                        setStatus(doPlay(index, sUno:lastColor()))
                    end
                end
            else
                -- Blank area, cancel your selection
                sSelectedIdx = 0
                setStatus(sStatus)
            end
        elseif 360 <= y and y <= 540 and 338 <= x and x <= 458 then
            -- Card deck area, draw a card
            setStatus(doDraw())
        end
    elseif sStatus == STAT_WILD_COLOR then
        if 310 < y and y < 405 then
            if 310 < x and x < 405 then
                -- Red sector
                setStatus(doPlay(sSelectedIdx, RED))
            elseif 405 < x and x < 500 then
                -- Blue sector
                setStatus(doPlay(sSelectedIdx, BLUE))
            end
        elseif 405 < y and y < 500 then
            if 310 < x and x < 405 then
                -- Yellow sector
                setStatus(doPlay(sSelectedIdx, YELLOW))
            elseif 405 < x and x < 500 then
                -- Green sector
                setStatus(doPlay(sSelectedIdx, GREEN))
            end
        end
    elseif sStatus == STAT_DOUBT_WILD4 then
        -- Asking if you want to challenge your previous player
        if 310 < x and x < 500 then
            if 310 < y and y < 405 then
                -- YES button, challenge wild +4
                setStatus(onChallenge())
            elseif 405 < y and y < 500 then
                -- NO button, do not challenge wild +4
                sUno:switchNow()
                setStatus(doDraw(4, true))
            end
        end
    elseif sStatus == STAT_ASK_KEEP_PLAY then
        --- Play the drawn card (choosing the color if it's a wild card)
        local function playDrawn()
            local hand = sUno:getHandCardsOf(YOU)
            local card = hand[sSelectedIdx]

            if not card:isWild() or #hand < 2 then
                setStatus(doPlay(sSelectedIdx, card.color))
            elseif sUno:getStackRule() ~= 2 or card.content ~= WILD_DRAW4 then
                setStatus(STAT_WILD_COLOR)
            else
                setStatus(doPlay(sSelectedIdx, sUno:lastColor()))
            end
        end

        if 310 < x and x < 500 and 405 < y and y < 500 then
            -- No button, keep the drawn card
            sSelectedIdx = 0
            setStatus(STAT_IDLE)
            refreshScreen(i18n.act_pass(YOU))
            threadWait(750)
            setStatus(sUno:switchNow())
        elseif 310 < x and x < 500 and 310 < y and y < 405 then
            -- YES button, play the drawn card
            playDrawn()
        elseif 700 <= y and y <= 880 then
            local size = #sUno:getHandCardsOf(YOU)
            local width = 44 * size + 76
            local startX = 800 - idiv(width, 2)
            local index = math.min(idiv(x - startX, 44), size - 1) + 1

            if startX <= x and x <= startX + width and index == sSelectedIdx then
                playDrawn()
            end
        end
    elseif sStatus == STAT_SEVEN_TARGET then
        if 288 < y and y < 366 and sUno:getPlayers() == 4 then
            if 338 < x and x < 472 then
                -- North sector
                setStatus(swapWith(COM2))
            end
        elseif 405 < y and y < 500 then
            if 310 < x and x < 405 then
                -- West sector
                setStatus(swapWith(COM1))
            elseif 405 < x and x < 500 then
                -- East sector
                setStatus(swapWith(COM3))
            end
        end
    elseif sStatus == STAT_GAME_OVER then
        if 360 <= y and y <= 540 and 338 <= x and x <= 458 then
            -- Card deck area, start a new game
            sGameSaved = false
            setStatus(STAT_NEW_GAME)
        end
    end
end

--- Convert window coordinates to the 1600x900 space.
local function toScreenSpace(mx, my)
    local w, h = love.graphics.getDimensions()
    local scale = math.min(w / SCREEN_W, h / SCREEN_H)
    local ox, oy = (w - SCREEN_W * scale) / 2, (h - SCREEN_H * scale) / 2
    local x, y = math.floor((mx - ox) / scale), math.floor((my - oy) / scale)

    if x < 0 or y < 0 or x >= SCREEN_W or y >= SCREEN_H then
        return nil
    end

    return x, y
end

--------------------------------------------------------------------------------
-- Settings (the original's UnoCard.stat file)
--------------------------------------------------------------------------------

function Game.saveSettings()
    if not sUno then
        return
    end

    local lines = {
        "score=" .. math.max(-999, sScore),
        "players=" .. sUno:getPlayers(),
        "difficulty=" .. sUno:getDifficulty(),
        "forcePlay=" .. sUno:getForcePlayRule(),
        "sevenZero=" .. (sUno:isSevenZeroRule() and 1 or 0),
        "stack=" .. sUno:getStackRule(),
        "snd=" .. (sSndEnabled and 1 or 0),
        "bgm=" .. sBgmVolume,
        "initialCards=" .. sUno:getInitialCards(),
        "twoVsTwo=" .. (sUno:is2vs2() and 1 or 0),
        "speed=" .. sSpeed,
        "lang=" .. sLang,
    }

    love.filesystem.write(SETTINGS_FILE, table.concat(lines, "\n") .. "\n")
end

local function loadSettings()
    local text = love.filesystem.read(SETTINGS_FILE)
    local t = {}

    if not text then
        return
    end

    for k, v in text:gmatch("([%w_]+)=([^\r\n]*)") do
        t[k] = v
    end

    local function int(key)
        local v = tonumber(t[key])

        return v and math.floor(v) or nil
    end

    -- Same order as the original, because the setters have side effects
    -- (e.g. enabling 7-0 rule switches to 4 players)
    if int("score") then sScore = clamp(int("score"), -999, 9999) end
    if int("players") then sUno:setPlayers(int("players")) end
    if int("difficulty") then sUno:setDifficulty(int("difficulty")) end
    if int("forcePlay") then sUno:setForcePlayRule(int("forcePlay")) end
    if int("sevenZero") then sUno:setSevenZeroRule(int("sevenZero") ~= 0) end
    if int("stack") then sUno:setStackRule(int("stack")) end
    if int("snd") then sSndEnabled = int("snd") ~= 0 end
    if int("bgm") then setBgmVolume(clamp(int("bgm"), 0, 100)) end
    if int("twoVsTwo") then sUno:set2vs2(int("twoVsTwo") ~= 0) end
    if int("speed") then sSpeed = int("speed") < 2 and 1 or int("speed") > 2 and 3 or 2 end
    if int("initialCards") and 5 <= int("initialCards") and int("initialCards") <= 20 then
        while sUno:getInitialCards() < int("initialCards") do sUno:increaseInitialCards() end
        while sUno:getInitialCards() > int("initialCards") do sUno:decreaseInitialCards() end
    end

    if I18N[t.lang or ""] then
        sLang = t.lang
    end
end

--------------------------------------------------------------------------------
-- LOVE callbacks
--------------------------------------------------------------------------------

--- Triggered when application starts.
-- Command line: love . [seed] [--lang=en|zh|ja]
function Game.load(args)
    local seed, langArg = 0, nil

    for _, a in ipairs(args or {}) do
        langArg = a:match("^%-%-lang=(%a+)$") or langArg
        seed = tonumber(a) or seed
    end

    love.graphics.setDefaultFilter("linear", "linear")
    font = love.graphics.newFont("resource/noto.ttc", 34)
    fontBaseline = font:getBaseline()
    if not pcall(function() screen = love.graphics.newCanvas(SCREEN_W, SCREEN_H, { msaa = 4 }) end) then
        screen = love.graphics.newCanvas(SCREEN_W, SCREEN_H)
    end

    -- Load the resources
    sUno = Uno.new({
        load = function(fileName)
            return love.graphics.newImage("resource/" .. fileName)
        end,
    }, math.floor(seed))
    sAI = AI.new(sUno)

    if pcall(function()
        for name, file in pairs({
            uno = "snd_uno.wav", win = "snd_win.wav", lose = "snd_lose.wav",
            draw = "snd_draw.wav", play = "snd_play.wav",
        }) do
            sounds[name] = love.audio.newSource("resource/" .. file, "static")
        end

        bgm = love.audio.newSource("resource/bgm.mp3", "stream")
        bgm:setLooping(true)
    end) then
        setBgmVolume(sBgmVolume)
    else
        sounds, bgm = {}, nil -- No audio device
    end

    sLang = "en"
    loadSettings()
    if langArg and I18N[langArg] then
        sLang = langArg
    end

    i18n = I18N[sLang]
    setBgmVolume(sBgmVolume)
    if bgm then
        bgm:play()
    end

    runFlow(function() setStatus(STAT_WELCOME) end)
end

function Game.update(dt)
    resumeFlow(math.min(dt, 0.1))
end

function Game.draw()
    local w, h = love.graphics.getDimensions()
    local scale = math.min(w / SCREEN_W, h / SCREEN_H)

    love.graphics.clear(0, 0, 0, 1)
    love.graphics.push()
    love.graphics.translate((w - SCREEN_W * scale) / 2, (h - SCREEN_H * scale) / 2)
    love.graphics.scale(scale)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(screen, 0, 0)
    if anim then
        for _, l in ipairs(anim.layers) do
            local p = anim.progress

            love.graphics.draw(l.elem, l.startLeft + (l.endLeft - l.startLeft) * p, l.startTop + (l.endTop - l.startTop) * p)
        end
    end

    love.graphics.pop()
end

function Game.mousepressed(mx, my, button)
    if button ~= 1 or flow then
        -- Only response to left-click events, and ignore the others.
        -- Also ignore clicks while a flow is in progress (STAT_IDLE).
        return
    end

    local x, y = toScreenSpace(mx, my)

    if x then
        runFlow(function() onClick(x, y) end)
    end
end

--- A .sav file was dropped onto the window: play it, on welcome screen.
function Game.filedropped(file)
    if flow or (sStatus ~= STAT_WELCOME and sStatus ~= STAT_PICK_REPLAY) or sAdjustOptions then
        return
    end

    local name = file:getFilename():match("([^/\\]+)$") or file:getFilename()
    local ok, text = pcall(function()
        file:open("r")
        local data = file:read()

        file:close()
        return data
    end)

    if ok and text then
        startReplay(text, name)
    else
        sStatus = STAT_WELCOME
        runFlow(function() refreshScreen(i18n.info_loadFailed(name)) end)
    end
end

function Game.keypressed(key)
    if key == "f11" or (key == "return" and love.keyboard.isDown("lalt", "ralt")) then
        love.window.setFullscreen(not love.window.getFullscreen(), "desktop")
    end
end

--- Triggered when application finishes.
function Game.quit()
    Game.saveSettings()
    return false
end

--------------------------------------------------------------------------------
-- Test support (see tests/)
--------------------------------------------------------------------------------

Game._test = {
    uno = function() return sUno end,
    ai = function() return sAI end,
    status = function() return sStatus end,
    score = function() return sScore end,
    busy = function() return flow ~= nil end,
    animating = function() return anim ~= nil end,
    setAuto = function(v) sAuto = v end,
    setFast = function(v) fastForward = v end,
    mute = function()
        sSndEnabled = false
        if bgm then bgm:stop() end
    end,
    setHook = function(fn) testHook = fn end,
    click = function(x, y) runFlow(function() onClick(x, y) end) end,
    startReplay = startReplay,
    setStatus = function(status) runFlow(function() setStatus(status) end) end,
    selected = function() return sSelectedIdx end,
    lang = function() return sLang end,
    speed = function() return sSpeed end,
    bgmVolume = function() return sBgmVolume end,
    sndEnabled = function() return sSndEnabled end,
    --- Show a status' screen without running its logic (for screenshots).
    render = function(status, message, selected)
        sStatus = status
        sSelectedIdx = selected or sSelectedIdx
        refreshScreen(message or "")
    end,
    constants = {
        STAT_IDLE = STAT_IDLE, STAT_WELCOME = STAT_WELCOME, STAT_NEW_GAME = STAT_NEW_GAME,
        STAT_GAME_OVER = STAT_GAME_OVER, STAT_WILD_COLOR = STAT_WILD_COLOR,
        STAT_DOUBT_WILD4 = STAT_DOUBT_WILD4, STAT_SEVEN_TARGET = STAT_SEVEN_TARGET,
        STAT_ASK_KEEP_PLAY = STAT_ASK_KEEP_PLAY, STAT_PICK_REPLAY = STAT_PICK_REPLAY,
    },
}

return Game
