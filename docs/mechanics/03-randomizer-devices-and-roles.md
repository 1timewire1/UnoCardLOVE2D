# Final review 3: randomizer devices, shared-pile and role mechanics

> Reference spec for `docs/gameversions.md` (see its Part F). Gathered from web-search snippets only; direct page fetches were blocked during research, so treat anything below HIGH as needing a check against the official instruction sheet before shipping.

Research for docs/gameversions.md Part A, at implementation level. Method: WebSearch snippets only (35 queries). Fetching pages was blocked, so no full instruction sheet was read end to end. Mattel instruction-sheet IDs that came up are listed so a human can check them: J3719 / N8367 (UNO Spin 2005), JGR00 (UNO Spin 2025), JJB31 (Spin Adults Only), T8220 (Roboto), CGH09 (Tiki Twist), P9391 (Eye Eye SpongeBob), DNG26 (Wild Jackpot), Y2316 / "UNO Power Grab Rules.pdf" (Power Grab), CGH10 (Royal Revenge), DWV64 (Colors Rule), HBF06 (Remix), T8221 (Reflex), Y2318 (Blast).

Confidence tags: **HIGH** = 2+ independent sources agree. **MED** = one detailed, plausible source (often a Mattel-sheet snippet). **LOW** = thin or inferred.

## Two corrections to the current survey doc (read these first)

