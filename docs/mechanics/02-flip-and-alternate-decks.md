# Final Review 2: Alternate Decks and Structural Variants (implementation-grade specs)

> Reference spec for `docs/gameversions.md` (see its Part F). Gathered from web-search snippets only; direct page fetches were blocked during research, so treat anything below HIGH as needing a check against the official instruction sheet before shipping.

Research method: WebSearch snippets only (WebFetch/curl blocked). 34 searches. Sources surfaced most often: Mattel instruction-sheet PDFs on service.mattel.com (GDR44 Flip, GXV56 Flip Marvel, HXJ49 Flip Transformers, HMY99 Flex, HXT58 Teams, HCC23/GXV87 Triple Play, R2827 Tippo, GKF04 Junior, "UNO Choo-Choo rules.pdf"), Wikipedia "Uno Flip!", gamerules.com, officialgamerules.org, GeekyHobbies, RulesPal, UltraBoardGames, TTPM reviews, BoardGameMatcher, nintendo.fandom (UNO 52).

Confidence tags: **HIGH** = 2+ independent sources agree; **MED** = one detailed, plausible source (often a Mattel sheet snippet); **LOW** = thin, inferred, or from memory without a confirming snippet. Where sources conflict, both versions are given.

Important note on snippets: the search tool returns summarized snippets of the pages, not the raw text. Quoted wording below is as close to the instruction sheet as the snippet allowed. Treat it as near-verbatim, not verbatim.

---

## 1. UNO Flip! (2019, GDR44 / GDG37, #13)

### 1.1 Deck composition: 112 double-sided cards. Light side has a white border, Dark side a black border.

Light colors are the classic Red, Yellow, Green and Blue. Dark colors are Pink, Teal, Orange and Purple. Each side has exactly 112 faces. Count check: 72 + 8×4 + 4 + 4 = 112.

**Light Side**

| Card | Copies | Exact effect | Conf. |
|---|---|---|---|
| Number 1-9 (no 0) | 72 (2 of each number per color, 18 per color) | Match by color or number. | HIGH |
| Draw One | 8 (2 per color) | Next player draws 1 card and loses their turn. | HIGH |
| Reverse | 8 (2 per color) | Reverses the direction of play. | HIGH |
| Skip | 8 (2 per color) | Next player loses their turn. | HIGH |
| Flip | 8 (2 per color) | Flips the whole game to the Dark side (see 1.2). Playable only on a matching color or on another Flip. | HIGH |
| Wild | 4 | Call any color. | HIGH |
| Wild Draw Two | 4 | Call a color. The next player draws 2 and loses their turn. Playable only if you hold no card of the current color. Can be challenged (see 1.3). | HIGH |

**Dark Side**

| Card | Copies | Exact effect | Conf. |
|---|---|---|---|
| Number 1-9 (no 0) | 72 (2 of each number per color) | Match by color or number. | HIGH |
| Draw Five | 8 (2 per color) | "Next player in sequence draws five cards and loses a turn." | HIGH |
| Reverse | 8 (2 per color) | Reverses the direction of play. | HIGH |
| Skip Everyone | 8 (2 per color) | Every other player is skipped, so the player who played it takes another turn (Wikipedia: "grants an extra turn"). | HIGH |
| Flip | 8 (2 per color) | Flips the game back to the Light side. Same matching restriction. | HIGH |
| Wild | 4 | Call any Dark color. | HIGH |
| Wild Draw Color | 4 | "Player names the next color to be matched; next player in sequence must draw cards until they get one of that color, after which they lose a turn. May only be used if the player has no cards of the current color." Challengeable. | HIGH |

**Which Light face pairs with which Dark face: NOT DOCUMENTED.** No source in the results gives a pairing table (searched for it specifically). Each physical card has one fixed back, and the sheet's only setup instruction is to keep "all the Light Side cards facing one way, all the Dark Side cards facing the other way." Implementation options:
- (a) Generate a fixed 112-entry pairing table once (seeded) and ship it as data. This is the most "physical" option.
- (b) Pair randomly at each shuffle. Simpler, but a player can't learn the backs.

Either is defensible. Whatever you choose, the pairing must be stable for the life of a round, because hands are flipped, not re-dealt. **LOW (gap).**

### 1.2 Flip procedure (exact order)

Mattel sheet, near-verbatim: "Once the Flip card has been played, flip over the Discard Pile (the card just played will now be on the bottom), then the Draw Pile, then everyone's hands must flip to the other side." Play stays on the new side "until someone else plays another FLIP card." **HIGH**

What this means for the game state:
- The **whole discard pile is inverted as a stack**, not card by card. The new top card is the opposite face of whatever card was at the **bottom** of the old discard pile (the starting card, or the oldest surviving card after a reshuffle). The played Flip card ends up at the bottom. **HIGH** (follows directly from the procedure)
- The draw pile is also inverted. The new top of the draw pile is the other face of the old bottom card.
- All hands flip. Every player now holds the reverse faces of the same physical cards.
- **What happens to the newly exposed top card:**
  - If it is an action card, its action is **not** applied ("you don't have to take the action").
  - If it is a Wild, **the player who played the Flip calls the color.**
  - This wording comes from the Flip Transformers sheet (HXJ49), which uses the same template. It is very probably the base Flip ruling too, but no base-Flip snippet confirmed it. **MED**
