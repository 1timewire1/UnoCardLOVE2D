-- Uno Card Game for LOVE2D
--
-- Lua port of "UnoCard" by Hikari Toyama (Apache License 2.0).
-- Original: https://github.com/shiawasenahikari/UnoCard
--
-- Uno runtime: the rules engine. It knows nothing about drawing or input.
--
-- Conventions that differ from the C++ original:
--   * Hand indices are 1-based (Lua arrays). Functions that returned -1 for
--     "no such card" return 0 instead.
--   * Player ids stay 0-based (YOU = 0 ... COM3 = 3), like the original.
--   * The 64-bit "legality" bit mask became a table: legality[card id].

local D = require("src.defs")
local Card = require("src.card")
local Player = require("src.player")

local NONE, RED, YELLOW = D.NONE, D.RED, D.YELLOW
local DRAW2, REV, WILD, WILD_DRAW4, NUM0 = D.DRAW2, D.REV, D.WILD, D.WILD_DRAW4, D.NUM0
local YOU, COM1, COM2, COM3 = D.YOU, D.COM1, D.COM2, D.COM3

local Uno = {}
Uno.__index = Uno

--- Easy level ID.
Uno.LV_EASY = 0
--- Hard level ID.
Uno.LV_HARD = 1
--- Direction value (clockwise).
Uno.DIR_LEFT = 1
--- Direction value (counter-clockwise).
Uno.DIR_RIGHT = 3
--- In this application, everyone can hold 26 cards at most.
Uno.MAX_HOLD_CARDS = 26

local function rand(lo, hi)
    return love.math.random(lo, hi)
end

local function shuffle(list)
    for i = #list, 2, -1 do
        local j = rand(1, i)
        list[i], list[j] = list[j], list[i]
    end
end

