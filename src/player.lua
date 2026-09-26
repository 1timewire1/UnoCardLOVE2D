-- Uno Card Game for LOVE2D
--
-- Lua port of "UnoCard" by Hikari Toyama (Apache License 2.0).
-- Original: https://github.com/shiawasenahikari/UnoCard

local D = require("src.defs")

--- Stores an Uno player's real-time information, such as hand cards and the
-- recent played card. Hand indices are 1-based.
local Player = {}
Player.__index = Player

Player.YOU, Player.COM1, Player.COM2, Player.COM3 = D.YOU, D.COM1, D.COM2, D.COM3

function Player.new()
    return setmetatable({
        -- Hand cards (array of Card).
        handCards = {},

        -- Visibility of the hand cards, parallel to handCards: open[i] is
        -- true when hand card i is known by you (the unique non-AI player).
        -- (The C++ original packs this into a bit mask.)
        open = {},

        -- Strong color. See getStrongColor().
        strongColor = D.NONE,

        -- Weak color. See getWeakColor().
        weakColor = D.NONE,

        -- Recent played card. nil if the player drew one or more cards in
        -- its last action.
        recent = nil,

        -- How many dangerous cards (cards in strong color) are in hand. THIS
        -- IS AN ESTIMATED VALUE, NOT A REAL VALUE! It is estimated from the
        -- player's actions, such as which color was selected when playing a
        -- wild card, and how many cards of that color were played after that.
        strongCount = 0,
    }, Player)
end

--- @return This player's all hand cards.
function Player:getHandCards()
    return self.handCards
end

--- Calculate the total score of this player's hand cards. According to the
-- official rule, Wild Cards are worth 50 points, Action Cards are worth 20
-- points, and Number Cards are worth points that equals to the number.
function Player:getHandScore()
    local score = 0

    for _, card in ipairs(self.handCards) do
        local c = card.content
        if c == D.WILD or c == D.WILD_DRAW4 then
            score = score + 50
        elseif c == D.REV or c == D.SKIP or c == D.DRAW2 then
            score = score + 20
        else
            score = score + c
        end
    end

    return score
end

--- @return How many cards in this player's hand.
function Player:getHandSize()
    return #self.handCards
end

--- When this player played a wild card, record the color specified, as this
-- player's strong color. The strong color will be remembered until this
-- player played a number of card matching that color. You can use this
-- value to defend this player's UNO dash.
-- @return This player's strong color, or D.NONE if unavailable.
function Player:getStrongColor()
    return self.strongColor
end

--- When this player draw a card in action, record the previous played card's
-- color, as this player's weak color. What this player did means that this
-- player probably do not have cards in that color. You can use this value
-- to defend this player's UNO dash.
-- @return This player's weak color, or D.NONE if unavailable.
function Player:getWeakColor()
    return self.weakColor
end

--- @return This player's recent played card, or nil if this player drew one
--         or more cards in its previous action.
function Player:getRecent()
    return self.recent
end

--- Check whether one of this player's hand cards is known by you, i.e. the
-- unique non-AI player. In 7-0 rule, when a seven or zero card is put down,
-- and your hand cards are transferred to someone else (for example, A), then
-- A's all hand cards are known by you.
-- @param index Index of the card to check (1 ~ #handCards).
function Player:isOpen(index)
    return self.open[index] == true
end

--- @return Whether ALL of this player's hand cards are known by you.
function Player:isAllOpen()
    for i = 1, #self.handCards do
        if not self.open[i] then
            return false
        end
    end

    return true
end

return Player
