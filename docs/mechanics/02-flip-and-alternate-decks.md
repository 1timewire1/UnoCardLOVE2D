# Final Review 2: Alternate Decks and Structural Variants (implementation-grade specs)

> Reference spec for `docs/gameversions.md` (see its Part F). First written from web-search snippets; **now checked against Mattel's official instruction sheets** (service.mattel.com). Anything still marked below HIGH was not on any sheet and needs a design decision or another source.

Research method:
- **Pass 1:** WebSearch snippets only (34 searches; page fetches were blocked).
- **Pass 2 (this revision):** the official instruction sheets were downloaded from service.mattel.com and read in full. Some sheets are scanned images; those were rendered and read visually. Wikipedia ("Uno Flip!", "Uno (card game)") was rechecked, but it added nothing beyond the sheets.

Sheets read: GDR44 (Flip, 2018 print), GDG37 (Flip, 2020 print, scanned), GXV56 (Flip Marvel, scanned), HJP41 (Flip Stranger Things), HXJ49 (Flip Transformers), HXT54 (Flip Attack), GXD74 (Flip Splash), GXD75 (Flip Express, scanned), HHL33 (All Wild), HMY99 / HNB00 (Flex, 2023 and 2024 prints), HXT58 / JDM40 (Teams, same sheet), GXV87 (Triple Play), HCC23 (Triple Play Stealth), R2827 (Tippo, two prints), GKF04 (Junior), HNN03 (Junior Move!), HPY62 (Junior Paw Patrol), T8234 (Choo Choo), R2823 (My First UNO Thomas, scanned), H3263 (H2O), J3721 (H2O Splash, scanned), P1703 (H2O To Go), DHW42 (UNO Splash), GDR45 (UNO Express).

No sheet was found for HHL36, HCC21 or any UNO Pocket product. Searches also turned up no Flip Nintendo, Flip Super Mario or Flip Harry Potter product on Mattel's site.

Confidence tags:
- **HIGH (sheet CODE)**: the official sheet says it; wording quoted or closely paraphrased.
- **MED**: one plausible non-sheet source, or a direct inference from sheet text.
- **LOW**: thin, a convention, or a design suggestion.
- **UNVERIFIED**: no sheet covers it.

---

## 1. UNO Flip! (2019, GDR44 / GDG37, #13)

### 1.1 Deck composition: 112 double-sided cards. Light side has a white border, Dark side a black border. 2–10 players, ages 7+.

Light colors: Blue, Green, Red, Yellow. Dark colors: Pink, Teal, Orange, Purple. Each side has exactly 112 faces. Count check: 72 + 8×4 + 4 + 4 = 112. **HIGH (sheet GDR44, GDG37)**

**Light Side**

| Card | Copies | Exact effect | Conf. |
|---|---|---|---|
| Number 1-9 (no 0) | 72 ("18 Blue cards - 1 to 9", etc.: 2 of each number per color) | Match by color or number. | HIGH (sheet GDR44) |
| Draw One | 8 (2 per color) | "The next player must draw one card and miss their turn. This card may only be played on a matching color or on another Draw One card." | HIGH (sheet GDR44) |
| Reverse | 8 (2 per color) | Reverses direction. Playable on matching color or another Reverse. | HIGH (sheet GDR44) |
| Skip | 8 (2 per color) | Next player is skipped. | HIGH (sheet GDR44) |
| Flip | 8 (2 per color) | Flips everything to the Dark side (see 1.2). "May only be played on a matching color or on another Flip card." | HIGH (sheet GDR44) |
| Wild | 4 | Choose any color, "including the color in play before." May be played even if you hold another playable card. | HIGH (sheet GDR44) |
| Wild Draw 2 | 4 | Choose the color. The next player "must draw two cards ... and lose their turn." You may play it only "when you do NOT have another card in your hand that matches the COLOR on the DISCARD pile" (matching numbers or Action Cards are fine). Challengeable (see 1.3). | HIGH (sheet GDR44) |

**Dark Side**

| Card | Copies | Exact effect | Conf. |
|---|---|---|---|
| Number 1-9 (no 0) | 72 (2 of each number per color) | Match by color or number. | HIGH (sheet GDR44) |
| Draw Five | 8 (2 per color) | "The next player must draw five cards and miss their turn." Playable on matching color or another Draw Five. | HIGH (sheet GDR44) |
| Reverse | 8 (2 per color) | As Light. | HIGH (sheet GDR44) |
| Skip Everyone | 8 (2 per color) | "All players are 'skipped' ... Play then returns to whoever laid down the card." | HIGH (sheet GDR44) |
| Flip | 8 (2 per color) | Flips back to Light. Same matching restriction. | HIGH (sheet GDR44) |
| Wild | 4 | As Light Wild, but with Dark colors. | HIGH (sheet GDR44) |
| Wild Draw Color | 4 | "The next player must draw until they get a color of your choosing (no matter how many cards they have to draw to do so) and lose their turn." Same "no card of the current COLOR" restriction. Challengeable. | HIGH (sheet GDR44) |

**Which Light face is printed behind which Dark face: NOT DOCUMENTED. Still a gap.**
- None of the eight Flip-family sheets gives a pairing table (GDR44, GDG37, GXV56, HJP41, HXJ49, HXT54, GXD74, GXD75).
- The only setup instruction is to keep "all the Light Side cards facing one way, all the Dark Side cards facing the other way."
- The Stranger Things sheet says the waffle icons appear on Upside Down cards "randomly." That fits a pairing with no pattern, but it does not define one.
- Implementation options:
  - (a) Generate a fixed 112-entry pairing table once (seeded) and ship it as data. This is the most "physical" option.
  - (b) Pair the faces randomly at each shuffle.
- Either way, the pairing must stay stable for the whole round, because hands are flipped, not re-dealt. **LOW (design decision)**

### 1.2 Flip procedure (exact order)

Sheet wording: "Once the Flip card has been played, flip over the Discard Pile (the card just played will now be on the bottom), then the Draw Pile, then everyone's hands must flip to the other side. This new side will remain in play until another Flip card is played, changing it again." **HIGH (sheet GDR44, GDG37)**

What this means for the game state:
- The **whole discard pile is turned over as one stack**. The new top card is the other face of the card that was at the **bottom** of the old pile. The played Flip card ends up at the bottom. **HIGH** (follows directly from the procedure)
- The draw pile is turned over too, and every hand flips.
- Cards added to a hand must face the same way as the rest: "if you are currently playing the Light Side, add new cards to your hand with the Light Side facing you." **HIGH (sheet GDR44)**
- **The newly exposed top card.** Sheet NOTE (GDG37, also GXV56, HJP41, HXJ49 and GXD75): "WHEN THE DECK IS FLIPPED, IF THE NEW TOP CARD ON THE DISCARD PILE IS AN ACTION CARD (REVERSE, SKIP, DRAW, FLIP) YOU DO NOT HAVE TO TAKE THE ACTION. IF THE NEW CARD ON TOP OF THE PILE IS A WILD CARD, THE PLAYER WHO PLAYED THE FLIP CARD CALLS THE COLOR."
  - The 2018 print (GDR44) does not have this note. The 2020 print (GDG37) adds it.
  - Exception: Flip Splash (GXD74) contradicts itself on who calls the color; see 2.6.
  - **HIGH (sheet GDG37)**
- The next player then matches the new top card on the new side.

### 1.3 Wild Draw 2 / Wild Draw Color challenge

- **Wild Draw 2** (sheet GDR44): "If you suspect that a Wild Draw 2 card has been played on you illegally ... you may challenge that player. The challenged player must show you (the challenger) their hand. If guilty, the challenged player must draw the 2 cards instead of you. However, if the challenged player is innocent, you must draw the 2 cards PLUS an additional 2 cards (4 total)!" **HIGH**
- **Wild Draw Color** (sheet GDR44): if guilty, the challenged player "must draw the cards until they get the chosen color instead of you." If innocent, the challenger draws "until you get the chosen color PLUS an additional 2 cards!" **HIGH**
- **Does the challenger lose their turn?**
  - The base sheets (GDR44, GDG37) don't say.
  - The newer template (Stranger Things HJP41, Transformers HXJ49) answers it for the Wild Draw 2:
    - Innocent: "the challenger draws 4 cards instead of 2 **and loses their turn**."
    - Guilty: "YOU must draw 2 cards and they draw none." This is silent on the challenger's turn; the natural reading is that the challenger then plays normally.
  - Recommendation: a failed challenger loses their turn; a successful challenger plays normally. Apply the same to the Wild Draw Color. **HIGH for the failed case (sheet HJP41, HXJ49), MED for the rest**
