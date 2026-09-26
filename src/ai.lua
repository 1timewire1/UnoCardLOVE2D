-- Uno Card Game for LOVE2D
--
-- Lua port of "UnoCard" by Hikari Toyama (Apache License 2.0).
-- Original: https://github.com/shiawasenahikari/UnoCard
--
-- AI strategies. Every bestCardIndex function returns two values:
--   1. Index (1-based) of the best card to play in current player's hand, or
--      0 that means no appropriate card to play.
--   2. When the best card to play is a wild card, the following legal color
--      to change. Otherwise the player's best color.
--
-- The decision trees are ported branch by branch from AI.h, so they keep the
-- original priorities (and the original tie-breaking of candidates).

local D = require("src.defs")
local Uno = require("src.uno")

local NONE, RED = D.NONE, D.RED
local NUM0, NUM7 = D.NUM0, D.NUM7
local DRAW2, REV, SKIP, WILD, WILD_DRAW4 = D.DRAW2, D.REV, D.SKIP, D.WILD, D.WILD_DRAW4

local AI = {}
AI.__index = AI

--- @param uno The Uno runtime this AI plays in.
function AI.new(uno)
    return setmetatable({
        uno = uno,

        -- Record the priorities of your candidates (number cards). Sorted
        -- from the highest priority to the lowest one. Used by hard AIs.
        candidates = {},
    }, AI)
end

local function rand(lo, hi)
    return love.math.random(lo, hi)
end

--- Sort the collected candidates (highest priority first).
local function sortCandidates(self)
    table.sort(self.candidates, function(a, b) return a.score < b.score end)
end

--- @return Index of the candidate with the highest priority (0 if none).
local function topCandidate(self)
    local c = self.candidates[1]
    return c and c.idx or 0
end

--- @return Whether the candidate with the highest priority is in that color.
local function topCandidateIs(self, hand, color)
    local c = self.candidates[1]
    return c ~= nil and hand[c.idx].color == color
end

--- @return Index of the first (best) candidate whose color is not `color`.
local function firstCandidateNot(self, hand, color)
    for _, c in ipairs(self.candidates) do
        if hand[c.idx].color ~= color then
            return c.idx
        end
    end

    return 0
end

--- @return Index of the first (best) candidate whose color is `color`.
local function firstCandidateIs(self, hand, color)
    for _, c in ipairs(self.candidates) do
        if hand[c.idx].color == color then
            return c.idx
        end
    end

    return 0
end

--- Priority of a number card, used to sort the candidates. When you have
-- multiple choices, firstly choose the cards in your best color, then choose
-- the cards of the contents that appeared a lot of times. This can reduce the
-- possibility of changing color by your opponents. e.g. When you put down the
-- 8th [nine] card after 7 [nine] cards appeared, no one can change the color
-- by using another [nine] card. (Lower value = higher priority.)
local function candidateScore(uno, card, index, bestColor)
    return -1000000 * (card.color == bestColor and 1 or 0)
        - 10000 * uno:getContentAnalysis(card.content)
        - 100 * uno:getColorAnalysis(card.color)
        - (index - 1)
end

--- Evaluate which color is the best for current player. In our evaluation
-- system, zero cards / reverse cards are worth 2 points, non-zero number
-- cards are worth 4 points, and skip / draw two cards are worth 5 points.
-- Finally, the color which contains the worthiest cards becomes the best
-- color.
-- @return Current player's best color.
function AI:calcBestColor4NowPlayer()
    local uno = self.uno
    local bestColor = NONE
    local nxt, oppo, prev = uno:getNextPlayer(), uno:getOppoPlayer(), uno:getPrevPlayer()
    local nextWeak, oppoWeak, prevWeak = nxt:getWeakColor(), oppo:getWeakColor(), prev:getWeakColor()
    local nextStrong, oppoStrong, prevStrong = nxt:getStrongColor(), oppo:getStrongColor(), prev:getStrongColor()

    -- NOTE: The original checks the NEXT player's hand size for all three
    -- flags (probably a copy-paste slip upstream). Kept as is, so that the
    -- AI plays exactly like the original.
    local nextIsUno = nxt:getHandSize() == 1
    local oppoIsUno = nxt:getHandSize() == 1
    local prevIsUno = nxt:getHandSize() == 1

    -- When defensing UNO dash, use others' weak color as your best color
    if nextIsUno and nextWeak ~= NONE then
        bestColor = nextWeak
    elseif oppoIsUno and oppoWeak ~= NONE and not uno:is2vs2() then
        bestColor = oppoWeak
    elseif prevIsUno and prevWeak ~= NONE then
        bestColor = prevWeak
    elseif uno:is2vs2() and oppoStrong ~= NONE
        and oppo:getHandSize() <= uno:getCurrPlayer():getHandSize() then
        bestColor = oppoStrong
    else
        local score = { [0] = 0, 0, 0, 0, 0 }

        for _, card in ipairs(uno:getCurrPlayer():getHandCards()) do
            local c = card.content

            if c == WILD or c == WILD_DRAW4 then
                -- Wild cards have no color
            elseif c == REV or c == NUM0 then
                score[card.color] = score[card.color] + 2
            elseif c == SKIP or c == DRAW2 then
                score[card.color] = score[card.color] + 5
            else
                score[card.color] = score[card.color] + 4
            end
        end

        -- Calculate the best color
        for i = 1, 4 do
            if score[i] > score[bestColor] then
                bestColor = i
            end
        end

        if bestColor == NONE then
            -- Only wild cards in hand
            -- Use others' weak color as your best color
            if prevWeak ~= NONE then
                bestColor = prevWeak
            elseif oppoWeak ~= NONE and not uno:is2vs2() then
                bestColor = oppoWeak
            elseif nextWeak ~= NONE then
                bestColor = nextWeak
            else
                bestColor = RED
            end
        end
    end

    -- Determine your best color in dangerous cases. Be careful of the
    -- conflict with other opponents' strong colors.
    while (nextIsUno and bestColor == nextStrong)
        or (oppoIsUno and bestColor == oppoStrong and not uno:is2vs2())
        or (prevIsUno and bestColor == prevStrong) do
        bestColor = rand(1, 4)
    end

    return bestColor
