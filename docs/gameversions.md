# UNO gameplay mechanics survey

This document surveys ~500 named UNO releases (physical, digital, and a handful of never-released
concepts) to scope out which ones offer a **gameplay mechanic** genuinely different from base UNO,
versus which ones are **cosmetic reskins** (same rules, licensed artwork). The goal: figure out what
a "mix-and-match" settings menu for this LÖVE port could realistically offer, from easiest to hardest,
and what's simply off the table for a pure digital card-rules engine.

**Bottom line up front:** of ~500 entries, about 250 are tagged RESKIN (a licensed movie, TV show,
sports team, or brand on a 108-112 card UNO deck). A full verification pass over all of them (see the
note at the end of Part D) found that most of those "reskins" still ship one or two bespoke themed bonus
cards; only a small minority are genuinely plain. Structurally distinct mechanics still cluster into a
few dozen *families*, because the same mechanic gets reused across many themed reissues (e.g. every
"Fandom NFL" team deck uses the same one added rule card; every "Ultimate Marvel" expansion pack just
adds one more character to the same power system). Part A catalogs those families, Part C is the
implementation roadmap, and Part D is the full title-by-title table for traceability back to the
source list.

## Methodology and confidence

This survey was produced by six research passes (one per ~80-item chunk of the source list) plus a
manual pass for the "never released" ideas at the end, using product pages, BoardGameGeek,
GeekyHobbies, the UNO Fandom wiki, Mattel's own rules PDFs, and similar sources. Two important caveats:

* **Reskins are asserted from a strong prior, not verified one-by-one.** With ~350 licensed decks,
  individually confirming "no added card" for each was not practical. The pattern (Mattel prints a
  themed deck with 0-2 bespoke cards, rules otherwise standard) is extremely well established and
  called out explicitly by multiple sources, so it's a safe default — but a specific title tagged
  RESKIN here could turn out to have one overlooked bonus card.
  **Update (verification complete):** a dedicated pass has now re-checked every RESKIN row individually
  (5 batches plus a deep-dive follow-up; see the note at the end of Part D). It reversed this prior:
  most single-movie/TV tie-ins from the mid-2000s on ship one bespoke wild card or house rule that Mattel
  doesn't advertise loudly. The rows that came back genuinely plain are mostly sports-team commemorative
  tins and novelty brand decks. Every RESKIN row in Part D now carries a "Correction"/"Confirmed"/
  "Unverified"/"Follow-up" note with a confidence tag. The RESKIN tag was kept even when a bonus card
  was found, meaning "standard rules plus at most a small themed card", as opposed to MECHANIC, which
  marks a structurally different ruleset.
* **Sourcing caveat:** most of the survey was built from web-search result snippets, because page
  fetches were blocked at the time. A final pass then read about 150 of Mattel's official instruction
  sheets (service.mattel.com) for every mechanic family, the Fandom line and ~95 licensed bonus cards.
  Rows marked "(sheet CODE)" quote that sheet. Elsewhere, HIGH means 2+ independent sources agreed,
  not that an official PDF was read. BoardGameGeek and the UNO fandom wiki stayed inaccessible.