1. **Wild Jackpot (#27) has no "shared growing Jackpot pile" in any source found.** The survey doc's A2 table said "a running pile of drawn cards accumulates in the middle; a Jackpot card dumps the whole pile on someone." Every source instead describes a **slot-machine "Wild Roller"**. Its lever-spinner has 6 symbols, and a button dispenses player-written Customizable Rule cards. The accumulate-and-dump mechanic actually belongs to **UNO Blast (#110)**: drawn cards go into the Card Blaster, which fires all of them at a random moment. The old row probably mixed up the two products. Confidence that it was wrong: MED-HIGH. No source mentions a pile, and 4+ sources describe the Roller.
2. **Power Grab (#104) uses four towers, U, N, O and "!".** They are not "U/N/O plus a 4th piece that voids things". Each tower separately blocks one action type: U blocks Draw One, N blocks Draw Two, O blocks Wild Draw Four, and "!" blocks Skip. Holding all four gives "Instant UNO", which means discard all cards but one (HIGH). So the doc's phrase "collect U/N/O + a 4th to void Draw 1/2/Wild+4, or empty your hand" is partly wrong. There is no Reverse tower.

---

## 1. UNO Spin (2005, #15), Spin To Go (#107), UNO Spin 2025 (#381), Spin Adults Only (#382)

### 1a. UNO Spin 2005: trigger and deck

| Item | Copies | Rule | Conf |
|---|---|---|---|
| Spin card (number cards 1-5 with a swirl around the number) | 5 per color = 20 | Played like a normal number card. The **next player** spins the wheel **instead of taking their turn** (Geeky Hobbies: "the next player in turn order spins the wheel instead of the player that played the Spin card"). | HIGH (20 cards, 1-5); MED (next player spins) |
| Rest of deck | Standard 108-card composition. The Mattel sheet says "19 Blue cards - 0 to 9 (includes 5 Spin Cards #1-5)", so Spin cards replace normal 1-5 cards and do not add to them. | Standard actions behave as in classic UNO. | MED |
| Scoring | No source gave a special point value. Spin cards are number cards, so they are presumably scored at face value. Manuals.plus: if the **last card** played is a Spin card, the next player still spins and resolves it, and the result can change round scoring. | | LOW |

### 1b. UNO Spin 2005: wheel outcomes (9 spaces, one source says "9-space spin wheel")

All 9 come from Mattel-sheet snippets (J3719/N8367) plus Wikipedia/Geeky Hobbies. **Weight**: assume 1/9 each (the physical wheel has equal segments). That is LOW, because the segments might not be the same size.

| Outcome | Weight | Exact effect (official wording where a snippet had it) | Conf |
|---|---|---|---|
| UNO Spin | 1/9 | "All players rush to yell 'UNO Spin.' The first player to yell it gets to discard one card of their choice." Wikipedia adds "even if it cannot be usually played." | HIGH |
| Discard Color | 1/9 | "The player that spun the wheel chooses a color in their hand and can discard all cards of that same color. You can choose to keep some cards of that color if you do not wish to discard all of them." **Conflict:** Wikipedia says "discard any or all cards of the same color **on the discard pile**", meaning the color of the top card. | HIGH (spinner may discard any or all of one color); conflict on which color |
| Discard Number | 1/9 | Spinner picks a number in their hand and "can discard all of the cards of that number from their hand, but are not required to discard all of them." | HIGH |
| Draw Red | 1/9 | "Draw until you pick up a red card (or Wild card). You must keep all of the cards you have drawn." The last card drawn is kept too. | HIGH |
| Draw Blue | 1/9 | Same as Draw Red, but for blue (or Wild). | HIGH |
| Trade Hands | 1/9 | "All players trade hands, passing to the left." If anyone receives a 1-card hand, they must call UNO or take the 2-card penalty. | HIGH (pass left); MED (UNO clause) |
| Show Hand | 1/9 | The spinner shows their hand to everyone, then normal play resumes. (The snippet said "players must show their hand". It most likely means the spinner only.) | MED |
| War | 1/9 | Each player reveals their highest number card. The highest one wins, and **ties are broken by each tied player's next-highest card**. The winner may then discard that card regardless of the top discard. | MED |
| Almost UNO | 1/9 | "The player that spun the wheel discards all but 2 cards." | HIGH |

**Not found:** "Spin Again", "Hit 5", "UNO Spin Off", and "Wild Spin" did not appear in any 2005 source. They may be false memories or belong to other editions. Do not implement them as official without checking.

**Spin To Go (#107):** no source showed any rule difference. Treat it as the same wheel and rules in a travel format (LOW). N8367 may be a later printing or the To-Go sheet. That is unconfirmed.

### 1c. UNO Spin 2025 (JGR00, #381)

| Item | Copies / weight | Effect | Conf |
|---|---|---|---|
| Spin cards | **24** per the Spanish JGR00 sheet ("Cartas Spin (24)": 5 per color numbered 1-5, plus **4 Wild Spin cards** with a spiral). Most English secondary sources still say 20. | Trigger a spin. Who spins in 2025 is not confirmed. Geeky Hobbies points out that in 2005 the *next* player spins, which suggests this changed in 2025 (maybe the player who played the card spins). | MED (24); LOW (who spins) |
| Color Draw | Probably 4 colored segments (R/B/G/Y) | "Depending on which color (Red, Blue, Green, Yellow) the Spin Wheel stops on, you must draw cards from the Draw Pile until you get a card of that color." | MED |
| Wild Color Draw | ? | The same draw-until mechanic, but a color is *chosen* instead of fixed by the wheel. Who chooses (spinner or someone else) and who draws is unclear. | LOW |
| Color Discard | ? | "Choose a color, then take all cards of that color from your hand and place them on the **BOTTOM** of the Discard Pile." The top card does not change. | MED |
| Swap Hands | ? | Spinner trades hands with **one chosen player**. This differs from 2005, where everyone passed left. | MED |
| 2x (product page: "Double Spin") | ? | "Beginning with the next player in current order, all players get to play 2 cards on their turn if they are able." Lasts **until the wheel is spun again**. | MED |
| Other segments | ? | Total segment count not found. Some summaries mixed 2005 outcomes into the 2025 list. Treat that as unverified. | LOW |

### 1d. UNO Spin Adults Only (JJB31, #382)

| Item | Detail | Conf |
|---|---|---|
| Contents | 112 cards, 1 spinning wheel. 2-8 players, 18+. | MED (Mattel shop page) |
| Challenge space(s) | Spinner draws a **challenge card** ("some challenges are physical, some are personal and some are racy"). The penalty for refusing was not found. | MED |
| Card-action spaces | Named: **Draw 2, Discard 2, Discard All**. "Discard All" probably means all of one color or number. | MED (names); LOW (exact effect) |
| Full segment list and weights | Not found. | gap |

### Edge cases & rulings (Spin family)
- 2005: spinning *replaces* the next player's turn. After the outcome resolves, play moves to the player after the spinner (inferred from "instead of their turn"). LOW
- Draw-until outcomes: a Wild counts as the stop card for Draw Red/Draw Blue. If the draw pile runs out, reshuffle the discard pile (standard rule, inferred). If no target-color card exists anywhere, the engine needs a cap. That case is unspecified.
- Discard outcomes: discarded cards go onto the discard pile but **do not trigger their actions** (inferred, standard for "discard" effects). Leftover action cards are not resolved. The top-card question needs a ruling: which discarded card ends up on top? In 2025 this is avoided because cards go on the bottom.
- Any outcome that leaves a player with 1 card: they must call UNO. Any that leaves 0: that player wins the round. Rules imply this for Almost UNO / Trade Hands, and it is explicitly stated for Trade Hands.
- "UNO Spin" race: in a digital game the race needs a real-time button, or the AI resolves it randomly or by reaction time.
- Discard Color: the source conflict (spinner's choice vs color of top discard) should be a sub-toggle.
- 2x persists across turns, so it is game state that a later spin must clear.

---

## 2. UNO Roboto (#103), UNO Tiki Twist (#106), UNO Eye Eye SpongeBob (#111)

### 2a. UNO Roboto (T8220)

| Element | Detail | Conf |
|---|---|---|
| Setup | Players record their names. Roboto calls one player to record **one House Rule per game** (max 10 seconds of audio). This can be skipped. Roboto names the **first player**. 4 "House Rule" cards are removed from the deck at setup (their purpose is unclear; probably reference/write cards). | MED (Mattel snippet) |
| Trigger | Players press the **Discard Plate** when they discard. Roboto randomly reacts to some discards. The frequency was not found. | MED (plate exists); LOW (per-discard trigger) |
| Outcome table (incomplete, weights unknown) | (1) **Named player discards all cards of a named color** (e.g. "all of their yellow cards"). (2) **Two named players swap hands**. (3) **Named player gets an extra turn**. (4) **Duel**: two named players must do a stated task, and **the last to finish draws 2**. (5) Name someone a nickname (party/flavor). (6) **House Rule all-play**: everyone races to do the recorded House Rule, and **the last to finish draws 2**. | MED (several blogs and reviews agree on the list; UBG has the draw-2 penalty) |
| UNO call | Still required: "no matter what he says, winners still have to say UNO." | MED |

### 2b. UNO Tiki Twist (CGH09)

| Element | Copies | Effect | Conf |
|---|---|---|---|
| Spin symbol on regular cards | Count not found | "Whenever a card with a Spin symbol is played, that player must spin the Tiki Idol." The **player the idol points to** does the action of the Tiki Face currently in the idol. | MED (Mattel snippet) |
| Tiki Face cards (placed in the idol and set its current action) | Count not found. Types: **Draw One, Draw Two, Draw Four, Discard Two, Discard All, Go To** | Draw N: pointed-at player draws N. Discard Two: pointed-at player discards 2 cards (probably any cards). Discard All: probably all of one color (not confirmed). **Go To**: "play order immediately skips to" the pointed-at player, who must play a card. If they cannot play, they draw 1. | MED (types, Draw Four, Go To); LOW (the Discard variants' exact wording) |
| How a Tiki Face enters the idol | | A Tiki Face card that would start the discard pile goes into the idol instead, and a new start card is flipped. Playing a Tiki Face during the game presumably *replaces* the face in the idol (fan wiki: "while this card is in the Tiki Idol"). | MED (start); LOW (replace on play) |
| Spin validity | | The idol must make at least one full turn or the spin is redone. If it stops between two players, **the spinner chooses** which one. | MED |
| Impossible actions | | No penalty if an action cannot be done. Exception: Go To with an empty playable hand means draw 1. | MED |
| Scoring | | 500 points, standard. | HIGH |

### 2c. UNO Eye Eye SpongeBob (P9391)

| Element | Copies | Effect | Conf |
|---|---|---|---|
| Deck | 112 cards: 108 standard + **Eyeball cards, 5 per color (20)**. Eyeball cards are probably number cards with an eyeball mark, like Spin cards; this is unconfirmed. | | MED |
| Trigger | | Playing an Eyeball card means pressing SpongeBob's nose, and both eyes spin. **Left eye = which player acts; right eye = which action.** One snippet said "next player must follow that card's action", which is garbled. | MED (BGG + Mattel snippet) |
| Right-eye outcomes (partial) | weights unknown | **Draw 4**, **Discard 1**, **Draw until a blue / yellow / Wild card**. Reference "cheat sheet" cards explain the icons. | LOW-MED (Spielbound listing) |
| Start card | | If an Eyeball card is flipped to start the discard pile, it is treated as a normal number card. | MED |

### Edge cases & rulings (device family)
- All three devices pick a **target player** at random. Roboto and Eye Eye pick the action at random too. In Tiki Twist the action is set by whichever face card is in the idol, so it is **deterministic and visible**. Model Tiki Twist as state (current_face) plus a random target. Model the others as random target plus a random action.
- A random target can be the triggering player. Nothing in the sources forbids it.
- A Go To (Tiki) or extra-turn (Roboto) outcome moves the turn pointer. The next turn is then counted from the new player, in the current direction (inferred).
- The race/duel outcomes (Roboto) need real-time input or simulation.

---

## 3. UNO Wild Jackpot (#27, DNG26)

| Item | Copies | Effect | Conf |
|---|---|---|---|
| Deck | 108 cards in total, including **16 Jackpot cards** (probably 4 per color, which is inferred) and **2 Wild Jackpot cards**. The full split is not found, so the standard deck must have been trimmed somewhere to fit them. | | MED (UBG + retailer) |
| Customizable Rule cards | 8 erasable cards, 2 pens | Players write house rules. The cards are shuffled and loaded into the unit's dispenser, never into the draw pile. Doc rows #498/#503 cover the sample "thought starters". | HIGH |
| Jackpot card (colored) | 16 | "You can only play this card on a matching color or another Jackpot card." Pull the lever. The spinner lands on 1 of 6 symbols, and you carry out that symbol's action. | MED |
| Wild Jackpot card | 2 | Like Jackpot, but it is a Wild: you can play it "on any turn, even if you have another playable card in your hand", you choose the next color, and you pull the lever. Then play passes to the next player. | MED (2 sources) |
| **Spinner symbols (6)**: the list is partial | Assume 1/6 each (LOW) | Found so far: (a) **Choose Any Player (even yourself)**: press the button to dispense a rule card, and the chosen player performs it. (b) **Player on your RIGHT** performs the dispensed rule. (c) **Player on your LEFT** performs it (fan wiki only). (d) **Every player, starting with you**, receives a rule card and performs it (fan wiki). (e) **Discard up to one card of each color** (fan wiki). (f) **Draw Four** (product copy: "land on Draw 4"). Mattel copy also names an "UNO Wild Jackpot!" outcome. It may be the discard symbol (e), or a 7th or replacement symbol. | MED (a, b, f); LOW (c, d, e, jackpot) |
| Start card | | If a Wild Jackpot card starts the discard pile, the player left of the dealer chooses any player, then presses the button. That player performs the dispensed rule. | MED |

### Edge cases & rulings
- What happens to a dispensed rule card after use? Not found. It is probably reloaded or put back into the dispenser. In a digital game, refill the dispenser from the discarded rules when it is empty.
- Is a dispensed rule one-shot (do it now) or persistent (a house rule for the rest of the game)? The wording "perform the rule written on that card" suggests **one-shot**. MED
- There is **no Jackpot pile**. See the correction at the top. If the project still wants a "growing shared pile", it should be credited to UNO Blast (section 8c) or labeled as an original house rule.

---

## 4. UNO Power Grab (#104, Y2316)

| Item | Copies | Effect | Conf |
|---|---|---|---|
| Components | 112 cards, 4 Power Towers (U red, N blue, O green, ! yellow), play tray | | HIGH |
| Power-icon number cards | Each icon appears **twice in each color** = 8 per icon, 32 in total (arithmetic from the rule text) | Playing a card with icon X lets you take tower X from wherever it is: the middle or another player. **The icon matters, not the card's color.** | HIGH (mechanic); MED (count) |
| Draw One | 8 (2 per color) | Next player draws 1 (and presumably loses their turn). | HIGH |
| Grab-2-Towers | 4 (1 per color) | Take any 2 towers from anywhere, including unclaimed ones. | HIGH |
| Wild Grab-A-Tower | 4 | Wild. Choose a color and take any 1 tower from anywhere. | HIGH |
| Draw Two / Skip / Reverse / Wild / Wild Draw Four | Counts not found. 112 minus 48 known non-standard cards leaves the rest for numbers and these. | Standard. | LOW (counts) |
| **U tower** | | Protects its holder from **Draw One**. | HIGH |
| **N tower** | | Protects from **Draw Two**. | HIGH |
| **O tower** | | Protects from **Wild Draw Four**. | HIGH |
| **! tower** | | Protects from **Skip**. | HIGH |
| All 4 towers | | "Instant UNO": "you get to discard all of your cards EXCEPT one, and then you still must call UNO." | HIGH |

### Edge cases & rulings
- Protection lasts "for the entire time you are in possession of it", so a stolen tower gives the protection to the new holder at once.
- A blocked action card is "treated as a regular color or Wild card": it still sets the color or symbol for matching, but has no effect on the protected player.
- When do you discard down to 1 card after getting all 4? Presumably right away, on the turn you get the 4th tower. Does it happen again if you lose a tower and get it back later? Unspecified, so the engine needs a once-per-acquisition flag.
- No tower protects against Reverse.

---

## 5. UNO Royal Revenge (#159, CGH10)

| Item | Copies | Effect | Conf |
|---|---|---|---|
| Crown (King role) | 1 | The youngest player starts as King. **The King chooses the color of every Wild played by anyone**: "if a wild card is laid down, the King decides what color shall be played." | HIGH |
| Royal Scepter (electronic timer) | 1, 2 AAA (one retailer says 3 AA) | Plays a fanfare at random times (about once a minute). When it sounds, **the crown passes to the player on the current King's LEFT**. Mattel copy says "rotates clockwise", which is the same thing at a table. The new King then picks a Jester by waving the scepter at someone until the start sound plays. Any player can be picked, including the current Jester. | HIGH |
| Jester hat (Jester role) | 1 | Worn by the player the King picks. What it does in play was **not found**. Most likely the Jester is the target of Jester cards. | LOW |
| King's Choice card | 4 (1 per color) | "The King gets to decide who will be forced to draw a card." Draw 1 card, King picks the victim. | HIGH |
| Jester card | 8 (2 per color) | Effect **not found**. The best guess is that the player wearing the Jester hat draws or suffers a penalty. Verify in CGH10-Eng.pdf. | LOW |
| Wild Dare (?) | ? | Named in one source and not confirmed. | LOW |
| Other cards | Standard Skip, Reverse, Wild (+ probably Wild Draw Four). Counts not found. | | LOW |

### Edge cases & rulings
- Digital port: replace the scepter with a random timer. Use a per-turn probability, or fire every N turns ± random. Real time does not work in a turn-based game.
- Does "left" mean the current *play direction* after a Reverse? Unspecified. The physical rule is seat-left. MED
- If the King plays a Wild, the King names the color as usual. If someone else does, the King chooses. The AI King's choice should favor the King's own hand.
- Can the King be the King's Choice target? Unspecified. Allowing it is probably fine.

---

## 6. UNO Colors Rule! (#162, DWV64, 2017)

| Item | Copies | Effect | Conf |
|---|---|---|---|
| Deck | 112 cards, 4 card holders. Card types: numbers **1-9** (fandom lists no 0), Draw Two, Reverse, Skip, Wild Draw Four, **Wild Color Choice** (= plain Wild), **Wild Color Character** (16; probably 4 per color, inferred), Color Power (4) | | MED |
| Color Power cards | 4 (one per color), placed face up in the center at the start | The holder has the power. Shown in a card holder. | HIGH |
| Wild Color Character (color X) | 16 | Wild. Playing one lets you **take Color Power X** from the center or from another player ("anyone who plays a Wild Color Character can take that corresponding Color Power Card from another player"). Presumably the next color is set to X. | HIGH (steal); LOW (color forced to X) |
| **Red power** | | "Give all of your red cards to another player **at any time**." Reusable or once? Not found. | MED (fan wiki only) |
| **Yellow power** | | Blocks Draw, Skip, Reverse and the **Red power** when they are aimed at you. | MED |
| **Green power** | | If you have no match, flip the top card of the draw pile onto the discard pile. It becomes the card in play, whether or not it matches, instead of you drawing. | MED |
| **Blue power** | | Play two playable cards in one turn. | MED |

### Edge cases & rulings
- The power descriptions come only from the matteluno fandom page. Verify against DWV64 before calling them official.
- "At any time" on the Red power means **out-of-turn interrupts**. Is it once per turn or unlimited? Unspecified. Red-power card dumps can empty your hand, and then you win (presumably you still need to call UNO).
- Yellow blocking Reverse is odd in 2-player and multiplayer games alike. Most likely a Reverse "aimed at you" just doesn't change direction when you are next. Unclear. LOW
- Can you hold more than one power? Yes, nothing caps it (inferred).

---

## 7. UNO Remix (#164, HBF06, about 2020-21)

| Item | Copies | Effect | Conf |
|---|---|---|---|
| Deck | 112 = **56 Game cards + 56 Remix cards**. Remix cards are blank write-on cards **kept in a fixed order and NOT shuffled** until customized. Also 4 Wilds (in the game deck?), 1 sticker sheet, and a score sheet. | | HIGH |
| Remix draft (each round) | Take N cards from the **front** of the ordered Remix deck (N = number of players), face up. Youngest picks first, then clockwise, one each. Each player customizes theirs by type, then they are shuffled into the Game deck. **Each round adds N more**, so the deck keeps growing more personal. Writing is permanent. | | HIGH |
| W, Wild + Name | Writer puts **their own name** on it. When anyone plays it, **the named player chooses the color**. | MED |
| SK, Skip-To | Writer's own name. Can be played on a matching color or symbol. Play **jumps to the named player**. | MED |
| SH, Shield + Name | Writer's own name. **Blocks penalty (draw) cards.** Presumably only the named player gets the protection. | MED (block); LOW (named-only) |
| G, Giving Card | Writer puts an **opponent's** name. When drawn, it **automatically goes to the named player**. A Shield cannot block it. | MED |
| D2 / WD4 (+Name) | Opponent's name. Probably "Draw 2 / Wild Draw 4, aimed at the named player" (fixed target). | LOW |
| AN2 / AN4 | Codes only. Probably "Add Name" to an existing D2/WD4, or +2/+4 variants. Unknown. | LOW |
| AM, Add A Mark / Plus cards | "Plus" cards carry **tally marks**, and the next player draws 1 card per mark. AM lets a player add a mark, so the card gets stronger over rounds. One review says Plus cards start as draw-1. | MED |
| Order of Remix deck | The sheet prints the order as W, SK, G, AM, SH, D2, WD4, AN2, AN4 (Geeky Hobbies "Order of Remix Deck"). Copies per type not found. | MED (order); gap (counts) |

### Edge cases & rulings
- Named-target cards when the named player is absent or eliminated: unspecified.
- A Giving card that is **dealt** (not drawn) at the deal: presumably it also passes to the named player. Unspecified.
- Shield vs Giving: explicitly cannot block it. Shield vs stacked draws: unspecified.
- Digital: free-text or name stickers turn into **parameter picks**: choose a type, then choose a player name or a mark count. The deck persists for the whole match (across rounds). Writing it to disk between games would copy the "permanent marker" feel.

---

## 8. Reflex/reaction family (game logic only)

### 8a. UNO Flash (#23)

| Element | Effect | Conf |
|---|---|---|
| Turn order | The unit (light-up player buttons) **picks who starts at random and keeps reshuffling who goes next** (fan page: "arbitrarily rearrange"). A player's lit button means it is their turn. | LOW-MED |
| Slap card | Play it, then press SLAP instead of your player button. All opponents race to press their own buttons, and **the last one draws 2**. That player's button flashes, and pressing it resumes the game, so the loser probably goes next. | MED (fandom + Geeky Hobbies) |
| Slap matching | Conflict: matches only same color or another Slap, **or** matches same color or same-type special card (which is the same thing, just worded differently). Treat it as a normal colored action card. | MED |
| Other cards | Draw Two, Skip, Wild, Wild Draw Four are standard. Reverse is probably absent because order is random (inferred). | MED / LOW |
| Scoring | Slap, Draw Two, Skip = 20. Wilds = 50. 500 points to win. | MED |

### 8b. UNO Reflex (#108, T8221)

| Element | Effect | Conf |
|---|---|---|
| After every play | The player presses the Reflex button. **Sometimes** a color lights up ("a colored light will not be displayed every time"). | MED (Mattel snippet) |
| Color lit | ALL players race to lay ANY one card of that color in front of them and press the button. **The first to do both gets rid of that card.** Everyone else takes their card back. Play continues with the player **after the winner**. | MED |
| Wrong color | Laying the wrong color and pressing means draw 2. | MED |
| Can't play | If you can't play a card on your turn, you do not press the button (no reflex roll). | MED |
| Action under the light | If the lit card is an action card (e.g. Draw 2), "the next player must complete that action". | MED |

### 8c. UNO Blast (#110, Y2318): the real accumulate-and-dump pile

| Element | Effect | Conf |
|---|---|---|
| Drawing | A player with no playable card draws 1 and puts it **into one of the Card Blaster's slots**, not into their hand. A newly drawn card can never be played that turn. | HIGH (Mattel + UBG) |
| Blast | The blaster fires at a random moment, and **the player who was inserting gets ALL the cards in it**. | HIGH |
| Draw One card | Next player draws 1 and puts it in the blaster. That counts as their turn. | MED |
| Wild Blast | Next player keeps drawing and inserting cards **until the blaster fires**. | MED |
| Slot choice | Slots exist and the player picks one. It is not clear whether the choice changes the odds. Digital: one shared hazard probability per insertion, maybe slightly different per slot (house design). | LOW |
| Scoring | 500 points. | HIGH |

### 8d. UNO Showdown (#37) / Showdown Supercharged (#105)

| Element | Effect | Conf |
|---|---|---|
| Showdown cards | Cards with a Showdown icon start a duel between **the player who played it and the next player**. A number on the card (1-3) sets how many draw-pile cards are loaded. | MED (Geeky Hobbies + GameRules + groupgames) |
| Duel | After a random countdown, the first to slam their paddle wins. **The loser takes the loaded cards.** Digital: a reaction-time minigame, or a 50/50 (or skill-weighted) coin flip. | MED |
| Showdown Draw Two | Works as a classic Draw Two (next player draws 2 and loses their turn). | MED |
| Supercharged differences | Not found. | gap |
| Scoring | 500 points, standard. | HIGH |

---

## Cross-mechanic interaction notes

**Hand-exchange collisions**
1. **Spin "Trade Hands" (all pass left) / Roboto swap / Spin 2025 "Swap Hands" vs the 7-0 rule.** All of them move whole hands. Resolve each effect fully before checking UNO calls or a win. If a 7 or 0 is the Spin-card trigger (it can't be in 2005, because Spin cards are 1-5, but a house deck could change that), resolve the 7-0 swap first, then the spin. Also decide whether "pass left" follows seats (official) or the current play direction (the 7-0 "0" rule usually follows direction). Recommendation: keep seat-left for Spin, play direction for 7-0, and document both.
2. **Trade Hands vs Power Grab towers / Colors Rule powers.** Towers and powers belong to the *player*, not the hand, so they stay put. A hand that was protected by a tower is now held by someone else.
3. **Hand swap vs Remix Giving card** (only triggers "when drawn"): a swap is not a draw, so it does not trigger.

**Discard-out-of-turn collisions**
4. **Spin Discard Color/Number, Almost UNO, Wild Jackpot "discard one of each color", Power Grab Instant UNO, Colors Rule Red dump.** Effects that empty a hand outside normal play. Do they count as going out? Recommendation: yes, but only after the current effect has fully resolved. Do not let a discarded action card trigger. Decide which card ends up on top of the discard pile (2025's place-on-bottom wording avoids the problem, so it is the cleanest default).
5. **Mass discards vs Jump-In.** A discarded card that exactly matches the top card must **not** open a Jump-In window. Otherwise discards chain. Suppress Jump-In while device effects are resolving.
6. **Spin "UNO Spin" race / Reflex light / Roboto duel vs Jump-In.** These are all real-time interrupts. Use one "interrupt window" system with a priority order: device race first, then Jump-In.

**Draw-penalty collisions**
7. **Stacking vs device draws.** Spin Draw Red/Blue, Tiki Draw Four, Wild Jackpot Draw Four, Eye Eye Draw 4, Roboto/Showdown loser draws, and Blast dumps are **not stackable cards**. They should resolve as plain draws and must not add to or clear a pending stack. If a Spin card is played while a +2 stack is pending (only possible if Spin cards could stack, which they can't), the stack resolves first.
8. **Power Grab towers vs Stacking.** If the N-tower holder is the target of a stacked +2+2, is the entire stack voided, does it pass to the next player, or does it end? Recommendation: the protected player is immune, the stack **ends** with no draw, and the last +2 counts as a colored card. With "Draw 4 on Draw 2" stacking allowed, the O tower and N tower each protect only their own card type, so a mixed stack gets awkward. Suggest: protection applies if the tower matches the **last** card of the stack.
9. **Colors Rule Yellow ("block Draw/Skip/Reverse") and Remix Shield vs Stacking:** the same question. Same recommendation: block ends the stack.
10. **Power Grab "! blocks Skip" vs Skip-Everyone / Mercy-family toggles:** decide whether it blocks only the Skip card or any skip effect (Draw Two's "lose your turn" too?). The official wording names Skip *cards*, so default to cards only.
11. **Wild Draw Four challenge vs King (Royal Revenge).** If the King chooses the color, the challenge question ("did the player have a matching color?") still refers to the color before the Wild. Fine, but a Royal-Revenge AI must not let the Wild's *player* pick the color.

**Turn-pointer collisions**
12. **Spin 2005 "spin instead of turn" vs Skip/Draw cards.** A Spin card is a number card, so it never coincides with a Skip. But if a Spin card is played and then a device effect like Tiki "Go To" or Roboto "extra turn" fires, decide who spins. Recommendation: handle device triggers in a FIFO queue, and update the turn pointer only after the queue is empty.
13. **Flash random order vs Reverse/Skip/7-0 "direction".** With Flash on, direction means nothing. Turn off Reverse and direction-based toggles, or define "next" as the next random pick.
14. **Reflex "play continues after the winner"** and **Tiki Go To / Remix Skip-To** all jump the turn pointer. They conflict with "Skip Everyone" and with a pending stack's target. Freeze reflex/jump effects while a stack is pending.
15. **Spin 2025 "2x" vs Colors Rule Blue (play 2 cards).** Do they combine to 3 or 4 cards a turn? Recommend no: cap at 2, and treat both as the same "multi-play" flag. 2x also interacts with Stacking: does playing two +2s in one turn count as a stack of 4 against the next player? Recommendation: yes, and treat it as one stack contribution.
16. **2x vs Jump-In**: a jump-in during 2x should count as one card, not start a 2-card turn.

**Role/ownership collisions**
17. **Royal Revenge King vs Colors Rule Wild Color Character.** If the King picks every wild color, a Character Wild's color may not match its power. Recommend: the King picks the color, and the power steal still follows the card's printed color.
18. **Several "who picks the Wild color" rules**: Royal Revenge King, Remix Wild + Name (named player), and the standard rule (the player). Precedence is needed. Suggest: card-specific (Remix name) > global role (King) > player.
19. **Steal mechanics (Power Grab towers, Colors Rule powers) vs hand swaps and team modes.** Ownership is per player. In team variants, decide whether a teammate's tower protects the team. Recommend no.
20. **Wild Jackpot / Roboto house-rule text vs engine toggles.** A free-text rule cannot be executed. A digital port needs a fixed menu of parameterized one-shot effects, and some of them (e.g. "swap hands") overlap with other toggles. Reuse the same effect code paths.

**Pile collisions**
21. **Blast blaster contents vs reshuffling the draw pile.** Cards in the blaster are out of the draw pile and the discard pile. If the draw pile runs out during a Wild Blast "draw until it fires", reshuffle the discard pile (but not the blaster). If both are empty, force the blast to fire.
22. **Draw-until effects (Spin Draw Red/Blue, Color Draw, Eye Eye draw-until) vs No Mercy-style "Mercy Rule" (hand-size elimination).** Draw-until can exceed the elimination limit in the middle of the effect. Decide whether elimination is checked after each card or after the effect ends. Recommend: after the effect ends.
23. **Device triggers on the starting card.** Each product handles them differently: Tiki Face goes into the idol, Eye Eye counts as a number card, Wild Jackpot gets the left-of-dealer special rule. Spin 2005 has no rule in the sources. Recommend: no trigger on the start card unless a specific rule says otherwise.

## Gaps remaining (priority order)
- Wild Jackpot: the full list of 6 spinner symbols, and how the 108 cards are split.
- Royal Revenge: the Jester card effect, the Jester hat effect, and the full card list.
- Tiki Twist: copies of Spin-symbol cards and of each Tiki Face, and the exact wording of Discard Two / Discard All.
- Eye Eye SpongeBob: the right-eye icon table.
- Roboto: how often triggers happen, and outcome weights.
- Spin 2025: number of segments, Wild Color Draw wording, who spins. Spin Adults Only: the segment list.
- Remix: copies per Remix type, and AN2/AN4.
- Colors Rule: official wording of the powers (only the fan wiki has them so far).
- Power Grab: counts for the standard actions.
- Showdown Supercharged: how it differs from #37.