end

--- In 7-0 rule, when a seven card is put down, the player must swap hand
-- cards with another player immediately. This API returns that swapping with
-- whom is the best answer for current player.
-- @return Current player swaps with whom (0 ~ 3).
function AI:calcBestSwapTarget4NowPlayer()
    local uno = self.uno
    local target
    local nxt, oppo, prev = uno:getNextPlayer(), uno:getOppoPlayer(), uno:getPrevPlayer()
    local hand = uno:getCurrPlayer():getHandCards()

    if nxt:getHandSize() == 1 then
        target = uno:getNext()
    elseif prev:getHandSize() == 1 then
        target = uno:getPrev()
    elseif oppo:getHandSize() == 1 then
        target = uno:getOppo()
    elseif prev:getStrongColor() == uno:lastColor() then
        target = uno:getPrev()
    elseif oppo:getStrongColor() == uno:lastColor() then
        target = uno:getOppo()
    else
        target = uno:getNext()
    end

    if #hand == 1 and target == uno:getNext() and uno:isLegalToPlay(hand[1]) then
        -- Do not swap with your next player when your final card is a legal
        -- card. This will make your next player win the game.
        target = uno:getPrev()
    end

    return target
end

--- AI strategies of determining if it's necessary to challenge previous
-- player's [wild +4] card's legality.
-- @return True if it's necessary to make a challenge.
function AI:needToChallenge()
    local uno = self.uno
    local lastColor = uno:lastColor()
    local next2lastColor = uno:next2lastColor()
    local s1 = uno:getNextPlayer():getHandSize()
    local s2 = uno:getCurrPlayer():getHandSize()

    -- Challenge when defending my UNO dash
    -- Challenge when I have 10 or more cards already
    -- Challenge when previous player holds 10 or more cards
    -- Challenge when legal color has not been changed
    return s1 == 1 or math.max(s1, s2) >= 10 or lastColor == next2lastColor
end

--- Whether the other card of a two-card hand (`other`) does not conflict with
-- playing `mine` as a 7/0 swap: it cannot be another card of that content, a
-- wild card, or a card in the same color. (Only meaningful for 2-card hands.)
local function otherCardIsFine(hand, mine, mineContent)
    local other = hand[3 - mine]

    return other.content ~= mineContent
        and other.content ~= WILD
        and other.content ~= WILD_DRAW4
        and other.color ~= hand[mine].color
end