- The next player must match the new top card on the new side.

### 1.3 Wild Draw Two / Wild Draw Color challenge

- **Who may challenge:** the next player, if they believe the card was played while its player held a card of the previous color. **HIGH**
- **How:** the challenged player shows their hand to the challenger. **HIGH**
- **Wild Draw Color:**
  - If guilty, the challenged player draws until they get the chosen color, instead of the challenger. **HIGH** (Mattel + gamerules.com)
  - If innocent, the challenger draws "until they get the chosen color PLUS an additional 2 cards." **HIGH**
- **Wild Draw Two (Light side):** this follows the standard UNO Wild Draw Four pattern scaled down: if guilty, the offender draws 2; if innocent, the challenger draws 2 + 2 = 4. **MED** (the snippets name both cards as challengeable but do not quote the Wild Draw Two penalty numbers)
- **Does the challenger still lose their turn?** Not stated in any snippet.
  - Recommended reading by analogy with classic UNO: if the challenge fails, the challenger takes the penalty and loses their turn.
  - If the challenge succeeds, the challenger draws nothing and plays normally. **LOW**
- **Wild Draw Color edge cases:**
  - The drawn card of the named color is **kept in hand**. The victim then loses their turn, so they do not get to play it. **HIGH** (Wikipedia: "after which they lose a turn")
  - **The draw pile runs out before the color appears:** not addressed. Recommended handling: reshuffle the discard pile (except its top card, keeping the current side face-up) and continue. If the color does not exist anywhere in the draw pile, stop drawing. **LOW (engine must decide)**

### 1.4 Starting card

Sources conflict, so make this an engine option:
- (A) gamerules.com: if the turned-up card is a Flip, "all cards are flipped, and the game begins on the dark side." **MED**
- (B) One snippet attributed to the Mattel sheet: if the first card is an action card, ignore it and turn over the next card. **LOW-MED** (the attribution is uncertain)
- (C) officialgamerules.org and the generic Mattel setup text: if the first card is an action card, its action happens immediately. **MED**

Wild Draw Two or Wild Draw Color as the starting card is not addressed specifically. Classic UNO would return it to the deck and reshuffle.

### 1.5 Scoring (side face-up at the end of the round)

"Points are counted using whichever side is face up when the round ends." If the player goes out with a card that makes the next player draw, that player draws first and then scores are tallied. Game is played to 500 points. **HIGH**

| Light card | Points | Dark card | Points | Conf. |
|---|---|---|---|---|
| Numbers | face value | Numbers | face value | HIGH |
| Draw One | 10 | Draw Five | 20 | Draw One MED, Draw Five HIGH |
| Reverse / Skip / Flip | 20 each | Reverse / Flip | 20 each | HIGH |
| — | — | Skip Everyone | 30 | HIGH |
| Wild | 40 | Wild | 40 | MED |
| Wild Draw Two | 50 | Wild Draw Color | 60 | HIGH |

Conflicting minority values exist and are probably wrong: a Q&A site gives Draw Five as 40, and one guide gives Wild Draw Color as 50. Mattel and Wikipedia agree on Draw Five 20 and Wild Draw Color 60.

### 1.6 Edge cases & rulings
- A Flip card can be played only on a matching color or another Flip. Flip is **not** wild. **HIGH**
- Dark Reverse with 2 players: by classic-UNO convention it acts as a Skip. Dark Skip Everyone with 2 players is the same as a Skip: the player plays again. **LOW** (convention)
- Number range is **1-9 on both sides, no zeros**. This matters for a 7-0 toggle: there are no 0s to trigger it. **HIGH**
- UNO-call and penalty are the classic rules (2 cards). **MED**
- Light Wild and Dark Wild are separate physical faces. A Light Wild can flip to anything on its back.

---

## 2. Flip derivatives

