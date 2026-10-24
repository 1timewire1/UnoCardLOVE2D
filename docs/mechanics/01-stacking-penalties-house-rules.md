# Final review 1: Stacking, penalties and official house rules

> Reference spec for `docs/gameversions.md` (see its Part F). **Verified against Mattel's official instruction sheets** (service.mattel.com) in a second pass. Claims marked "(sheet CODE)" quote or closely paraphrase that sheet. Anything still resting on web snippets, fan wikis or package art is marked as such.

Research cluster: UNO Show 'Em No Mercy (base, Expansion Pack, No Mercy Attack, Deadpool edition), all ten UNO Add-On Packs, official classic rules and house rules, and UNO Attack (1999, 2010s, 2020).

**Method.** First pass: WebSearch snippets only (fetches blocked). Second pass: downloaded and read the official sheets for HWV18/HXT57, JJB29, JNK69, JCV56-59, JHG45, JMM16-18, JPH28, classic 42003 (current and pre-2008 printings), 41940 "UNO Basic" (2008, with house rules), 41943 (UNO Attack 1999), T8219, GTX66, GXY78/GXY81 and GNL02 (UNO Attack). Card counts that the sheets don't print were checked against Mattel's own shop listings and package-back art (shop.mattel.com). BoardGameGeek and the UNO fandom wikis still return 403, so they are only reachable through search snippets.

**Confidence tags:**
- **HIGH (sheet CODE)**: printed on that official Mattel instruction sheet.
- **MED-HIGH (pkg CODE)**: read off Mattel's own package art or shop listing, not the sheet.
- **MED**: one detailed secondary source, or two agreeing secondary sources.
- **LOW**: thin or inferred. Don't implement from it without a check.
- **UNVERIFIED**: no official source found in either pass.

**Official sheet URLs** (all fetchable from service.mattel.com):
- No Mercy: `instruction_sheets/HVW18-Eng.pdf`. The *file name* transposes the letters; the part number printed on the sheet is **HWV18** (HWV18-4B70, HWV18-9564). The tin edition HXT57 serves the same sheet.
- No Mercy Expansion: `JJB29_English.pdf` (vector art; text extracts with MuPDF, not pypdf).
- No Mercy Attack: `JNK69_0970G1_DOM_IS_(-9994).pdf`.
- Add-On Packs: `JCV56-Reverse.pdf`, `JCV57-Speed.pdf`, `JCV58-Stack.pdf`, `JCV59-Swap.pdf`, `JHG45_English.pdf`, `JMM16_2LB.pdf` (Frenemies), `JMM17_2LB.pdf` (Comeback), `JMM18_2LB.pdf` (Defense), `JPH28_DOM.pdf` (Love Island).
- Classic UNO: `42003-Wild.pdf` (current, with Wild Swap Hands), `42003-Eng.pdf` / `42001.pdf` (older 112-card printing with 4 Blank cards; text is hex-encoded), `UNO%20Basic%20IS.pdf` (41940, 2008, 108 cards plus official house rules).
- UNO Attack: `41943-0821-g1.pdf` (1999), `T8219.pdf`, `GTX66-Eng.pdf`, `GXY81-Eng.pdf` (served for both GXY78 and GXY81), `GNL02-Eng.pdf`.

---

## 1. UNO Show 'Em No Mercy (2023, Mattel HWV18; tin HXT57; 168 cards)

The sheet's contents line says only "168 Cards"; it **prints no per-card counts**. Effects below are sheet wording.

### Card table

| Card | Copies | Exact effect (HWV18 sheet) | Confidence |
|---|---|---|---|
| Number cards 0-9 (4 colors) | 80 (2 of each number per color) | Face value. 0 and 7 have the special rules below. | effect HIGH (sheet HWV18); count MED (fan wiki, sums to 168) |
| 7 | (part of the number cards) | "7's Swap - When you play a 7 card of any color, you MUST swap your hand with another player of your choice. Play then continues in current order." | HIGH (sheet HWV18) |
| 0 | (part of the number cards) | "0's Pass - When you play a 0 card of any color, ALL players must pass their hand to the next player in the current direction of play." | HIGH (sheet HWV18) |
| Skip | 12 (3/color) | "When played, the next player in current order loses their turn." | effect HIGH (sheet HWV18); count MED |
| Reverse | 12 (3/color) | Reverses direction. "With just two players a Reverse skips the other player, letting you take another turn." | effect HIGH (sheet HWV18); count MED |
| Draw Two (colored) | 12 (3/color) | "The next player in current order must draw 2 cards and lose their turn." Stackable. | effect HIGH (sheet HWV18); count MED |
| Draw Four (colored, *not* wild) | 8 (2/color) | "When played, the next player must draw 4 cards and lose their turn." Listed under *Color* Action Cards in the scoring table, so it is a colored card. Stackable. | effect and colored status HIGH (sheet HWV18); count MED |
| Discard All | 12 (3/color) | "Discard all the cards in your hand that match the color of the Discard All Card. Place the extra cards under the Discard All Card." | effect HIGH (sheet HWV18); count MED |
| Skip Everyone | 8 (2/color) | "Skip all the other players and take another turn." | effect HIGH (sheet HWV18); count MED |
| Wild Reverse Draw 4 | 8 | "Reverse the direction of play, then the next player in the new direction must draw 4 cards and lose their turn. With just two players this card skips the other player and makes YOU draw 4 cards! You may use the stacking rule to send the penalty back to the other player." | effect HIGH (sheet HWV18); count MED |
| Wild Draw 6 | 4 | "The next player must draw 6 cards and lose their turn." | effect HIGH (sheet HWV18); count MED |
| Wild Draw 10 | 4 | "The next player must draw 10 cards and lose their turn." | effect HIGH (sheet HWV18); count MED |
| Wild Color Roulette | 8 | "**The next player chooses a color.** After that, they must reveal cards one at a time from the Draw Pile until they get a card of that color (Wild Cards do NOT count). Then they add all the revealed cards to their hand and lose their turn." | effect HIGH (sheet HWV18), **chooser conflict resolved: the next player (the victim) picks**; count MED |

**Count check.** The breakdown above (80 + 12 + 12 + 12 + 8 + 12 + 8 + 8 + 4 + 4 + 8 = 168) is the fan-wiki list (cardgameuno.fandom.com, via search snippet); it is the only full breakdown found and the only one that sums to 168. Miexto independently gives Discard All 12 and Color Roulette 8; retailers agree on Wild Draw 6 = 4 and Wild Draw 10 = 4. Mattel's sheet and shop listing don't print counts. Treat the counts as **MED**, not sheet-verified.

### Core rules (all HIGH, sheet HWV18)

"4 special rules and 6 super-tough Action Cards have been added." The four special rules are Stacking, Mercy, 7's Swap and 0's Pass. The six new action cards are Discard All, Skip Everyone, Wild Reverse Draw 4, Wild Draw 6, Wild Draw 10 and Wild Color Roulette.