--- AI Strategies (Difficulty: EASY). Analyze current player's hand cards,
-- and calculate which is the best card to play out.
function AI:easyAI_bestCardIndex4NowPlayer()
    local uno = self.uno
    local nxt, oppo, prev = uno:getNextPlayer(), uno:getOppoPlayer(), uno:getPrevPlayer()
    local nextStrong, oppoStrong, prevStrong = nxt:getStrongColor(), oppo:getStrongColor(), prev:getStrongColor()
    local hand = uno:getCurrPlayer():getHandCards()
    local yourSize = #hand

    if yourSize == 1 then
        -- Only one card remained. Play it when it's legal.
        return uno:isLegalToPlay(hand[1]) and 1 or 0, hand[1].color
    end

    local lastColor = uno:lastColor()
    local bestColor = self:calcBestColor4NowPlayer()
    local iBest, i0, i7, iNM, iRV, iSK, iDW, iWD, iWD4 = 0, 0, 0, 0, 0, 0, 0, 0, 0
    local matches = 0

    for i = 1, yourSize do
        -- Index of any kind
        local card = hand[i]
        local c = card.content

        if card.color == lastColor then
            matches = matches + 1
        end

        if uno:isLegalToPlay(card) then
            if c == DRAW2 then
                if iDW == 0 or card.color == bestColor then iDW = i end
            elseif c == SKIP then
                if iSK == 0 or card.color == bestColor then iSK = i end
            elseif c == REV then
                if iRV == 0 or card.color == bestColor then iRV = i end
            elseif c == WILD then
                iWD = i
            elseif c == WILD_DRAW4 then
                iWD4 = i
            elseif c == NUM7 and uno:isSevenZeroRule() then
                if i7 == 0 or card.color == bestColor then i7 = i end
            elseif c == NUM0 and uno:isSevenZeroRule() then
                if i0 == 0 or card.color == bestColor then i0 = i end
            else -- number cards
                if iNM == 0 or card.color == bestColor then iNM = i end
            end
        end
    end

    -- Decision tree
    local nextSize, oppoSize, prevSize = nxt:getHandSize(), oppo:getHandSize(), prev:getHandSize()

    if nextSize == 1 then
        -- Strategies when your next player remains only one card.
        -- Firstly consider to use a 7 to steal the UNO, if can't,
        -- limit your next player's action as well as you can.
        if i7 > 0 and (yourSize > 2 or otherCardIsFine(hand, i7, NUM7)) then
            iBest = i7
        elseif i0 > 0 and (yourSize > 2 or otherCardIsFine(hand, i0, NUM0)) then
            iBest = i0
        elseif iDW > 0 then
            iBest = iDW
        elseif iSK > 0 then
            iBest = iSK
        elseif iRV > 0 then
            iBest = iRV
        elseif iWD4 > 0 and matches == 0 then
            iBest = iWD4
        elseif iWD > 0 and lastColor ~= bestColor then
            iBest = iWD
        elseif iWD4 > 0 and lastColor ~= bestColor then
            iBest = iWD4
        elseif iNM > 0 and hand[iNM].color ~= nextStrong then
            iBest = iNM
        elseif iWD > 0 and (i7 > 0 or i0 > 0) then
            iBest = iWD
        end
    elseif prevSize == 1 then
        -- Strategies when your previous player remains only one card.
        -- Consider to use a 0 or 7 to steal the UNO.
        if i0 > 0 then
            iBest = i0
        elseif i7 > 0 then
            iBest = i7
        elseif iNM > 0 and hand[iNM].color ~= prevStrong then
            iBest = iNM
        elseif iSK > 0 and hand[iSK].color ~= prevStrong then
            iBest = iSK
        elseif iDW > 0 and hand[iDW].color ~= prevStrong then
            iBest = iDW
        elseif iWD > 0 and lastColor ~= bestColor then
            iBest = iWD
        elseif iWD4 > 0 and lastColor ~= bestColor then
            iBest = iWD4
        elseif iNM > 0 then
            iBest = iNM
        end
    elseif oppoSize == 1 then
        -- Strategies when your opposite player remains only one card.
        -- Consider to use a 7 to steal the UNO.
        if i7 > 0 then
            iBest = i7
        elseif i0 > 0 then
            iBest = i0
        elseif iNM > 0 and hand[iNM].color ~= oppoStrong then
            iBest = iNM
        elseif iRV > 0 and prevSize > nextSize then
            iBest = iRV
        elseif iSK > 0 and hand[iSK].color ~= oppoStrong then
            iBest = iSK
        elseif iDW > 0 and hand[iDW].color ~= oppoStrong then
            iBest = iDW
        elseif iWD > 0 and lastColor ~= bestColor then
            iBest = iWD
        elseif iWD4 > 0 and lastColor ~= bestColor then
            iBest = iWD4
        elseif iNM > 0 then
            iBest = iNM
        end
    else
        -- Normal strategies
        if i0 > 0 and hand[i0].color == prevStrong then
            iBest = i0
        elseif i7 > 0 and (hand[i7].color == prevStrong
            or hand[i7].color == oppoStrong
            or hand[i7].color == nextStrong) then
            iBest = i7
        elseif iRV > 0 and (prevSize > nextSize or prev:getRecent() == nil) then
            iBest = iRV
        elseif iNM > 0 then
            iBest = iNM
        elseif iSK > 0 then
            iBest = iSK
        elseif iDW > 0 then
            iBest = iDW
        elseif iRV > 0 then
            iBest = iRV
        elseif iWD > 0 then
            iBest = iWD
        elseif iWD4 > 0 then
            iBest = iWD4
        elseif i0 > 0 and (yourSize > 2 or otherCardIsFine(hand, i0, NUM0)) then
            iBest = i0
        elseif i7 > 0 then
            iBest = i7
        end
    end

    return iBest, bestColor
end