| Product | Extra / different cards | Exact effect | Conf. |
|---|---|---|---|
| **Flip Stranger Things (#143, HJP41)** | Real World side: **Wild Jim Hopper**. Upside Down side: **Wild Eleven's Waffle**. Other faces mirror base Flip: Draw One / Reverse / Skip / Wild Draw 2 / Flip on one side, Draw 5 / Reverse / Skip Everyone / Flip / Wild Draw Color on the other. | **Jim Hopper:** the player with the most cards must discard half their hand. **Eleven's Waffle:** the player with the fewest cards must draw until they get a card with a waffle icon. | MED (single TTPM review). Copy counts unknown (probably 4 each, likely replacing plain Wilds). Tie-breaks and rounding of "half" are unknown. Which faces carry the waffle icon is unknown. |
| **Flip Marvel (#198, GXV56)** | Super Heroes side (light): **4 Wild Super Hero**. Villains side (dark): **4 Wild Villain + 4 Wild Draw Color**. | "There are also special wild cards with a 'Super Hero' rule and a 'Villain' rule." The effect text was not retrievable. | Counts MED (Mattel sheet snippet). Effects are a **GAP**. |
| **Flip Transformers (#258, HXJ49)** | Autobots side (light) and Decepticons side (dark), with harsher dark penalties (Draw 5 / Skip Everyone). Special rules: **"Might of Optimus Prime"** (players get rid of cards) and **"Tyranny of Megatron"** (players add cards to their hands). | Exact triggers and amounts were not retrieved. The sheet also gives the post-flip ruling: the exposed action is not taken, and an exposed Wild has its color called by the Flip player. | MED for names, **GAP** for effects |
| **Flip Express (#285)** | Nothing distinct found. The only "Express" listing (rokomari) says 112 cards and reuses GDR44 codes. | Treat it as a travel packaging of base Flip. | LOW |
| **Flip Attack (#309, HXT54)** | 112 double-sided cards plus a card launcher. The sides are renamed **"Mild Side"** (classic-like) and **"Wild Side"** (harsher). | Every draw (voluntary or forced) is replaced by pressing the launcher and taking whatever shoots out (0 to several cards). "More cards shoot out on the Wild Side than on the Mild Side." A Flip card flips hands and discard as in base Flip. You may choose to press instead of playing even when you have a legal card (GeekyHobbies). If the launcher runs out, shuffle the discard pile in. | MED for concept and launcher. Exact card list and whether Draw cards keep their number are **GAP**. "Hit 2" / "Discard All" from Attack could not be confirmed for this product. |

### Edge cases & rulings (derivatives)
- **Flip Attack digital model:** model each "draw" as one press. Each press yields a random count from a distribution keyed to the current side: something like Mild {0: 60%, 1: 25%, 2-3: 15%} and Wild with a heavier tail up to around 5–6. These numbers are a suggestion; the official source only says 0 to "a handful" and gives no frequencies. **LOW** (no official distribution exists; the physical launcher is random)
- **Flip Attack open question:** whether a Draw card means "press N times" or "press once" in Flip Attack is unconfirmed. Classic UNO Attack uses "press once" for Hit cards, and Draw Two does not exist there. **GAP**
- **Physical consistency in Flip Attack:** the launcher holds the draw pile, so it must also flip orientation. Digitally, just flip the draw pile as in base Flip.
- **Jim Hopper / Waffle "player with most/fewest cards" can be the caster.** No ruling exists. Recommended: include the caster, and break ties by turn order starting after the caster. **LOW**

---

## 3. UNO All Wild (2022, HHL33/HHL36, #28; Pocket All Wild #284)

### 3.1 Deck (112 cards, all Wild, no colors and no numbers)

| Card | Copies | Exact effect | Conf. |
|---|---|---|---|
| Wild | 54 | No effect. Plays on anything. | Count MED* |
| Wild Reverse | 14 | Reverses the direction of play. | Count MED*, effect HIGH |
| Wild Skip | 14 | Next player loses their turn. | Count MED*, effect HIGH |
| Wild Skip Two (also "Double Skip") | 6 | "Next two players in turn order lose their turn." | Count MED*, effect HIGH |
| Wild Draw Two | 10 | Next player draws 2 and loses their turn. | Count MED*, effect MED |
| Wild Targeted Draw Two | 4 | "Choose any player at the table. That player draws two cards. Unlike Wild Draw Two, they do not lose their next turn." | Count MED*, effect HIGH |
| Wild Draw Four | 6 | Next player draws 4 and loses their turn. No restriction and no challenge, since there is no color to hold. | Count MED*, effect MED, no-challenge is a logical inference |
| Wild Forced Swap (also "Swap Hands") | 4 | "You must choose another player and exchange your entire hand with theirs. The swap is mandatory." Whoever ends with 1 card must say UNO. | Count MED*, effect HIGH |

\* The counts come from a single fan database (BoardGameMatcher). They sum exactly to 112, which is plausible, but no Mattel breakdown was found. The figures "26 Wild / 12 each" that circulate were **not** supported by any result.

### 3.2 Rules
- There is **no color and no number matching at all**. Any card may be played on any card, so the legality check is "always legal." Players still draw if they choose not to play or cannot play; in practice every hand is always playable. **HIGH** (Mattel launch copy: "no matching of numbers or colors")
- **Starting card:** if it is an action card, the action happens. If it is a Wild Targeted Draw Two, the dealer chooses who draws, and that player does not lose their first turn. A Forced Swap as the starting card is **not addressed**. Suggested handling: bury it and turn over the next card, or have the dealer swap. **MED** for the stated cases, **GAP** for the swap
- **Scoring:** Wild = 20 points. All seven action types = 50 points each. Game to 500. The rules do not say what happens if the last card played forces a draw (GeekyHobbies explicitly notes this gap). **MED**
- **Pocket All Wild (#284, Burger King):** smaller pocket deck, composition unknown. **GAP**

### Edge cases & rulings
- Wild Skip Two with 2 players: both "next two" are the opponent then yourself. Effectively the caster plays again. **LOW** (convention)
- Wild Skip Two with 3 players skips both opponents, so the caster goes again.
- Wild Reverse with 2 players acts as a Skip. **LOW** (classic convention)
- Forced Swap with your own empty-after-play hand: you play your last card as the swap, so your hand is 0 and you would receive theirs. Classic UNO's Swap Hands ruling says playing it as the last card still wins, because going out ends the round before the effect resolves. Not stated for All Wild. **LOW**

---

## 4. UNO Flex! (#25, HMY99, 2023/2024)

### 4.1 Components
- 112 cards **including 8 Power Cards**, so 104 playing cards. This also implies a maximum of 8 players. **HIGH** (Mattel sheet + RulesPal)
- Each player gets 1 Power Card, starting **green side up**. Deal 7 cards. **HIGH**

| Card | Copies | Regular side | Flex side (requires green Power Card) | Conf. |
|---|---|---|---|---|
| Flex number cards | ? | Number in its primary color | Played as its second (flex) color. E.g. "a Red 4 can become a Green 4." | Effect HIGH, count GAP |
| Flex Draw Two | ? | Next player draws 2 (classic) | "Every player must draw 1 card" (all other players draw 1) | HIGH |
| Flex Skip | ? | Skip next player | "Skip All": every other player skipped | HIGH |
| Flex Reverse | ? | Reverse | Reverse **and** skip the next player (Gigazine) | LOW-MED |
| Flex Wild Draw Four | ? | Classic Wild Draw Four | You choose the target player, who draws 4 | MED (two secondary sources) |
| Flex Wild Targeted Draw 2 | ? | (unclear) | "Acts as a 'targeted' Draw 2 Card where you choose the player to draw 2 cards" | MED (Mattel 2024 sheet snippet). Conflict: it is unclear whether this is a separate card or the flex side of another Wild. |
| Flex Wild All Draw | ? | "Acts like a classic Wild Card" | "Forces every other player to draw 2 cards. The next player does not lose their turn." | HIGH (Mattel 2024 + TTPM) |
| Wild All Flip | ? | Wild: "you call the color that continues play" | — (it is not a Flex card) | HIGH |
| Power Card | 8 | Green = may flex. Red = may not. | — | HIGH |

**Wild All Flip:** "All players must flip their Power Card." This is a toggle: green becomes red and red becomes green, for every player including the caster. **HIGH**

There are also presumably classic Skip / Reverse / Draw Two / Wild cards without flex. **GAP:** per-card counts were not found.

### 4.2 Rules
- On your turn, if your Power Card is green, you may play a Flex card using its flex side. Afterwards your Power Card flips to red. While it is red, you may not use flex sides. **HIGH**
- **The flex color lasts only for your play.** It "doesn't mean the card turns red for the next player": the **primary color stays the one to match** for the next player. This conflicts with intuition; one review states it, and the others are silent. **MED**
- **Power Card recovery:**
  - Gigazine: "return to an unused state when everyone has finished using them, or due to the 'power card flip' effect." If everyone's card is red, all reset to green.
  - Other sources mention only Wild All Flip.
  - **MED** for the all-red reset (single source)
- **Scoring:** optional. The winner of a round scores the cards left in opponents' hands, with classic values presumed. **MED**

### Edge cases & rulings
- Does the flex Draw Two ("all others draw 1") still make the next player lose their turn? Not stated. By analogy with "All Draw" ("next player does not lose their turn"), the answer is probably **no**. **LOW**
- Wild All Flip played by someone who is green flips themselves to red as well. **MED** ("All players")

---

## 5. UNO Teams! (#405, HXT58, 2024)

### 5.1 Deck

112 cards. Classic-style colors and numbers plus **Wild Team Play** and **Wild Team Draw Four**. Exact per-card counts were **not found**. A reasonable assumption is the classic 108-card deck with 4 plain Wilds replaced, plus 4 team cards, but that is **LOW**.

| Card | Copies | Exact effect | Conf. |
|---|---|---|---|
| Classic numbers / Skip / Reverse / Draw Two / Wild | ? | Classic | MED |
| Wild Team Play | ? | Choose a color. Play skips directly to your partner. Per the sheet snippet: "if the partner can't play, the player who used the card draws 2 as a penalty." | MED (single sheet snippet; the penalty reading is odd but reported as found) |
| Wild Team Draw Four | ? | The next player draws 2 and loses their turn, **and that player's partner also draws 2, even if out of the game**. The player who played it chooses the color. With strict alternation, this costs the opposing team 4 cards in total. | MED (sheet snippet) |

### 5.2 Rules
- **Teams:** players pair up and keep the same partner all game. Partners sit so that turns alternate between teams. That alternation is implied by Wild Team Play skipping "directly" to the partner and Team Draw Four hitting "the next player's partner." **HIGH** for fixed pairs, **LOW** for seating
- **Opening pass:** at the start, each player chooses one card and passes it face-down to their partner. **HIGH**
- **Communication:** teammates may talk but may not reveal or hint at the cards in their hands. After a Wild, a teammate may not influence the color choice. **HIGH**
- **Going out (Mattel):** "if you get rid of all the cards in your hand, your partner then passes you half the cards in their hand and you keep playing."
  - If the partner has an odd count, they keep the larger half.
  - If the partner has only 1 card, they pass nothing and you stay out.
  - **MED** (Mattel sheet snippet)
  - **Conflicting secondary versions:** officialgamerules.org says you stay in play until both teammates are completely out. A GeekyHobbies line says "you'll take half the cards from their hand **if they're not doing as well as you are**," which would make taking cards optional. Report both; recommended default is the Mattel version.
- **Win and score:** the team wins the round when **both** partners are out. Scoring (officialgamerules.org): numbers face value; Draw Two, Skip, Reverse 20 each; Wild and Wild Team cards 50 each. First team to 500. **MED**
- UNO-call applies to each individual player. **HIGH**

### Edge cases & rulings
- An "out" player can be forced back in by Wild Team Draw Four ("even if out of the game"). An out player is therefore not eliminated, and their seat must stay in the turn order or in a dormant list. **MED**
- What happens to an out player's turn: since they hold 0 cards, they are presumably skipped. Not stated explicitly. **LOW**
- Player count: one retailer lists "2 to 4 players," which contradicts team play. Likely 4 (2v2), or larger even counts with more teams. **GAP**

---

## 6. UNO Triple Play (#16; Stealth #112; HCC21/HCC23/GXV87)

### 6.1 Game logic (device abstracted)
- **Three discard piles.** Setup: deal 7 cards each, then place 1 face-up card on each pile. One source requires all three starting cards to be numbers (replace action cards); the Mattel summary says only "one card face up in each space." **MED** (conflict)
- **Lit piles:** each turn the device lights a random subset (1–3) of the piles. You may discard **only** to a lit pile, and you must match the top card of that pile by color, number or symbol. **HIGH**
- **Overload:** each pile has a hidden capacity. Warning lights progress green → yellow → red as it fills. When a discard overloads a pile, play pauses and the player who overloaded it draws the number shown on the center display (a device-random number). The pile is then cleared. **HIGH** for the mechanic. The draw count is not fixed in any source: it is whatever the display shows.
- **Timer mode:** a per-turn timer. If it expires on your turn, you draw 6. **MED** (Mattel sheet snippet)
- **Stealth mode** (ON/OFF/STEALTH switch, HCC23): hides the overload warning lights. **MED**

| Special card | Effect | Conf. |
|---|---|---|
| Wild Clear | Wild; resets (clears) a pile's tray | MED |
| Wild Give Away | If it overloads the tray, the penalty cards go to opponents, and the player chooses the recipients and how many cards each gets | MED |
| Discard Two | After playing it, the player may follow with another card of the same color | MED |
| Classic Skip / Reverse / Draw Two / Wild / Wild Draw Four | Classic | MED |

### Digital model

Per pile:
- `count`
- `capacity` (hidden; random, e.g. uniform 4–12)
- `warn = count / capacity`

Per turn:
- `lit = random non-empty subset`, or weighted toward 2–3 lit piles.
- Overload draw: a random value, e.g. 2–6.

The ranges are suggestions; there is no official distribution. **LOW**

### Edge cases & rulings
- Does the turn pass after you overload? Presumed yes. **LOW**
- If no lit pile is playable, draw as in classic UNO. **MED**

---

## 7. UNO Tippo (#24, R2827)

### 7.1 Deck: 112 cards
- Per color: **19 cards**, numbered 0–9. Five of them are **Stop Cards numbered #1–5** in each color (exact layout per number unclear).
- Plus Draw Two, Reverse, Skip, Wild, Wild Draw Four, and **Tilt** cards.
- **MED** (UltraBoardGames). Exact action counts are **GAP**.

### 7.2 Rules as logic (two discard "trays")
- There are two discard trays on a balance scale. You may discard into either open tray, matching that tray's top card. **MED**
- **Stop cards:**
  - A Stop card can be played on another Stop card if the color **or** number matches. The latest one is the visible top.
  - A non-Stop number card **cannot** be played on a Stop card.
  - When Stop cards are visible on both trays, both trays are open. When one Stop card gets covered, the remaining visible Stop card marks its tray as **stopped**, and play continues in the other tray.
  - The snippet wording is confusing. Implement it as "a tray topped by a Stop card accepts only Stop cards matching color or number." **LOW-MED**
- **Tilt card:**
  - When a Tilt is played, "starting with the next player and going in order of play, all players (including you) take turns drawing one card from the DRAW pile and placing it in the same tray as the Tilt card."
  - Continue "until the scale tips and spills the cards. The player who discarded the last card draws 2 cards as a penalty."
  - Then "reset the scale with the top 2 cards in each tray. The player after whoever tipped the scales is next, and play resumes in the current direction."
  - **MED-HIGH** (Mattel sheet snippet)
  - **Correction to the survey doc:** the tipper does **not** take the spilled cards. They draw 2. The spilled cards presumably return to the draw pile, which is not stated. **LOW**
- **Natural tips:** the scale can also tip during ordinary play when one tray outweighs the other. The penalty in that case is presumably the same (whoever caused it draws 2, then reset). **LOW** (only the Tilt-triggered case was quoted)
- UNO-call: say it when you play your next-to-last card; if caught before the next player begins, draw 2. Score as classic, game to 500. Dealer is whoever draws the highest number. **HIGH**

### Digital model
- `imbalance = |countA − countB|` (or a weighted sum).
- Tip when `imbalance ≥ T`, where `T` is random, e.g. 6–10, or a hidden per-round value.
- Tilt card = forced loop: each player adds 1 card to the Tilt tray until the threshold is crossed.

**LOW** (no official numbers)

---

## 8. UNO 52 (#158; GBA 2006 / DS 2007 video game, not a physical card product)

| Element | Spec | Conf. |
|---|---|---|
| Turn structure | (1) Play a card to the discard pile as in normal UNO. (2) Then optionally play one card from your hand into your **poker hand**. Skipping step 2 is allowed, and forced if no hand card can be added. | MED (nintendo.fandom) |
| Poker hands | The fan wiki says players hold "five face-up poker hands that can be swapped." This is ambiguous: it may mean a 5-card face-up hand per player. They "influence your score at the end of the round." | LOW |
| Chips | Each player starts with 25 chips. At the start of every round, each player antes 1 chip into the pot. | MED |
| Game types | **Chips:** reach 50–500 chips. **Uno Wins:** go out first, over 1–10 rounds. **Poker Wins:** win 1–10 rounds with a poker hand. **Pot Wins:** win the pot. | MED (fandom + MobyGames) |

### Gaps
- Poker hand-ranking table.
- How the pot is split between "went out first" and "best poker hand."
- Whether poker-hand cards can be stolen or swapped by action cards.
- How UNO colors and numbers map to poker suits and ranks. The likely mapping is 4 colors = 4 suits and numbers = ranks.

Design this mode from scratch. It is a separate product: Mattel's "UNO Wild Twists" (a 52-card playing-card deck with Red/Black Wilds and poker rules) is **not** UNO 52.

---

## 9. Reduced and kids decks

### 9.1 UNO Pocket, Pizza Pizza / Pizza 73 (#51-52)

| Card | Copies | Effect | Conf. |
|---|---|---|---|
| Numbers 1–9 | 36 (1 of each number per color) | Classic | MED |
| Draw One | 4 (1 per color) | Next player draws 1 (presumably loses turn) | MED |
| Skip | 4 (1 per color) | Classic | MED |
| Reverse | 4 (1 per color) | Classic | MED |
| Wild | 3 | Classic | MED |
| Exclusive promo Wild | 1? | Brand-specific; differs per promo | LOW |

The 36 + 12 + 3 = 51 cards listed by gamerules.com suggest a 52nd card, most likely the exclusive Wild. **Deal 5 cards each, play to 250 points.** **MED**

There is no 0, no Draw Two, and no Wild Draw Four.

**Caution:** RulesPal's "UNO Pocket" page describes a full 108-card deck. "Pocket" is a brand label, not a single composition.

Wendy's and Burger King pocket compositions were **not found** (GAP).

### 9.2 UNO Junior (GKF04, 45 cards) / Mein Erstes UNO (#350)
- 2–4 players, ages 3+. Match by **color, number or animal**. **HIGH**
- **Level 1:** simple matching only. Number cards only. **HIGH**
- **Level 2:** adds action cards. In GKF04 these are Skip, Reverse and Wild; the Paw Patrol edition says "Reverse and Skip." Junior Move says "Wild cards and certain action cards." **MED** (sources differ on whether Wild joins at level 2)
- **Level 3:** adds penalty cards **Draw One and Draw Two**, giving the full deck. **HIGH**
- Per-card counts within the 45 are a **GAP**. Mein Erstes UNO is presumably the German Junior. **LOW**

### 9.3 UNO Junior Move! (#362, HPY62)
- Same three tiers as Junior:
  - Beginner: color/number.
  - Intermediate: plus Wild and some action cards.
  - Advanced: plus Draw 1 and Draw 2.
  - **HIGH**
- Cards with a **Star icon**: when played, the player "MUST perform the action on their Move! card" (jump, dance, clap, bend). This is unenforceable digitally; show it as a prompt only. **MED**

### 9.4 UNO Choo Choo (#391)
- **Discard "Track"** instead of a pile: each played card attaches to the end of the track. This has no logic effect; it is just a discard pile. **MED**
- **Matching:** color (boxcar color) **or** animal. Example: on a blue zebra, play any zebra or any blue card. **MED**
- **Conductor (wild):** matches anything and can be played any time on your turn. Call the color. If a Conductor starts the game, the first player chooses the color. **MED**
- **Raccoon (draw 1):** the next player draws 1 and loses their turn. Playable only on another Raccoon, on a matching color, or on a Conductor when the matching color is in play. **MED**
- **No match:** draw 1 card. Whether the drawn card may then be played is not stated. **MED / GAP**
- **Going out:** at 1 card, cheer "UNO Choo-Choo!" **MED**
- Card counts are a **GAP**.

### 9.5 UNO H2O Splash (#47)
- **Correction to the survey doc's "best of 3":** the rules say "**the first player to win three hands wins the game**," and Splash's "winner conditions are no longer points based." That is first-to-3 (up to 5 hands with 2 players), not best-of-3. **HIGH** (RulesPal H2O + BoardGameMatcher Splash)
  - Conflict: a retailer listing for "UNO H2O To Go" says 500 points.
- **Wild Downpour One / Two (base H2O):** "all other players must either draw one or two cards depending on which Wild Downpour card is played. The player of the card may also call a new colour and play continues in the current direction." **HIGH**
- **Whirlpool (Splash):**
  - Triggered by playing a special Splash card **or a 0 or a 2**. The next player shakes the Whirlpool.
  - **Outcomes:**
    - **Draw H2O:** draw until you get a blue card, a 2, a 0 or a wild.
    - **Wave Right / Wave Left:** show a card to that neighbor.
    - **Wipeout:** reverse the order of play.
  - **MED** (single source)
- The restriction on playing Wild Draw Four when you hold a playable card was **dropped** in Splash. **MED**

---

## Cross-mechanic interaction notes

### Flip (and its derivatives) with standard toggles
1. **Flip + 7-0 (rotate/swap hands):**
   - Neither side has a 0, so the "0 rotates all hands" half of 7-0 never fires on a Flip deck. Decide whether 7-0 is disabled or remapped (e.g. 7 swap, 1 rotate) when Flip is on.
   - A swapped hand keeps its current side face-up, so no conflict.
   - A flip during a pending 7-swap choice is impossible, since the swap is resolved immediately.
2. **Flip + Stacking:**
   - Light: can Draw One stack on Draw One? Can Wild Draw Two stack on Draw One? (+1 / +2 ladders.)
   - Dark: Draw Five on Draw Five gives a +10 chain. Wild Draw Color cannot be summed numerically. Options: (a) unstackable; (b) stacking another Wild Draw Color re-names the color and passes the "draw until color" obligation on; (c) a mixed chain "+5 + until-color" resolved as draw N then continue until color.
   - **What happens to a pending stack when a Flip is played?** A Flip is not a draw card, so it cannot be played onto a pending stack under a strict stacking rule. If Jump-In or another rule allows it, the stack's numbers should probably convert to the new side (e.g. +2 Light becomes ?). Recommendation: **forbid Flip while a draw penalty is pending.**
3. **Flip + Jump-In (play an identical card out of turn):**
   - "Identical" must include the side: identical face on the current side.
   - A Jump-In Flip flips everyone's hand mid-turn-order. Turn passes from the jumper, as is standard.
   - The post-flip exposed-top-card rule (no action; the Flip player calls a Wild's color) must name the **jumper** as "the Flip player."
4. **Flip + Draw-to-match / forced-play toggles:**
   - Wild Draw Color is already a draw-until mechanic. Don't apply "draw until playable" on top of it, or the victim would draw until the color and then be allowed to play it, contradicting "loses a turn."
5. **Flip + Wild Draw Four challenge toggles:**
   - Light Wild Draw Two and Dark Wild Draw Color need their **own** challenge resolution: Wild Draw Two uses 2 / 2+2; Wild Draw Color uses "until color" / "until color + 2."
   - The engine's generic challenge code must be parameterized by penalty, not hard-coded to 4/6.
6. **Flip + the Skip-Everyone family:**
   - Dark Skip Everyone combined with a "Reverse acts as Skip in 2-player" toggle is redundant but consistent.
   - Combined with a Jump-In window, Skip Everyone gives the caster an immediate extra turn. Others may Jump-In before it.
7. **Flip + scoring toggles:**
   - Card value depends on the **face-up side at round end**, so the score function must read the current side, not the card's "native" side.
8. **Flip + Teams:**
   - Partner card-passing happens face-up on the current side. Passed cards remain double-sided objects.
   - Team Draw Four's "partner draws even if out" has no Flip analogue. A Dark "Team Draw Color" would be undefined.
9. **Flip Attack + Flip:**
   - The launcher RNG must be keyed to the side.
   - Wild Draw Color under Attack ("press until you get the color") is undefined. Probably the victim presses repeatedly until a card of the color appears among the launched cards. **GAP**

### All Wild
10. **All Wild + Stacking:**
    - Every card is legal on every card, so "stack a draw card on a draw card" means any of Wild Draw Two (10 copies), Wild Draw Four (6) or Targeted Draw Two (4) can extend a chain.
    - Questions the engine must answer:
      - Can a Targeted Draw Two re-target a pending stack to any player? This would be a strong "deflect" move.
      - Can Skip, Skip Two or Reverse "dodge" a stack? Most stacking house rules say no.
    - Because matching never constrains, unrestricted stacking is very swingy. Recommendation: allow only Draw-on-Draw, and resolve Targeted Draw Two as a stack terminator that sends the total to the chosen player.
11. **All Wild + 7-0:** there are no numbers, so 7-0 is inert. Forced Swap is already the native analogue.
12. **All Wild + Jump-In:**
    - With only 8 card names and up to 54 identical plain Wilds, Jump-In becomes near-constant.
    - Either disable it or restrict it to identical **action** names.
13. **All Wild + Wild Draw Four challenge:** must be disabled. No color means there is nothing to have held.
14. **All Wild + any color-dependent toggle** (e.g. "Draw until color," "color-call bonuses," Flex flex-color): inert or undefined. The engine should grey them out.

### Flex
15. **Flex + Stacking:**
    - The flex Draw Two makes all other players draw 1. Is that stackable? It hits everyone, not the next player, so it cannot be "passed along."
    - Recommendation: flex-side draw effects are **non-stackable terminators**. Regular-side Draw Two and Wild Draw Four stack normally.
16. **Flex + Jump-In:** "identical card" must compare the **regular** side. Using the flex side out of turn would also consume the Power Card. Recommendation: no flexing on a Jump-In.
17. **Flex + Flip (if someone combines decks):** Flex number cards carry two colors. A Flip deck already doubles faces. Do not support combining them.
18. **Flex color persistence vs. standard engine:** the flex color applies only to legality of *your* play. The next player matches the card's **primary** color. If the engine stores "current color" as the color of the last play, Flex breaks that assumption. Store `matchColor = primaryColor`.

### Teams
19. **Teams + 7-0:** a 7 swap with your own partner is legal but useless or exploitative. A 0 rotation moves cards across teams. Consider restricting 7-swaps to opponents.
20. **Teams + Stacking:** Wild Team Draw Four hits two players (next player and their partner, 2 each). Can either stack onto it? Recommendation: the next player may stack and pass the whole +4 total on; the partner's 2 is then cancelled. Otherwise forbid stacking it.
21. **Teams + "out" players + Jump-In:** an out player (0 cards) can be re-entered by Team Draw Four. They must not be removed from the seating array.
22. **Teams + Forced Swap (All Wild) or 7-swap:** swapping with an out player (0 cards) would put a player out instantly. Forbid targeting players with 0 cards.

### Triple Play / Tippo (multi-pile)
23. **Multi-pile + Flip:** which pile flips? Physically all of them. "Bottom card becomes top" then applies per pile. Don't combine them.
24. **Multi-pile + Stacking:** the stack must be tied to a specific pile, or "pending draw" must be global. Recommended: global pending draw, playable on any lit/open pile.
25. **Multi-pile + Jump-In:** "identical to the top card" becomes ambiguous with 2–3 tops. Allow Jump-In on any pile whose top is identical.
26. **Triple Play overload + Draw Five / Skip Everyone etc.:** fine. Overload is just an extra penalty draw triggered by pile size.
27. **Tippo Tilt + All Wild:** fine. Tippo's Stop-card legality depends on color/number, so Tippo + All Wild is incoherent.

### Kids and reduced decks
28. **Pocket (no 0, no Draw Two, no Wild Draw Four):** inert with 7-0's zero-rotation, inert with Wild Draw Four challenge, and stacking reduces to Draw-One chains. Pocket's 5-card deal and 250-point target should be part of the preset, not separate toggles.
29. **Junior / Choo Choo animal matching:** introduce a third match attribute (`animal`). The legality check becomes `color == c || number == n || animal == a`. Any toggle that assumes numbers (7-0, Jump-In) needs an animal-aware equivalent or must be disabled.
30. **H2O Splash Whirlpool on 0 and 2:** collides with 7-0, since 0 would both rotate hands and trigger a Whirlpool. Define the order: resolve 7-0 first, then the Whirlpool, or disallow combining them.
    - "Draw H2O" (until blue / 2 / 0 / wild) is a draw-until-condition like Wild Draw Color, so the same reshuffle and exhaustion handling applies.

### Generic engine requirements surfaced by this cluster
- A **draw-until-predicate** primitive, used by Wild Draw Color, Waffle and Draw H2O. It needs reshuffle and exhaustion handling.
- A **target-player** primitive, used by Targeted Draw Two, Flex Wild Draw Four, Forced Swap, Jim Hopper "most cards" and Waffle "fewest cards." It needs a tie-break policy.
- A **side** state with a pairing table for Flip, and side-aware scoring.
- A **per-player toggle resource** for Flex Power Cards (green/red, with a global-reset rule).
- **Multi-pile discard** with per-pile capacity and legality masks (Triple Play lit piles, Tippo stopped trays).
- **Partner/team topology** with an "out but not eliminated" player state (Teams).
- **Parameterized challenge resolution** (Wild Draw Two, Wild Draw Four, Wild Draw Color).
- A **match-length structure** of first-to-N-hand-wins vs. points (H2O Splash: first to 3).
