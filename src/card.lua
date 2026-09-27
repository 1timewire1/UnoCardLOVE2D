-- Uno Card Game for LOVE2D
--
-- Lua port of "UnoCard" by Hikari Toyama (Apache License 2.0).
-- Original: https://github.com/shiawasenahikari/UnoCard

local D = require("src.defs")

--- Uno card. Instances are created by the Uno class only (one per card id).
local Card = {}
Card.__index = Card

-- Card names, indexed by (card id + 1). The "[R]"-style prefix is a color
-- mark understood by the text renderer (it tints the remaining text).
local NAMES = {
    "[R]0", "[R]1", "[R]2", "[R]3", "[R]4", "[R]5", "[R]6",
    "[R]7", "[R]8", "[R]9", "[R]+2", "[R]Reverse", "[R]Skip",
    "[B]0", "[B]1", "[B]2", "[B]3", "[B]4", "[B]5", "[B]6",
    "[B]7", "[B]8", "[B]9", "[B]+2", "[B]Reverse", "[B]Skip",
    "[G]0", "[G]1", "[G]2", "[G]3", "[G]4", "[G]5", "[G]6",
    "[G]7", "[G]8", "[G]9", "[G]+2", "[G]Reverse", "[G]Skip",
    "[Y]0", "[Y]1", "[Y]2", "[Y]3", "[Y]4", "[Y]5", "[Y]6",
    "[Y]7", "[Y]8", "[Y]9", "[Y]+2", "[Y]Reverse", "[Y]Skip",
    "Wild", "Wild +4", "Wild Swap Hands", "Wild Pass Hands",
    "[R]Swap 1", "[B]Swap 1", "[G]Swap 1", "[Y]Swap 1",
    "[R]Refresh Hand", "[B]Refresh Hand", "[G]Refresh Hand", "[Y]Refresh Hand",
}

--- Create a card.
-- Card id is: 39 + content for a wild card (color = NONE); or, for a
-- Swap 1 / Refresh Hand (content >= 17), 56 + (content - 17) * 4 +
-- (color - 1) - one id per color, tacked on after the wild-type ids since
-- contents 0-12 (the original 13-per-color slots) are all taken; or,
-- otherwise, 13 * (color - 1) + content. Cards are ordered (sorted in
-- hands) by this id.
-- @param image   Front image.
-- @param darkImg Dark (unplayable) image.
-- @param color   One of D.NONE / D.RED / D.BLUE / D.GREEN / D.YELLOW.
-- @param content One of D.NUM0 ... D.REFRESH_HAND.
function Card.new(image, darkImg, color, content)
    local id
    if color == D.NONE then
        id = 39 + content
    elseif content >= 17 then
        id = 56 + (content - 17) * 4 + (color - 1)
    else
        id = 13 * (color - 1) + content
    end

    return setmetatable({
        color = color,
        content = content,
        image = image,
        darkImg = darkImg,
        id = id,
        name = NAMES[id + 1],
    }, Card)
end

--- @return Whether the card is a [wild] or [wild +4].
function Card:isWild()
    return self.color == D.NONE
end

return Card
