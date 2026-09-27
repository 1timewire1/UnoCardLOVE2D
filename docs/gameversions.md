# UNO gameplay mechanics survey

This document surveys ~500 named UNO releases (physical, digital, and a handful of never-released
concepts) to scope out which ones offer a **gameplay mechanic** genuinely different from base UNO,
versus which ones are **cosmetic reskins** (same rules, licensed artwork). The goal: figure out what
a "mix-and-match" settings menu for this LÖVE port could realistically offer, from easiest to hardest,
and what's simply off the table for a pure digital card-rules engine.

**Bottom line up front:** of ~500 entries, the overwhelming majority (roughly 350+) are cosmetic
reskins — a licensed movie, TV show, sports team, or brand printed on an unmodified 108-card UNO
deck. Genuinely distinct mechanics cluster into a much smaller number of *families* (a few dozen),
because the same mechanic gets reused across many themed reissues (e.g. every "Fandom NFL" team deck
uses the same one added rule card; every "Ultimate Marvel" expansion pack just adds one more
character to the same power system). Part A below catalogs those families. Part C is the full
title-by-title table for traceability back to the source list.

## Methodology and confidence

This survey was produced by six research passes (one per ~80-item chunk of the source list) plus a
manual pass for the "never released" ideas at the end, using product pages, BoardGaneGeek,
GeekyHobbies, the UNO Fandom wiki, Mattel's own rules PDFs, and similar sources. Two important caveats:

* **Reskins are asserted from a strong prior, not verified one-by-one.** With ~350 licensed decks,
  individually confirming "no added card" for each was not practical. The pattern (Mattel prints a
  themed deck with 0-2 bespoke cards, rules otherwise standard) is extremely well established and
  called out explicitly by multiple sources, so it's a safe default — but a specific title tagged
  RESKIN here could turn out to have one overlooked bonus card.
* **A handful of entries are tagged UNKNOWN** where no reliable source could be found at all (mostly
  obscure regional/promotional items). These are called out in Part C and should be treated as "we
  don't actually know," not "confirmed cosmetic."
* Where a family (Fandom NFL, Ultimate Marvel, Elite NFL, Burger King Desafio, Add-On Packs) repeats
  across dozens of numbered entries, Part A describes the mechanic **once**; Part C just points back
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
*doesn't* have yet, **Jump-In** (play an identical card out of turn, skipping to that player). Jump-In
is a natural, cheap addition given the existing turn/legality model. **Tag: EASY.**

