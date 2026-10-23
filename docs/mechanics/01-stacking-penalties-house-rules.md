# Final review 1: Stacking, penalties and official house rules

> Reference spec for `docs/gameversions.md` (see its Part F). Gathered from web-search snippets only; direct page fetches were blocked during research, so treat anything below HIGH as needing a check against the official instruction sheet before shipping.

Research cluster: UNO Show 'Em No Mercy (and its expansion and Deadpool editions), the 2024-25 Add-On Packs, official house-rule definitions, and UNO Attack.

**Method and limits.** WebFetch and curl were blocked, so everything here comes from WebSearch result snippets (33 queries). Some snippets quote Mattel instruction sheets directly: HVW18 (No Mercy), JCV58 (Stack Pack), JHG45 (Billie Eilish), T8219, GXY78 and GNL02 (UNO Attack). Others come from retailers (Mattel shop, Kmart, Silicon Power and Shop of Magic listings), GeekyHobbies, GameRules, Miexto, Wikipedia and BGG.

**Confidence tags:**
- **HIGH**: two or more independent sources agree.
- **MED**: one detailed, plausible source, or a direct quote from a Mattel sheet seen in only one snippet.
- **LOW**: thin, inferred, or from my own prior recollection. These are marked **[recall]** and must be checked against the physical sheet.

**Mattel instruction-sheet URLs.** These can't be fetched here; a human with a normal browser should check them.
- No Mercy: `https://service.mattel.com/instruction_sheets/HVW18-Eng.pdf`
- Stack Pack: `https://service.mattel.com/instruction_sheets/JCV58-Stack.pdf`
- Billie Eilish: `https://service.mattel.com//instruction_sheets/JHG45_English.pdf`
- UNO Attack (classic): `https://service.mattel.com/instruction_sheets/T8219.pdf`
- UNO Attack (2020): `GXY78-FR.pdf`, `GXY81-Eng.pdf`, `GNL02-SP.pdf`
- Swap Pack / Reverse Pack / Speed Pack: by product-code pattern, likely JCV59 / JCV56 / JCV57. The add-on pack sheets also turn up as `JCW36.pdf` to `JCW39.pdf`.

---

## 1. UNO Show 'Em No Mercy (2023, Mattel HVW18, 168 cards)

### Card table