--- AI Strategies (Difficulty: HARD). Analyze current player's hand cards,
-- and calculate which is the best card to play.
function AI:hardAI_bestCardIndex4NowPlayer()
    local uno = self.uno
    local nxt, oppo, prev = uno:getNextPlayer(), uno:getOppoPlayer(), uno:getPrevPlayer()
    local nextWeak = nxt:getWeakColor()
    local nextStrong, oppoStrong, prevStrong = nxt:getStrongColor(), oppo:getStrongColor(), prev:getStrongColor()
    local hand = uno:getCurrPlayer():getHandCards()
    local yourSize = #hand

    if yourSize == 1 then
        -- Only one card remained. Play it when it's legal.
        return uno:isLegalToPlay(hand[1]) and 1 or 0, hand[1].color
    end

    local allWild = true
    local lastColor = uno:lastColor()
    local bestColor = self:calcBestColor4NowPlayer()
    local iBest, iRV, iSK, iDW, iWD, iWD4 = 0, 0, 0, 0, 0, 0
    local matches = 0
    local cands = {}

    self.candidates = cands
    for i = 1, yourSize do
        -- Index of any kind
        local card = hand[i]
        local c = card.content

        allWild = allWild and card:isWild()
        if card.color == lastColor then
            matches = matches + 1
        end

        if uno:isLegalToPlay(card) then
            if c == DRAW2 then
                if iDW == 0 or card.color == bestColor then iDW = i end
            elseif c == SKIP then
                if iSK == 0 or card.color == bestColor then iSK = i end
            elseif c == REV then
                if iRV == 0 or card.color == bestColor then iRV = i end
            elseif c == WILD then
                iWD = i
            elseif c == WILD_DRAW4 then
                iWD4 = i
            else -- number cards
                cands[#cands + 1] = { score = candidateScore(uno, card, i, bestColor), idx = i }
            end
        end
    end

    sortCandidates(self)

    -- Decision tree
    local nextSize, oppoSize, prevSize = nxt:getHandSize(), oppo:getHandSize(), prev:getHandSize()

    if nextSize == 1 then
        -- Strategies when your next player remains only one card.
        -- Limit your next player's action as well as you can.
        if iDW > 0 then
            iBest = iDW
        elseif lastColor == nextStrong then
            -- Priority when next called Uno & lastColor == nextStrong:
            -- 0: Number cards, NOT in color of nextStrong
            -- 1: Skip cards, in any color
            -- 2: Wild cards, switch to your best color
            -- 3: Wild +4 cards, switch to your best color
            -- 4: Reverse cards, in any color
            -- 5: Draw one, and pray to get one of the above...
            iBest = firstCandidateNot(self, hand, nextStrong)
            if iBest == 0 and iSK > 0 then iBest = iSK end
            if iBest == 0 and iWD > 0 then iBest = iWD end
            if iBest == 0 and iWD4 > 0 then iBest = iWD4 end
            if iBest == 0 and iRV > 0 then iBest = iRV end
        elseif nextStrong ~= NONE then
            -- Priority when next called Uno & lastColor != nextStrong:
            -- (nextStrong is known)
            -- 0: Number cards, NOT in color of nextStrong
            -- 1: Reverse cards, NOT in color of nextStrong
            -- 2: Skip cards, NOT in color of nextStrong
            -- 3: Draw one because it's not necessary to use wild cards
            iBest = firstCandidateNot(self, hand, nextStrong)
            if iBest == 0 and iRV > 0 and prevSize >= 4 and hand[iRV].color ~= nextStrong then
                iBest = iRV
            end
            if iBest == 0 and iSK > 0 and hand[iSK].color ~= nextStrong then
                iBest = iSK
            end
        else
            -- Priority when next called Uno & nextStrong is unknown:
            -- 0: Skip cards, in any color
            -- 1: Reverse cards, in any color
            -- 2: Wild +4 cards, if no cards matching last color
            -- 3: Number cards, in your best color
            -- 4: Wild cards, switch to your best color
            -- 5: Wild +4 cards, switch to your best color
            -- 6: Number cards, in any color
            if iSK > 0 then iBest = iSK end
            if iBest == 0 and iRV > 0 then iBest = iRV end
            if iBest == 0 and iWD4 > 0 and matches == 0 then iBest = iWD4 end
            if iBest == 0 and topCandidateIs(self, hand, bestColor) then iBest = topCandidate(self) end
            if iBest == 0 and iWD > 0 then iBest = iWD end
            if iBest == 0 and iWD4 > 0 then iBest = iWD4 end
            if iBest == 0 then iBest = topCandidate(self) end
        end
    elseif prevSize == 1 then
        -- Strategies when your previous player remains only one card.
        -- Save your action cards as much as you can, because once a reverse
        -- card is put down, you can use these cards to limit your previous
        -- player's action.
        if lastColor == prevStrong then
            -- Priority when prev called Uno & lastColor == prevStrong:
            -- 0: Skip cards, NOT in color of prevStrong
            -- 1: Wild cards, switch to your best color
            -- 2: Wild +4 cards, switch to your best color
            -- 3: Number cards, in any color, but firstly your best color
            -- 4: Draw one because it's not necessary to use other cards
            if iSK > 0 and hand[iSK].color ~= prevStrong then iBest = iSK end
            if iBest == 0 and iWD > 0 then iBest = iWD end
            if iBest == 0 and iWD4 > 0 then iBest = iWD4 end
            if iBest == 0 then iBest = topCandidate(self) end
        elseif prevStrong ~= NONE then
            -- Priority when prev called Uno & lastColor != prevStrong:
            -- (prevStrong is known)
            -- 0: Reverse cards, NOT in color of prevStrong
            -- 1: Number cards, NOT in color of prevStrong
            -- 2: Draw one because it's not necessary to use other cards
            if iRV > 0 and hand[iRV].color ~= prevStrong then iBest = iRV end
            if iBest == 0 then iBest = firstCandidateNot(self, hand, prevStrong) end
        else
            -- Priority when prev called Uno & prevStrong is unknown:
            -- 0: Number cards, in your best color
            -- 1: Wild cards, switch to your best color
            -- 2: Wild +4 cards, switch to your best color
            -- 3: Number cards, in any color
            -- 4: Draw one. DO NOT PLAY REVERSE CARDS!
            if topCandidateIs(self, hand, bestColor) then iBest = topCandidate(self) end
            if iBest == 0 and iWD > 0 and lastColor ~= bestColor then iBest = iWD end
            if iBest == 0 and iWD4 > 0 and lastColor ~= bestColor then iBest = iWD4 end
            if iBest == 0 then iBest = topCandidate(self) end
        end
    elseif oppoSize == 1 then
        -- Strategies when your opposite player remains only one card.
        -- Give more freedom to your next player, the only one that can
        -- directly limit your opposite player's action.
        if lastColor == oppoStrong then
            -- Priority when oppo called Uno & lastColor == oppoStrong:
            -- 0: Number cards, NOT in color of oppoStrong
            -- 1: Reverse cards, NOT in color of oppoStrong
            -- 2: Skip cards, NOT in color of oppoStrong
            -- 3: +2 cards, NOT in color of oppoStrong
            -- 4: Wild cards, switch to your best color
            -- 5: Wild +4 cards, switch to your best color
            -- 6: Reverse cards, in color of oppoStrong
            --    (only when prevSize > nextSize)
            --    (pray that prev can limit oppo!)
            -- 7: Number cards, in color of oppoStrong
            --    (pray that next can limit oppo!)
            iBest = firstCandidateNot(self, hand, oppoStrong)
            if iBest == 0 and iRV > 0 and hand[iRV].color ~= oppoStrong then iBest = iRV end
            if iBest == 0 and iSK > 0 and hand[iSK].color ~= oppoStrong then iBest = iSK end
            if iBest == 0 and iDW > 0 and hand[iDW].color ~= oppoStrong then iBest = iDW end
            if iBest == 0 and iWD > 0 then iBest = iWD end
            if iBest == 0 and iWD4 > 0 then iBest = iWD4 end
            if iBest == 0 and iRV > 0 and prevSize > nextSize then iBest = iRV end
            if iBest == 0 then iBest = topCandidate(self) end
        elseif oppoStrong ~= NONE then
            -- Priority when oppo called Uno & lastColor != oppoStrong:
            -- (oppoStrong is known)
            -- 0: Number cards, NOT in color of oppoStrong
            -- 1: Reverse cards, NOT in color of oppoStrong
            -- 2: Skip cards, NOT in color of oppoStrong
            -- 3: +2 cards, NOT in color of oppoStrong
            -- 4: Draw one because it's not necessary to use other cards
            iBest = firstCandidateNot(self, hand, oppoStrong)
            if iBest == 0 and iRV > 0 and hand[iRV].color ~= oppoStrong then iBest = iRV end
            if iBest == 0 and iSK > 0 and hand[iSK].color ~= oppoStrong then iBest = iSK end
            if iBest == 0 and iDW > 0 and hand[iDW].color ~= oppoStrong then iBest = iDW end
        else
            -- Priority when oppo called Uno & oppoStrong is unknown:
            -- 0: Reverse cards, in any color
            --    (only when prevSize > nextSize)
            -- 1: Number cards, in any color, but firstly your best color
            -- 2: Wild cards, switch to your best color
            -- 3: Wild +4 cards, switch to your best color
            -- 4: Draw one because it's not necessary to use other cards
            if iRV > 0 and prevSize > nextSize then iBest = iRV end
            if iBest == 0 then iBest = topCandidate(self) end
            if iBest == 0 and iWD > 0 and lastColor ~= bestColor then iBest = iWD end
            if iBest == 0 and iWD4 > 0 and lastColor ~= bestColor and nextSize <= 4 then iBest = iWD4 end
        end
    elseif allWild then
        -- Strategies when you remain only wild cards.
        -- When your next player remains only a few cards, use [Wild +4]
        -- cards at first. Otherwise, use [Wild] cards at first.
        if nextSize <= 4 then
            iBest = iWD4 == 0 and iWD or iWD4
        else
            iBest = iWD > 0 and iWD or iWD4
        end
    elseif lastColor == nextWeak and yourSize > 2 then
        -- Strategies when your next player drew a card in its last action.
        -- Unless keeping or changing to your best color, you do not need to
        -- play your limitation/wild cards. Use them in more dangerous cases.
        -- Priority:
        -- 0: Reverse cards, in any color
        --    (only when prevSize > nextSize)
        -- 1: Number cards, in (nextWeak > bestColor > others)
        -- 2: Reverse cards, in any color
        -- 3: Skip cards, in your best color
        -- 4: +2 cards, in your best color
        if iRV > 0 and prevSize > nextSize then iBest = iRV end
        if iBest == 0 then iBest = firstCandidateIs(self, hand, nextWeak) end
        if iBest == 0 then iBest = topCandidate(self) end
        if iBest == 0 and iRV > 0 and (prevSize >= 4 or prev:getRecent() == nil) then iBest = iRV end
        if iBest == 0 and iSK > 0 and oppoSize >= 3 and hand[iSK].color == bestColor then iBest = iSK end
        if iBest == 0 and iDW > 0 and oppoSize >= 3 and hand[iDW].color == bestColor then iBest = iDW end
    else
        -- Normal strategies
        -- Priority:
        -- 0: +2 cards, in any color, when nextSize <= 4
        -- 1: Skip cards, in any color, when nextSize <= 4
        -- 2: Reverse cards, in any color, when prevSize > nextSize,
        --    or prev drew a card in its last action
        -- 3: Number cards, in any color, but firstly your best color
        -- 4: Skip cards, in your best color
        -- 5: +2 cards, in your best color
        -- 6: Wild cards, switch to your best color, when nextSize <= 4
        -- 7: Wild +4 cards, switch to your best color, when nextSize <= 4
        -- 8: Wild +4 cards, when yourSize == 2 && prevSize <= 3 (UNO dash!)
        -- 9: Wild cards, when yourSize == 2 && prevSize <= 3 (UNO dash!)
        if (iDW > 0 or iSK > 0) and nextSize <= 4 and nextSize - oppoSize <= 1 then
            iBest = math.max(iDW, iSK)
        end
        if iBest == 0 and iRV > 0 and (prevSize > nextSize or prev:getRecent() == nil) then iBest = iRV end
        if iBest == 0 then iBest = topCandidate(self) end
        if iBest == 0 and iRV > 0 and prevSize >= 4 then iBest = iRV end
        if iBest == 0 and iSK > 0 and oppoSize >= 3 and hand[iSK].color == bestColor then iBest = iSK end
        if iBest == 0 and iDW > 0 and oppoSize >= 3 and hand[iDW].color == bestColor then iBest = iDW end
        if iBest == 0 and iWD > 0 and nextSize <= 4 then iBest = iWD end
        if iBest == 0 and iWD4 > 0 and nextSize <= 4 then iBest = iWD4 end
        if iBest == 0 and iWD4 > 0 and yourSize == 2 and prevSize <= 3 then iBest = iWD4 end
        if iBest == 0 and iWD > 0 and yourSize == 2 and prevSize <= 3 then iBest = iWD end
        if iBest == 0 and yourSize == Uno.MAX_HOLD_CARDS then
            -- When you are holding 26 cards, which means you cannot hold
            -- more cards, you need to play your action/wild cards to keep
            -- game running, even if it's not worth enough to use them.
            if iSK > 0 then
                iBest = iSK
            elseif iDW > 0 then
                iBest = iDW
            elseif iRV > 0 then
                iBest = iRV
            elseif iWD > 0 then
                iBest = iWD
            elseif iWD4 > 0 then
                iBest = iWD4
            end
        end
    end

    return iBest, bestColor
end

--- AI Strategies in 2vs2 special rule. Analyze current player's hand cards,
-- and calculate which is the best card to play out.
function AI:teamAI_bestCardIndex4NowPlayer()
    local uno = self.uno
    local nxt, oppo, prev = uno:getNextPlayer(), uno:getOppoPlayer(), uno:getPrevPlayer()
    local nextStrong, oppoStrong, prevStrong = nxt:getStrongColor(), oppo:getStrongColor(), prev:getStrongColor()
    local hand = uno:getCurrPlayer():getHandCards()
    local yourSize = #hand

    if yourSize == 1 then
        -- Only one card remained. Play it when it's legal.
        return uno:isLegalToPlay(hand[1]) and 1 or 0, hand[1].color
    end

    local lastColor = uno:lastColor()
    local bestColor = self:calcBestColor4NowPlayer()
    local iBest, iRV, iSK, iDW, iWD, iWD4 = 0, 0, 0, 0, 0, 0
    local matches = 0
    local cands = {}

    self.candidates = cands
    for i = 1, yourSize do
        -- Index of any kind
        local card = hand[i]
        local c = card.content

        if card.color == lastColor then
            matches = matches + 1
        end

        if uno:isLegalToPlay(card) then
            if c == DRAW2 then
                if iDW == 0 or card.color == bestColor then iDW = i end
            elseif c == SKIP then
                if iSK == 0 or card.color == bestColor then iSK = i end
            elseif c == REV then
                if iRV == 0 or card.color == bestColor then iRV = i end
            elseif c == WILD then
                iWD = i
            elseif c == WILD_DRAW4 then
                iWD4 = i
            else -- number cards
                cands[#cands + 1] = { score = candidateScore(uno, card, i, bestColor), idx = i }
            end
        end
    end

    sortCandidates(self)

    -- Decision tree
    local nextSize, oppoSize, prevSize = nxt:getHandSize(), oppo:getHandSize(), prev:getHandSize()

    if nextSize == 1 then
        -- Strategies when your next player remains only one card.
        -- Limit your next player's action as well as you can.
        if iDW > 0 then iBest = iDW end
        if iBest == 0 and iSK > 0 then iBest = iSK end
        if iBest == 0 and iRV > 0 then iBest = iRV end
        if iBest == 0 and iWD4 > 0 and matches == 0 then iBest = iWD4 end
        if iBest == 0 and iWD > 0 and lastColor ~= bestColor then iBest = iWD end
        if iBest == 0 and iWD4 > 0 and lastColor ~= bestColor then iBest = iWD4 end
        if iBest == 0 then iBest = firstCandidateNot(self, hand, nextStrong) end
        if iBest == 0 and iWD > 0 then iBest = iWD end
    elseif prevSize == 1 then
        -- Strategies when your previous player remains only one card.
        iBest = firstCandidateNot(self, hand, prevStrong)
        if iBest == 0 and iSK > 0 and hand[iSK].color ~= prevStrong then iBest = iSK end
        if iBest == 0 and iDW > 0 and hand[iDW].color ~= prevStrong then iBest = iDW end
        if iBest == 0 and iWD > 0 and lastColor ~= bestColor then iBest = iWD end
        if iBest == 0 and iWD4 > 0 and lastColor ~= bestColor then iBest = iWD4 end
        if iBest == 0 then iBest = topCandidate(self) end
    elseif oppoSize == 1 then
        -- Strategies when your team mate remains only one card.
        if iSK > 0 then iBest = iSK end
        if iBest == 0 and iDW > 0 then iBest = iDW end
        if iBest == 0 and iWD4 > 0 and matches == 0 then iBest = iWD4 end
        if iBest == 0 and iRV > 0 and hand[iRV].color == oppoStrong then iBest = iRV end
        if iBest == 0 then iBest = firstCandidateNot(self, hand, oppoStrong) end
        if iBest == 0 and iWD > 0 and oppoStrong ~= NONE and lastColor ~= oppoStrong then iBest = iWD end
        if iBest == 0 and iRV > 0 and prevSize < nextSize then iBest = iRV end
        if iBest == 0 then iBest = topCandidate(self) end
        if iBest == 0 and iRV > 0 then iBest = iRV end
        if iBest == 0 and iWD > 0 then iBest = iWD end
        if iBest == 0 and iWD4 > 0 then iBest = iWD4 end
    else
        -- Normal strategies
        if iSK > 0 and hand[iSK].color == oppoStrong then iBest = iSK end
        if iBest == 0 and iRV > 0 and (hand[iRV].color == oppoStrong or prev:getRecent() == nil) then
            iBest = iRV
        end
        if iBest == 0 then iBest = topCandidate(self) end
        if iBest == 0 and iSK > 0 then iBest = iSK end
        if iBest == 0 and iDW > 0 then iBest = iDW end
        if iBest == 0 and iRV > 0 then iBest = iRV end
        if iBest == 0 and iWD > 0 and lastColor ~= oppoStrong then iBest = iWD end
        if iBest == 0 and iWD4 > 0 and lastColor ~= oppoStrong then iBest = iWD4 end
    end

    return iBest, bestColor
end

--- AI Strategies in 7-0 special rule. Analyze current player's hand cards,
-- and calculate which is the best card to play out.
function AI:sevenZeroAI_bestCardIndex4NowPlayer()
    local uno = self.uno
    local nxt, oppo, prev = uno:getNextPlayer(), uno:getOppoPlayer(), uno:getPrevPlayer()
    local nextStrong, oppoStrong, prevStrong = nxt:getStrongColor(), oppo:getStrongColor(), prev:getStrongColor()
    local hand = uno:getCurrPlayer():getHandCards()
    local yourSize = #hand

    if yourSize == 1 then
        -- Only one card remained. Play it when it's legal.
        return uno:isLegalToPlay(hand[1]) and 1 or 0, hand[1].color
    end

    local lastColor = uno:lastColor()
    local bestColor = self:calcBestColor4NowPlayer()
    local iBest, i0, i7, iRV, iSK, iDW, iWD, iWD4 = 0, 0, 0, 0, 0, 0, 0, 0
    local matches = 0
    local cands = {}

    self.candidates = cands
    for i = 1, yourSize do
        -- Index of any kind
        local card = hand[i]
        local c = card.content

        if card.color == lastColor then
            matches = matches + 1
        end

        if uno:isLegalToPlay(card) then
            if c == DRAW2 then
                if iDW == 0 or card.color == bestColor then iDW = i end
            elseif c == SKIP then
                if iSK == 0 or card.color == bestColor then iSK = i end
            elseif c == REV then
                if iRV == 0 or card.color == bestColor then iRV = i end
            elseif c == WILD then
                iWD = i
            elseif c == WILD_DRAW4 then
                iWD4 = i
            elseif c == NUM7 then
                if i7 == 0 or card.color == bestColor then i7 = i end
            elseif c == NUM0 then
                if i0 == 0 or card.color == bestColor then i0 = i end
            else -- number cards
                cands[#cands + 1] = { score = candidateScore(uno, card, i, bestColor), idx = i }
            end
        end
    end

    sortCandidates(self)

    -- Decision tree
    local nextSize, oppoSize, prevSize = nxt:getHandSize(), oppo:getHandSize(), prev:getHandSize()

    if nextSize == 1 then
        -- Strategies when your next player remains only one card.
        -- Firstly consider to use a 7 to steal the UNO, if can't,
        -- limit your next player's action as well as you can.
        if i7 > 0 and (yourSize > 2 or otherCardIsFine(hand, i7, NUM7)) then iBest = i7 end
        if iBest == 0 and i0 > 0 and (yourSize > 2 or otherCardIsFine(hand, i0, NUM0)) then iBest = i0 end
        if iBest == 0 and iDW > 0 then iBest = iDW end
        if iBest == 0 and iSK > 0 then iBest = iSK end
        if iBest == 0 and iRV > 0 then iBest = iRV end
        if iBest == 0 and iWD4 > 0 and matches == 0 then iBest = iWD4 end
        if iBest == 0 and iWD > 0 and lastColor ~= bestColor then iBest = iWD end
        if iBest == 0 and iWD4 > 0 and lastColor ~= bestColor then iBest = iWD4 end
        if iBest == 0 then iBest = firstCandidateNot(self, hand, nextStrong) end
        if iBest == 0 and iWD > 0 and (i7 > 0 or i0 > 0) then iBest = iWD end
    elseif prevSize == 1 then
        -- Strategies when your previous player remains only one card.
        -- Consider to use a 0 or 7 to steal the UNO.
        if i0 > 0 then iBest = i0 end
        if iBest == 0 and i7 > 0 then iBest = i7 end
        if iBest == 0 then iBest = firstCandidateNot(self, hand, prevStrong) end
        if iBest == 0 and iSK > 0 and hand[iSK].color ~= prevStrong then iBest = iSK end
        if iBest == 0 and iDW > 0 and hand[iDW].color ~= prevStrong then iBest = iDW end
        if iBest == 0 and iWD > 0 and lastColor ~= bestColor then iBest = iWD end
        if iBest == 0 and iWD4 > 0 and lastColor ~= bestColor then iBest = iWD4 end
        if iBest == 0 then iBest = topCandidate(self) end
    elseif oppoSize == 1 then
        -- Strategies when your opposite player remains only one card.
        -- Consider to use a 7 to steal the UNO.
        if i7 > 0 then iBest = i7 end
        if iBest == 0 and i0 > 0 then iBest = i0 end
        if iBest == 0 then iBest = firstCandidateNot(self, hand, oppoStrong) end
        if iBest == 0 and iRV > 0 and prevSize > nextSize then iBest = iRV end
        if iBest == 0 and iSK > 0 and hand[iSK].color ~= oppoStrong then iBest = iSK end
        if iBest == 0 and iDW > 0 and hand[iDW].color ~= oppoStrong then iBest = iDW end
        if iBest == 0 and iWD > 0 and lastColor ~= bestColor then iBest = iWD end
        if iBest == 0 and iWD4 > 0 and lastColor ~= bestColor then iBest = iWD4 end
        if iBest == 0 then iBest = topCandidate(self) end
    else
        -- Normal strategies
        if i0 > 0 and hand[i0].color == prevStrong then iBest = i0 end
        if iBest == 0 and i7 > 0 and (hand[i7].color == prevStrong
            or hand[i7].color == oppoStrong
            or hand[i7].color == nextStrong) then
            iBest = i7
        end
        if iBest == 0 and iRV > 0 and (prevSize > nextSize or prev:getRecent() == nil) then iBest = iRV end
        if iBest == 0 then iBest = topCandidate(self) end
        if iBest == 0 and iSK > 0 then iBest = iSK end
        if iBest == 0 and iDW > 0 then iBest = iDW end
        if iBest == 0 and iRV > 0 then iBest = iRV end
        if iBest == 0 and iWD > 0 then iBest = iWD end
        if iBest == 0 and iWD4 > 0 then iBest = iWD4 end
        if iBest == 0 and i0 > 0 and (yourSize > 2 or otherCardIsFine(hand, i0, NUM0)) then iBest = i0 end
        if iBest == 0 and i7 > 0 then iBest = i7 end
    end

    return iBest, bestColor
end

return AI