### A2. Draw-pile / penalty variants

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Stacking +2/+4/+6/+10, Mercy Rule, 7-Swap, 0-Pass, Color Roulette, Discard All, Skip Everyone | Uno Show 'Em No Mercy (#45, #378, #390, #406-407), digital Ubisoft port | The "maximalist" house-rule pack: draw penalties of every size stack onto the next player; a hand of 25+ cards eliminates you; wilds can force a full-table color change, dump your whole hand of one color, or skip the whole table. | **EASY–MEDIUM** (each piece is a small independent extension of the Stack rule already in the engine; the full combined ruleset is a bigger lift but decomposes cleanly into independent toggles) |
| Reverse Pack: Reverse Draw 2, Reverse Skip, Wild Power Reverse, Wild "NO U" (reflect a penalty back) | Uno Add-On Packs! Reverse Pack (#421) | Combo cards (reverse+draw, reverse+skip) plus a card that redirects an incoming draw penalty back at whoever played it. | **EASY** |
| Stack Pack: Stack 1/2/3, Wild Stack Number (random N via flipped card) | Uno Add-On Packs! Stack Pack (#422) | Officializes stacking as cards rather than a blanket house rule, plus a "roll the top card" random-N draw. | **EASY** |
| Wild Jackpot: shared growing "Jackpot" draw pile, dumped on a player when triggered | Uno Wild Jackpot (#27), Arby's tie-ins (#342, #367) | A running pile of drawn cards accumulates in the middle; a Jackpot card dumps the whole pile on someone. | **MEDIUM** (needs a new shared-pile state) |
| Novelty fixed-N draws: Draw 73, Draw 100, "everyone else draws 4" | Pizza 73 promo (#488), No Mercy April Fools card (#487), unreleased idea (#494) | Just the existing draw-N action generalized to arbitrary N and to "all opponents" as target. | **EASY** |
| Power Grab towers (collect U/N/O + a 4th to void Draw 1/2/Wild+4, or empty your hand) | Uno Power Grab (#104) | A meta-resource layer: collecting a set of 4 tokens grants powerful one-time effects. | **MEDIUM** |

### A3. Turn-order and targeting variants

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Bullseye targeting (choose who an action card hits, instead of always "next player") | Mini Uno Bullseye (#418) | Turns single-target action cards into player-choice-target cards. | **EASY** (the codebase's 7-0 already has a "choose a player" UI to reuse) |
| Swap Pack: swap 1 card, refresh whole hand, force-trade two players, pass-all-hands | Uno Add-On Packs! Swap Pack (#420) | A cluster of hand-manipulation cards; "pass all hands" is exactly 7-0's "0" effect done via a card instead of a number. | **EASY** |
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
| Spin wheel (Spin card triggers a spin: discard-all-of-color, draw-until-X, swap hands, double effect, etc.) | Uno Spin (#15, #107, #137, #242, #274?, #381-382) | A small table of named outcomes selected randomly. | **EASY–MEDIUM** (the outcome table itself is straightforward; needs a short spin animation for feel, but no new rule primitives) |
| Roboto / Tiki Twist / Eye Eye Spongebob (a device randomly picks a house rule or a target player) | Uno Roboto (#103), Uno Tiki Twist (#106), Uno Eye Eye Spongebob (#111) | Same shape as Spin: random selection from a small table, sometimes also picking *who* it applies to. | **EASY–MEDIUM** |
| Flash / Reflex / Showdown (real-time reaction races: hit a button first, or lose) | Uno Flash (#23), Uno Reflex (#108), Uno Showdown (#37, #105) | Turn order becomes "whoever reacts fastest," or two players race to slap a paddle. | **HARD, awkward fit** — this is a turn-based, coroutine-driven engine (see `src/game.lua`) playing against three AI seats; a real-time reflex mechanic requires either faking AI reaction times (which feels arbitrary) or turning part of the game into an actual timing minigame. Feasible in principle, low value here. |
| Tippo (balance-scale that can "tip" and force a draw) | Uno Tippo (#24) | Two discard piles on a physical tipping scale; overloading one side costs you. | **MEDIUM** (can model the "scale" as a simple counter with a tip threshold; no physical balance needed) |
| Triple Play trays (3 simultaneous discard piles, "overload" penalty) | Uno Triple Play (#16, #112) | Structural: the single discard pile becomes three, with rules about which are legal targets. | **HARD** (touches the core single-discard-pile assumption throughout `src/uno.lua`) |
| Wild Jackpot Roller / pre-written custom rules on erasable cards | Uno Wild Jackpot (#27), Uno Happy Birthday (#306), Uno House Rules! (#29, #368), NDJOLIJEAN (#346), customizable-wild ideas (#498-499, #503) | Players write a house rule on a blank card pre-game; when it's drawn/played, that rule applies. | **MEDIUM to implement the mechanism** (a free-text "custom card" with a player-entered label is easy); **the rule's actual effect is unenforceable by software** unless it's picked from a fixed menu of pre-coded effects, in which case this just becomes "let the player assemble their own action card from existing primitives" — a nice generic feature once several EASY mechanics above exist as building blocks. |
| Uno Rush / online timed play (see opponents' hands, time-limited turns) | Uno Rush (#366) | A visible-hands, timer-pressured mode. | **MEDIUM** (mostly a UI/AI-difficulty question; showing opponents' hands is trivial, timing pressure needs a turn timer) |

### A6. Alternate deck compositions

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| All Wild (every card in the deck is some Wild/action type; no color/number matching at all) | Uno All Wild (#28), Pocket All Wild (#284) | Fundamentally changes what "legal card" means. | **EASY–MEDIUM** (a deck-composition setting, plus making the legality check permissive for this mode) |
| Reduced/"Pocket" 52-card deck (numbers 1-9 only, draw-1 instead of draw-2/4) | Uno Pocket lines (#51-52, #340, #399) | A smaller, faster deck. | **EASY** (a deck-size/content variant) |
| Junior/Choo Choo/Mein Erstes Uno (kids' simplified rules: match by icon, no action cards, or a curated subset by difficulty tier) | Mein Erstes Uno (#350), Uno Junior Move! (#362), Uno Choo Choo (#391) | Selectable difficulty tiers, from "match only" up to full rules. | **EASY** (this is just exposing the existing rule toggles as a friendlier tiered preset) |

### A7. Character / power-card systems

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Ultimate Marvel / Ultimate DC (each player secretly picks a character with a personal mini-deck and a printed passive power that triggers on specific conditions — e.g. "when you play a danger-symbol card, everyone else burns a card"; two win conditions: empty your hand, or be the last player with cards left in your character deck) | Uno Ultimate Marvel (#56-57, #59-71, #395), Uno Ultimate DC (#58, #72-73) | Confirmed via Mattel/GameRules/GeekyHobbies. A genuinely different meta-layer: asymmetric player powers plus a second, per-character resource. | **HARD** — the *framework* (give each player an optional passive ability that triggers on a condition) is a reasonable, self-contained system to build; but the survey found 18+ distinct named characters, each with bespoke rules text that would need individually implementing and balancing. Recommend building the framework and shipping a handful of hand-picked powers rather than the full roster. |
| Elite NFL "Elite Icon" (playing a marked base card unlocks a drafted NFL Player Card's special power) | Uno Elite NFL Core/Alt Jerseys Edition (#408-409, #467-474) | A drafting/collection layer on top of standard play; several foil rarity tiers, only one ("Viper," confirmed to count as all 4 colors) verified to have an actual rule effect beyond collectibility. | **HARD**, same reasoning as Ultimate Marvel — build the generic "unlockable ability" framework, don't chase all 56+ player cards. |
| Fandom NFL team rule card (each of the ~30 team decks adds one bonus foil card with a small themed rule, e.g. a "signal touchdown or draw 3" prompt) | Uno Fandom NFL line (#218-224, #440-466) | A single lightweight bonus card per deck, not a system — despite the huge number of SKUs, this is one small mechanic reused ~30 times with only cosmetic differences. | **EASY** (one generic "themed bonus wild" toggle covers the entire line) |
| Danger/Enemy cards with an ongoing penalty until "defeated" | Ultimate Thanos Promo Card (#395) | A card that imposes a standing restriction on whoever drew it until a condition is met. | **MEDIUM** (needs a "standing effect on a player" concept, otherwise absent from the engine) |

### A8. Dares, truths, and other real-world prompts

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Dare! (choose: perform a dare, or draw as a penalty) | Uno Dare! (#12), Adults Only (#41), Dare advertisement pre-written dares (#496) | A binary choice card with a real-world stakes side. | **NOT FEASIBLE (unenforceable)** for the "perform the dare" branch, but the "or draw N" branch is trivially EASY — recommend implementing only the penalty-draw fallback, optionally showing dare flavor text for local human players to use informally. |
| Truth / Spin Adults Only (answer a personal question or take a penalty) | Uno Truth Adults Only (#380), Uno Spin Adults Only (#382) | Same shape as Dare. | Same as above. |
| Emoji face-holding, BTS dance, "Move!" jump/clap/dance, Mazda car-noises, Star Wars "toss cards like an exhaust port" | Uno Emoji (#359), Uno BTS (#11), Uno Junior Move! (#362), unreleased Mazda card (#495), Star Wars Technical Schematics flavor rule (#193) | Cards whose entire effect is "do a physical/social thing." | **NOT FEASIBLE (unenforceable)** — can be shown as flavor text for local play, has zero enforceable game-state effect. |
| WWE "Locked Up" 1v1 duel (both players reveal/play a number card, higher wins, loser draws both) | Uno WWE (#230-231) | A self-contained mini-duel between two specific players. | **EASY** (a simple "both reveal highest number" comparison) |
| Nascar "Drafting" (play up to 2 extra matching-color cards immediately after a wild) | Uno Nascar (#233) | A bonus-cards-in-one-turn effect. | **EASY** |
| X Games renamed action cards (new names, several genuinely new numeric effects: Wild Draw 5/10, discard-down-to-5, reverse+discard-a-color) | Uno X Games (#234) | A themed set of otherwise-standard-shaped new action cards. | **EASY** |
| Liar's Uno (play a card face-down, bluff what it is; others can challenge; wrong claims cost the liar a card, wrong challenges cost the challenger) | Liar's Uno Trust No One (#475) | A genuine bluffing/challenge subsystem layered on discard-matching. | **MEDIUM–HARD** — logic is self-contained, but a believable AI bluffing/calling strategy is real work (the existing AI already handles one bluff-adjacent decision: challenging a Wild+4). |

### A9. Scoring and win-condition variants

| Mechanic | Found in | Description | Tag |
|---|---|---|---|
| Cricket-style running score to 500, lowest wins, themed cards (Four/Six/Wicket/Over) replace standard actions | Uno Cricket (India) (#229) | Replaces "empty your hand first" with an accumulating-score game across rounds. | **MEDIUM** (the existing per-game scoring already tracks hand values; this needs a different round-to-round scoring loop, not first-empty-hand-wins) |
| H2O Splash "best of 3 hands" | Uno H2O Splash (#47) | Match structure of 3 short games instead of 1. | **EASY** (a match-length setting) |
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
* **Uno Undercover (#235)**'s 9 power-up cards, **Uno CD-ROM (#236)**'s hand-size-hiding Spy Card, and
  **Uno Famicom's (#364)** Board Game mode are the most structurally novel finds of the whole digital
  research pass - none of them are just reskins with a bonus wild card. See Part E4.

### A13. Never-released ideas

See the dedicated table below (Part B) — these are one-off marketing/prototype cards, not full
products, and are mostly either trivial numeric variants or unenforceable novelty prompts.

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
| 497 | Cut command cards from Uno Undercover | Prototype cards for an existing secret-mission mechanic; specifics undocumented. | N/A |
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
(73/100/all-opponents-4) · Team Attack multi-discard · WWE "Locked Up" duel · Nascar Drafting bonus plays ·
X Games renamed action set · All Wild deck mode · Pocket reduced-deck mode · Junior/tiered-difficulty
presets · Fandom NFL-style "one themed bonus wild" toggle · H2O Splash best-of-3 match structure ·
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
Color Roulette, Discard All, Skip Everyone — each on its own toggle) · Wild Jackpot's growing shared
pile · Power Grab towers · Royal Revenge King/Jester role · Tippo's tipping-scale counter · Danger/Enemy
standing-effect cards · Cricket-style running-score match mode · a generic "assemble your own action
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
| 1 | Uno 50th Anniversary Icon Series 1971 | RESKIN | Decade-themed retro-art collector deck; standard UNO rules. Some sources note 8 Wild cards instead of 4, otherwise cosmetic. |
| 2 | Uno 50th Anniversary Icon Series 1980 | RESKIN | 1980s-themed retro art, standard rules. |
| 3 | Uno 50th Anniversary Icon Series 1990 | RESKIN | 1990s-themed retro art, standard rules. |
| 4 | Uno 50th Anniversary Icon Series 2000 | RESKIN | 2000s-themed retro art, standard rules. |
| 5 | Uno 50th Anniversary Icon Series 2010 | RESKIN | 2010s-themed retro art, standard rules. |
| 6 | Uno 50th Anniversary Premium Set | MECHANIC | "50/50" card: coin-flip decides who draws 4 extra. See A2. |
| 7 | Nonpartisan Uno | MECHANIC (novelty) | Orange/purple instead of red/blue; "Veto" out-of-turn interrupt card. See A8. |
| 8 | Base Uno (1980) | RESKIN | Historical baseline release; reference point, not a variant. |
| 9 | Uno Attack | MECHANIC | Card-launcher random draw; Hit 2, Wild Hit 4. See A5. |
| 10 | Uno Left Hand | UNKNOWN | Not confirmed as a distinct product; likely a "pass hand left" house rule. |
| 11 | Uno BTS | MECHANIC (minor) | "Dancing Wild" — dance or draw 3. See A8. |
| 12 | Uno Dare! | MECHANIC | Dare/Wild Dare: perform a dare or draw. See A8. |
| 13 | Uno Flip! | MECHANIC | Double-sided Light/Dark deck. See A4. |
| 14 | Uno Artiste Jean-Michel Basquiat | RESKIN | Collector art deck; 4 decorative-only extra cards, standard play. |
| 15 | Uno Spin (2005) | MECHANIC | Spinning wheel on action/wild play. See A5. |
| 16 | Uno Triple Play | MECHANIC | 3 simultaneous discard piles, overload penalty. See A5. |
| 17 | Skip-Bo | DIFFERENT-GAME | Sequencing game, no color/number discard matching. See A10. |
| 18 | Uno Blitzo | DIFFERENT-GAME | Electronic reaction/button-pad game, no card play. See A10. |
| 19 | Dos (First Edition) | DIFFERENT-GAME | Two piles, sum-matching instead of equality. See A10. |
| 20 | Uno Quatro | DIFFERENT-GAME | Connect-Four fused with UNO tiles. See A10. |
| 21 | Uno Mariokart | MECHANIC (minor) | Item-Box wild cards (5 effects). |
| 22 | Uno The Office | MECHANIC (minor) | "Kevin's Famous Chili" — all drop cards, last draws 2. |
| 23 | Uno Flash | MECHANIC | Random-turn-order light-up unit + SLAP card. See A5. |
| 24 | Uno Tippo | MECHANIC | Tipping-scale two-pile mechanic. See A5. |
| 25 | Uno Flex! | MECHANIC | Two-sided "Power Card" gates an alternate stronger card effect. |
| 26 | Uno Super Mario | MECHANIC (minor) | "Super Star" counters + customizable wilds. |
| 27 | Uno Wild Jackpot | MECHANIC | Wild Roller device dispenses pre-written custom rules. See A5. |
| 28 | Uno All Wild | MECHANIC | Every card is Wild/action type. See A6. |
| 29 | Uno House Rules! | MECHANIC | Player-authored dynamic rules per number. See A1/A5. |
| 30 | Uno Party! | MECHANIC | 6-16 player mechanics: Point Taken, Drawn Together, Pile Up, Speed Play. See Part C roadmap (ARCHITECTURAL). |
| 31 | Dos Second Edition | DIFFERENT-GAME | Revised two-pile addition mechanic. See A10. |
| 32 | Uno Sonic the Hedgehog | MECHANIC (minor) | "Victory Lap" — all others draw 1. |
| 33 | Uno Minecraft | MECHANIC (minor) | "Creeper" card — forced reveal + draw 3. |
| 34 | Uno Pokémon | MECHANIC (minor) | "Trainer" card — full hand swap. |
| 35 | Uno Pokémon (Asia) | MECHANIC (minor) | Regional special cards (Snorlax/Greninja), effects unconfirmed. |
| 36 | Uno Harry Potter and the Sorcerer's Stone | MECHANIC (minor) | "Voldemort"/"Harry" multi-discard; "Gryffindor" forced-draw-until. |
| 37 | Uno Showdown | MECHANIC | Physical reflex paddle duel + 500-pt scoring. See A5. |
| 38 | Ono 99 | DIFFERENT-GAME | Running-total-to-99 elimination game. See A9. |
| 39 | Uno Splash | RESKIN | Waterproof plastic cards, standard rules. |
| 40 | Uno H2O | MECHANIC (minor) | Wild "Downpour" 1/2 — force draws. |
| 41 | Uno Dare Adults Only | MECHANIC | Escalating dare tiers via die roll. See A8. |
| 42 | Uno Monster High | MECHANIC (minor) | Two bespoke Wild cards (color give-away, multi-discard+share). |
| 43 | Uno Dice Game: Roll and Write! | DIFFERENT-GAME | Dice + scoresheet chain game. See A10. |
| 44 | Uno Stacko | DIFFERENT-GAME | Jenga-style block tower. See A10. |
| 45 | Uno Show 'Em No Mercy | MECHANIC | Full "No Mercy" ruleset. See A2. |
| 46 | Uno Flip (2009) | MECHANIC | Likely mislabel/duplicate of #13 (Flip debuted 2019). |
| 47 | Uno H2O Splash | MECHANIC | Shake-to-reveal "Whirlpool" device; best-of-3 match. See A5/A9. |
| 48 | Blokus Shuffle: Uno Edition | DIFFERENT-GAME | Blokus tile-placement with an UNO card layer. See A10. |
| 49 | Uno Milk Chocolate Edition | RESKIN | Cards printed on chocolate wrappers; no rule change. |
| 50 | Uno UpUp DownDown | RESKIN | WWE collab; "Wild Challenge!" is a re-themed Wild Draw Four. |
| 51 | Uno Pocket Pizza Pizza | MECHANIC (minor) | Reduced 52-card "Pocket" deck + exclusive Wild. See A6. |
| 52 | Uno Pocket Pizza 73 | MECHANIC (minor) | Same Pocket format, different exclusive Wilds. |
| 53 | Uno Extreme | MECHANIC | Same mechanic as Attack (#9), different regional name. |
| 54 | Uno Attack (2020) | MECHANIC | Revised launcher hardware + revised action-card set. |
| 55 | Boom-O | DIFFERENT-GAME | Countdown-timer elimination game. See A9. |
| 56 | Uno Ultimate Marvel | MECHANIC | Character power-card system, dual win conditions. See A7. |
| 57 | Uno Ultimate Marvel Second Edition | MECHANIC | Same system, refreshed roster. |
| 58 | Uno Ultimate DC | MECHANIC | Same system, DC characters. |
| 59 | Uno Ultimate Marvel Ms. Marvel Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
| 60 | Uno Ultimate Marvel Spider-Man Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
| 61 | Uno Ultimate Marvel Loki Expansion Pack | MECHANIC | Adds one character to the Ultimate Marvel system. |
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
| 74 | Uno Happy Feet | RESKIN | Cosmetic reskin, standard UNO rules. |
| 75 | Uno Ghostbusters | RESKIN | Cosmetic reskin, standard UNO rules. |
| 76 | Uno Encanto | RESKIN | Cosmetic reskin, standard UNO rules. |
| 77 | Uno Planes | RESKIN | Cosmetic reskin, standard UNO rules. |
| 78 | Uno Captain Marvel | RESKIN | Cosmetic reskin (distinct from the Ultimate Marvel line's Captain Marvel). |
| 79 | Uno Cars 2 | RESKIN | Cosmetic reskin, standard UNO rules. |
| 80 | Uno Jurassic World | RESKIN | Cosmetic reskin, standard UNO rules. |
| 81 | Uno Star Wars | RESKIN | Cosmetic reskin, standard UNO rules. |
| 82 | Uno The Lion King | RESKIN | Cosmetic reskin, standard UNO rules. |
| 83 | Uno Avengers | RESKIN | Cosmetic reskin (distinct from the mechanically-different Ultimate Marvel line). |
| 84 | Uno Cars 3 | RESKIN | Cosmetic reskin, standard UNO rules. |

### #85–168

| # | Title | Category | Mechanic Notes |
|---|-------|----------|-----------------|
| 85 | Uno Incredibles 2 | RESKIN | Cosmetic reskin, standard UNO rules. |
| 86 | Uno Trolls World Tour | RESKIN | Cosmetic reskin, standard UNO rules. |
| 87 | Uno Toy Story 4 | RESKIN | Cosmetic reskin, standard UNO rules. |
| 88 | Uno Frozen 2 | RESKIN | Cosmetic reskin, standard UNO rules. |
| 89 | Uno Shrek 2 | RESKIN | Cosmetic reskin, standard UNO rules. |
| 90 | Uno Kung Fu Panda | RESKIN | Cosmetic reskin, standard UNO rules. |
| 91 | Uno Superman Returns | RESKIN | Cosmetic reskin, standard UNO rules. |
| 92 | Uno Pirates of the Caribbean | RESKIN | Cosmetic reskin, standard UNO rules. |
| 93 | Uno Dominos | DIFFERENT-GAME | UNO effects layered on domino tile-matching. See A10. |
| 94 | Uno Hearts | DIFFERENT-GAME | Trick-taking Hearts with UNO wilds mixed in. See A10. |
| 95 | Uno Wild Twists Playing Cards | DIFFERENT-GAME | Poker deck + wilds, own "Wild Race" game. See A10. |
| 96 | Uno Cobs Game Changers Cards | MECHANIC | Promo insert cards shuffled into a standard deck (All Draw Two, Wild Shuffle 'Em Up, See The Future, Wild Draw Eight, Wild Face Up). |
| 97 | Phase 10 | DIFFERENT-GAME | Complete-10-phases rummy-style game. See A10. |
| 98 | Uno Bingo | DIFFERENT-GAME | Tile/dice bingo game. See A10. |
| 99 | Uno Wild Tiles | DIFFERENT-GAME | Arrow-directed tile-laying game. See A10. |
| 100 | Uno Dice (1987) | DIFFERENT-GAME | Dice-as-hand variant of UNO's matching idea. See A10. |
| 101 | Uno Dice Game (Can) | UNKNOWN | Likely Canadian release of #100; not fully confirmed. |
| 102 | Luck Plus | DIFFERENT-GAME | Cards + dice, light math game "from the makers of UNO." See A10. |
| 103 | Uno Roboto | MECHANIC | Electronic dealer triggers random house-rule ALL-PLAY races. See A5. |
| 104 | Uno Power Grab | MECHANIC | "Power Tower" collection voids penalty cards. See A2. |
| 105 | Uno Showdown Supercharged | MECHANIC | Slap-paddle reflex duel. See A5. |
| 106 | Uno Tiki Twist | MECHANIC | Spinning idol randomizer/targeter. See A5. |
| 107 | Uno Spin To Go! | MECHANIC | Portable Uno Spin wheel. See A5. |
| 108 | Uno Reflex | MECHANIC | Light-up reaction-race unit. See A5. |
| 109 | Uno Attack Jurassic World | MECHANIC | Attack-family launcher, dinosaur theme. See A5. |
| 110 | Uno Blast | MECHANIC | Attack-family variant with a slot-choice risk mechanic. |
| 111 | Uno Eye Eye Spongebob! | MECHANIC | Eyes-spin randomizer/targeter. See A5. |
| 112 | Uno Triple Play Stealth | MECHANIC | Triple Play with hidden overload warnings. See A5. |
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
| 125 | Uno Nickelodeon Spongebob Squarepants | RESKIN | Cosmetic reskin, standard UNO rules. |
| 126 | Uno Nickelodeon Spongebob Squarepants Special Edition (2002) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 127 | Uno Nickelodeon Spongebob Squarepants Meme | RESKIN | Cosmetic reskin, standard UNO rules. |
| 128 | Uno Rick and Morty | RESKIN | Standard rules + one "Mr. Meeseeks" discard-search card. |
| 129 | Uno Teen Titans Go! | RESKIN | Cosmetic reskin, standard UNO rules. |
| 130 | Uno DragonBall Z | RESKIN | Cosmetic reskin, standard UNO rules. |
| 131 | Uno Saved By The Bell | RESKIN | Cosmetic reskin, standard UNO rules. |
| 132 | Uno Friends | RESKIN | Cosmetic reskin, standard UNO rules. |
| 133 | Uno Hanna Barbera | RESKIN | Cosmetic reskin, standard UNO rules. |
| 134 | Uno Ultimate Spider-Man Web Warriors | RESKIN | Cosmetic reskin, not tied to the Ultimate Marvel powers system. |
| 135 | Uno Hannah Montana (2007 On Tour) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 136 | Uno Hannah Montana (2007 Best of Both Worlds) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 137 | Uno Spin Hannah Montana | MECHANIC | Uno Spin wheel mechanic, themed. See A5. |
| 138 | Uno The Big Bang Theory | RESKIN | Standard rules + "Kitty" forced-draw-until-Sheldon/Penny card. |
| 139 | Uno One Piece (2003) | UNKNOWN | Could not verify; likely early-2000s reskin. |
| 140 | Uno Doctor Who | RESKIN | Standard rules + "Exterminate" fewest-cards-draws-4 card. |
| 141 | Uno Spy X Family | RESKIN | Standard rules + 4 original special cards (effects unconfirmed). |
| 142 | Uno Glee | RESKIN | Cosmetic reskin, standard UNO rules. |
| 143 | Uno Flip! Stranger Things | MECHANIC | Uno Flip mechanic + themed extra cards. See A4. |
| 144 | Uno Schitt's Creek | RESKIN | Standard rules + "Where Everyone Fits In" reveal-and-draw card. |
| 145 | Uno Ted Lasso | RESKIN | Standard rules + "Roy Kent Grunt" extra-draw card. |
| 146 | Uno Yellowstone | RESKIN | Standard rules + "Yellowstone Brand" forced-draw card. |
| 147 | Uno DC Super Hero Girls | RESKIN | Standard rules + "Save the Day" immunity wild. |
| 148 | Uno Shark Week | RESKIN | Standard rules + "Shark Attack" slap-race card. |
| 149 | Uno Masters of the Universe | UNKNOWN | Could not verify specific rules. |
| 150 | Uno The Muppet Show | RESKIN | Cosmetic reskin, standard UNO rules. |
| 151 | Uno Nickelodeon | RESKIN | Cosmetic reskin, standard UNO rules. |
| 152 | Uno Peanuts A Charlie Brown Christmas | RESKIN | Cosmetic reskin, standard UNO rules. |
| 153 | Uno Seinfeld | RESKIN | Standard rules + "Wild Seinfeld Episode" (choose 1 of 8 pre-set rules). |
| 154 | Uno USA | RESKIN | Cosmetic reskin, standard UNO rules. |
| 155 | Uno American Kennel Club Sporting Group (2006) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 156 | Uno Angry Birds | RESKIN | Cosmetic reskin, standard UNO rules. |
| 157 | Uno The Legend of Zelda | RESKIN | Standard rules + "Wild Triforce" symbol-match card. |
| 158 | Uno 52 | MECHANIC | Parallel poker-hand hybrid, reduced challenge penalty. See A3. |
| 159 | Uno Royal Revenge | MECHANIC | King/Jester role system with electronic scepter. See A3. |
| 160 | Uno Rummy Up | DIFFERENT-GAME | Rummikub tile-rummy with UNO action tiles. See A10. |
| 161 | Uno Unocorns | RESKIN | Standard rules + "Wild Narwhal" forehead-guessing card. |
| 162 | Uno Colors Rule! | MECHANIC | Steal-able "Special Color Power Cards." See A3. |
| 163 | Uno Spider Sense Spider-Man | RESKIN | Standard rules + "Spider-Sense" and "Web Slinger" cards. |
| 164 | Uno Remix! | MECHANIC | Evolving "remix" card stack, including blank write-on cards. See A5. |
| 165 | Uno Barbie The Movie | RESKIN | Standard rules + "Played With Too Much" color-discard wild. |
| 166 | Uno Batman Begins | RESKIN | Cosmetic reskin, standard UNO rules. |
| 167 | Uno Batman v Superman | RESKIN | Cosmetic reskin, standard UNO rules. |
| 168 | Uno Cars (2012) | RESKIN | Cosmetic reskin, standard UNO rules. |

### #169–252

| # | Title | Category | Mechanic Notes |
|---|-------|----------|-----------------|
| 169 | Uno Cars (2014) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 170 | Uno Disney Wish | RESKIN | Cosmetic reskin, standard UNO rules. |
| 171 | Uno Disney Pixar Finding Dory | RESKIN | Cosmetic reskin, standard UNO rules. |
| 172 | Uno Disney Frozen (2014) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 173 | Uno Disney Frozen (2016) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 174 | Uno Green Lantern | RESKIN | Cosmetic reskin, standard UNO rules. |
| 175 | Uno Harry Potter (2005) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 176 | Uno Harry Potter (2010) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 177 | Uno Harry Potter (2018) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 178 | Uno Harry Potter (2021) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 179 | Uno High School Musical | RESKIN | Cosmetic reskin, standard UNO rules. |
| 180 | Uno High School Musical 2 | RESKIN | Cosmetic reskin, standard UNO rules. |
| 181 | Uno Jurassic World Dominion | RESKIN | Cosmetic reskin, standard UNO rules. |
| 182 | Uno Justice League | RESKIN | Cosmetic reskin, standard UNO rules. |
| 183 | Uno Disney Pixar Lightyear | RESKIN | Cosmetic reskin, standard UNO rules. |
| 184 | Uno Minions Rise of Gru | RESKIN | Cosmetic reskin, standard UNO rules. |
| 185 | Uno The Nightmare Before Christmas (2007) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 186 | Uno The Nightmare Before Christmas (2017) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 187 | Uno The Peanuts Movie | RESKIN | Cosmetic reskin, standard UNO rules. |
| 188 | Uno Peanuts It's The Great Pumpkin Charlie Brown (2006) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 189 | Uno Nickelodeon Dreamworks The Penguins of Madagascar | RESKIN | Cosmetic reskin, standard UNO rules. |
| 190 | Uno Ratatouille | RESKIN | Cosmetic reskin, standard UNO rules. |
| 191 | Uno Space Jam A New Legacy | RESKIN | Cosmetic reskin, standard UNO rules. |
| 192 | Uno Spirit Untamed | RESKIN | Cosmetic reskin, standard UNO rules. |
| 193 | Uno Star Wars Technical Schematics | RESKIN | Flavor-only "toss cards" rule, no mechanical effect. See A8. |
| 194 | Uno Teenage Mutant Ninja Turtles Mutant Mayhem | RESKIN | Cosmetic reskin, standard UNO rules. |
| 195 | Uno Hotwheels (2020) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 196 | Uno Disney Princess (2020) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 197 | Uno Disney Mickey Mouse and Friends (2021) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 198 | Uno Flip! Marvel | MECHANIC | Uno Flip mechanic, Marvel theme. See A4. |
| 199 | Uno Coca-Cola (2004) | MECHANIC | Exclusive "Thirst" card/rule (exact effect undocumented). |
| 200 | Uno Jelly Belly | MECHANIC | Jelly-bean resource-accumulation mechanic tied to draw cards. |
| 201 | Uno Burger King Desafio: Dinossauros (Brazil) | MECHANIC | "Carta Desafio" dare-or-draw-5 card. See A8. |
| 202 | Uno Burger King Desafio: Música (Brazil) | MECHANIC | Same Desafio mechanic, music theme. |
| 203 | Uno Burger King Desafio: Monstros (Brazil) | MECHANIC | Same Desafio mechanic, monster theme. |
| 204 | Uno Burger King Desafio: Robós (Brazil) | MECHANIC | Same Desafio mechanic, robot theme. |
| 205 | Uno Burger King Desafio: Princesa (Brazil) | MECHANIC | Same Desafio mechanic, princess theme. |
| 206 | Uno Burger King Desafio: Sereia (Brazil) | MECHANIC | Same Desafio mechanic, mermaid theme. |
| 207 | Uno McDonald's Party Games (Japan) | UNKNOWN | Could not verify; possibly a mislabeled 2026 anime collab (standard/All-Wild/Flip variants). |
| 208 | Uno The Amazing Spider-Man (2023) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 209 | Uno Batman (2005) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 210 | Uno Fantastic Four (2005) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 211 | Uno The Incredible Hulk (2003) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 212 | Uno Marvel Heroes (2010) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 213 | Uno Superman (2006) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 214 | Uno X-Men (2003) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 215 | Uno New York Giants (2006) | MECHANIC | Era "Champs Card" forced-draw-until rule. |
| 216 | Uno NBA All Stars Western Conference | UNKNOWN | Specific added card not confirmed. |
| 217 | Uno MLB Stars of the American League | MECHANIC | "Top 2" card forces the two lowest-hand players to draw. |
| 218 | Uno Fandom NFL Super Bowl LVIII Kansas City Chiefs | MECHANIC | Fandom NFL "Touchdown" rule + exclusive foil card. See A7. |
| 219 | Uno Fandom NFL Pittsburgh Steelers | MECHANIC | Same Fandom NFL mechanic, team art only. |
| 220 | Uno Fandom NFL San Francisco 49ers | MECHANIC | Same Fandom NFL mechanic, team art only. |
| 221 | Uno Fandom NFL Philadelphia Eagles | MECHANIC | Same Fandom NFL mechanic, team art only. |
| 222 | Uno Fandom NFL Dallas Cowboys | MECHANIC | Same Fandom NFL mechanic, team art only. |
| 223 | Uno Fandom NFL New England Patriots | MECHANIC | Same Fandom NFL mechanic, team art only. |
| 224 | Uno Fandom NFL Kansas City Chiefs | MECHANIC | Same Fandom NFL mechanic, team art only. |
| 225 | Uno Arsenal Highbury Legends | MECHANIC | Red Card/Yellow Card penalty cards. |
| 226 | Uno New York Mets David Wright | MECHANIC | "Hot Corner" card/rule, no standard equivalent. |
| 227 | Uno NFL New England Patriots Special Edition (2005) | MECHANIC | Era "Champs Card" mechanic (see #215). |
| 228 | Uno NBA Kobe Bryant Special Edition (2007) | MECHANIC | "Three-Pointer" forced-draw-until card. |
| 229 | Uno Cricket (India) (2021) | DIFFERENT-GAME | Running-score win condition, cricket-themed cards. See A9. |
| 230 | Uno WWE Legends Special Edition (2006) | MECHANIC | "1-2-3" card + "Locked Up" 1v1 duel. See A8. |
| 231 | Uno WWE (2017) | MECHANIC | "Locked Up" number-duel card. See A8. |
| 232 | Uno WWE (2010) | UNKNOWN | Plausibly the same "Locked Up" mechanic; unconfirmed. |
| 233 | Uno Nascar (2005) | MECHANIC | "Drafting" bonus-plays wild. See A8. |
| 234 | Uno X Games | MECHANIC | Renamed action-card set with several new effects. See A8. |
| 235 | Uno Undercover | DIGITAL-ONLY | Dev. Golden Goose/RealArcade, PC only (no DS version - that's a separate plain Gameloft port). Standard deck + 9 named "power-up cards," some played as 2-card combos. See Part E4. |
| 236 | Uno CD-ROM | DIGITAL-ONLY | Mattel Media/Interactive, ~1999-2002. Adds Spy Card (hides your hand-size from opponents) + Mutant/Shark Cards (names known, effects undocumented). See Part E4. |
| 237 | Uno Game Boy Color | DIGITAL-ONLY | Dev. HotGen (not Genki), 1999. Adds a Challenge mode that inverts scoring: reaching a point ceiling eliminates you instead of winning. See Part E4. |
| 238 | Uno + Skip-Bo 2 Game Pack (Game Boy Advance) | RESKIN | Two unmodified separate games bundled on one cartridge. |
| 239 | Uno Free Fall (Game Boy Advance) | DIFFERENT-GAME | Falling-block tile-matching puzzle game. See A10. |
| 240 | Uno Free Fall (Java Mobile Game) | DIFFERENT-GAME | Same falling-block puzzle mechanic as #239. |
| 241 | Uno (Java Mobile Game) (2009) | DIGITAL-ONLY | Gameloft; same product line as #114. Quick Play/Tournament (5 escalating rounds)/Custom Game (9 toggleable rules, only 2 named). See Part E3. |
| 242 | Uno Spin (Java Mobile Game) | MECHANIC | Digital Uno Spin wheel mechanic. See A5. |
| 243 | Uno & Friends (Java Mobile Game) (2012) | DIGITAL-ONLY | Gameloft, distinct from the 2013 online version (#376). "Uno World Tour" (6 venues x 5 stages, some stages are non-UNO minigames) + Hot Seat. See Part E3. |
| 244 | Uno DirecTV Game Lounge | DIGITAL-ONLY | Dev. Denki, interactive-TV port; no unique rule found beyond delivery method. See Part E4. |
| 245 | Uno Paw Patrol (2015) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 246 | Uno Mickey Mouse and Friends (2017) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 247 | Uno South Park | RESKIN | Cosmetic reskin, standard UNO rules. |
| 248 | Uno Disney (2002) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 249 | Uno Disney (2016) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 250 | Uno Disney 100 | RESKIN | Cosmetic reskin, standard UNO rules. |
| 251 | Uno Disney Pixar Coco | RESKIN | Cosmetic reskin, standard UNO rules. |
| 252 | Uno Toy Story (2008) | RESKIN | Cosmetic reskin, standard UNO rules. |

### #253–336

| # | Title | Category | Mechanic Notes |
|---|-------|----------|-----------------|
| 253 | Uno Toy Story 3 (2009) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 254 | Uno Trolls Band Together | RESKIN | Cosmetic reskin, standard UNO rules. |
| 255 | Uno Doc McStuffins | RESKIN | Cosmetic reskin, standard UNO rules. |
| 256 | Uno Care Bears | RESKIN | Cosmetic reskin, standard UNO rules. |
| 257 | Uno Ren and Stimpy | RESKIN | Cosmetic reskin, standard UNO rules. |
| 258 | Uno Flip Transformers | MECHANIC | Uno Flip mechanic, Transformers theme. See A4. |
| 259 | Uno The Simpsons Springfield | RESKIN | Cosmetic reskin, standard UNO rules. |
| 260 | Uno Pixar (2021) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 261 | Uno Monster High (2017) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 262 | Uno Monster High (2013) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 263 | Uno Master Disney Pixar Cars | RESKIN | Cosmetic reskin ("Master" is a product-line label, not a ruleset). |
| 264 | Uno Kiki's Delivery Service | RESKIN | Cosmetic reskin, standard UNO rules. |
| 265 | Uno Haikyu!! | RESKIN | Cosmetic reskin, standard UNO rules. |
| 266 | Uno My Hero Academia | RESKIN | Cosmetic reskin, standard UNO rules. |
| 267 | Uno Doraemon (2023) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 268 | Uno Doraemon (2003) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 269 | Uno Hi Hi Puffy AmiYumi | RESKIN | Cosmetic reskin, standard UNO rules. |
| 270 | Uno Naruto Shippuden | RESKIN | Cosmetic reskin, standard UNO rules. |
| 271 | Uno One Piece (New World) (2011) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 272 | Uno One Piece (2016) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 273 | Uno One Piece (Summit War) (2011) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 274 | Uno One Piece Log Spin | MECHANIC (unconfirmed) | Probable Uno Spin-family variant themed on the Log Pose. |
| 275 | Uno Hello Kitty (2003) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 276 | Uno Hello Kitty (2006) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 277 | Uno Hello Kitty (2012) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 278 | Uno Hello Kitty (Japan) (2011) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 279 | Uno Pokémon XY | RESKIN | Cosmetic reskin, standard UNO rules. |
| 280 | Uno Pokémon Best Wishes | RESKIN | Cosmetic reskin, standard UNO rules. |
| 281 | Uno Monster Dream Company | UNKNOWN | Japan release tied to Monster Strike; specifics unverified. |
| 282 | Uno Dragon Ball Super (Japan) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 283 | Uno Speed Racer | RESKIN | Cosmetic reskin, standard UNO rules. |
| 284 | Uno Pocket All Wild Burger King | MECHANIC | Pocket-format All Wild deck. See A6. |
| 285 | Uno Flip! Express | MECHANIC | Same Flip mechanic, travel-size deck. See A4. |
| 286 | Uno Limited Too It's a Girl's World | RESKIN | Cosmetic reskin, standard UNO rules. |
| 287 | Uno Phineas and Ferb | RESKIN | Cosmetic reskin, standard UNO rules. |
| 288 | Uno Chicago White Sox World Series (2005) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 289 | Uno New York | RESKIN | Cosmetic reskin, standard UNO rules. |
| 290 | Uno Batman The Dark Knight | RESKIN | Cosmetic reskin, standard UNO rules. |
| 291 | Uno Nike Zoom Freak 3 | RESKIN | Promotional sneaker tie-in, standard UNO rules. |
| 292 | Uno Star Trek Special Edition (1999) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 293 | Uno Teenage Mutant Ninja Turtles (2013) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 294 | Uno Pittsburgh Steelers (2009) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 295 | Uno Boston Red Sox 2007 World Series Champions | RESKIN | Cosmetic reskin, standard UNO rules. |
| 296 | Uno Ambassador: Masahi Oguro | UNKNOWN | Could not verify; likely Japan celebrity promo item. |
| 297 | Uno Veefriends | RESKIN | Cosmetic reskin, standard UNO rules. |
| 298 | Uno NFL (2023) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 299 | Uno Boston Celtics (2005) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 300 | Uno Ford | RESKIN | Cosmetic reskin, standard UNO rules. |
| 301 | Uno Despicable Me 4 | RESKIN | Cosmetic reskin, standard UNO rules. |
| 302 | Uno John Deere | RESKIN | Cosmetic reskin, standard UNO rules. |
| 303 | Uno Barbie (Black) (2018) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 304 | Uno FAO Schwarz | RESKIN | Cosmetic reskin, standard UNO rules. |
| 305 | Vacation Uno | RESKIN | Travel-themed packaging, standard UNO rules. |
| 306 | Uno Happy Birthday | MECHANIC | Blank customizable wild cards. See A5. |
| 307 | Uno Macy's Thanksgiving Day Parade | RESKIN | Cosmetic reskin, standard UNO rules. |
| 308 | Uno 30 Year Anniversary | MECHANIC | "Wild Anniversary" bonus-effect card. |
| 309 | Uno Flip Attack | MECHANIC | Flip + Attack combined. See A4. |
| 310 | Uno Polly Pocket (2006) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 311 | Uno Sesame Street 35th Anniversary | RESKIN | Cosmetic reskin, standard UNO rules. |
| 312 | Uno Pittsburgh Steelers Super Bowl XL | RESKIN | Cosmetic reskin, standard UNO rules. |
| 313 | Uno Texas Edition | RESKIN | Cosmetic reskin, standard UNO rules. |
| 314 | Uno Barbie California Girl | RESKIN | Cosmetic reskin, standard UNO rules. |
| 315 | Uno My Scene | RESKIN | Cosmetic reskin, standard UNO rules. |
| 316 | Uno Barbie (2013) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 317 | Uno Super Kick (Germany) | UNKNOWN | Possible physical kicking/launcher mini-mechanic, unverified. |
| 318 | Uno Ryan's World Pocket Watch | RESKIN | Cosmetic reskin ("Pocket Watch" is the media company, not a mechanic). |
| 319 | Uno Boston Red Sox (2004) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 320 | Uno San Antonio Spurs (2006) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 321 | Uno NBA Cleveland Cavaliers Lebron James | RESKIN | Cosmetic reskin, standard UNO rules. |
| 322 | Uno Wellie Wishers | RESKIN | Cosmetic reskin, standard UNO rules. |
| 323 | Uno Shopkins | RESKIN | Cosmetic reskin, standard UNO rules. |
| 324 | Uno Hotwheels (2014) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 325 | Uno Doraemon (2016) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 326 | Uno Sock Monkey | RESKIN | Cosmetic reskin, standard UNO rules. |
| 327 | King Size Uno (With Free Turn) | MECHANIC | "Free Turn" bonus-turn card (exact wording unconfirmed). |
| 328 | Uno Moomin (2024) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 329 | Uno Lilo and Stitch (2024) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 330 | Uno Fandom Masters of the Universe | RESKIN | Cosmetic reskin, standard UNO rules. |
| 331 | Uno Fandom Star Trek | RESKIN | Cosmetic reskin, standard UNO rules. |
| 332 | Uno Fandom Harry Potter Gryffindor | RESKIN | Cosmetic reskin, standard UNO rules. |
| 333 | Uno Fandom Harry Potter Slytherin | RESKIN | Cosmetic reskin, standard UNO rules. |
| 334 | Uno Fandom Harry Potter Ravenclaw | RESKIN | Cosmetic reskin, standard UNO rules. |
| 335 | Uno Fandom Harry Potter Hufflepuff | RESKIN | Cosmetic reskin, standard UNO rules. |
| 336 | Uno Fandom Avatar The Last Airbender | RESKIN | Cosmetic reskin, standard UNO rules. |

### #337–420

| # | Title | Category | Mechanic Notes |
|---|-------|----------|-----------------|
| 337 | Uno Diary of a Wimpy Kid (2010) | RESKIN | "Cheese Touch" Wild — reveal yellows, holders draw 2. |
| 338 | Uno Diary of a Wimpy Kid (2012) | RESKIN | Same Cheese Touch mechanic as #337. |
| 339 | Uno Attack Mega Hit | MECHANIC | "Mega Hit" stacking rule on the Attack launcher. See A2/A5. |
| 340 | Uno Pocket Geox | RESKIN | Promotional pocket-tin edition, standard UNO rules. |
| 341 | Uno Disney Channel | RESKIN | Cosmetic reskin, standard UNO rules. |
| 342 | Uno Arby's Wild Jackpot | MECHANIC | Wild Jackpot's shared-pile mechanic, promo tie-in. See A2. |
| 343 | Uno Max Steel (Red Box) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 344 | Uno American Girl (2020) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 345 | Uno Pinkalicious | RESKIN | Cosmetic reskin, standard UNO rules. |
| 346 | Uno NDJOLIJEAN | MECHANIC | "Shuffle Hands"/"Make Your Own Rule" wilds + multi-discard house rule. |
| 347 | Uno World Series Champions 2004 Boston Red Sox | RESKIN | Cosmetic reskin, standard UNO rules. |
| 348 | Uno Philadelphia Eagles (2006) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 349 | Uno New York Yankees Derek Jeter | RESKIN | Cosmetic reskin, standard UNO rules. |
| 350 | Mein Erstes Uno (Germany) | MECHANIC | Uno Junior: tiered difficulty, animal icons. See A6. |
| 351 | Uno Artlist Collection The Dog Special Edition (2003) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 352 | Uno Artlist Collection The Dog Special Edition (2006) | RESKIN | Reissue of #351. |
| 353 | Uno Chicago Cubs (2006) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 354 | Uno Madness | DIFFERENT-GAME | Perfection-style spring-loaded spiral tray/timer game. See A10. |
| 355 | Uno Utterly Butterly Omega 3 | RESKIN | UK margarine-brand promo pack, standard UNO rules. |
| 356 | Uno Elvis | RESKIN | Cosmetic reskin, standard UNO rules. |
| 357 | Uno Sumikko Gurashi | RESKIN | Cosmetic reskin, standard UNO rules. |
| 358 | Uno NFL Greatest Stars Reggie Bush | RESKIN | Cosmetic reskin, standard UNO rules. |
| 359 | Uno Emoji | MECHANIC | Face-holding action card + blank house-rule wild. See A8. |
| 360 | Uno 2000 Italian Ferrari | RESKIN | Cosmetic reskin, standard UNO rules. |
| 361 | Uno Platica Polinesia | MECHANIC | "¡Mira!" wild forces draws unless holding a token card. |
| 362 | Uno Junior Move! | MECHANIC | Tiered difficulty + "Move!" physical-action cards. See A6/A8. |
| 363 | Uno Boost | UNKNOWN | Could not verify details. |
| 364 | Uno Famicom / Super Uno | DIGITAL-ONLY | Dev. Tomy, 1993, Japan-only. Up to 6 players, official +2/+4 stacking predating Mattel's own house rules, and a Board Game mode (5 boards, items, UNO-hands-as-battles). See Part E4. |
| 365 | Uno Stacko (1994) | DIFFERENT-GAME | Original Jenga-style block tower + die. See A10. |
| 366 | Uno Rush | DIGITAL-ONLY | Dev. Carbonated Games, 2009. Auto-plays a pre-sorted hand under time pressure, all hands visible, + a Shuffle card. See Part E1. |
| 367 | Uno Arby's Get Wild 4 Uno Plus Glow-In-The-Dark Stickers | RESKIN | Promo decks + "make your own wild" stickers, standard rules. |
| 368 | Uno House Rules | MECHANIC | Standalone player-authored dynamic rule-set. See A1/A5. |
| 369 | Uno Deluxe House Rules | MECHANIC | Jump-In, Seven-O, Progressive baked into the ruleset. See A1. |
| 370 | Uno Fun Pack (Germany) | UNKNOWN | Could not verify contents; likely packaging variant. |
| 371 | Uno The Batman (2006) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 372 | Uno Ito Family's Dining Table | MECHANIC | Bonus 14-card set of 12 alternate house-rule variants. |
| 373 | Uno Sudoku | DIFFERENT-GAME | UNO-branded Sudoku puzzle. See A10. |
| 374 | Uno Mobile (Mattel163) | DIGITAL-ONLY | 7 named house-rule toggles + Ranked/2v2 modes (wagering excluded, see roadmap); "Survival" mode could not be confirmed to exist. See Part E3. |
| 375 | Uno 2 Go / Uno Wonder | DIGITAL-ONLY | Same game, renamed on 2025 global launch. 9 named new action cards + 14-route/3000+-level Story Mode. See Part E3. |
| 376 | Uno & Friends (Online) | DIGITAL-ONLY | Gameloft 2013, distinct from the 2012 version (#243). Tournaments, 2v2, ~31 companions with real activatable powers, leaderboards. See Part E3. |
| 377 | Eres Un Experto Jugando A UNO Showdown? (Flash Game) | UNKNOWN | Likely a promotional trivia/skill mini-game, not full rules. |
| 378 | Uno Show 'Em No Mercy Expansion Pack | MECHANIC | More No Mercy power cards. See A2. |
| 379 | Uno Golf | DIFFERENT-GAME | Face-down grid-based scoring variant. See A9. |
| 380 | Uno Truth Adults Only | MECHANIC | Truth/Wild Truth cards + die + question list. See A8. |
| 381 | Uno Spin (2025) | MECHANIC | Refreshed Spin wheel outcomes. See A5. |
| 382 | Uno Spin Adults Only | MECHANIC | Adult Spin outcomes incl. dares. See A5/A8. |
| 383 | Uno Braille | ACCESSIBILITY | Braille + colorblind-friendly icon markings. See A11. |
| 384 | Radica: Uno 360 | DIGITAL-ONLY | NOT standard rules digitized - 4 discard piles selected by physically rotating the handheld, plus a timed UNO-call penalty. Same family as Triple Play (A5). See Part E4. |
| 385 | Uno SuperLite 2000 Vol. 16 Game | DIGITAL-ONLY | Japan-only budget PS2 reissue (Success), anime art/VO added; no rule difference found. See Part E4. |
| 386 | Uno Party Mania! | MECHANIC | Ubisoft DLC: Point Taken, Wild Drawn Together, Wild Pile Up. |
| 387 | Uno Disney Princess (2002) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 388 | Uno Harry Potter (2003) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 389 | Uno National Parks | RESKIN | Cosmetic reskin, standard UNO rules. |
| 390 | Uno Show 'Em No Mercy (Ubisoft) | DIGITAL-ONLY | Digital adaptation of the full No Mercy ruleset. See A2. |
| 391 | Uno Choo Choo | MECHANIC | Icon-matching kids' variant + Wild "Conductor." See A6. |
| 392 | Seikin Uno (Japan) | UNKNOWN | Brand-ambassador promo, not a distinct product/deck. |
| 393 | Uno NSYNC | RESKIN | Cosmetic reskin, standard UNO rules. |
| 394 | Uno University of North Carolina | RESKIN | Cosmetic reskin, standard UNO rules. |
| 395 | Uno Ultimate Thanos Promo Card | MECHANIC | Standing-penalty "Enemy" card for the Ultimate Marvel system. See A7. |
| 396 | Uno New York Knicks Special Edition (2006) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 397 | Uno Fandom Monster High | RESKIN | Cosmetic reskin, standard UNO rules. |
| 398 | Uno Magic Tree House | RESKIN | Cosmetic reskin, standard UNO rules. |
| 399 | Uno Pocket Sunset Boulevard | UNKNOWN | Likely a promotional pocket-tin tie-in, unverified. |
| 400 | Uno Master | MECHANIC | Likely shorthand for Masters of the Universe's "Power of Greyskull" card. |
| 401 | Uno Xbox 360 Live | DIGITAL-ONLY | Not a separate SKU - these are features of #113's same 2006 release (literal webcam video chat + 4 enumerated theme decks). See Part E1. |
| 402 | Uno McDonald's 2007 | RESKIN | Cosmetic reskin, standard UNO rules. |
| 403 | Uno ColorADD | ACCESSIBILITY | Colorblind ColorADD symbol markings. See A11. |
| 404 | Uno Arcade Edition (Apple Arcade) | DIGITAL-ONLY | Dev. Mattel163, June 2025. Single Player/Quick Match/Custom Games; new cards incl. Wild Swap Hands, Double Discard All. See Part E3. |
| 405 | Uno Teams! | MECHANIC | Deeper 2v2 team play with card-passing/pooled hands. See A3. |
| 406 | Uno Show 'Em No Mercy Deadpool | MECHANIC | New "Wild Reverse Draw Ten" card for the No Mercy ruleset. |
| 407 | Uno Show 'Em No Mercy Deadpool Reverse Draw 10 Promo Card | MECHANIC | Reverse + draw-10 combined effect. |
| 408 | Uno Elite NFL Core Edition (2024) | MECHANIC | "Elite Icon" drafted-player-power system. See A7. |
| 409 | Uno Elite NFL Draft Expansion Pack (2024) | MECHANIC | More Player Cards for the Elite Icon system. |
| 410 | Uno Beetlejuice Beetlejuice | RESKIN | Cosmetic reskin, standard UNO rules. |
| 411 | Uno Crayon Shinchan (Japan) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 412 | Uno One Piece (2024) (Japan) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 413 | Uno Chiikawa (Japan) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 414 | Uno Fandom Batman The Animated Series | RESKIN | Cosmetic reskin, standard UNO rules. |
| 415 | Uno Fandom Batman Batmobiles & Gadgets | RESKIN | Cosmetic reskin, standard UNO rules. |
| 416 | Uno Fandom Batman Classic TV Series | RESKIN | Cosmetic reskin, standard UNO rules. |
| 417 | Uno Moana 2 | RESKIN | Cosmetic reskin, standard UNO rules. |
| 418 | Mini Uno Bullseye | MECHANIC | Choose-the-target ("Bullseye") rule. See A3. |
| 419 | Uno Add-On Packs! Speed Pack | MECHANIC | Escalating discard-speed-level mechanic. See Part C roadmap. |
| 420 | Uno Add-On Packs! Swap Pack | MECHANIC | Hand-swap card cluster. See A3. |

### #421–484

| # | Title | Category | Mechanic Notes |
|---|-------|----------|-----------------|
| 421 | Uno Add-On Packs! Reverse Pack | MECHANIC | Reverse-combo cards + penalty-reflect wild. See A2. |
| 422 | Uno Add-On Packs! Stack Pack | MECHANIC | Officialized stacking + random-N stack. See A2. |
| 423 | Uno Pixar (2025) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 424 | Uno Barbie (2025) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 425 | Uno Fandom She-Ra Princess of Power | RESKIN | Cosmetic reskin, standard UNO rules. |
| 426 | Uno Fandom Monster High Fearbook | RESKIN | Cosmetic reskin, standard UNO rules. |
| 427 | Uno The Quintessential Quintuplets (Japan) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 428 | Uno Expo 2025 (Japan) | MECHANIC | "WORLD" wild: restrict play to one color until broken by a Wild/Wild+4. |
| 429 | Uno Blue Lock (Japan) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 430 | Uno Fandom Star Wars Troopers | RESKIN | Cosmetic reskin, standard UNO rules. |
| 431 | Uno Fandom Star Wars Posters | RESKIN | Cosmetic reskin, standard UNO rules. |
| 432 | Uno Fandom Star Wars Droids | RESKIN | Cosmetic reskin, standard UNO rules. |
| 433 | Uno Demon Slayer (Japan) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 434 | Uno Superman (2025) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 435 | Uno Simpsons (2009) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 436 | Uno Card Premium Pack With A UNIQUE Uno Card Box | RESKIN | Collector packaging item, standard UNO rules. |
| 437 | Uno Jurassic World Rebirth | RESKIN | Cosmetic reskin, standard UNO rules. |
| 438 | Uno Chainsaw Man Reze Arc (Japan) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 439 | Uno Jujutsu Kaisen (Japan) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 440 | Uno Fandom NFL Jacksonville Jaguars | MECHANIC | Fandom NFL mechanic, team art only. See A7. |
| 441 | Uno Fandom NFL Cincinnati Bengals | MECHANIC | Fandom NFL mechanic, team art only. |
| 442 | Uno Fandom NFL New Orleans Saints | MECHANIC | Fandom NFL mechanic, team art only. |
| 443 | Uno Fandom NFL Buffalo Bills | MECHANIC | Fandom NFL mechanic, team art only. |
| 444 | Uno Fandom NFL Las Vegas Raiders | MECHANIC | Fandom NFL mechanic, team art only. |
| 445 | Uno Fandom NFL Minnesota Vikings | MECHANIC | Fandom NFL mechanic, team art only. |
| 446 | Uno Fandom NFL Los Angeles Chargers | MECHANIC | Fandom NFL mechanic, team art only. |
| 447 | Uno Fandom NFL Los Angeles Rams | MECHANIC | Fandom NFL mechanic, team art only. |
| 448 | Uno Fandom NFL Green Bay Packers | MECHANIC | Fandom NFL mechanic, team art only. |
| 449 | Uno Fandom NFL New York Giants | MECHANIC | Fandom NFL mechanic, team art only. |
| 450 | Uno Fandom NFL Seattle Seahawks | MECHANIC | Fandom NFL mechanic, team art only. |
| 451 | Uno Fandom NFL Tampa Bay Buccaneers | MECHANIC | Fandom NFL mechanic, team art only. |
| 452 | Uno Fandom NFL Houston Texans | MECHANIC | Fandom NFL mechanic, team art only. |
| 453 | Uno Fandom NFL Detroit Lions | MECHANIC | Fandom NFL mechanic, team art only. |
| 454 | Uno Fandom NFL Baltimore Ravens | MECHANIC | Fandom NFL mechanic, team art only. |
| 455 | Uno Fandom NFL Tennessee Titans | MECHANIC | Fandom NFL mechanic, team art only. |
| 456 | Uno Fandom NFL Atlanta Falcons | MECHANIC | Fandom NFL mechanic, team art only. |
| 457 | Uno Fandom NFL Cleveland Browns | MECHANIC | Fandom NFL mechanic, team art only. |
| 458 | Uno Fandom NFL Denver Broncos | MECHANIC | Fandom NFL mechanic, team art only. |
| 459 | Uno Fandom NFL Carolina Panthers | MECHANIC | Fandom NFL mechanic, team art only. |
| 460 | Uno Fandom NFL Chicago Bears | MECHANIC | Fandom NFL mechanic, team art only. |
| 461 | Uno Fandom NFL New York Jets | MECHANIC | Fandom NFL mechanic, team art only. |
| 462 | Uno Fandom NFL Arizona Cardinals | MECHANIC | Fandom NFL mechanic, team art only. |
| 463 | Uno Fandom NFL Indianapolis Colts | MECHANIC | Fandom NFL mechanic, team art only. |
| 464 | Uno Fandom NFL Miami Dolphins | MECHANIC | Fandom NFL mechanic, team art only. |
| 465 | Uno Fandom NFL Washington Commanders | MECHANIC | Fandom NFL mechanic, team art only. |
| 466 | Uno Fandom NFL Super Bowl LIX Eagles (2025) | MECHANIC | Fandom NFL mechanic with a Super-Bowl-specific bonus card. |
| 467 | Uno Elite NFL Core Edition Starter Pack (Viper Cards) (2025) | MECHANIC | Elite Icon system; Viper foil counts as all 4 colors. See A7. |
| 468 | Uno Elite NFL Core Edition Starter Pack (Kaleidoscope Cards) (2025) | MECHANIC | Elite Icon system; Kaleidoscope rarity tier, rule-uniqueness unconfirmed. |
| 469 | Uno Elite NFL Core Edition Booster Set (Viper Cards) (2025) | MECHANIC | Elite Icon system, booster format. |
| 470 | Uno Elite NFL Core Edition Booster Set (Kaleidoscope Cards) (2025) | MECHANIC | Elite Icon system, booster format. |
| 471 | Uno Elite NFL Core Edition Booster Set Plus (Viper Cards) (2025) | MECHANIC | Elite Icon system, larger booster format. |
| 472 | Uno Elite NFL Core Edition Booster Bundle (Kaleidoscope Cards) (2025) | MECHANIC | Elite Icon system, bundle format. |
| 473 | Uno Elite NFL Alt Jerseys Edition Starter Pack (Hypnotic Cards) (2025) | MECHANIC | Elite Icon system; Hypnotic rarity tier, rule-uniqueness unconfirmed. |
| 474 | Uno Elite NFL Alt Jerseys Edition Booster Set Plus (Hypnotic Cards) (2025) | MECHANIC | Elite Icon system, booster format. |
| 475 | Liar's Uno Trust No One | DIFFERENT-GAME | Face-down bluff/challenge subsystem. See A8. |
| 476 | Uno Hotwheels (Italy) (2021) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 477 | Uno Attack On Titan (Japan) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 478 | Uno Add-On Packs! Billie Eilish | MECHANIC | Original rule cards + colorblind-friendly symbol markings. See A8/A11. |
| 479 | Uno Wednesday | RESKIN | Cosmetic reskin, standard UNO rules. |
| 480 | Uno Fandom Gremlins | RESKIN | Cosmetic reskin, standard UNO rules. |
| 481 | Uno Fandom Chucky | RESKIN | Cosmetic reskin, standard UNO rules. |
| 482 | Uno Wicked | RESKIN | Cosmetic reskin, standard UNO rules. |
| 483 | Uno The Simpsons (2025) | RESKIN | Cosmetic reskin, standard UNO rules. |
| 484 | Uno America's Newest Card Game Craze! (1973) | RESKIN | Historical baseline print; predates Wild Draw Four (introduced 1992). |

### #485–503 (never released)

See Part B above for the full table.

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

**#235 — UNO Undercover — the title specifically flagged for this research pass.** PC only (Windows,
via RealArcade), released July 2008. Dev. **Golden Goose Productions**, distributed by
RealNetworks/RealArcade under Mattel's license; also ported to BREW/J2ME/Windows Mobile. **Correction:
there is no DS version of "Uno Undercover" specifically** — a separate, plain "UNO" (standard rules, no
spy theme) was released for DS by Gameloft in Dec 2009, a different product this doc's earlier "(PC/DS,
~2008, likely Gameloft)" tag appears to have conflated with Undercover.

Standard 108-card deck plus **9 added "power-up cards"** shuffled into play in both modes. MED-HIGH,
converging across MobyGames/RealArcadeapedia/Giant Bomb, paraphrased not verbatim:
* **Redecorate** — changes the color of the discard pile *and* every card in the deck to the same
  color/tone (a mass color-unification wild).
* **Clone** — mimics/assumes the effect of any other card in the deck (a copy-a-card wild).
* **Lucky Croc Tooth** — protects the holder from a draw-card penalty for a number of turns equal to the
  value of a paired numbered card.
* **Toe Hold** — forces a target opponent to hold 3 random cards for several turns, duration tied to a
  paired card's number.
* **Highland Two-Step** — makes two chosen opponents swap hands with each other.
* **Double Cross** — a wild that changes the pile's color *and* two other cards in the deck.
* **Sleep** — discarded together with a numbered card; makes one selected opponent skip turns, count set
  by the numbered card's value.
* **Tsunami** — discarded together with a numbered card; forces a selected opponent to draw cards, count
  set by the numbered card's value.
* **Switcheroo** — makes two opponents swap *seats* (turn order), not hands.

Sleep and Tsunami are genuinely new to this project: **two-card combo plays** (a special card + a
numbered card whose value parameterizes the effect) — no "play two cards as one action" primitive exists
in this codebase yet, so these would need real new plumbing, not just a new content/status value.

**On "command cards" specifically (the term that prompted this whole research pass):** every source
found for the *shipped* game calls these "power-up cards"/"power cards," **never** "command cards." This
strongly suggests this project's existing Part B note (#497, "Cut command cards from Uno Undercover")
refers to an earlier prototype/internal name for a mechanic that shipped under a different name (most
likely these same 9 cards, renamed before release) — or a genuinely different, never-shown cut set that
can't be distinguished from that possibility with available sources. **No source** (fan wiki, a Cutting
Room Floor-style preservation site, developer interview, marketing archive) documents specific cut
"command cards" by name or effect — this remains "specifics undocumented," now with much more confidence
that it can't be resolved further without whatever original source generated this project's ~500-item
list in the first place. **Do not treat the shipped power-up cards as confirmed to *be* the cut command
cards** — that's an inference, not a sourced fact.

Mission/story structure: a spy narrative wrapper (protagonist "Felicia Blue" infiltrating locations to
track "Madame Zero") over the *same* standard-rules-plus-power-cards deck throughout — different
venues/opponents appear to just mean different AI personalities/difficulty, not different card-legality
rules per mission; no source describes a mission-specific rule change. A separate **Quick-Play mode**
offers the same ruleset without the story wrapper. MED-HIGH — effectively reskinned standard UNO plus a
fixed 9-card bonus set, not per-mission rule variants.

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

*Compiled from a multi-pass automated survey (see Methodology). Titles marked UNKNOWN in Part D should
be re-checked before relying on their RESKIN-by-default assumption for anything load-bearing. Part E's
confidence tags (HIGH/MED/LOW) work the same way — re-verify anything below HIGH before it drives an
actual implementation decision, ideally with direct page fetches rather than search-snippet synthesis.*