- **"Wild Cards are considered a match, too"** (sheets HJP41, HXJ49, and Flex HMY99 for its Wild Draw Four): when checking the challenged hand, a held Wild counts as a card of the current color, so holding any Wild makes the draw-Wild illegal. The base Flip sheets don't say this.
  - Make it an engine option. Default ON for derivatives that print it; for base Flip, OFF matches GDR44 literally.
  - **HIGH (sheet HJP41) for the derivatives; UNVERIFIED for base Flip**
- **Wild Draw Color edge cases:**
  - The victim keeps the card of the named color and loses their turn ("draw until ... and lose their turn"). **HIGH (sheet GDR44)**
  - Flip Splash (GXD74) and Flip Express (GXD75) add: "Once the player has drawn a card of the chosen color, they must show it to the other players for verification." This matters only for a physical game.
  - Flip Express caps the draw: "(or until they have drawn a maximum of five cards)". **HIGH (sheet GXD75)**
  - Base Flip has no cap.
  - **The draw pile runs out before the color appears:** not addressed. The only related rule is general: "If no player is out of cards by the time the DRAW pile is depleted, the DISCARD pile is reshuffled and play continues" (sheet GDR44). Recommendation: reshuffle (keep the top card, current side up) and continue; if the color does not exist anywhere in the draw pile, stop. **LOW (engine must decide)**

### 1.4 Starting card

The previous three-way conflict is resolved: each print and product has its own rule. **HIGH (sheets as cited)**

| Product / print | Rule |
|---|---|
| Base Flip GDR44 (2018) and GDG37 (2020), light-side actions | **Draw One:** "If turned up at the beginning of play, the same rule applies" (the first player draws 1 and misses their turn). **Reverse:** the dealer goes first, then play moves right. **Skip:** the player left of the dealer is skipped. **Wild:** the player left of the dealer chooses the color. **Wild Draw 2:** "return this card to the deck and pick another card." |
| Flip card as the starting card | GDR44: **not addressed**. GDG37 (and Marvel GXV56, Express GXD75): "If this card is turned over at the beginning of play, the deck is immediately flipped to the Dark side." |
| Wild Draw Color exposed at the start (only possible via a starting Flip) | GDG37 / GXV56 / GXD75: "the person to left of the dealer chooses the color that continues play." This implies no draw. |
| Dark Draw Five / Skip Everyone / Reverse exposed at the start | Not stated. Apply the 1.2 post-flip note (action not taken). **MED** |
| Stranger Things (HJP41), Flip Attack (HXT54) | "If this card is an Action Card, ignore it and flip over the next card." |
| Transformers (HXJ49) | Not addressed. |

Engine default: follow GDG37 (the latest base print).

### 1.5 Scoring (side face-up at the end of the round)

- "REMEMBER TO SCORE POINTS BASED ON WHICH SIDE (LIGHT OR DARK) THE GAME ENDED ON."
- "If the last card played in a round is a Draw One, Draw Five, Wild Draw Two or Wild Draw Color card, the next player must draw ... These cards are counted when the points are totaled."
- Play to 500.
- **Alternative scoring:** keep a running tally of the points each player is left holding; when one player reaches 500, the lowest total wins.
- **HIGH (sheet GDR44, GDG37)**

| Light card | Points | Dark card | Points | Conf. |
|---|---|---|---|---|
| Numbers | face value | Numbers | face value | HIGH (sheet GDR44) |
| Draw One | 10 | Draw Five | 20 | HIGH (sheet GDR44) |
| Reverse / Skip / Flip | 20 each | Reverse / Flip | 20 each | HIGH (sheet GDR44) |
| — | — | Skip Everyone | 30 | HIGH (sheet GDR44) |
| Wild | 40 | Wild | 40 | HIGH (sheet GDR44) |
| Wild Draw Two | 50 | Wild Draw Color | 60 | HIGH (sheet GDR44) |

The minority values from pass 1 (Draw Five 40, Wild Draw Color 50) are wrong.

### 1.6 Other rules and edge cases
- **Turn options** (sheet GDR44):
  - If you can't match, draw one; you may play that card if it is playable.
  - You may also decline to play a playable card and draw instead; then you may play only the drawn card.
  - **HIGH**
- **Dealer selection:** each player draws and reveals the Light side; the highest number deals, and symbols count as zero. Deal 7. **HIGH (sheet GDR44)**
- **UNO call:** yell "UNO" when playing your next-to-last card. If you are caught before the next player begins their turn, draw 2. **HIGH (sheet GDR44)**
- **Flip is not wild.** It plays only on a matching color or another Flip. **HIGH (sheet GDR44)**
- **Reverse with 2 players:** the sheet is silent. Use the classic-UNO convention (acts as a Skip). **LOW**
- **Skip Everyone with 2 players:** same as a Skip; the player plays again. **HIGH** (follows from "play then returns to whoever laid down the card")
- **No zeros:** numbers are 1-9 on both sides, so the 0-rotate half of a 7-0 toggle never fires. **HIGH (sheet GDR44)**

---

## 2. Flip derivatives

### 2.1 Flip Marvel (#198, GXV56, 2020)

Super Heroes side (white border) and Villains side (black border). 2–10 players. **HIGH (sheet GXV56, scanned and read visually)**

| Side | Cards |
|---|---|
| Super Heroes | 72 numbers 1-9 · 8 Draw One · 8 Reverse · 8 Skip · 8 Flip · **4 Wild Super Hero** · 4 Wild Draw Two |
| Villains | 72 numbers 1-9 · 8 Draw Five · 8 Reverse · 8 Skip Everyone · 8 Flip · **4 Wild Villain** · 4 Wild Draw Color |

There is **no plain Wild on either side**: the Super Hero and Villain cards take its slots.

- **Wild Super Hero:** "the player with the MOST cards in their hand gets to discard ONE card. That player then gets to choose the color that continues play in current order from the player who laid down the Wild Super Hero card."
  - It may be played even if you hold another playable card.
  - If it is the starting card, the player left of the dealer chooses the color.
- **Wild Villain:** "the player with the FEWEST cards in their hand must draw THREE cards. That player then gets to choose the color that continues play in current order from the player who laid down the Wild Villain card."
- **The color chooser is the affected player, not the caster.** The next turn still goes to the player after the caster.
- **Ties for most / fewest:** not addressed. Recommended: include the caster, and break ties by turn order starting after the caster. **LOW**
- **Starting cards:** the same as GDG37 (Flip at the start → flip to Villains immediately; Wild Draw Color exposed at the start → the player left of the dealer chooses the color).
- **Scoring:** Wild Super Hero 40 and Wild Villain 40; everything else as base Flip.
- The post-flip note is present (as in GDG37).

### 2.2 Flip Stranger Things (#143, HJP41, 2021)

"Real World" side and "Upside Down" side. 2–10 players. Contents list only "112 Double-Sided Cards": **per-card copy counts are not on the sheet (UNVERIFIED).** **HIGH (sheet HJP41)** for everything else below.

- **Numbers are "2-9, 11"** (scoring line: "All number cards (2-9, 11) ... Face Value"). The 1 appears to be replaced by an 11 ("Eleven"), worth 11 points. Whether that is true on both sides is **MED** (inferred from the scoring line).
- **Wild Jim Hopper (Real World side):**
  - "The player with the MOST cards in their hand gets to discard half of their cards (if the number of cards in their hand is an odd number, discard the larger amount)."
  - The player who laid it down calls the color.
  - **Correction:** this is a *benefit* to the player with the most cards, not a penalty.