* **Two entries are still tagged UNKNOWN** (#377, #399) where even the product's identity couldn't be
  pinned down. They're called out in Part D and should be treated as "we don't actually know," not
  "confirmed cosmetic."
* Where a family (Fandom NFL, Ultimate Marvel, Elite NFL, Burger King Desafio, Add-On Packs) repeats
  across dozens of numbered entries, Part A describes the mechanic **once**; Part D just points back
  at it.

## How feasibility tags work

Every mechanic in Part A gets a tag reflecting how hard it would be to add as a togglable option in
*this* codebase specifically — not "is this hard in general." That matters because this is a pure
digital card-rules engine (`src/uno.lua` is the rules engine, `src/ai.lua` drives four AI seats,
`src/game.lua` is a turn-based coroutine UI) with a **fixed 4-seat layout** (YOU/WEST/NORTH/EAST), no
dice, no motors, no camera, and no ability to verify what a human player does away from the screen.
The engine already ships three optional rules (7-0, 2vs2, Stack) — several mechanics below turn out to
be small extensions of those.

| Tag | Meaning |
|---|---|
| **EASY** | A localized rule tweak: new card effect(s) using existing primitives (draw N, skip, reverse, choose color, choose target), little to no new UI. |
| **MEDIUM** | Needs genuinely new state or UI (a new game-wide status, a new player-facing choice, new card art), but is still just turn-based card logic. |
| **HARD** | Needs a structural change (new pile model, per-character content, a new player count, a full alternate ruleset) — big but not impossible. |
| **NOT FEASIBLE (physical)** | Depends on a physical device (motorized launcher, spinner, scale, dice tower, Jenga blocks) that has no meaningful digital equivalent beyond "insert an RNG call," and/or the product *is* that physical device. |
| **NOT FEASIBLE (unenforceable)** | Depends on players doing something in the real world (performing a dare, dancing, making a face, being honest about a personal question) that software cannot check. Can be *displayed* as a prompt with an honor-system self-report, but never truly "implemented." |
| **OUT OF SCOPE (different game)** | Not UNO's discard-matching mechanic at all (Rummikub, Bingo, Sudoku, dominoes, a falling-block puzzle game, a Jenga tower...). Could be a separate project; not a menu toggle on this game. |
| **ARCHITECTURAL** | Blocked less by mechanic complexity and more by this game's fixed 4-player, single-table structure (e.g. anything needing 6-16 players). |

---

## Part A — Distinct mechanic families

### A1. Already in this codebase

For reference, `src/uno.lua` already implements three optional rules that several "new" mechanics
below turn out to duplicate or extend:

* **7-0**: playing a 7 swaps hands with a chosen player; playing a 0 passes every hand to the next
  player in turn order.
* **2vs2**: YOU+NORTH vs WEST+EAST; a team wins when either member empties their hand.
* **Stack**: +2s (and optionally +4s) can be stacked instead of drawn; the first player who can't
  stack draws the accumulated total.

These map directly onto several "real" products: **Uno Deluxe House Rules** (#369) is essentially
Mattel's own packaging of 7-0 (their "Seven-O") + Stack ("Progressive") + one rule this engine
*doesn't* have yet, **Jump-In** (play an identical card out of turn, skipping to that player). Mattel's
official wording (sheet 41940): the jumped-in card *cancels* the card it lands on and play continues
from the jumper; it never adds to a stack. Official Progressive UNO is same draw type only, one card
per turn. Jump-In needs out-of-turn plumbing, so it's not quite a card-effect tweak. **Tag: EASY-MEDIUM.**

### A2. Draw-pile / penalty variants

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Stacking +2/+4/+6/+10, Mercy Rule, 7-Swap, 0-Pass, Color Roulette, Discard All, Skip Everyone | Uno Show 'Em No Mercy (#45, #378, #390, #406-407), digital Ubisoft port | The "maximalist" house-rule pack: draw penalties of every size stack onto the next player; a hand of 25+ cards eliminates you; wilds can force a full-table color change, dump your whole hand of one color, or skip the whole table. | **EASY–MEDIUM** (each piece is a small independent extension of the Stack rule already in the engine; the full combined ruleset is a bigger lift but decomposes cleanly into independent toggles) |
| Reverse Pack: Reverse Draw 2, Reverse Skip, Wild Power Reverse, Wild "NO U" (reflect a penalty back) | Uno Add-On Packs! Reverse Pack (#421) | Combo cards (reverse+draw, reverse+skip) plus a card played *in response* to a Draw card that makes the Draw card's player take the penalty. | **EASY** (cards) / **MEDIUM** (NO U needs a response window) |
| Stack Pack: Stack 1/2/3, Wild Stack Number (random N via flipped card) | Uno Add-On Packs! Stack Pack (#422) | Officializes stacking as cards rather than a blanket house rule: colored Stack cards stack only onto a Draw card of the same color, Wilds onto anything; Wild Stack Number flips pile cards until a number. | **EASY** |
| Newer Add-On Packs (Frenemies, Comeback, Defense, Love Island) | Additions table at the end of Part D | Frenemies: targeting/rivalry wilds (Nemesis, Petty Play, Eliminator, Instigator). Comeback: catch-up wilds (Swap Hands, Double Down, Match the Max, Misery Loves Company) plus a U-N-O instant-UNO rule. Defense: Block, Block & Rebound, Block & Deflect, Redirect. Love Island: pair-linking wilds. Exact text in `docs/mechanics/01`. | **EASY-MEDIUM** (Defense needs the response window) |
| No Mercy Attack (2026) | Additions table at the end of Part D | No Mercy's rules on an Attack launcher: Hit cards stack equal-or-higher, every press must be completed, Mercy at 25. | **MEDIUM** (once No Mercy and the randomized draw exist) |
| Accumulate-and-dump pile (drawn cards go into a shared container instead of your hand; it empties onto whoever triggers it) | Uno Blast (#110). **Correction:** previously credited to Wild Jackpot (#27), which has no such pile; see A5 for Jackpot's actual roller. No source ties the Arby's promos (#342, #367) to any shared pile. | A player who can't play inserts their drawn card into the pile; at a random moment it fires and the inserting player takes everything. "Wild Blast" makes the next player keep inserting until it fires. | **MEDIUM** (needs a new shared-pile state plus a per-insert fire probability) |
| Novelty fixed-N draws: Draw 73, Draw 100, "everyone else draws 4" | Pizza 73 promo (#488), No Mercy April Fools card (#487), unreleased idea (#494) | Just the existing draw-N action generalized to arbitrary N and to "all opponents" as target. | **EASY** |
| Power Grab towers (four ownable towers U/N/O/!, each blocking one card type; all four = discard down to 1) | Uno Power Grab (#104) | A persistent per-player protection layer: U blocks Draw One, N blocks Draw Two, O blocks Wild Draw Four, ! blocks Skip. Towers are stolen by playing tower-icon cards. | **MEDIUM** |

### A3. Turn-order and targeting variants

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Bullseye targeting (choose who an action card hits, instead of always "next player") | Mini Uno Bullseye (#418) | Turns single-target action cards into player-choice-target cards. | **EASY** (the codebase's 7-0 already has a "choose a player" UI to reuse) |
| Swap Pack: Swap 1, Refresh Hand, Wild Force Trade, Wild Pass Hands | Uno Add-On Packs! Swap Pack (#420) | A cluster of hand-manipulation cards; "pass all hands" is exactly 7-0's "0" effect done via a card instead of a number. **Implemented**, but the final review found two mismatches with the real cards: the official wild is **Wild Force Trade**, where you pick *any two players* (yourself optional) to trade hands, while this port's "Wild Swap Hands" always includes the player; and official **Swap 1** takes a random card from the target and gives them a card *you choose*, while this port gives a random one. | **EASY** |
| Team Attack (discard up to 3 cards from hand in one turn) | TMNT Team Attack (#124) | A themed wild that lets you dump multiple cards at once instead of one. | **EASY** |
| Teams! (2v2 with card-passing between partners, and a partner absorbs half the other's hand if they go out first) | Uno Teams! (#405) | A deeper team mode than the existing 2vs2 special rule — partners can hand cards to each other, and the team keeps playing (with pooled cards) after one partner empties their hand. | **MEDIUM** (builds on the existing 2vs2 rule, but pooled/absorbed hands after a partner "finishes" is new state) |
| Royal Revenge (King chooses wild colors and who wears the "Jester" penalty; role periodically changes) | Uno Royal Revenge (#159) | A rotating privileged-player role affecting who calls wild colors. | **MEDIUM** (new persistent per-game role state; the physical scepter/crown obviously doesn't port) |
| Colors Rule power-card ownership + steal | Uno Colors Rule! (#162) | Players hold an active "power," and other players can steal it from them. | **MEDIUM–HARD** (persistent ownable abilities plus a steal action is new territory) |
| Uno 52 (secondary poker-style hand built alongside your regular hand; reduced challenge penalty) | Uno 52 (#158) | A second, parallel "hand" that has to be tracked and updated, with its own legality rules (color/symbol match, no action cards). | **HARD** (effectively a second concurrent card-placement system) |

### A4. Double-sided deck (the "Flip" family)

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Flip: every card has a Light side and a harsher Dark side; a Flip card flips the whole deck (draw pile, discard pile, and every hand) to the other side simultaneously | Uno Flip! (#13, and its many themed reissues: #46, #143, #198, #258, #285, #309) | The single most-reused genuine mechanic in the whole survey. Dark side swaps in Draw 5, Skip Everyone, Wild Draw Color, etc. in place of the milder Light-side effects. | **MEDIUM–HARD**: logic is a clean "every card has two faces, track an active side" model, but it roughly doubles the card-art/data needed and touches rendering, AI evaluation, and legality across the whole engine — not a small patch, but self-contained and worth doing first among the "hard" tier given how often it recurs. |
| Flip Attack (Flip combined with a random draw-count "launcher" press) | Uno Flip Attack (#309) | Adds Attack's randomized-draw-count flavor on top of Flip. Depends on Flip existing first. | **MEDIUM** once Flip exists (the "launcher" part is just weighted RNG, see A5) |

### A5. Physical randomizer devices

All of these describe a physical gadget (a card launcher, a spinner, dice, a tipping scale, a slot
machine, an electronic light-up unit) whose *game-relevant effect* is "resolve a random outcome from a
small table." That part ports fine as RNG. The device itself obviously doesn't.

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Attack/Extreme/Blast/Mega Hit launcher (press a button, a random 0-N cards come out instead of a fixed draw) | Uno Attack (#9, #53, #54, #109, #339) | Replace "draw 2" with "draw a random amount, weighted, from 0 up to a cap." | **EASY** as a rule (the mechanical launcher itself is **NOT FEASIBLE (physical)**, but a "randomized draw count" toggle is a trivial RNG change) |
| Spin wheel (Spin card triggers a spin: discard-all-of-color, draw-until-X, swap hands, double effect, etc.) | Uno Spin (#15, #107, #137, #242, #274?, #381-382) | A small table of named outcomes selected randomly. Each edition has its own wheel (2005, Spin To Go, Hannah Montana, 2025, Adults Only), and who spins changed in 2025 from the next player to the player of the Spin card. All tables are in `docs/mechanics/03`. | **EASY–MEDIUM** (the outcome table itself is straightforward; needs a short spin animation for feel, but no new rule primitives) |
| Roboto / Tiki Twist / Eye Eye Spongebob (a device randomly picks a house rule or a target player) | Uno Roboto (#103), Uno Tiki Twist (#106), Uno Eye Eye Spongebob (#111) | Same shape as Spin: random selection from a small table, sometimes also picking *who* it applies to. | **EASY–MEDIUM** |
| Flash / Reflex / Showdown (real-time reaction races: hit a button first, or lose) | Uno Flash (#23), Uno Reflex (#108), Uno Showdown (#37, #105) | Turn order becomes "whoever reacts fastest," or two players race to slap a paddle. | **HARD, awkward fit** — this is a turn-based, coroutine-driven engine (see `src/game.lua`) playing against three AI seats; a real-time reflex mechanic requires either faking AI reaction times (which feels arbitrary) or turning part of the game into an actual timing minigame. Feasible in principle, low value here. |
| Tippo (balance-scale that can "tip" and force a draw) | Uno Tippo (#24) | Two discard piles on a physical tipping scale; overloading one side costs you. | **MEDIUM** (can model the "scale" as a simple counter with a tip threshold; no physical balance needed) |
| Triple Play trays (3 simultaneous discard piles, "overload" penalty) | Uno Triple Play (#16, #112) | Structural: the single discard pile becomes three, only the lit ones are playable, overloading costs 1-4 cards, and Wilds set no color. | **HARD** (touches the core single-discard-pile assumption throughout `src/uno.lua`) |
| Wild Jackpot Roller / pre-written custom rules on erasable cards | Uno Wild Jackpot (#27), Uno Happy Birthday (#306), Uno House Rules! (#29, #368), NDJOLIJEAN (#346), customizable-wild ideas (#498-499, #503) | Players write a house rule on a blank card pre-game; when it's drawn/played, that rule applies. | **MEDIUM to implement the mechanism** (a free-text "custom card" with a player-entered label is easy); **the rule's actual effect is unenforceable by software** unless it's picked from a fixed menu of pre-coded effects, in which case this just becomes "let the player assemble their own action card from existing primitives" — a nice generic feature once several EASY mechanics above exist as building blocks. |
| Uno Rush / online timed play (see opponents' hands, time-limited turns); UNO Master's turn timer | Uno Rush (#366); UNO Master (#400, 1997 Spear's Games: play or draw within 8/6/4 s or draw 4) | A visible-hands, timer-pressured mode. | **MEDIUM** (mostly a UI/AI-difficulty question; showing opponents' hands is trivial, timing pressure needs a turn timer) |

### A6. Alternate deck compositions

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| All Wild (every card in the deck is some Wild/action type; no color/number matching at all) | Uno All Wild (#28), Pocket All Wild (#284) | Fundamentally changes what "legal card" means. | **EASY–MEDIUM** (a deck-composition setting, plus making the legality check permissive for this mode) |
| Reduced/"Pocket" deck (numbers 1-9 only, draw-1 instead of draw-2/4; 52 cards per one rules site, 56 per Casio's 2024 promo page) | Uno Pocket lines (#51-52, #340, #399) | A smaller, faster deck. Deal 5, play to 250. "Pocket" is a promo brand label, so composition may vary by sponsor. | **EASY** (a deck-size/content variant) |
| Junior/Choo Choo/Mein Erstes Uno/My First UNO/UNO Express (kids' and short-game decks: match by color, number or animal; a curated subset by difficulty tier; or a 56-card deck dealt 5 to 250) | Mein Erstes Uno (#350), Uno Junior Move! (#362), Uno Choo Choo (#391); My First UNO and UNO Express in the Additions table | Selectable difficulty tiers, from "match only" up to full rules. Junior is 56 cards with three levels; Choo Choo is 28 cards matched by color or animal. | **EASY** (this is just exposing the existing rule toggles as a friendlier tiered preset) |

### A7. Character / power-card systems

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Ultimate Marvel / Ultimate DC (each player secretly picks a character with a personal mini-deck and a printed passive power that triggers on specific conditions — e.g. "when you play a danger-symbol card, everyone else burns a card"; two win conditions: empty your hand, or be the last player with cards left in your character deck) | Uno Ultimate Marvel (#56-57, #59-71, #395), Uno Ultimate DC (#58, #72-73) | Confirmed via Mattel/GameRules/GeekyHobbies. A genuinely different meta-layer: asymmetric player powers plus a second, per-character resource. | **HARD** — the *framework* (give each player an optional passive ability that triggers on a condition) is a reasonable, self-contained system to build; but the survey found 18+ distinct named characters, each with bespoke rules text that would need individually implementing and balancing. Recommend building the framework and shipping a handful of hand-picked powers rather than the full roster. |
| Elite NFL "Elite Icon" (playing a marked base card unlocks a drafted NFL Player Card's special power) | Uno Elite NFL Core/Alt Jerseys Edition (#408-409, #467-474) | A 3-card Lineup drawn from an 8-card personal Player Deck; playing an Elite-icon card of a lineup card's color may fire that card once (it's discarded and your turn ends). Basic actions live on the Player Cards, not in the main deck. Wild Foil counts as all 4 colors; other rarity tiers are cosmetic. | **HARD**, same reasoning as Ultimate Marvel — build the generic "unlockable ability" framework, don't chase all 56+ player cards. |
| Fandom NFL team rule cards | Uno Fandom NFL line (#218-224, #440-466) | **Correction:** each team deck has its *own* named rule card (Cowboys Hail Mary, Browns Dawg Pound, Patriots Lead Block, Bears Super Bowl Shuffle, Jets Broadway Beatdown...), not one shared mechanic. Most map onto A14 primitives (forced draw, draw-until, block, hand redeal); a few are physical races. Full list in `docs/mechanics/08`. | **EASY** per card once the A14 primitives exist |
| Danger/Enemy cards with an ongoing penalty until "defeated" | Ultimate Thanos Promo Card (#395) | A card that imposes a standing restriction on whoever drew it until a condition is met. | **MEDIUM** (needs a "standing effect on a player" concept, otherwise absent from the engine) |

### A8. Dares, truths, and other real-world prompts

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Dare! (choose: perform a dare, or draw as a penalty) | Uno Dare! (#12), Adults Only (#41), Dare advertisement pre-written dares (#496) | A binary choice card with a real-world stakes side. | **NOT FEASIBLE (unenforceable)** for the "perform the dare" branch, but the "or draw N" branch is trivially EASY — recommend implementing only the penalty-draw fallback, optionally showing dare flavor text for local human players to use informally. |
| Truth / Spin Adults Only (answer a personal question or take a penalty) | Uno Truth Adults Only (#380), Uno Spin Adults Only (#382) | Same shape as Dare. | Same as above. |
| Emoji face-holding, BTS dance, "Move!" jump/clap/dance, Mazda car-noises, Star Wars "toss cards like an exhaust port" | Uno Emoji (#359), Uno BTS (#11), Uno Junior Move! (#362), unreleased Mazda card (#495), Star Wars Technical Schematics flavor rule (#193) | Cards whose entire effect is "do a physical/social thing." | **NOT FEASIBLE (unenforceable)** — can be shown as flavor text for local play, has zero enforceable game-state effect. |
| WWE "Locked Up" 1v1 duel (both players reveal/play a number card, higher wins, loser draws both) | Uno WWE (#230-231) | A self-contained mini-duel between two specific players. | **EASY** (a simple "both reveal highest number" comparison) |
| Nascar "Drafting" (play up to 2 extra matching-color cards immediately after a wild) | Uno Nascar (#233) | A bonus-cards-in-one-turn effect. | **EASY** |
| X Games renamed action cards (Can-Can = Wild Draw 10, Nuclear Air = Wild Draw 5, Dirt-Dive = discard down to 5, Fakie = Wild + everyone trades hands, Drop a Hill = Wild + draw a new hand, Alley-Oop = Reverse + discard a color) | Uno X Games (#234, 1999) | A themed set of otherwise-standard-shaped new action cards. Confirmed via BoardGameGeek in the final review; colors and copy counts still unknown. | **EASY** |
| Liar's Uno (play a card face-down, bluff what it is; others can challenge; wrong claims cost the liar a card, wrong challenges cost the challenger) | Liar's Uno Trust No One (#475) | A genuine bluffing/challenge subsystem layered on discard-matching. | **MEDIUM–HARD** — logic is self-contained, but a believable AI bluffing/calling strategy is real work (the existing AI already handles one bluff-adjacent decision: challenging a Wild+4). |

### A9. Scoring and win-condition variants

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Cricket-style running score to 500, lowest wins, themed cards (Four/Six/Wicket/Over) replace standard actions | Uno Cricket (India) (#229) | **Unverified:** the final review found no source for this product or its card list. Keep only as an original idea. | **MEDIUM** (the existing per-game scoring already tracks hand values; this needs a different round-to-round scoring loop, not first-empty-hand-wins) |
| H2O Splash "first to win 3 hands" (corrected from "best of 3") | Uno H2O Splash (#47) | Match structure of short hands with no points; the first player to win 3 hands wins. | **EASY** (a match-length setting) |
| Ono 99 / Boom-O family (accumulating total toward 99, or a shared countdown timer; elimination via tokens/lives) | Ono 99 (#38), Boom-O (#55) | A running shared number that cards push up or down, with an elimination threshold. | **MEDIUM**, but arguably **OUT OF SCOPE (different game)** — these don't use discard-pile matching at all, they're closer to a different card game wearing UNO's name. |
| Golf (face-down 2x3 grid instead of a hand, minimize score) | Uno Golf (#379) | A different hand model entirely (a grid you flip into, not cards you hold and legally match). | **OUT OF SCOPE (different game)** |

### A10. Different games entirely (sharing the UNO brand, not the mechanic)

These don't belong on a "toggle a mechanic" menu for this UNO engine at all — they're separate games.
Listed for completeness since the source list included them: **Skip-Bo** (#17), **Dos** (#19, #31),
**Uno Quatro** (#20), **Phase 10** (#97), **Uno Dominos** (#93), **Uno Hearts** (#94), **Uno Wild
Twists** (#95), **Uno Bingo** (#98), **Uno Wild Tiles** (#99), **Uno Dice** (#100-101), **Luck Plus**
(#102), **Uno Rummy Up** (#160), **Blokus Shuffle: Uno Edition** (#48), **Uno Stacko** (#44, #365),
**Uno Madness** (#354), **Uno Sudoku** (#373), **Uno Free Fall** (#239-240, a falling-block puzzle
game), **Uno Dice Game: Roll and Write!** (#43). **Tag: OUT OF SCOPE (different game)** across the
board.

### A11. Accessibility editions

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Braille markings, ColorADD symbols, Billie Eilish pack's colorblind-friendly symbol markings | Uno Braille (#383), Uno ColorADD (#403), Add-On Packs! Billie Eilish (#478) | Standard rules; cards carry an additional tactile or symbolic marking so blind/low-vision or colorblind players can identify color/number without relying on printed color alone. | The literal tactile Braille embossing is **NOT FEASIBLE (physical)** on a screen, but the underlying *goal* — don't require distinguishing color by hue alone — maps directly onto a genuinely useful **EASY** digital feature: colorblind-safe icons/patterns per color and screen-reader-friendly card labels. Worth doing on its own merits, not just as a "version toggle." |

### A12. Digital-only precedents worth stealing

Several existing UNO video games/apps already did the "toggle a bunch of house rules" thing this
project wants to build, and their menus are good prior art. **Part E is a full deep-dive research pass**
on every digital-only title in this survey (exact card names/effects, not just "has some DLC cards") -
this section is just the headline takeaways:

* **Uno (Ubisoft, #115)** and its many DLC packs (#118-123, #386, #390) ship a combinable "house rules"
  toggle set, exactly the shape being planned here. Confirmed toggles: Stacking, 7-0, Jump-In (high
  confidence); Draw to Match, Force Play, No Bluffing (medium confidence, plausible but not verified
  against the actual options menu). See Part E2.
* **Uno Mobile (Mattel163, #374)** exposes 7 named house-rule toggles as independent options (Stack,
  Jump-in, 7-0, No Bluffing, Progressive, Draw to Match, Force Play - a near-exact match for the shape
  of this codebase's own settings menu), minus its real-money wagering mode, which is **out of scope**
  for this project regardless of mechanical simplicity. See Part E3.
* **Uno 2 Go / Uno Wonder (#375)** and **Uno & Friends (#376, #243)** show that a "career/tournament"
  progression mode and companion-power mechanics are popular digital-only additions. Uno & Friends'
  companions in particular are a genuine gameplay system (limited-use active powers, not cosmetic) worth
  studying as a template for an optional "character power" framework (see A7/C's Tier 3 roadmap note).
  See Part E3.
* **Uno Undercover (#235)**'s 13 Command Cards (15 defined, 2 cut; decompiled, see
  `docs/mechanics/09-uno-undercover.md`), **Uno CD-ROM (#236)**'s hand-size-hiding Spy Card, and
  **Uno Famicom's (#364)** Board Game mode are the most structurally novel finds of the whole digital
  research pass - none of them are just reskins with a bonus wild card. See Part E4.

### A13. Never-released ideas

See the dedicated table below (Part B) — these are one-off marketing/prototype cards, not full
products, and are mostly either trivial numeric variants or unenforceable novelty prompts.

### A14. Themed bonus cards from the reskin pass, grouped by engine primitive

The reskin verification pass (Part D) turned up ~150 named themed bonus cards, and a later pass checked
about 60 of them, plus the Fandom line, against Mattel's official instruction sheets (exact wording in
`docs/mechanics/07-themed-bonus-cards.md` and `08-fandom-line.md`). Individually each is a one-off, but
almost all of them reduce to a short list of reusable effect primitives. Building the primitive once
makes every card in its row nearly free (a name, an art asset, and a parameter set), so this grouping
matters more for implementation order than any single card. Card numbers point at Part D rows; cards
marked * are sheet-verified.

| Primitive | What the engine needs | Example cards (Part D #) | Already in codebase? | Tag |
|---|---|---|---|---|
| **Forced draw to a chosen/derived target** | Draw-N with a target selector: next, chosen, all opponents, fewest-cards player, or split among players | Power of Greyskull, all others draw 3 (#149*); Graduation, all others draw 1 (HSM3*); Badtz-Maru, fewest-cards player draws 4 (Hello Kitty & Friends*); Dr. Blowhole's Revenge, split 4 pile cards among players (#189*); Casting Call (#315*); Best of Both Worlds, all opponents draw 1 (#136*); Beetlejuice (#410) | Partly: draw-N + Bullseye's chosen target | EASY |
| **Draw until a condition** | "Draw until predicate(card)" loop with a safety cap; predicate over color, number set, or card tag | Sorting Hat (#177*); Joker's wild, chosen player until your color (#290*); Mutated Minion (FDV57*); The One Where You Draw, until a named Friend (#132*); Bat Signal, until a 1-4 Batman-family card (JBG35*); Dragon, until a Prince card (#387*); King Pig, round-robin deal that stops at the first opponent who gets the color (#156*); Thirst (#199); Greninja (#35); Oogie Boogie (#185) | Partly: Draw to Match is the same loop with predicate = "playable" | EASY once a predicate hook exists |
| **Reveal-or-draw check** | Per-player check "holds a card matching X?" then a penalty; needs a reveal animation/log | Infinity Gauntlet, players who HOLD the color draw 2 (#83*); Lotso, with backfire if everyone has it (#253*); Attack of the T. Rex, chained until someone misses (#437*); Where Everyone Fits In (#144*); Jellyfishing (#125*); Wild Cerebro (#214*); Kryptonite, play green/Wild or draw 3 (#91*); Wild Villain, play the matching weapon or draw 3 (#371*); Wild Triforce (#157*); Crossing the Streams (#75*); Fully Charged (Toy Story 5*); Bond's Precognition (#141) | No | EASY-MEDIUM |
| **Mass / self discard by filter** | Discard all/up-to-N cards matching a filter, from one or every hand, sometimes with a redraw | Owen's Raptor Squad (#80*); Voldemort (#175-176*); Olaf's Summertime (#172*); Super Charged (#195*); Best Friends, everyone may discard one card of a called number (#192*); Played With Too Much, others dump a color then redraw that many (#165*); Mega Minions Power (#301*); Robin's Rule, target discards all pink (#129*); Man's Best Friend (#187*); Water Drop (Planes F&R*); Wild Discard All (#248*) | No (No Mercy's Discard All is the same primitive, see A2) | EASY |
| **Give cards away** | Move N chosen cards from your hand to chosen opponents (distribution UI) | Web Slinger, up to 3 of one color (#134*); Power Ring, all yellows (#174*); Creeperific "Urrrhhh" (#262*); Justice, deal down to 1 (#166*); Screen Slayer, 2 of your cards to one player (#85*); Beachcomber, one of each color (#314*); 30th Anniversary card, all but one (#308*); Rule of Two (Fandom Star Wars Dark Side*) | No | MEDIUM (distribution UI) |
| **Hand swap / rotate / redeal** | swap(), cycle(), plus "pool N hands and redeal evenly" | Disney Parks Magic, everyone passes the whole hand left (GPV93*) = Wild Pass Hands; Cosmic Crush (#78*) = Refresh Hand; Duke Caboom, pool two hands and redeal (#87*); Crash-Up, **triggered when drawn** (#84*); Batman Bomb, pool every other hand and redeal (#415*); World Tour, chained hand-taking (#135*); Circle of Life, everyone passes ONE chosen card left (#82*); Muppet Mayhem (#150) | Mostly: swap/cycle/refreshHand exist; pool-and-redeal, one-card pass and draw-triggered cards are new | EASY |
| **Hand-size equalizer** | Set every hand toward a target size (largest hand, fixed N) | Power of Togetherness, draw up to the largest hand (#254*); Ohana, everyone to 4 (#329); Super Absorbency (#126) | No | EASY |
| **Take / trade specific cards** | View a hand, pick a card, optionally give one back; blind random pick | Tiny Diamond's Mix Tape, take one card from every hand (#86*); Called Shot (Fandom Star Wars Troopers*); Frankie's Hand (#397); Wild Blind (#89); Amulet (#481) | Partly: Swap 1 is the blind version | EASY-MEDIUM (a visible-hand picker UI) |
| **Pile search / pile take** | Search or flip the draw or discard pile for a card matching a filter, then play or keep it | Accele-race, flip a card then race to match it (#169*); Mr. Meeseeks (#128); Pic-a-nic (#133); Wild Wayfinder (#417); Shenron's Wish (#130) | No | EASY-MEDIUM |
| **Multi-skip / turn steal** | Skip a chosen or computed set of players; out-of-turn play | Web Swing, skip ONE player who reveals the named color (#208*); Hyperspeed, every play of a color skips the next player until it changes (#183*); Avatar State, out-of-turn play with all 4 colors (#336*); Arkham Asylum (#414); Hancock (#271); Defy Gravity (#482) | Partly: Skip + Bullseye; out-of-turn play needs the same plumbing as Jump-In | EASY (skips) / MEDIUM (out-of-turn) |
| **Block / cancel an incoming effect** | A response window when a penalty targets you; outcomes are block, reflect, or redirect | Block: Avengers Assemble (#83*), BFF Power (#316*), Flitterific (Disney Fairies*), Hero Card, keyed to Batman/Superman art (#167*). Reflect: Agent P (#287*), Super Star (#26*). Redirect: This is the Way (#81 note*). Cancel any action: Invisibility (#36*). Rockin' Blockin' (#310) | No (Stack's "respond with a +2" is the closest existing hook) | MEDIUM |
| **Standing effect until a trigger** | Per-player or global status that persists across turns until cleared | Save the Day, immunity until another Wild (#147*); Forces of Nature, only one color until your next turn (#88*); Black is My Happy Color, chained forced black-Wild play (#479*); Expo 2025 WORLD color lock (#428); Hyperspeed (#183*) | No | MEDIUM |
| **Duel / simultaneous reveal** | Two or more players commit a card secretly, compare, resolve | Kickin' Battle (#90*); Locked Up (#231*); Power of Friendship (#196*); Wild Narwhal, guess a hidden card's color (#161*); Remember Me, name the two buried discards or draw 3 (#251*) | No | MEDIUM (AI choice logic) |
| **Combo / doubler** | Play two cards together; the second's effect is doubled or copied | Fire Fist Ace (#271); UNO UNO no Mi (#272) | No (multi-card play is new) | MEDIUM |
| **Card tags (icon subsets)** | A per-card attribute layer: a themed icon on a fixed subset of cards, used by the predicates above | Bat Signal family on 1-4 (JBG35*); Harry on 2/6/9 (#176*); Triforce on 3/6/9 (#157*); Raptor cards (#80*); Love/Money on every card (#144*); Villain weapons (#371*); Mega Minions icon on actions (#301*); Hero art on actions (#167*); Friends characters (#132*); Gryffindor cards (#177*, which numbers is not printed on the sheet) | No | EASY data, but it's the enabler for several rows above, so it has to come first |
| **Pre-game rule picker** | Choose 1 of N preset rules at setup | Seinfeld Episode (#153) | Settings menu already does this | EASY |
| **Deck composition tweak** | Different copy counts or colors | Iconic Series, 8 Wilds instead of 4 and a different color set per decade (#1-5*) | Deck builder exists | EASY |
| **Physical randomizer** | A coin flip or drop resolved by RNG | Welcome to the Jam, drop the card: discard 2 or draw 2 (#191*); 50/50 coin (#6*) | n/a | EASY |
| **Unenforceable / honor system** | Prompt text only, maybe a self-report button | Rad Style, players wearing the color draw 2 (#131*); Dumb Fu (#184*); Shark Attack slap race (#148*, could be AI-timed); Ice the Kicker (#298*); Mickey Movie Madness trivia (#250*); Wild Don't Talk (#76); Roy Kent Grunt (#145); Sharing Squirrel (#297) | n/a | NOT FEASIBLE (unenforceable), except where a draw-penalty fallback exists |

Things this grouping makes visible for planning:
* **Six primitives cover most of the list**: targeted draw, draw-until, reveal-or-draw, filtered discard,
  hand swap/redeal, and hand-size equalize. They're all EASY and share one dependency, a small
  predicate/target-selector layer. Building that layer first turns dozens of themed cards into data.
* **Only two cards are already implemented under other names**: Refresh Hand behaves exactly like
  Cosmic Crush, and Wild Pass Hands like Disney Parks Magic. Two earlier matches were wrong: Remember
  Me is a memory quiz, and Circle of Life passes one card. Bullseye covers single-target redirects,
  but Web Swing is gated by a reveal.
* **Card tags are the hidden dependency.** A lot of draw-until, reveal-or-draw and block cards key off a
  themed icon or character printed on certain cards rather than color or number alone. Since this port
  uses generic art, the tag would need to be a visible overlay on the affected cards, which is a
  rendering decision for the planning step.
* **Response windows and standing effects** (block/reflect/redirect, immunity, color locks) are the two
  primitives most likely to collide with each other and with Stack and Jump-In, so they deserve the
  most care in the conflict analysis.
* **Draw-triggered cards** (Cars 3's Crash-Up, Minecraft's Creeper) act when *drawn*, not played, which
  needs an on-draw hook the engine doesn't have.

---

## Part B — Unreleased / never-produced ideas (#485–503)

These were revealed publicly (mostly as social-media marketing gimmicks from UNO's official accounts,
plus a few leaked prototype cards) but never sold as real products. Numbering follows the source list.

| # | Item | What it is | Tag |
|---|------|-----------|----------|
| 487 | Show 'Em No Mercy April Fools "Wild Draw 100" | Joke card: next player draws 100 (the whole deck, several times over). | EASY (trivial Draw-N) |
| 488 | Pizza 73 "Pick Up 73" | Forces the next player to draw 73. | EASY |
| 489 | Wild "Wash Hands" | Real-world action card, no game-state effect. | NOT FEASIBLE (unenforceable) |
| 490 | "I Would Draw 2 For You" | Redirect/absorb a penalty on another player's behalf. | EASY–MEDIUM |
| 491 | "Please Don't Ask What My Valentine's Day Plans Are" | Flavor-only reskinned Wild. | Trivial (cosmetic) |
| 492 | "You Make My Heart Skip A Beat" | Flavor-only reskinned Skip. | Trivial (cosmetic) |
| 493 | "You Make Me Go WILD" | Flavor-only reskinned Wild. | Trivial (cosmetic) |
| 494 | "Everyone Else Draws 4" | All-opponents Draw-4 (not just next player). | EASY |
| 495 | Mazda "Wild Card" (car noises until a red card) | Real-world roleplay effect gated on a real rule (color-based end condition). | NOT FEASIBLE (unenforceable) for the roleplay part |
| 496 | Dare! pre-written dares | Sample content for Uno Dare!, not a new mechanic. | See A8 |
| 497 | Cut command cards from Uno Undercover | **Resolved by decompiling the game** (`docs/mechanics/09-uno-undercover.md` section 3). "Command Card" is the shipped name. Two cut cards remain in the files: **Plunder** (remove any card from your hand and bank its points; art exists, popup disabled, code a stub) and **Personal Shield** (paired card sets N turns of bouncing draw penalties back; folded into Lucky Croc Tooth). Also cut: two-color first-draft art for the three combo cards, a 3-card Deck Customization loadout screen, "Pass" and "Amplified" penalty (stacking) modes, an Elimination game type, and Wild Vouchers. | EASY (Plunder, Shield) / see spec 09 |
| 498 | Customizable Wild "Thought Starters" | Sample prompts for a blank/write-your-own wild. | See A5 (Wild Jackpot Roller row) |
| 499 | Happy Birthday pre-written custom cards | Same customizable-wild idea, birthday-themed samples. | See A5 |
| 500 | "What Would Your Wild Card Do?" | Open-ended, player-invented effect by definition. | NOT FEASIBLE (unenforceable) as a fixed rule |
| 501 | "Make It Rain UNO!" | Flavor-only novelty wild. | Trivial (cosmetic) |
| 502 | Instagram "Rules of the Day" | An open-ended, ongoing marketing series (hundreds of one-off joke rules), not a stable ruleset. | N/A — not a discrete mechanic |
| 503 | Wild Jackpot customizable wild suggestions | Sample content for Wild Jackpot's Roller. | See A5 |

**Takeaway:** aside from a couple of trivial numeric variants (Draw 73/100, "everyone draws 4"), this
whole bucket is either one-off flavor text with no enforceable rule, or sample content for mechanics
already covered in Part A. The one reusable idea worth keeping: a free-text "custom wild card" that
lets a local player type a house rule as flavor text, with no engine-enforced effect — cheap to add,
purely cosmetic/organizational.

---

## Part C — Implementation roadmap

Ordered from cheapest to most expensive, folding in the tags from Part A. This is meant to seed a
follow-up planning conversation, not to be the final plan.

**Superseded for build order:** `docs/implementation-plan.md` is the actual phased plan, grounded in
the engine's current architecture, with the cross-version conflict rules and a compatibility table.
The tiers below are kept as the original survey-era estimate.

### Tier 0 — Already done
7-0, 2vs2, Stack (`src/uno.lua`).

### Tier 1 — Easy: small, independent card-effect additions
**Implemented** (as a first pass at the toggle plumbing itself): **Draw to match** (keep drawing until a
legal card turns up), **Wild +4 challenge** (an on/off toggle — off means it can never be challenged), and
**Bullseye targeting** (+2/Skip's target is chosen instead of automatic). These needed no new card art, so
they were used to validate the settings-page plumbing (`rulePages()` in `src/game.lua`) end to end; adding
another toggle is now a matter of one more descriptor entry plus (for Bullseye-style redirection) a small
resolver function, not new hardcoded layout/click-handling code. Jump-In was scoped for this batch too but
turned out to need real turn-order-interruption plumbing (out-of-turn play), not just a card-effect tweak —
deferred, see the note in Part A1.

**Also implemented, as the first new-card-art mechanic**: a full 4-card **Swap Pack** -
**Wild Swap Hands** (swap hands with a chosen player, or the sole opponent automatically in a 2-player
game) and **Wild Pass Hands** (everyone passes hands to the next player) reuse the `swap()`/`cycle()`
engine primitives 7-0 already needed; **Swap 1** (take a random card from a chosen player's hand and swap
it for a random card of yours) and **Refresh Hand** (discard your whole hand under the draw pile, then draw
the same number of new cards) needed two new engine primitives (`Uno:swapOneCard()`/`Uno:refreshHand()`)
and two new replay opcodes (`S1`/`RF`), since - unlike everything added so far - they involve randomness
that has to be logged, not just re-derived. Swap 1 reuses the same target-picker UI as 7-0/Wild Swap Hands
(a `sSwapOneCard` flag in `src/game.lua` tells the shared resolver which kind of swap to do), rather than
adding a whole separate status. Wild Swap/Pass Hands are wild-type (4 copies each, id 39+content, since all
13 per-color content slots were taken - see `src/defs.lua`); Swap 1/Refresh Hand are ordinary colored cards
instead (one copy per color, 4 total each, matching the real Add-On Pack's density), which needed a 3rd id
scheme tacked on after the wild-type ids (`src/card.lua`'s `Card.new()` has the exact formula) since they
don't fit either of the first two. All of it is gated behind the single `swapPackRule` toggle, defaulting
off, which changes deck composition (not just legality) so it only takes effect on the next new game.

Still open in this tier: Jump-In (from Deluxe House Rules) · Reverse Pack (reverse+draw, reverse+skip,
reflect-penalty) · Stack Pack (stack 3, random-N via flipped card) · novelty fixed-N draws
(73/100/all-opponents-4) · Team Attack multi-discard · WWE "Locked Up" duel (resolution unverified) ·
Nascar Drafting bonus plays (unverified) · X Games renamed action set · All Wild deck mode · Pocket reduced-deck mode ·
Junior/tiered-difficulty presets · Fandom NFL-style "one themed bonus wild" toggle (Touchdown text
unverified) · H2O Splash first-to-3-hands match structure · the A14 effect primitives ·
colorblind-safe card icons and screen-reader labels (the real, useful half of the accessibility editions).

Note on new card art: this codebase draws every card face from a pre-rendered PNG (`resource/front_*.png`,
sourced from a public-domain-style Wikipedia SVG per the README). **Resolved for new mechanics**: rather
than a runtime placeholder-card renderer, `tools/gen_cards.py` generates new cards as SVGs (matching the
existing cards' visual language: white rounded card, dark outline, an inset colored/black rect, a big white
rotated ellipse, a colored icon, small corner icons) and rasterizes them via `rsvg-convert` at build time
into the same `front_*.png`/`dark_*.png` files the engine already expects - no runtime rendering changes
needed. New mechanics get their own original icons rather than reproductions of Mattel's actual card
designs, both because the source vector art isn't available to match pixel-for-pixel and to avoid
reproducing their proprietary designs. Reverse Pack, X Games, and eventually Flip's dark side can follow
the same recipe.

*Recommended starting point*, since these compose cleanly with the existing rule-toggle system and
don't require new rendering or AI work beyond what 7-0/Stack already needed.

### Tier 2 — Medium: new state, new UI, or a new player choice
Attack/Extreme-style randomized draw count · Spin wheel (small outcome table + short animation) ·
Roboto/Tiki Twist-style random rule/target picker · Show 'Em No Mercy's individual pieces (Mercy Rule,
Color Roulette, Discard All, Skip Everyone — each on its own toggle) · UNO Blast's accumulate-and-dump
pile · Power Grab towers · Royal Revenge King/Jester role · Tippo's tipping-scale counter · Danger/Enemy
standing-effect cards · a running-score match mode · a generic "assemble your own action
card" builder (covers the Wild Jackpot Roller / Happy Birthday / customizable-wild family in one
feature instead of five).

**To-do, explicitly deferred (not in this survey's original ~500, a house-rule idea raised while adding
2-player support)**: a "shrinking table" toggle where a game continues until only the human player is out
of cards — each CPU seat that empties its hand leaves the table instead of ending the game, so e.g. a
4-player game can play down through 3-player and 2-player configurations before it's over. This needs
mid-game seat deactivation (distinct from `setPlayers()`, which only sets the seat count for a *new*
game), re-deriving `getNext()`/`getOppo()`/`getPrev()` and turn order around a shrinking active-seat set
instead of the current fixed 2/3/4-player patterns, and reworking win/scoring (there's no longer a single
winner the moment one hand empties). Sequenced after the current Tier 1 toggles are solid.

### Tier 3 — Hard: structural changes
Flip! double-sided deck (touches card data, legality, AI evaluation, and rendering throughout, but is
the single most-requested mechanic in the whole survey by reuse count — do this before the other Hard
items) · Teams! pooled-hand 2v2 · Colors Rule power-ownership/steal · Triple Play's multi-pile discard
model · Uno 52's parallel poker-hand · Liar's Uno bluffing/challenge subsystem (needs new AI logic, not
just new rules) · a generic "character power" framework for the Ultimate Marvel/DC and Elite NFL
families (ship the framework plus a handful of hand-picked powers, not all 18+/56+ named characters).

### Not recommended / out of scope
* **Physical-device mechanics** (Attack's literal launcher, Spin's literal wheel, Tippo's literal
  scale, Flash/Reflex/Showdown's light-up reaction hardware, Uno Stacko's Jenga tower, dice towers) —
  their *rule effects* are absorbed into Tier 1/2 above via RNG; the hardware itself isn't a thing to
  build.
* **Real-time reflex mechanics** (Flash, Reflex, Showdown, Blitzo) — awkward fit for a turn-based,
  coroutine-driven engine playing against AI opponents; low value for the effort.
* **Unenforceable real-world-action cards** (Dare!, Truth, Emoji faces, BTS dance, "Move!",
  car-noises) — can show flavor text for local human play, but have no real digital implementation;
  recommend implementing only their draw-penalty fallback where one exists.
* **Different games sharing the brand** (Skip-Bo, Phase 10, Dos, Quatro, Dominos, Hearts, Rummy Up,
  Bingo, Wild Tiles, Sudoku, Blokus Shuffle, Madness, Free Fall, Golf, Ono 99/Boom-O) — not UNO's
  discard-matching mechanic; a separate project, not a menu toggle here.
* **Anything requiring more than 4 seats** (Uno Party!'s 6-16 player design) — blocked by this game's
  fixed YOU/WEST/NORTH/EAST architecture; would need a real player-count refactor first.
* **Uno Mobile's wagering/payout-multiplier mode** — deliberately excluded regardless of mechanical
  simplicity (real-money gambling mechanics aren't appropriate for this project).
* **Literal Braille embossing / webcam opponent view** — no physical/hardware equivalent on a screen;
  see A11 for the accessibility features that *are* worth keeping.

---

## Part D — Full reference table (all ~500 titles)

Every numbered title from the source list, tagged by category:
**MECHANIC** (genuinely different rule(s), cataloged in Part A), **RESKIN** (cosmetic only, standard
rules), **DIFFERENT-GAME** (not UNO's mechanic at all), **DIGITAL-ONLY** (video game/app feature),
**ACCESSIBILITY**, or **UNKNOWN** (could not verify). See the Methodology note above about confidence
on RESKIN entries in bulk.

### #1–84

| # | Title | Category | Mechanic Notes |
|---|-------|----------|-----------------|
| 1 | Uno 50th Anniversary Icon Series 1971 | RESKIN | 2021 Iconic Series (1 of 5 decade decks). Standard rules, but 8 Wild cards instead of 4 (112 cards) - a series-wide trait, not unique to this deck. HIGH. |
| 2 | Uno 50th Anniversary Icon Series 1980 | RESKIN | Same Iconic Series as #1: standard rules, 8 Wild cards instead of 4 (112 cards), 1980s retro art. HIGH. |
| 3 | Uno 50th Anniversary Icon Series 1990 | RESKIN | Same Iconic Series as #1: standard rules, 8 Wild cards instead of 4 (112 cards), 1990s retro art. HIGH. |
| 4 | Uno 50th Anniversary Icon Series 2000 | RESKIN | Same Iconic Series as #1: standard rules, 8 Wild cards instead of 4 (112 cards), 2000s retro art. HIGH. |
| 5 | Uno 50th Anniversary Icon Series 2010 | RESKIN | Same Iconic Series as #1: standard rules, 8 Wild cards instead of 4 (112 cards), 2010s retro art. HIGH. |
| 6 | Uno 50th Anniversary Premium Set | MECHANIC | HBF05: 4 Wild 50/50 + a coin. Choose 2 players (you may be one; you must be in a 2-player game), UNO side = heads; the loser draws 4, then you name the color. HIGH (sheet). See A2. |
| 7 | Nonpartisan Uno | MECHANIC (novelty) | Orange/purple replace red/blue. "Veto" card: if anyone talks politics, any player may play it on them to skip their next turn. Triggered by real-world talk, no defined card-play timing, so it belongs with the honor-system cards (A8). HIGH (effect), LOW (timing). |
| 8 | Base Uno (1980) | RESKIN | Historical baseline release; reference point, not a variant. When Wild Draw Four was introduced is unverified: the only dated claim (1983, with the challenge rule) comes from a single Baidu entry (LOW), while Mattel's 1970s retro reissue and 1970s rule text point to WD4 already being in the deck in the 1970s (MED). |
| 9 | Uno Attack | MECHANIC | Classic UNO Attack (41943, 1999): 112 cards, 72 numbers 1-9; Hit 2 (press twice), Reverse, Skip, Discard All (1/color), Trade Hands (1/color, must trade), Wild All Hit (everyone else presses once), Wild Hit-Fire (press until it fires). Pressing the launcher ends your turn. The 2010 T8219 set swaps Trade Hands and the two special wilds for more Discard All and 4 Wild Attack-Attack. HIGH (sheets). Spec: docs/mechanics/01. See A5. |
| 10 | Uno Left Hand | RESKIN | Resolved: real Mattel product (HPP32/GKD73, 2020, International Left-Handers Day). Cards print their value mirrored/on the reverse side so it's visible when fanned in a LEFT hand (disadvantage for right-handers) - otherwise standard rules. HIGH. |
| 11 | Uno BTS | MECHANIC (minor) | "Dancing Wild" — dance or draw 3. See A8. |
| 12 | Uno Dare! | MECHANIC | Dare/Wild Dare: perform a dare or draw. See A8. |
| 13 | Uno Flip! | MECHANIC | GDR44/GDG37: 112 double-sided cards, numbers 1-9 only (no 0s) on both sides. Light: Draw One, Reverse, Skip, Flip, Wild, Wild Draw Two. Dark: Draw Five, Reverse, Skip Everyone, Flip, Wild, Wild Draw Color (draw until the named color). Flipping inverts the discard pile, then the draw pile, then every hand. Challenges: WD2 2/4, WD Color until-color/+2. Score by the face-up side at round end, to 500. HIGH (sheets). Spec: docs/mechanics/02. See A4. |
| 14 | Uno Artiste Jean-Michel Basquiat | RESKIN | Collector art deck; 4 decorative-only "Artiste Extra" cards (recreate a larger artwork when arranged), standard play - confirmed. HIGH. |
| 15 | Uno Spin (2005) | MECHANIC | J3719: 20 Spin cards (numbers 1-5) replace normal ones; the NEXT player spins instead of taking their turn. 9-space wheel: UNO Spin race, Discard Color (from your own hand), Discard Number, Draw Red, Draw Blue, Trade Hands (pass left), Show Hand, War, Almost UNO (discard all but 2). HIGH (sheet). Spec: docs/mechanics/03. See A5. |
| 16 | Uno Triple Play | MECHANIC | GXV87: three discard piles, of which the device lights the playable ones. Deck has no Draw Two or WD4 (Discard Two of the Same Color, Wild Clear, Wild Give Away instead); Wilds set no color. Overloading a pile costs 1-4 cards and does not clear it. HIGH (sheet). See A5. |
| 17 | Skip-Bo | DIFFERENT-GAME | Sequencing game, no color/number discard matching. See A10. |
| 18 | Uno Blitzo | DIFFERENT-GAME | Electronic reaction/button-pad game, no card play. See A10. |
| 19 | Dos (First Edition) | DIFFERENT-GAME | Two piles, sum-matching instead of equality. See A10. |
| 20 | Uno Quatro | DIFFERENT-GAME | Connect-Four fused with UNO tiles. See A10. |
| 21 | Uno Mariokart | MECHANIC (minor) | GWM70: 112 cards with 8 Wild Item Box and no plain Wilds. A Wild Item Box flips the top draw-pile card face-up onto the discard pile (it becomes the card to match, its own action ignored) and applies that card's item: Mushroom = play again; Banana Peel = previous player draws 2; Green Shell = chosen opponent draws 1; Lightning = all opponents draw 1, then you play again; Bob-omb = you draw 2 and pick the color. HIGH (sheet); which color carries which item is MED. |
| 22 | Uno The Office | MECHANIC (minor) | GVH29: 4 "Kevin's Famous Chili" Wilds. Everyone, including the player, drops their cards on the table; the last to do so draws 2; then the player names the color. Pink replaces red. HIGH (sheet). |
| 23 | Uno Flash | MECHANIC | M1002: the unit picks the next player at random (can repeat), with an optional 6/4-second turn timer (time out = draw 2). Deck has 8 SLAP cards (last to slap draws 2) and no Reverse; Draw Two / WD4 hit the next unit-picked player. HIGH (sheet). See A5. |
| 24 | Uno Tippo | MECHANIC | R2827, 112 cards incl. 5 Stop cards per color and 4 Tilt. Two trays on a scale: a tray topped by a Stop card accepts only Stop cards (or a Wild) unless the other tray also shows a Stop. Tilt: from the next player on, each adds a pile card to that tray until it tips; whoever tipped draws 2; spilled cards are set aside. HIGH (sheet). See A5. |
| 25 | Uno Flex! | MECHANIC | HMY99: 8 Power Cards (one per player, green = may flex). A Flex card can be played as its flex side (second color, or a stronger action) once, which turns your Power Card red; the next player still matches the printed color. Numbers 1-8; some carry a flip icon that toggles your Power Card. Wild All Flip toggles everyone's. HIGH (sheet); per-card counts unconfirmed. |
| 26 | Uno Super Mario | MECHANIC (minor) | HJC89: 2 Super Star Wilds (play one when a Draw Two/WD4 targets you and its player draws instead; name the color) + 2 Customizable Wilds. HIGH (sheet). Super Star vs a stack or another Super Star is unstated. |
| 27 | Uno Wild Jackpot | MECHANIC | Correction: no shared growing pile (that is UNO Blast, #110). DNG26: 16 Jackpot + 2 Wild Jackpot cards; playing one pulls a 6-symbol "Wild Roller" lever. Found symbols: choose any player (even yourself) to perform a dispensed player-written rule card, player on your right/left performs one, everyone performs one, discard up to one card of each color, Draw 4. 8 erasable rule cards live in the dispenser, not the deck. MED (mechanism), LOW (full symbol list). See A5. |
| 28 | Uno All Wild | MECHANIC | HHL33: 112 cards, every one a Wild of some kind (Wild, Reverse, Skip, Skip Two, Draw Two, Draw Four, Targeted Draw Two, Forced Swap), so every play is legal. A starting action card is ignored. Scoring Wild 20, actions 50, to 500. HIGH (sheet); per-card counts unconfirmed. See A6. |
| 29 | Uno House Rules! | MECHANIC | Player-authored dynamic rules per number. See A1/A5. |
| 30 | Uno Party! | MECHANIC | Two SKUs: HMY49 (224 cards, 6-16 players) and JJV58 (168 cards, 6-14). Point Taken (everyone points; draw 1 per finger, max 5), Drawn Together (link two other players so one's draws are copied to the other; one link at a time, ends when a Point Taken is played), Pile Up (a same-color mini-pile circles the table, actions inert; first who can't add takes it all), Speed Play (out-of-turn play of an identical NUMBER card only; misplay = take back + draw 1). No team play. HIGH (sheets). ARCHITECTURAL (player count). |
| 31 | Dos Second Edition | DIFFERENT-GAME | Revised two-pile addition mechanic. See A10. |
| 32 | Uno Sonic the Hedgehog | MECHANIC (minor) | Unverified: no Mattel sheet. The listed code HGJ78 is actually UNO Dragon Ball Z, and HJG14 has no product. "Victory Lap, all others draw 1" comes from retailer copy only. MED. |
| 33 | Uno Minecraft | MECHANIC (minor) | FPD61: 4 Creeper Wilds. When you DRAW one from the pile, show it and draw 3 more (a second Creeper among them is a plain Wild). HIGH (sheet); some retailer copy saying others draw is wrong. |
| 34 | Uno Pokémon | MECHANIC (minor) | Unverified: no source found for a "Trainer" full-hand-swap card in 3 searches. The only confirmed Mattel Pokémon special cards are the Japanese Snorlax/Greninja pair (#35). LOW. |
| 35 | Uno Pokémon (Asia) | MECHANIC (minor) | Mattel Japan GNH17 (Feb 2020): Snorlax Wild, next player draws 3 then discards all their cards of the declared color; Greninja Wild, next player draws until the declared color appears, then the Greninja player declares the color again. MED-HIGH (official JP page via GAME Watch). Check the Snorlax translation before implementing; dumping a color helps the victim. |
| 36 | Uno Harry Potter and the Sorcerer's Stone | MECHANIC (minor) | Mattel 42797 (~2000), 110 cards: 8 Draw Three, 1 Howler (the chosen player shouts out their whole hand, you name the color, no lost turn), 1 Invisibility (cancels any action played on you, including Howler, or plays as a plain Wild). Same product as #388. HIGH (sheet). |
| 37 | Uno Showdown | MECHANIC | Physical reflex paddle duel + 500-pt scoring. See A5. |
| 38 | Ono 99 | DIFFERENT-GAME | Running-total-to-99 elimination game. See A9. |
| 39 | Uno Splash | RESKIN | Waterproof plastic cards, standard rules - confirmed, distinct from the mechanically-different Uno H2O Splash (#40 family). HIGH. |
| 40 | Uno H2O | MECHANIC (minor) | H3263, 108 cards: Wild Downpour Draw 1 / Draw 2 make all OTHER players draw 1 or 2, then the player names the color. The first to win 3 hands wins. HIGH (sheet). |
| 41 | Uno Dare Adults Only | MECHANIC | Escalating dare tiers via die roll. See A8. |
| 42 | Uno Monster High | MECHANIC (minor) | Same product as #262 (T8233, (c)2011): its only special card is Creeperific "Urrrhhh"; the second wild described earlier doesn't exist. HIGH (sheet). Merge with #262. |
| 43 | Uno Dice Game: Roll and Write! | DIFFERENT-GAME | Dice + scoresheet chain game. See A10. |
| 44 | Uno Stacko | DIFFERENT-GAME | Jenga-style block tower. See A10. |
| 45 | Uno Show 'Em No Mercy | MECHANIC | HWV18, 168 cards. Stack any Draw card of equal or higher value than the last one (color irrelevant); draw until you can play, then you must play it; 25+ cards knocks you out (your hand is set aside until the next reshuffle); win by going out or by being the last player left. 7 = swap with a chosen player, 0 = everyone passes. Color Roulette: the NEXT player names the color, then reveals cards until it appears. Scoring: color actions 20, wild actions 50, 250 per knockout, 1000 to win. HIGH (sheet); per-card counts still unconfirmed. Spec: docs/mechanics/01. See A2. |
| 46 | Uno Flip (2009) | MECHANIC | Likely mislabel/duplicate of #13 (Flip debuted 2019). |
| 47 | Uno H2O Splash | MECHANIC | J3721: Whirlpool device triggered by special cards or any 0 or 2; 8 commands (Draw H2O until blue/2/0/Wild, Wave Right/Left, Wipeout, Draw 3, Draw 2, Give 1, Discard 2). First to win 3 hands wins (also true of base H2O). HIGH (sheet). See A5/A9. |
| 48 | Blokus Shuffle: Uno Edition | DIFFERENT-GAME | Blokus tile-placement with an UNO card layer. See A10. |
| 49 | Uno Milk Chocolate Edition | RESKIN | Cards printed on chocolate wrappers; no rule change found - novelty confectionery, not a functioning ruleset variant. MED. |
| 50 | Uno UpUp DownDown | RESKIN | WWE collab. Correction: "Wild Challenge" is a 3rd, additional Wild-type card (forces opponent to draw extra cards) alongside the untouched standard Wild and Wild Draw Four - not a retheme of either. MED. |
| 51 | Uno Pocket Pizza Pizza | MECHANIC (minor) | Reduced 52-card "Pocket" deck + exclusive Wild. See A6. |
| 52 | Uno Pocket Pizza 73 | MECHANIC (minor) | Same Pocket format, different exclusive Wilds. |
| 53 | Uno Extreme | MECHANIC | Same mechanic as Attack (#9), different regional name. |
| 54 | Uno Attack (2020) | MECHANIC | 2020 Attack (GXY81/GNL02): adds 4 Hit 1 cards; 4 Reverse, 8 Skip, 8 Discard All, 4 Hit 1, 8 Hit 2, 4 Wild, 4 Wild Attack-Attack; Mega Hit stacking rule; who presses on Attack-Attack differs between editions. HIGH (sheets). |
| 55 | Boom-O | DIFFERENT-GAME | Countdown-timer elimination game. See A9. |
| 56 | Uno Ultimate Marvel | MECHANIC | HHV87 (1st Ed): 4 characters (Iron Man, Thor, Captain Marvel, Black Panther), each with a 56-card Character Deck (power card + 47 cards + 4 Enemies + 4 Events) as their personal draw pile. Win by going out or by being the last with cards left in your deck. Official turn order: play, on-play power, defeat an Enemy, then the Danger flip (by the player of the Danger-icon card). Keywords: Draw (lose turn), Add (don't), Burn (deck to Burn Pile), Recover (Burn Pile to the bottom of your deck). HIGH (sheet). Spec: docs/mechanics/04. See A7. |
| 57 | Uno Ultimate Marvel Second Edition | MECHANIC | Same system, refreshed roster. |
| 58 | Uno Ultimate DC | MECHANIC | HRF37: same system with Superman (Impervious), Wonder Woman (Amazonian Fury), Green Lantern (Construct Creation) and Aquaman (Aquatic Aftershock, a color-change trap; not Location-based), plus Item and Location cards. HIGH (sheet). |
| 59 | Uno Ultimate Marvel Ms. Marvel Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
| 60 | Uno Ultimate Marvel Spider-Man Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
| 61 | Uno Ultimate Marvel Loki Expansion Pack | MECHANIC | Confirmed playable character (HPT40), separate from Loki the Enemy in Thor's core deck. Wilds include Simple Illusion and Your Savior is Here; exact power text isn't on the add-on sheet. HIGH (playable), LOW (power). |
| 62 | Uno Ultimate Marvel Ant-Man Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
| 63 | Uno Ultimate Marvel Shang-Chi Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
| 64 | Uno Ultimate Marvel Dr. Strange Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
| 65 | Uno Ultimate Marvel Scarlet Witch Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
| 66 | Uno Ultimate Marvel She-Hulk Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
| 67 | Uno Ultimate Marvel Miles Morales Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
| 68 | Uno Ultimate Marvel Spider-Gwen Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
| 69 | Uno Ultimate Marvel Spider-Man 2099 and Venom 2-Pack | MECHANIC | Adds two characters to the Ultimate Marvel system. |
| 70 | Uno Ultimate Marvel Rocket and Groot Expansion Pack | MECHANIC | Adds two characters to the Ultimate Marvel system. |
| 71 | Uno Ultimate Marvel Mighty Thor Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
| 72 | Uno Ultimate DC Batman Expansion Pack | MECHANIC | Adds one character to the Ultimate DC system. |
| 73 | Uno Ultimate DC Harley Quinn Expansion Pack | MECHANIC | Adds one character to the Ultimate DC system. |
| 74 | Uno Happy Feet | RESKIN | Correction: has 1 unique "MAMBO!" bonus card/rule, exact effect undocumented online. MED. |
| 75 | Uno Ghostbusters | RESKIN | GDJ78 (2019): Wild Crossing The Streams, every player including you draws 1, then you play a card of your choice and every other player must play a card of its color or draw 2. HIGH (sheet). The 2016 deck (DTD32) has only 4 customizable wilds. |
| 76 | Uno Encanto | RESKIN | Correction: 4 unique "Wild Don't Talk" cards - silences a chosen opponent (3-card draw penalty for talking) until someone calls UNO; also a normal Wild. HIGH. |
| 77 | Uno Planes | RESKIN | Correction: unique "Wild Altimeter Alert" card - name a color, everyone plays one card of that color face-down, reveal simultaneously, highest number wins. MED-HIGH. |
| 78 | Uno Captain Marvel | RESKIN | GDJ79: Wild Cosmic Crush, put your whole hand on the bottom of the draw pile in any order, then draw the same number. HIGH (sheet). Matches this port's Refresh Hand exactly. |
| 79 | Uno Cars 2 | RESKIN | Correction: unique "Wild Special Agent Mater" card - look at every other player's hand before choosing the color. HIGH. |
| 80 | Uno Jurassic World | RESKIN | FLK66: Owen's Wild Raptor Squad, discard every Raptor card (marked with a Raptor and paw print) from your hand. HIGH (sheet). |
| 81 | Uno Star Wars | RESKIN | Wild The Force (classic Star Wars deck): unverified, no sheet. The Mandalorian deck (HJR23) has Wild This is the Way: when a Draw 2 or WD4 is played on you, block it and choose any other player to draw instead. HIGH (sheet, Mandalorian). |
| 82 | Uno The Lion King | RESKIN | Correction (GDJ81): Wild Circle of Life, every player chooses ONE card and passes it to the left (not whole hands). HIGH (sheet). |
| 83 | Uno Avengers | RESKIN | Two decks. 2014 (CJM73): Avengers Assemble blocks a Draw 2/4 played on you. 2018 (GDJ80): Wild Infinity Gauntlet, lay a card of a color from your hand on it; every player who HOLDS that color draws 2. HIGH (sheets). |
| 84 | Uno Cars 3 | RESKIN | Correction (FDJ15): Crash-Up Rule card triggers when DRAWN from the pile: combine your hand with the next player's, shuffle, deal back between you starting with them, then it goes to the discard pile as a Wild. No "Smokey" card. HIGH (sheet). |

### #85–168

| # | Title | Category | Mechanic Notes |
|---|-------|----------|-----------------|
| 85 | Uno Incredibles 2 | RESKIN | Correction (FNC49): Wild Screen Slayer, everyone else closes their eyes and you put two of YOUR cards into another player's hand. HIGH (sheet). |
| 86 | Uno Trolls World Tour | RESKIN | GRC65: Wild Tiny Diamond's Mix Tape, the next player draws one card from every other player's hand. HIGH (sheet). |
| 87 | Uno Toy Story 4 | RESKIN | GDJ88: Wild Duke Caboom, take two players' hands, mix them, and deal them back equally (you choose who gets an odd card). HIGH (sheet). |
| 88 | Uno Frozen 2 | RESKIN | Correction (GKD76): Wild Forces of Nature, choose a color; only that color may be played (even over matching numbers or wilds) until your next turn. HIGH (sheet). |
| 89 | Uno Shrek 2 | RESKIN | Correction: unique "Wild Blind" card - a chosen player closes their eyes and blindly picks one card from each other player's hand, then a color is chosen. HIGH. |
| 90 | Uno Kung Fu Panda | RESKIN | M1003: Kickin' Battle, challenge any player; both reveal a card at once; the lower (symbols count 0) loses, ties battle again; the loser takes all battle cards plus 2. HIGH (sheet). |
| 91 | Uno Superman Returns | RESKIN | Correction (J4299): one bonus card, Kryptonite x4 (not two). Each other player in turn must play a green card or a Wild, or draw 3. Playable any time. HIGH (sheet). |
| 92 | Uno Pirates of the Caribbean | RESKIN | AMBIGUOUS - at least 2 distinct releases exist. "At World's End" (~2007, Disney Parks skull tin) has a "Black Pearl" card, exact effect unconfirmed. "Dead Men Tell No Tales" (~2017) has a wild that forces all other players to draw until they get the chosen color. MED existence, LOW wording. |
| 93 | Uno Dominos | DIFFERENT-GAME | UNO effects layered on domino tile-matching. See A10. |
| 94 | Uno Hearts | DIFFERENT-GAME | Trick-taking Hearts with UNO wilds mixed in. See A10. |
| 95 | Uno Wild Twists Playing Cards | DIFFERENT-GAME | Poker deck + wilds, own "Wild Race" game. See A10. |
| 96 | Uno Cobs Game Changers Cards | MECHANIC | Australian Cobs Popcorn promo (Mar 2018): 13 single insert cards, not 5. Known: All Draw Two (every player draws 2), Wild Draw Eight (next draws 8, loses turn), Wild Face Up (everyone plays face up for the rest of the game), Wild Shuffle 'Em Up (wording suspect), See The Future (effect unknown), Deflection (bounce a card back on its player, any time), Popcorn (real-world snack perk). 6 cards unknown. HIGH (promo), LOW-MED (most effects). |
| 97 | Phase 10 | DIFFERENT-GAME | Complete-10-phases rummy-style game. See A10. |
| 98 | Uno Bingo | DIFFERENT-GAME | Tile/dice bingo game. See A10. |
| 99 | Uno Wild Tiles | DIFFERENT-GAME | Arrow-directed tile-laying game. See A10. |
| 100 | Uno Dice (1987) | DIFFERENT-GAME | Dice-as-hand variant of UNO's matching idea. See A10. |
| 101 | Uno Dice Game (Can) | RESKIN | Resolved: same global SKU as the US "Uno Dice Game" (Mattel W5807), same UPC - likely a duplicate/misfiled catalog entry, not a distinct Canadian variant. MED. |
| 102 | Luck Plus | DIFFERENT-GAME | Cards + dice, light math game "from the makers of UNO." See A10. |
| 103 | Uno Roboto | MECHANIC | T8220: records player names and one 10-second House Rule per game, names the first and next players, and reacts to some discards with commands (discard a color, duel where loser draws 2, House Rule all-play where last draws 2, nicknames). A card discarded by a command takes effect. HIGH (sheet); trigger frequency and the "swap hands"/"extra turn" commands unconfirmed. See A5. |
| 104 | Uno Power Grab | MECHANIC | Correction: four towers, U/N/O/! (Y2316). Each one protects its holder from one card type: U = Draw One, N = Draw Two, O = Wild Draw Four, ! = Skip. Playing a number card with a tower icon (8 per icon) takes that tower from anywhere; Grab-2-Towers (4) and Wild Grab-A-Tower (4) also steal. Holding all 4 = Instant UNO: discard all but one card. A blocked card still counts for matching. HIGH. See A2. |
| 105 | Uno Showdown Supercharged | MECHANIC | GMX56: same rules as Showdown (#37), cosmetic changes only. Showdown: 20 icon cards + 4 Wild Showdown start a paddle duel with the next player over 1-3 loaded cards; the loser takes them; pressing early loses. HIGH (sheets). See A5. |
| 106 | Uno Tiki Twist | MECHANIC | CGH09: no Draw Two or WD4 in the deck. Playing a Tiki Face card puts it in the idol and spins at once; the pointed-at player does the face's action (Draw 1/2/4, Discard 2, Discard All of the face's color, Go To). HIGH (sheet); copy counts unconfirmed. See A5. |
| 107 | Uno Spin To Go! | MECHANIC | Correction: R2820 has its own travel-themed wheel (Gas/Food/Lodging, Scenic View, Cash Machine, Phone Call, UNO Spin, Escalator, Taxi/Boat/Plane, Luggage, Recycle) and icon number cards, 108 cards; you can go out through wheel discards. HIGH (sheet). See A5. |
| 108 | Uno Reflex | MECHANIC | Light-up reaction-race unit. See A5. |
| 109 | Uno Attack Jurassic World | MECHANIC | Attack-family launcher, dinosaur theme. See A5. |
| 110 | Uno Blast | MECHANIC | Y2318, 110 cards with no Draw Two or WD4: 72 numbers, 8 Draw One, 8 Reverse, 8 Skip, 4 Discard Color, 4 Wild, 6 Wild Blast. A player who can't play inserts their drawn card into the Card Blaster (it can't be played); when it fires, the inserter takes everything. Wild Blast = next player keeps inserting until it fires. This is the real accumulate-and-dump pile (previously misattributed to Wild Jackpot). HIGH (sheet). See A5. |
| 111 | Uno Eye Eye Spongebob! | MECHANIC | P9391: 20 Eyeball number cards (1-5); playing one spins both eyes. Left eye: green = a player of your choice, black = nobody, red = the spinner. Right eye: Draw 4, Discard 1, or draw until Yellow/Blue/Wild. HIGH (sheet). See A5. |
| 112 | Uno Triple Play Stealth | MECHANIC | HCC23: Triple Play with the overload warning lights hidden (they stay blue); Wild Give Away is replaced by Wild All Tap. HIGH (sheet). See A5. |
| 113 | Uno (Xbox 360) | DIGITAL-ONLY | Dev. Carbonated Games/Microsoft (not Gameloft). Standard/Partner/House Rules modes, ranked play, downloadable decks, literal webcam video chat. See Part E1. |
| 114 | Uno (Gameloft) | DIGITAL-ONLY | 15-round unlock-progression career mode; same product line as #241/#243. See Part E3. |
| 115 | Uno (Ubisoft) | DIGITAL-ONLY | Base for many DLC packs; combinable house-rules toggles, 2v2 online. See A12, Part E2. |
| 116 | Uno 35th Anniversary (Xbox 360) | DIGITAL-ONLY | Free DLC deck; "35" card forces next player to play a 3 or 5 or draw-and-miss-turn. See Part E1. |
| 117 | Uno Super Street Fighter 2 Turbo HD Remix | DIGITAL-ONLY | XBLA DLC deck with a bespoke "Hadouken" card (open-ended draw penalty). See Part E1. |
| 118 | Uno Rabbids | DIGITAL-ONLY | Ubisoft DLC, 4 named unique action cards. See Part E2. |
| 119 | Uno Just Dance 2017 | DIGITAL-ONLY | Ubisoft DLC, 4 named all-players-simultaneously cards. See Part E2. |
| 120 | Uno Rayman | DIGITAL-ONLY | Ubisoft DLC, 4 named unique action cards. See Part E2. |
| 121 | Uno Fenyx's Quest | DIGITAL-ONLY | Ubisoft DLC, 4 selectable passive "god blessing" powers (low-confidence effect text). See Part E2. |
| 122 | Uno The Call of Yara | DIGITAL-ONLY | Ubisoft DLC, "Pesos" economy + 4 named character abilities + 1 new card. See Part E2. |
| 123 | Uno Valhalla | DIGITAL-ONLY | Ubisoft DLC, full board + cargo/perks/events - biggest structural departure of any Ubisoft pack. See Part E2. |
| 124 | Uno Teenage Mutant Ninja Turtles (Team Attack) | MECHANIC | "Team Attack" multi-card discard wild. See A3. |
| 125 | Uno Nickelodeon Spongebob Squarepants | RESKIN | N5836 (2010): Jellyfishing x4, every player reveals a jellyfish card or draws 2. HIGH (sheet), MED that this is the printing #125 means. |
| 126 | Uno Nickelodeon Spongebob Squarepants Special Edition (2002) | RESKIN | Correction: Sababa Toys collector tin with a unique "Super Absorbency" rule - the player with the FEWEST cards absorbs 3 cards (1 from each neighbor + 1 from the draw pile). MED-HIGH. |
| 127 | Uno Nickelodeon Spongebob Squarepants Meme | RESKIN | Correction: unique "Wild Draw 6 Cards" card (meme-speak styling) - name a color, next player draws 6, may discard all cards of that color from the draw if any matched. MED. |
| 128 | Uno Rick and Morty | RESKIN | Confirmed (2019): "Mr. Meeseeks" card searches the DISCARD PILE (not your hand) for a favorable card and plays it immediately. HIGH. |
| 129 | Uno Teen Titans Go! | RESKIN | Correction (FDJ14): Robin's Rule card x4, the chosen player gets to discard every PINK card (a favor to them); also 2 customizable wilds. HIGH (sheet). |
| 130 | Uno DragonBall Z | RESKIN | Correction (2023): unique "Wild Shenron's Wish" card - flip the top draw-pile card; if it bears a Dragonball icon, choose one of draw-2/reverse/skip/discard-a-card; otherwise turn just ends; player still names the color. MED. |
| 131 | Uno Saved By The Bell | RESKIN | Correction (GVH30): Wild Rad Style, choose a color; every player WEARING that color draws 2. Honor system. HIGH (sheet). |
| 132 | Uno Friends | RESKIN | HRF43: Wild The One Where You Draw, name a Friend; the next player draws until they get a card showing that Friend. HIGH (sheet). |
| 133 | Uno Hanna Barbera | RESKIN | Correction (~2004, Deluxe Collector Tin): unique "Pic-a-nic" (Yogi Bear) card - steal the top card of the discard pile at any time; also a Wild. MED. |
| 134 | Uno Ultimate Spider-Man Web Warriors | RESKIN | BGG46/FFH21: Web Slinger, "sling" up to 3 cards of one color at any player(s) in any split. HIGH (sheet). |
| 135 | Uno Hannah Montana (2007 On Tour) | RESKIN | M1004: World Tour, lay your hand face down and take another player's; they may keep yours or take someone else's, and so on; the last player takes what's left. HIGH (sheet). |
| 136 | Uno Hannah Montana (2007 Best of Both Worlds) | RESKIN | K6505: Best of Both Worlds, either all opponents draw 1, or discard it to block a WD4 from the previous player (you still take your turn). HIGH (sheet). |
| 137 | Uno Spin Hannah Montana | MECHANIC | Correction: N8367 has its own wheel (Draw Star, World Tour, Sweet Niblets!, Draw 2 for everyone but the spinner, plus 5 standard Spin outcomes) and 32 Star cards (6-9). HIGH (sheet). See A5. |
| 138 | Uno The Big Bang Theory | RESKIN | Confirmed (2012): "Kitty"/"Soft Kitty" card forces the next player to draw repeatedly until they hit a Sheldon (3/9) or Penny (0/5) numbered card; they keep everything drawn and lose their turn. HIGH. |
| 139 | Uno One Piece (2003) | RESKIN | Resolved (Product A of 4 distinct One Piece UNO releases, see #271/#272/#412): confirmed via an Anime News Network article as a real, genuinely earlier Bandai x Mattel original predating the 2011 reissue (#271/#273), with its own different designs/exclusive cards. The 2003 date is now confirmed-plausible rather than likely wrong. MED-HIGH. |
| 140 | Uno Doctor Who | RESKIN | Confirmed (2007, Tenth Doctor era): "Exterminate" forces whoever has the fewest cards to draw 4, unless challenged (mirrors the Wild Draw Four challenge - loser of the challenge draws 4 or 6). HIGH core effect, MED on the challenge detail. |
| 141 | Uno Spy X Family | RESKIN | Major correction (Ensky, Japan, Oct 2023): the "4 original special cards" are 4 physical COPIES of ONE card, "Bond's Precognition" - name a color, everyone reveals cards of that color or draws 3. A separate 2026 McDonald's Japan promo has different single-card-per-deck Spy x Family tie-ins; don't conflate the two. HIGH. |
| 142 | Uno Glee | RESKIN | Correction (2010, Fundex under Mattel's sublicense): unique "Sabotage" card - view an opponent's hand and swap a card you don't want for one you do. MED. |
| 143 | Uno Flip! Stranger Things | MECHANIC | HJP41: Flip with Wild Jim Hopper (the player with the most cards discards half, rounded up; a benefit) and Wild Eleven's Waffle; numbers 2-9 plus 11. A starting action card is ignored. HIGH (sheet); copy counts unconfirmed. See A4. |
| 144 | Uno Schitt's Creek | RESKIN | HHL32: every card has a Love or Money icon. Wild Where Everyone Fits In: call an icon; any player who doesn't hold MORE of it than of the other (ties included) draws 3. HIGH (sheet). |
| 145 | Uno Ted Lasso | RESKIN | Confirmed (2022): "Roy Kent Grunt" - stare down the next player in a grunt-face contest; whoever breaks first draws 2. HIGH. |
| 146 | Uno Yellowstone | RESKIN | Confirmed (2023): 36 numbered cards secretly carry a "Yellowstone Brand" icon; the Brand card makes everyone show a Branded card or draw 2. HIGH. |
| 147 | Uno DC Super Hero Girls | RESKIN | FDJ16: Save The Day x2 (+2 customizable), place it before another player to protect them from penalty cards until another wild is played. HIGH (sheet). |
| 148 | Uno Shark Week | RESKIN | FNC48: Wild Shark Attack, everyone races to slap the discard pile; last draws 4. HIGH (sheet). |
| 149 | Uno Masters of the Universe | RESKIN | GVY91 ((c)2020): 4 Wild Power of Greyskull, all other players draw 3; purple replaces yellow. HIGH (sheet). The later Fandom (#330, HYH55) and movie (JMF11) decks have different cards. |
| 150 | Uno The Muppet Show | RESKIN | Correction (2003 Sababa Toys tin): unique "Muppet Mayhem" card - acts as a Wild, and forces everyone at the table to swap hands (player picks the direction). HIGH. |
| 151 | Uno Nickelodeon | RESKIN | Unverified after a real search (general ~1998-2000 Rugrats/Hey Arnold/CatDog flagship deck, distinct from the SpongeBob-specific decks) - no bonus card found, but per this pass's base rate treat as likely-has-one-anyway rather than confirmed clean. LOW. |
| 152 | Uno Peanuts A Charlie Brown Christmas | RESKIN | Correction: 2 distinct releases. The ~2007/2008 Snoopy-doghouse-tin version has a "Happy Holiday" card (everyone draws 1, may discard it if it matches the called color); the Fandom reissue (JNV43) has Wild Charlie Brown Christmas Tree: one lap around the table where each player may lay a card of a different color from the previous one (not their last card); laid cards go under the tree and their actions are inert. MED-HIGH (tin) / HIGH (JNV43 sheet). |
| 153 | Uno Seinfeld | RESKIN | Confirmed (2023): "Wild Seinfeld Episode" lets players pick 1 of 8 pre-set rules at game start. 4 of 8 names found - "Serenity Now!" (last to yell it draws 4), "Yada Yada" (land a bit, discard 2), "No UNO For You!" (counter an UNO call, they draw 4), and a likely "No Soup for You!" - the other 4 unconfirmed. HIGH core claim, MED on the full list. |
| 154 | Uno USA | RESKIN | Unverified after a real search - no bonus card found; per this pass's base rate, treat as likely-has-one-anyway rather than confirmed clean. LOW-MED. |
| 155 | Uno American Kennel Club Sporting Group (2006) | RESKIN | Correction (Sababa Toys): a named "Best in Show" card/rule exists per 2 retailer listings, but its exact effect was never stated by any source found. MED name, LOW effect. |
| 156 | Uno Angry Birds | RESKIN | Correction (Y2372): King Pig, call a color, then deal from the pile one card to each opponent in turn until someone receives that color. HIGH (sheet). |
| 157 | Uno The Legend of Zelda | RESKIN | FMW19: Triforce symbol on every 3, 6 and 9. Wild Triforce: the next player must play the chosen color WITH a Triforce, or draw 3. Tan replaces yellow. HIGH (sheet). |
| 158 | Uno 52 | MECHANIC | Parallel poker-hand hybrid, reduced challenge penalty. See A3. |
| 159 | Uno Royal Revenge | MECHANIC | CGH10, 56 cards (1-8 per color, Reverse, Skip, 4 King's Choice, 8 Jester, 4 Wild) with no Draw Two or WD4. The King names every Wild's color; the scepter fanfare passes the crown left and the new King picks a Jester. Jester card = the hat wearer draws 1; King's Choice = the King picks who draws 1; neither loses a turn. HIGH (sheet). See A3. |
| 160 | Uno Rummy Up | DIFFERENT-GAME | Rummikub tile-rummy with UNO action tiles. See A10. |
| 161 | Uno Unocorns | RESKIN | FNC46: Wild Narwhal, everyone draws a card and holds it to their forehead unseen; on your turn you must guess its color before discarding it and playing. HIGH (sheet). |
| 162 | Uno Colors Rule! | MECHANIC | DWV64: four Color Powers. Red = give all your red cards to any player at any time; Blue = play 2 playable cards; Green = when you can't play, flip the top draw card onto the pile; Yellow = immunity to Skip, Reverse, Draw 2, WD4 and Red. Wild Color Character steals that color's power; Wild Color Choice steals any named power (not a plain Wild). No 0s, no plain Wild. HIGH (sheet). See A3. |
| 163 | Uno Spider Sense Spider-Man | RESKIN | Confirmed: "Spider-Sense" (others reveal a qualifying card or draw 2) and "Web Slinger" (sling up to 3 same-color cards from your hand to opponents, also a Wild) - the latter likely reuses the same name/effect as #134's Web Warriors card. MED. |
| 164 | Uno Remix! | MECHANIC | HBF06: 56 game cards + 56 blank Remix cards drafted each round (Wild + Name, Skip-To, Giving, Add A Mark, Shield, Draw 2 + Name, WD4 + Name, AN2/AN4 add a second name). The deck grows permanently across rounds. No points: a sticker per round win. HIGH (sheet); copy counts unconfirmed. See A5. |
| 165 | Uno Barbie The Movie | RESKIN | HPY59 (2023): Wild "Played With Too Much", all other players discard every card of the chosen color, then draw the same number. HIGH (sheet). #424 is the same SKU. |
| 166 | Uno Batman Begins | RESKIN | H7339: Justice, deal one card to each other player in turn until you're down to one (calling UNO); also a regular Wild. HIGH (sheet). |
| 167 | Uno Batman v Superman | RESKIN | DRL58: Hero Card x2 (Batman/Superman) + 2 customizable. Block an action card showing Superman with a Batman Hero Card, and vice versa. HIGH (sheet). |
| 168 | Uno Cars (2012) | RESKIN | Correction (the original 2006-film tie-in, item H7340; "2012" likely a later print date of the same deck): unique "Wild Victory Lap" card - cycle through other players' hands looking for a better one, keep whichever you settle on. MED. |

### #169–252

| # | Title | Category | Mechanic Notes |
|---|-------|----------|-----------------|
| 169 | Uno Cars (2014) | RESKIN | BGG54: Accele-race, flip the top pile card onto the discard; everyone races to discard one card of its color; the last to play takes theirs back. HIGH (sheet). |
| 170 | Uno Disney Wish | RESKIN | Correction (2023, item HRF41): unique "Wild Wishing Star" card (4 copies) - name a color, others show a matching "Wishing Icon" card or draw until they get one. MED. |
| 171 | Uno Disney Pixar Finding Dory | RESKIN | Correction (2016, item DRB64): unique "Just Keep Swimming" Wild card - next player draws until they get a blue card; may ship with additional customizable cards too. MED. |
| 172 | Uno Disney Frozen (2014) | RESKIN | Correction (CJM70): only Olaf's Summertime x4 (discard up to 3 pink or 3 yellow cards). There is no Elsa's Freeze card. HIGH (sheet). |
| 173 | Uno Disney Frozen (2016) | RESKIN | Unresolved: no evidence found of a distinct 2016 release separate from #172 (CJM70) or the later Frozen II deck (#88); likely a duplicate/mislabeled entry pending a physical box check. LOW. |
| 174 | Uno Green Lantern | RESKIN | T8235: Power Ring, give away all your yellow cards, split among other players however you like. HIGH (sheet). |
| 175 | Uno Harry Potter (2005) | RESKIN | Correction: likely shares content with #176 (both pre-2018 waves) - "Wild Voldemort" card, discard all your Harry-image cards (2/6/9 of each color), last one discarded sets the color; worth 50 points. MED. |
| 176 | Uno Harry Potter (2010) | RESKIN | T8231: Voldemort x4, discard every Harry card (2, 6, 9) from your hand; the last one you place sets color/number; with none it's a plain Wild. Same content as #175. HIGH (sheet). |
| 177 | Uno Harry Potter (2018) | RESKIN | FNC42: 4 Wild Sorting Hat, the chosen player draws until they draw a "Gryffindor card". HIGH (sheet). The sheet doesn't define a Gryffindor card; the "1/2/3/4" mapping used earlier is unsourced. |
| 178 | Uno Harry Potter (2021) | RESKIN | Correction: a repackaging/rerelease of #177 (FNC42) in new box art, same "Wild Sorting Hat" card - not independently distinct content. MED. |
| 179 | Uno High School Musical | RESKIN | Correction (2006): unique "Duet" Wild card - all other players discard a matching number pair (0&2/1&6/3&5/4&9) or draw 2. MED. |
| 180 | Uno High School Musical 2 | RESKIN | Correction (2007): unique "Wild Sharpay's Helping Hand" card - give one card from your hand to any other player, then name the color. HIGH. |
| 181 | Uno Jurassic World Dominion | RESKIN | Correction (2022, own BGG entry #451353, distinct from the base Jurassic World deck at #80 and from Uno Attack Jurassic World): unique "Run!" card - block/cancel another player's Dino-icon action card. HIGH. |
| 182 | Uno Justice League | RESKIN | Correction (~2017): unique "Superman's X-Ray Vision" Wild card - look at a chosen player's hand, take one card from it in exchange for one of yours, then name the color. HIGH. |
| 183 | Uno Disney Pixar Lightyear | RESKIN | Correction (HJC25): Wild Hyperspeed, choose a color; every play of that color skips the next player until the color changes. HIGH (sheet). |
| 184 | Uno Minions Rise of Gru | RESKIN | GKD75: Wild Dumb Fu, the next player holds a pose until their next turn or draws 4. HIGH (sheet). |
| 185 | Uno The Nightmare Before Christmas (2007) | RESKIN | Correction (Sababa Toys, glow-in-the-dark tin): unique "Oogie Boogie" card - next player draws until their drawn NUMBER cards total 11+, then the last card drawn is discarded and the color is chosen. HIGH. |
| 186 | Uno The Nightmare Before Christmas (2017) | RESKIN | Correction: a genuinely distinct release from #185 (different color scheme/packaging, Mattel "Fandom" line era), but appears to carry over the same "Oogie Boogie" card rather than adding a new one. MED-HIGH distinct release, MED same card. A separate 2026 Fandom deck (JNV41) has Wild Sandy Claws (a one-lap pass-a-card chain, HIGH from sheet); don't confuse the two. |
| 187 | Uno The Peanuts Movie | RESKIN | DHC65: Man's Best Friend, discard up to 3 Charlie Brown/Snoopy cards, then a chosen "Best Friend" discards 1. HIGH (sheet). |
| 188 | Uno Peanuts It's The Great Pumpkin Charlie Brown (2006) | RESKIN | Correction (Fundex "Great Pumpkin Halloween Special Edition"): unique "Trick or Treat!" card - everyone draws one card, the player calls a color, matching-color drawers may discard theirs. HIGH. |
| 189 | Uno Nickelodeon Dreamworks The Penguins of Madagascar | RESKIN | T8228: Dr. Blowhole's Revenge, give away the top 4 pile cards, split among players however you like. HIGH (sheet). |
| 190 | Uno Ratatouille | RESKIN | Existence unconfirmed - no product found under this name after real search (the "Uno Pixar" multi-film tin exists but Ratatouille inclusion is unconfirmed). Flag for doc-source verification. LOW. |
| 191 | Uno Space Jam A New Legacy | RESKIN | Correction (GXV55): Wild Welcome to the Jam, drop the card: Slam side up = you discard 2; UNO side up = you draw 2. HIGH (sheet). |
| 192 | Uno Spirit Untamed | RESKIN | Correction (GXD73): Wild Best Friends, call a number; each player in turn may discard one card of that number, you last. HIGH (sheet). |
| 193 | Uno Star Wars Technical Schematics | RESKIN | Confirmed correct: "That Was One in a Million" card instructs physically tossing cards at the discard pile (Death Star exhaust-port flavor); genuinely no mechanical effect found anywhere. MED-HIGH. See A8. |
| 194 | Uno Teenage Mutant Ninja Turtles Mutant Mayhem | RESKIN | Correction (2023 movie, distinct from the 2017 Team Attack deck): unique "From the Sewers" rule - targeted player(s) draw until they hold one card of each of the 4 colors. MED. |
| 195 | Uno Hotwheels (2020) | RESKIN | BGG53 (same SKU as #324/#476): Wild Super Charged, discard every card of one color from your hand; that color continues. HIGH (sheet). |
| 196 | Uno Disney Princess (2020) | RESKIN | GYY69: Wild Power of Friendship, place a card of a secret color face down; others lay a guess face down; matchers discard theirs. HIGH (sheet). |
| 197 | Uno Disney Mickey Mouse and Friends (2021) | RESKIN | Correction: unique "Wild Friendship" card - every player discards one card. MED, single source. |
| 198 | Uno Flip! Marvel | MECHANIC | GXV56: no plain Wilds. Light: 4 Wild Super Hero (the player with the most cards discards one). Dark: 4 Wild Villain (the player with the fewest cards draws three) + 4 Wild Draw Color. HIGH (sheet). See A4. |
| 199 | Uno Coca-Cola (2004) | MECHANIC | "Thirst" card: choose any other player, who draws until a red number card or a Wild appears; that card goes straight onto the discard pile, then the Thirst player names the next color. MED (single source). |
| 200 | Uno Jelly Belly | MECHANIC | Jelly Belly gift box (~2012): bean-shaped cards + a bag of jelly beans, rules explain using beans in play. The "resource mechanic tied to draw cards" claim is unverified. MED (exists), LOW (mechanic). |
| 201 | Uno Burger King Desafio: Dinossauros (Brazil) | MECHANIC | "Carta Desafio" dare-or-draw-5 card. See A8. |
| 202 | Uno Burger King Desafio: Música (Brazil) | MECHANIC | Same Desafio mechanic, music theme. |
| 203 | Uno Burger King Desafio: Monstros (Brazil) | MECHANIC | Same Desafio mechanic, monster theme. |
| 204 | Uno Burger King Desafio: Robós (Brazil) | MECHANIC | Same Desafio mechanic, robot theme. |
| 205 | Uno Burger King Desafio: Princesa (Brazil) | MECHANIC | Same Desafio mechanic, princess theme. |
| 206 | Uno Burger King Desafio: Sereia (Brazil) | MECHANIC | Same Desafio mechanic, mermaid theme. |
| 207 | Uno McDonald's Party Games (Japan) | RESKIN | Resolved: real, distinct McDonald's Japan Happy Set promo line (Nov 2017 30th-anniversary wave; Nov 2022 2nd wave), NOT the same as the separate Feb 2026 "Minna de UNO" My Hero Academia/Spy x Family collab. Cosmetic promo deck. HIGH. |
| 208 | Uno The Amazing Spider-Man (2023) | RESKIN | Correction (HXY08): Wild Web Swing, everyone reveals; skip ONE player who shows the named color (nobody if none). HIGH (sheet). |
| 209 | Uno Batman (2005) | RESKIN | Correction: a genuinely separate Sababa Toys 2005 release from the Mattel "Batman Begins" deck at #166 (different designer credit/UPC) - NOT the same product. Bonus card not located; the later "Bat Signal" card belongs to a different, modern "UNO Batman Comics" edition, not this one. MED distinct release, LOW on its own bonus card. |
| 210 | Uno Fantastic Four (2005) | RESKIN | Correction: unique "N-Zone" card - name a player, they draw until a red card appears (which becomes the new discard), then the N-Zone player still names the next color. MED. |
| 211 | Uno The Incredible Hulk (2003) | RESKIN | Unverified after a real search (2003 Mattel collectible tin, existence confirmed) - no bonus card found; per this pass's base rate treat as likely-has-one-anyway. LOW. |
| 212 | Uno Marvel Heroes (2010) | RESKIN | Correction (Fundex, not Mattel): a "Feats of Fate" card is named in a dedicated rulebook TOC; trade a card to the first player holding a Draw Two/Four, or play any card if none do. MED name, LOW on effect wording. |
| 213 | Uno Superman (2006) | RESKIN | Correction: likely a genuinely separate Sababa Toys release from "Superman Returns" (#91) - a "Bizarro vs. Superman"/exclusive Battle Card is named by retailers, effect unconfirmed. LOW-MED distinct release, LOW on card effect. |
| 214 | Uno X-Men (2003) | RESKIN | Wild Cerebro (name an X-Men character; the target reveals it or a Wild, or draws 5) is confirmed for the 2026 deck (JNP43), not this 2003 tin. HIGH (2026 sheet), LOW for #214. |
| 215 | Uno New York Giants (2006) | MECHANIC | Era "Champs Card" (found for UNO NFL AFC/NFC Edition 2006): chosen player draws until they draw a 4 or have drawn 7 cards; Champs player names the color. MED (card), LOW-MED (that this exact deck has it). |
| 216 | Uno NBA All Stars Western Conference | RESKIN | Resolved: real 2006 Mattel release, player-photo theme on standard card types, no unique added mechanic found (unlike the same line's Lakers Legends "SHOWTIME!" card). MED-HIGH. |
| 217 | Uno MLB Stars of the American League | MECHANIC | "Top 2" card forces the two lowest-hand players to draw. |
| 218 | Uno Fandom NFL Super Bowl LVIII Kansas City Chiefs | MECHANIC | Unverified for this deck (not on Mattel's current site). The related Super Bowl LVII deck (HPW22) has Wild Touchdown!: every other player raises their arms and the last to do so draws 3 (sheet). LOW for #218 itself. See A7. |
| 219 | Uno Fandom NFL Pittsburgh Steelers | MECHANIC | HYH53: own team rule, "Steel Curtain" rule. "Force opponents to draw cards". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 220 | Uno Fandom NFL San Francisco 49ers | MECHANIC | HYH52: own team rule, "The Backup" rule. "Protect yourself from injury (well, Draw Cards)". (a draw-card shield) MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 221 | Uno Fandom NFL Philadelphia Eagles | MECHANIC | HYH51: own team rule, "Fly Eagles Fly" rule. "Force opponents to fumble one card onto the Discard Pile". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 222 | Uno Fandom NFL Dallas Cowboys | MECHANIC | HYH50: own team rule, Wild Hail Mary. "When a player is down to their last card and yells 'UNO!', it's time to throw up a prayer and immediately play the Hail Mary card. First, name a color. If that is the color of the player's last card, you get to discard down to 1 card. Play then continues with the player to your left in the color you chose. If multiple people try to play a Hail Mary at the same time, it goes to the player who gets their card to the discard pile first." HIGH (sheet). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 223 | Uno Fandom NFL New England Patriots | MECHANIC | HYH49: own team rule, "Lead Block" card. "Use the Lead Block Card to avoid being skipped over." (a Skip counter) MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 224 | Uno Fandom NFL Kansas City Chiefs | MECHANIC | HYH48: own team rule, "Arrowhead Loud" rule. "Hit 142.2 decibels as you force other players to draw a card". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 225 | Uno Arsenal Highbury Legends | MECHANIC | Red Card/Yellow Card penalty cards. |
| 226 | Uno New York Mets David Wright | MECHANIC | "Hot Corner" card/rule, no standard equivalent. |
| 227 | Uno NFL New England Patriots Special Edition (2005) | MECHANIC | Era "Champs Card" (see #215). LOW-MED that this deck carries it. |
| 228 | Uno NBA Kobe Bryant Special Edition (2007) | MECHANIC | "Three-Pointer" forced-draw-until card. |
| 229 | Uno Cricket (India) (2021) | DIFFERENT-GAME | Unverified: two targeted searches found no Cricket UNO and no Four/Six/Wicket/Over card list. Existence and mechanics unconfirmed. LOW. See A9. |
| 230 | Uno WWE Legends Special Edition (2006) | MECHANIC | Unverified: no Mattel sheet; "1-2-3" card not found. Locked Up is confirmed for later WWE decks (#231). LOW. |
| 231 | Uno WWE (2017) | MECHANIC | FNC47: 4 Locked Up Wilds. Pick an opponent; both choose a number card and reveal together; the LOWER takes both into hand. HIGH (sheet). A newer WWE deck (JKH98, 2025) has Wild Payback instead; see the Additions table. See A8. |
| 232 | Uno WWE (2010) | RESKIN | Resolved: 2010 Cena/Mysterio "Wrestling Edition" with the Locked Up card (lower value takes both). Same rule as #231 (FNC47 sheet). HIGH. |
| 233 | Uno Nascar (2005) | MECHANIC | "Drafting" bonus-plays wild. See A8. |
| 234 | Uno X Games | MECHANIC | BoardGameGeek (#12228, 1999) and two mirrors list the renamed cards: Can-Can (Wild, draw 10), Nuclear Air (Wild, draw 5), Dirt-Dive (discard all but 5), Fakie (Wild, all players trade hands), Drop a Hill (Wild, draw a new hand), Alley-Oop (Reverse + discard all of one color), and Tailwhip/Lipslide trick cards replacing Reverse/Skip. HIGH (though the three sources may share one origin). Colors and copy counts not found. See A8. |
| 235 | Uno Undercover | DIGITAL-ONLY | Dev. Golden Goose/RealArcade, 2008, Windows (plus a Mac build; no DS version - that's a separate plain Gameloft port). Standard 108-card deck + up to 7 of the player's 13 unlocked **Command Cards** (15 defined, 2 cut), one copy each, human-only. Several take a second "pairing" card that sets a turn count. Verified by decompiling the game, see Part E4 and `docs/mechanics/09-uno-undercover.md`. HIGH. |
| 236 | Uno CD-ROM | DIGITAL-ONLY | Mattel Media/Interactive, ~1999-2002. Adds Spy Card (hides your hand-size from opponents) + Mutant/Shark Cards (names known, effects undocumented). See Part E4. |
| 237 | Uno Game Boy Color | DIGITAL-ONLY | Dev. HotGen (not Genki), 1999. Adds a Challenge mode that inverts scoring: reaching a point ceiling eliminates you instead of winning. See Part E4. |
| 238 | Uno + Skip-Bo 2 Game Pack (Game Boy Advance) | RESKIN | Confirmed correct (Destination Software, 2006): two unmodified, separate single-player-vs-AI games on one cartridge, no shared/crossover mechanic found. MED-HIGH. |
| 239 | Uno Free Fall (Game Boy Advance) | DIFFERENT-GAME | Falling-block tile-matching puzzle game. See A10. |
| 240 | Uno Free Fall (Java Mobile Game) | DIFFERENT-GAME | Same falling-block puzzle mechanic as #239. |
| 241 | Uno (Java Mobile Game) (2009) | DIGITAL-ONLY | Gameloft; same product line as #114. Quick Play/Tournament (5 escalating rounds)/Custom Game (9 toggleable rules, only 2 named). See Part E3. |
| 242 | Uno Spin (Java Mobile Game) | MECHANIC | Digital Uno Spin wheel mechanic. See A5. |
| 243 | Uno & Friends (Java Mobile Game) (2012) | DIGITAL-ONLY | Gameloft, distinct from the 2013 online version (#376). "Uno World Tour" (6 venues x 5 stages, some stages are non-UNO minigames) + Hot Seat. See Part E3. |
| 244 | Uno DirecTV Game Lounge | DIGITAL-ONLY | Dev. Denki, interactive-TV port; no unique rule found beyond delivery method. See Part E4. |
| 245 | Uno Paw Patrol (2015) | RESKIN | Unverified: GeekyHobbies has a dedicated rules-explainer page for this title (a weak positive signal, per the pattern that such pages exist specifically for decks with non-default content), but the specific card wasn't retrievable. LOW-MED. |
| 246 | Uno Mickey Mouse and Friends (2017) | RESKIN | Correction: unique "Wild Friendship" card - every player discards one card ("because Mickey loves to share"); may be the same card reused across 2017-2021 reprints (see #197). MED-HIGH. |
| 247 | Uno South Park | RESKIN | Correction (2004 Sababa Toys tin): a named exclusive "Dead Kenny" card is referenced by multiple listing titles (playing on the show's running joke), effect not found anywhere. LOW-MED name, LOW effect. |
| 248 | Uno Disney (2002) | RESKIN | Resolved (confirmed "Disney Electronic UNO," Mattel, 2002): kept as RESKIN, NOT retagged to DIFFERENT-GAME - multiple eBay listings ("mit Karten"/"with cards") and Mattel's own instruction sheet (service.mattel.com/instruction_sheets/DisneyUno.pdf, "Players: 2-10") confirm this ships a full physical UNO-compatible deck; it's genuinely real UNO. The electronic part is a "Game Tray" accessory (Tinker Bell Button + Color Selector lights) used for one special "Wild Discard All" card - press the button, the tray's lights land on a color (or match it yourself), everyone discards all cards of that color. The tray has no hand of its own and isn't an AI opponent - it's a randomizer/referee gimmick for one card, not a self-contained electronic game (contrast #263). HIGH on product identity, MED-HIGH on mechanic. |
| 249 | Uno Disney (2016) | RESKIN | Likely a duplicate/mislabeled entry, similar to #173 (Frozen 2016) - no distinct 2016 generic/flagship Disney release found separate from #248 or any specific-franchise Disney deck. LOW. |
| 250 | Uno Disney 100 | RESKIN | HPW21: Wild Mickey Movie Madness, name a Disney movie; the chosen player names 4 characters from it or draws 4. Trivia/honor system. HIGH (sheet). |
| 251 | Uno Disney Pixar Coco | RESKIN | Correction (FMB85): Wild Remember Me is a memory quiz, not a hand swap: the next player must name the two cards buried under it or draw 3. HIGH (sheet). |
| 252 | Uno Toy Story (2008) | RESKIN | Unverified after a real search (2008 Mattel, original film) - no bonus card found, but later Toy Story decks in the family (#87, and a "Toy Story 5" deck) do have one, suggesting under-research rather than genuine absence. LOW. |

### #253–336

| # | Title | Category | Mechanic Notes |
|---|-------|----------|-----------------|
| 253 | Uno Toy Story 3 (2009) | RESKIN | R2822 (2009): Lotso, call a color; opponents without it draw 3, but if ALL have it, you draw 3. HIGH (sheet). |
| 254 | Uno Trolls Band Together | RESKIN | HPW18: Wild Power of Togetherness, everyone draws up to the size of the largest hand. HIGH (sheet). |
| 255 | Uno Doc McStuffins | RESKIN | Correction (2013, Cardinal Games): unique "Stethoscope" card - acts as a Wild, and every other player shows a Doc McStuffins card or draws 2. MED. |
| 256 | Uno Care Bears | RESKIN | Unverified after a real search (2003) - no bonus card found; per this pass's base rate treat as likely-has-one-anyway. LOW-MED. |
| 257 | Uno Ren and Stimpy | RESKIN | Existence unconfirmed under the UNO brand - the only real Mattel-era Ren & Stimpy card product found is a non-UNO "Bump-A-Riffic" card game. Flag for doc-source verification. LOW. |
| 258 | Uno Flip Transformers | MECHANIC | HXJ49: Might of Optimus Prime (compare highest number cards; the winner discards up to 2) and Tyranny of Megatron (both reveal hands; the lower draws 2); ties go to the caster. A failed WD challenge = draw 4. HIGH (sheet). See A4. |
| 259 | Uno The Simpsons Springfield | RESKIN | Follow-up: a 112-card tin (not base 108), confirming SOME bonus card exists. Most plausibly = the real 2005 "Springfield USA Exclusive Special Edition" tin - deeper research found a long, genuine Simpsons UNO reprint history (2001, 2003 UPC 831614005323, 2005 Springfield tin, 2007 Sababa Toys, 2025 JHB16/#483) that are distinct real products, NOT one title triple-counted - do not merge this into #483. The "Woo-hoo/D'OH!" candidate name may simply be a rule reused across multiple Simpsons UNO editions over the years rather than proof this is the same SKU as #483. MEDIUM. |
| 260 | Uno Pixar (2021) | RESKIN | Confirmed as the SAME SKU as #423 "Uno Pixar (2025)" below - merge (Mattel "Pixar 25th Anniversary" tin, SKU GVP47, official instruction sheet carries a (c)2020 Mattel notice): "Pixar Pop Quiz" Wild x4 - name a movie, the chosen player names characters from it and draws one card per correct answer. GVP47 is a continuously-stocked catalog item, not a new 2025 SKU. HIGH. |
| 261 | Uno Monster High (2017) | RESKIN | Unresolved - likely has a bonus card by analogy to the adjacent 2013 (#262) and 2015 "Beast Ghoul Friends" editions, but which one wasn't confirmed. This doc's #42/#261/#262/#397/#426 entries likely represent 3-4 genuinely distinct Monster High UNO products across years that need reconciling. LOW-MED. |
| 262 | Uno Monster High (2013) | RESKIN | T8233 ((c)2011, not 2013): Creeperific "Urrrhhh" x4, give away cards of a chosen color one per player clockwise until you run out. HIGH (sheet). #42 is the same product. |
| 263 | Uno Master Disney Pixar Cars | DIFFERENT-GAME | Resolved and RETAGGED from RESKIN: a 2007 Mattel/Radica ELECTRONIC HANDHELD device with an on-screen/virtual hand of cards - no physical deck at all (likely the 43429/43435 chassis, also sold as "Radica Color Screen UNO Handheld" G8665; the same model number is cross-tagged by sellers to both Disney Princess and Disney Pixar Cars, confirming one chassis relicensed across Disney properties). "Uno Master" is likely not an attested official Mattel product name (no corroborating primary source found) - may be a collector/regional label. No Cars-specific gameplay beyond cosmetic art/sounds/lights found. Note: a separate, ordinary PAPER "Disney Pixar Cars" UNO deck also exists elsewhere (a normal RESKIN) - don't conflate with this electronic unit. HIGH it's electronic hardware with no physical cards, MED on exact chassis/model, LOW on exact internal ruleset (no manual retrieved). |
| 264 | Uno Kiki's Delivery Service | RESKIN | Correction (Ensky, Japan): two separate eBay listings title this set "Special Rule Card" (singular), implying a unique bonus card unlike the usual Ensky "4 cards" pattern. Exact name/effect not found. MED existence, LOW specifics. |
| 265 | Uno Haikyu!! | RESKIN | Correction (Jan 2024, Ensky): confirmed to ship 4 original special rule cards per 2+ independent retailer/press descriptions (Dengeki Online + a separate listing naming "4 Freak Fast Attack Cards"), matching Ensky's house pattern. Exact Japanese card name/effect not found. HIGH existence, LOW specifics. |
| 266 | Uno My Hero Academia | RESKIN | Correction (~Jan 2024, Ensky): standalone retail set, confirmed distinct from the 2026 McDonald's Japan Happy Set promo (see #207). Retailer listings describe 4 original special rule cards (same Ensky house pattern as Haikyu/Naruto Shippuden). Exact names/effects not found. MED-HIGH existence, LOW specifics. |
| 267 | Uno Doraemon (2023) | RESKIN | Confirmed as a third, distinct Doraemon UNO release (separate from #268's 2003 edition and the ~2016 edition), Oct 2023, Ensky/Joshin. Unlike sibling Ensky anime-UNO titles, no listing anywhere mentions a special rule card - may genuinely be the one plain reskin in this family, but absence of evidence isn't confirmation. LOW-MED. |
| 268 | Uno Doraemon (2003) | RESKIN | Existence confirmed (Bandai x Mattel's earliest Japan anime UNO collab, same wave as #139's 2003 One Piece release), bonus card not found despite Japanese-language searches. MED existence, LOW on card content. |
| 269 | Uno Hi Hi Puffy AmiYumi | RESKIN | Existence itself unconfirmed - no product listing, BGG/eBay hit, or Mattel instruction sheet found anywhere. Flag for doc-source verification. LOW. |
| 270 | Uno Naruto Shippuden | RESKIN | Correction (~Jan 2024, Ensky): confirmed to ship "4 original special rule cards" per retailer description, matching Ensky's house pattern for anime UNO lines - exact names/effects not found despite Japanese-language searches. MED existence, LOW specifics. |
| 271 | Uno One Piece (New World) (2011) | RESKIN | CONFIRMED MERGE with #273 "Summit War" (Product B of 4 distinct One Piece UNO releases, see #139/#272/#412): an Anime News Network article (2011-06-09) describes exactly ONE Bandai x Mattel reissue, July 7 2011, ¥1,260 - "New World" and "Summit War" are fan-assigned story-arc labels, not official product names; no evidence of 2 distinct 2011 releases. 2 bonus cards confirmed: "Fire Fist Ace" (doubles another action card's effect when played together) and "Hancock"/"Mero Mero Mellow" (turns a targeted player to stone, losing a turn), plus a "I'm gonna be the Pirate King!" call-out replacing "Uno!". HIGH. |
| 272 | Uno One Piece (2016) | RESKIN | Resolved (Product C of 4 distinct One Piece UNO releases, see #139/#271/#412): Ensky's March 2016 "45th Anniversary" rule-change wave, replacing that wave's 2 new standard wilds with 4 theme-original cards - "Shanks" (name a color, an opponent reveals matching cards, cancelable only by a Luffy "1") and "UNO UNO no Mi" (copies another action card's effect when played with it), confirmed via a BGG-mirror listing naming exactly these 2 cards. Genuinely distinct cards from Product B (#271/#273) confirm this is a separate release. MED-HIGH. |
| 273 | Uno One Piece (Summit War) (2011) | RESKIN | CONFIRMED MERGE with #271 "New World" (2011) - same July 2011 Bandai x Mattel release under a different fan-assigned arc name, see #271 for the full shared bonus-card findings and source. HIGH. |
| 274 | Uno One Piece Log Spin | MECHANIC (unconfirmed) | A Bandai One Piece "UNO SPIN / log spin" listing exists; no rules found. Treat as UNO Spin with One Piece art. MED (exists), LOW (any rule differences). |
| 275 | Uno Hello Kitty (2003) | RESKIN | Unverified (likely a Sababa Toys collector tin) - no bonus card confirmed for this specific year; a general undated rules page describes only standard cards. LOW. |
| 276 | Uno Hello Kitty (2006) | RESKIN | Unverified after a real search - no bonus card found for this specific year; searches kept surfacing the 2003/2012 editions instead. LOW. |
| 277 | Uno Hello Kitty (2012) | RESKIN | Correction (Mattel/Cardinal tin): a named "Exclusive 'Hello Kitty Bow' Rule" card is advertised by multiple sellers, exact effect not found anywhere. MED name, LOW effect. |
| 278 | Uno Hello Kitty (Japan) (2011) | RESKIN | The 2011 date/existence itself may be wrong - no corroborating source found; the clearest Japan-market Sanrio/Hello Kitty UNO is actually a 2018 "UNO Sanrio Characters" release, possibly conflated with this entry (similar to #139's likely-wrong "2003" date). LOW, needs the most follow-up of this batch. |
| 279 | Uno Pokémon XY | RESKIN | Correction: likely corresponds to Mattel's "GNH17" Snorlax & Greninja edition (Greninja is the signature XY-era Pokémon) - confirmed to ship a "Special Rule Card," exact effect not found. MED existence, LOW effect. |
| 280 | Uno Pokémon Best Wishes | RESKIN | Existence not independently confirmed under this name - searches kept surfacing the later GNH17 (XY-era) edition instead. Flag for doc-source verification. LOW. |
| 281 | Uno Monster Dream Company | RESKIN | Resolved: Mattel Japan GDJ91, correctly tied to "Monster Strike Dream Company" (an official 2019-2020 mobile spin-off of Monster Strike, not the core game). HIGH real/tie confirmed; cosmetic reskin otherwise. |
| 282 | Uno Dragon Ball Super (Japan) | RESKIN | Correction (Ensky/Bandai, Japan): per a Japanese press release, removes both standard Wilds and replaces them with 4 original cards; exact names/effects not found. LOW-MED. |
| 283 | Uno Speed Racer | RESKIN | Confirmed real (2007/08 Mattel film tie-in, via trade press + resale listing), but no bonus card found despite a real search. LOW. |
| 284 | Uno Pocket All Wild Burger King | MECHANIC | Pocket-format All Wild deck. See A6. |
| 285 | Uno Flip! Express | MECHANIC | Correction (GXD75): a distinct 56-card, 2-4 player Flip, not just a travel box. Dark side has Draw Three instead of Draw Five; Wild Draw Color is capped at 5 cards; deal 5, play to 250. HIGH (sheet). See A4. |
| 286 | Uno Limited Too It's a Girl's World | RESKIN | Follow-up: still no product/listing/press mention found. Only tangential hit: an unrelated, abandoned 2007 "IT'S A GIRLZ WORLD" plush-toy trademark filing (2008 abandoned) - not linked to UNO or cards. Likely doesn't exist as described. LOW. |
| 287 | Uno Phineas and Ferb | RESKIN | Y2371: Agent P reflects a Draw 2/WD4 played on you back onto its player. HIGH (sheet). |
| 288 | Uno Chicago White Sox World Series (2005) | RESKIN | Confirmed as a real commemorative tin; no unique mechanic found, consistent with other single-season sports tins reading as genuinely plain. LOW. |
| 289 | Uno New York | RESKIN | No standalone "New York" product found - may be conflated with a Yankees (2005/2006) or Mets (2007) tin, neither of which shows a unique mechanic either. LOW. |
| 290 | Uno Batman The Dark Knight | RESKIN | M1006 (2008): The Joker's wild card, the chosen player draws until your color appears, discards that card and keeps the rest. HIGH (sheet). |
| 291 | Uno Nike Zoom Freak 3 | RESKIN | Correction: not standard rules. The 2021 UNO x Nike x Giannis 50th-anniversary collection included a Giannis UNO deck with a new "Force a Turnover" rule (steal an extra discard; also playable in the UNO! mobile app). The Zoom Freak 3 shoe itself is apparel. HIGH (rule exists), LOW (exact text). |
| 292 | Uno Star Trek Special Edition (1999) | RESKIN | Correction (Mattel, 1999): 4 exclusive "Star Fleet Command" cards incl. "Live Long and Prosper" (discard current hand, draw an entirely new one, call a color) and "Beam Me Up, Scotty"; call-out is "Space, the final UNO frontier!" Distinct from a separate Fundex "Collector's Edition" ("Beam Up WILD" negates a +2/+4 played against you). MED. |
| 293 | Uno Teenage Mutant Ninja Turtles (2013) | RESKIN | Correction (CJM71, 2014): Team Attack card x4, discard up to three Villain cards. HIGH (sheet). The 2017 deck (FFH20) uses the same text. |
| 294 | Uno Pittsburgh Steelers (2009) | RESKIN | Standalone 2009 product unconfirmed; "Ice the Kicker" belongs to the later league-wide multi-team UNO NFL line (see #298), not attributable to a single-team 2009 tin. LOW. |
| 295 | Uno Boston Red Sox 2007 World Series Champions | RESKIN | Only a 2004-dated Red Sox edition was found (Sababa Toys); the "2007" date itself is unverified and may be confused with #319/#347's 2004 product. No mechanic found either way. LOW. |
| 296 | Uno Ambassador: Masahi Oguro | RESKIN | Resolved: correct spelling is Masashi Oguro, a Japanese footballer appointed "UNO Ambassador" (UNO大使) by Mattel Japan on Oct 23 2005 - a celebrity-endorsement promo role, not a distinct card product. HIGH. |
| 297 | Uno Veefriends | RESKIN | Confirmed via the official VeeFriends blog: "Sharing Squirrel" - next player must photograph their hand and post it online with #VeeFriendsUNO; plus 3 themed renames of standard actions (Draw Two Emu, Reverse Robin, Skip Tick). HIGH. |
| 298 | Uno NFL (2023) | RESKIN | HPW20/HPY63: Wild Ice The Kicker, the next player must kick a paper field goal through their own finger goalposts or draw 3. HIGH (sheet). |
| 299 | Uno Boston Celtics (2005) | RESKIN | Follow-up: upgraded to "real-but-undocumented," MEDIUM confidence - confirmed an extensive Sababa Toys "Special Edition UNO" sports-licensing wave (2006 NBA Western Conference, 2006 Spurs, 2006/2007 Yankees/Red Sox/Cubs) that a Celtics edition would fit, even though no direct listing surfaced. Note the 2005 NBA champion was the Spurs, not the Celtics, so the doc's year/team pairing may still be slightly off. |
| 300 | Uno Ford | RESKIN | No Ford-branded UNO found; the 2025 "UNO Elite F1" motorsport line is a different, unrelated product - don't conflate. LOW. |
| 301 | Uno Despicable Me 4 | RESKIN | Correction (HXT53): Wild Mega Minions Power, other players discard their action cards with a Mega Minions icon to the bottom of the pile and draw that many. HIGH (sheet). The 2016 deck (FDV57) has "Mutated Minion" (next player draws until your color), not "Evil Minion". |
| 302 | Uno John Deere | RESKIN | Confirmed as a ~2011 licensed tin via resale listings; no bonus-card info found. LOW. |
| 303 | Uno Barbie (Black) (2018) | RESKIN | Cannot pin down this specific SKU - may be confusing a "Fashion Swap" card (name 2 players + a color, they swap all cards of that color) or the unrelated 2023 movie's "Played With Too Much" card with this release. LOW. |
| 304 | Uno FAO Schwarz | RESKIN | Confirmed (~2022, 160th-anniversary collectors box); one unverified customer-review mention of "a special card," no name/effect. LOW-MED. |
| 305 | Vacation Uno | RESKIN | Travel-themed packaging, standard UNO rules. |
| 306 | Uno Happy Birthday | MECHANIC | Blank customizable wild cards. See A5. |
| 307 | Uno Macy's Thanksgiving Day Parade | RESKIN | Follow-up: still no evidence of any kind after a second search pass (only unrelated Macy's balloon-contest/NFT items and the unrelated Mattel "Nonpartisan Uno" turned up). Strengthened to "genuinely seems not to exist." MOD-HIGH. |
| 308 | Uno 30 Year Anniversary | MECHANIC | 42885: 4 Anniversary cards, playable any time on any color or number. Give your whole hand except 1 card to any other player, say "Happy Anniversary!", call UNO, and name the color. Worth 100 points. HIGH (sheet). |
| 309 | Uno Flip Attack | MECHANIC | HXT54: Flip with a launcher. Mild side: Hit 2x, Discard All, Wild Press Your Luck, Reverse, Skip, Wild, Flip. Wild side: Hit 5x, Wild Discard All, Wild All-Out Attack, Reverse, Skip Everyone, Flip. Launched cards can't be played that turn. HIGH (sheet); counts unconfirmed. See A4. |
| 310 | Uno Polly Pocket (2006) | RESKIN | Confirmed: "Rockin' Blockin'" wild card - played normally, each opponent draws 1; or discard it from hand to cancel a Wild Draw Four played against you. MED. |
| 311 | Uno Sesame Street 35th Anniversary | RESKIN | Follow-up: likely a doc-error conflation of two real-but-separate products - confirmed real Sesame Street "My First Uno" editions exist (1991/1992/1994/2002 Elmo King-Size), none branded "35th Anniversary"; the real "Sesame Street 35th Anniversary Game" (2004, Rose Art) is a different, non-UNO trivia board game. MOD-HIGH. |
| 312 | Uno Pittsburgh Steelers Super Bowl XL | RESKIN | Confirmed as a real tin (Sababa Toys); bonus card unknown despite a real search. LOW. |
| 313 | Uno Texas Edition | RESKIN | No generic "Texas Edition" found - likely = the 2005 Texas Rangers MLB deck mislabeled; bonus card unknown either way. LOW. |
| 314 | Uno Barbie California Girl | RESKIN | 42803 (2004 "Barbie UNO"): Beachcomber x4, give one card of each color (up to 4) to any player. HIGH (sheet), MED that this is the deck #314 means. |
| 315 | Uno My Scene | RESKIN | Correction: the product exists (H9022, 2005). Casting Call x4, flip pile cards until two match, then give them all to one player or split them among the others. HIGH (sheet). |
| 316 | Uno Barbie (2013) | RESKIN | Correction: most likely CHL29 (2013 "Barbie Life in the Dreamhouse"), BFF Power x4 blocks a Draw 2/WD4, then you name the color; NOT the HPY59 movie deck. HIGH (sheet), MED mapping. A 2012 deck (T8236) has "Fashion Trend". The earlier merge with #424 is withdrawn. |
| 317 | Uno Super Kick (Germany) | RESKIN | Resolved, corrects the launcher guess: "Kick" = German football slang. A "Die Mannschaft" national-team player-photo deck with a photo-upload-to-jersey online code gimmick - no physical launcher mechanic (that's a different product, UNO Showdown). HIGH. |
| 318 | Uno Ryan's World Pocket Watch | RESKIN | Cosmetic reskin ("Pocket Watch" is the media company, not a mechanic). |
| 319 | Uno Boston Red Sox (2004) | RESKIN | Follow-up: leaning toward the SAME product as #347 below, MEDIUM confidence (not fully nailed down) - no distinct UPC found for 2 separate 2004 SKUs, though Sababa Toys did issue other distinct-year Red Sox/MLB SKUs (2006 UPC 831614008805, 2007 player editions), so the "multiple SKUs across years" pattern is real even if not proven for 2004 itself. No bonus card found either way. |
| 320 | Uno San Antonio Spurs (2006) | RESKIN | CONFIRMED REAL (follow-up): eBay listing - Sababa Toys "Special Edition UNO," Year 2006, Theme NBA, Character Family San Antonio Spurs, UPC 831614005651, sold as a "Collector Case" set. Bonus-card content still not found. HIGH. |
| 321 | Uno NBA Cleveland Cavaliers Lebron James | RESKIN | Follow-up: real but likely mislabeled, MOD-HIGH confidence - a graded-card listing ("2006 Uno NBA Eastern Conference LeBron James Draw 4 PSA 10 Cleveland Cavaliers") shows LeBron/Cavaliers cards are part of a Sababa Toys "Uno: NBA Eastern Conference" (2006) set, parallel to the confirmed Western Conference set - not a standalone Cavaliers-only product; the doc's title likely describes it team-first rather than by its real conference-based name. |
| 322 | Uno Wellie Wishers | RESKIN | Confirmed as a 2017 Mattel tin via eBay; bonus card plausible (per Mattel's general tin-edition pattern) but unconfirmed for this specific title. LOW-MED. |
| 323 | Uno Shopkins | RESKIN | CONFIRMED REAL (follow-up): eBay.de listing - "UNO Kartenspiel Shopkins Edition mit Sammeldose" (with collectible tin/can). Bonus-card content still not found. HIGH. |
| 324 | Uno Hotwheels (2014) | RESKIN | BGG53: Wild Super Charged (see #195, same SKU as #476). HIGH (sheet). |
| 325 | Uno Doraemon (2016) | RESKIN | Existence loosely confirmed (fandom-wiki reference to a Japan-only release); bonus card unconfirmed. LOW. |
| 326 | Uno Sock Monkey | RESKIN | Follow-up: still no evidence found in any search angle (direct, Fundex, BGG). Strengthened to "genuinely seems not to exist." MOD-HIGH. |
| 327 | King Size Uno (With Free Turn) | MECHANIC | Unverified: no King Size UNO with a Free Turn card found. LOW. |
| 328 | Uno Moomin (2024) | RESKIN | Existence unconfirmed directly; bonus card unconfirmed, though plausibly part of the 2024 "UNO Fandom" wave pattern (see #330/#336) given the matching year - not verified as actually belonging to that line. LOW. |
| 329 | Uno Lilo and Stitch (2024) | RESKIN | Confirmed (Mattel JCC10): "Ohana" hand-equalizing rule/card - any player with >4 cards discards down to 4, any player with <4 cards draws up to 4 ("Ohana means family" - everyone ends with an equal "family"). MED. |
| 330 | Uno Fandom Masters of the Universe | RESKIN | Correction: the Fandom MOTU deck is HYH55, not GVY91. Its rule is "The Armory of Grayskull" (collect Action Cards). MED (box art). GVY91's Power of Greyskull belongs to #149; the 2026 movie deck (JMF11) has Wild Power Sword (play up to 2 cards a turn while you hold it). |
| 331 | Uno Fandom Star Trek | RESKIN | JBD86: "Mirror, Mirror" rule, forcing others to draw. MED (box art); the product page links the wrong sheet. |
| 332 | Uno Fandom Harry Potter Gryffindor | RESKIN | JBD82: "Sword of Godric Gryffindor" rule, compelling others to draw. MED (box art). Each house deck has its own rule. |
| 333 | Uno Fandom Harry Potter Slytherin | RESKIN | JBD85: "Parseltongue" card, the last player to hiss draws. MED (box art). |
| 334 | Uno Fandom Harry Potter Ravenclaw | RESKIN | JBD84: confirmed real; "Salvio Hexia" rule blocks a "spell". MED (box art). |
| 335 | Uno Fandom Harry Potter Hufflepuff | RESKIN | JBD83: "Protego Maxima" rule protects others from drawing. MED (box art). |
| 336 | Uno Fandom Avatar The Last Airbender | RESKIN | JBD87: with all 4 colors in hand, play the Avatar State Wild any time, even out of turn; choose a color, play a card of that color, and play resumes from you. HIGH (sheet). |

### #337–420

| # | Title | Category | Mechanic Notes |
|---|-------|----------|-----------------|
| 337 | Uno Diary of a Wimpy Kid (2010) | RESKIN | Conflict: the Fundex manual (MED-HIGH) describes 4 yellow "Cheese Touch" cards, playable only on yellow, where the next player draws 2, plus 2 more if they have no yellow to play; then it acts as a normal yellow card, 50 pts. A fan site (LOW-MED) instead describes a Wild where everyone reveals yellows and holders draw 2. Prefer the Fundex version. |
| 338 | Uno Diary of a Wimpy Kid (2012) | RESKIN | Possibly a later printing of #337; only the Fundex edition was found, so whether 2010 and 2012 are distinct products (or carry different Cheese Touch rules) is unresolved. LOW. |
| 339 | Uno Attack Mega Hit | MECHANIC | The 2020 Attack sheets (GXY81/GNL02): a Mega Hit starts with Wild Attack-Attack; any Hit card can be stacked on any Hit; the next player must add a Hit or do all the presses; play resumes after the first Hit player; you may stop pressing once cards fire. HIGH (sheet). See A2/A5. |
| 340 | Uno Pocket Geox | MECHANIC (minor) | Correction: not standard rules. A real Geox-branded Mattel UNO Pocket in a metal tin (MED), i.e. the reduced half-size Pocket format (see A6). A Casio 2024 promo page gives the Pocket deck as 56 cards, not the 52 stated in A6. Composition unconfirmed. MED. |
| 341 | Uno Disney Channel | RESKIN | Likely = the 2007 Mattel "Hannah Montana" UNO (a confirmed Disney Channel tie-in); BGG notes "two special cards that change the game play" but doesn't name or describe them. LOW-MED. |
| 342 | Uno Arby's Wild Jackpot | MECHANIC | Promo tie-in to Wild Jackpot (#27). Correction: Wild Jackpot has no shared pile; its mechanic is the Wild Roller and player-written rule cards (see A5). Whether this promo deck ships any of that is unverified. LOW. |
| 343 | Uno Max Steel (Red Box) | RESKIN | Follow-up: likely a doc error, MODERATE confidence - confirmed a real Mattel 80th-Anniversary "Ruby Red" multi-IP box (Hot Wheels, Barbie, Rock 'em Sock 'em Robots, Scrabble, Magic 8 Ball) exists, but Max Steel is NOT among its listed graphics - likely source of the confusion. |
| 344 | Uno American Girl (2020) | RESKIN | CONFIRMED REAL (follow-up): multiple consistent eBay listings - Brand Mattel, "American Girl Uno," Year 2020, Theme Dolls, Character Family American Girl. Bonus-card content still not found. HIGH. |
| 345 | Uno Pinkalicious | RESKIN | CONFIRMED REAL (follow-up): Board Game Oracle listing - "Uno: Pinkalicious," 2010, Publisher Fundex (Mattel-licensed), 2-10 players, ages 7+. Bonus-card content still not found. HIGH. |
| 346 | Uno NDJOLIJEAN | MECHANIC | HYC81: Shuffle Hands and Make Your Own Rule Wilds; discarding several cards that share a number or symbol at once, with multiple action cards all taking effect together. MED-HIGH (Mattel store copy). |
| 347 | Uno World Series Champions 2004 Boston Red Sox | RESKIN | Follow-up: leaning toward the SAME product as #319 above, MEDIUM confidence - see #319 for the shared evidence. The "World Series Champions" wording reads as incidental marketing phrasing (2004 was literally the year Boston won it) rather than evidence of a second distinct SKU, but no UPC-level proof either way was found. No card/rule info found. |
| 348 | Uno Philadelphia Eagles (2006) | RESKIN | Standalone 2006 single-team edition unconfirmed; the modern multi-team UNO NFL line has a documented "Ice the Kicker" mechanic (see #298), but attributing it to a one-off 2006 Eagles tin is unverified. LOW-MED. |
| 349 | Uno New York Yankees Derek Jeter | RESKIN | Correction (2007, Sababa Toys, part of a 9-player MLB line): a unique named "Captain" card exists for this deck specifically (each player in the line has their own uniquely-named card), exact effect not found. MED. |
| 350 | Mein Erstes Uno (Germany) | MECHANIC | German UNO Junior. Correction (GKF04): Junior has 56 cards (36 animal cards 0-8, plus 4 each of Draw 1, Draw 2, Skip, Reverse, Wild), deal 5; three levels add actions then penalties. HIGH (sheet). See A6. |
| 351 | Uno Artlist Collection The Dog Special Edition (2003) | RESKIN | Confirmed real (2003 Mattel); no bonus card found, distinct from the later Artiste Series (Haring/Basquiat) decks which do add a matching rule. LOW. |
| 352 | Uno Artlist Collection The Dog Special Edition (2006) | RESKIN | Reissue of #351. |
| 353 | Uno Chicago Cubs (2006) | RESKIN | Correction (year disputed: 2004/2006/2007 all cited): named "Acquisition cards" and rules are confirmed to exist, exact effect not found. MED. |
| 354 | Uno Madness | DIFFERENT-GAME | Perfection-style spring-loaded spiral tray/timer game. See A10. |
| 355 | Uno Utterly Butterly Omega 3 | RESKIN | UK margarine-brand promo pack, standard UNO rules. |
| 356 | Uno Elvis | RESKIN | Correction (2000 Mattel tin #42541): a named "Vegas card" exists (wild-type, grouped with Wild Draw Four per a dedicated rules site), exact effect not found. MED. |
| 357 | Uno Sumikko Gurashi | RESKIN | Existence itself unconfirmed despite Japanese-language searches. Ensky-pattern character decks (Chiikawa, see #413) typically carry 4 bonus cards - plausible if real, but unconfirmed. LOW. |
| 358 | Uno NFL Greatest Stars Reggie Bush | RESKIN | Follow-up: still no evidence - searched both real UNO NFL lines (standard + "UNO Elite NFL") and Reggie Bush memorabilia directly, only ordinary non-UNO trading cards (Score/Topps/Upper Deck) found. LOW. |
| 359 | Uno Emoji | MECHANIC | Face-holding action card + blank house-rule wild. See A8. |
| 360 | Uno 2000 Italian Ferrari | RESKIN | Follow-up: still unconfirmed - found a real multilingual (German/French/Italian) standard Mattel deck, a "2000's Y2K" 50th-Anniversary deck, and the genuine, much more recent UNO Formula 1 edition (its own "Overtake" rule, don't attribute it here) - none Ferrari-specific. Likely conflation with one of these. LOW-MED. |
| 361 | Uno Platica Polinesia | MECHANIC | Unverified: no source mentions this product. Existence in question. LOW. |
| 362 | Uno Junior Move! | MECHANIC | Correction: Junior Move! is HNN03 (HPY62 is Junior Paw Patrol). 32 numbers 1-8, 20 actions, 4 MOVE! cards; Star cards make the player do a physical action. HIGH (sheet). See A6/A8. |
| 363 | Uno Boost | DIGITAL-ONLY | Resolved: a Facebook browser game (~2010-2011), 2-player vs AI. "Boost" mechanic lets you substitute powerful cards into your hand from a sideboard, paid for with earned/purchased virtual currency; wins grant XP unlocking harder AI. HIGH real/digital, MED on exact publisher. |
| 364 | Uno Famicom / Super Uno | DIGITAL-ONLY | Dev. Tomy, 1993, Japan-only. Up to 6 players, official +2/+4 stacking predating Mattel's own house rules, and a Board Game mode (5 boards, items, UNO-hands-as-battles). See Part E4. |
| 365 | Uno Stacko (1994) | DIFFERENT-GAME | Original Jenga-style block tower + die. See A10. |
| 366 | Uno Rush | DIGITAL-ONLY | Dev. Carbonated Games, 2009. Auto-plays a pre-sorted hand under time pressure, all hands visible, + a Shuffle card. See Part E1. |
| 367 | Uno Arby's Get Wild 4 Uno Plus Glow-In-The-Dark Stickers | RESKIN | Unverified: two searches found no Arby's UNO promo at all. The title ("Get Wild 4" with make-your-own-wild stickers) suggests standard rules plus blank wilds rather than any Wild Jackpot mechanic. LOW. |
| 368 | Uno House Rules | MECHANIC | Standalone player-authored dynamic rule-set. See A1/A5. |
| 369 | Uno Deluxe House Rules | MECHANIC | Official wording (41940): Jump-In = an identical card played out of turn cancels the first card and play continues from the jumper (it never adds to a stack); Seven-O; Progressive = same draw type only, one per turn, the last WD4 player names the color. HIGH (sheet). See A1. |
| 370 | Uno Fun Pack (Germany) | RESKIN | Resolved: standard 108 cards + a spare blank card + 3 German-language "Fun-Regeln" house-rule cards bundled in - a minor packaging/rules-card variant, not a themed reskin. MED-HIGH. |
| 371 | Uno The Batman (2006) | RESKIN | J3799 (2006), 108 cards, no plain Wilds: Wild Villain x4 (next player must play a card with the weapon that beats that villain, or draw 3) and Utility Belt WD4 x4 (beats any villain). HIGH (sheet). |
| 372 | Uno Ito Family's Dining Table | MECHANIC | Unverified: no UNO tie-in found for the TV show (correct name 伊東家の食卓, Itō-ke no Shokutaku). The 12 variants couldn't be listed. LOW. |
| 373 | Uno Sudoku | DIFFERENT-GAME | UNO-branded Sudoku puzzle. See A10. |
| 374 | Uno Mobile (Mattel163) | DIGITAL-ONLY | 7 named house-rule toggles + Ranked/2v2 modes (wagering excluded, see roadmap); "Survival" mode could not be confirmed to exist. See Part E3. |
| 375 | Uno 2 Go / Uno Wonder | DIGITAL-ONLY | Same game, renamed on 2025 global launch. 9 named new action cards + 14-route/3000+-level Story Mode. See Part E3. |
| 376 | Uno & Friends (Online) | DIGITAL-ONLY | Gameloft 2013, distinct from the 2012 version (#243). Tournaments, 2v2, ~31 companions with real activatable powers, leaderboards. See Part E3. |
| 377 | Eres Un Experto Jugando A UNO Showdown? (Flash Game) | UNKNOWN | Still unresolved after a second dedicated search. New supporting evidence: the parent product "UNO Showdown" (GKC04) / "Showdown Supercharged" (GMX56) is solidly real with confirmed Spanish-market distribution (a Spanish-language GMX56-SP.pdf instruction sheet found) - supports this being a since-vanished promotional Flash tie-in (Flash-era content is largely de-indexed post-2020) rather than a doc error. Stays UNKNOWN per standing permission. |
| 378 | Uno Show 'Em No Mercy Expansion Pack | MECHANIC | JJB29: five card types (10's Play Again, Wild Discard All, Wild Reverse Draw 8, Wild Final Attack, Wild Sudden Death) plus 6 two-sided Mercy/No Mercy coins, one use per game. Mercy = your hand goes under the discard pile and you draw 7; No Mercy = double one Draw card's value, which counts for stacking. HIGH (sheet). See A2. |
| 379 | Uno Golf | DIFFERENT-GAME | Face-down grid-based scoring variant. See A9. |
| 380 | Uno Truth Adults Only | MECHANIC | Truth/Wild Truth cards + die + question list. See A8. |
| 381 | Uno Spin (2025) | MECHANIC | JGR00: 24 Spin cards (20 numbered 1-5 + 4 Wild); the player who PLAYED the Spin card spins (unlike 2005). Outcomes: Color Draw, Wild Color Draw, Color Discard (to the bottom of the pile), Swap Hands with one chosen player, 2x (everyone plays 2 cards until the next spin). HIGH (sheet). See A5. |
| 382 | Uno Spin Adults Only | MECHANIC | JJB31: the player of the Spin card spins. Wheel: Draw 2, Target Draw 2, Discard 2, Discard All (choose a color), Flip for Number, Target Challenge, Challenge A/B/C; failing or refusing a challenge = draw 4. 16 Challenge cards. HIGH (sheet). See A5/A8. |
| 383 | Uno Braille | ACCESSIBILITY | Braille + colorblind-friendly icon markings. See A11. |
| 384 | Radica: Uno 360 | DIGITAL-ONLY | NOT standard rules digitized - 4 discard piles selected by physically rotating the handheld, plus a timed UNO-call penalty. Same family as Triple Play (A5). See Part E4. |
| 385 | Uno SuperLite 2000 Vol. 16 Game | DIGITAL-ONLY | Japan-only budget PS2 reissue (Success), anime art/VO added; no rule difference found. See Part E4. |
| 386 | Uno Party Mania! | MECHANIC | Ubisoft DLC: Point Taken, Wild Drawn Together, Wild Pile Up. |
| 387 | Uno Disney Princess (2002) | RESKIN | B3280 (2006 "Disney Princess UNO", 110 cards): Dragon x2, each other player discards a Prince card or draws until they can. HIGH (sheet), MED mapping (2006, not 2002). |
| 388 | Uno Harry Potter (2003) | RESKIN | Same product as #36 (Mattel 42797): Howler and Invisibility cards plus Draw Threes, not Sorting Hat. HIGH (sheet). |
| 389 | Uno National Parks | RESKIN | Confirmed (Sababa Toys, proceeds to the National Park Foundation): a named "exclusive bear alert card" exists, exact effect not found. MED. |
| 390 | Uno Show 'Em No Mercy (Ubisoft) | DIGITAL-ONLY | Digital adaptation of the full No Mercy ruleset. See A2. |
| 391 | Uno Choo Choo | MECHANIC | T8234: 28 cards (5 animals x 4 colors, 4 Raccoon Draw 1, 4 Conductor Wild); match color or animal; deal 5; a drawn card may be played at once. HIGH (sheet). See A6. |
| 392 | Seikin Uno (Japan) | RESKIN | Resolved: SEIKIN (Japanese YouTuber/musician) named Mattel Games' official Japan ambassador Jan 11 2023 ("UNO Day"); limited "SEIKIN Cards"/"SEIKIN Dice" promo items with original SEIKIN-devised house rules shipped alongside. HIGH. |
| 393 | Uno NSYNC | RESKIN | Confirmed (2000 Mattel #42810, bundled with a Justin Timberlake CD); no bonus card found despite confirmed product details - plausibly a genuine plain reskin plus bundled novelty CD. LOW-MED. |
| 394 | Uno University of North Carolina | RESKIN | Follow-up: upgraded to "unconfirmed but plausible," MEDIUM confidence - confirmed a real sibling product, Entertainment Earth's (discontinued) "Uno University of Southern California Game," proving Mattel ran a short collegiate-licensed UNO line a UNC entry would fit. |
| 395 | Uno Ultimate Thanos Promo Card | MECHANIC | Unverified: no Mattel sheet or rules text found. LOW. See A7. |
| 396 | Uno New York Knicks Special Edition (2006) | RESKIN | Follow-up: upgraded to "unconfirmed but highly plausible," MED-HIGH confidence - fits the confirmed Sababa Toys "Special Edition" sports-tin family (NY Yankees 2005/2006, NY Mets 2007, Boston Red Sox 2007, NBA Western/Eastern Conference 2006) even though no direct Knicks listing surfaced. |
| 397 | Uno Fandom Monster High | RESKIN | HYH54: "Wild Frankie's Hand", swap a card with your beastie. MED (box art). Distinct from #426. |
| 398 | Uno Magic Tree House | RESKIN | Follow-up: upgraded to "likely real," MED-HIGH confidence - found a specific eBay listing, "Uno Magic Tree House Card Game EUC RARE," a concrete collector listing rather than a generic hit. Publisher/year still unconfirmed. |
| 399 | Uno Pocket Sunset Boulevard | UNKNOWN | Still unresolved after a second dedicated search. New supporting evidence: "Uno Pocket" is further confirmed as a real, brand-promiscuous recurring giveaway family - 2 more instances found (a 2024 Casio gift-with-purchase, a 2022 Pizza 73 tie-in distinct from the full-size Pizza 73 "UNO Combo" promo already in the doc). No connection to "Sunset Boulevard" found in any form. Stays UNKNOWN per standing permission. |
| 400 | Uno Master | MECHANIC | Correction: not Masters of the Universe (that is #149/#330). This is the 1997 Spear's Games "UNO Master" electronic turn timer (also called Uno Time / Uno Slam): standard UNO, but you must play or draw and hit the button within 8/6/4 s (easy/medium/hard) or draw 4. HIGH. Fits the turn-timer row in A5. |
| 401 | Uno Xbox 360 Live | DIGITAL-ONLY | Not a separate SKU - these are features of #113's same 2006 release (literal webcam video chat + 4 enumerated theme decks). See Part E1. |
| 402 | Uno McDonald's 2007 | RESKIN | Follow-up: still unconfirmed for this date/market. Found real but mismatched McDonald's UNO promos in other years/markets (UK DreamWorks promo, 2026 Japan My Hero Academia/Spy x Family promo) plus a real but different 2007 McDonald's Shrek the Third trivia card game (not UNO) - possible year/product conflation. LOW-MED. |
| 403 | Uno ColorADD | ACCESSIBILITY | Colorblind ColorADD symbol markings. See A11. |
| 404 | Uno Arcade Edition (Apple Arcade) | DIGITAL-ONLY | Dev. Mattel163, June 2025. Single Player/Quick Match/Custom Games; new cards incl. Wild Swap Hands, Double Discard All. See Part E3. |
| 405 | Uno Teams! | MECHANIC | HXT58: partners sit across from each other and each passes one card to their partner at the start. Wild Team Play (skip to your partner; you draw 2 if they can't play), Wild Team Draw Four (next player and their partner draw 2 each, even if out). Going out: your partner passes you half their hand; an out player tags back in by receiving half of whatever their partner later draws. HIGH (sheet). See A3. |
| 406 | Uno Show 'Em No Mercy Deadpool | MECHANIC | Edition confirmed (Target exclusive per fan wiki). Adds a Wild Reverse Draw Ten to the No Mercy deck, plus three more new wilds per retail listings: Gimme!, Maximum Effort, and Rock-Paper-Scissors-Shoot!. HIGH (edition, Maximum Effort), MED (the rest), effects not found. By analogy to No Mercy's Wild Reverse Draw 4, Reverse Draw Ten most likely reverses, the new next player draws 10, and it stacks (LOW). |
| 407 | Uno Show 'Em No Mercy Deadpool Reverse Draw 10 Promo Card | MECHANIC | Likely the SDCC 2024 exclusive foil promo card from the Deadpool No Mercy line (see #406). LOW-MED that it is specifically the Reverse Draw 10. |
| 408 | Uno Elite NFL Core Edition (2024) | MECHANIC | JDM38: each player's Lineup is 3 face-up cards from an 8-card Player Deck. Playing an Elite-icon card of a lineup card's color may activate it (once: the card is discarded, the Lineup refills, and your turn ends). Player-card actions use icons (Skip, Reverse, Draw N, Peek, Play Again, Discard, Recover, Swap). Wild Foil = all 4 colors; no point system. HIGH (sheet); individual player powers unconfirmed. See A7. |
| 409 | Uno Elite NFL Draft Expansion Pack (2024) | MECHANIC | More Player Cards for the Elite Icon system. |
| 410 | Uno Beetlejuice Beetlejuice | RESKIN | Confirmed (2024 Mattel/WB film tie-in): "Beetlejuice Beetlejuice Beetlejuice" card - draw 3, give them to a chosen opponent while saying "Beetlejuice" three times (sources differ slightly on exact penalty wording). MED. |
| 411 | Uno Crayon Shinchan (Japan) | RESKIN | Confirmed (Ensky, ¥1,250); no special card confirmed, though plausible by Ensky-pattern analogy. LOW-MED. |
| 412 | Uno One Piece (2024) (Japan) | RESKIN | Resolved (Product D of 4 distinct One Piece UNO releases, see #139/#271/#272): consistently dated November 2024 across multiple independent Japanese retailers (Joshin, Jumpichiban, japan-figure.com), ¥1,760, 112 cards, confirmed to ship 4 original special rule cards - a separately-dated, separately-sold Ensky printing distinct from Product C (#272, 2016), not a re-listing of it. Exact card names/effects still not found despite Japanese-language searches. MED existence/distinctness, LOW-MED on exact card content. |
| 413 | Uno Chiikawa (Japan) | RESKIN | Confirmed (Ensky, Aug 2024): "Shooting Star" (流れ星) card - lets you chant a wish (up to 3 times per the source), exact trigger/resolution mechanics beyond that not confirmed. MED. |
| 414 | Uno Fandom Batman The Animated Series | RESKIN | JDJ98: "Arkham Asylum" Wild, skip the next player, who chooses the color. MED (store copy + box art). |
| 415 | Uno Fandom Batman Batmobiles & Gadgets | RESKIN | JDJ99: Wild Batman Bomb, collect all OTHER players' cards, shuffle, and redeal them evenly to those players; your own hand is untouched. HIGH (sheet). |
| 416 | Uno Fandom Batman Classic TV Series | RESKIN | JDJ97: choose a color; every later play of that color needs a sound effect or the player draws 1. MED (store copy + box art). |
| 417 | Uno Moana 2 | RESKIN | Confirmed (2024 Mattel): "Wild Wayfinder" - search the draw pile top-to-bottom for a Draw Two/Four card and place it on the discard pile. MED. |
| 418 | Mini Uno Bullseye | MECHANIC | Choose-the-target ("Bullseye") rule. See A3. |
| 419 | Uno Add-On Packs! Speed Pack | MECHANIC | JCV57: 12 colored number cards with a Speed Up icon + 4 Wild Double Speed Up. Each icon raises the speed level from the next player on; at level N you must chain N cards, each matching the previous; only the last card's action fires; failing = draw N and the level resets to 1. HIGH (sheet). See Part C roadmap. |
| 420 | Uno Add-On Packs! Swap Pack | MECHANIC | JCV59: Swap 1, Refresh Hand, Wild Force Trade, Wild Pass Hands (4 each per package art). The implemented version differs in three ways (see A3). HIGH (sheet). |

### #421–484

| # | Title | Category | Mechanic Notes |
|---|-------|----------|-----------------|
| 421 | Uno Add-On Packs! Reverse Pack | MECHANIC | JCV56: Reverse Draw 2, Reverse Skip, Wild Power Reverse, Wild NO U (played in response to a Draw card, the player who played the Draw card takes the penalty). HIGH (sheet). See A2. |
| 422 | Uno Add-On Packs! Stack Pack | MECHANIC | JCV58: Stack 1 and Stack 2 (colored; stack onto a Draw card of the same color), Wild Stack 3, Wild Stack Number (flip until a number card; flipped cards go under the discard pile). Stack-on-Stack ignores color. HIGH (sheet). See A2. |
| 423 | Uno Pixar (2025) | RESKIN | Confirmed MERGE into #260: same Mattel SKU (GVP47, official instruction sheet carries a (c)2020 notice) - "2025" is just a reseller re-listing of a continuously-stocked catalog item, not a new SKU. See #260 for the "Pixar Pop Quiz" mechanic. HIGH. |
| 424 | Uno Barbie (2025) | RESKIN | Same SKU as #165 (HPY59, 2023 Barbie The Movie), not #316 (corrected merge). HIGH (sheet). |
| 425 | Uno Fandom She-Ra Princess of Power | RESKIN | JFP10: Wild "Unite Etheria" (draw a card / discard two / players try to match your card). Name MED, procedure LOW. |
| 426 | Uno Fandom Monster High Fearbook | RESKIN | JFP08: all other players show a matching "Fearbook" pair or draw until they can. MED (store copy + box art). Distinct from #397. |
| 427 | Uno The Quintessential Quintuplets (Japan) | RESKIN | Follow-up: upgraded to "likely doesn't exist," MED-HIGH confidence - confirmed the real "五等分の花嫁カードゲーム" is an UNRELATED Bushiroad original TCG (launched Oct 2024), not an UNO product. Probable brand/franchise conflation. |
| 428 | Uno Expo 2025 (Japan) | MECHANIC | 4 "WORLD" cards (Ensky, Myaku-Myaku art): the player declares red or blue; until a Wild or Wild Draw Four is discarded, only red/blue cards, Wilds or WORLD cards may be played. MED. |
| 429 | Uno Blue Lock (Japan) | RESKIN | Follow-up: still no evidence found in English or Japanese searches. Leaning "doesn't exist." LOW. |
| 430 | Uno Fandom Star Wars Troopers | RESKIN | JCW38: Wild Called Shot. The target names a color; if you hold it, they take one of your cards of that color. HIGH (sheet). |
| 431 | Uno Fandom Star Wars Posters | RESKIN | JCW36: Wild My Favorite Line. Name a movie; each player in turn quotes it; the first to fail draws 3. HIGH (sheet). |
| 432 | Uno Fandom Star Wars Droids | RESKIN | JCW39: Wild Let's Build a Droid. Players chain cards of different colors; whoever breaks the chain draws 3 and the laid cards return to hands. HIGH (sheet). |
| 433 | Uno Demon Slayer (Japan) | RESKIN | Confirmed (Ensky "Devil Blade" accessory deck, April 2025): ships 4 exclusive/secret special rule cards (2 independent sources agree on the count), exact names/effects not found. MED. |
| 434 | Uno Superman (2025) | RESKIN | Confirmed (distinct from the 2024 "Ultimate DC" and Batman 35th Anniversary decks): "Kryptonite" Wild Rule targeting green cards - sources disagree whether it sends all green cards in play to one opponent or strips green cards from every hand. MED. |
| 435 | Uno Simpsons (2009) | RESKIN | Follow-up (REVERSES the earlier duplicate flag): deeper research found a long, genuine Simpsons UNO reprint history (2001/2003/2005/2007/2025, see #259/#483), so this is likely NOT the same SKU as #483 or #259 after all. "2009" itself matches no confirmed release year found (2001/2003/2005/2007/2025 are all documented, 2009 is not) - probably a mis-dated reference to one of the real editions (2007 Sababa Toys is closest temporally), but which one is unconfirmed. No bonus card pinned to this specific date. MEDIUM. |
| 436 | Uno Card Premium Pack With A UNIQUE Uno Card Box | RESKIN | Collector packaging item, standard UNO rules. |
| 437 | Uno Jurassic World Rebirth | RESKIN | JFT28: Wild Attack of the T. Rex, name a color; players reveal it in turn until one can't (they draw 5); if it comes back to you, you draw 5. HIGH (sheet). |
| 438 | Uno Chainsaw Man Reze Arc (Japan) | RESKIN | Confirmed (Ensky-style, July 2025); ships 4 original special rule cards (2 sources agree on count), exact names/effects not found. LOW-MED. |
| 439 | Uno Jujutsu Kaisen (Japan) | RESKIN | Confirmed (Ensky, late Aug 2025, ¥1,540); ships 4 original special rule cards (Ensky house pattern), exact names/effects not found. LOW-MED. |
| 440 | Uno Fandom NFL Jacksonville Jaguars | MECHANIC | JDK20: own team rule, "Duuuval Double" rule. "Yell a cheer quickly or you may be drawing cards". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 441 | Uno Fandom NFL Cincinnati Bengals | MECHANIC | JDK15: own team rule, "Who Dey" rule. "may have other players drawing and discarding cards". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 442 | Uno Fandom NFL New Orleans Saints | MECHANIC | JDK09: own team rule, "March In" rule. "Other players must show the right color or draw cards". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 443 | Uno Fandom NFL Buffalo Bills | MECHANIC | JDK00: own team rule, "Hall of Fame QB" rule. "'Pass' a card the furthest to avoid drawing 2 cards". (a dexterity flick, physical only) MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 444 | Uno Fandom NFL Las Vegas Raiders | MECHANIC | JDK21: own team rule, "Just Win, Baby" rule. "Force other players to draw extra cards". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 445 | Uno Fandom NFL Minnesota Vikings | MECHANIC | JDK08: own team rule, "Skol Vikings" rule. "may have players drawing cards after they form a Viking's 'V'!" (a gesture race) MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 446 | Uno Fandom NFL Los Angeles Chargers | MECHANIC | JDK22: own team rule, "CHARGE!" rule. "The last player to discard may have to draw cards". (a discard race) MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 447 | Uno Fandom NFL Los Angeles Rams | MECHANIC | JDK07: own team rule, "Horns Up!" rule. "'Ram' back the last card to the previous player". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 448 | Uno Fandom NFL Green Bay Packers | MECHANIC | JDK06: own team rule, "Team Ownership" rule. "Give away your hand and then get a new one". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 449 | Uno Fandom NFL New York Giants | MECHANIC | JDK10: own team rule, "Helmet Catch" rule. "will force another player to hold a card up to their head!" MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 450 | Uno Fandom NFL Seattle Seahawks | MECHANIC | JDK11: own team rule, "The 12s" rule. "Yell 'Sea-Hawks' in your best 12th Man voice or draw cards". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 451 | Uno Fandom NFL Tampa Bay Buccaneers | MECHANIC | JDK12: own team rule, "Buc's Cannon" rule. "Force opponents to draw cards". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 452 | Uno Fandom NFL Houston Texans | MECHANIC | JDK18: own team rule, "Battle Red" card. "Players who can't play red must draw cards when you play the 'Battle Red' card." MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 453 | Uno Fandom NFL Detroit Lions | MECHANIC | JDK05: own team rule, "Defend the Den" rule. "Dodge opponents' Action Cards". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 454 | Uno Fandom NFL Baltimore Ravens | MECHANIC | JDK14: own team rule, "Ravens Flock" rule. "Force other players to skip their turn". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 455 | Uno Fandom NFL Tennessee Titans | MECHANIC | JDK25: own team rule, "Music City Miracle" rule. "Lateral a card to another player". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 456 | Uno Fandom NFL Atlanta Falcons | MECHANIC | JDK02: own team rule, "Dirty Bird" card. "Do the dance when you play the Dirty Bird Card to make other players draw cards!" MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 457 | Uno Fandom NFL Cleveland Browns | MECHANIC | JDK16: own team rule, Wild Dawg Pound. "Whenever another player plays their next-to-last card and calls 'UNO!', play this card (on your turn) and force them to draw 2 cards! This is also a Wild Card." HIGH (sheet). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 458 | Uno Fandom NFL Denver Broncos | MECHANIC | JDK17: own team rule, "Mile-High Salute" rule. "Match cards with another player and discard". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 459 | Uno Fandom NFL Carolina Panthers | MECHANIC | JDK03: own team rule, "Keep Pounding" rule. "Play an extra card on your turn". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 460 | Uno Fandom NFL Chicago Bears | MECHANIC | JDK04: own team rule, "Super Bowl Shuffle" rule. "Shuffle all hands and then deal them back". (Shuffle Hands) MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 461 | Uno Fandom NFL New York Jets | MECHANIC | JDK24: own team rule, "Broadway Beatdown" rule. "Make another player draw cards until they get a green one". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 462 | Uno Fandom NFL Arizona Cardinals | MECHANIC | JDK01: own team rule, "Rise Up Red Sea" rule. "Players without a red card may have to draw cards". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 463 | Uno Fandom NFL Indianapolis Colts | MECHANIC | JDK19: own team rule, "Stampede" rule. "Force opponents to draw cards". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 464 | Uno Fandom NFL Miami Dolphins | MECHANIC | JDK23: own team rule, "Perfect Season" rule. "Play sequential cards one after another". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 465 | Uno Fandom NFL Washington Commanders | MECHANIC | JDK13: own team rule, "Hog's Wild" rule. "Force your opponents to draw 1 card". MED (box art). Each Fandom NFL deck has a different rule, not one shared mechanic; see docs/mechanics/08. |
| 466 | Uno Fandom NFL Super Bowl LIX Eagles (2025) | MECHANIC | JKB93 (with a Chiefs twin, JKB92): Wild "touchdown!" rule that may force an opponent to draw 3 extra cards, plus 1 alt-art foil. MED (store copy + box art). |
| 467 | Uno Elite NFL Core Edition Starter Pack (Viper Cards) (2025) | MECHANIC | Elite Icon system; Viper foil counts as all 4 colors. See A7. |
| 468 | Uno Elite NFL Core Edition Starter Pack (Kaleidoscope Cards) (2025) | MECHANIC | Elite Icon system; Kaleidoscope rarity tier, rule-uniqueness unconfirmed. |
| 469 | Uno Elite NFL Core Edition Booster Set (Viper Cards) (2025) | MECHANIC | Elite Icon system, booster format. |
| 470 | Uno Elite NFL Core Edition Booster Set (Kaleidoscope Cards) (2025) | MECHANIC | Elite Icon system, booster format. |
| 471 | Uno Elite NFL Core Edition Booster Set Plus (Viper Cards) (2025) | MECHANIC | Elite Icon system, larger booster format. |
| 472 | Uno Elite NFL Core Edition Booster Bundle (Kaleidoscope Cards) (2025) | MECHANIC | Elite Icon system, bundle format. |
| 473 | Uno Elite NFL Alt Jerseys Edition Starter Pack (Hypnotic Cards) (2025) | MECHANIC | Elite Icon system; Hypnotic rarity tier, rule-uniqueness unconfirmed. |
| 474 | Uno Elite NFL Alt Jerseys Edition Booster Set Plus (Hypnotic Cards) (2025) | MECHANIC | Elite Icon system, booster format. |
| 475 | Liar's Uno Trust No One | MECHANIC | Retagged from DIFFERENT-GAME: JLH43 is UNO with face-down "Liar's" plays. Almost every card (numbers and actions) is a Liar's card; you announce what you played. Any player may challenge before the next turn starts: a caught liar takes the card back and draws 1; a wrong challenger draws 1; an unchallenged claimed action takes effect. 7-0 is always on. HIGH (sheet). See A8. |
| 476 | Uno Hotwheels (Italy) (2021) | RESKIN | Confirmed MERGE into #324: same Mattel SKU (BGG53), not a distinct Italian edition - no Italy-exclusive SKU/box variant found. The "Italy/2021" mix-up likely stems from an unrelated real 2021 Hot Wheels '32 Ford DIE-CAST CAR in UNO-themed livery (part of a "Mattel Games Mini Collection" tied to UNO's 50th anniversary) that got Italian press coverage - a toy car, not a card game, and a red herring for this entry. MED. |
| 477 | Uno Attack On Titan (Japan) | RESKIN | Follow-up: upgraded to "likely doesn't exist," MEDIUM confidence - the only hit this time was an UNRELATED Shiseido men's skincare brand "uno" that ran AoT-themed ad videos, a brand-name false positive. Also not the unrelated "Union Arena" AoT trading-card game found in the previous pass. |
| 478 | Uno Add-On Packs! Billie Eilish | MECHANIC | JHG45: Wild Pass Color (everyone passes all cards of a chosen color to the LEFT), Trick Wild (if the next player can't play that color you may play again), Wild Color Challenge (others show the color or draw 2; if all can, you draw 3), Reverse Hands (everyone plays with hands face up until your next turn). Every card has colorblind symbols. HIGH (sheet). See A8/A11. |
| 479 | Uno Wednesday | RESKIN | Correction (JHB18): Wild Black is My Happy Color, the next player must play a black Wild (Wild, WD4 or this card); if they can't, they draw 1, lose their turn and the rule passes on; it ends if it returns to you. HIGH (sheet). |
| 480 | Uno Fandom Gremlins | RESKIN | JLG94: declare a color; every other player draws and reveals 1 card; each player whose card matched draws N more (N = the number of matches). Number cards score a flat 5. HIGH (sheet). |
| 481 | Uno Fandom Chucky | RESKIN | JLG92: "Amulet", turn any card in your hand into any card in the deck. MED (store copy + box art). |
| 482 | Uno Wicked | RESKIN | Confirmed (2025 Mattel film tie-in): special rule "Defy Gravity" - skip other players based on how many green cards you hold (exact skip-count-per-card unconfirmed). MED. |
| 483 | Uno The Simpsons (2025) | RESKIN | Confirmed as the current 2025 Mattel "TV Show Edition" (item JHB16, UPC 194735326846): "Woo-hoo! D'OH!" rule - triggered outcome is either safe ("Woo-hoo!") or forced to draw cards ("D'OH!"); also "Ay Caramba!" replaces the UNO call-out. Follow-up REVERSES the earlier duplicate flag: a long, genuine Simpsons UNO reprint history (2001/2003/2005/2007, see #259/#435) means this is its own distinct real product, not a triple-counted entry with #259/#435. HIGH existence/name, MED exact mechanic. |
| 484 | Uno America's Newest Card Game Craze! (1973) | RESKIN | Historical baseline print. Correction: "introduced 1992" was wrong; 1992 is when Mattel acquired the game, not when Wild Draw Four appeared. The original 1971/1973 deck's exact action-card mix is undocumented (see #8). |

### #485–503 (never released)

See Part B above for the full table.

### Additions found during sheet verification (N1–N24)

Official products that turned up on Mattel's support site (or in Mattel's store copy) during the
sheet-verification pass but weren't in the original source list. They're numbered N1+ so the source
list's numbering stays intact. Exact card text is in the `docs/mechanics/` file named in each row.

| # | Title | Tag | Description |
|---|---|---|---|
| N1 | UNO Show 'Em No Mercy Attack (JNK69, 2026) | MECHANIC | No Mercy's rules on a two-button launcher: Hit 2x/4x, Wild Reverse Hit 4x, Wild Hit 6x (stack equal-or-higher, and every press must be completed), Wild Ultra Hit (hold the red button as long as you dare), Wild Duel to the Death, plus Skip Everyone and Discard All. Mercy at 25; 250 per knockout, to 1000. HIGH (sheet); counts unconfirmed. Spec 01. |
| N2 | UNO Add-On Packs: Frenemies (JMM16) | MECHANIC | Wild Nemesis (your chosen enemy draws 2 extra whenever you make them draw), Wild Petty Play (a chosen player draws 3; also playable out of turn against anyone who makes you draw), Wild Eliminator (all others discard their Wilds), Wild Instigator (choose any players and 1-4 cards each). HIGH (sheet). Spec 01. |
| N3 | UNO Add-On Packs: Comeback (JMM17) | MECHANIC | Wild Swap Hands, Wild Double Down (discard it plus one more card), Wild Match the Max (a chosen player draws up to the largest hand), Wild Misery Loves Company (all others draw up to the largest hand), plus a U-N-O instant-UNO rule. HIGH (sheet). Spec 01. |
| N4 | UNO Add-On Packs: Defense (JMM18) | MECHANIC | Response cards: Wild Block (cancel a Draw or Skip on you), Block & Rebound (send a Draw back +1), Block & Deflect (pass a Draw or Skip to the next player), Redirect (send a Draw to any player). Each also works as a plain Wild. HIGH (sheet). Spec 01. |
| N5 | UNO Add-On Pack: Love Island (JPH28) | MECHANIC | Wild Coupled Up (play for your coupled partner when they can't), Wild Eggs In One Basket (when your target reaches UNO you discard down to one too), Wild Pull You For A Chat (view a hand and swap one card), I've Got a Text (choose one of three effects). 13 playable cards + 3 reference cards. HIGH (sheet). Spec 01. |
| N6 | UNO WWE (JKH98, 2025) | RESKIN | Wild Payback: all other players reveal and discard their Wilds to the bottom of the pile, then draw the same number. HIGH (sheet). Spec 04. |
| N7 | UNO Flip Splash (GXD74) | MECHANIC | Waterproof 108-card Flip: 2 Wild + 2 Wild Draw Two (Light), 2 Wild + 2 Wild Draw Color (Dark). Its sheet contradicts itself on who names a Wild's color after a flip. HIGH (sheet). Spec 02. |
| N8 | UNO Express (GDR45) | MECHANIC (minor) | Official short-game deck: 56 cards, 2-4 players, deal 5, play to 250; Wild Draw Two with a 4/4 challenge. HIGH (sheet); counts not printed. Spec 02. |
| N9 | My First UNO Thomas (R2823) | MECHANIC (minor) | 36 king-size cards (1-7 in 4 colors, 4 Draw 2, 4 Wild), deal 5. HIGH (sheet). Spec 02. |
| N10 | UNO Fandom Star Wars: Dark Side (JCW37) | RESKIN | Wild Rule of Two: give up to 2 cards to a chosen "apprentice", never your last card. HIGH (sheet). Spec 08. |
| N11 | UNO Fandom Elf (JLG93) | RESKIN | "World's Best UNO": give all cards of one color to another player. MED (store copy + box). Spec 08. |
| N12 | UNO Fandom Harry Potter: Dark Arts (JLG90) | RESKIN | "Unforgivable Curses": the target shows the chosen color or draws 3; if they have it, it rebounds to a player of their choice. MED. Spec 08. |
| N13 | UNO Fandom Clueless (JMD55) | RESKIN | "Ugh, As If!": reject an Action Card played on you. MED. Spec 08. |
| N14 | UNO Fandom Ken (JFP09) | RESKIN | "Ken You Dig It?": play any card from the discard pile. 4 copies, no foil, 112 cards. MED. Spec 08. |
| N15 | UNO Fandom The Nightmare Before Christmas (JNV41, 2026) | RESKIN | Wild Sandy Claws: a one-lap pass-a-card chain. HIGH (sheet). Distinct from #185/#186. Spec 08. |
| N16 | UNO Masters of the Universe movie (JMF11, 2026) | RESKIN | Wild Power Sword: while you hold it you may play up to 2 cards a turn. HIGH (sheet). Distinct from #149 and #330. Spec 08. |
| N17 | UNO Toy Story 5 (JLN03, 2026) | RESKIN | Wild Fully Charged: everyone reveals battery-icon cards; whoever has the most is safe, everyone else draws 1. HIGH (sheet). Spec 07. |
| N18 | UNO Disney Parks (GPV93, 2019) | RESKIN | Wild Disney Parks Magic: every player passes their whole hand to the left (same effect as this port's Wild Pass Hands). HIGH (sheet). Spec 07. |
| N19 | UNO Disney Fairies (N7785, 2008) | RESKIN | Flitterific!: discard it to block a Draw 2/WD4; you don't draw, but your turn ends. HIGH (sheet). Spec 07. |
| N20 | UNO High School Musical 3 (N2830, 2008) | RESKIN | Graduation: all other players draw 1. HIGH (sheet). Spec 07. |
| N21 | UNO Hello Kitty & Friends (FNC40, 2017) | RESKIN | Wild Badtz-Maru: the player with the fewest cards (all tied players) draws 4. HIGH (sheet). Spec 07. |
| N22 | UNO Planes: Fire & Rescue (CGN24, 2014) | RESKIN | Water Drop: empty all your blue cards onto the discard pile, then choose the color. HIGH (sheet). Spec 07. |
| N23 | UNO Batman Comics (JBG35, 2024) | RESKIN | Wild Bat Signal: the next player draws until they get a Batman, Robin, Batgirl or Nightwing card (numbers 1-4). HIGH (sheet). The card previously attached to #371's notes. Spec 07. |
| N24 | UNO Barbie (T8236, 2012) | RESKIN | Fashion Trend: call a color; players show a card of it in turn, and the first who can't draws 2. HIGH (sheet). Distinct from #316 and #165. Spec 07. |

### Reskin verification pass (complete)

The Methodology section's "reskins are a strong prior, not individually verified" caveat is being
worked off in batches of 50, checking each RESKIN/UNKNOWN title for a missed bonus card or rule (per
user request, separate from Part E's digital-only pass). Progress:

* **Batch 1 (titles #1-5, #8, #14, #39, #49, #50, #74-92, #125-136, #138, #140-142, #144-148 - 50
  titles): done.** Only #14, #39, and #49 confirmed as genuinely plain reskins; the other 47 rows above
  were corrected or confirmed in place with a specific card/rule and a confidence tag. Two structural
  gaps surfaced but were folded into existing rows rather than given new numbers: "Uno Star Wars: The
  Mandalorian" (a separate later release from #81, own "This is the Way" card) and the 2018 "Uno
  Avengers" GDJ80 (a second release alongside the 2014 one already at #83, own "Infinity Gauntlet"
  card) - both noted inline in #81/#83 above.
* **Batch 2 (all 15 UNKNOWN-tagged titles, prioritized per user request, plus RESKIN titles #150-189 -
  50 titles): done.** 13 of 15 UNKNOWN titles resolved (most turned out to be real, plain cosmetic
  products - promo/ambassador items, regional SKUs, or reskins with no added mechanic; a few corrected
  wrong guesses outright, e.g. #317 "Super Kick" is a football-photo deck, not a launcher). #377 and
  #399 remain genuinely UNKNOWN after a real search effort, per the user's explicit OK to leave them
  for manual verification. Of the 35 RESKIN titles, only #173 (Frozen 2016, likely a duplicate of #172)
  and #151/#154 (Nickelodeon flagship, USA - no bonus card found but unconfirmed either way) came back
  without a positively-identified bonus card; the other 32 were corrected or confirmed with a specific
  card/rule.
* **Batch 3 (titles #190-197, #208-214, #238, #245-257, #259-273, #275-280 - 50 titles): done.** Highlights:
  confirmed bonus cards for several high-confidence titles (Amazing Spider-Man 2023 "Web Swing" HIGH,
  Disney 100 "Wild Mickey Movie Madness" HIGH via official Mattel instruction sheet, Pixar 2021 "Pixar
  Pop Quiz" HIGH via official instruction sheet, Monster High 2013 "Creeperific 'Urrrhhh'" HIGH via
  official instruction sheet, Trolls Band Together "Power of Togetherness" HIGH, Haikyu!! "4 original
  special rule cards" HIGH). Two structural findings worth a future cross-reference pass rather than a
  per-row fix: (a) #271 "One Piece (New World)" and #273 "One Piece (Summit War)" appear to be the SAME
  July 2011 release double-counted under two different fan-assigned arc names, sharing the same 2
  bonus cards ("Fire Fist Ace", "Hancock"/"Mero Mero Mellow"); (b) #263 "Uno Master Disney Pixar Cars" is
  not a paper deck at all but a 2007 electronic handheld device - flagged as a DIFFERENT-GAME retag
  candidate, same as #248 "Uno Disney (2002)" which is likely the electronic Tinker Bell edition. Also
  flagged for existence verification (no corroborating source found at all): #190 Ratatouille, #257 Ren
  and Stimpy, #269 Hi Hi Puffy AmiYumi, #278 Hello Kitty (Japan, 2011), #280 Pokémon Best Wishes. Of the
  50 titles, #267 Doraemon (2023) is the one title in this batch where the evidence leans toward the
  doc's existing "plain reskin" tag actually being correct (no Ensky "special rule card" boilerplate
  found anywhere, unlike every sibling Ensky anime-UNO title checked this batch).
* **Batch 4 (titles #282-283, #286-290, #292-295, #297-304, #307, #310-316, #319-326, #328-336, #341,
  #343-345, #347-348 - 50 titles): done.** This batch skewed heavily toward sports-team/novelty-brand
  decks and a notably thin web footprint - more than a dozen titles could not even be confirmed to exist
  (#286 Limited Too, #299 Boston Celtics 2005, #307 Macy's Parade, #311 Sesame Street 35th Anniversary,
  #315 My Scene, #320 Spurs, #321 Cavaliers/LeBron, #323 Shopkins, #326 Sock Monkey, #343 Max Steel,
  #344 American Girl 2020, #345 Pinkalicious - flagged for existence verification). Confirmed
  high-confidence bonus mechanics: VeeFriends "Sharing Squirrel" (HIGH, official brand blog), Star Trek
  1999's "Live Long and Prosper"/"Beam Me Up, Scotty" (MED), Polly Pocket 2006's "Rockin' Blockin'"
  (MED), Lilo & Stitch 2024's "Ohana" hand-equalizer (MED), NFL's "Ice the Kicker" (MED-HIGH). Confirmed
  Mattel's March 2024 "UNO Fandom" premium collectible line exists and ships a unique rule + foil card
  per deck (trade-press confirmed); Masters of the Universe's "Power of Greyskull" and Avatar's "Avatar
  State" are specifically confirmed (MED-HIGH), but the 4 separate Harry Potter house decks (#332-335)
  and Star Trek Fandom (#331) have only line-level confirmation with per-deck card specifics unconfirmed.
  Structural finding: #319 "Boston Red Sox (2004)" and #347 "World Series Champions 2004 Boston Red Sox"
  look like the same product double-counted under two titles (same pattern as #271/#273 in batch 3) -
  flagged for a future merge/cross-reference pass, not fixed inline.
* **Batch 5 (FINAL - titles #349, #351, #353, #356-358, #360, #371, #387-389, #393-394, #396-398, #402,
  #410-417, #423-427, #429-434, #435, #437-439, #476-477, #479-483 - 47 titles): done.** This closes out
  every RESKIN-tagged row in the doc. Highlights: Harry Potter 2003's "Sorting Hat" (HIGH), Wednesday's
  "Black is My Happy Color" (HIGH), The Simpsons' "Woo-hoo! D'OH!" (HIGH), Fandom Gremlins' "Never Feed
  Them After Midnight" (MED-HIGH via official Mattel instruction sheet). Three NEW likely-duplicate
  findings (same double-counting pattern as #271/#273 and #319/#347 from earlier batches), all flagged
  for a future merge/cross-reference pass rather than fixed inline: (a) #435 "Simpsons (2009)," #483
  "The Simpsons (2025)," and the existing #259 "Simpsons Springfield" are likely 3 doc entries for 1
  product; (b) #423 "Pixar (2025)" is likely the same SKU as the existing #260 "Pixar (2021)" entry
  ("Pixar Pop Quiz"); (c) #424 "Barbie (2025)" and #476 "Hotwheels (Italy) (2021)" are likely the same
  SKUs as the existing #316 "Barbie (2013)" and #324 "Hotwheels (2014)" entries respectively. Confirmed
  #397 "Fandom Monster High" ("Frankie's Hand") and #426 "Fandom Monster High Fearbook" are genuinely
  TWO separate products, not a duplicate. #412 "One Piece (2024) (Japan)" needs cross-referencing
  against #139/#271/#272/#273 - a real risk of a 4th One Piece double-count. Existence could not be
  confirmed at all for several titles despite a real search effort (candidates for a future
  existence-verification pass): #358, #360, #394, #396, #398, #402, #427, #429, #477.
* **Reskin verification pass: COMPLETE.** All ~255 RESKIN-tagged rows and both remaining UNKNOWN rows
  have now been checked across 5 batches (totaling ~247 titles researched).
* **Deep-dive follow-up pass (4 flagged categories): done.** A dedicated second-pass research round
  resolved most of the open items from the 5 verification batches:
  - **Duplicates confirmed and merged**: #271/#273 (One Piece 2011, "New World"/"Summit War" are
    fan-assigned arc labels for one July 2011 release, HIGH), #260/#423 (Pixar GVP47, same
    continuously-stocked SKU, HIGH), #316/#424 (Barbie HPY59, corrected to 2023, MED), #324/#476 (Hot
    Wheels BGG53, MED - the "Italy/2021" mix-up traces to an unrelated UNO-themed die-cast car, not a
    card game). #319/#347 (Red Sox 2004) stays a MEDIUM-confidence probable merge, not fully nailed
    down. The full One Piece family (#139/#271+273/#272/#412) now cleanly maps to 4 distinct real
    products across 2003/2011/2016/2024.
  - **One duplicate flag REVERSED**: #259/#435/#483 (Simpsons) turned out to likely be 2-3 genuinely
    distinct real products (2001/2003/2005/2007/2025 reprint history), not one title triple-counted -
    do not merge these.
  - **Electronic-hardware items resolved**: #263 "Uno Master Disney Pixar Cars" RETAGGED from RESKIN to
    DIFFERENT-GAME (confirmed a self-contained electronic handheld with an on-screen virtual hand, no
    physical cards, HIGH). #248 "Uno Disney (2002)" stays RESKIN, not retagged (confirmed it ships a
    full physical deck + a special "Wild Discard All" card that uses an electronic Tinker Bell tray as
    a color-randomizer gimmick, not a self-contained electronic game).
  - **Existence-unconfirmed titles**: 7 titles upgraded to CONFIRMED REAL (#320 Spurs, #323 Shopkins,
    #344 American Girl 2020, #345 Pinkalicious - all HIGH; #398 Magic Tree House MED-HIGH; #321
    Cavaliers/LeBron real but mislabeled as "Uno: NBA Eastern Conference"; #394 UNC and #396 NY Knicks
    upgraded to "unconfirmed but plausible" via confirmed sibling-product patterns). Several others
    strengthened toward "likely doesn't exist" with a specific conflation theory identified (#311
    Sesame Street 35th Anniversary confused with a non-UNO Rose Art trivia game; #315 My Scene confused
    with UNO: Barbie 2002; #343 Max Steel confused with the Mattel 80th-Anniversary "Ruby Red" box;
    #427 Quintessential Quintuplets confused with an unrelated Bushiroad TCG; #477 Attack On Titan
    confused with a Shiseido skincare brand named "uno").
  - **The 2 remaining UNKNOWN titles** (#377, #399) stay UNKNOWN per the user's standing permission,
    now with stronger confirmation that their parent product families (UNO Showdown; UNO Pocket) are
    real, supporting a "vanished/undocumented variant" theory over a doc error.
* **Final review (MECHANIC rows and Part A): done.** Six more research passes gathered
  implementation-grade specs for every Part A family (now in `docs/mechanics/`, summarized with a
  conflict catalog in Part F) and re-checked the MECHANIC rows that the reskin pass never covered. Rows
  found WRONG and corrected: #400 (UNO Master is the 1997 electronic turn timer, not Masters of the
  Universe), #36/#388 (the 2000 Harry Potter deck has Howler/Invisibility Cloak, not Sorting Hat; likely
  one product), #42 (second Monster High wild unsupported), #96 (Cobs is 13 cards), #27/#110 (the
  accumulate-and-dump pile is Blast's, not Wild Jackpot's), #104 (four towers, each blocking one card
  type), #47 (first to 3 hands), #24 (tipper draws 2), #484 (1992 is Mattel's acquisition, not WD4's
  debut), #291 (Giannis deck has a "Force a Turnover" rule), #340 (a Pocket deck, retagged), #337
  (Cheese Touch effect conflicts with the Fundex manual). Vague rows filled in with exact effects: #6,
  #7, #21, #22, #26, #33, #35, #40, #199, #215, #234, #308, #406, #428. Downgraded to unverified: #34,
  #200, #229, #327, #361, #372, #367. Also found that the already-implemented Swap Pack differs from the
  real cards (see A3).
* **Official-sheet verification: done.** Every mechanic family, the whole Fandom line and ~95 licensed
  bonus cards were checked against Mattel's own instruction sheets (`docs/mechanics/` files 01-08 now
  quote them). About 170 Part D rows were updated; the biggest corrections were that each Fandom NFL
  deck has its own rule card, discarded action cards do take effect in most device games, several deck
  lists were wrong (Royal Revenge, Triple Play, Tiki Twist, Blast, Power Grab, UNO Junior), Coco's
  Remember Me and Lion King's Circle of Life aren't hand swaps, #316 Barbie is a different deck from
  #424 (which matches #165), and My Scene (#315) does exist. 24 official products missing from the
  source list were added as N1-N24.
* **UNO Undercover decompile: done.** A decompile of the shipped game (`docs/mechanics/09-uno-undercover.md`)
  replaced the secondary-source summary of #235: 13 obtainable Command Cards (not 9 "power-up cards"),
  four effects corrected, four cards added, and #497's cut cards identified (Plunder, Personal Shield).

---

## Part E — Digital-only deep dive

A dedicated research pass on every `DIGITAL-ONLY`-tagged title in Part D, at the user's request: instead
of "has some DLC cards," this documents the actual card names, exact effects, and rule structures, so
any of these can be properly scoped for implementation later. Produced by four parallel research agents
(one per sub-section below), each independently hitting the same environment limitation: direct page
fetches (Wikipedia, Fandom wikis, GameFAQs, app stores, official Ubisoft/Xbox pages) were blocked by
this session's network egress policy, so every finding below comes from web-search result synthesis
rather than a verified raw read of the source page. Confidence is tagged per finding:

* **HIGH** — corroborated across 2+ independent sources/searches with consistent wording.
* **MED** — a specific, detailed claim from a source that reads as reliable, but not independently
  cross-checked against a second source.
* **LOW** — a name or general claim is confirmed, but exact effect text/wording is inferred, ambiguous
  between sources, or single-sourced from a fan site. Treat as "needs verification before relying on it,"
  not as confirmed fact.

Corrections this pass made to Part D's existing entries (developer misattributions, wrong dates,
conflated titles, wrong "standard rules" assumptions) are applied directly to those rows above; this
section is the supporting detail.

### E1. Xbox 360 / Xbox Live family (#113, #116, #117, #366, #401)

**Correction:** all of these are developed by **Carbonated Games**, published by **Microsoft Game
Studios** — not Gameloft (Gameloft made an unrelated 2008 iPod/iPhone UNO). And **#401 "Uno Xbox 360
Live" is not a separate release** — no evidence of a distinct SKU exists; online play, ranked matches,
webcam, and the downloadable theme decks are all features of the one 2006 release (#113). Recommend
merging #401 into #113 if this doc is ever restructured.

**#113 — UNO (Xbox 360/XBLA base game).** Released May 9, 2006, 400 Microsoft Points. Standard 108-card
deck; no structural deck change in the base game (deck changes come only from DLC below). HIGH.

Modes: **Standard** (normal play), **Partner** (2v2 with the player across from you, to 250 points,
MED), **House Rules** (marketed as "customize 10 different game rules"; only 3 specific toggles could be
sourced - win-condition point threshold, Wild Draw Four challenge on/off, Draw Two penalty count, MED;
achievement text confirms 3+ toggleable rules exist, consistent with ~10, but the full list wasn't
found). A YouTube title suggesting a 4th "Elimination" mode conflicts with the 3-mode framing most
sources give — unresolved, LOW. Xbox Live supported Ranked/Quick/Player match types, MED-HIGH.

**Webcam feature is real**, not a UI flourish: UNO was a flagship launch title for the Xbox 360 Live
Vision camera (Sept 2006) and showed literal live video of your opponents' faces during play — well
documented, including its infamy for attracting inappropriate content shortly after launch. HIGH.

Downloadable theme decks for the base game (4 total, per one aggregated source - no purely-cosmetic deck
was found, every one added at least one new card):
* **Project Gotham Racing 3 Theme Deck** (100 MSP, Sept 2006) — new backgrounds/music/art, plus a
  **"Gotham Live"** card: lets you look at any other player's hand, while also functioning as a normal
  Wild. HIGH.
* **Kameo: Elements of Power Theme Deck** (100-150 MSP, price disputed between sources; Nov 2006) — an
  unnamed card that lets the player **swap their entire hand with any other player's**. Only the lobby
  host needs to own the deck for the whole table to use it. HIGH on mechanic, LOW on exact price.
* **UNO 35th Anniversary Theme Deck** (#116, free, ~2006) — one added **"35" card**: the next player
  must play a 3 or a 5 of any color, or draw a card and miss their turn. A constraint card, not a direct
  attack. MED-HIGH.
* **UNO Super Street Fighter II Turbo HD Remix Theme Deck** (#117, 280 MSP, ~late 2008) — character
  portraits, Sagat's HD Remix stage as background/music. The **Hadouken card**: target one opponent, who
  must then draw continuously until they draw a "Block" or "Jump" card (i.e. until they hit the deck's
  Skip- or Reverse-equivalent) — an open-ended draw penalty, not a fixed count. Skip/Reverse in this deck
  appear to be thematically renamed "Block"/"Jump" (MED, inferred from phrasing, not an explicit
  statement); if so, Hadouken is the only mechanically-new card in the deck.

**#366 — UNO Rush (XBLA).** Released March 25, 2009 ("Days of Arcade" promo), same developer. Not a
straight 108-card deck: 7 cards each numbered 0-9 in one of 4 colors, plus standard action cards (Skip,
Draw Two, Reverse, Wild, Wild Draw Four) and a new **Shuffle** card — a rebalanced pool built for speed
play. MED.

The **"timed" mode is a hybrid, not a countdown bar or free-form reflex play**: on your turn, the game
auto-plays from the front of your (player-ordered) hand — if the front card is legal it plays
automatically, and if the next card also combos (matches color/number in sequence) it auto-chains, and
so on. Your actual input during other players' turns is **re-ordering your hand** so the front is a
legal/optimal play when your turn arrives (reviewers describe "about five seconds" to do this,
approximate). A well-arranged hand can play its whole hand in one turn. MED-HIGH, consistent across
several independent reviews.

**"Visible hands"**: every player's hand is shown face-up to everyone for the whole round — purely
informational (helps you plan the reordering above), does not grant jump-in or change legality. MED-HIGH.

**Shuffle card**: styled like a Draw Four in a distinct color. Shuffles the **next player's** hand into
random order **and** skips their turn — a direct attack on Rush's core "keep your hand pre-sorted"
strategy, on top of the skip. ("Scramble" in one achievement-guide source is the same card, not a second
one.) HIGH, corroborated across 3 independent paraphrases.

Modes: **Traditional/Standard**, **Partner/Pairs** (2v2), **Elimination** (must play a card or take a
strike; 3 strikes = eliminated from the round). The timed/visible-hands ruleset is the underlying engine
across all three, not a separate 4th mode — if this doc's earlier "timed, visible-hands mode" framing
implied a single mode, that's imprecise; better read as "Rush's core ruleset" with these 3 as the mode
select on top. MED.

Biggest open questions: the complete 10-toggle House Rules list for #113, whether Elimination is a real
4th top-level mode there, exact Kameo deck price, exact 35th Anniversary/Street Fighter release dates,
and whether Block/Jump are literally renamed Skip/Reverse.

### E2. Ubisoft family (#115, #118-123, #386, #390)

**#115 — UNO (Ubisoft base game, 2016).** PS4/Xbox One Aug 2016, PC Dec 2016, Switch Nov 2017. Dev.
Ubisoft Chengdu. Standard 108-card deck. Markets its house rules as explicitly **combinable** ("combine
Jump-In and Stacking or 7-0 swaps to create your perfect kind of chaos"). Confirmed toggles: **Stacking**
(Draw Two/Wild Draw Four stack, penalty passes on), **7-0** (7 swaps hands with a chosen opponent, 0
passes all hands one seat), **Jump-In** (play an exact match out of turn) — these 3 are HIGH confidence,
cited by Mattel itself as the "classic" fan-contest house rules. **Draw to Match**, **Force Play**, **No
Bluffing** (disables the Wild Draw Four challenge) are also referenced as being among "six combinable
house rules" for this game but couldn't be verified against the actual in-game menu — MED.

**#118 — Uno Rabbids DLC.** 4 cards, HIGH confidence on names, MED-HIGH on effects:
* **Comin' Through** — 5 cards randomly distributed from your hand to opponents, then 5 more randomly
  redistributed among everyone including you.
* **Explosive Results** — next forced-to-draw player draws 4 total.
* **Hurry Up!** — for several turns, each player must act within 3 seconds or draws a card and is
  skipped.
* **Wild Blue Yonder** — cancels an incoming Draw Two/Wild Draw Four; with no pending penalty to block,
  functions as a normal Wild.

**#119 — Uno Just Dance 2017 DLC.** 4 cards, distinguishing trait: affects **all players at once**
rather than one target. HIGH names, MED-HIGH effects:
* **Just Dance Machine** — every player gets a random "experiment" card triggering a random action.
* **Scream & Shout** — every player except whoever has the lowest card count must randomly discard down
  to match that lowest count.
* **Lean On** — each player swaps hands with the player seated directly across from them.
* **Worth It** — for a duration, only number cards may be played, table-wide.

**#120 — Uno Rayman DLC.** 4 cards, HIGH names, MED-HIGH effects:
* **Dragon** — takes every player's hand, shuffles, redistributes randomly.
* **Punching Things** — reflects an incoming Draw Two/Wild Draw Four back at whoever played it, at
  double the penalty.
* **Escape** — peek at one opponent's hand; hides your own hand count from everyone until you call Uno.
* **A Little Help** — duplicates the effect/appearance of the current top discard card (a free copy).

**#121 — Uno Fenyx's Quest DLC** (Immortals Fenyx Rising, Jan 2021). Adds a "Golden Isle" board element:
playing 5 cards frees a chosen god, granting a passive blessing for the rest of the match. **LOW
confidence on exact effects** (single uncorroborated search synthesis):
* **Aphrodite** — immunity to "Typhon" damage/penalty effects (exact trigger unconfirmed).
* **Hephaistos** — every 3 cards you play, discard all your cards of one chosen color.
* **Athena** — when an opponent draws due to no legal play, they must discard a random card.
* **Ares** — each time any card is played, two random cards of that color are discarded (scope —
  own hand vs. table-wide — ambiguous).

**#122 — Uno The Call of Yara DLC** (Far Cry 6, ~Oct 2021, $5 standalone). Genuinely structural: adds a
**Pesos economy** (7 cards + 300 Pesos to start, +100 Pesos each turn) spendable on 4 named character
abilities, plus 1 new card. MED-HIGH:
* **Dani Rojas** — 500P: chosen player draws 1-6 cards. 800P: ALL other players draw 1-6.
* **Philly Barzaga** — 600P: combine 4 colors into an instantly-playable Wild. 1000P: same, but a Wild
  Draw Four.
* **Juan Cortez** — 600P: discard 1-3 of your own cards. 1300P: discard 4-6.
* **Lucky Mama** — 200P: block one chosen player from a "service" next turn. 400P: block ALL others.
* **Guerrilla Recorder** (new card) — randomly affects every player's Pesos: each may gain a large sum
  or lose their entire stash.

**#123 — Uno Valhalla DLC** (Assassin's Creed Valhalla, ~April 2022). **The single biggest structural
departure of any digital-only UNO found in this whole pass** — Ubisoft's own PR: "for the first time in
UNO, the board becomes part of the gameplay." Discarding cards moves you across a physical board;
movement collects **cargo**, spendable on **perks** (including slowing opponents); a **Longboat** passive
lets enough cargo discard multiple cards at once; random board **events** (e.g. "Glory Regained"/"Raid"
— steal 2 cargo from an opponent, possibly two distinct events, not fully disambiguated); a new
**Eivor's Raven** card lets you travel to any board area to claim a reward, bypassing normal movement;
cargo can also be spent to start a "card fight" to slow an opponent. **Exact win condition and
cargo/perk costs are unconfirmed** — no source gave a full rules breakdown. MED-HIGH on mechanics
existing, LOW-MED on exact rules. Flag for follow-up before ever prioritizing this one.

**#386 — Uno Party! Mania DLC** (July 2024, $4.99 standalone). **3** new action cards, not 4 (confirmed
by 2 independent searches — if any existing doc text implied a 4th card, that was wrong). HIGH names and
effects:
* **Point Taken** — every player points at one other player; each player then draws one card per
  finger currently pointed at them (stackable, multi-target accusation).
* **Wild Drawn Together** — choose a new color (standard Wild) and link two players; for the rest of
  the game, whenever either linked player draws, the other must draw the same amount too.
* **Wild Pile Up** — starts a "mini-pile" seeded from the top of the draw pile; players take turns
  adding a matching-color card to pass it along; whoever can't continue absorbs the whole mini-pile.

**#390 — Uno Show 'Em No Mercy DLC** (Ubisoft, Oct 2025). **Verdict: a digital port/adaptation of
Mattel's existing tabletop "UNO Show 'Em No Mercy"/"No Mercy" ruleset, not a digital-only invention** —
rules and cards match the known physical variant closely, and no source describes anything unique to
the digital version specifically. Confirmed rules (HIGH): **Mercy** (25+ cards in hand = eliminated),
**Draw Until You Can Play**, **7's Swap** (whole-hand swap), **0's Pass** (everyone passes hands).
Marketing cites "six super-tough action cards"; cross-referencing tabletop No Mercy sources, likely Wild
Reverse Draw 4, Wild Draw 6, Wild Draw 10, Wild Color Roulette ("sad face" — next player names a color,
flip draw-pile cards until it appears, take all revealed, lose turn), Skip Everyone, and probably a
Discard-All matching-color card — MED on the complete 6-card list. Win conditions: empty-hand-first OR
elimination via the 25-card Mercy threshold.

### E3. Mobile / handheld family (#114, #241, #243, #374, #375, #376, #404)

**Two collapsing notes:** #114 and #241 are the **same Gameloft product** at different points in its
life (2008 J2ME/BREW/Symbian build → 2009+ iPhone/iPod/Android/"UNO HD" build), not two separate games.
Likewise #375's "Uno 2 Go" (Dec 2022 soft-launch) was **renamed "UNO Wonder"** for its Sept 2025 global
launch — same cruise theme, same 9 cards, same Story Mode, one release not two. (#243 and #376 *are*
genuinely distinct Gameloft releases — a 2012 offline feature-phone build and a 2013 online rebuild —
confirmed via separate MobyGames listings.)

**#114/#241 — UNO (Gameloft mobile).** Standard 108-card deck; customization is at the rules level.
**Career mode**: exactly 15 rounds, sequential, up to 5 attempts per round; what changes round-to-round
is procedural difficulty (opponent count, active house-rule set, win condition), not new decks/named
opponents — progression rewards are cosmetic/meta only (icons, backgrounds, avatars). MED-HIGH.
**Tournament mode**: exactly 5 rounds, same escalating-rules engine as Career, just shorter. MED-HIGH.
**Custom Game mode**: 9 toggleable rules total; only **7-0** and **Jump-in** confirmed by name (same
definitions as elsewhere); the other 7 weren't individually named in any accessible source. HIGH that
it's 9 rules including these two, LOW on the rest.

**#243 — Uno & Friends (2012, Gameloft, feature-phone/offline).** Career mode = **"Uno World Tour"**: 6
venues x 5 stages = 30 stages; 1-3 stars per stage gate the next venue; some stages are mini-games
sharing only card *imagery* with UNO (e.g. memory-matching), not real UNO rules. **Hot Seat**:
pass-and-play for up to 4 on one device. MED-HIGH.

**#376 — Uno & Friends (2013, online, Gameloft+Mattel).** Single-player content was later entirely
replaced by online multiplayer-only (up to 4 worldwide). Two currencies: **Tokens** (match/tournament
entry, 2 per basic game, earned via win streaks/daily ads or bought) and **Coins** (cosmetics/boosts,
earned via match points or bought).

Boosts (per-match activatable perks), full named list, HIGH confidence:
**Shield** (respond to an incoming Draw 2/4 with a card to block it), **Snare** (activates the first
time you're Skipped/Reversed), **Safety Net** (5 cards instead of 6+ once the match timer hits 30s),
**50% Bonus** (+50% points that match), **New Hand** (swap your whole hand once per game), **Dampener**
(halves cards drawn from a Draw 2/4 hit against you), **Mirror** (whoever plays a Draw 2/4 on you also
draws), **Spy** (see other players' hands), **Overdraw** (opponents draw 2 instead of 1 when they can't
play — a global modifier, not a personal buff).

**Companion characters are mechanically real, not cosmetic-only** (the key question asked): ~31
companions, each with an **active special power usable a limited number of times per match** (example
cited: makes a random player draw a card when a specified card is played). Use-count scales with
companion level: 1 use/game at levels 1-4, 2 at levels 5-9, 3 at level 10 ("Ultimate Ability"); leveled
by winning or buying duplicates (10 copies = max level). A genuine gameplay-affecting
passive-with-limited-triggers system. MED-HIGH, single-sourced but internally consistent and detailed.

A later update added a **"Team UNO" 2v2 mode** (confirmed via a period YouTube title) — exact rules text
not found for Gameloft's version specifically (inferred by analogy to Mattel163's 2v2, see below). MED
mode exists, LOW on exact rules. Also found: **Uno Dare** (unlocks 12 collectible avatars) and **Uno
Journey** (separate progression track with named sub-journeys — Tiki Twist, Mine, Arctic — 20-30 levels
each).

**#374 — Uno Mobile / "UNO!™" (Mattel163).** Live service since ~2019-2020, still active (a Dec
2025-Feb 2026 Sanrio collab was found in search). Note: Mattel recently bought out NetEase's stake and
launched "Mattel Game Studios" to self-publish going forward; **"Codemasters" as a developer could not
be corroborated by any source** — worth double-checking if that attribution exists elsewhere in this
project's notes.

Full house-rule toggle list (Custom room setup), HIGH confidence on all 6-7, near-verbatim across 3
search passes:
* **Stack** — +2/+4 stackable; a +2 can only stack on another +2; whoever can't extend draws the total.
* **Jump-in** — play an exact match instantly out of turn; play continues from there.
* **7-0** (sometimes split "Swap on 7"/"Swap on 0") — same definitions as elsewhere.
* **No Bluffing** — removes the Wild Draw Four challenge entirely.
* **Progressive** — identical draw cards stack/accumulate (MED confidence this is genuinely distinct
  from "Stack" rather than an alt name for it — sources weren't fully consistent).
* **Draw to Match** (aka Draw Until You Play).
* **Force Play** — a playable drawn card auto-plays immediately.

Could **not** confirm a "Discard All" *toggle* — may instead be a special *card* in seasonal decks (see
below), which would explain an earlier doc note citing it as a headline feature. A "No Mercy" preset
with Wild Draw Six/Ten, "Seven Swap," "Zero Pass" that turned up in search is **very likely Ubisoft's
separate product bleeding into the search results** (a Fandom wiki catalogs multiple UNO products
together) — **do not treat as confirmed for this app.** Likewise, **a "Survival" mode could not be
confirmed to exist at all** after a genuine multi-angle search — may be removed, mistranslated, or
confused with another product; recommend dropping this claim or marking it explicitly unverified.

Other confirmed modes: **Ranked** (earn "stars" via in-match points on a win; lose a "heart" on a loss,
3 hearts = knocked out of that session; Platinum+ can spend "Star Defense" to protect against star
loss), **2v2** (4 players/2 teams, teammates sit across from each other and **can see each other's
hand** — the core mechanical hook; round ends and both teammates win as soon as either empties their
hand), **Room Mode** (general custom-lobby term). HIGH on 2v2, MED-HIGH on Ranked.

Seasonal/event decks are mostly cosmetic reskins (Sanrio collab, Joyous Voyage, Summer Splashers, Card
Carnival, Fantástica Day of the Dead, Cat Card, Call of Spring). One confirmed mechanical exception:
**Double Discard All Card** — appears occasionally on "Wild Weekend" events; discards both of its two
shown colors together, and the next player must match the card's designated "main" color.

**#375 — Uno 2 Go / Uno Wonder.** Standard base + **9 named new action cards** (additions model, not a
redesign). Marketing names and wiki-catalogued names both surfaced without a fully certain 1:1 mapping
between them — reported as-is so the mapping can be verified in-app later:
* **Wild Skip All** — play again instantly (skips everyone else).
* **Number Tornado** (= likely "Tornado Card"/"Wild Tornado Card") — discards every number card (0-9)
  from your hand; does not affect action/wild cards.
* **Shark** — "devours the next card played" (exact mechanics not confirmed beyond marketing flavor
  text).
* **Explosive Results Card** — next forced-to-draw player draws 3 *extra* cards; itself stackable if
  another draw card follows and Stacking is on.
* **Dandelion Modifier** — discards all *other* cards carrying the "Dandelion Modifier" from the play
  area, placing this card at the bottom.
* **Wild Draw Color Card** — next player draws continuously until revealing a card of a color chosen
  by whoever played this (Wilds don't count), then their turn is skipped entirely.
* **Wild Punch Card** — when a draw card is played against you, play this to *both* reverse turn order
  and reflect the draw penalty back at whoever hit you.
* **Wild Trick Card**, **Double Color Property**, **Mirror Card** — confirmed to exist/be marketed but
  exact effect text could not be retrieved. LOW.

MED-HIGH that these names are real and belong to this title; LOW-MED on exact wording for the last
three; LOW on the marketing↔wiki name mapping (educated inference only).

Story Mode: a "luxurious global cruise," 14 routes, 100+ named locations (Cape Town, San Diego,
Santorini cited), 3,000+ levels total; each destination has a boss battle against a named antagonist
(examples: "Octopus King," pirates, mermaids). MED-HIGH on the numbers, LOW on the complete boss roster.

**#404 — UNO: Arcade Edition (Apple Arcade, Mattel163, June 2025).** Standard base + a small set of
new/exclusive cards:
* **Wild Swap Hands Card** — acts as a normal Wild *and* forces the player to swap their entire hand
  with another player of their choice. (Note: same concept name as this codebase's own already-shipped
  Wild Swap Hands, arrived at independently — worth being aware neither is "based on" the other, and
  that Mattel163 appears to reuse this card design across their own UNO titles.)
* **Double Discard All Card** — same card documented for Uno Mobile above; Mattel163 clearly reuses card
  designs across their portfolio.
* **Color Showdown**/likely **"Wild Color Shutdown"** — name only, exact effect not found. LOW.
* **Wild Draw Color Card** — if identical to the Uno Wonder version above: draw until the chosen color,
  then skip. MED (inferred by name-match).

Modes: Single Player (vs. AI), Quick Match (online), Custom Games (exposes the new cards). Custom Games
also confirmed to offer a **turn/match time limit**: 3 minutes, 5 minutes, or Unlimited.

### E4. Legacy / miscellaneous digital (#235, #236, #237, #244, #364, #384, #385)

**#235 — UNO Undercover.** **Verified by decompiling the shipped game** (Alawar/Real PC release,
`App.swf` via JPEXS FFDec plus the game's XML data); the full write-up, with class names and per-claim
confidence, is `docs/mechanics/09-uno-undercover.md`. This replaces the earlier secondary-source
summary, which had the card count, the name and four card effects wrong.

* **Platform:** Windows, July 2008, dev. **Golden Goose Productions**, distributed by RealNetworks
  (RealArcade, GameHouse). A Mac OS X build also exists (MED). The earlier BREW/J2ME/Windows Mobile port
  claim has **no evidence** and was probably a mix-up with unrelated UNO phone games. No DS version: the
  2009 DS "UNO" is a separate plain Gameloft port.
* **"Command Cards" is the shipped name**, in code (`com.ggg.uno.CommandCard`), data and UI. "Power-up
  cards" is press wording only. The earlier conclusion that the game never says "command cards" was
  wrong.
* **15 defined, 13 obtainable** (one per campaign mission), not 9. Up to 7 of the *human's* unlocked
  cards are shuffled into the 108-card deck, one copy each; the AI never holds them. Switcheroo and
  Highland Two-Step are left out of 2-player games. They score 0 in practice, although the help screen
  prints 20-70 points.
* **Effects as coded** (where card text, pop-up text and code disagree, the code wins):

| Card | Color | Effect (code) |
|---|---|---|
| Redecorate | Wild | Choose a color; every non-wild card **in your own hand** becomes that color. |
| Clone | Blue | Choose a card in your hand; a **duplicate** of it is added to your hand. |
| Lucky Croc Tooth | Yellow, paired | For N turns, any Draw Two / WD4 aimed at you **bounces back** to its player. |
| Shooting Star | Red | Play up to **4 cards of one color** at once. |
| Toe Hold | Blue, paired | Choose an opponent; up to 3 random cards in their hand are locked for N of their turns. |
| Double Cross | Wild | Choose a color; recolor 1-2 chosen cards **in your own hand**. |
| Highland Two-Step | Green | Two chosen opponents swap hands. |
| Sleep | Green, paired | Choose an opponent; they lose N turns. |
| Tsunami | Blue, paired | Choose an opponent; they take N random cards **from the other players' hands** (skipping Command Cards and 1-card hands). |
| Switcheroo | Yellow | Two opponents swap **seats** (turn order). |
| Reverse Skip | Yellow | Reverse, then skip the next player (2 players: you go again). |
| Reverse Draw-Two | Red | Reverse; the next player draws 2 and loses their turn. |
| Skip Draw-Two | Green | Skip the next player; the one after draws 2 and loses their turn. |

* **Paired cards:** after the Command Card is played, a second card from your hand is dropped into a
  slot and tucked under the discard pile. A number card sets N to its value, any other card counts
  as 1, and a 0 makes the effect do nothing. Timed effects count down at the start of the affected
  player's turn, show on their portrait, and clear at round end.
* **Base rules as coded:** deal 7; the human always starts; a wild start card is redrawn, a starting
  action has no effect; WD4 playable any time and never challengeable; no stacking; draw 1 and play
  only that card or pass; Manual or Automatic UNO calls (caught = draw 2). Modes: **Single** (first out
  wins, the default) and **Standard** (to **300** points).
* **Missions:** the Felicia Blue vs. Madame Zero spy plot is confirmed. AI play is identical for every
  character (random playable card, UNO called 50% of the time). Missions vary player count (2-6),
  game type, scripted losses and a hidden **AI handicap** ("easing") that ramps 95 → 50 over missions
  1-4: the AI may refuse to play its last card or to hit the human with Skip/Draw Two/WD4, and extra
  Wilds are added to the deck.
* **Cut content (#497):** Plunder, Personal Shield, two-color combo-card art, a 3-card Deck
  Customization screen, Pass and Amplified penalty modes, an Elimination game type (highest scorer out
  each round until 2 remain), Wild Vouchers, and a hidden cheat console. See spec 09 section 3.

**#236 — UNO CD-ROM.** Dev/pub Mattel Media/Mattel Interactive; dating is inconsistent across sources
(GameFAQs "2000," an Internet Archive listing "2002") — likely one base release ~1999-2000 with a later
reissue ~2002, so this doc's "1990s PC port" framing is probably slightly late. **Correction: not
"AI/settings value only"** — adds named special cards:
* **Spy Card** (HIGH, has its own dedicated wiki page) — while held in your hand, other players *cannot
  see how many cards you have*: suppresses the normal visible-hand-size info this and most UNO
  implementations show. A genuine informational-asymmetry mechanic not present in this codebase (which
  always shows AI hand-size counts).
* **Mutant Card** and **Shark Card** — confirmed to exist by name (listed consistently alongside Spy
  Card) but their exact effects could not be found anywhere indexed. Reporting names only, not guessing.

**#237 — UNO (Game Boy Color).** Released Dec 16, 1999, dev **HotGen** (this doc's earlier "Genki,
~2001" attribution appears to be wrong; no source connects Genki to this title). Standard cards, standard
official UNO point values for scoring.

**Challenge mode inverts the win condition of the existing scoring system**, HIGH confidence, converging
across GameFAQs/Wikipedia/2 independent reviews: each player has a max point ceiling; every round, losers
(and per one source, sometimes even the winner) have points *added* to their running total; reaching or
exceeding the ceiling gets you *eliminated* rather than declared a winner as in Standard scoring. Play
continues until one player remains — they win. Multiple reviewers independently call this confusing,
noting the exact points-per-round formula is never explained on-screen even in the original game — a
real but poorly-documented mechanic, not just an artifact of secondary sourcing. **Standard mode** plays
to ~1000 points (double the real-world default of 500, unconfirmed if adjustable); **Link Game mode**
adds 1 human opponent via Game Boy Link Cable in either scoring mode, with up to 3 CPU seats filling the
rest. If this codebase ever tracks cumulative score across games, Challenge mode would be a cheap
"flip the win condition" toggle worth considering.

**#244 — UNO DirecTV Game Lounge.** DirecTV's interactive-TV "Game Lounge" channel, launched mid-2007;
UNO included via an exclusive Mattel-brands deal, dev. **Denki** (Dundee, Scotland). Rebranded "GSN Game
Lounge" 2010, discontinued March 2013. No source describes any rule variant, added card, or UNO-specific
feature beyond the interactive-TV delivery mechanism. Consistent with this doc's existing note. MED
(absence of evidence, no gameplay footage/manual locatable to positively confirm).

**#364 — UNO Famicom / Super UNO.** Super Famicom, Nov 12 1993, Japan-only, dev. **Tomy Corporation**
(licensed from Mattel). Standard matching as a base, but with real structural additions this doc's
earlier "adjustable rules/players" stub undersold:
* **Up to 6 players** (1-2 human + CPU) — already broader than this codebase's fixed 4-seat design.
* **Two scoring variants** (names/differences not found, confirmed as a menu choice).
* An official **+2/+4 stacking toggle** — functionally close to this codebase's existing Stack rule, but
  shipped as a menu option in 1993, predating Mattel's own "Progressive"/Stack packaging by decades.
* Three modes: **Regular** (straight UNO), **Team** (partnered play, akin to 2vs2, exact partner
  mechanics not detailed), and **Board Game mode** — a genuinely different structural layer: move around
  one of 5 boards against 3 CPU opponents; board spaces trigger effects (bonus points, forced movement,
  item pickups); collected items are usable either on the board (hinder other players) or at the start
  of an UNO hand (help win that hand); the first 4 boards each have 4 "castles," where defeating a castle
  means winning an UNO hand to "rescue" a character; the 5th board has one castle holding the final
  opponent.

MED confidence (converges across superfamicom.org, Giant Bomb wiki, and a 2025 English fan-translation
project's blog, but no official Japanese-language primary source was independently found). Board Game
mode is a full metagame (board traversal + items + UNO-hands-as-battles) predating and resembling later
career/tournament modes (Uno & Friends, Gameloft's progression mode) by 15-20 years — genuinely one of
the more interesting digital-only finds in this pass if a "career mode" is ever scoped.

**#384 — Radica: Uno 360 (electronic handheld).** Mattel/Radica Games brand (model P6629). **Correction:
not "standard rules digitized"** — has a distinct physical/structural mechanic: **four discard piles**,
one per physical side of the device; instead of choosing a card from a single pile, on-screen arrows
tell you which direction(s) to physically rotate the handheld (it has motion/gravity sensors) to align a
matching pile, then press SELECT to discard into it. A **"Discard Two"** action card (one of four colors)
appears to discard 2 cards at once (exact trigger not fully confirmed). **UNO-calling has a hard ~2
second time limit** once down to one card, with up to a 5-card penalty if missed — stricter and more
literally timed than standard UNO's usual 2/4-card penalty. Three modes: Free Play (no time limit), Time
Match (discard as much as possible in 5 minutes), 500 Points. MED-HIGH, sourced from what appears to be
the real Mattel instruction-manual PDF via search snippet. **Reclassification recommendation:** this is
structurally the same family as this doc's existing **Triple Play** entry (A5, tagged HARD — touches the
single-discard-pile assumption throughout the engine) but with 4 piles instead of 3, plus a genuinely
stricter timed call-penalty on top; not the simple digitization the old stub implied.

**#385 — UNO SuperLite 2000 Vol. 16 Game.** PS2, Japan-only, published by **Success** under their budget
"SuperLite 2000" reissue line, 2004. Appears to be an enhanced port (anime-style art, Japanese voice
acting) rather than a mechanically distinct release — no source describes any rule/card difference from
standard UNO, though no rules-level source (manual, detailed review) was found to independently verify
that beyond box-listing detail. LOW-MED that this is purely cosmetic — treat as "no positive evidence of
a mechanical difference found," not "confirmed identical."

**UNO Free Fall / the Java Mobile ecosystem (~2009)** — confirmed (not deep-researched further, per
scope): a falling-block tile-matching puzzle game (cards fall into one of 8 columns, match 3+ by
color/number/symbol to clear, comparable to Dr. Mario/Puyo Puyo). Does not use UNO's discard-matching
mechanic at all — correctly excluded from this project's scope, consistent with this doc's existing
A10 classification.

---

## Part F — Implementation specs and cross-mechanic conflicts

Two review passes gathered implementation-grade detail for every mechanic family in Part A: exact card
lists, copy counts, effect wording, edge cases and official rulings. The second pass read Mattel's
official instruction sheets (about 150 of them, from service.mattel.com), so most rules below are now
quoted from the sheet rather than reconstructed from search results. The full specs, with per-claim
confidence tags and sheet codes, live in `docs/mechanics/`:

| File | Covers |
|---|---|
| `01-stacking-penalties-house-rules.md` | Show 'Em No Mercy (+ Expansion, + No Mercy Attack), all nine Add-On Packs, classic UNO's official rules and printed variants (Jump-In, Seven-O, Progressive, 2-player, Partners), UNO Attack card sets and launcher rules |
| `02-flip-and-alternate-decks.md` | UNO Flip and every Flip edition (Marvel, Stranger Things, Transformers, Express, Splash, Attack), All Wild, Flex, Teams, Triple Play, Tippo, UNO 52, Junior/Choo Choo/My First UNO/Express, H2O |
| `03-randomizer-devices-and-roles.md` | Every UNO Spin wheel, Roboto, Tiki Twist, Eye Eye SpongeBob, Wild Jackpot, Power Grab, Royal Revenge, Colors Rule, Remix, Flash, Reflex, Blast, Showdown |
| `04-power-systems-and-party-rules.md` | UNO Ultimate Marvel/DC (rules, roster, Enemies, Items), Elite NFL, NFL decks, Liar's UNO, UNO Party!, WWE |
| `05-mechanic-row-corrections.md` | Per-row evidence behind the MECHANIC-row corrections in Part D |
| `06-followup-gap-fill.md` | Wild Draw Four history, X Games and Deadpool No Mercy card lists, the last never-verified RESKIN rows |
| `07-themed-bonus-cards.md` | ~95 licensed-deck bonus cards with official wording, grouped by A14 primitive |
| `08-fandom-line.md` | Every UNO Fandom deck, including each Fandom NFL team's own rule card |
| `09-uno-undercover.md` | UNO Undercover (#235) from the decompiled game: all 15 Command Cards as coded, the paired-card mechanic, the cut content behind #497, base rules and the AI handicap |

### F1. Facts from the specs that change how things get built

* **Flip** has no 0s on either side (numbers 1-9), so 7-0's "0" never fires on a Flip deck. Flipping
  inverts the discard pile, then the draw pile, then every hand, so the new top card is the back of the
  old *bottom* card. On the 2020 print, a Flip turned up as the starting card flips the game to Dark
  immediately; the exposed card's action is not applied, and an exposed Wild's color is called by
  whoever played the Flip. Challenge penalties differ per card (Wild Draw Two 2/4, Wild Draw Color
  "until the color" / "until the color plus 2"), so challenge code can't be hard-wired to 4/6.
* **No Mercy** (sheet HWV18): stack any Draw card of equal or higher value, color irrelevant; Wild
  Reverse Draw 4 stacks and sends the total back, and in 2-player games its player draws 4 unless they
  stack it back. Draw until you can play, then you *must* play that card. 25+ cards knocks you out and
  your hand is set aside until the next reshuffle. Color Roulette: the *victim* names the color. 7-0 is
  built in. Scoring: color actions 20, wild actions 50, 250 per knockout, 1000 to win.
* **Official stacking models are all different:** base UNO has none; Progressive is same draw type
  only, one per turn; Stack Pack's colored cards must match the Draw card's color; No Mercy and No Mercy
  Attack use equal-or-higher value; Attack's Mega Hit lets any Hit go on any Hit.
* **Official Jump-In** (sheet 41940): the identical card *cancels* the card it lands on and play
  continues from the jumper. It never adds to a stack.
* **Response cards are common.** NO U, Super Star, Agent P, Avengers Assemble, BFF Power, Flitterific,
  This is the Way, all four Defense Pack wilds, Petty Play and Hail Mary are all played as a reaction to
  someone else's card, outside normal turn order.
* **Speed Pack** turns are chains of N cards, each matching the previous card, where only the last
  card's action fires. Missing the count means drawing N and resetting the speed level to 1.
* **All Wild** is 112 cards, every play is legal, a starting action is ignored, and its Wild Draw Four
  can't be challenged.
* **Flex** cards' flexed color only governs *your* play; the next player still matches the printed
  color. That breaks the assumption that "current color = color of the last card played".
* **UNO Attack**: pressing the launcher ends your turn even if a playable card comes out, the opposite
  of base UNO's play-the-drawn-card option. No Mercy Attack adds the opposite rule for Hits: every press
  must be completed.
* **UNO Ultimate** has no shared draw pile: each player draws from their own 56-card Character Deck,
  and an empty deck eliminates rather than reshuffles. The official order is play, power, defeat, then
  Danger flip, and the player of the Danger-icon card is the one who flips.
* **Several cards trigger when drawn, not played** (Minecraft's Creeper, Cars 3's Crash-Up), and several
  create **persistent links between players** (Frenemies' Nemesis, Love Island's Coupled Up and Eggs In
  One Basket, Party's Drawn Together, Save the Day). Neither hook exists in the engine yet.
* **The implemented Swap Pack differs from the real cards in three ways** (sheet JCV59): official Wild
  Force Trade picks *any two* players; official Swap 1 gives back a card *you choose*; official Refresh
  Hand puts your old hand under the *discard* pile. This port's Refresh Hand matches Captain Marvel's
  Cosmic Crush instead, and its Wild Swap Hands matches the classic deck's and the Comeback Pack's card
  of that name, so both are legitimate cards; they just aren't the Swap Pack's.

### F2. Conflict catalog: decisions the engine has to make once

Each item is a design decision that several mechanics force at the same time. Settling each one once,
as a shared engine rule, avoids per-pair special cases.

1. **Stacking policy has to be an enum, not a boolean.** Six official models: none (base), same type
   one per turn (Progressive), equal-or-higher value (No Mercy), equal-or-higher Hits with every press
   completed (No Mercy Attack), color-gated (Stack Pack), and any Hit on any Hit with play resuming
   after the *first* hitter (Attack Mega Hit). With No Mercy and Stack Pack both on, a Stack 1 can never
   follow a +2 under the value rule. *Recommended:* a card's own text governs its own stacking; the
   global policy covers everything else.
2. **Response windows.** Penalties can be blocked (Defense Wild Block, Avengers Assemble, BFF Power,
   Flitterific, Invisibility, Rockin' Blockin'), reflected to their player (NO U, Super Star, Agent P,
   Block & Rebound +1), or redirected (This is the Way, Block & Deflect, Redirect), and some reactions are
   triggered by someone's UNO call (Hail Mary, Dawg Pound) or by being made to draw (Petty Play).
   Passive blocks also exist (Power Grab towers, Colors Rule Yellow, Remix Shield, Save the Day).
   *Recommended:* one "pending effect" phase in which the target may respond, with defined outcomes for
   block, reflect and redirect, and whose turn follows each. For passive blocks, protection applies if
   it matches the *last* card of a stack, and a block ends the stack with no draw.
3. **Out-of-turn play.** Jump-In, Party's Speed Play (number cards only, with a misplay penalty),
   Avatar State, Veto, Colors Rule Red ("any time"), Petty Play, Hail Mary, and real-time races (Spin's
   "UNO Spin", Reflex, Roboto duels, Kevin's Chili, Shark Attack, Accele-race) all act outside the turn
   order. *Recommended:* a single interrupt system with a priority order (device race, then response
   window, then Jump-In), with Jump-In suppressed while mass discards resolve. Use the official Jump-In
   behavior (cancel and replace, never stack) as the default and offer "adds to the stack" as a house
   option. Powers that say "on your turn" shouldn't work on an out-of-turn play.
4. **Hand movement.** 7-0 passes in the direction of play, Billie Eilish's Wild Pass Color and Disney
   Parks Magic always pass left, Spin 2005's Trade Hands is seat-left, Circle of Life passes one card,
   and Wild Force Trade swaps any two seats. Owned things (Power Grab towers, Colors Rule powers, Flex
   Power Cards, Elite NFL Lineups) stay with the *player*, not the hand. *Recommended:* one swap
   primitive taking two arbitrary seats plus a direction parameter. Don't let swaps target a 0-card
   player in Teams. With No Mercy on, the built-in 7-0 must not double-apply with the 7-0 toggle.
5. **Draw sources, draw-until loops and elimination.** Many cards draw until a predicate is met (Wild
   Draw Color, Color Roulette, Spin's Draw Red/Blue, Sorting Hat, Joker's wild, Bat Signal). Ultimate
   draws from personal decks, Blast's container is outside both piles, and No Mercy sets a knocked-out
   hand aside until the next reshuffle. *Recommended:* a `drawSourceFor(player)` hook; a draw-until
   primitive with reshuffle and a hard cap (Flip Express officially caps Wild Draw Color at 5); and
   elimination checked once after an effect fully resolves, not mid-draw. Drawn Together's mirrored
   draws can eliminate a bystander, so cap them or make that an option.
6. **Who names the Wild color.** Normally the player who played it, but Royal Revenge's King names every
   Wild's color, a Remix named Wild lets the named player pick, Color Roulette has the victim pick,
   Triple Play's Wilds set no color at all, and Flex separates "color you played as" from "color to
   match". *Recommended:* card-specific rule beats a global role, which beats the default. The WD4
   legality check uses the color in force before the Wild, after any pre-play power such as Captain
   Marvel's.
7. **Turn pointer jumps.** Skip Everyone, Tiki Twist's Go To, Remix's Skip-To, extra-turn effects,
   Reflex's "continue after the winner", Elite NFL activations (which end your turn), Royal Revenge's
   fanfare and Flash's random order all move the pointer. *Recommended:* resolve triggered effects
   through a FIFO queue and move the pointer only once the queue is empty. Flash's random order makes
   direction meaningless, so Reverse and direction-based toggles should be disabled with it.
8. **Multi-card plays.** Speed Pack chains, Spin 2025's "2x", Colors Rule Blue, the MOTU movie's Power
   Sword, Keep Pounding, Team Attack, NDJOLIJEAN's same-number multi-discard, Double Down and Fire Fist
   Ace all play more than one card a turn. *Recommended:* one multi-play state with a cap, rather than
   letting them add together. Two +2s played in one 2x turn count as one stack contribution.
9. **Deck shapes that make other toggles inert or incoherent.** No 0s in Flip, Pocket, Attack, Power
   Grab or Colors Rule decks (7-0's half is dead); no Draw Two or WD4 in Triple Play, Tiki Twist, Blast
   or Royal Revenge (stacking has nothing to stack); no colors in All Wild (WD4 challenge, color cards
   and Flex coloring are meaningless, and Jump-In becomes near-constant); animal matching in Junior and
   Choo Choo adds a third match attribute; multiple discard piles in Triple Play and Tippo conflict with
   Flip. *Recommended:* the settings screen greys out toggles that a chosen deck makes inert, and doesn't
   offer combinations like Flip with Flex or Flip with multi-pile at all.
10. **Challenge resolution must be parameterized.** WD4 (4/6), Flip's Wild Draw Two (2/4), Wild Draw
    Color (until color / plus 2), UNO Express's Wild Draw Two (4/4), Progressive's scaled challenge
    penalty, and Liar's UNO's 1-card bluff calls all share one shape with different penalties. On the
    derivative sheets a held Wild counts as a match when checking a challenged hand. Choosing to stack
    instead of drawing should waive the challenge.
11. **Discards outside normal play.** Officially, action cards discarded by an effect **do** take effect
    in Roboto, Eye Eye, Wild Jackpot, Spin 2005, Blast and NDJOLIJEAN, and going out through such a
    discard is allowed (Spin To Go, Roboto, Eye Eye say so explicitly). The exceptions send cards to the
    *bottom* of the pile, where they do nothing (Spin 2025's Color Discard, Mega Minions Power,
    Payback, Eliminator), or say actions are inert (Party's Pile Up, Charlie Brown Christmas Tree).
    *Recommended:* follow each card's official behavior with a per-effect flag, and count going out
    only after the effect fully resolves. (This reverses the earlier recommendation that discarded
    actions never trigger.)
12. **Draw-triggered cards and persistent links.** Cards that act when drawn (Creeper, Crash-Up) need an
    on-draw hook that also fires during penalty draws and draw-until loops. Persistent player links
    (Nemesis, Coupled Up, Eggs In One Basket, Drawn Together, Save the Day) need standing state that
    other effects can query. *Recommended:* treat links like standing effects (A14) with a clear
    "ends when" condition for each.
13. **Two-player degenerate cases.** Reverse acts as Skip; No Mercy's 2-player Wild Reverse Draw 4
    makes its player draw; Skip Two and Skip Everyone become "play again"; Point Taken and Drawn Together
    barely work at 2-4 seats. Classic UNO's old sheets print official 2-player rules. Each mechanic needs
    an explicit 2-player rule, which this engine already has the pattern for (2-player Reverse-as-Skip).
14. **Honor-system cards.** Dares, Truths, Veto, Rad Style, Dumb Fu, Ice the Kicker, the NFL gesture
    races and similar cards can share one prompt framework with an optional self-report button.
    Reaction races (Shark Attack, Kevin's Chili, Touchdown!) can instead be resolved with simulated AI
    reaction times. Wherever a card offers a draw-penalty fallback, implement that fallback as the real
    effect.

### F3. Gaps that would block a specific family

None of these block the cheap tiers. Most remaining gaps are things the official sheets simply don't
print, so they'll need a design decision rather than more research.

* **Copy counts:** many newer sheets print only "112 Cards". Per-type counts are still unknown for
  No Mercy (11 types), the No Mercy Expansion and No Mercy Attack, All Wild, Flex, Teams, Flip Attack and
  most Add-On Packs; 4 copies per bonus Wild is the usual inference.
* **Device odds:** wheel segment sizes, launcher/blaster/Reflex odds and Roboto's trigger frequency are
  hardware behavior, not printed rules. The port will have to pick distributions.
* **Flip:** which Light face backs which Dark face (no sheet documents it; a fixed seeded pairing is the
  fallback).
* **Ultimate:** exact power text for Black Widow and every add-on character (the add-on sheets carry
  only blurbs), the Thanos promo, and the Batman/Harley Quinn packs.
* **Licensed decks with no Mattel sheet:** about 30 bonus cards (Wicked, Moana 2, The Simpsons 2025,
  Superman 2025, Lilo & Stitch, Pixar, Disney Wish, Encanto, Seinfeld, Rick and Morty, the older
  Sababa/Fundex tins) remain snippet-based. See `docs/mechanics/07`.
* **Unverified entirely:** Cricket (#229), WWE Legends' 1-2-3 (#230), NASCAR Drafting (#233), Super
  Bowl LVIII's rule (#218), Elite NFL individual player powers, and the Deadpool No Mercy wilds (#406).

---

*Compiled from a multi-pass automated survey (see Methodology). Titles marked UNKNOWN in Part D should
be re-checked before relying on their RESKIN-by-default assumption for anything load-bearing. Part E's
confidence tags (HIGH/MED/LOW) work the same way — re-verify anything below HIGH before it drives an
actual implementation decision, ideally with direct page fetches rather than search-snippet synthesis.*
