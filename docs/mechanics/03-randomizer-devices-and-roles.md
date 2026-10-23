# Final review 3: randomizer devices, shared-pile and role mechanics

> Reference spec for `docs/gameversions.md` (see its Part F). **Verified pass (2026-10):** every product in this file was checked against Mattel's official English instruction sheet from service.mattel.com. Rules marked "(sheet CODE)" are quoted or closely paraphrased from that sheet. Anything still marked MED/LOW or "unverified" was not on the sheet. It came from the earlier web-snippet pass or from inference.

Sheets read (all English, from service.mattel.com/instruction_sheets/): J3719 (UNO Spin 2005), N8367 (Disney Hannah Montana UNO Spin, 2008), R2820 (To Go! UNO Spin, 2009), JGR00 (UNO Spin 2025), JJB31 (UNO Spin Adults Only, 2025), T8220 (Roboto), CGH09 (Tiki Twist), P9391 (Eye-Eye, SpongeBob!), DNG26 (Wild Jackpot), Y2316 (Power Grab), CGH10 (Royal Revenge), DWV64 (Colors Rule), HBF06 (Remix), M1002 (Flash), T8221 (Reflex), Y2318 (Blast), GKC04 (Showdown, ©2020), GMX56 (Showdown Supercharged), plus JNK69 (Show 'em No Mercy Attack) for the new-products list. Wikipedia's "Uno Spin" article was used for the wheel layout only.

Confidence tags: **HIGH** = stated on the official sheet (or 2+ independent sources agree). **MED** = one detailed, plausible non-sheet source. **LOW** = thin or inferred.

## Corrections to the survey doc (read these first)

1. **Wild Jackpot (#27) has no shared growing Jackpot pile.** Confirmed (sheet DNG26), HIGH. The unit is a lever-spinner with 6 symbols plus a button that deals player-written Customizable Rule cards. The accumulate-and-dump mechanic belongs to **UNO Blast (#110)** (sheet Y2318).
2. **Power Grab (#104) uses four towers: U, N, O and "!".** Confirmed (sheet Y2316), HIGH. U blocks Draw One, N blocks Draw Two, O blocks Wild Draw Four, "!" blocks Skip. Holding all four gives Instant UNO. There is no Reverse tower.
3. **Spin To Go (#107) is NOT the same wheel as UNO Spin.** It has a different, travel-themed wheel (Gas/Food/Lodging, Scenic View, Cash Machine, Phone Call, Escalator, Taxi/Boat/Plane, Luggage, Recycle, UNO Spin) and special-icon number cards (sheet R2820), HIGH.
4. **UNO Spin Hannah Montana (#137) has its own wheel too** (Draw Star, World Tour, Sweet Niblets!, Draw 2, plus five 2005 outcomes) and 32 "Star" cards (sheet N8367), HIGH. N8367 is this product, not a reprint of the 2005 game.
5. **In UNO Spin 2025 and Adults Only, the player who played the Spin card spins.** In 2005 it was the next player (sheets JGR00, JJB31, J3719), HIGH.
6. **Discarded action cards DO take effect in several device games.** Roboto, Eye-Eye and Wild Jackpot all say so outright, and Spin 2005 lets the spinner pick the top card "affecting the next player's turn." The earlier "do not let a discarded action card trigger" default was wrong for these products. See cross-mechanic note 4.
7. **Royal Revenge is a 56-card deck** with no Draw Two and no Wild Draw Four. The Jester card makes the Jester-hat wearer draw 1 (sheet CGH10), HIGH.
8. **Several device decks are not "108 standard + extras."** Tiki Twist has no Draw Two or Wild Draw Four. Power Grab has no 0s, one Reverse per color and no plain Wild. Blast is 110 cards with no Draw Two or Wild Draw Four. Colors Rule has no 0s and no plain Wild. Spin Adults Only numbers run 0-7 only. Full lists are below.

---

## 1. UNO Spin family

### 1a. UNO Spin 2005 (#15): deck and trigger (sheet J3719)

| Item | Copies | Rule | Conf |
|---|---|---|---|
| Contents | 112 cards = 108 playing cards + **4 Wheel Reference Cards** (not played). 2-10 players. | 19 per color (0-9), "includes 5 Spin Cards #1-5". 8 Draw Two, 8 Reverse, 8 Skip (2 per color), 4 Wild, 4 Wild Draw Four. So Spin cards replace normal 1-5 cards. | HIGH (sheet J3719) |
| Spin card | 20 (numbers 1-5 in each color, swirl around the number) | "A player may play a Spin card as they would a regular number card, however, whenever a Spin card is played, the **next player must spin the wheel**. Spinning the wheel **takes the place of that player's turn**." | HIGH (sheet J3719) |
| Multi-card discards | | "If the Wheel causes you to discard multiple cards, you get to decide which of your cards is placed on the top of the DISCARD pile, affecting the next player's turn. Thus, you can change the color, number or symbol that is in play." | HIGH (sheet J3719) |
| Last card is a Spin card | | "If the last card played is a Spin card, the next player must spin the wheel and that action must be resolved, so that any cards drawn or discarded also affect the points totaled." | HIGH (sheet J3719) |
| Scoring | | Standard: numbers face value; Draw Two, Reverse, Skip 20; Wild, Wild Draw Four 50. 500 to win. Spin cards are number cards (face value). | HIGH (sheet J3719) |

### 1b. UNO Spin 2005: wheel outcomes (sheet J3719)

The sheet lists exactly 9 outcomes. Wikipedia lists the same 9 as the wheel's areas, in clockwise order: UNO Spin, Discard Color, Draw Blue, Draw Red, War, Discard Number, Show Hand, Trade Hands, Almost UNO. **Weight**: assume 1/9 each. That is still LOW, because neither source says the segments are equal.

| Outcome | Official text (sheet J3719) | Conf |
|---|---|---|
| Almost UNO | "The player that spun the wheel discards all but 2 cards." | HIGH |
| Discard Number | "The player that spun the wheel chooses a number in their hand and can discard all cards of that same number. You can choose to keep some cards of that number if you do not wish to discard all of them." | HIGH |
| Discard Color | "The player that spun the wheel **chooses a color in their hand** and can discard all cards of that same color. You can choose to keep some cards of that color if you do not wish to discard all of them." This settles the old conflict: the spinner picks the color. Wikipedia's "color on the discard pile" is wrong. | HIGH |
| Draw Red | "Draw until you pick up a red card (or Wild card). You must keep all of the cards you have drawn." | HIGH |
| Draw Blue | "Draw until you pick up a blue card (or Wild card). You must keep all of the cards you have drawn." | HIGH |
| Trade Hands | "All players trade hands, passing to the left. If any player receives a hand with only one card, that player must yell 'UNO' or the 2-card penalty applies." | HIGH |
| Show Hand | "Show your hand to all other players, giving them an opportunity to see it, and then resume normal play." (The spinner shows.) | HIGH |
| War | "Each player selects the highest number card of any color in their hand (if they have one) and reveals them at the same time. The player with the highest card gets to discard that card and all other players put their cards back in their hands. If there is a tie, the tied players face-off with their next highest card, and the winner discards all the War cards they played. **Play then continues with the next person after the winner** taking their turn (in the current direction of play)." | HIGH |
| UNO Spin | "All players rush to yell 'UNO Spin.' The first player to yell it gets to discard one card of their choice. **Play then continues with the next person after the winner** taking their turn (in the current direction of play)." | HIGH |

"Spin Again", "Hit 5", "UNO Spin Off" and "Wild Spin" are not on any of the three Spin wheels read (J3719, N8367, R2820). Do not implement them as official.

### 1c. UNO Spin Hannah Montana (#137) (sheet N8367, ©2008)

Same rules and deck as 2005, with two differences: (a) all number cards 6-9 are **Star cards** (8 per color, 32 in total), and (b) a different 9-outcome wheel. HIGH (sheet N8367).

| Outcome | Official text (sheet N8367) |
|---|---|
| Almost UNO, Discard Number, Discard Color, Show Hand, UNO Spin | Same wording as 2005. |
| Draw Star | "Draw until you pick up a Star card, which is any card numbered 6 through 9 (or you can draw a Wild card). You must keep all of the cards you have drawn." |
| World Tour | "Send your hand 'on tour' by trading cards with any other player. Lay your hand facedown on the playing area and take any other player's cards. That player may then choose to keep your hand or take another player's cards, and so on. The last player 'on the tour' must take whatever hand is left. Once a player has taken a hand, no other player can take it from them on that tour. When the tour is over, play resumes in the current direction with the player after the spinner taking their turn." |
| Sweet Niblets! | Same as UNO Spin (race to yell "Sweet Niblets!", winner discards one card of their choice, play continues after the winner). |
| Draw 2 | "All players (EXCEPT the player who spun the wheel) must draw 2 cards and add them to their hands." |

### 1d. UNO Spin To Go (#107) (sheet R2820, ©2009)

108 cards (no reference cards; there is 1 Reference Sheet instead), same composition as 2005, with 20 Spin cards (1-5). The next player spins, as in 2005. **Special Number Cards**: gas (#2), food (#5), lodging (#7), taxi (#1), boat (#3), plane (#6) carry icons and match normally. HIGH (sheet R2820).

| Outcome | Official text (sheet R2820) |
|---|---|
| Gas, Food, Lodging | "Draw until you pick up a gas (#2), food (#5) or lodging (#7) card. You must keep all of the cards you have drawn." |
| Scenic View | "You get to view the hand of any player of your choice." |
| Cash Machine | "Draw until you get a green card. You must keep all of the cards you have drawn." (No Wild stop is mentioned.) |
| Phone Call | "'Call' for a Wild card. Starting with the player to your left, if that player has a Wild or a Wild Draw 4 card, they must give it to you. If not, continue calling each player clockwise until you either receive a Wild or you've called everyone and no one has a Wild to give you." |
| UNO Spin | Same as 2005. |
| Escalator | "Discard one card of each color in your hand. You can choose to keep some applicable cards." |
| Taxi, Boat, Plane | "Discard all vehicle cards in your hand: taxi (#1), boat (#3) and plane (#6)." (Optional, like the other discards.) |
| Luggage | "Choose a color in your hand and discard all cards of that same color." (Optional.) |
| Recycle | "Count how many cards you have, discard all of them, and then draw the same amount of cards so that you have a completely new hand." |

Going out (sheet R2820): "It is also possible to go out of the game by discarding or giving away cards due to an action directed by the UNO Spin wheel." The UNO call "also applies if you discard or give away your next-to-last card due to an action directed by the wheel." HIGH.

### 1e. UNO Spin 2025 (#381) (sheet JGR00)

| Item | Detail | Conf |
|---|---|---|
| Contents | "1 UNO Spin Wheel, 112 Cards". The sheet does not give a per-type card list. | HIGH (sheet JGR00) |
| Spin cards | **24**: "Five cards of each color (numbers 1 through 5) and 4 Wild Cards have a swirling pattern." Whether the 4 Spin Wilds are the deck's only plain Wilds is not stated. | HIGH (24); unverified (Wild split) |
| Who spins | "If a player plays a Spin Card, **they** must spin the wheel." The player who played it spins. This is a change from 2005. | HIGH (sheet JGR00) |
| Start card | "If this card is an Action Card, ignore it and flip over the next card." | HIGH |
| WD4 | Wild Draw 4 challenge: if the challenge fails, the challenger draws **6** and loses their turn. If it succeeds, the player of the WD4 draws 4. Action cards may be played on action cards of the same color. Scoring is optional (500). | HIGH |

Wheel outcomes (sheet JGR00), five types. The sheet does not give the segment count or sizes:

| Outcome | Official text | Conf |
|---|---|---|
| Color Draw | "Depending on which color (Red, Blue, Green, Yellow) the Spin Wheel stops on, you must draw cards from the Draw Pile until you get a card of that color. Show it to the other players before adding it (and ALL other cards you have drawn) to your hand." No Wild stop is mentioned. | HIGH (text); segments per color unverified |
| Wild Color Draw | "Choose a color (Red, Blue, Green, Yellow), then draw cards from the Draw Pile until you get a card of that color. Show it to the other players before adding it (and ALL other cards you have drawn) to your hand." The spinner chooses and the spinner draws. | HIGH |
| Color Discard | "Choose a color (Red, Blue, Green, Yellow), then take all cards of that color from your hand and place them on the BOTTOM of the Discard Pile." | HIGH |
| Swap Hands | "Choose another player and swap hands with them." | HIGH |
| 2x | "Beginning with the next player in current order, all players get to play 2 cards on their turn if they are able. This lasts until the wheel is spun again." (The Spanish text says "must" play 2.) | HIGH |

### 1f. UNO Spin Adults Only (#382) (sheet JJB31)

| Item | Detail | Conf |
|---|---|---|
| Contents | "1 UNO Spin Adults Only Wheel, 112 Cards", including **16 Challenge Cards** that are separated out at setup (so 96 UNO cards). 2-8 players, 18+. | HIGH (sheet JJB31) |
| Number range | Scoring says "All number cards (**0-7**)". | HIGH |
| Spin cards | **30**: "Seven cards of each color (numbers 1-3 and a 4) and two WILD cards." The per-color wording is garbled (7 per color, but only 1-4 named). | HIGH (30 total); per-color numbers unverified |
| Who spins | The player who played the Spin card. | HIGH |
| Action cards | Skip, Reverse, **Discard All** (color card: "Discard all the cards in your hand of the same color as the Discard All Card. The Discard All Card is placed on top of all the cards you discard."), Wild, Wild Draw 4 (the 2025 challenge rule: challenger draws 6). Draw Two is not listed as a card. Copy counts are not given. | HIGH (types); counts unverified |
| Scoring | Numbers face value; Skip, Reverse, Discard All 20; Wild, Wild Draw 4 50; 500 to win (optional). | HIGH |

Wheel outcomes (sheet JJB31). The sheet does not give weights:

| Outcome | Official text |
|---|---|
| Draw 2 | "Draw 2 cards from the Draw Pile." (The spinner draws.) |
| Target Draw 2 | "Choose another player who must draw 2 cards. Play then continues after you in current order." |
| Discard 2 | "Discard 2 cards from your hand and place them on the bottom of the Discard Pile." |
| Discard All | "Same as the Discard All Card, only you get to choose the color." |
| Flip for Number | "You must flip over cards from the Draw pile until you get a number card. Now draw that many cards from the Draw pile and add them to your hand." (A 0 means you draw 0.) |
| Target Challenge | "Choose another player to complete any challenge from the top card from the Challenge pile." |
| Challenge A / B / C | Three separate spaces. Draw a Challenge card and do the challenge printed under the letter you landed on. "If you do not successfully complete this challenge, you must Draw 4 cards." The table judges success. Chickening out: "If you are unwilling to perform the challenge, you must draw 4 cards instead." |

That makes 9 named spaces (6 + 3 Challenge letters) if each appears once. Whether any repeat is unverified.

### Edge cases & rulings (Spin family)
- 2005 / Hannah Montana / To Go: spinning *replaces* the next player's turn (sheet). After the outcome, play passes to the player after the spinner, except after War / UNO Spin / Sweet Niblets!, where play continues **after the race winner** (sheet J3719).
- 2025 / Adults Only: the player who played the card spins. After the spin, play presumably passes normally to the next player. Exception: Target Draw 2, where the sheet says "play then continues after you".
- Draw-until outcomes: Draw Red/Blue/Star stop on a Wild too (sheets J3719, N8367). Cash Machine and 2025 Color Draw do not mention Wilds, so they stop only on the color. Reshuffle the discard pile if the draw pile runs out (standard). If no target card exists anywhere, the engine needs a cap. That case is unspecified.
- Multi-card discards in 2005/HM/To Go: the spinner chooses the top card, and it affects the next player (sheet). In 2025 and Adults Only, discarded cards go on the bottom, so the top card never changes. The Adults-Only *Discard All card* is the exception: it goes on top of the discards.
- Any outcome that leaves 1 card means an UNO call is needed (To Go and 2005 Trade Hands state this explicitly). Any outcome that leaves 0 cards means the spinner goes out (sheet R2820 states this explicitly).
- The "UNO Spin" / "Sweet Niblets!" race needs a real-time button, or the AI resolves it randomly or by simulated reaction time.
- 2x persists across turns, so it is game state that the next spin must clear.

---

## 2. UNO Roboto (#103), UNO Tiki Twist (#106), UNO Eye-Eye SpongeBob (#111)

### 2a. UNO Roboto (sheet T8220, ©2010)

| Element | Detail | Conf |
|---|---|---|
| Contents | 112 cards = standard 108 + **4 House Rule cards**. 2-6 players. The House Rule cards "are not used in play". "They are reference sheets that provide different examples of House Rules" (e.g. "Dance Craze: Do a Hula Dance / the Chicken Dance / the Robot / the Twist"). | HIGH (sheet T8220) |
| Setup | Each player records their name (up to 3 s). Roboto calls one player to record **one House Rule per game** (max 10 s). This step can be skipped. Action cards turned up as the start card go back into the draw pile. Roboto names the **first player**, and play is clockwise. | HIGH |
| Trigger | "Whenever you place a card (or cards) on the DISCARD pile during normal play, press the Discard Plate ONE time." Do not press it for Surprise-Command discards. Roboto "will interrupt your game **from time to time**". The frequency and per-press odds are **not stated**. | HIGH (trigger point); frequency unverified |
| Surprise Commands (officially described) | (1) One player records a **nickname** for another, which Roboto uses for the rest of the game (flavor only). (2) **Duel**: two named players race to complete the challenge he sets, and "the loser of the duel must draw 2 cards". (3) The sheet's worked example: "Nicole, discard all your red cards!" | HIGH (these three) |
| Surprise Commands (not on the sheet) | Two named players **swap hands**; named player gets an **extra turn**. These came from blogs and reviews only. | MED, unverified |
| After a Surprise Command | "UNO Roboto will also call out the name of a player to continue the game." So the next player is chosen by the device and can be anyone. | HIGH |
| Discards from a command | "If a Surprise Command causes a new card to be placed on the DISCARD pile, the new card **cancels any card it covers up** and it then affects whichever player resumes play." Example: a red Draw 2 discarded on top of a Wild Draw 4 cancels the +4, and the resuming player draws 2. | HIGH |
| House Rule | "When you least expect it": all players race to do the recorded House Rule, and "the last player to finish must draw 2 cards". Then Roboto "will call on a **random player** to continue play". | HIGH |
| UNO call | If a command lets you discard all remaining cards, "you must discard each card one at a time and you must say 'UNO!' after discarding your next to last card." | HIGH |
| WD4 challenge | Standard: guilty player draws 4; innocent means the challenger draws 6. | HIGH |

### 2b. UNO Tiki Twist (sheet CGH09, ©2014)

| Element | Copies | Effect | Conf |
|---|---|---|---|
| Deck | 112 | 19 per color 0-9 (76), **8 Reverse, 8 Skip** (2 per color), **4 Wild, 16 Tiki cards**, plus the Tiki Idol Spinner. **No Draw Two and no Wild Draw Four.** 2-10 players. | HIGH (sheet CGH09) |
| Spin symbol on regular cards | Count **not given** | "Whenever a card with a Spin symbol is played, **that player** must spin the Tiki Idol. Whoever the Tiki Idol's hand is pointing to when the spinning stops must perform the action on the Tiki Face card showing in the Tiki Idol." | HIGH (rule); count unverified |
| Tiki Face card (playing one) | 16 Tiki cards; per-type split **not given** | "On your turn, instead of placing a card on the discard pile, you may choose to play a Tiki Face card. You may play a Tiki Face card on your turn even if you have another playable card in your hand. Place the card face-up INSIDE the Tiki Idol so all players can see it. **Spin the Tiki Idol** and when it stops, whoever the Tiki Idol's hand is pointing to must perform the action on the card." The new face replaces the old one, and the top discard does not change. | HIGH |
| Tiki Face actions | | **Draw 1** / **Draw 2** / **Draw 4**: "the chosen player must draw N card(s)". **Discard 2**: "the chosen player may discard any 2 cards of their choice." **Discard All**: "the chosen player may discard all of the cards of the color indicated" (so Discard All faces are color-specific, e.g. "discard all yellow cards"). **Go To**: "play IMMEDIATELY continues with the chosen player and they lay down the next card to continue game play. If the player has no card in his hand to play, he must draw a card." | HIGH |
| Persistent face | | "Each time another card with a Spin icon is played, the idol is spun and [the same action happens]. This will only change when someone plays a DIFFERENT Tiki Face card in the Tiki Idol." | HIGH |
| Start card | | A Tiki Face start card goes in the idol and another card is drawn to start the discard pile. | HIGH |
| Spin validity | | Less than 1 full revolution means re-spin. If it stops between two players, "the player who spun the idol gets to decide". | HIGH |
| Impossible actions | | "In most cases, if the player is unable to perform the action, they are not penalized." The exception is Go To (draw 1). "Once the action has been completed, play resumes in the CURRENT ORDER unless the action ... is 'Go To'." | HIGH |
| Reshuffle | | When the draw pile runs out, reshuffle the discard pile "AND all Tiki Face Cards inside the Tiki idol (except the one showing)". | HIGH |
| Scoring | | Numbers face value; Reverse, Skip, **Tiki 20**; **Wild Tiki 50**; 500 to win. (The contents list says "4 Wild Cards" and the scoring list says "Wild Tiki". These are probably the same 4 cards.) | HIGH (values); LOW (Wild = Wild Tiki) |

### 2c. UNO Eye-Eye, SpongeBob! (sheet P9391, ©2008)

| Element | Detail | Conf |
|---|---|---|
| Deck | 112 = standard 108 (19 per color 0-9 "includes 5 Eyeball Cards #1-5", 8 Draw Two, 8 Reverse, 8 Skip, 4 Wild, 4 Wild Draw Four) + **4 Reference cards ("Cheat Sheets")**. Eyeball cards are number cards 1-5 (20 in total). 2-10 players. | HIGH (sheet P9391) |
| Trigger | The player of an Eyeball card pushes SpongeBob's nose, and both eyes spin. "The LEFT eye indicates which player will perform an action; the RIGHT eye reveals what action that player will perform." | HIGH |
| Left eye (WHO) | **GREEN**: "Any player of your choice acts". **BLACK**: "No player acts". **RED**: "You act" (the spinner). | HIGH |
| Right eye (WHAT) | **Draw 4 cards**. **Discard 1 card**. **Draw cards until a Yellow, Blue or Wild card is drawn**. | HIGH |
| Outcome table | 3 × 3 = 9 combinations. Every BLACK result is "Nothing happens. Play continues as normal." Weights are not stated. Assume 1/3 per eye, independent (LOW). | HIGH (table); LOW (weights) |
| After the action | "Play resumes with the player after you (the spinner) taking their turn (even if the next player was the one you chose to draw or discard). If an Action Card had been discarded due to the spinning ..., the next player must also follow the direction of that card." | HIGH |
| Going out on an Eyeball card | "You still have to spin his eyeballs and that action must be completed." If it makes you draw, you have not won yet. If it says discard, "you still won since you don't have any cards left". | HIGH |
| Start card | An Eyeball start card is "a normal number card". | HIGH |
| Scoring | Standard values, 500 to win. | HIGH |

### Edge cases & rulings (device family)
- Roboto: random command, random targets, random next player, unknown frequency. Tiki Twist: deterministic, visible action (the current face) + random target. Eye-Eye: two independent 3-way rolls.
- A random target can be the triggering player: Tiki (the idol can point at the spinner), Eye-Eye (RED = spinner; GREEN lets the spinner pick anyone).
- Tiki "Go To" and Roboto "name the next player" move the turn pointer. The next turn is counted from the new player, in the current direction.
- Roboto duels and the House Rule race need real-time input or simulation.

---

## 3. UNO Wild Jackpot (#27) (sheet DNG26, ©2016)

| Item | Copies | Effect | Conf |
|---|---|---|---|
| Deck | 108 | **15 per color "0 to 9"** (60; which numbers are duplicated is not stated), 8 Draw Two, 8 Reverse, 8 Skip (2 per color), **2 Wild**, 4 Wild Draw Four, **16 Jackpot (4 per color)**, **2 Wild Jackpot**. Also 1 Wild Jackpot unit, 8 Customizable Rule cards, 2 markers. | HIGH (sheet DNG26) |
| Customizable Rule cards | 8 | Dealt out equally to the players at setup (leftovers set aside). Each player writes a rule on theirs. They are shuffled and loaded into the dispenser, never into the draw pile. The sheet's suggestion list: discard until you have 2 cards; play as many cards in a row as you can; draw until you have 7 cards; play all of your Wild cards; take 2 cards from the player with the most cards; make chicken noises until your next turn; hug the player with the most cards; high-five everyone with your feet. | HIGH |
| Jackpot card | 16 | "When you play this card, you get to pull the Wild Jackpot lever. This card may only be played on a matching color or on another Jackpot card." | HIGH |
| Wild Jackpot card | 2 | Pull the lever. Playable "ON ANY TURN, even if you have another playable card". "The player who played it gets to name the color." | HIGH |
| After the lever | | "Play continues with the next player in the current direction of play." | HIGH |
| Used rule cards | | "Place any used custom rule cards in a pile behind the Wild Jackpot unit. If you run out of custom rule cards, shuffle the used cards and load them back into the unit." So each rule is one-shot. | HIGH |
| Start card | | If **a Jackpot or a Wild Jackpot** is turned up, "the person to the left of the dealer chooses any player at the table, THEN presses the button ... The chosen player must then perform the rule." | HIGH |
| Scoring | | Standard values, plus **Jackpot 40** and **Wild Jackpot 50**. 500 to win. | HIGH |

**Spinner symbols (6)** (sheet DNG26). Weight: assume 1/6 each (LOW, not stated).

| # | Official text |
|---|---|
| 1 | "Choose any player (even yourself). Press the button on the front of the unit to deal a Customizable Rule card. The chosen player must perform the rule written on that card." |
| 2 | "Press the button ... to deal a Customizable Rule card. The player on your RIGHT must perform the rule written on that card." |
| 3 | "... The player on your LEFT must perform the rule written on that card." |
| 4 | "Press the button ... to deal EACH PLAYER a Customizable Rule card. Starting with you, each player must perform the rule written on that card." |
| 5 | "You may discard UP TO one card of EACH COLOR in your hand to the DISCARD pile. You can play the cards in any order you like. If any of the cards you play are action cards, **each one will affect the next player**." |
| 6 | "Draw 4 cards from the DRAW pile." (The puller draws.) |

There is no separate "UNO Wild Jackpot!" symbol. That was marketing copy.

### Edge cases & rulings
- A dealt rule is **one-shot** (sheet). Free text can't run in a port, so model the rule deck as a fixed menu of parameterized one-shot effects. The sheet's 8 suggestions are a good starting menu.
- Symbol 5 stacks action effects: "each one will affect the next player". So two Draw Twos discarded this way mean the next player draws 4, presumably and loses their turn once. Skip + Reverse order matters ("in any order you like").
- There is still **no Jackpot pile**. If the project wants a "growing shared pile", credit it to UNO Blast (section 8c).

---

## 4. UNO Power Grab (#104) (sheet Y2316, ©2012)

| Item | Copies | Effect | Conf |
|---|---|---|---|
| Components | 112 cards, 4 Power Towers (U red, N blue, O green, ! yellow), 1 Play Tray. 2-6 players. | | HIGH (sheet Y2316) |
| Number cards | **18 per color, 1 to 9** (72; i.e. two of each number, **no 0s**) | Standard. | HIGH |
| Power-icon cards | "Each of the four (4) Power Icons appears twice in each of the four color suits" = 32 number cards | Playing one lets you claim that tower from anyone or from the neutral spot. "The color of the Power Tower does NOT have to match the color of the Power Icon card played." "You may NOT match cards by the Power Icon." Which numbers carry icons is not stated. | HIGH |
| Draw One | 8 (2 per color) | "The next player must draw 1 card and miss their turn." | HIGH |
| Draw Two | 8 (2 per color) | Standard. | HIGH |
| Skip | 8 (2 per color) | Standard. | HIGH |
| Reverse | **4 (1 per color)** | Standard. | HIGH |
| Grab-2-Towers | 4 (1 per color) | "Grab any two (2) Power Towers of your choosing", from players, the neutral spot, or both. Colored, so it matches by color or symbol. As the start card: "the first player does not get to grab Towers but matches this card by color only." | HIGH |
| Wild Grab-A-Tower | 4 | Grab any one tower; it is also a Wild (choose the color). As the start card: no grab, but the first player chooses the color. | HIGH |
| Wild Draw Four | 4 | Standard, with the challenge (innocent means the challenger draws 6). | HIGH |
| Plain Wild | **0** | There is no plain Wild card in this deck. | HIGH |
| **U / N / O / ! towers** | | "When you possess a Power Tower, you have protection against the corresponding Action Card ... you have the power to block it: You don't have to perform the action, whether it is to draw cards or skip." U = Draw One, N = Draw Two, O = Wild Draw Four, ! = Skip. | HIGH |
| All 4 towers: Instant UNO | | "If you are skillful enough to have all 4 Power Towers in your possession, you get to discard all of your cards EXCEPT one (you must still yell 'UNO!'). **Return all the Power Towers to the neutral spot.**" | HIGH |
| Scoring | | Numbers face value; Draw One, Draw Two, Reverse, Skip 20; **Grab-2-Towers 50**; Wild Grab-A-Tower 50; Wild Draw Four 50. 500 to win. | HIGH |

### Edge cases & rulings
- Protection lasts "for the entire time you are in possession of it", so a stolen tower protects the new holder at once (sheet).
- A blocked card: "treat it like a regular color or Wild card and play by matching it accordingly" (sheet).
- Instant UNO resets the towers to neutral (sheet), so it cannot fire twice from the same set. The old once-per-acquisition flag is no longer needed. Timing: the sheet says only "if you ... have all 4 in your possession". Recommend resolving it right after the grab that completes the set, on the same turn.
- No tower protects against Reverse.

---

## 5. UNO Royal Revenge (#159) (sheet CGH10, ©2014)

| Item | Copies | Effect | Conf |
|---|---|---|---|
| Deck | **56 cards** | **8 per color, 1 to 8** (one of each; 32), **4 Reverse** (1 per color), **4 Skip** (1 per color), **4 King's Choice** (1 per color), **8 Jester** (2 per color), **4 Wild**. **No Draw Two and no Wild Draw Four.** Plus 1 Crown, 1 Jester Hat, 1 Electronic Scepter (2 AAA). 2-6 players. | HIGH (sheet CGH10) |
| Start | "The youngest player wears the crown and holds the Royal Scepter first, making them the King. The King then chooses another player to be the Jester." **"The King starts play."** | HIGH |
| Wild | "When this card is played, **THE KING** gets to choose the color that continues play." If it is turned up at the start, the King chooses. (The sheet once calls it "Wild Dare". That is a typo.) | HIGH |
| King's Choice (+1) | 4 | "The King chooses any player he wants and that player must draw one card." It matches by color or on another +1 card (King's Choice or Jester). Start card: the King picks who draws, then play continues with the King. | HIGH |
| Jester (+1) | 8 | "Whoever is wearing the Jester Hat must draw one card." It matches by color or on another +1 card. Start card: the Jester draws 1, then play continues with the King. | HIGH |
| +1 turn order | | "After a player is forced to draw a card due to a King's Choice or Jester card being played, **play does not continue from that player**." Example: P1 plays Jester, P3 is the Jester, P3 draws, then P2 plays next. The +1 victim does not lose their turn. | HIGH |
| Jester hat (role) | 1 | The only effect is being the Jester-card target. | HIGH |
| Scepter fanfare | | "Whenever the Royal Scepter sounds its FANFARE (after a minute or so), it's time for a new king! The Crown is placed on the head of the player to the **LEFT** of the current king." The new King picks a new Jester ("any player ..., including the person who was just wearing the Jester Hat"). **"Play then continues with the new King."** | HIGH |
| Scoring | | Numbers face value; Reverse, Skip, King's Choice, Jester 20; Wild 50; 500 to win. | HIGH |

### Edge cases & rulings
- Digital port: replace the scepter with a random timer (per-turn probability, or every N turns ± random). The fanfare also **moves the turn to the new King**, so it is a turn-pointer jump as well as a role change.
- Is "left" seat-left or play direction? The sheet says LEFT (seat). Keep it seat-based.
- Can the King target himself with King's Choice? "Any player he wants". Allow it. Can the King be his own Jester? "Chooses another player", so no at game start. For later Jesters the sheet says "any player", so it is unclear whether the King may pick himself. LOW.
- The AI King's color choice should favor the King's own hand.

---

## 6. UNO Colors Rule! (#162) (sheet DWV64, ©2016)

| Item | Copies | Effect | Conf |
|---|---|---|---|
| Deck | 112 | **17 per color, 1 to 9** (68; **no 0s**; which number appears only once is not stated), **8 Draw Two** (2 per color), **4 Reverse** (1 per color), **4 Skip** (1 per color), 4 Wild Draw Four, **16 Wild Color Character**, **4 Wild Color Choice**, **4 Color Power cards** (+ 4 plastic stands). **No plain Wild.** 2-10 players. | HIGH (sheet DWV64) |
| Color Power cards | 4 | Placed in their stands "near the playing area" at setup (unclaimed). Whoever holds one has that power. | HIGH |
| Wild Color Character | 16 (4 per color presumed; the split is not stated) | "When you play this card, you take on the power [of] the color of the card played." Take that Color Power card, from the stand or from another player. "Color Character Cards are wild, so you may play them whenever you want, and then **you choose the color that resumes play**." So the next color is **not** forced to the card's color. | HIGH (rule); LOW (4 per color) |
| Wild Color Choice | 4 | Not a plain Wild: "you get to choose **any Color Power** you desire ... If another player currently has that Color Power, take the Color Power card from them." Then choose the color that continues play. | HIGH |
| Steal | | "This card will stay there until another player steals the power from you", e.g. by playing the Red Character Card "OR ... a Wild Color Choice Card and calls 'red'". | HIGH |
| **RED power** | | "This card allows you **to give your red cards to any other player you wish at any time**." | HIGH |
| **BLUE power** | | "This card allows you to play 2 playable cards on your turn." | HIGH |
| **GREEN power** | | "If you have no playable cards in your hand, you may take the top card from the draw pile and immediately place it on the discard pile (whether it is a playable card or not) to complete your turn." | HIGH |
| **YELLOW power** | | "This card protects you from any **Skip, Reverse, Draw 2, Wild Draw 4 and Red Character Card** played against you." | HIGH |
| Scoring | | Numbers face value; Draw Two, Reverse, Skip 20; Wild Draw Four, Wild Color Choice, Wild Color Character 50. 500 to win. | HIGH |

### Edge cases & rulings
- Red "at any time" means **out-of-turn interrupts**. The sheet sets no per-turn limit, so it is unlimited. A Red dump can empty your hand. Recommend treating that as going out, with the normal UNO call at 1 card. Whether the dump must be all red cards or can be some of them is unspecified; the wording "your red cards" suggests all.
- Yellow vs "Red Character Card": the sheet's wording means Yellow blocks an incoming **Red-power dump** aimed at you. (Read literally, it would block someone stealing your Red power with a Red Character card. That seems unintended.) LOW.
- Yellow blocking Reverse: most likely a Reverse played when you are next does not change direction. Unclear. LOW
- Can you hold more than one power? Nothing caps it (inferred).
- Blue's "2 playable cards": does the second card have to match the first? Presumably it matches the new top card. Unspecified.

---

## 7. UNO Remix (#164) (sheet HBF06)

| Item | Copies | Effect | Conf |
|---|---|---|---|
| Deck | 112 = **56 Game cards + 56 Remix cards**. Game cards: **9 per color 1-9** (36, no 0s), **4 Draw cards** (1 per color; these are the "Plus" cards, since the Spanish text uses the same word, "Toma"), **8 Reverse** (2 per color), **4 Skip** (1 per color), **4 Wild**. Plus 1 Remix card box and 1 sticker sheet. 3-6 players. | | HIGH (sheet HBF06) |
| Remix deck | 56 | "DO NOT SHUFFLE." Kept in the box in printed order. The **per-type copy counts and the printed order are not stated in the sheet text.** The order W, SK, G, AM, SH, D2, WD4, AN2, AN4 (Geeky Hobbies) is still **unverified**. | HIGH (no shuffle); unverified (order, counts) |
| Draft (each round) | | Take as many cards as there are players from the front of the box, face up. Round 1: the youngest picks first. Later rounds: the last round's winner picks first. Then picks go **clockwise** in the English text (the Spanish text says to the right). Each player customizes theirs, and they are **added to the Game deck**. The deck grows every round. The last round's winner deals. | HIGH |
| End of match | | Keep playing rounds until the box holds only enough for one more round (the Final Round). **There are no points**: each round winner takes the next numbered sticker. The player with the most stickers is the Champion (ties go to the highest final sticker number). The player with the fewest is the Jester (ties go to the lowest number). Each of them may cross out one name on any card. | HIGH |

Remix card types (sheet HBF06, official text):

| Type (code) | Customize | Effect |
|---|---|---|
| Plus card | (Starts with tally marks; the base deck's 4 Draw cards) | "Can be played on matching color or symbol. The next player must draw as many cards as tally marks shown on this card and their turn is skipped." |
| Wild + Name (W) | Add YOUR name | "You may play it at any time, however the person whose name is on the card gets to choose the new color." |
| Skip-To (SK) | Add YOUR name | "Can be played on matching color or symbol. Play skips directly to the player whose name is on the card." |
| The Giving Card (G) | Add an OPPONENT's name | "When this card is DRAWN, this card is immediately given to the player whose name is on the card. This cannot be blocked by a shield. Can be played on matching color or symbol." |
| Add A Mark (AM) | Find any Plus card in the play deck, add 1 tally mark, shuffle it back | Then **destroy** the Add A Mark card. It never enters the deck. |
| Shield + Name (SH) | Add YOUR name | "Can be played on a matching color or symbol, OR you may use it to block a penalty card (Plus, Draw 2, Wild Draw 4). If the Shield card does NOT have your name on it, you may only block a penalty card of the same color. ... If the Shield card does have your name on it, you may block a penalty card of ANY color." Against a WD4, an unnamed Shield must wait for the WD4 player to call the color, and then it can block only if the colors match. Afterwards "play continues in current order from the player who played the Wild Draw Four initially." |
| Draw 2 + Name (D2) | Add an OPPONENT's name | Plays on matching color or another Draw 2. "If there is ONE name on the card, that player must draw two cards. If there are TWO names on the card, [the player who laid it down] gets to choose which of the two names must draw." Play still resumes with the next player after the one who laid it down. |
| Wild Draw 4 (WD4) | Add an OPPONENT's name | Normal WD4 legality and challenge (innocent means the challenger draws 6). Same one-name/two-name targeting and turn order as D2. |
| Add A Name to Draw 2 / Draw 4 (AN2 / AN4) | Find a Draw 2 (AN2) or Draw 4 (AN4) in the play deck and add a second name, shuffle it back | Then **destroy** it. It never enters the deck. |
| Reverse, Skip, Wild | (Also explained in the Remix section; whether plain copies exist in the Remix box is unverified) | Standard. |

### Edge cases & rulings
- Named-target cards when the named player is absent: unspecified.
- A Giving card that is **dealt** (not drawn) at the deal: presumably it also passes to the named player. Unspecified.
- The Shield rules above replace the old guess. A Shield blocks a penalty played *on you*; the sheet does not cover chains of penalties.
- Digital: free text and name stickers become **parameter picks** (type → player name / mark count). The deck persists for the whole match. Writing it to disk would copy the "permanent marker" feel. AM/AN cards are instant one-time edits, not deck cards.

---

## 8. Reflex/reaction family (game logic only)

### 8a. UNO Flash (#23) (sheet M1002, ©2007)

| Element | Effect | Conf |
|---|---|---|
| Deck | 108: 19 per color 0-9, **8 Draw Two, 8 Skip, 8 SLAP** (2 per color each), 4 Wild, 4 Wild Draw Four. **No Reverse.** 3-6 players. | HIGH (sheet M1002) |
| Turn order | The unit picks who starts. After each turn, the player presses their Player Button and "the unit will then immediately select the next player to play ... watch out, it could be you again!" | HIGH |
| Turn timer | The Speed Switch sets ∞ / 6 s / 4 s per turn. "If you do not press your Player Button before time runs out, indicated by a buzzer, you must draw two cards." | HIGH |
| Draw Two / Wild Draw Four | "The next player selected by the unit must draw ... (even if that player is you!)." The Draw Two drawer must still press their button in time or draw 2 more. Optional rule: the player of a Draw 2 / WD4 names the victim instead. | HIGH |
| Skip | The next player selected is skipped, but must still press their button in time. | HIGH |
| SLAP card | Press SLAP instead of your Player Button. "All of your opponents must race to slap (press) their own Player Buttons as fast as they can. The Player Button of the last player to slap will then flash and that player must draw 2 cards." Pressing the flashing button resumes the game. Pressing the Player Button instead of SLAP cancels the SLAP. A SLAP start card goes back into the deck. | HIGH |
| Scoring | Draw Two, Skip, SLAP 20; Wild, Wild Draw Four 50; 500 to win. | HIGH |

### 8b. UNO Reflex (#108) (sheet T8221, ©2010)

| Element | Effect | Conf |
|---|---|---|
| Deck | Standard 108. | HIGH (sheet T8221) |
| After every play | "On EVERY TURN, after you've played a card, you must PUSH AND RELEASE the UNO Reflex Button ... the unit may or may not display one of the 4 colored lights." How often is not stated. If you can't play a card, you do not press. | HIGH (rule); frequency unverified |
| Color lit | "ALL PLAYERS must race to lay down ... ANY one card that matches that color and PRESS THE BUTTON again." The winner gets rid of the card; others take theirs back. "Play continues with the player after you. ... The card you played is now the card to be matched." Wilds and Wild Draw 4s may be used to match the light "EVEN IF YOU HAVE a matching color". | HIGH |
| Action under the light | "If you match the colored light with an Action Card, the next player must complete that action." | HIGH |
| Wrong color | "You must draw 2 cards. Play then continues with the next player in the original order." | HIGH |
| No match | Press once to stop the sound; play continues in the original order. | HIGH |
| Wild / Wild Draw 4 color | **The button chooses the color**: press and hold, the lights cycle, and the one lit on release is the color. ("You can try to release the Button at just the right time.") The WD4 victim draws before the button is pressed. | HIGH |

### 8c. UNO Blast (#110) (sheet Y2318, ©2012): the real accumulate-and-dump pile

| Element | Effect | Conf |
|---|---|---|
| Deck | **110 cards**: 18 per color 1-9 (72, no 0s), **8 Draw One, 8 Reverse, 8 Skip** (2 per color), **4 Discard Color** (1 per color), **4 Wild, 6 Wild Blast**. **No Draw Two and no Wild Draw Four.** 2-6 players. | HIGH (sheet Y2318) |
| Drawing | "Anytime you are forced to draw a card from the DRAW pile, you must place it in one of the empty slots on the Card Blaster." "If you draw a card that is playable, you may NOT play it on the same turn." You may also choose to draw instead of playing, but the card still goes in the blaster. | HIGH |
| Blast | "If your card triggers the blast, you must take all of the cards that shoot out and add them to your hand; your turn is over." "You never know which slot will trigger the blast!" The number of slots and the odds are not stated. | HIGH (rule); unverified (slot count/odds) |
| Draw One | "The next player must draw 1 card and place it in the Card Blaster! This counts as their turn." | HIGH |
| Discard Color | "You may discard all cards of that color in your hand ... The card you place on the top of the DISCARD pile continues play." | HIGH |
| Wild Blast | "Played like a Wild card. In addition, ... the next player must draw and insert cards into the Card Blaster until the blast is triggered. That player must add all of the cards that blast out to their hand; this counts as their turn." | HIGH |
| Start card | An action start card goes back into the DRAW pile, and a new card is turned. | HIGH |
| Scoring | Numbers face value; Draw One, Discard Color, Reverse, Skip 20; Wild, Wild Blast 50; 500 to win. | HIGH |

### 8d. UNO Showdown (#37) (sheet GKC04, ©2020) / Showdown Supercharged (#105) (sheet GMX56, ©2019)

| Element | Effect | Conf |
|---|---|---|
| Deck (both) | 112: standard 108 + **4 Wild Showdown**. "There is a total of **20 Showdown cards distributed throughout the deck** (not including the Wild Showdown cards)." The sheets do not say which cards carry the icon or how many show 1, 2 or 3. 2-10 players. | HIGH (sheets GKC04, GMX56); unverified (icon distribution) |
| Showdown icon | The player who played it faces "the next player in the current order of play". They load "the number of cards indicated by the Showdown icon" (1-3) from the draw pile into the unit. "Having a SHOWDOWN icon on a card does not make a match." | HIGH |
| Duel | Red lights and countdown tones, then GREEN means press your paddle. The cards flip toward the loser (Supercharged: "Whoever presses their paddle first wins ... The card(s) will FLIP toward the slower player"). The loser adds them to their hand. **Pressing early**: the countdown stops, the red light points at the guilty player, and they automatically lose. Unclear landing: whoever has the most cards on their side of the line takes them. | HIGH |
| Wild Showdown | "You get to choose which player to have a showdown with and you get to choose the amount of cards (1-3) ... You also get to choose the color." Playable even with another playable card. | HIGH |
| Going out | If the final card has a Showdown icon, the showdown must happen first. Win it and you win the round. Lose it and you add the cards and play continues. Optional "extra challenge": every final card triggers a 1-card showdown. | HIGH |
| Scoring | Standard + **Wild Showdown 40**; 500 to win. | HIGH |
| Supercharged differences | **No rule differences** found. Same deck, same text. Supercharged only adds "THUNDER" and "LIGHTNING FLASH" effects before the countdown. | HIGH (sheet GMX56) |
| "Showdown Draw Two" | Not on either sheet as a separate card. Removed. | corrected |

Digital: the duel is a reaction-time minigame, or a 50/50 (or skill-weighted) coin flip. Model the false-start rule as a small extra loss chance for the AI.

---

## 9. Other device-based UNO products on Mattel's site (not in this file's scope)

Searched service.mattel.com. Products already covered elsewhere in `docs/gameversions.md` are marked "(covered)".

| Product (code) | One line |
|---|---|
| **UNO Show 'em No Mercy Attack (JNK69, ©2026)** | **Not in gameversions.md.** 168 cards + launcher with two buttons: yellow "Hit" (classic Attack) and a red, chargeable "Ultra Hit". Hit 2x/4x, Wild Reverse Hit 4x, Wild Hit 6x, Wild Ultra Hit, Wild Duel to the Death (two players alternate holding the red button until an Ultra Attack fires). Hit-card stacking with equal or higher cards, 7-swap / 0-pass, Skip Everyone, Discard All, Mercy knockout at 25 cards, 1000-pt scoring with a 250-pt bonus per knocked-out player. |
| UNO Spin To Go (R2820) and UNO Spin Hannah Montana (N8367) | Now filled in above (1c, 1d). |
| UNO Attack / Extreme (T8219, GXY78, GTX66, V9364, 42443), Attack Mega Hit (GNL02, GXY81), Attack Jurassic World (FPW39, GYM42) | Random card-launcher family (covered, A5). |
| UNO Flip Attack (HXT54) | Flip + launcher (covered). No sheet on the product page. |
| UNO Triple Play (GXV87) / Triple Play Stealth (HCC23) | 3-pile tray unit with an overload penalty (covered). |
| UNO Blitzo (42458) | Electronic button-pad reaction game (covered as DIFFERENT-GAME). |
| UNO H2O Splash (J3721) | Whirlpool spinner device (covered in 02-flip-and-alternate-decks.md, 9.5). |
| UNO Moo! (CHD58, FFV32, N7793) | Preschool figure game. The barn is only a draw bag and holder; there is no randomizer device. 24 figures (16 animals, 4 Skunk = Skip, 4 Farmer = Wild). |
| UNO Slide, UNO Hold Up | **Not found** on service.mattel.com under any keyword tried. Keep them unverified/possibly non-existent. |

---

## Cross-mechanic interaction notes

**Hand-exchange collisions**
1. **Spin 2005 "Trade Hands" (all pass left, sheet) / Spin 2025 "Swap Hands" (spinner + one chosen player, sheet) / Hannah Montana "World Tour" (chain pick) / Roboto swap (unverified) vs the 7-0 rule.** All of them move whole hands. Resolve each effect fully before checking UNO calls or a win. Spin cards are 1-5 in every Spin edition read, so a 7 or 0 is never a Spin trigger in the official decks. Keep seat-left for Spin 2005 (official), play direction for 7-0, and document both.
2. **Hand swaps vs Power Grab towers / Colors Rule powers / Royal Revenge roles.** Towers, powers, Crown and Jester Hat belong to the *player*, not the hand, so they stay put.
3. **Hand swap vs Remix Giving card** (only triggers "when DRAWN", sheet): a swap is not a draw, so it does not trigger.

**Discard-out-of-turn collisions**
4. **Device discards (Spin Discard Color/Number, Almost UNO, War, To Go Escalator/Luggage/Taxi-Boat-Plane/Recycle, Tiki Discard 2/All, Eye-Eye Discard 1, Roboto "discard all your red", Wild Jackpot symbol 5, Power Grab Instant UNO, Blast Discard Color, Colors Rule Red dump, Adults-Only Discard 2/All).**
   - *Going out:* yes. Sheet R2820 says so explicitly, and Roboto and Eye-Eye describe it. Check after the effect has fully resolved. Roboto: discard one card at a time and call UNO at 1.
   - *Does a discarded action card take effect?* **Officially yes in several products** (this corrects the old default). Roboto (T8220): the new top card "cancels any card it covers up and ... affects whichever player resumes play". Eye-Eye (P9391): "the next player must also follow the direction of that card". Wild Jackpot (DNG26): "each one will affect the next player". Spin 2005/HM/To Go: the spinner picks the top card, "affecting the next player's turn". Blast: "the card you place on the top ... continues play". Not applicable: Spin 2025 and Adults Only put discards on the **bottom**, so the top card never changes. **Recommendation:** the top card after a device discard is live against the player who resumes. Only Wild Jackpot symbol 5 resolves *every* discarded action card. Everywhere else only the top card counts.
   - *Cancelling:* Roboto says a covered card's pending effect is cancelled (a Wild Draw 4 covered by a Draw 2 means the resuming player draws 2, not 6). Use that as the general rule for out-of-turn discards that land on a pending penalty.
5. **Mass discards vs Jump-In.** A discarded card that exactly matches the top card must **not** open a Jump-In window. Otherwise discards chain. Suppress Jump-In while device effects are resolving.
6. **Spin "UNO Spin" race / Reflex light / Roboto duel and House Rule / Flash SLAP / Showdown duel vs Jump-In.** These are all real-time interrupts. Use one "interrupt window" system with a priority order: device race first, then Jump-In.

**Draw-penalty collisions**
7. **Stacking vs device draws.** Spin Draw Red/Blue/Star/Color Draw, Spin "Draw 2" (HM: everyone but the spinner), Tiki Draw 1/2/4, Wild Jackpot symbol 6, Eye-Eye Draw 4 / draw-until, Roboto duel and House-Rule losers, Showdown losers, Blast dumps, Flash timeout draws: none of these are cards, so none are stackable. Resolve them as plain draws that do not add to or clear a pending stack. No official device sheet allows stacking.
8. **Power Grab towers vs Stacking.** Stacking is not official here. If a house stack targets the N-tower holder, the protected player is immune, the stack **ends** with no draw, and the last +2 counts as a colored card ("treat it like a regular color ... card", sheet). With mixed +2/+4 stacks, protection applies if the tower matches the **last** card.
9. **Colors Rule Yellow** (blocks Skip, Reverse, Draw 2, Wild Draw 4, Red dump, sheet) and **Remix Shield** (blocks Plus / Draw 2 / Wild Draw 4; any color if it carries your name, same color otherwise, sheet) **vs Stacking:** same recommendation, the block ends the stack. Note the Shield is a *card you play* to block, and the Yellow power is passive.
10. **Power Grab "!" blocks Skip vs Skip-Everyone / Mercy-family toggles:** the sheet says "protection against Skip cards", so default to Skip cards only. Draw One/Two/WD4 "miss their turn" is not blocked by "!".
11. **Wild Draw Four challenge vs King (Royal Revenge).** Royal Revenge has **no Wild Draw Four** (sheet CGH10), so this only matters when King rules are mixed with a standard deck. Then the King names the color, and the challenge still asks about the color before the Wild. Also note Reflex, where **the button** picks the Wild color. Neither the player nor the King does.

**Turn-pointer collisions**
12. **Who spins and who plays next.** 2005/HM/To Go: the next player spins instead of taking a turn. 2025/Adults: the player who played the card spins. Tiki: the player who played spins, then play resumes in current order (or jumps for Go To). Eye-Eye: play resumes after the spinner even if the next player was the target. Royal Revenge +1: the victim does not lose a turn. Roboto: the device names the next player. Handle device triggers in a FIFO queue, and update the turn pointer only after the queue is empty.
13. **Flash random order vs Reverse/Skip/7-0 "direction".** Flash has no Reverse (sheet), and "next" means the next random pick. Turn off direction-based toggles, or define "next" as the next random pick (Skip = skip that pick, Draw Two = the pick draws, possibly yourself).
14. **Reflex "play continues after the winner"**, **Tiki Go To**, **Remix Skip-To**, **Roboto naming the next player**, **War / UNO Spin race winners**, and the **Royal Revenge fanfare** (play continues with the new King) all jump the turn pointer. They conflict with "Skip Everyone" and with a pending stack's target. Freeze jump effects while a stack is pending.
15. **Spin 2025 "2x" vs Colors Rule Blue ("play 2 playable cards on your turn").** Recommend no 3- or 4-card turns: cap at 2, and treat both as the same "multi-play" flag. Two +2s in one 2x turn count as one stack contribution of 4 against the next player.
16. **2x vs Jump-In**: a jump-in during 2x counts as one card, not a 2-card turn.

**Role/ownership collisions**
17. **Royal Revenge King vs Colors Rule Character/Choice Wilds.** In Colors Rule the *player* chooses the resume color after any Character card (sheet), and the power follows the printed color (Character) or the declared power (Choice). If King rules are layered on, the King picks the color and the power steal is unaffected.
18. **Several "who picks the Wild color" rules**: Remix Wild + Name (named player), Royal Revenge (King), Reflex (button / RNG), standard (player). Precedence: card-specific (Remix name) > global role (King) > device (Reflex) > player.
19. **Steal mechanics (Power Grab towers, Colors Rule powers, Royal Revenge roles) vs team modes.** Ownership is per player. A teammate's tower does not protect the team (recommendation).
20. **Wild Jackpot / Roboto house-rule text vs engine toggles.** A free-text rule cannot be executed. Use a fixed menu of parameterized one-shot effects (Wild Jackpot's 8 official suggestions are a ready-made list), and reuse existing effect code paths (swap hands, draw-to-N, discard-to-N).

**Pile collisions**
21. **Blast blaster contents vs reshuffling the draw pile.** Cards in the blaster are out of both piles. If the draw pile runs out during a Wild Blast, reshuffle the discard pile (not the blaster). If both are empty, force the blast. Tiki Twist adds a pile rule too: idol faces (except the one showing) go back in at reshuffle (sheet).
22. **Draw-until effects (Spin Draw Red/Blue/Star, Color Draw, Wild Color Draw, To Go Gas/Food/Lodging and Cash Machine, Eye-Eye draw-until, Adults Flip for Number) vs a Mercy-style hand-size elimination.** Check elimination after the effect ends. Note that Spin 2025 Color Draw, Cash Machine and Gas/Food/Lodging have **no Wild stop**, so they can run longer.
23. **Device triggers on the starting card.** Per the sheets: Spin 2025/Adults ignore an action start card and flip again. Roboto and Blast put it back into the draw pile. Tiki Face goes into the idol. Eye-Eye treats an Eyeball card as a plain number. Wild Jackpot fires a dispensed rule (Jackpot or Wild Jackpot). Power Grab Grab cards give no grab. Royal Revenge King's Choice/Jester make someone draw 1, then the King starts. Flash returns a SLAP or WD4 to the deck. Spin 2005 has no rule for a Spin start card. Recommend no spin.

## Gaps remaining (priority order)
- Wheel and spinner **segment sizes / weights**: Spin 2005 (9 areas), Spin 2025 (segment count and how many Color Draw segments), Adults Only, Wild Jackpot (6), Eye-Eye (3 × 3). No sheet states them. 1/N is an assumption.
- Spin 2025: full card list (only "112 cards" and "24 Spin cards" are printed). Adults Only: per-color Spin numbers and action-card counts.
- Tiki Twist: count of Spin-symbol cards, and the split of the 16 Tiki cards by type and color.
- Roboto: trigger frequency, and whether "swap hands" / "extra turn" are real Surprise Commands.
- Reflex: how often a color lights. Blast: number of slots and fire odds.
- Showdown: which 20 cards carry the icon and their 1/2/3 split.
- Remix: per-type copy counts and the printed order of the 56-card Remix deck.
- Wild Jackpot / Colors Rule: which number is duplicated in the 15- and 17-card color suits. Colors Rule: Character split per color (4 each presumed).