1. **Setup:** deal 7 each. If the first Discard Pile card is an Action Card, "ignore it and flip over the next card." The player left of the dealer starts; play proceeds clockwise.
2. **Stacking (sheet text):** "If someone plays a Draw Card (+2, +4, +6, +10) you can 'Stack' the penalty by playing a Draw Card from your hand of equal or higher value. If you do, the card you played adds to the total penalty for the next player. For example, if someone plays a +4 card on you, and you can play a +6 on top of it, the next player is now forced to draw 10 cards (unless they can play a Draw +6 or higher, then it goes on to the next player). This continues until someone can't play a Draw Card that equals or exceeds the value of the last card played. That player then takes the full penalty of all stacked Draw Cards. Ouch!"
   - The comparison is against **the last card played**, not the running total. Colored Draw 4 and Wild Reverse Draw 4 are both value 4.
   - Only Draw Cards (+2, +4, +6, +10) stack. Color Roulette, Skip Everyone, Skip and Reverse aren't Draw Cards and can't answer a stack. This is explicit from the list, HIGH.
   - The sheet doesn't mention color when stacking. Reading "equal or higher value" as color-agnostic remains an inference (MED).
   - Wild Reverse Draw 4 stacks and reverses, so the penalty heads back the other way. The 2-player clause ("send the penalty back") is printed.
3. **Draw until you can play, then play it:** "If you DO NOT HAVE a matching card, you MUST draw cards from the Draw Pile UNTIL YOU DRAW A CARD YOU CAN PLAY. Then, play that card." The drawn playable card **must** be played (closes the earlier LOW gap).
4. **Mercy Rule:** "If a player ever has 25 or more cards in their hand, they are out of the game. Set aside their hand of cards until the deck runs out and needs to be reshuffled."
   - The threshold is ≥25. "Ever" supports checking after every hand-size change, including penalty draws and 0/7 hand passes (the swap case is still inference, MED-HIGH).
   - **Knocked-out player's cards (gap closed):** set aside, **out of play**, until the Draw Pile runs out. Then they go back in with the reshuffle ("if there are no cards left in the Draw Pile, reshuffle the Discard Pile to form a new Draw Pile").