- **Wild Eleven's Waffle (Upside Down side):**
  - "The player with the FEWEST cards must draw cards until they get a card with a Waffle Icon on it."
  - The player who laid it down calls the color.
  - Some Upside Down cards "randomly have an icon of a waffle on them." Which cards, and how many, is **UNVERIFIED**.
- **Plain Wilds:** the scoring table lists only "Wild Special Rule Cards ... Wild Jim Hopper, Wild Eleven's Waffle" at 40. That implies the special Wilds replace the plain Wilds, as in Marvel. **MED**
- **Wild Draw 2 / Wild Draw Color:** the newer challenge wording (see 1.3): a failed challenger draws 4 and loses their turn; a held Wild counts as a match.
- **Starting card:** an Action Card is ignored and the next card is turned over.
- **Post-flip note:** present.
- **Win and scoring:** the first player out wins the hand. Scoring is "optional": a running tally to 500, scored by the face-up side.
- **Ties for most / fewest cards:** not addressed. **LOW**

### 2.3 Flip Transformers (#258, HXJ49, 2023)

"Autobots" side and "Decepticons" side. 2–10 players. Numbers 1-9. Contents list only "112 Double-Sided Cards": **counts UNVERIFIED.** **HIGH (sheet HXJ49)** for the effects below.

- **Wild The Might of Optimus Prime (Autobots side):**
  - "First, choose another player to challenge. Next, both players reveal the highest NUMBER card (1-9) in their hand. The player with the HIGHER value card wins the challenge and may discard up to 2 cards."
  - "You may NOT discard the very last card from your hand using this rule."
  - "In the case of a tie, or if the challenged player has no number cards in their hand, the player who originally played the card is declared the winner."
  - Discards go "UNDERNEATH the Might of Optimus Prime Card." The challenge winner calls the color.
  - **Caster has no number card:** not addressed. Recommended: the challenged player wins if they have a number card. **LOW**
- **Wild The Tyranny of Megatron (Decepticons side):**
  - "First, choose another player to challenge. Next, both players REVEAL their hands. The player with the LOWEST value number card (1-9) must draw 2 cards."
  - "In the case of a tie, the player who originally played the card is declared the winner." The challenge winner calls the color.
  - **Either player has no number card:** not addressed. Recommended: a player with no number card counts as having no "lowest" card and so cannot lose. If neither has one, the caster wins. **LOW**
- **Scoring:** "Wild Special Rule Cards" 40; other values as base Flip. Like Stranger Things, no plain Wild is listed, which implies the special Wilds replace them. **MED**
- **Wild Draw 2:** uses the newer challenge wording (see 1.3). The post-flip note is present.
- **Starting card:** not addressed.

### 2.4 Flip Express (#285, GXD75, 2020) — a real, distinct small deck

**Correction:** pass 1 treated this as base-Flip packaging. It is a **56-card**, 2–4 player Flip built on UNO Express. **HIGH (sheet GXD75, scanned and read visually)**

| Light side (white) | Dark side (black) |
|---|---|
| 9 Blue / 9 Green / 9 Red / 9 Yellow, 1 to 9 (one of each) | 9 Pink / 9 Teal / 9 Orange / 9 Purple, 1 to 9 |
| 4 Draw One (1 per color) | **4 Draw Three** (1 per color) |
| 4 Reverse, 4 Skip, 4 Flip (1 per color each) | 4 Reverse, 4 Skip Everyone, 4 Flip (1 per color each) |
| 2 Wild, 2 Wild Draw Two | 2 Wild, 2 Wild Draw Color |

Count check: 36 + 16 + 4 = 56.

- **Setup:** deal **5** cards each.
- **Draw Three:** "the next player must draw three cards and miss their turn."
- **Wild Draw Color:** draw until the chosen color "**or until they have drawn a maximum of five cards**."
- **Starting cards:** the same as GDG37 (Flip at the start flips to Dark). The post-flip note is present.
- **Last card:** "If the last card played in a round forces the next player to draw ... they must do so."
- **Scoring:** numbers face value; Draw One 10; Draw Three / Reverse / Skip / Flip 20; Skip Everyone 30; Wild 40; Wild Draw Two 50; Wild Draw Color 60. **Game to 250.**

### 2.5 Flip Attack (#309, HXT54, 2024)

112 double-sided cards plus a battery card launcher. 2–10 players. "Mild Side" (white borders) and "Wild Side". The sheet gives **no per-card counts (UNVERIFIED).** **HIGH (sheet HXT54)** for everything below.

- **Drawing = pressing the launcher.**
  - "If nothing happens, your turn is over." "If cards SHOOT out, you must add all of them to your hand and your turn is over."
  - **Unlike base Flip, a drawn card cannot be played that turn.**
  - "You may choose to press the launcher button instead of playing a card, even if you have a playable card."
- **Missed UNO call:** you "must press the launcher twice."
- **Flip:**
  - All players flip their hands, then flip the Discard Pile.
  - Then "Lift the Card Launcher lid all the way until you see the cartridge ROTATE 180 degrees." That is the draw-pile flip.
  - The post-flip top-card note is **absent** from this sheet. Use the GDG37 rule. **MED**
- **Launcher empty:** reshuffle the Discard Pile into the launcher.
- **Starting card:** an Action Card is ignored and the next card is turned over.

| Side | Card | Effect |
|---|---|---|
| Mild | Numbers 1-9, Reverse, Skip, Wild, Flip | Classic. |
| Mild | **Hit 2x** | "Next player must hit the Launcher button twice." All cards that shoot out go to them, then "their turn is then over." Playable on matching color or another Hit 2x. |
| Mild | **Discard All** | Discard every card in your hand of the card's color, with the Discard All placed on top. It may be played on another Discard All. |
| Mild | **Wild Press Your Luck** | "Discard a card from your hand for each successful press" (a press that shoots nothing). Stop any time. If the launcher shoots cards, take them **and take back all your original cards**. The card goes on top of your discards. Call the color. |
| Wild | Numbers 1-9, Reverse, Skip Everyone, Flip | As base Flip Dark side. |
| Wild | **Hit 5x** | As Hit 2x, but 5 presses. |
| Wild | **Wild Discard All** | Plays on anything. Pick a color and discard all your cards of that color, with this card on top. Call the color. |
| Wild | **Wild All-Out Attack** | The next player becomes the target. "Starting with the targeted player, everybody takes one turn pressing the button. All cards that shoot out go to the targeted player. Play then continues with the targeted player." The card's player picks the color. |

- **Scoring:** numbers face value; Hit 2x 10; Reverse / Skip / Flip / Discard All / Hit 5x 20; Skip Everyone 30; Wild 40; Wild Discard All 50; Wild Press Your Luck and Wild All-Out Attack 60. Play to 500, scored by the face-up side.
- **No draw-Wild exists** in Flip Attack: there is no Wild Draw Two / Wild Draw Color and no challenge.
- **Plain Wild on the Wild Side:** none is listed among the Wild Side action cards. **UNVERIFIED**
- **Launcher model:**
  - The sheet says only: "Sometimes NO cards shoot out, and on the Mild side a few cards may shoot out, but on the Wild Side it may be a WHOLE BUNCH!"
  - Model each press as a random count keyed to the side, for example Mild {0: 60%, 1: 25%, 2-3: 15%} and Wild with a heavier tail up to around 5–6.
  - **LOW** (no official distribution exists)

### 2.6 Flip Splash (GXD74, 2020) — new product, no catalogue number in gameversions.md

108 double-sided cards plus a carabiner clip. 2–10 players. Same colors and layout as base Flip, except there are **2 Wild + 2 Wild Draw Two (Light) and 2 Wild + 2 Wild Draw Color (Dark)**. Count check: 72 + 32 + 4 = 108. The rules text is the GDR44 text with three changes. **HIGH (sheet GXD74)**

- **Light→Dark Flip note:** "if a wild card is now on top, the player who played the Flip card chooses what color continues play."
- **Dark→Light Flip note:** "if the new card on the top of the discard pile after the flip is a wild card, **the next player in order decides the color**." Other actions "are not re-activated."
  - **The sheet contradicts itself.** Recommended: follow GDG37 (the Flip player calls). **LOW**