--- Split a string by a plain separator. Empty fields are kept, like
-- QString::split.
local function split(s, sep)
    local out, start = {}, 1

    while true do
        local i = s:find(sep, start, true)
        if not i then
            out[#out + 1] = s:sub(start)
            return out
        end

        out[#out + 1] = s:sub(start, i - 1)
        start = i + #sep
    end
end

--- Make everyone's cards of player p known to you: sort them and mark every
-- card as open. (MAKE_PUBLIC in the original.)
local function makePublic(self, p)
    local pl = self:getPlayer(p)

    table.sort(pl.handCards, function(a, b) return a.id < b.id end)
    pl.open = {}
    for i = 1, #pl.handCards do
        pl.open[i] = true
    end
end

--- Create the Uno runtime.
-- @param assets Provide a table with a function load(fileName) that returns
--               an image (any value) for a file in the resource directory.
-- @param seed   Random seed. Pass 0 or nil to seed from the clock.
function Uno.new(assets, seed)
    local self = setmetatable({}, Uno)
    local A = { "k", "r", "b", "g", "y" }
    local B = {
        "0", "1", "2", "3", "4", "5", "6", "7",
        "8", "9", "+", "$", "@", "w", "w+",
    }

    -- Load background & card back image resources
    self.bgWelcome = assets.load("bg_welcome.png")
    self.bgCounter = assets.load("bg_counter.png")
    self.bgClockwise = assets.load("bg_clockwise.png")
    self.backImage = assets.load("back.png")

    -- Generate 54 types of cards. table[id] (0 ~ 53)
    self.table = {}
    for i = 0, 53 do
        local a = i < 52 and math.floor(i / 13) + 1 or 0
        local b = i < 52 and i % 13 or i - 39
        local x = assets.load("front_" .. A[a + 1] .. B[b + 1] .. ".png")
        local y = assets.load("dark_" .. A[a + 1] .. B[b + 1] .. ".png")
        self.table[i] = Card.new(x, y, a, b)
    end

    -- Load colored wild & wild +4 image resources. Index 0 = uncolored.
    self.wildImage = { [0] = self.table[39 + WILD].image }
    self.wildDraw4Image = { [0] = self.table[39 + WILD_DRAW4].image }
    for i = 1, 4 do
        self.wildImage[i] = assets.load("front_" .. A[i + 1] .. "w.png")
        self.wildDraw4Image[i] = assets.load("front_" .. A[i + 1] .. "w+.png")
    end

    -- Random seed
    if seed == nil or seed == 0 then
        seed = os.time()
    end

    love.math.setRandomSeed(seed)
    self.seed = seed

    -- Player in turn (YOU / COM1 / COM2 / COM3)
    self.now = rand(0, 3)

    -- How many players in game. Supports 2, 3 or 4.
    self.players = 3

    -- Current action sequence (DIR_LEFT / DIR_RIGHT / 0 when not in game)
    self.direction = 0

    -- Current difficulty (LV_EASY / LV_HARD)
    self.difficulty = Uno.LV_EASY

    -- Whether the 2vs2 rule is enabled
    self._2vs2 = false

    -- 0: When you draw a playable card, you must keep it in hand.
    -- 1: When you draw a playable card, choose to play it or not.
    -- 2: When you draw a playable card, you must play it.
    self.forcePlayRule = 1

    -- Whether the 7-0 rule is enabled
    self.sevenZeroRule = false

    -- Whether the "draw to match" rule is enabled: when you draw a card by
    -- yourself (not a forced draw from a +2/+4) and it is not legal to play,
    -- keep drawing until you draw a legal card, or you cannot draw any more.
    self.drawToMatchRule = false

    -- Whether the "Wild +4 anytime" rule is enabled: a Wild +4 can never be
    -- challenged, so it is always safe to play regardless of your hand.
    self.wildDraw4NoChallengeRule = false

    -- Whether the Bullseye rule is enabled: a +2 or Skip's effect targets a
    -- player chosen by whoever played it, instead of always the next player.
    self.bullseyeRule = false

    -- 0: No cards can be stacked.
    -- 1: Only +2 cards can be stacked.
    -- 2: +2 & +4 cards can be stacked.
    self.stackRule = 0

    -- In stack rules, records how many required cards need to be drawn by
    -- the final player. When this value is not zero, only cards that can be
    -- stacked are legal to play.
    self.draw2StackCount = 0

    -- How many initial cards for everyone in each game (5 ~ 20).
    self.initialCards = 7

    -- Which cards are legal to play: legality[card id] == true. When the
    -- recent-played-card queue changes, this value is updated automatically.
    self.legality = {}

    -- Game players, player[0 ~ 3]
    self.player = {}
    for i = 0, 3 do
        self.player[i] = Player.new()
    end

    -- colorAnalysis[A]: how many cards in color A are used.
    -- contentAnalysis[B]: how many cards in content B are used.
    self.colorAnalysis = { [0] = 0, 0, 0, 0, 0 }
    self.contentAnalysis = {}
    for i = 0, 14 do
        self.contentAnalysis[i] = 0
    end

    -- Card deck (ready to use). The last element is the top of the deck.
    self.deck = {}

    -- Used cards
    self.used = {}

    -- Recent played cards. recent[3] is the last played card.
    self.recent = {}
    for i = 0, 3 do
        self.recent[i] = { card = nil, color = NONE }
    end

    -- Replay data of the current game (array of commands)
    self.replay = {}

    -- Your loaded replay, and the position of the next command to run
    self.loaded = {}
    self.it = 1

    return self
end

--- @return Card back image resource.
function Uno:getBackImage()
    return self.backImage
end

--- @return Background image resource in current direction.
function Uno:getBackground()
    return self.direction == Uno.DIR_LEFT and self.bgClockwise
        or self.direction == Uno.DIR_RIGHT and self.bgCounter
        or self.bgWelcome
end

--- When a player played a wild card and specified a following legal color,
-- get the corresponding color-filled image here, and show it in recent card
-- area.
function Uno:getColoredWildImage(color)
    return self.wildImage[color]
end

--- Same as getColoredWildImage(), but for wild +4 cards.
function Uno:getColoredWildDraw4Image(color)
    return self.wildDraw4Image[color]
end

--- @return Player in turn (YOU / COM1 / COM2 / COM3).
function Uno:getNow()
    return self.now
end

--- Switch to next player's turn.
-- @return Player in turn after switched.
function Uno:switchNow()
    self.now = self:getNext()
    return self.now
end

--- @return Current player's next player.
--         NOTE: With 2 players (YOU and COM2 only), this is always the
--         other one of the two, regardless of direction: Reverse only has
--         two seats to alternate between either way.
function Uno:getNext()
    if self.players == 2 then
        return self.now == YOU and COM2 or YOU
    end

    local nxt = (self.now + self.direction) % 4

    if self.players == 3 and nxt == COM2 then
        nxt = (nxt + self.direction) % 4
    end

    return nxt
end

--- @return Current player's opposite player.
--         NOTE: When only 3 players in game, getOppo() == getPrev(). With 2
--         players, getOppo() == getNext() == getPrev(): there is only one
--         other player, so all three "relative to me" ideas mean the same
--         seat (rather than mathematically folding back to yourself, which
--         is what a naive 2-of-4-active-seats rotation would otherwise give).
function Uno:getOppo()
    if self.players == 2 then
        return self.now == YOU and COM2 or YOU
    end

    local oppo = (self:getNext() + self.direction) % 4

    if self.players == 3 and oppo == COM2 then
        oppo = (oppo + self.direction) % 4
    end

    return oppo
end

--- @return Current player's previous player.
function Uno:getPrev()
    if self.players == 2 then
        return self.now == YOU and COM2 or YOU
    end

    local prev = (4 + self.now - self.direction) % 4

    if self.players == 3 and prev == COM2 then
        prev = (4 + prev - self.direction) % 4
    end

    return prev
end

--- @param who Get which player's instance (0 ~ 3).
function Uno:getPlayer(who)
    if who < YOU or who > COM3 then
        return nil
    end

    return self.player[who]
end

function Uno:getCurrPlayer() return self.player[self:getNow()] end
function Uno:getNextPlayer() return self.player[self:getNext()] end
function Uno:getOppoPlayer() return self.player[self:getOppo()] end
function Uno:getPrevPlayer() return self.player[self:getPrev()] end

--- @param whom Get whose hand cards.
function Uno:getHandCardsOf(whom)
    return self:getPlayer(whom):getHandCards()
end

--- @return How many players in game (2, 3, or 4).
function Uno:getPlayers()
    return self.players
end

--- Set the amount of players in game. Supports 2, 3 and 4. A 2-player game
-- is YOU against COM2 (the seat across the table); COM1 and COM3 sit out.
function Uno:setPlayers(players)
    if players == 2 or players == 3 or players == 4 then
        self._2vs2 = false
        self.sevenZeroRule = false
        self.players = players
    end
end

--- Switch current action sequence between DIR_LEFT and DIR_RIGHT.
function Uno:switchDirection()
    self.direction = 4 - self.direction
end

--- @return Current difficulty (LV_EASY / LV_HARD).
function Uno:getDifficulty()
    return self.difficulty
end

--- Set game difficulty. Only LV_EASY and LV_HARD are available.
function Uno:setDifficulty(difficulty)
    if difficulty == Uno.LV_EASY or difficulty == Uno.LV_HARD then
        self.difficulty = difficulty
    end
end

--- @return Whether the 2vs2 rule is enabled. In 2vs2 mode, you win the game
--         either you or the player sitting on your opposite position played
--         all of the hand cards.
function Uno:is2vs2()
    return self._2vs2
end

--- Enable/Disable the 2vs2 rule.
function Uno:set2vs2(enabled)
    self._2vs2 = enabled
    if enabled then
        self.players = 4
        self.sevenZeroRule = false
    end
end

--- @return 0: When you draw a playable card, you must keep it in hand.
--         1: When you draw a playable card, choose to play it or not.
--         2: When you draw a playable card, you must play it.
function Uno:getForcePlayRule()
    return self.forcePlayRule
end

function Uno:setForcePlayRule(rule)
    if 0 <= rule and rule <= 2 then
        self.forcePlayRule = rule
    end
end

--- @return Whether the 7-0 rule is enabled. In 7-0 rule, when a seven card
--         is put down, the player must swap hand cards with another player
--         immediately. When a zero card is put down, everyone need to pass
--         the hand cards to the next player.
function Uno:isSevenZeroRule()
    return self.sevenZeroRule
end

--- Enable/Disable the 7-0 rule.
function Uno:setSevenZeroRule(enabled)
    self.sevenZeroRule = enabled
    if enabled then
        self.players = 4
        self._2vs2 = false
    end
end

--- @return Whether the "draw to match" rule is enabled. See the field
--         comment in Uno.new() for what it does.
function Uno:isDrawToMatchRule()
    return self.drawToMatchRule
end

--- Enable/Disable the "draw to match" rule.
function Uno:setDrawToMatchRule(enabled)
    self.drawToMatchRule = enabled
end

--- @return Whether the "Wild +4 anytime" rule is enabled. See the field
--         comment in Uno.new() for what it does.
function Uno:isWildDraw4NoChallengeRule()
    return self.wildDraw4NoChallengeRule
end

--- Enable/Disable the "Wild +4 anytime" rule.
function Uno:setWildDraw4NoChallengeRule(enabled)
    self.wildDraw4NoChallengeRule = enabled
end

--- @return Whether the Bullseye rule is enabled. See the field comment in
--         Uno.new() for what it does.
function Uno:isBullseyeRule()
    return self.bullseyeRule
end

--- Enable/Disable the Bullseye rule.
function Uno:setBullseyeRule(enabled)
    self.bullseyeRule = enabled
end

--- Directly set whose turn it is, bypassing the normal direction-based
-- getNext() computation. Used by the Bullseye rule to redirect a +2/Skip's
-- effect to a chosen target instead of the automatic next player.
-- NOTE: Unlike swap()/cycle(), this is not written to the replay log: it
-- does not change any player's hand, and the next drawn/played card already
-- carries its own player id, which is enough for forwardReplay() to
-- re-establish the correct turn owner on playback.
-- @param who New player in turn (0 ~ 3).
function Uno:setNow(who)
    if YOU <= who and who <= COM3 then
        self.now = who
    end
end

--- Can or cannot stack +2/+4 cards. If can, when you put down a +2/+4 card,
-- the next player may transfer the punishment to its next player by stacking
-- another +2/+4 card. Finally the first one who does not stack a +2/+4 card
-- must draw all of the required cards.
-- @return 0: No cards can be stacked. 1: Only +2. 2: +2 & +4.
function Uno:getStackRule()
    return self.stackRule
end

function Uno:setStackRule(rule)
    if 0 <= rule and rule <= 2 then
        self.stackRule = rule
    end
end

--- @return Current game mode: 0: 2P, 1: 7-0, 2: 2vs2, 3: 3P, 4: 4P.
function Uno:getGameMode()
    return self.sevenZeroRule and 1 or self._2vs2 and 2 or self.players == 2 and 0 or self.players
end

--- @param gameMode 0: 2P, 1: 7-0, 2: 2vs2, 3: 3P, 4: 4P.
function Uno:setGameMode(gameMode)
    if gameMode == 0 then
        self:setPlayers(2)
    elseif gameMode == 1 then
        self:setSevenZeroRule(true)
    elseif gameMode == 2 then
        self:set2vs2(true)
    else
        self:setPlayers(gameMode)
    end
end

--- @return In a stack rule, how many required cards need to be drawn by the
--         final player. When this value is not zero, only cards that can be
--         stacked are legal to play.
function Uno:getDraw2StackCount()
    return self.draw2StackCount
end

--- @return How many initial cards for everyone in each game.
function Uno:getInitialCards()
    return self.initialCards
end

--- Add a initial card for everyone. Can be increased to 20 at most.
function Uno:increaseInitialCards()
    self.initialCards = math.min(self.initialCards + 1, 20)
end

--- Remove a initial card for everyone. Can be decreased to 5 at least.
function Uno:decreaseInitialCards()
    self.initialCards = math.max(self.initialCards - 1, 5)
end

--- Find a card instance in card table.
-- @return Corresponding card instance, or nil if the pair is invalid.
function Uno:findCard(color, content)
    if color == NONE and content == WILD then
        return self.table[39 + WILD]
    elseif color == NONE and content == WILD_DRAW4 then
        return self.table[39 + WILD_DRAW4]
    elseif color ~= NONE and content ~= WILD and content ~= WILD_DRAW4 then
        return self.table[13 * (color - 1) + content]
    end

    return nil
end

--- Find a card instance in card table by card ID (0 ~ 53).
function Uno:findCardById(id)
    return self.table[id]
end

--- @return How many cards in deck (haven't been used yet).
function Uno:getDeckCount()
    return #self.deck
end

--- @return How many cards have been used.
function Uno:getUsedCount()
    local count = #self.used

    for i = 0, 3 do
        if self.recent[i].card ~= nil then
            count = count + 1
        end
    end

    return count
end

--- @return Info of recent played cards (array 0 ~ 3 of {card, color}).
--         getRecentInfo()[3] is the last played card, [2] is the
--         next-to-last played card, etc.
function Uno:getRecentInfo()
    return self.recent
end

--- @return Color of the last played card.
function Uno:lastColor()
    return self.recent[3].color
end

--- @return Color of the next-to-last played card.
function Uno:next2lastColor()
    return self.recent[2].color
end

--- @return How many cards in color A are used.
function Uno:getColorAnalysis(color)
    return self.colorAnalysis[color]
end

--- @return How many cards in content B are used.
function Uno:getContentAnalysis(content)
    return self.contentAnalysis[content]
end

--- Legal cards after a normal play: all wild cards, all cards in the last
-- color, and (if the last card is not a wild card) all cards that have the
-- same content as the last card.
function Uno:calcLegality()
    local legal = { [WILD + 39] = true, [WILD_DRAW4 + 39] = true }
    local card = self.recent[3].card
    local last = self:lastColor()

    if last >= RED then
        for c = 0, 12 do
            legal[13 * (last - 1) + c] = true
        end
    end

    if not card:isWild() then
        for col = 0, 3 do
            legal[13 * col + card.content] = true
        end
    end

    return legal
end

--- Start a new Uno game. Shuffle cards, let everyone draw initial cards,
-- then determine our start card.
function Uno:start()
    local card

    -- Reset direction
    self.direction = Uno.DIR_LEFT

    -- In stack rules, reset the stack counter
    self.draw2StackCount = 0

    -- Clear the analysis data
    self.colorAnalysis = { [0] = 0, 0, 0, 0, 0 }
    for i = 0, 14 do
        self.contentAnalysis[i] = 0
    end

    -- Clear card deck, used card deck, recent played cards,
    -- everyone's hand cards, and everyone's strong/weak colors
    self.deck = {}
    self.used = {}
    for i = 0, 3 do
        local p = self.player[i]

        self.recent[i] = { card = nil, color = NONE }
        p.open = {}
        p.handCards = {}
        p.weakColor = NONE
        p.strongColor = NONE
    end

    -- Generate a temporary sequenced card deck (108 cards). Zero cards
    -- have 1 copy, wild cards have 4 copies, the others have 2 copies.
    for i = 0, 53 do
        card = self.table[i]

        local copies = (card.content == WILD or card.content == WILD_DRAW4) and 4
            or card.content == NUM0 and 1
            or 2

        for _ = 1, copies do
            self.deck[#self.deck + 1] = card
        end
    end

    -- Shuffle cards
    shuffle(self.deck)

    -- Determine a start card as the previous played card
    repeat
        card = table.remove(self.deck)
        if card:isWild() then
            -- Start card cannot be a wild card, so return it to the bottom
            -- of card deck and pick another card
            table.insert(self.deck, 1, card)
        else
            -- Any non-wild card can be start card. Start card determined
            self.recent[3] = { card = card, color = card.color }
            self.colorAnalysis[card.color] = self.colorAnalysis[card.color] + 1
            self.contentAnalysis[card.content] = self.contentAnalysis[card.content] + 1
        end
    until self.recent[3].card ~= nil

    -- Write log
    self.replay = { string.format("ST,%d,%d,%d", self._2vs2 and 1 or 0, self.players, card.id) }

    -- Let everyone draw initial cards
    for _ = 1, self.initialCards do
        self:draw(YOU, true)
        if self.players ~= 2 then self:draw(COM1, true) end
        if self.players == 4 or self.players == 2 then self:draw(COM2, true) end
        if self.players ~= 2 then self:draw(COM3, true) end
    end

    -- In the case of (last winner = a seat that sits out at this player
    -- count) re-specify the dealer randomly among the seats actually in play
    if self.players == 3 and self.now == COM2 then
        self.now = (3 + rand(0, 2)) % 4
    elseif self.players == 2 and (self.now == COM1 or self.now == COM3) then
        self.now = rand(0, 1) == 0 and YOU or COM2
    end
end

--- Call this function when someone needs to draw a card.
-- NOTE: Everyone can hold 26 cards at most in this program, so even if this
-- function is called, the specified player may not draw a card as a result.
-- @param who   Who draws a card (0 ~ 3).
-- @param force Pass true if the specified player is required to draw cards,
--              i.e. previous player played a [+2] or [wild +4] to let this
--              player draw cards. Or false if the specified player draws a
--              card by itself in its action.
-- @return Index of the drawn card in hand, or 0 if the specified player
--         didn't draw a card because of the limitation.
function Uno:draw(who, force)
    local index = 0

    if YOU <= who and who <= COM3 then
        local p = self.player[who]
        local hand = p.handCards

        if self.draw2StackCount > 0 then
            self.draw2StackCount = self.draw2StackCount - 1
        elseif not force then
            -- Draw a card by player itself, register weak color
            p.weakColor = self:lastColor()
            if p.weakColor == p.strongColor then
                -- Weak color cannot also be strong color
                p.strongColor = NONE
            end
        end

        if #hand < Uno.MAX_HOLD_CARDS and #self.deck > 0 then
            -- Draw a card from card deck, and put it to an appropriate position
            local card = table.remove(self.deck)

            if who == YOU then
                -- Keep your hand cards sorted (insert after equal cards)
                local i = 1
                while i <= #hand and hand[i].id <= card.id do
                    i = i + 1
                end

                table.insert(hand, i, card)
                table.insert(p.open, i, true)
                index = i
            else
                hand[#hand + 1] = card
                p.open[#hand] = false
                index = #hand
            end

            p.recent = nil
            self.replay[#self.replay + 1] = string.format("DR,%d,%d", who, card.id)
            if #self.deck == 0 then
                -- Re-use the used cards when there are no more cards in deck
                for j = #self.used, 1, -1 do
                    local c = self.used[j]

                    self.deck[#self.deck + 1] = c
                    self.colorAnalysis[c.color] = self.colorAnalysis[c.color] - 1
                    self.contentAnalysis[c.content] = self.contentAnalysis[c.content] - 1
                    table.remove(self.used, j)
                end

                shuffle(self.deck)
            end
        else
            -- In stack rules, if someone cannot draw all of the required
            -- cards because of the max-hold-card limitation, force reset
            -- the counter to zero.
            self.draw2StackCount = 0
            self.replay[#self.replay + 1] = string.format("DF,%d", who)
        end

        if self.draw2StackCount == 0 then
            -- Update the legality table when necessary
            self.legality = self:calcLegality()
        end
    end

    return index
end

--- Check whether the specified card is legal to play. It's legal only when
-- it's wild, or it has the same color/content to the previous played card.
function Uno:isLegalToPlay(card)
    return self.legality[card.id] == true
end

--- @return How many legal cards (the cards that can be played legally) in
--         now player's hand.
function Uno:legalCardsCount4NowPlayer()
    local count = 0

    for _, card in ipairs(self.player[self.now].handCards) do
        if self:isLegalToPlay(card) then
            count = count + 1
        end
    end

    return count
end

--- Call this function when someone needs to play a card. The played card
-- replaces the "previous played card", and the original "previous played
-- card" becomes a used card at the same time.
-- NOTE: Before calling this function, you must call isLegalToPlay() at first
-- to check whether the specified card is legal to play. This function will
-- play the card directly without checking the legality.
-- @param who   Who plays a card (0 ~ 3).
-- @param index Play which card (index of the player's hand cards).
-- @param color Optional, available when the card to play is a wild card.
--              Pass the specified following legal color.
-- @return The played card, or nil if the index is invalid.
function Uno:play(who, index, color)
    local card = nil

    color = color or NONE
    if YOU <= who and who <= COM3 then
        local p = self.player[who]
        local hand = p.handCards
        local size = #hand

        if 1 <= index and index <= size then
            card = hand[index]
            if not card:isWild() then
                color = card.color
            end

            table.remove(hand, index)
            table.remove(p.open, index)
            if card:isWild() then
                -- When a wild card is played, register the specified
                -- following legal color as the player's strong color
                if self.stackRule ~= 2 or card.content ~= WILD_DRAW4 then
                    -- In +2/+4 stack rule, Wild +4 cards will lose their
                    -- "change color" ability, and cannot be challenged.
                    -- So when someone played a Wild +4 card in this rule,
                    -- strong color will not be registered.
                    p.strongColor = color
                    p.strongCount = 1 + math.floor(size / 3)
                    if color == p.weakColor then
                        -- Strong color cannot also be weak color
                        p.weakColor = NONE
                    end
                end
            elseif card.color == p.strongColor then
                -- Played a card that matches the registered
                -- strong color, strong counter counts down
                p.strongCount = p.strongCount - 1
                if p.strongCount == 0 then
                    p.strongColor = NONE
                end
            elseif p.strongCount >= size then
                -- Correct the value of strong counter when necessary
                p.strongCount = size - 1
            end

            if card.content == DRAW2 and self.stackRule ~= 0 then
                self.draw2StackCount = self.draw2StackCount + 2
            elseif card.content == WILD_DRAW4 and self.stackRule == 2 then
                self.draw2StackCount = self.draw2StackCount + 4
            end

            p.recent = card

            -- Push the recent-played-card queue. (Copy the entries: they
            -- are tables here, whereas they were value types in C++.)
            if self.recent[0].card ~= nil then
                self.used[#self.used + 1] = self.recent[0].card
            end

            for i = 1, 3 do
                self.recent[i - 1] = { card = self.recent[i].card, color = self.recent[i].color }
            end

            self.recent[3] = { card = card, color = color }
            self.colorAnalysis[card.color] = self.colorAnalysis[card.color] + 1
            self.contentAnalysis[card.content] = self.contentAnalysis[card.content] + 1
            self.replay[#self.replay + 1] = string.format("PL,%d,%d,%d", who, card.id, color)

            -- Update the legality table
            if self.draw2StackCount < 1 then
                self.legality = self:calcLegality()
            elseif self.stackRule == 1 then
                -- Only +2 cards can be stacked
                self.legality = {}
                for col = 0, 3 do
                    self.legality[13 * col + DRAW2] = true
                end
            else
                -- +2 & +4 cards can be stacked. After a wild +4 the color
                -- did not change, so only the +2 in that color (or a +4).
                self.legality = { [WILD_DRAW4 + 39] = true }
                if card:isWild() then
                    self.legality[13 * (self:lastColor() - 1) + DRAW2] = true
                else
                    for col = 0, 3 do
                        self.legality[13 * col + DRAW2] = true
                    end
                end
            end

            if size == 1 then
                -- Game over, change background & show everyone's hand cards
                self.direction = 0
                for i = COM1, COM3 do
                    makePublic(self, i)
                end
            end
        end
    end

    return card
end

--- When you think your previous player used a [wild +4] card illegally, i.e.
-- it holds at least one card matching the next-to-last color, call this
-- function to make a challenge.
-- @param whom Challenge whom (0 ~ 3).
-- @return true if challenge success, or false if challenge failure.
function Uno:challenge(whom)
    local result = false

    if YOU <= whom and whom <= COM3 then
        if whom ~= YOU then
            makePublic(self, whom)
        end

        for _, card in ipairs(self.player[whom].handCards) do
            if card.color == self:next2lastColor() then
                result = true
                break
            end
        end
    end

    self.replay[#self.replay + 1] = string.format("CH,%d", whom)
    return result
end

--- In 7-0 rule, when someone put down a seven card, then the player must
-- swap hand cards with another player immediately. (Whole player records are
-- swapped, so strong/weak color estimations travel with the cards.)
-- @param a Who put down the seven card (0 ~ 3).
-- @param b Exchange with whom (0 ~ 3). Cannot exchange with yourself.
function Uno:swap(a, b)
    self.player[a], self.player[b] = self.player[b], self.player[a]
    if a == YOU or b == YOU then
        makePublic(self, YOU)
    end

    self.replay[#self.replay + 1] = string.format("SW,%d,%d", a, b)
end

--- In 7-0 rule, when a zero card is put down, everyone need to pass the hand
-- cards to the next player.
function Uno:cycle()
    local curr, nxt, oppo, prev = self.now, self:getNext(), self:getOppo(), self:getPrev()
    local P = self.player
    local store = P[curr]

    P[curr] = P[prev]
    P[prev] = P[oppo]
    P[oppo] = P[nxt]
    P[nxt] = store
    makePublic(self, YOU)
    self.replay[#self.replay + 1] = "CY"
end

--- Save current game as a new replay file (in LOVE's save directory).
-- @return Name of the saved file, or an empty string if save failed.
function Uno:save()
    local name = tostring(os.time()) .. ".sav"

    love.filesystem.createDirectory("replays")
    if love.filesystem.write("replays/" .. name, table.concat(self.replay, ";")) then
        return name
    end

    return ""
end

--- Load a replay from its text content.
-- @return True if load success.
function Uno:loadReplay(text)
    local function check(val, lo, hi)
        local v = tonumber(val)

        if v == nil or v ~= math.floor(v) then
            v = 0
        end

        return lo <= v and v <= hi
    end

    local loaded = split((text:gsub("^%s+", ""):gsub("%s+$", "")), ";")
    local ok = true

    for i = 1, #loaded do
        local x = split(loaded[i], ",")
        local cmd = x[1]

        if (i == 1 and cmd ~= "ST") or (i ~= 1 and cmd == "ST") then
            -- ST command can only appear once at the beginning
            ok = false
        elseif cmd == "ST" then
            -- ST: Start a new game. Command format: ST,a,b,c
            -- a = 1 if in 2vs2 mode, otherwise 0
            -- b = players in game [2, 4]
            -- c = start card's id [0, 51]
            ok = #x > 3 and check(x[2], 0, 1) and check(x[3], 2, 4) and check(x[4], 0, 51)
        elseif cmd == "DR" then
            -- DR: Draw a card from deck. Command format: DR,a,b
            -- a = who drew a card [0, 3]
            -- b = drawn card's id [0, 53]
            ok = #x > 2 and check(x[2], 0, 3) and check(x[3], 0, 53)
        elseif cmd == "PL" then
            -- PL: Play a card. Command format: PL,a,b,c
            -- a = who played a card [0, 3]
            -- b = played card's id [0, 53]
            -- c = the following legal color [0, 4]
            ok = #x > 3 and check(x[2], 0, 3) and check(x[3], 0, 53) and check(x[4], 0, 4)
        elseif cmd == "DF" or cmd == "CH" then
            -- DF: Draw but failure. Command format: DF,a
            -- a = who drew but failure [0, 3]
            -- CH: Make a challenge. Command format: CH,a
            -- a = challenged to whom [0, 3]
            ok = #x > 1 and check(x[2], 0, 3)
        elseif cmd == "SW" then
            -- SW: Swap hand cards between player A and B. Command format: SW,a,b
            -- a = player A's id [0, 3]
            -- b = player B's id [0, 3]
            ok = #x > 2 and check(x[2], 0, 3) and check(x[3], 0, 3) and x[2] ~= x[3]
        elseif cmd ~= "CY" then
            -- CY: Cycle, everyone pass hand cards to the next. Command: CY
            -- Other commands are all unknown commands
            ok = false
        end

        if not ok then
            break
        end
    end

    self.loaded = ok and loaded or {}
    self.it = 1
    return ok
end

--- Go to next step of your replay. This method will do nothing when we
-- reached the end of your replay.
-- @return The name of the command that has been run (e.g. "ST") followed by
--         its parameters a, b, c (0 for missing ones). At the end of the
--         replay, returns an empty string.
function Uno:forwardReplay()
    local s = ""
    local a, b, c = 0, 0, 0

    if #self.loaded > 0 and self.it <= #self.loaded then
        local x = split(self.loaded[self.it], ",")
        local card

        self.it = self.it + 1
        a = x[2] and tonumber(x[2]) or 0
        b = x[3] and tonumber(x[3]) or 0
        c = x[4] and tonumber(x[4]) or 0
        s = x[1]
        if s == "ST" then
            -- ST: Start a new game. Command format: ST,a,b,c
            -- a = 1 if in 2vs2 mode, otherwise 0
            -- b = players in game [2, 4]
            -- c = start card's id [0, 51]
            self:setPlayers(b)
            self:set2vs2(a ~= 0)
            card = self.table[c]
            self.deck = {}
            self.used = {}
            for i = 0, 3 do
                local p = self.player[i]

                self.recent[i] = { card = nil, color = NONE }
                p.open = {}
                p.handCards = {}
                p.weakColor = NONE
                p.strongColor = NONE
            end

            self.recent[3] = { card = card, color = card.color }
            self.direction = card.content == REV and Uno.DIR_RIGHT or Uno.DIR_LEFT
        elseif s == "DR" then
            -- DR: Draw a card from deck. Command format: DR,a,b
            -- a = who drew a card [0, 3]
            -- b = drawn card's id [0, 53]
            local p = self.player[a]
            local i = 1

            card = self.table[b]
            while i <= #p.handCards and p.handCards[i].id < card.id do
                i = i + 1
            end

            table.insert(p.handCards, i, card)
            table.insert(p.open, i, true)
            self.now = a
        elseif s == "PL" then
            -- PL: Play a card. Command format: PL,a,b,c
            -- a = who played a card [0, 3]
            -- b = played card's id [0, 53]
            -- c = the following legal color [0, 4]
            local p = self.player[a]
            local i = 1

            card = self.table[b]
            while i <= #p.handCards and p.handCards[i].id < card.id do
                i = i + 1
            end

            if i <= #p.handCards and p.handCards[i] == card then
                table.remove(p.handCards, i)
                table.remove(p.open, i)
                for j = 0, 2 do
                    self.recent[j] = { card = self.recent[j + 1].card, color = self.recent[j + 1].color }
                end

                self.recent[3] = { card = card, color = c }
            end

            self.now = a
            if card.content == REV then
                self:switchDirection()
            end
        elseif s == "DF" then
            -- DF: Draw but failure. Command format: DF,a
            -- a = who drew but failure [0, 3]
            self.now = a
        elseif s == "SW" then
            -- SW: Swap hand cards between player A and B. Command format: SW,a,b
            -- a = player A's id [0, 3]
            -- b = player B's id [0, 3]
            self.player[a], self.player[b] = self.player[b], self.player[a]
        elseif s == "CY" then
            -- CY: Cycle, everyone pass hand cards to the next. Command: CY
            local curr, nxt = self.now, self:getNext()
            local oppo, prev = self:getOppo(), self:getPrev()
            local P = self.player
            local store = P[curr]

            P[curr] = P[prev]
            P[prev] = P[oppo]
            P[oppo] = P[nxt]
            P[nxt] = store
        end
    else
        self.direction = 0
    end

    return s, a, b, c
end

return Uno