5. **Win condition:** "When a player plays their final card, they win. Alternatively, if all other players are knocked out of the game (see Mercy Rule), you win."
6. **Calling UNO:** "if someone catches you and calls out 'UNO' before you (and before the next player begins their turn), then you must draw 2 cards!"
7. **Scoring ("Keeping Score (Optional Victory Method)"):** the winner of a hand scores the cards left in opponents' hands.
   - Number cards 0-9: face value.
   - "Any Color Action Card" (Skip, Reverse, Draw 2, Draw 4, Discard All, Skip Everyone): **20**.
   - "Any Wild Action Card" (Wild Reverse Draw 4, Wild Draw 6, Wild Draw 10, Wild Color Roulette): **50**.
   - "250 Points for each player knocked out of the game during the hand (ignore the cards in their hand at the time they were knocked out)."
   - First to **1000** points wins. (Corrects the first pass's "Skip Everyone/Draw 4 around 25-30".)

### Edge cases & rulings
- **2-player Wild Reverse Draw 4** (HIGH, sheet HWV18): the player who played it draws 4, unless they stack it back. Implement literally.
- **2-player Reverse** = take another turn (printed). **2-player Skip Everyone** = take another turn (follows from its text).
- **Discard All:** the Discard All card stays on top, with the extra cards placed *under* it, so its color stays active. Whether you may go out this way isn't addressed; the text says "all" (LOW that it's forbidden).
- **Color Roulette:** the victim chooses the color, reveals until that color appears (Wilds don't count), takes all revealed cards and loses their turn.
- **Skip Everyone:** you take another turn immediately.
- Only Draw Cards can answer a pending stack. 0, 7 and Discard All can't (HIGH, follows from the stacking text).
- No Wild Draw 4 challenge exists in No Mercy; the sheet never mentions one (HIGH by absence).

### No Mercy Expansion Pack (Mattel JJB29, ©2024; 24 cards, 6 coins)

"These cards and coins are designed to be combined with a UNO Show 'em No Mercy card game and cannot be played with on their own." Expansion cards carry an identification icon in the bottom-left corner so they can be separated from the core deck (sheet JJB29).

**Correction:** the first pass's "Wild Discard All + #10 + unknown third card" was incomplete. The pack has **five** card types.

| Card | Copies | Exact effect (JJB29 sheet) | Confidence |
|---|---|---|---|
| 10's Play Again (colored number 10, all 4 colors) | not printed; 8 (2/color) per BGG snippet | "When you play this card, immediately take another turn." | effect HIGH (sheet JJB29); count LOW-MED |
| Wild Discard All | not printed | "This card matches anything so you can play it no matter what card is on the Discard Pile. Pick the color you want to discard and discard all the cards in your hand of that color. This card goes on top of those cards. Since this a Wild Card, you also get to choose the color that continues play." | HIGH (sheet JJB29) |
| Wild Reverse Draw 8 | not printed | "Reverse the direction of play AND make the next player in that direction draw 8 cards and lose their turn. You choose the color that continues play." It is a Draw Card of value 8, so it fits between +6 and +10 under the stacking rule (inference, HIGH). | HIGH (sheet JJB29) |
| Wild Final Attack | not printed | "First, reveal your hand. The next player loses their turn and must draw 1 card for each Action Card and Wild Card in your hand (number cards don't count). If you reveal 7 or more Action and/or Wild Cards, that player must draw 25 cards instead AND all other players must draw 5 cards. You choose the color that continues play." | HIGH (sheet JJB29) |
| Wild Sudden Death | not printed | "All players, including YOU, must draw cards from the Draw Pile until they have 24 cards in their hand – ouch! You choose the color that continues play." | HIGH (sheet JJB29) |

Counts: the 24 cards split over 5 types; nothing official prints the split. 8 tens + 4 of each wild = 24 is the most plausible (LOW-MED).

**Coins (6, two-sided; corrects "3+3").** Each coin has a **Mercy** face and a **No Mercy** face (sheet art plus package back). "Each player gets 1 coin and must declare at the beginning of each game if they are going to use the 'Mercy' or the 'No Mercy' side. You can use it on your turn whenever you want, but only once per game so choose wisely!" (sheet JJB29). The limit is once per **game**, not per round.

| Coin side | Exact effect (JJB29 sheet) |
|---|---|
| Mercy | "You may immediately discard your ENTIRE HAND to the bottom of the Discard Pile, and then draw 7 fresh cards from the Draw Pile to create a new hand. You may use this even if you would have been knocked out for having more than 25 cards." |
| No Mercy | "Immediately doubles the penalty of any Draw Card you play. For example, if you play a Wild Reverse Draw 8 it becomes a Wild Reverse Draw 16! NOTE: the new value of the penalty applies even when stacking." |

So No Mercy doubles **that card's** value (not the running stack total), and the doubled value is what the next player must equal or exceed (the "applies even when stacking" note). HIGH (sheet JJB29).

### UNO Show 'Em No Mercy Attack (Mattel JNK69, ©2026; 168 cards + two-button launcher) — NEW

"This ain't your father's UNO Attack." It is the No Mercy rules plus a launcher with a Yellow "Hit" button (normal Attack) and a Red "Ultra Hit" button that charges up. The sheet prints **no per-card counts**. Card list from the action-card sections and scoring table (all HIGH, sheet JNK69):

| Card | Exact effect (JNK69 sheet) |
|---|---|
| Number cards | Face value. 7's Swap and 0's Pass exactly as in base No Mercy. |
| Skip | Next player loses their turn. |
| Reverse | Direction reversed. |
| Discard All | "Discard all the cards in your hand that match the color of the Discard All Card. Place the discarded cards under the Discard All Card." |
| Skip Everyone | "Skip all the other players and take another turn." |
| Hit 2x | "Next player must hit the Yellow Button twice and lose their turn." |
| Hit 4x | Next player hits Yellow 4 times and loses their turn. |
| Wild Reverse Hit 4x | Reverse, then the next player in that direction hits Yellow 4 times and loses their turn. Wild; you choose the color. |
| Wild Hit 6x | Next player hits Yellow 6 times and loses their turn. Wild; you choose the color. |
| Wild Ultra Hit | "The next player must point the Launcher toward themselves, lift the protective cover, and press the Red Button FOR AS LONG AS THEY LIKE ... If no cards shoot out, they are safe and then take their turn as normal. If the button becomes fully charged, it's an ULTRA ATTACK ... That player must then collect all the cards." You choose the color either way. |
| Wild Duel to the Death | "First, choose another player. Then, beginning with them, take turns pointing the Launcher at yourselves and holding down the Red Button for as long as you dare. Continue back and forth until someone causes an Ultra Attack! That player must then collect all the cards ... the surviving player chooses the color that continues play." |

There is no plain Wild, Color Roulette, Draw 10 or Hit 10 in the card list.

Rules (HIGH, sheet JNK69):
- **No matching card:** press Yellow. If nothing comes out, your turn is over. If cards shoot out, add them all to your hand and your turn is over. "You may choose to press the Yellow Button instead of playing a card, even if you have a playable card in your hand." There is no draw-until-playable here.
- **Red button charge persists:** it "charges the launcher. The longer you hold it, the more it charges. Cards won't fire out until the unit is fully charged," so a short press raises the danger for the next player. A digital port needs a persistent charge meter.
- **Stacking:** "If someone plays a Hit Card (2x, 4x, 6x) on you, you can 'Stack' the penalty by playing a Hit Card from your hand of equal or higher value." The worked example is 4x + 6x = 10 presses. Ultra Hit and Duel are not Hit Cards in that list, so they don't stack.
- **Must finish presses:** "you must hit the button as many times as required even if cards shoot out before you have finished." This is the **opposite** of the classic Attack Mega Hit forfeit rule.
- **Mercy:** 25 or more cards and you're out; your hand is set aside until the deck needs reshuffling. Special case: "if an Ultra Attack causes a player's hand to exceed 25 cards ... they are out of the game and must take all the Ultra Attack cards, plus their hand, shuffle them, and put them on top of the Draw Deck inside the Launcher."
- **UNO penalty:** hit Yellow twice. Cards left in the launcher opening go to the presser. If no one has won when the launcher is empty, reshuffle the Discard Pile into it.
- **Scoring (optional):** number cards face value; "Any Action Card" (Reverse, Skip, Hit 2, Hit 4, Skip Everyone, Discard All) 20; Wild Reverse Hit 4 and Wild Hit 6 **40**; Wild Ultra Hit **50**; Wild Duel to the Death **100**; 250 per knockout; first to 1000 wins.

### Deadpool edition (2024)

**Partly found, effects UNVERIFIED.** Not listed on service.mattel.com (searched "deadpool", "uno deadpool", "uno no mercy deadpool", "uno marvel"), so no official sheet is available. Secondary sources:
- BamSmackPow (July 2, 2024): a **Target exclusive**, $19.99, with new cards "**Wild Maximum Effort**" and "**Wild GIMME!**". It says Skip and Reverse get a "Deadpool twist" without describing it.
- Fan wiki (matteluno.fandom, snippet only): lists a **Wild Reverse Draw 10** "and three other custom cards", including Wild Gimme!.
- eBay listings: an SDCC 2024 version sold as the "Chimichanga" edition.

**Rock-Paper-Scissors-Shoot!** appeared in no source. **No effect text was found for any Deadpool card.** Natural model for Wild Reverse Draw 10 is Wild Reverse Draw 4 with value 10 (LOW, inference only). Don't implement Gimme! or Maximum Effort without a card photo or sheet.

---

## 2. UNO Add-On Packs (2024-2026; 16 cards each; classic deck required)

Every sheet says: "THESE CARDS ARE DESIGNED TO BE COMBINED WITH A CLASSIC UNO® CARD GAME AND CANNOT BE PLAYED WITH ON THEIR OWN." Each pack contains 16 cards (sheet, every pack). Normal UNO rules apply otherwise. **No sheet prints per-type counts.** Where noted, counts come from the package-back art (Mattel shop images), which shows a fan of 4 cards per type.

### 2a. Swap Pack (JCV59)

| Card | Copies | Exact effect (JCV59 sheet) | Confidence |
|---|---|---|---|
| Swap 1 (colored) | 4 (1/color) | "Play this card on a card of matching color or another Swap 1 card. Then you take a random card from another player's hand and give them a card from your hand." | HIGH (sheet JCV59); count MED-HIGH (pkg JCV59) |
| Refresh Hand (colored) | 4 (1/color) | "Play this card on a card of matching color or another Refresh Hand card. Place your entire Hand at the bottom of the **Discard Pile**, and then draw the same number of cards from the Draw Pile to make a new hand." | HIGH (sheet JCV59); count MED-HIGH (pkg) |
| Wild Force Trade | 4 | "When you play this card, choose any two players (include yourself if you want to) and force them to swap hands. Then choose the color that continues play." | HIGH (sheet JCV59); count MED-HIGH (pkg) |
| Wild Pass Hands | 4 | "When you play this card, all players (including you) must pass their hand to the next player in the current order. After everyone has passed their hand, you choose the color that continues play." | HIGH (sheet JCV59); count MED-HIGH (pkg) |

**Check against the project's implementation (`src/card.lua`, `src/uno.lua`):**
- **Wild Force Trade vs the project's "Wild Swap Hands".** Official Force Trade: the player who played it picks **any two players, themselves optional**, and those two swap hands. The project's "Wild Swap Hands" only swaps the player who played it with one chosen player. That is a strict subset of Force Trade, and it is exactly the **classic deck's** Wild Swap Hands (sheet 42003) and the **Comeback Pack's** Wild Swap Hands (sheet JMM17). To match the Swap Pack, rename the card and allow a third-party pair.
- **Swap 1.** Official: take a **random** card from one other player, and give them **a card from your hand**. The sheet doesn't say the given card is random; the natural reading is that you choose it (MED-HIGH). The project (`Uno:swapOneCard`) swaps random-for-random. Make the given card a choice, keeping random as an option.
- **Refresh Hand: correction.** Official: old hand goes to the bottom of the **Discard Pile**. The project (`Uno:refreshHand`) and the first pass put it at the bottom of the **Draw Pile**. Fix needed.
- **Matching.** Swap 1 and Refresh Hand match by color **or** by their own symbol (stated on the sheet).

### 2b. Reverse Pack (JCV56)

| Card | Copies | Exact effect (JCV56 sheet) | Confidence |
|---|---|---|---|
| Reverse Draw 2 (colored) | 4 (1/color) | "Reverse the direction of play AND make the next player in that direction draw 2 cards and lose their turn. This card matches all other Reverse cards and Draw 2 cards and can be played on either type regardless of color." | HIGH (sheet JCV56); count MED-HIGH (pkg JCV56) |
| Reverse Skip (colored) | 4 (1/color) | "Reverse the direction of play AND the next player in that direction is skipped and loses their turn. This card matches all other Reverse cards and Skip cards and can be played on either type regardless of color." | HIGH (sheet JCV56); count MED-HIGH (pkg) |
| Wild Power Reverse | 4 | "Reverse the direction of play, choose the color that continues play, AND take another turn!" The package back calls it "Reverse AND skip everyone!" | HIGH (sheet JCV56); count MED-HIGH (pkg) |
| Wild NO U | 4 | "You may play this card: • In response to any Action Card that makes you draw cards. You reverse the direction of play, force **the player who played the Action Draw Card** to take the penalty, and choose the color that continues play. • On any card as a normal Wild Card to reverse the direction of play and then choose the color that continues play." | HIGH (sheet JCV56), **target conflict resolved**; count MED-HIGH (pkg) |

Edge cases: Wild NO U is a **response card**, played out of normal matching when a draw penalty hits you; the engine needs a response window. It answers "any Action Card that makes you draw cards", which includes Wild Draw 4 and Draw 2. With 2 players, Reverse Skip and Wild Power Reverse both give the player who played them another turn, and Reverse Draw 2 makes the opponent draw 2 and returns the turn to the player who played it. Standard Reverse = Skip logic (inference, MED).

### 2c. Stack Pack (JCV58)

| Card | Copies | Exact effect (JCV58 sheet) | Confidence |
|---|---|---|---|
| Stack 1 (colored) | 4 (1/color) | You may play it "• on a card of the matching color. The next player must draw 1 card and lose their turn. • in response to a Draw Card (+2, +4) if your card matches the color of the Draw 2 Card, or the chosen color for the Wild Draw 4. The total penalty is passed to the next player. For example, if a player plays a Wild Draw 4 and calls 'red,' you may play a red Stack 1 card which makes the next player have to draw 5 cards and lose their turn. • in response to a Stack Card. The penalty increases by 1 and the next player must draw the total of the Stack Cards. For example, if you play a Stack 1 in response to a Stack 2, the next player must draw 3 cards and lose their turn." | HIGH (sheet JCV58); count MED-HIGH (pkg JCV58) |
| Stack 2 (colored) | 4 (1/color) | "Just like Stack 1, only you force the next player to draw 2 cards." | HIGH (sheet JCV58); count MED-HIGH (pkg) |
| Wild Stack 3 | 4 | "• on any other card. You choose the color that continues play and the next player must draw 3 cards and lose their turn. • in response to any Draw Card or Stack Card. You choose the color that continues play and the penalty increases by 3 and passes to the next player." | HIGH (sheet JCV58); count MED-HIGH (pkg) |
| Wild Stack Number | 4 | "Same as the Wild Stack 3, except: To determine how many cards the next player must draw, flip over the top card of the Draw Pile until you reveal a Number Card. The number on the card is how many cards the next player must draw! Put any cards you flipped over under the Discard Pile." | HIGH (sheet JCV58); count MED-HIGH (pkg) |

Edge cases and key rulings:
- **Color gate applies only when answering a base Draw Card.** A colored Stack card answering a Draw 2 / Wild Draw 4 must match its color or the called color. Answering **another Stack Card has no color condition** on the sheet (HIGH, by the separate bullet).
- **Wild Stack Number gap closed:** flip until a Number Card. Flipped action/wild cards are skipped, and all flipped cards go **under** the Discard Pile. Remaining gap: a flipped **0** literally means draw 0 (LOW; the sheet is silent).
- Stack 1/2 on another card with the same symbol: the sheet only says "matching color" (unlike Swap 1's "or another Swap 1 card"). Allowing symbol-on-symbol is standard UNO matching (MED).
- Base Draw 2 / Wild Draw 4 can't answer anything; the pack grants response rights only to Stack Cards (MED inference, unchanged).

### 2d. Speed Pack (JCV57)

| Card | Copies | Effect | Confidence |
|---|---|---|---|
| Colored **number** cards with one "Speed Up" icon | 12 (3/color) | Play as a normal number card; raises the Speed Level by 1. Mattel shop: "All 16 cards in this pack have a 'Speed Up' icon." Which numbers appear isn't readable (photos show e.g. yellow 1, red 5). | identity MED-HIGH (pkg JCV57 art and product photo); count MED-HIGH (pkg back shows 12 colored + 4 wild) |
| Wild Double Speed Up | 4 | "Increases the speed by 2 levels and you get to choose the color that continues play!" | effect HIGH (sheet JCV57); count MED-HIGH (pkg) |

**Speed-level rule (HIGH, sheet JCV57):**
1. Normal UNO is Speed Level 1. "Every card with a 'Speed Up' icon you play increases the speed by one level. **Starting with the next player**, everyone must play an extra card on their turn for each icon played." Icons played in your own chain don't change your own requirement (gap closed).
2. At level N you must play N cards. "When playing multiple cards on your turn, each card must match the previous played card."
3. "Action Cards (Draw 2, Skip, Reverse, etc.) only take effect if they are the last card played. If you play 3 cards on your turn and the first or second card is an Action Card, the next player does not have to do the action."
4. Can't keep up: "they play what they can and then draw cards equal to the current Speed Level. For example, if the current speed is 4 and you are only able to play 2 cards, you play those 2 cards and then draw 4 cards. The speed is then reset to 1."
5. No cap on the level is printed (gap remains; no cap is the literal reading).

### 2e. Billie Eilish Add-On Pack (JHG45; 16 cards; ©2025 Lash Music)

| Card | Copies | Exact effect (JHG45 sheet) | Confidence |
|---|---|---|---|
| Wild Pass Color | unknown | "First, choose a color. Next, every player passes all the cards in their hand of that color to the player on their left. If a player has no cards of that color they don't have to pass but must still accept the cards passed to them. Play continues with the color you chose." | HIGH (sheet JHG45). Always to the **left**, not the direction of play. |
| Trick Wild Card | unknown | "First, choose a color. If the next player can't play a card of that color, you may immediately play again." | HIGH (sheet JHG45). Gap: whether the next player still draws or loses their turn isn't stated. |
| Wild Color Challenge | unknown | "First, choose a color. After that, all other players must show you a card of that color from their hand. Anyone who can't must draw 2 cards. If ALL players show a card of that color, you must draw 3 cards. Play continues with the color you chose." | HIGH (sheet JHG45). The backfire clause is official. |
| **Reverse Hands** (sheet name; shop and secondary sources say "Reveal Hands") | unknown | "When you play this card, everyone immediately lays their hands face up on the table, and play continues like this until your start your next turn." | HIGH (sheet JHG45) |

The sheet's own heading mislabels the cards as "REVERSE PACK CARDS" (a copy-paste error). Per-type counts are still UNVERIFIED (probably 4 each). Whether Reverse Hands is wild or colored isn't clear from the grayscale art.

### 2f. Frenemies Pack (JMM16) — NEW

All four card types are wilds (sheet JMM16 art; "+3" and "+1-4" icons).

| Card | Exact effect (JMM16 sheet) |
|---|---|
| Wild Nemesis | "Choose another player to be your 'enemy,' and anytime you play a card that makes them draw cards, they must draw 2 extra cards! This continues until you decide to end the beef! You also get to choose the color that continues play." |
| Wild Petty Play (+3) | "Choose another player to draw 3 cards. Also, if another player makes you draw cards for any reason, you may play this card out of turn and make them draw 3 cards." |
| Wild Eliminator | "All other players must discard all Wild Cards from their hand. Place all discarded Wild Cards on the bottom of the Discard pile. You also get to choose the color that continues play." |
| Wild Instigator (+1-4) | "Choose as many players as you want and make them draw cards. You also decide on how many cards each one will draw from 1-4. You also get to choose the color that continues play." |

Confidence: effects HIGH (sheet JMM16). Per-type counts UNVERIFIED (the sheet doesn't print them). Gaps: Petty Play out of turn doesn't say whether you still draw your own penalty, or whether a color is chosen. Nemesis has no stated way to "end the beef" beyond declaring it.

### 2g. Comeback Pack (JMM17) — NEW

| Card | Exact effect (JMM17 sheet) |
|---|---|
| Wild Swap Hands | "Swap hands with any player. You also get to choose the color that continues play." |
| Wild Double Down (-1) | "Discard this card and an additional card on top of it. You also get to choose the color that continues play." |
| Wild Match the Max | "Choose a player. That player must draw cards until their hand contains the same number of cards as the player with the largest hand. You also get to choose the color that continues play." |
| Wild Misery Loves Company | "All other players must draw cards until their hand contains the same number of cards as the player with the largest hand. You also get to choose the color that continues play." |
| **U-N-O Rule** (pack-wide) | "the cards have letters in the corner, either an 'U', 'N', or 'O'. If you have three cards in your hand that can spell out U-N-O, you may discard down to one card on your turn for an INSTANT UNO! Put all the cards under the 3 U-N-O cards on the Discard Pile and then select the next color in play. When you discard the U-N-O cards together, none of their actions are activated. And don't forget to yell 'UNO!'" |

Confidence: effects HIGH (sheet JMM17). Counts and the letter-to-card mapping are UNVERIFIED; the sheet art shows letters varying by copy. Note that this pack's Wild Swap Hands is exactly the project's current "Wild Swap Hands" behaviour.

### 2h. Defense Pack (JMM18) — NEW

| Card | Exact effect (JMM18 sheet) |
|---|---|
| Wild Block | "If someone plays a Draw or Skip card on you, block the penalty by playing this card. You also get to choose the color that continues play. You may also play this as a regular Wild Card." |
| Wild Block & Rebound (+1) | "If someone plays a Draw card (Draw 2, Wild Draw 4) on you, bounce it back to them and they must draw the cards, plus one more to boot! You may also play this as a regular Wild Card. You also get to choose the color that continues play." |
| Wild Block & Deflect | "If someone plays a Draw or Skip card on you, play this card to block and deflect the penalty to the next player in current order. You also get to choose the color that continues play. You may also play this as a regular Wild Card." |
| Wild Redirect | "If someone plays a Draw card on you, deflect it to a player of your choice! You also get to choose the color that continues play. You may also play this as a regular Wild Card." |

Confidence: effects HIGH (sheet JMM18). Counts UNVERIFIED. Gaps: Rebound doesn't reverse direction (unlike NO U). Whose turn follows a block, rebound or redirect isn't stated.

### 2i. Love Island Add-On Pack (JPH28; ©2026 ITV) — NEW

Contents: 16 cards, **including** two placeholder cards (Coupled Up, Eggs In One Basket) and one "I've Got a Text" Special Rules reference card, which are removed before play. That leaves 13 playable cards; the split is UNVERIFIED.

| Card | Exact effect (JPH28 sheet) |
|---|---|
| Wild Coupled Up | Choose another player to be coupled with you; put the placeholder in front of them. "While coupled, if that player cannot play a card on their turn, you may immediately play a playable card from your hand for them instead. They do not draw a card. If the played card requires any choices ... you make those choices. Play then continues in turn order from the coupled player who originally could not play a card. The coupling remains in effect until another Wild Coupled Up Card is played." Wild. |
| Wild Eggs In One Basket | Choose another player; placeholder in front of them "for the rest of the game." While in effect: "Any time that player reaches UNO, you immediately discard cards from your hand until you also have one card. All discarded cards are placed on the bottom of the Discard Pile." And "If that player is forced to draw cards due to a Draw 2 or Wild Draw 4 Card, you must draw the same number of cards as well." Wild. |
| Wild Pull You For A Chat | "Choose another player and secretly view their entire hand. You may take one card from their hand and replace it with one card from yours." Wild. |
| I've Got a Text (colored, per sheet art) | Choose one: "• Everyone except you draws one card. • Swap hands with any player. • All players except you must reveal a card from their hand that matches the color of the card you played. If a player cannot, they must draw cards until they reveal a matching color. Drawing a Wild Card does not count." |

Confidence: effects HIGH (sheet JPH28).

---

## 3. Official classic rules and house-rule definitions

### 3a. Classic UNO (current deck, sheet 42003 "Wild" printing)

**Contents (HIGH, sheet 42003):** 112 cards = 19 per color (0-9: one 0 and two each of 1-9), 8 Draw Two, 8 Reverse, 8 Skip (2 per color each), 4 Wild, 4 Wild Draw Four, **1 Wild Swap Hands**, **3 Wild Customizable**. "For a classic game of UNO, take the Wild Swap Hands card and 3 Wild Customizable cards out of the deck." The 2008 "UNO Basic" printing (41940) is the 108-card deck without them.

| Rule | Official wording | Confidence |
|---|---|---|
| **Drawing / reneging** | "If you don't have a card that matches ... you must take a card from the DRAW pile. If the card you picked up can be played, you are free to put it down in the same turn." "You may also choose NOT to play a playable card from your hand. If so, you must draw a card ... If playable, that card can be put down in the same turn, however you may not play any other card from your hand after the draw." | HIGH (sheets 42003, 41940) |
| **Wild Draw Four legality and challenge** | "You may only play this card when you do NOT have another card in your hand that matches the COLOR on the DISCARD pile (but it is acceptable to play this card if you have matching number or Action Cards)." "If you suspect that a Wild Draw 4 card has been played on you illegally ... you may challenge that player. The challenged player must show you (the challenger) their hand. If guilty, the challenged player must draw the 4 cards instead of you. However, if the challenged player is innocent, you must draw the 4 cards PLUS an additional 2 cards (6 total)!" The older printing adds: "Only the person required to draw the 4 cards can make the challenge." | HIGH (sheets 42003, 41940, 42001/42003 old) |
| WD4 challenge: who plays next | Not stated on any sheet. Wikipedia: after a successful challenge "play continues with the challenger"; after a failed one the challenger "misses their turn". The chosen color stands either way. | MED (Wikipedia only) |
| **UNO call** | "If you don't yell 'UNO' and you are caught before the next player begins their turn, you must draw **two** cards." The **pre-2008 printing said FOUR** cards, and defined "beginning a turn" as drawing from the DRAW pile or drawing a card from hand to play. You can't be caught until your second-to-last card touches the pile; catching yourself first makes you safe. | HIGH (sheets 42003, 41940; old 42001/42003) |
| Last card is Draw Two / WD4 | The next player must still draw; those cards count in the score. | HIGH (sheet 42003) |
| **Scoring** | Numbers face value; Draw Two, Reverse, Skip 20; Wild, Wild Draw Four 50; **Wild Swap Hands 40; Customizable 40**. First to 500 wins. Alternative: keep a running tally of points held; when someone reaches 500, the lowest total wins. | HIGH (sheet 42003) |
| **Wild Swap Hands (classic)** | "Choose any opponent and swap all the cards in your hand with all the cards in their hand ... you choose the color that resumes play." | HIGH (sheet 42003) |
| **Two players** | Printed only on the **older** sheet: "1. Playing a Reverse card works like playing a Skip card. By playing the Reverse card, you may immediately play another card. 2. By playing a Skip card, you may immediately play [another card]. 3. After playing a Draw 2 card or a Wild Draw 4 card, your opponent draws the number of cards indicated, and play is back to you." The current 42003 and 41940 sheets omit 2-player rules. | HIGH (old sheet 42001/42003-Eng) |
| **Partners (4 players)** | "Sit across from your partner. When either partner goes out, the hand is over. Total all of the points in both opposing partners' hands and score for the winning team." Variation: rotate partners over 12 hands (4 players) or 28 hands at two tables (8 players). | HIGH (old sheet 42001/42003-Eng) |
| **Challenge UNO** | Keep a running total of points *held*; anyone reaching the target (500 suggested) is eliminated; the last two play head-to-head under the 2-player rules; the winner of the final hand wins. "THE MAKERS OF UNO FIND THIS VARIATION THE MOST CHALLENGING WAY TO PLAY." | HIGH (old sheet; same text on Attack sheets 41943, T8219) |
| **Stacking in base UNO (official ruling)** | Not allowed. @realUNOgame, **May 4, 2019**: you cannot stack Draw 2 and Draw 4 cards; repeated Sept 28, 2022 for +2 on +2. The ruling refers to the core rules: the 2008 sheet's own "Progressive UNO" house rule *does* allow same-type stacking. | HIGH (multiple news sources); consistent with the sheets |

### 3b. Official house rules (sheet 41940 "UNO Basic", ©2008)

The sheet lists these under "HOUSE RULES: You may want to try some of the following 'House' Rules". They are all **HIGH (sheet 41940)**.

| Rule | Exact official text |
|---|---|
| **Progressive UNO** | "1. When a player plays a Draw Two card, the next player may play another Draw Two card, causing the next player to draw 4 cards. 2. Same rule applies to Wild Draw Four cards: When a player plays a Wild Draw Four card, the next player may play another Wild Draw Four card, causing the next player to draw 8 cards. The last player to play a consecutive Wild Draw Four card calls the color to continue play. If a Wild Draw Four card is played illegally and the player is challenged, the usual rules apply ... except that the penalty will increase depending on the number of cards played. 3. Players can continue to play consecutive Draw Two or Wild Draw Four cards, as long as they have them in their hands. For example, if 4 players in a row played Draw Two cards, the next player (who doesn't have a Draw Two card) would have to draw 8 cards. 4. You can only play one Draw Two or Wild Draw Four during your turn, even though you may have multiples of these cards in your hand." So stacking is same type only (+2 on +2, +4 on +4), never mixed. |
| **Seven-O** | "1. Every time a '0' is played, all players pass their hands to the next player in direction of play. 2. Every time a '7' is played, the player who played the '7' card must trade their hand with another player of their choice." |
| **Jump-In** | "If you are holding the exact same card (identical color and number) as the card on top of Discard Pile, you may play it immediately, regardless of whose turn it is ... Play resumes from the player who played the last card (the player who 'jumped in'). Two important things to remember: 1. If you have 2 matching cards in your hand, you may play them back-to-back, but they must be played one at a time ... This gives another player a chance to 'jump in' and stop you from playing a second card. 2. If you 'jump in' with a Skip, Reverse, Draw Two or Wild Draw Four, **the second identical card played cancels out the first**. (Follow normal UNO card game rules for these cards beginning with the player who played the second identical card.)" |
| Combining | "For a truly twisted game, try combining multiple UNO CARD GAME HOUSE RULES. If the rules conflict, let YOUR HOUSE define the best way to play!" |

**Corrections:** Progressive UNO was previously sourced from a Noble Knight summary (MED); it's now sheet-verified, including the "one per turn" clause and the challenge-penalty scaling. Jump-In on action cards was previously LOW-MED variant text. The official ruling is that the jump-in card **cancels and replaces** the first, with effects applied from the jumper; it does **not** add to a stack. WD4 is explicitly allowed as a jump-in card.

### 3c. Ubisoft / digital-only toggles (unchanged, not on any sheet)

| Rule | Definition | Confidence |
|---|---|---|
| **Draw to Match** (Ubisoft) | "Drawing is continued until a card can be played instead of just one draw." | MED (MobyGames) |
| **Force Play** (Ubisoft) | "A drawn card that can be played is played automatically." The official sheets make playing the drawn card optional. | MED |
| **No Bluffing** (Ubisoft) | Its code flag is `FREE_WILD_DRAW4`: Wild Draw Four can be played at any time, so there is nothing to challenge. No menu text defines it (spec 11). | MED (code flag name) |
| **2v2** (Ubisoft) | Partners sit opposite and see each other's hand; team wins when **one** partner empties their hand. Matches the official Partners rule ("When either partner goes out, the hand is over"). UNO Wonder "Teams" (2026) instead needs both partners out. | Win condition MED-HIGH (official Partners rule agrees); hand visibility MED |

### Edge cases & rulings
- WD4 challenge with stacking: Progressive UNO (sheet 41940) is the only official ruling. A challenge on a stacked WD4 follows the usual rules, but the penalty scales with the number of cards played.
- Jump-In and draw penalties: officially the jumped card **cancels** the first and its effect starts from the jumper (sheet 41940).

---

## 4. UNO Attack

### 4a. Original UNO Attack! (1999, Mattel 41943; 112 cards plus launcher)

| Card | Copies | Effect (41943 sheet) | Confidence |
|---|---|---|---|
| Number cards 1-9 (no 0s) | 72 (18/color) | Face value. | HIGH (sheet 41943) |
| Hit 2 | 8 (2/color) | "The next player must hit the Launcher button twice. His/her turn is then over." | HIGH (sheet 41943) |
| Reverse | 8 (2/color) | Reverse direction. | HIGH (sheet 41943) |
| Skip | 8 (2/color) | Next player loses their turn. | HIGH (sheet 41943) |
| Discard All | **4 (1/color)** | Discard all cards of one color with the Discard All on top; "You may also discard a Discard All card on top of another Discard All card." | HIGH (sheet 41943) |
| Trade Hands | **4 (1/color)** | "The player discarding the Trade Hands card MUST trade his/her hand with another player of his/her choosing." "A player may not go out on a Trade Hands card." | HIGH (sheet 41943) |
| Wild | 4 | Standard wild. | HIGH (sheet 41943) |
| Wild All Hit | 2 | Call a color; "each player (beginning with the person to the discard player's left) must press the Launcher button once ... The player who played the Wild All Hit card does not press." | HIGH (sheet 41943) |
| Wild Hit-Fire | 2 | Call a color; "the next player in the direction of play must press the Launcher button until the Launcher shoots out cards ... and forfeits his/her turn." | HIGH (sheet 41943) |

Total 112. Scoring: numbers face value; Reverse, Skip, Hit 2 20; Discard All, Trade Hands 30; Wild, Wild All Hit, Wild Hit-Fire 50; 500 to win (sheet 41943).

### 4b. Later editions

**Correction:** the first pass attributed "4 Reverse, 3 Customizable, 1 Wild Hit 4" to T8219. The T8219 sheet doesn't contain them; they come from **GTX66**.

| Edition (sheet) | Contents (all 112 cards; 72 numbers 1-9 in each) | Confidence |
|---|---|---|
| **T8219** (2010s) | 8 Hit 2, **8 Reverse**, 8 Skip, 8 Discard All (2/color), 4 Wild, **4 Wild Attack-Attack** | HIGH (sheet T8219) |
| **GTX66** | 8 Hit 2, **4 Reverse** (1/color), 8 Skip, 8 Discard All, 4 Wild, 4 Wild Attack-Attack, **3 Wild Customizable, 1 Wild Hit 4** | HIGH (sheet GTX66) |
| **GXY78 / GXY81 (2020, "Mega Hit")**; GNL02 | **4 Reverse** (1/color), 8 Skip, 8 Discard All, **4 Hit 1** (1/color), 8 Hit 2, 4 Wild, 4 Wild Attack-Attack | HIGH (sheets GXY81, GNL02). The GXY78 product page serves the GXY81 sheet. |

| Card | Effect | Confidence |
|---|---|---|
| Wild Attack-Attack | Call a color and "choose ANY OTHER PLAYER in the game to 'Attack.'" **The sheets differ on who presses and who plays next:** *T8219*: the launcher faces the victim and "the 'attacking' player gets to press the Launcher button twice"; play continues to the left of the player who played it. *GTX66 / GXY81*: the chosen player "must hit the button twice. The game then continues with the next player in turn order after the player who got attacked." *GNL02*: the attacked player presses twice; play continues with "the second player to the left ... of the player who played the Wild Attack-Attack card." All allow going out on it ("may use this command card as normal before the game ends"). | HIGH per sheet; **editions conflict**. Recommend the GXY81 version (newest). |
| Hit 1 | "The next player in current order must hit the Launcher button once. His/her turn is then over." | HIGH (sheets GXY81, GNL02) |
| Wild Hit 4 (1 copy) | "Next player must hit the Launcher button FOUR TIMES. Their turn is then over ... This card is also a wild card." | HIGH (sheet GTX66) |
| Wild Customizable (3) | Write your own house rule in pencil; decide before the game how many (1-3) to include; wild. | HIGH (sheet GTX66) |
| Discard All | As in the original. The 2020 wording is "you may discard multiple yellow cards in your hand, as long as a yellow Discard All card is placed on top." | HIGH |

Scoring by sheet: T8219 has Reverse/Skip/Hit 2 20, Discard All 30, Wild/Attack-Attack 50. GTX66 adds Wild Hit 4 40 and Wild Customizable 50. GXY81 and GNL02 have Hit 1 20, **Hit 2 40**, Discard All 30, Wild/Attack-Attack 50. All play to 500.

### 4c. Launcher rules
- **No playable card:** press once. If nothing comes out, play moves on. If cards shoot out, add them to your hand (all editions, HIGH).
- **Turn ends on any press (2020 era):** "in UNO ATTACK, if cards shoot out when you press the button and one or more of them are playable, you MAY NOT throw them down ... ONCE YOU PRESS THE LAUNCH BUTTON YOUR TURN IS OVER" (sheets GXY81, GTX66). The older sheets imply the same.
- **Reneging:** "You may choose not to play a playable card from your hand. If so, you must hit the Launcher button. Your turn is then over" (sheets 41943, T8219, GNL02; GXY81 words it inside Let's Play).
- Cards left sticking out of the launcher go to the player who activated it (all sheets).
- **Forfeit on fire:** "If any cards shoot out ... before you finish pressing the button the required number of times, you may forfeit the remaining presses" (sheets GXY81, GNL02, inside the Mega Hit section). No Mercy Attack reverses this (see §1).
- **UNO not called:** press twice (all sheets).
- **Penalties:** "Any player making a card suggestion to another player must hit the Launcher button 4 times" (sheets 41943, T8219, GNL02).
- **Two players:** Reverse acts as Skip and you may play again; Skip lets you play again; after the opponent completes a Hit 2, play is back to you (all sheets).
- Rotate the launcher to face whoever's turn it is.

### 4d. "Mega Hit" rule (sheets GXY81 and GNL02; HIGH)
"Mega Hit" is both the 2020 product name (GXY81 / GNL02 "UNO Attack Mega Hit") **and** a rule printed in those sheets. It is not in T8219 or GTX66.
- "Whenever someone plays a Hit card against you (Hit 1, Hit 2, or Wild Attack-Attack), you can play ANY Hit card from your hand on top of it (regardless of color)." There's **no value restriction**, unlike No Mercy. "(a) you don't have to perform the hit, and (b) the next player in current order will have to perform BOTH hits," and so on until "a player that has no Hit card in their hand. That player will then have to perform ALL THE ADDED-UP HITS."
- A Wild Attack-Attack in the stack "adds 2 more hits to the stack ... and allows them to send the attack to any player" (worked example: Hit 1 + Hit 2 + Attack-Attack = 5 presses, sent back to the original player).
- "If the first card played is a Wild Attack-Attack card and the player being attacked has a Hit card, they may play it and start a Mega Hit stack. The next player IN THE CURRENT ORDER FROM THE ATTACKED PLAYER must then either play a Hit card or perform all the hits in the stack."
- "After a Mega Hit stack has played out, game play continues with the next player in the current order from THE PLAYER WHO LAID DOWN THE FIRST HIT CARD."
- The forfeit-on-fire rule applies to the accumulated presses.

---

## Cross-mechanic interaction notes

1. **There are six incompatible official stacking/response models**, so the engine needs a "stack policy" enum, not a boolean:
   - **Base UNO:** no stacking (2019/2022 rulings).
   - **Progressive UNO (sheet 41940):** same type only (+2 on +2, WD4 on WD4), one per turn; the last WD4 player calls the color; challenge penalties scale.
   - **No Mercy (HWV18) and No Mercy Attack (JNK69):** any Draw/Hit Card of **equal or higher value than the last card played**. The No Mercy Coin doubles that card's value, and the doubled value counts when stacking (JJB29).
   - **Stack Pack (JCV58):** colored Stack cards answer a Draw 2/WD4 only on matching color; on other Stack cards with no color condition; Wild Stack 3/Number answer anything.
   - **UNO Attack Mega Hit (GXY81/GNL02):** any Hit card on any Hit card, regardless of color or value. Play resumes after the *first* Hit player.
   - **Deflectors (no adding):** Wild NO U (JCV56) sends the penalty to whoever played the draw card. Defense Pack (JMM18): Block cancels it, Block & Rebound returns it +1, Block & Deflect passes it to the next player, Redirect sends it to any player. Frenemies' Wild Petty Play (JMM16) is an out-of-turn +3 counter.

   With No Mercy and Stack Pack both on, a Stack 1 (value 1) can never follow a +2 under "equal or higher". Recommend: each pack's own text governs its own cards.
2. **Wild NO U vs Wild Reverse Draw 4.**
   - NO U **bounces** the penalty to "the player who played the Action Draw Card" without adding to it. WRD4 **adds 4** and reverses.
   - In a multi-card stack, "the player who played the Action Draw Card" most naturally means the last player who added (MED).
   - No sheet rules on NO U against Color Roulette (not a draw *card penalty* in the stacking sense; Roulette is a reveal) or NO U on NO U. Recommend allowing NO U on NO U.
3. **Jump-In vs active stacks (official, sheet 41940):** an identical +2/WD4 jumped in **cancels** the first and applies its own effect from the jumper, so the original victim draws nothing and the player after the jumper draws 2/4. It never adds to a stack. Ubisoft's "jump in and add" is a digital house variant; keep it only as an optional sub-mode. Jump-In under No Mercy, Stack Pack or Mega Hit was never addressed officially.
4. **Jump-In with wilds:** the sheet explicitly allows jumping in with a Wild Draw Four (an identical card). For No Mercy's many wilds, "identical" most naturally means the same face (Wild Draw 6 on Wild Draw 6) (MED).
5. **Seven-O vs No Mercy:** No Mercy's 7/0 rules are word-for-word Seven-O (sheets HWV18, 41940), so enabling both must not double-apply them.
   - Mercy: "If a player **ever** has 25 or more cards," so check after every hand change, including passes and swaps.
   - **Threshold wording differs across sheets:** "25 or more" (HWV18, JNK69 Mercy rule) vs "more than 25" (JJB29 Mercy Coin) vs "exceed 25" (JNK69 Ultra Attack note). Use ≥25 as the rule and treat the others as loose wording (MED).
   - Billie Eilish's Wild Pass Color always goes **left**. The Swap Pack's Wild Pass Hands and the No Mercy 0 follow the current direction.
6. **Hand-swap code needs two arbitrary seats.** Wild Force Trade (JCV59) can swap two *other* players. The 7, classic Wild Swap Hands (42003), Comeback Wild Swap Hands (JMM17), Attack Trade Hands (41943) and Love Island's "swap hands with any player" all involve the player who played them.
7. **Draw rules differ by edition.** No Mercy: draw until playable, then you **must** play it (HWV18). Classic: draw one, optionally play it (42003). Attack and No Mercy Attack: press, and your turn is over. Draw to Match is redundant under No Mercy, and No Mercy already behaves like Force Play.
8. **Speed Pack vs everything (sheet JCV57):** actions only fire when last in the chain, so a mid-chain +2, Stack card, 0 or 7 does nothing (0/7 count as action-like here, inference). The speed-failure draw (N cards) has no official interaction with a pending stack or the Mercy Rule.
9. **WD4 challenge vs stacking:** only Progressive UNO rules on it (scaled penalty). No Mercy, the Stack Pack and the Defense Pack never mention challenges. Recommend: the challenge is available only to the player the WD4 (or stack) finally lands on.
10. **UNO Attack launcher vs "draw then play":** pressing ends your turn (2020 sheets explicit). An Attack mode must disable Force Play and Draw to Match. No Mercy Attack: you must finish all presses even if cards fire. Classic Attack Mega Hit: you may stop once cards fire.
11. **No Mercy Coin (resolved):** it doubles the played Draw Card's own value, and that doubled value is what the next player must meet or beat. It is once per **game**; the side is declared at game start (JJB29).
12. **Love Island persistent effects:** Coupled Up and Eggs In One Basket create standing links between two players that react to other cards. Eggs In One Basket's "must draw the same number" triggers only on Draw 2 / Wild Draw 4, so a literal engine excludes other draw sources such as Stack cards or Wild Petty Play. Frenemies' Wild Nemesis (+2 on every draw you cause to one player) is another standing link. The engine needs a per-player modifier list.

### Open gaps (highest priority first)
1. **No Mercy per-card counts:** not printed on HWV18. The fan-wiki breakdown sums to 168 (MED). Confirm from a physical deck or a card photo.
2. **Deadpool edition:** card names known (Wild Reverse Draw 10, Wild Gimme!, Wild Maximum Effort), effects UNVERIFIED. Rock-Paper-Scissors-Shoot! wasn't found at all.
3. **Per-type counts:** JJB29 (24 cards, 5 types), JNK69 (168 cards), Billie Eilish, Frenemies, Comeback, Defense, Love Island (13 playable). Swap/Reverse/Stack (4 each) and Speed (12 + 4) rest on package art only.
4. Speed Pack: which numbers the 12 colored cards carry. Comeback: which letter each card carries.
5. Wild Attack-Attack: who presses and where play resumes differs across T8219 / GXY81 / GNL02.
6. Smaller sheet silences: who plays next after a WD4 challenge; Trick Wild's effect on the next player; Wild Stack Number flipping a 0; turn order after Defense Pack blocks.
7. Ubisoft's 2v2 hand visibility. (No Bluffing is now resolved from the code flag, see spec 11.)