- **Wild Draw Color:** the victim must show the drawn card of the chosen color for verification.
- **Scoring:** as base Flip.

### 2.7 Other "Flip" items
- Mattel's catalogue search for "flip" also returns **Phase 10 Flip (HYN12)**, which is not UNO, and the **JLL32 Fan Favorites Bundle**, which is a bundle.
- Wikipedia's list has a 2009 Target-exclusive "Uno Flip," a dexterity game unrelated to Flip! 2019.
- No Flip Nintendo, Flip Super Mario or Flip Harry Potter sheet or product exists on service.mattel.com. **HIGH** (negative search result)

### Edge cases & rulings (derivatives)
- **Most / fewest-card targets** (Super Hero, Villain, Jim Hopper, Waffle) may be the caster; no sheet gives a tie-break. Recommended: include the caster, and break ties by turn order starting after the caster. **LOW**
- **Waffle with no waffle card left in the draw pile:** not addressed. Reshuffle as in 1.3; stop if none exist. **LOW**
- **Jim Hopper "half":** odd counts discard the larger half (e.g. 9 → discard 5). Which cards are discarded is the target's choice. **HIGH (sheet HJP41)** for rounding; **LOW** for who picks the cards.
- **Optimus Prime discards** go under the Optimus card, so the Optimus stays on top as the Wild. **HIGH (sheet HXJ49)**
- **Flip Attack physical consistency:** the launcher holds the draw pile and is rotated 180° on a flip. Digitally, just flip the draw pile.

---

## 3. UNO All Wild (2022, HHL33 / HHL36, #28; Pocket All Wild #284)

### 3.1 Deck (112 cards, all Wild, no colors and no numbers). 2–10 players.

The sheet says only "112 Cards". **No per-card counts appear on it.** **HIGH (sheet HHL33)** for the effects below.

| Card | Copies | Exact effect (sheet HHL33) | Conf. |
|---|---|---|---|
| Wild | 54* | "Technically this isn't an 'action' card ... You could even call out a color if you want to. It won't change anything." | effect HIGH |
| Wild Reverse | 14* | Direction of play is reversed. | effect HIGH |
| Wild Skip | 14* | "The next player loses their turn." | effect HIGH |
| Wild Skip Two | 6* | "The next two players lose their turns." | effect HIGH |
| Wild Draw Two | 10* | "The next player must draw 2 cards and lose their turn." | effect HIGH |
| Wild Draw Four | 6* | "The next player must draw 4 cards and lose their turn." No restriction, no challenge. | effect HIGH |
| Wild Targeted Draw Two | 4* | "A player of your choice draws 2 cards (they do not lose their next turn)." | effect HIGH |
| Wild Forced Swap | 4* | "You MUST choose another player and exchange hands with them (If either player ends up with one card in their hand, they must remember to shout 'UNO!')." | effect HIGH |

\* The counts come from one fan database (BoardGameMatcher). They sum to 112, but no sheet confirms them. **UNVERIFIED**