| Card | Copies | Exact effect (official wording where snippet-quoted) | Confidence |
|---|---|---|---|
| Number cards 0-9 (4 colors) | 80 (2 of each number per color) **[recall]** | Face value. 1-9 have no special effect. 0 and 7 have the effects below. | effect HIGH; count LOW |
| 7 | (part of the number cards) | "Drop a 7 to swap hands with the player of your choice." (Nintendo/Ubisoft listing). Swapping is mandatory, not optional. | HIGH |
| 0 | (part of the number cards) | Every player passes their hand to the next player in the direction of play. | HIGH (Sainsbury's loosely says "swap hands with another player"; Epic, Nintendo and Ubisoft say pass. Use pass.) |
| Skip | 12 (3/color) **[recall]** | Next player loses their turn. | effect HIGH; count LOW |
| Reverse | 12 (3/color) **[recall]** | Reverses direction. With 2 players it acts like a Skip (standard rule). | effect HIGH; count LOW |
| Draw 2 (colored) | 12 (3/color) **[recall]** | Next player draws 2 and loses their turn. Stackable. | effect HIGH; count LOW |
| Draw 4 (colored, *not* wild) | 8 (2/color) **[recall]** | Next player draws 4 and loses their turn. Plays on color or symbol like any colored card. Stackable. | existence HIGH (the stacking list "+2, +4, +6, +10" includes it, and Miexto lists "Draw 4"); count LOW |
| Discard All | 12 (3/color) | "Discard all the cards in your hand that match the color of the Discard All Card. Place the extra cards under the Discard All Card." (HVW18 snippet) | effect HIGH; count MED (Miexto "Discard All Card – 12") |
| Skip Everyone | 8 (2/color) **[recall]** | "Skip all the other players and take another turn." (HVW18 / Ubisoft) | effect HIGH; count LOW |
| Wild Reverse Draw 4 | 8 **[recall]** | Choose a color, reverse direction; the next player *in the new direction* draws 4 and loses their turn. HVW18 snippet: "With just two players this card skips the other player and makes YOU draw 4 cards! You may use the stacking rule to send the penalty back to the other player." | effect HIGH; 2-player clause MED (single quoted snippet); count LOW |
| Wild Draw 6 | 4 **[recall]** | "The next player must draw 6 cards and lose their turn." (HVW18) | effect HIGH; count LOW |
| Wild Draw 10 | 4 **[recall]** | "The next player must draw 10 cards and lose their turn." (HVW18 via Ubisoft) | effect HIGH; count LOW |
| Wild Color Roulette | 8 | Snippet (attributed to Mattel): "**The next player chooses a color.** After that, they must reveal cards one at a time from the Draw Pile until they get a card of that color (Wild Cards do NOT count). Then they add all the revealed cards to their hand and lose their turn." | effect MED. **Conflict on who picks the color:** the Mattel snippet says the *next* player; Miexto says "the color **you** decide". Count MED (Miexto "Wild Color Roulette Card – 8") |

**Count check.** The recalled counts sum to 168 (80 + 12 + 12 + 12 + 8 + 12 + 8 + 8 + 4 + 4 + 8), which matches the official total (HIGH). The only counts confirmed by a source are Discard All (12) and Wild Color Roulette (8), both from Miexto (MED). Before shipping, check the counts against the HVW18 contents box or the matteluno.fandom.com page "Uno_Show_'Em_No_Mercy".

### Core rules

1. **Stacking (HVW18, quoted in a snippet; MED-HIGH):** "If someone plays a Draw Card (+2, +4, +6, +10) you can 'Stack' the penalty by playing a Draw Card from your hand of **equal or higher value**. If you do, the card you played adds to the total penalty for the next player." The stack continues until a player can't or won't stack; that player draws the whole accumulated total. Two further sources (a Nintendo article and Lilach Bullock) independently give the "equal or higher" wording, so the rule itself is HIGH.
   - Value is the number printed on the card. Colored Draw 4, Wild Draw 4 and Wild Reverse Draw 4 are all value 4. So +2 can go on +2. +4 (colored or Wild Reverse) can go on +2 or +4. +6 can go on +2, +4 or +6. +10 can go on anything, including +10.
   - Lower can't go on higher: no +2 on +4, no +4 on +6.
   - **Wild Reverse Draw 4 stacks** as a +4 and reverses direction, so the stack returns to the previous player (HVW18 explicitly mentions "use the stacking rule to send the penalty back"). HIGH that it stacks; MED on the exact sending-back mechanic for 3+ players.
   - Color matching is not required when stacking (implied by "equal or higher value"). A colored Draw 4 or Draw 2 can be laid on a Wild Draw 6 or similar regardless of color, as long as the value is high enough. MED (implied, not quoted).
   - Wild Color Roulette, Skip Everyone, Reverse and Skip are **not** Draw Cards, so they can't be used to answer or deflect a stack. Inferred from the wording; MED.
   - Whoever finally draws the total also loses their turn. Implied by "lose their turn" on each card; MED.
2. **Draw until you can play (HIGH):** "If you don't have a matching card, you keep drawing until you find one" (Nintendo listing plus fan guides). LOW: whether the drawn playable card must be played immediately. Most sources imply yes.
3. **Mercy Rule (HIGH):** "If your hand has 25 or more cards, you're out, no second chances!"
   - The check is ≥25, not >25.
   - It applies whenever a hand reaches 25, including in the middle of a penalty draw, and during a 0 or 7 hand swap. The swap case is inferred; LOW.
   - **What happens to an eliminated player's cards: NOT FOUND (gap).** Two plausible readings: shuffled into the Draw Pile, or placed at the bottom of it. Recommend making this an engine option and verifying against HVW18.
4. **Win condition (HIGH):** Win the round by emptying your hand **or** by being the last player standing after everyone else is knocked out (Ubisoft: "get rid of all your cards, or you can knock other players out by filling their hand with too many cards").
5. **Scoring (MED that it exists, values LOW):** The HVW18 snippet says "All number cards (0-9) face value." I recall the target as 1,000 points. **[recall]** Action cards 20, Skip Everyone/Draw 4 around 25-30, Wilds 50. None of these values were confirmed; check the sheet.
6. **UNO call:** standard. No No-Mercy-specific penalty was found.

### Edge cases & rulings
- **2-player Wild Reverse Draw 4** (MED, quoted): the card skips the opponent and **the player who played it draws 4**, unless they stack it back. This is the oddest official clause; implement it literally behind a flag.
- **2-player Reverse** = Skip (standard).
- **2-player Skip Everyone** is the same as a Skip: you take another turn.
- **Discard All:** "extra cards go under the Discard All card." The Discard All itself stays on top, so its color is the active color. LOW: whether you may go out by discarding your whole hand this way. Normally yes, since the card says "all".
- **Color Roulette chooser conflict:** the next player choosing the color reads as the official wording (MED). Note that if the victim chooses, they would pick the color most likely to show up early. The next player draws and loses their turn.
- **Skip Everyone:** after the skip, you take another turn immediately and may play any legal card.
- Whether 0, 7 or Discard All can be played as an "answer" during a pending stack: **no**, only Draw Cards answer (inferred, MED).

### No Mercy Expansion Pack (Mattel JJB29, 2024-25)

| Item | Copies | Effect | Confidence |
|---|---|---|---|
| "#10" number cards with "Ten Replay" modifier | 8 (BGG) | Number card 10. The player who plays it immediately takes another turn. | MED (BGG and BoardGameBliss) |
| Wild Discard All | 8 | Choose a color, then discard every card you hold of that color. | MED (BGG and fandom) |
| Third card type | 8 (inferred: 24 − 16) | **NOT FOUND.** My recollection of a "Wild Sudden Death"-type card is unverified and LOW; don't implement from this. | gap |
| Mercy Coin | (6 coins total, split unknown; likely 3+3, LOW) | Throw out your hand and draw a new one. Once per round. | HIGH (Mattel shop and retailers) |
| No Mercy Coin | (see above) | Doubles the penalty of a played card. Once per round. | HIGH |

The pack can't be played on its own; it needs the No Mercy base deck (HIGH).

### Deadpool edition / "Wild Reverse Draw 10"
**NOT FOUND.** No snippet mentioned a Deadpool No Mercy edition or a Wild Reverse Draw 10. If the card exists, the natural model is Wild Reverse Draw 4 with value 10: it stacks on anything ≤10 and sends the stack back to the previous player. That is inference only (LOW).

---

## 2. UNO Add-On Packs (2024-2025; 16 cards each; need a classic deck; HIGH)

GeekyHobbies: "The normal rules of UNO still apply… Each pack adds 16 new cards."

### 2a. Swap Pack (JCV59)

| Card | Copies | Exact effect | Confidence |
|---|---|---|---|
| Swap 1 (colored) | unknown (16 total ÷ 4 types → probably 4, i.e. 1 per color) | "Take a random card from another player's hand and give them a card from your hand." (Kmart, Mattel shop) | effect HIGH; count LOW |
| Refresh Hand (colored) | probably 4 (1/color) | "Put your entire hand at the bottom of the draw pile and draw a new hand of the same size." | effect HIGH; count LOW |
| **Wild Force Trade** | probably 4 | The player who plays it **chooses any two players** (Mattel listing: "including themselves") who must trade hands. The player who played it chooses the color. | HIGH (several retailers plus the Mattel shop) |
| Wild Pass Hands | probably 4 | Every player, including whoever played it, passes their hand to the next player in the current direction of play. | HIGH |

**Check against the project's implementation (`src/card.lua`, `src/uno.lua`, `README.md`):**
- **Name mismatch.** The real card is **"Wild Force Trade"**, not "Wild Swap Hands". "Wild Swap Hands" is the classic-deck card (1 per 2018+ classic deck). Rename it, or keep the old name as an alias.
- **Rule mismatch.** Wild Force Trade lets the player pick **any two players**, which may or may not include themselves. The project currently implements "swap with a chosen player" (always including self). The official card is a superset: a 3rd-party swap must be allowed.
- **Swap 1.** The official card *takes a random card* from the target and *gives them one from your hand*. The wording implies **you choose** which card to give. The project swaps a random card for a random card. Retailer wording is "give that player a card from your hand"; it isn't explicit that the given card is chosen, so LOW-MED.
- **Refresh Hand.** "Bottom of the draw pile, draw the same number" matches the project.
- **Copy counts.** The project uses 4 Wild Swap, 4 Wild Pass and 1 per color of each colored card, totalling 16. That is consistent with 16 cards and 4 types × 4, but the per-type split is unconfirmed.

### 2b. Reverse Pack (JCV56)

| Card | Copies | Exact effect | Confidence |
|---|---|---|---|
| Reverse Draw 2 (colored) | probably 4 | Reverses direction **and** the next player (in the new direction) draws 2 and loses their turn. | HIGH (GeekyHobbies and a retailer) |
| Reverse Skip (colored) | probably 4 | Reverses direction **and** skips the next player. | HIGH |
| Wild Power Reverse | probably 4 | Choose a color, reverse direction, and the player who played it takes another turn. | MED-HIGH |
| Wild NO U | probably 4 | Reverses direction and changes color. It can be played **in response to a draw penalty** to bounce it. **Conflict:** one listing says it bounces the penalty "back to the previous player"; another says "back on the player who played it". | MED. Both phrasings likely mean the player who played the *draw* card, which with direction reversed is the previous player. Verify. |

Edge cases: Wild NO U is the only add-on card explicitly designed to be played **out of the normal matching rules, as a response**. The engine needs a "response window" when a draw penalty is pending. With 2 players, Reverse Skip and Wild Power Reverse both just give the player who played them another turn. Reverse Draw 2 with 2 players means the other player draws 2 and you play again. That follows from the standard Reverse = Skip rule (inferred, MED).

### 2c. Stack Pack (JCV58; official sheet partly quoted)

| Card | Copies | Exact effect | Confidence |
|---|---|---|---|
| Stack 1 (colored) | probably 4 | Play on a matching color; the next player draws 1 and loses their turn. "It can also be played in response to a Draw Card (+2, +4) **when its color matches the Draw 2 or the chosen color for a Wild Draw 4**; the total penalty goes to the next player." | MED-HIGH (JCV58 snippet plus retailers) |
| Stack 2 (colored) | probably 4 | Same as Stack 1, but 2 cards. | MED-HIGH |
| Wild Stack 3 | probably 4 | Play on anything and choose a color; the next player draws 3 and loses their turn. It can be played in response to a Draw or Stack card, adding +3. | MED-HIGH |
| Wild Stack Number | probably 4 | Like Wild Stack 3, but "Flip the top card of the Draw Pile to find out how many!" The next player draws that many. | MED. Gap: what happens if the flipped card is an action or wild card, and what happens to the flipped card afterwards. |

Edge cases and key rulings:
- **Stack Pack stacking is color-gated** for the colored Stack cards (they must match the Draw 2's color or the Wild Draw 4's chosen color). Wilds can stack on anything. This differs from No Mercy, where stacking is by value.
- The pack only lets **Stack cards** respond to Draw cards. Snippets don't say whether a base Draw 2 may then be stacked onto a Stack 1. Literal reading: the base-game no-stacking rule still applies to base cards, so only Stack-Pack cards respond (MED inference).

### 2d. Speed Pack (JCV57)

| Card | Copies | Effect | Confidence |
|---|---|---|---|
| Colored cards with one "Speed Up" icon | unknown (16 total minus wilds) | The card plays normally (its number/action identity is unknown from the snippets) and raises the speed level by 1. | MED |
| Wild Double Speed Up | unknown (probably 4) | Wild: choose a color, raise the speed level by 2. | MED-HIGH (two retailers) |

**Speed-level rule** (GeekyHobbies plus retailers; MED-HIGH overall):
1. The game starts at **speed level 1** (normal UNO: play 1 card).
2. Each Speed Up icon raises the level by 1; the Wild Double Speed Up raises it by 2. The first icon makes the level 2, the next makes it 3, and so on. The increase affects the **next player** onward. MED: whether icons played earlier in your own chain change your own required count. Most likely they don't; the level is fixed at the start of your turn.
3. At level N, on your turn you must play **N cards** as a chain. The first card must match the top of the Discard Pile, and each later card must match **the card you just played** (color or number/symbol).
4. **Action-card effects apply only if the action card is the last card of your chain.**
5. If you can't reach N: "play as many cards as you can," then "draw cards equal to the current speed" as a penalty, and **the speed level resets to 1**. Retailers phrase this as "discard what they can".
6. There is no separate reset card. Gap: no cap on the level was found.

### 2e. Billie Eilish Add-On Pack (JHG45; 16 cards; every card has color-blind symbols)

| Card | Copies | Exact effect | Confidence |
|---|---|---|---|
| Wild Pass Color | unknown | "First, choose a color. Next, every player passes all the cards in their hand of that color to the player on their left. If a player has no cards of that color they don't have to pass but must still accept the cards passed to them." (JHG45) | HIGH (official quote). Note it is always "to the left", not the direction of play. |
| Trick Wild | unknown | Choose a color. The next player may play a card of that color; if they can't, you immediately play another card (GeekyHobbies). The Mattel shop phrases it as "take another turn". | MED |
| Wild Color Challenge | unknown | Choose a color. All other players must show a card of that color; anyone who can't draws 2. **Mattel shop adds: if all of them *do* have it, the player who played it draws 3.** GeekyHobbies omits that backfire clause. | MED (the conflict is reported; the Mattel version is more authoritative) |
| Reveal Hands | unknown | All players lay their hands face up and play normally with them visible; "once it is your turn again" the cards go back into hands. | MED |

Gap: the per-type copy counts (probably 4 each).

---

## 3. Official house-rule definitions

| Rule | Definition as worded by Mattel / Ubisoft / sources | Confidence |
|---|---|---|
| **Stacking in base UNO (official ruling)** | Not allowed. The @realUNOgame tweet of **May 4, 2019** said "You cannot stack Draw 2 & Draw 4 cards": if a +4 is played the next player draws 4 and loses their turn, and you can't add a +2 to make it 6. A follow-up the next day said +2 on +2 isn't allowed either. **Sept 28, 2022:** a repeat tweet said you can't stack +2 on +2. UNO also said the mobile and online versions use custom rules, including common house rules. | HIGH (Today, Gigazine, WRDW, JPost). Often cited as 2022; it was originally **2019**, with a 2022 repeat. |
| **Wild Draw Four challenge (official)** | A WD4 is legal only if you hold **no card matching the current color** (matching number or symbol cards and other wilds don't count against you). The next player may challenge. The challenged player shows their hand **privately to the challenger**. If the play was illegal (guilty), the player who played the WD4 draws 4 and the challenger does **not** draw; play continues with the challenger. If it was legal (not guilty), the challenger draws **6** (4 + 2) and loses their turn. The color chosen with the WD4 stands either way. | HIGH (Wikipedia plus multiple rule sites agree on 4/6). "Play continues with challenger" is MED. |
| **Progressive UNO** (Mattel's older suggested variant) | "If a draw card is played then the 'victim' can play **the same type of card**, thus passing the result on to the next player" (Noble Knight summary of Mattel's sheet). Same type means +2 on +2 and WD4 on WD4; **no +4 on +2 or +2 on +4**. The total passes on until someone can't stack and draws it all. | MED (one source quoting Mattel). The "no mixing" reading follows from "same type". Several low-quality pages agree no +2 goes on a +4. |
| **Jump-In** | If a player holds **exactly the same card (both number and color)** as the top discard, they may play it immediately even if it isn't their turn. **Play continues from the player who jumped in**; the players in between are skipped. | HIGH (Wikipedia plus a 2006 Wikipedia mirror plus Ubisoft/MobyGames). |
| Jump-In on wilds/actions | 2006 Wikipedia variant text: you may jump in with a WD4 only on another WD4. Jump-in on a +2/WD4: either wait until the victim has drawn, or the jumped card **cancels** the penalty unless the victim already drew. An alternative variant lets the jump-in card add to the stack (the common Ubisoft/Mobile behaviour), but no official wording was found. Plain Wild on Wild: unresolved. | LOW-MED (variant sources only) |
| **Seven-O** | Playing a 7: the player **must** swap hands with a player of their choice. Playing a 0: **all** players pass their hands to the next player in the current direction. | HIGH |
| **Draw to Match** (Ubisoft) | "Drawing is continued until a card can be played instead of just one draw." | MED (MobyGames description of Ubisoft options) |
| **Force Play** (Ubisoft) | "A drawn card that can be played is played automatically." (Base Mattel rules give the option to play the drawn card if it's playable; Force Play removes the choice.) | MED |
| **No Bluffing** (Ubisoft) | Named as a toggle but not defined in any snippet. Most likely it disables the WD4 challenge or bluff, i.e. a WD4 may only be played legally or can't be challenged. **Gap.** | LOW |
| **2v2** (Ubisoft) | Partners sit opposite each other and can see each other's hand (mobile port review). Team-only quick chat. Win condition: the team wins when **one** partner empties their hand (Mattel mobile: "reduce your hand (or your partner's) to zero"). By contrast, UNO Wonder "Teams" (2026) requires **both** partners to empty their hands. The Ubisoft win condition is not confirmed. | MED/LOW |

### Edge cases & rulings
- The Mattel tweets state that the official ban covers the physical game, while the digital versions intentionally ship stacking as an option.
- WD4 challenge with stacking enabled: no official ruling. Logical: a challenge can only happen on a WD4 that ends up resolving on you. If you stack instead, you've waived the challenge (inference).
- Jump-In and draw penalties: see the cross-mechanic notes below.

---

## 4. UNO Attack

### 4a. Original UNO Attack (1998/1999; 112 cards plus electronic launcher)
Sources disagree on the year: BoardGameMatcher says 1999, Wikipedia says 1998.

| Card | Copies | Effect | Confidence |
|---|---|---|---|
| Number cards 1-9 (no 0s), 2 per color | 72 (18/color) | Face value. | HIGH (BGM count plus Mattel T8219 snippet "72 numbered cards (18 per color)") |
| Hit 2 | 8 (2/color) | Next player presses the launcher **twice**, then loses their turn. | HIGH |
| Reverse | 8 | Reverse direction. | MED |
| Skip | 8 | Next player loses their turn. | MED |
| Discard All | 4 | Discard all cards of one color (this card's color); "a Discard All can also go on another Discard All". | MED-HIGH |
| Trade Hands | 4 | Trade hands with any player of your choice. | MED (count from BGM; effect from name/standard) |
| Wild | 4 | Standard wild. | HIGH |
| Wild All Hit | 2 | Choose a color; "everyone except whoever played the card each press the Launcher button once." | HIGH (Wikipedia plus BGM) |
| Wild Hit-Fire | 2 | Choose a color; "the next player must hit the launcher button **until it fires**." | HIGH |

The total is 112 (HIGH). There is **no "Skip All" and no "Wild Hit 4"** in the original. "Wild Hit 4" is the 2010-era single card, and "Skip All" doesn't appear in any Attack edition found.

### 4b. 2010-era Attack (T8219, 112 cards) and 2020 revision (GXY78 / GXY81 / GNL02)
From the T8219 snippet (MED-HIGH, sums to 112): 72 numbered, 8 Hit 2, **4 Reverse**, 8 Skip, **8 Discard All**, 4 Wild, **4 Wild Attack-Attack**, **3 Customizable (blank)**, **1 Wild Hit 4**.

GameRules gives a different split: 1 Reverse per color, 2 Hit 2 and 2 Skip per color, 3 Wild Customizable, 1 Wild Hit 4. Treat the Mattel sheet as authoritative.

BoardGameMatcher: "in the 2010 edition, Trade Hands cards are replaced with another set of Discard All, and Wild All-Hit/Wild Hit-Fire are replaced with 4 Wild Attack-Attack."

| 2010/2020 card | Effect | Confidence |
|---|---|---|
| Wild Attack-Attack | Choose a color **and choose any player to attack**. Turn the launcher toward them; they press it **twice**. | MED (Vietnamese retailer guide; consistent with Mega Hit text) |
| Wild Hit 4 (1 copy) | Choose a color; the next player presses 4 times (inferred from name). | LOW |
| Customizable (3, blank) | Write your own rule. | MED |
| Discard All | As in the original. | MED |

The **2020 revised set (#54)** couldn't be separated cleanly from the 2010 set. The GXY78 manual (manualsnet) gives 112 cards but no breakdown. **Gap:** confirm whether GXY78 changed any counts versus T8219.

### 4c. Launcher rules (HIGH unless noted)
- "Hit" = press the launcher button once. **One press per hit**; the launcher fires a random number of cards, often zero. Press once per required hit, not until cards come out, **except Wild Hit-Fire**, which means press until it fires.
- If you can't play: press the launcher **once**, take whatever comes out, and your turn ends.
- **Pressing the launcher any number of times ends your turn immediately, even if a drawn card is playable** (Wikipedia). This conflicts with the base rule's "play the drawn card".
- Cards left sticking out of the launcher go into the presser's hand.
- If cards fire before you finish the required presses, **you may forfeit the remaining presses** (GXY78/GNL02 quote; MED-HIGH).
- Forgetting to call UNO: press the launcher **twice**.
- Rotate the launcher to face whoever's turn it is.

### 4d. "Mega Hit" stacking (GXY78 / GNL02; MED-HIGH, official quote)
- A Mega Hit stack can start when **the first card is an Attack-Attack** and the attacked player holds a **Hit** card. The attacked player plays it. "The next player in the current order from the attacked player must then either play a Hit card or perform **all the hits in the stack**."
- When it resolves: "game play continues with the next player in the current order from **THE PLAYER WHO LAID DOWN THE FIRST HIT CARD**."
- The forfeit-on-fire rule still applies to the accumulated presses.
- Gap: whether #339 "Mega Hit" in the survey doc is this rule or a separate product. The snippets show it as a rule within the 2020 Attack sheets.

---

## Cross-mechanic interaction notes

1. **There are four incompatible official stacking models.** The engine needs a "stack policy" enum rather than one boolean:
   - **Base UNO (official):** no stacking at all (2019 and 2022 tweets).
   - **Progressive UNO (Mattel variant):** same card type only (+2 on +2, WD4 on WD4); no mixing.
   - **No Mercy:** any Draw card of **equal or higher value**, color-agnostic. Reverse-draw stacks and sends the penalty back.
   - **Stack Pack:** colored Stack 1/2 cards must **match the color** of the Draw 2 or the WD4's chosen color; Wild Stack 3 and Wild Stack Number stack on anything.
   - **UNO Attack Mega Hit:** Hit cards stack only after an Attack-Attack, and play resumes after the *first* Hit player, not after the victim.

   If No Mercy and Stack Pack are both enabled, a Stack 1 (value 1) could never legally follow a +2 under the No Mercy "equal or higher" rule. The engine must choose a precedence; suggest the pack's own text overrides for its own cards.
2. **Wild NO U (Reverse Pack) vs No Mercy Wild Reverse Draw 4:**
   - Both send a pending penalty back.
   - NO U **bounces** the penalty without adding to it.
   - WRD4 **adds 4** and reverses.
   - With 2 players, No Mercy's literal rule makes the WRD4 player draw 4 themselves. That clashes with intuition and with NO U's 2-player behaviour, so flag it.
   - No source rules on NO U inside a No Mercy value-stack (value 0?), on NO U against Color Roulette, or on a NO U answered by another NO U. Recommend: NO U answers any pending draw total; a second NO U bounces it again.
3. **Jump-In vs active stacks:** there's no official ruling.
   - Old variant text says a jump-in on a +2/WD4 **cancels** the penalty unless the victim already drew. The other variant allows jumping in only after the draw.
   - Ubisoft-style play typically lets an identical +2 jump in and **add to the stack**, with the turn passing from the jumper.
   - These are three different behaviours; make it a sub-option. Jump-In under No Mercy/Stack Pack was never addressed officially.
4. **Jump-In with wilds:** identical "color+number" can't really apply to wilds. The variant text allows WD4 on WD4 only. For No Mercy's many wilds, decide whether "identical" means the same face (Wild Draw 6 on Wild Draw 6) or is banned.
5. **Seven-O vs No Mercy:** No Mercy builds Seven-O in natively (7 = swap with your choice, 0 = pass in the direction of play), identical to the house rule. Enabling both must not double-apply it.
   - Under the Mercy Rule, a swap or pass can push someone to 25+. Unresolved whether elimination is checked after a hand passes; suggest checking after every hand-size change.
   - Billie Eilish's Wild Pass Color always passes **to the left**, regardless of direction, unlike Seven-O's 0 and Wild Pass Hands (which follow the direction of play).
6. **Wild Force Trade vs Seven-O's 7:** Force Trade can swap two *other* players; the 7 always involves the player who played it. Hand-swap code should take two arbitrary seats.
7. **Draw to Match vs No Mercy:** No Mercy's base rule already *is* draw-until-playable. Draw to Match is redundant there.
   - Combining it with the Mercy Rule creates real elimination risk while drawing.
   - Force Play combined with draw-until-playable makes the drawn card auto-play (Ubisoft Force Play definition).
8. **Speed Pack vs everything:**
   - Under the "action effect only if it's the last card in the chain" rule, a +2 or Stack card mid-chain does nothing. That suppresses stacking and Seven-O mid-chain; 0 and 7 are number cards with effects, and probably only fire when played last (inference).
   - Failing the speed requirement means drawing N cards. N stacks with No Mercy's 25-card elimination, and there's no ruling on combining that draw with a pending stack.
9. **WD4 challenge vs stacking:** none of the stacking modes (No Mercy, Progressive, Stack Pack) defines a challenge.
   - The No Mercy snippets never mention challenging. Wild Draw 6/10 appear playable at any time, so their legality is unrestricted. Inferred, MED.
   - The base WD4 color restriction and challenge only apply to the classic Wild Draw 4. Recommend: the challenge is available only when the WD4 would resolve on you, i.e. you choose not to stack.
10. **UNO Attack launcher vs "draw then play":** pressing the launcher ends your turn even if you got a playable card, the opposite of base UNO's play-the-drawn-card option. An Attack mode should disable Force Play and Draw to Match.
11. **No Mercy Coin (doubles a played card's penalty) vs stacks:** unresolved whether it doubles only that card's value or the whole running stack total. It can't be implemented without the JJB29 sheet.

### Open gaps (highest priority first)
1. Per-card copy counts for No Mercy. The recalled set sums to 168, but only Discard All 12 and Roulette 8 are corroborated.
2. Where an eliminated No Mercy player's cards go.
3. No Mercy point values.
4. Who picks the Color Roulette color (the Mattel snippet says the next player).
5. The third 8-card type in the No Mercy Expansion, plus the coin split and the No Mercy Coin's interaction with stacks.
6. The Deadpool "Wild Reverse Draw 10": nothing found.
7. Per-type counts for all add-on packs, the identities of the Speed Pack's colored cards, and the Wild NO U target wording.
8. Ubisoft's definitions of No Bluffing and 2v2.
9. UNO Attack 2020 (GXY78) card counts versus T8219, and #339 Mega Hit as a product versus a rule.