### 3.2 Rules
- **No matching at all:** "Every card is wild, so you don't need to match number or color ... just play a card." The legality check is "always legal." **HIGH (sheet HHL33)**
- **Optional draw ("One more thing…"):** you may choose to draw instead of playing. "If you do, you must either play the card you just drew or pass your turn without playing a card." **HIGH (sheet HHL33)**
- **Starting card. Correction:** "Flip over the top card of the Draw Pile to start the Discard Pile (if it's a Wild Action Card, **ignore the action**)." The earlier claim that the starting action happens (with the dealer choosing a Targeted Draw Two victim) is wrong. The Forced Swap starting-card gap is therefore closed: it is ignored. **HIGH (sheet HHL33)**
- **UNO call:** "The moment you only have 1 card," yell UNO. If someone else "beats you to it" before the next player's turn, draw 2. **HIGH (sheet HHL33)**
- **Scoring (optional):** "Any Wild Card ... 20 Points (Wild)"; "Any Wild Action Card ... 50 Points (Literally anything else)". Running tally to 500. **HIGH (sheet HHL33)**
- **Going out on a draw card:** whether the next player draws before scoring is not addressed. **UNVERIFIED**
- **Pocket All Wild (#284, Burger King):** no sheet found. **UNVERIFIED**

### Edge cases & rulings
- **Wild Skip Two with 2 players:** the "next two" are the opponent and then yourself, so you play again. With 3 players it skips both opponents. **LOW** (convention)
- **Wild Reverse with 2 players:** acts as a Skip. **LOW** (convention)
- **Forced Swap as your last card:** going out ends the hand before the swap matters (classic Swap Hands ruling). Not stated for All Wild. **LOW**

---

## 4. UNO Flex! (#25, HMY99 / HNB00, 2023; reprinted 2024)

### 4.1 Components
- 112 cards **including 8 Power Cards**. **2–8 players**, ages 7+. **HIGH (sheet HMY99)**
- **Number cards run 1-8**: scoring reads "All number cards (1-8)". **HIGH (sheet HMY99)**
- **Three kinds of cards:** Classic, Flex and Power.
- **Setup:**
  - Give each player a Power Card on the green side. The 2023 print calls it the green "9" side; the red side is "8". The 2024 print replaces the digits with icons.
  - Deal 7 cards each.
  - **Starting card:** "If this card is an Action Card, ignore it and flip over the next card." **HIGH (sheet HMY99)**
- **Per-card copy counts are not on the sheet. UNVERIFIED.**

| Card | Regular side | Flex side (needs a green Power Card) | Conf. |
|---|---|---|---|
| Flex number card | Number in its primary ("center oval") color | The same number in its secondary color, used only to make the match | HIGH (sheet HMY99) |
| Flex Draw Two | Classic Draw 2 | "Forces every other player to draw 1 card. The next player does not lose their turn." | HIGH (sheet HMY99) |
| Flex Skip | Classic Skip | "SKIP ALL which passes over all other players so the turn comes back to you." | HIGH (sheet HMY99) |
| Flex Reverse | Classic Reverse | "Acts as a REVERSE then SKIP, so game play goes in the opposite direction and the first player in that direction is skipped." | HIGH (sheet HMY99) (was LOW-MED) |
| Flex Wild Target Draw 2 | "Acts like a classic Wild Card" | "A 'targeted' Draw 2 Card where you choose the player to draw 2 cards. Play then continues with the next player in current order." Call the color. | HIGH (sheet HMY99). The earlier separate-card question is closed. |
| Flex Wild Draw Four | Classic Wild Draw Four. Restriction: no card of the current color, and "Wild Cards are considered a match, too." Challenge: if innocent, the challenger draws 6 and loses their turn; if guilty, you draw 4 and they draw none. | "A 'targeted' Draw 4 where you choose the player to draw 4 cards. Play then continues with the next player in current order." Call the color. | HIGH (sheet HMY99) |
| Flex Wild All Draw | "Acts like a classic Wild Card" | "Forces every other player to draw 2 cards. The next player does not lose their turn." | HIGH (sheet HMY99) |
| Classic number cards (some with a "flip" icon), Draw Two, Skip, Reverse | Classic | — | HIGH (sheet HMY99) |
| Wild All Flip | "All players must flip their Power Card. This is also a Wild Card, so you call the color." | — | HIGH (sheet HMY99) |
| Power Card | 8 | Green = may use flex sides; red = may not | HIGH (sheet HMY99) |

The sheet also says: "Action Cards may be played on other Action Cards of the same color."

### 4.2 Rules
- **Flex color does not persist.** The sheet's example: you play a yellow-regular / green-flex card as green, but "the next player in order must match the YELLOW 'regular' side." "The 'regular' side or 'center oval color' of the card is the color that continues game play." **HIGH (sheet HMY99)** (was MED)
- **Power Card cycle.** After you use a flex side, your Power Card goes from green to red. "The card will stay on the red side until":
  1. "Every player's Power Card is on the red side at the same time, then all players turn their cards back to the green side."
  2. "You play a Number Card with a 'flip' symbol on it." Playing one is **mandatory toggling**: "you MUST flip your Power Card. If it is currently on the green side it flips to the red side, and vice versa." So a flip-icon card can also turn a green card red.
  3. "Someone plays a Wild Flip card."
  - **HIGH (sheet HMY99)** (all-red reset was MED; the flip-icon number cards are newly documented)
- **Turn options:** you may draw instead of playing, and play the drawn card if it matches. When the draw pile is empty, reshuffle the discard pile. **HIGH (sheet HMY99)**
- **UNO call:** same wording as All Wild (draw 2 if beaten to the call). **HIGH (sheet HMY99)**
- **Scoring (optional):** numbers face value; any Action Card 20 (Skip, Reverse, Draw 2, Flex Skip, Flex Reverse, Flex Draw 2); any Wild 50 (Flex Wild Target Draw 2, Flex Wild All Draw, Flex Wild Draw 4, Wild All Flip). Play to 500. **HIGH (sheet HMY99)**

### Edge cases & rulings
- **Flex Draw Two's flex side does not cost the next player their turn.** That is stated, so the earlier LOW question is closed. **HIGH (sheet HMY99)**
- **Targeted Draw 2 / Draw 4 aimed at the next player:** "play then continues with the next player in current order," so the target draws but still plays. **MED** (reading)
- **Flex Wild Draw Four's flex side:** the sheet does not repeat the "no matching color" restriction for the flex side. Recommended: the restriction applies to the regular side only. **LOW**
- **Wild All Flip** toggles every Power Card, the caster's included. **HIGH (sheet HMY99)**

---

## 5. UNO Teams! (#405, HXT58 / JDM40, 2024)

### 5.1 Deck
- "112 Cards." Numbers 0-9 (scoring: "All number cards (0-9)"), Draw Two, Skip, Reverse, Wild, **Wild Team Play** and **Wild Team Draw Four**. Some cards carry a **Passing Symbol**.
- **Per-card counts are not on the sheet. UNVERIFIED.**
- **HIGH (sheet HXT58)** for the card list.

| Card | Exact effect (sheet HXT58) | Conf. |
|---|---|---|
| Draw Two / Skip / Reverse / Wild | Classic | HIGH |
| Wild Team Play | "First, choose a color. Play then SKIPS directly to your partner. If they can play a card on their turn, they do and play continues from there. If they CAN'T play a card, you must draw 2 cards as a penalty. Play continues from your partner with the chosen color." | HIGH (the odd-sounding penalty reading is confirmed: the **card's player** draws 2) |
| Wild Team Draw Four | "The next player must draw 2 cards and skip their turn, and their partner must also draw 2 cards (even if they are currently out of the game). This is also a wild card, so you choose the color." | HIGH. No play restriction and no challenge are printed. |
| Passing Symbol (on some cards) | "When you play a card with a Passing Symbol, you and your teammate both pass each other 1 card." No hinting. | HIGH (newly documented) |

### 5.2 Rules
- **Teams and seating:**
  - Teams of 2, fixed for the game.
  - "Choose a partner and **sit across from them**." With 4 players, turns therefore alternate between teams.
  - The box icon reads "2–4 TEAMS" (the extracted text is "7+ 2–4TEAMS"), meaning **4–8 players in 2–4 teams**.
  - **HIGH (sheet HXT58)** for across-seating; **MED** for the 2–4 teams reading of the icon.
- **Setup:** deal 7. A starting Action Card is ignored and the next card is turned over. Then "Everyone passes one card from their hand to their partner." **HIGH (sheet HXT58)**
- **Communication:** "teammates can talk to one another, but they cannot talk or drop hints about the cards in their hands." On any Wild, a teammate "cannot say anything that will influence the color." **HIGH (sheet HXT58)**
- **Going out:**
  - "If you get rid of all the cards in your hand, your partner then passes you half the cards in their hand and you keep playing. If your partner only has 1 card left in their hand, they don't pass anything and you stay out of the game."
  - With an odd count, the partner keeps the larger half (9 → pass 4, keep 5).
  - **HIGH (sheet HXT58)**
  - The conflicting secondary versions (stay in until both are out with no passing; take cards only if the partner is doing worse) are wrong.
- **Tagging back in (new):** "While you are out, if your partner draws cards for any reason they immediately pass you half of their cards and you're back in the game." **HIGH (sheet HXT58)**
- **Winning:** "When a team plays their final card and both players are out of cards, they win." **HIGH (sheet HXT58)**
- **UNO call:** your partner may yell "UNO!" for you. The penalty (draw 2) applies only if neither of you calls before the next player begins. **HIGH (sheet HXT58)**
- **Scoring (optional):** numbers face value; Skip / Reverse / Draw 2 20; Wild / Wild Team Play / Wild Team Draw Four 50. Keep a running tally per team to 500. **HIGH (sheet HXT58)**

### Edge cases & rulings
- **Out players stay in the seating order.** They can be re-entered by Wild Team Draw Four ("even if out") or by a tag-back. **HIGH (sheet HXT58)**
- **An out player's turn:** with 0 cards they are presumably skipped. Not stated. **LOW**
- **Wild Team Draw Four hitting an out partner:** they draw 2 and so are back in. **HIGH** (follows from the text)
- **Wild Team Play with 2 teams across:** "skips directly to your partner." With 4 players this skips one opponent. **HIGH**

---

## 6. UNO Triple Play (#16; HCC23 Stealth #112; GXV87)

### 6.1 Deck (GXV87). 2–6 players, ages 7+. **HIGH (sheet GXV87)**

| Card | Copies | Effect (sheet GXV87) |
|---|---|---|
| Numbers 0-9 | 76 (19 per color) | Classic matching |
| Reverse | 8 | Reverse. As the starting card: "place it back into the middle of the draw pile and pick another card." |
| Skip | 8 | Skip. Same starting-card rule. |
| Discard Two of the Same Color | 8 | Play it together with one more card of its color. The Discard Two goes on the bottom, and you "only press the Discard Pile once." "If the last card played is a Special card, the next player in order must do the action." It may also be played alone. |
| Wild | 4 | Plays on anything, but **the player does NOT call a color.** "The next player that plays to that pile in current order decides the color that continues play" by laying down any card. If that card is a Special card, its action is honored. |
| Wild Clear | 4 | Place it on a lit pile and hold for TWO SECONDS. This resets that pile's Card Counter to green. It may be played any time. The color is set as for Wild. |
| Wild Give Away | 4 | "If you play this card and it causes the Discard Pile to 'overload,' you may take all the cards you are required to draw ... and give them away to any player or players you choose," in any split. Otherwise it is just a discard. The color is set as for Wild. |

Count check: 76 + 24 + 12 = 112.

**Correction:** there is **no Draw Two and no Wild Draw Four** in Triple Play. Pass 1 listed "classic Skip / Reverse / Draw Two / Wild / Wild Draw Four."

### 6.2 Game logic (device abstracted) **HIGH (sheet GXV87)**
- **Setup:** deal 7, then place 1 card face up on each of the three pile spaces. Only Reverse and Skip have a "put it back" starting rule; the number-only requirement from pass 1 is not on the sheet.
- **Lit piles:** "The amount of playable Discard Piles will vary each turn." "YOU MAY ONLY PLAY TO A DISCARD PILE SPACE THAT IS LIT UP." "You may only play to ONE Discard Pile per turn." Match by number, color or symbol.
- **No match:**
  - Draw one card and play it if you can.
  - Otherwise "you must press one of the available Discard Piles to activate the card counter." A press with no card still counts toward overload.
  - The same applies if you choose not to play.
- **Overload:**
  - "The player who played the card that caused the overload must draw the indicated number of cards ... (anywhere between **1-4** cards)." Then press Go for the next player.
  - **The pile is not cleared by an overload.** Only Wild Clear resets a counter.
  - Housekeeping only: around 20 cards on a pile, remove all but the top card. Those removed cards are reshuffled when the draw pile runs out.
- **Going out:** "If you play your last card on a Discard Pile that overloads, you cannot go out. You must draw the number of cards indicated ... and continue playing."
- **Timer mode:** a few seconds per turn (the Spanish text says five). If the timer expires, "take back any cards you tried to play and draw 6 cards." If an overload happens in Timer mode, the timer pauses.
- **Scoring:** numbers face value; Reverse 20; Skip 20; Discard 2 30; Wild / Wild Clear / Wild Give-Away 50. Play to 500, or use the running-total alternative.
- **"Challenge Game" (new):** an elimination variant. Players are eliminated at a designated total (suggested 500). The last two play head to head, and whoever reaches the total loses.

### 6.3 Triple Play Stealth (HCC23) **HIGH (sheet HCC23)**
- **Same deck, but the 4 Wild Give Away are replaced by 4 Wild All Tap:** "One at a time every other player must tap an active discard pile until it OVERLOADS. When it does, they must draw the number of cards indicated." Scoring 50.
- **STEALTH mode** (ON/OFF/STEALTH switch): "Game play is the same as in Regular or Timer mode except the Card Counter Display lights DO NOT CHANGE COLOR ... They will stay blue the entire round."
- Volume control: values 0–5.

### Digital model
- Per pile: `count`, a hidden `capacity` (random, e.g. uniform 4–12), and `warn = count / capacity` (green / yellow / red; always blue in Stealth).
- Per turn: `lit` = a random non-empty subset of the three piles, perhaps weighted toward 2–3 lit piles.
- Overload draw: uniform **1–4** (the sheet gives this range). On overload, re-roll that pile's capacity without clearing it.
- Wild Clear sets `count = 0`.
- A press with no card adds 1 to `count`.
- **LOW** for the capacity and lit distributions (no official numbers); **HIGH** for the 1–4 draw range.

### Edge cases & rulings
- **After an overload, the turn passes:** "press the Go button to re-set the unit for the next player in current order." **HIGH (sheet GXV87)**
- **A Wild on top of a pile:** the next player to play there may play any card, and that card's color becomes the pile's color. **HIGH (sheet GXV87)**

---

## 7. UNO Tippo (#24, R2827, 2009)

### 7.1 Deck: 112 cards. 2–10 players. **HIGH (sheet R2827)**

| Card | Copies |
|---|---|
| Numbers 0-9 | 76: "19 Blue Cards - 0 to 9 (includes 5 Stop Cards #1-5)", same for each color, so **20 Stop cards** |
| Draw Two / Reverse / Skip | 8 each (2 per color) |
| Wild | 4 |
| Wild Draw Four | 4 |
| Tilt | 4 |

Count check: 76 + 24 + 12 = 112. Stop cards are the numbers 1–5 printed with an octagon. Each color has two of each 1–9; that one copy of each 1–5 is the Stop copy is inferred. **MED**

### 7.2 Rules as logic (two discard trays on a balance scale) **HIGH (sheet R2827)**
- **Setup:**
  - Dealer is whoever draws the highest number. Deal 7.
  - Turn over two cards, one per tray. Starting action cards are disregarded, and the first player chooses the color of a starting Wild.
- **Play:**
  - Match the top card of **either** tray.
  - "Whenever an Action card is played, the next player must follow that action regardless of what is on top of the other tray."
  - No match: draw one; play it if possible.
- **Stop cards:**
  - "Whenever there is ONE visible Stop card, that tray is stopped; no player can discard on it."
  - "Whenever there are TWO visible Stop cards, both trays are open."
  - "There are 2 ways to open a stopped pile: Playing any Wild card on top of a Stop card ... Playing a Stop card in the other tray."
  - "You can play a Stop card on top of another Stop card (as long as color or number of both Stop cards match) ... However, you cannot play a number card that is not also a Stop card on top of a Stop card."
- **Implementation:**
  - A tray is `stopped` when its top is a Stop card and the other tray's top is not.
  - A stopped tray accepts **only a Wild** (any Wild, which opens it).
  - An open tray topped by a Stop card accepts a matching Stop card or a Wild, but no plain number.
  - Whether a color-matching action card may go on a Stop card is not addressed. **LOW**
- **Tipping (any cause):**
  - "If the scale tips so far that the cards are dumped out, you must draw 2 cards as a penalty! ... the last player to make a play (discard or draw) takes the 2-card penalty."
  - Reset "by placing the top 2 cards in each DISCARD pile back in their respective trays and set all other cards aside." The set-aside cards are reshuffled when the draw pile is depleted.
  - **Correction:** natural tips are confirmed to use the same penalty, and spilled cards are set aside rather than returned to the draw pile.
- **Tilt card:**
  - "When you play this Wild card ... starting with the next player and going in order of play, all players—including you—take turns drawing one card from the DRAW pile and placing it in the same tray as the Tilt card. Continue doing this until the scale tips."
  - The last discarder draws 2. "The player after whoever tipped the scales is next."
  - "If the last card discarded was an Action card, the next player must follow that action."
  - Tilt as your last card: players still discard until the scale tips, so you risk the 2-card penalty.
  - Whether the Tilt player calls a color is not stated; it is called a "Wild card." **MED**
- **Wild Draw Four:** the sheet gives no "no matching color" restriction and no challenge. **HIGH (sheet R2827)** (absence)
- **UNO call and scoring:** say UNO on your next-to-last card; if caught, draw 2. Scoring: numbers face value; Draw Two / Reverse / Skip 20; Wild / Wild Draw Four / Tilt 50. Play to 500, or the running-total alternative.

### Digital model
- `imbalance = |weightA − weightB|`, where weight can be the card count.
- Tip when `imbalance ≥ T`, where `T` is random (e.g. 6–10) or a hidden per-round value.
- Tilt = a forced loop: each player adds 1 draw-pile card to the Tilt tray until the threshold is crossed.
- **LOW** (no official numbers)

---

## 8. UNO 52 (#158; GBA 2006 / DS 2007 video game, not a physical card product)

Unchanged from pass 1. There is no Mattel sheet; it is a video game. **UNVERIFIED** beyond the fan wiki.

| Element | Spec | Conf. |
|---|---|---|
| Turn structure | (1) Play a card to the discard pile as in normal UNO. (2) Optionally play one card from your hand into your **poker hand**. Step 2 may be skipped, and is forced off if no card can be added. | MED (nintendo.fandom) |
| Poker hands | The fan wiki says players hold "five face-up poker hands that can be swapped." This may mean a 5-card face-up hand per player. They "influence your score at the end of the round." | LOW |
| Chips | Each player starts with 25 chips and antes 1 into the pot every round. | MED |
| Game types | **Chips:** reach 50–500 chips. **Uno Wins:** go out first, over 1–10 rounds. **Poker Wins:** win 1–10 rounds with a poker hand. **Pot Wins:** win the pot. | MED (fandom + MobyGames) |

Gaps:
- The poker hand-ranking table.
- How the pot is split between "went out first" and "best poker hand."
- Whether poker-hand cards can be stolen or swapped.
- The color/number → suit/rank mapping.

Design this mode from scratch. Mattel's "UNO Wild Twists" (HJR19, a 52-card playing-card deck) is **not** UNO 52.

---

## 9. Reduced and kids decks

### 9.1 UNO Pocket, Pizza Pizza / Pizza 73 (#51-52) — UNVERIFIED

No UNO Pocket sheet exists on service.mattel.com. Pass-1 data (gamerules.com) is kept as is: 36 numbers 1–9 (one per color), 4 Draw One, 4 Skip, 4 Reverse, 3 Wild, probably plus 1 exclusive promo Wild. Deal 5, play to 250. **MED / UNVERIFIED.** "Pocket" is a promo label, not one fixed composition.

**Closest official analogue — UNO Express (GDR45, 2018):**
- 56 cards, 2–4 players, deal 5, play to 250.
- Numbers 1-9, with Draw One, Skip, Reverse, Wild and **Wild Draw Two**.
- Starting Action Card: ignore it and turn over the next card.
- **Wild Draw Two challenge:** "The challenged player must draw four cards. However, if the challenged player is innocent, you must draw four cards!" (4 either way).
- **Scoring:** numbers face value; actions 20; Wild and Wild Draw Two 50.
- Per-card counts are not printed. A likely split is 36 numbers + 4 of each action + 4 Wild + 4 Wild Draw Two = 56. **HIGH (sheet GDR45)** for the rules; **MED** for the counts.
- This is a good candidate preset for a reduced deck.

### 9.2 UNO Junior (GKF04, 2020) and UNO Junior Paw Patrol (HPY62) **HIGH (sheet GKF04, HPY62)**
- **Correction:** the deck is **56 cards, not 45**.

| Card | Copies |
|---|---|
| Animal number cards, 0-8 | 36 (9 per color) |
| Draw 1 | 4 (1 per color) |
| Draw 2 | 4 (1 per color) |
| Skip | 4 (1 per color) |
| Reverse | 4 (1 per color) |
| Wild | 4 |

- 2–4 players, ages 3+. Deal **5**.
- Match by **color, number or animal**. HPY62 uses "character" cards in the same layout.
- **Levels:**
  - **Beginner:** "Take out all the Action Cards."
  - **Intermediate:** "Add the Reverse, Skip and Wild cards BACK INTO the deck, but LEAVE OUT the Draw One and Draw Two cards."
  - **Advanced:** add Draw One and Draw Two (the entire deck).
  - The earlier source conflict over whether Wild joins at level 2 is resolved: it does.
- **No match:** draw ONE card and play it if it matches.
- **UNO:** if caught not saying it, draw 2. The winner is the first player out (no points).
- "You can play an action card on top of a matching action card no matter the color."
- **Correction:** HPY62 is **UNO Junior Paw Patrol The Mighty Movie**, not Junior Move! (that is HNN03).
- Mein Erstes UNO (#350) is presumably the German Junior. **UNVERIFIED**

### 9.3 UNO Junior Move! (#362, HNN03, 2022) **HIGH (sheet HNN03)**

| Card | Copies |
|---|---|
| Numbers 1-8 | 32 (8 per color) |
| Draw 1 | 4 |
| Draw 2 | 4 |
| Skip | 4 |
| Reverse | 4 |
| Wild | 4 |
| MOVE! cards | 4 |

That is 52 playing cards + 4 MOVE! cards = 56.

- 2–4 players, ages 3+. Deal 5.
- Match by color, number or image.
- **Setup:** "Remove the 4 MOVE! cards ... have each player pick a card." Each card names one action: Jump, Dance, Clap or Bend.
- **Star icon:** cards with a Star Icon "randomly" have it. When you play one, "you MUST get up and perform your action. ... Then, your turn is over."
- **Advanced level:** if you forget the action and are caught, draw 1 extra card.
- **Levels:** the same three as Junior.
- **Digital:** show the action as a prompt only.

### 9.4 UNO Choo Choo (#391, T8234, 2011) **HIGH (sheet T8234)**

| Card | Copies |
|---|---|
| Animal cards: Zebra, Giraffe, Tiger, Monkey, Elephant | 20 (one per color each) |
| Raccoon (Draw 1) | 4 (one per color) |
| Conductor (Wild, white) | 4 |

Total 28 cards.

- 2–4 players, ages 3+. Each player starts with 5 cards (popped from the train). **The youngest player goes first.**
- **Discard Track** instead of a pile; the last card on the right is the "End Card." Logically it is just a discard pile.
- **Matching:** the boxcar color **or** the animal.
- **Conductor:** wild, playable any time on your turn; call the color. If it is the Starter Card, whoever goes first chooses the color.
- **Raccoon:**
  - The next player draws 1 and loses their turn.
  - Playable "only on another raccoon card or on a matching color card (or a conductor if the matching color is in play)."
- **No match:** draw 1. "If the card you draw matches ... or is a conductor, you may immediately play it." This closes the earlier gap.
- **Train empty, or the track too long:** shuffle every track card except the End Card.
- **Calling:** say "UNO Choo-Choo!" before connecting your next-to-last card. If caught before the next player plays or draws, draw 2.
- **Winning:** the first player out wins (no points).

### 9.5 My First UNO (Thomas & Friends, R2823, 2010; other licences vary) **HIGH (sheet R2823, scanned)**

| Card | Copies |
|---|---|
| King-size numbers #1–#7 | 28 (one per color each) |
| Draw 2 | 4 |
| Wild | 4 |

Total 36 cards.

- 2–4 players, ages 3+. The dealer is the highest card; deal 5.
- **Starting card:** "If the card drawn is a Wild Card or a Draw 2 Card, continue drawing cards until you find a number card (1-7)."
- **Matching:** number, color or character.
- **No match:** draw one; play it if it matches.
- **UNO penalty:** draw 2, if caught before the next player plays or draws.
- **Winning:** the first player out wins.
- Other My First UNO licences (Sofia, Dora, Pooh, etc.) have their own sheets. **UNVERIFIED**

### 9.6 UNO H2O (#40, H3263) **HIGH (sheet H3263)**
- 108 waterproof cards, 2–10 players.
- **"The first player to win three hands wins the game."** This applies to **base H2O too**, not just Splash.
- **Wild Downpour One / Two:** "all other players must either draw one or two cards depending on which Wild Downpour card is played. The player of the card may also call a new colour and play continues in the current direction."
- **Wild Draw Four:** worded with **no restriction and no challenge**.
- Per-card counts are not printed ("compatible with the original UNO instructions"). The number of Downpour cards is **UNVERIFIED**.

### 9.7 UNO H2O Splash (#47, J3721, 2005) **HIGH (sheet J3721, scanned)**
- 108 cards plus a Whirlpool, 2–10 players. "The first player to win three hands wins the game" (first-to-3, not best-of-3).
- **Trigger:** "When a player plays a Splash Card, a '0', or a '2' the next player, in the current direction of play, must shake the Whirlpool and follow the command." A 0 or 2 must still be played on a matching color or number.
- **Splash Card:** also a Wild; the player may call a new color.

**Whirlpool commands** (8, up from the 4 known in pass 1):

| # | Command | Effect |
|---|---|---|
| 1 | Draw H2O | The next player draws until they get a blue, a "2", a "0" or a Wild. |
| 2 | Wave Right | The player shows the player on their right one card. |
| 3 | Wave Left | The player shows the player on their left one card. |
| 4 | Wipeout | Reverses the order of play. The player who played the Splash card must flip the Whirlpool. |
| 5 | Draw 3 | The player draws 3. |
| 6 | Draw 2 | The player draws 2. |
| 7 | Give 1 | The player gives one card to any player they choose. |
| 8 | Discard 2 | The player may discard any two cards; the top card becomes the new color and number. |

- **Wild Draw Four** has no restriction in the text, the same as base H2O. Pass 1 said the restriction was "dropped in Splash"; that is accurate but not Splash-specific.
- The number of Splash Cards is **UNVERIFIED**.

### 9.8 UNO H2O To Go (P1703) and UNO Splash (#39, DHW42) **HIGH (sheet P1703, DHW42)**
- Both are the **classic 108-card deck with classic rules**:
  - 19 per color (0–9), 8 each Draw Two / Reverse / Skip, 4 Wild, 4 Wild Draw Four, plus a carabiner.
  - Classic Wild Draw Four restriction and challenge (4 / 6).
  - Classic scoring to 500.
- This resolves the pass-1 conflict: the "H2O To Go = 500 points" retailer listing is correct, because that product has no Downpour cards and no first-to-3 rule.

---

## Cross-mechanic interaction notes

### Flip (and its derivatives) with standard toggles
1. **Flip + 7-0 (rotate/swap hands):**
   - No Flip-family deck has a 0, so the 0-rotation half of 7-0 never fires. Stranger Things also has no 1; it has an 11.
   - Decide whether 7-0 is disabled or remapped (e.g. 7 swap, 1 rotate) when Flip is on.
   - A swapped hand keeps its current side face-up.
2. **Flip + Stacking:**
   - **Light side:** can Draw One stack on Draw One, and can Wild Draw Two stack on it? These are +1 / +2 ladders.
   - **Dark side:** Draw Five on Draw Five gives +10. Draw Three in Flip Express is the same idea.
   - **Wild Draw Color cannot be summed.** Options:
     - (a) It is unstackable.
     - (b) Stacking another Wild Draw Color re-names the color and passes the obligation on.
     - (c) A mixed chain resolves as "draw N, then continue until the color."
   - **Recommendation:** forbid playing Flip while a draw penalty is pending (Flip is not a draw card).
3. **Flip + Jump-In:**
   - "Identical" must include the side.
   - The post-flip exposed-top-card rule (no action; the Flip player calls a Wild's color, per GDG37) must name the **jumper** as the Flip player.
4. **Flip + draw-to-match / forced-play toggles:**
   - Don't stack "draw until playable" on top of Wild Draw Color: the sheet says the victim "lose[s] their turn."
   - Flip Attack forbids playing a drawn card at all ("add all of them to your hand and your turn is over"), so draw-and-play toggles conflict with Flip Attack.
5. **Flip + challenge toggles:**
   - Parameterize the challenge by penalty:
     - Wild Draw Two: 2 / 4.
     - Wild Draw Color: until-color / until-color + 2.
     - Flex Wild Draw Four: 4 / 6.
     - UNO Express Wild Draw Two: 4 / 4.
   - Parameterize two more things:
     - Whether a held **Wild counts as a match** (printed in HJP41, HXJ49, HMY99; absent in GDR44 and GDG37).
     - Whether a failed challenger loses their turn (yes per HJP41, HXJ49).
6. **Flip + Skip Everyone family:**
   - Skip Everyone, Flex Skip All, and the 2-player Reverse-as-Skip all reduce to "the caster plays again."
   - With a Jump-In window, others may Jump-In before the caster's extra turn.
7. **Flip + scoring toggles:**
   - Card value depends on the face-up side at round end, so the score function must read the current side.
   - The Flip Express target (250) and the Flip Attack values differ; they belong in the preset.
8. **Flip + Teams:**
   - Partner card-passing happens on the current side, and passed cards stay double-sided.
   - A Dark-side "Team Draw Color" is undefined.
9. **Flip Attack + base Flip:**
   - Flip Attack has **no Wild Draw Color**, so "press until color" never arises. That closes the pass-1 gap.
   - Hit 2x / Hit 5x are explicitly "hit the Launcher button twice / 5 times" (an N-press draw). That also closes the pass-1 gap.
   - The launcher RNG should be keyed to the side.
10. **Duel primitive (new):**
    - Might of Optimus Prime and Tyranny of Megatron each need a "choose a player, compare revealed cards, the winner gets an effect and calls the color" primitive.
    - Ties go to the caster.

### All Wild
11. **All Wild + Stacking:**
    - Any of Wild Draw Two, Wild Draw Four or Targeted Draw Two can extend a chain (unverified counts 10 / 6 / 4).
    - Questions the engine must answer: can Targeted Draw Two re-target a stack? Can a Skip "dodge" one?
    - Recommendation: Draw-on-Draw only, with Targeted Draw Two as a terminator.
12. **All Wild + 7-0:** inert (no numbers). Forced Swap is the native analogue.
13. **All Wild + Jump-In:** near-constant with identical plain Wilds. Disable it, or restrict it to identical action names.
14. **All Wild + Wild Draw Four challenge:** must be disabled. The sheet prints no restriction.
15. **All Wild + color-dependent toggles:** inert. Calling a color is cosmetic per the sheet.
16. **All Wild starting card:** the action is ignored (HHL33). Don't reuse the classic starting-action resolver.

### Flex
17. **Flex + Stacking:**
    - Flex-side draws (all others draw 1 or 2; targeted 2 or 4) are non-stackable terminators.
    - Per the sheet, "play continues with the next player," so they never cost the next player a turn.
    - Regular-side Draw Two and Wild Draw Four stack normally.
18. **Flex + Jump-In:** compare the **regular** side. Recommendation: no flexing on a Jump-In, since it would also consume the Power Card.
19. **Flex + Flip:** do not support combining the decks.
20. **Flex color persistence:** confirmed. `matchColor = primaryColor` even when the card was played via its flex color. This must override the engine's "current color = color of the last play."
21. **Flex Power Card flip-icon numbers:** a number-card play can toggle the player's own resource (green→red as well as red→green). The engine needs a per-card `togglesPower` flag.
22. **Flex + 7-0:** Flex numbers are 1-8, so there are no 0s; 7s exist.

### Teams
23. **Teams + 7-0:** a 7-swap with your own partner is legal but exploitative, and a 0-rotation moves cards across teams. Consider restricting 7-swaps to opponents.
24. **Teams + Stacking:** Wild Team Draw Four hits two players (2 each). Recommendation: forbid stacking on it, or let only the next player pass on their 2.
25. **Teams + out players:** out players are re-entered by Team Draw Four or a tag-back. They must stay in the seating array. Skip their turns while their hand is empty.
26. **Teams + swaps:** swapping with a 0-card player would put the swapper out instantly. Forbid targeting 0-card players.
27. **Teams + Passing Symbol:** a passed card arrives mid-turn. Check UNO-call state for both partners after each pass.

### Triple Play / Tippo (multi-pile)
28. **Multi-pile + Flip:** don't combine them.
29. **Multi-pile + Stacking:**
    - Triple Play has no draw cards, so stacking is inert there.
    - In Tippo, a pending Draw Two or Wild Draw Four applies "regardless of what is on top of the other tray," so a global pending draw is correct.
30. **Multi-pile + Jump-In:** allow Jump-In on any pile whose top is identical. In Triple Play, also require that pile to be lit.
31. **Triple Play Wilds set no color.** The next card played on that pile sets it. The color-call UI must be suppressed in this mode, and each pile needs its own "accept anything" flag.
32. **Tippo Stop cards + All Wild:** incoherent (Stop legality depends on color/number), so don't combine them.

### Kids and reduced decks
33. **Pocket / Express:**
    - No 0s and no Draw Two in Pocket; Express has a Wild Draw Two with a 4 / 4 challenge.
    - 7-0's zero-rotation is inert, and stacking reduces to small chains.
    - The 5-card deal and 250 target belong in the preset.
34. **Junior / Choo Choo / My First UNO matching:**
    - Add a third match attribute (`animal` or `character`): legality becomes `color == c || number == n || picture == p`.
    - Choo Choo has **no numbers at all** (animal + color only).
    - Junior has 0-8; Junior Move! and My First UNO have 1-8 and 1-7.
    - Toggles that assume numbers (7-0, Jump-In) need a picture-aware equivalent or must be disabled.
35. **H2O Splash Whirlpool on 0 and 2:**
    - It collides with 7-0, since a 0 would both rotate hands and trigger the Whirlpool. Resolve 7-0 first, then the Whirlpool, or disallow combining them.
    - "Draw H2O" is a draw-until-predicate (blue / 2 / 0 / Wild).
    - "Give 1" and "Discard 2" reuse the target-player and multi-discard primitives.
36. **First-to-3-hands** applies to both H2O and H2O Splash. H2O To Go and UNO Splash use points.

### Generic engine requirements surfaced by this cluster
- A **draw-until-predicate** primitive, with an optional cap. Used by Wild Draw Color (Flip Express: max 5), Waffle and Draw H2O. It needs reshuffle and exhaustion handling.
- A **target-player** primitive with a tie-break policy. Used by Targeted Draw Two, the Flex targeted draws, Forced Swap, Jim Hopper / Super Hero (most cards), Waffle / Villain (fewest cards), Give 1 and All-Out Attack.
- A **duel** primitive (choose, reveal, compare, winner effect + color call). Used by Optimus and Megatron.
- **Side state** with a pairing table for Flip, plus side-aware scoring and side-specific starting rules.
- A **per-player toggle resource** for Flex Power Cards: green/red, an all-red reset, and per-card toggle flags.
- **Multi-pile discard** with per-pile capacity, lit masks, per-pile "color set by next card" (Triple Play) and Stop-card legality (Tippo).
- **Partner/team topology** with an "out but not eliminated" state, tag-back, and card passing (Teams).
- **Parameterized challenge resolution:** penalty pair, whether Wild counts as a match, whether the challenger loses the turn.
- A **match-length structure:** first-to-N hand wins (H2O and H2O Splash: 3) vs. points (500, or 250 for Express and Flip Express), plus the elimination "Challenge Game" (Triple Play).
- A **"drawn card cannot be played" turn flag** (Flip Attack launcher draws).
