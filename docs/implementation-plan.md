# Implementation plan: mechanics from the UNO survey

This is the build plan that follows the research in `docs/gameversions.md` and the specs in
`docs/mechanics/01`-`12`. It answers two questions:

1. **In what order should the ~500 surveyed versions' mechanics be built?** (Parts 2-3)
2. **Where do mechanics from different versions collide, and how does the engine settle each
   collision once?** (Parts 4-6)

It is grounded in the engine as it stands today (Part 1), because most of the ordering is forced by
what the current code can't express yet. Part 7 records the ten design decisions settled before work
started; the phases below already reflect them.

Conventions: "spec 01" means `docs/mechanics/01-stacking-penalties-house-rules.md` and so on. "#N" is a
Part D row in `docs/gameversions.md`. Effort is S (a day or two), M (about a week), L (several weeks).

---

## Part 1: What the engine can and can't express today

Everything below was read from the current source, not inferred.

| Area | Today | What blocks new mechanics |
|---|---|---|
| **Card identity** (`src/card.lua`, `src/defs.lua`) | A card is `(color, content)` with `content` an enum 0-18. Ids come from three hand-written formulas: colored `13*(color-1)+content` (0-51), wild-type `39+content` (52-55), Swap 1 / Refresh Hand `56+(content-17)*4+(color-1)` (56-63). `Uno.new()` builds a 64-entry `self.table`. | Every new card type needs a new formula, a new enum slot, and edits in legality, replay bounds, scoring, AI and tests. Card faces can't carry attributes (value, tags, a second side). |
| **Card effects** (`src/game.lua` `doPlay()`) | An `if/elseif` chain on `card.content`, interleaved with UI state (`setStatus(STAT_*)`), coroutines (`runFlow`, `threadWait`, `animate`) and file-scope flags (`sSwapOneCard`, `sBullseyeContent`). | Effects can't be queued, cancelled, reflected or redirected, because each one runs to completion inline. Nothing can respond to an effect before it lands. |
| **Rules state** (`src/uno.lua`) | One flag or small enum per rule (`forcePlayRule` 0-2, `stackRule` 0-2, `sevenZeroRule`, `drawToMatchRule`, `wildDraw4NoChallengeRule`, `bullseyeRule`, `swapPackRule`), each with its own getter, setter, settings descriptor and save/load line. | Adding a rule touches four places. There's no way to say "this rule is inert with that deck" or "this mode forces that rule on". |
| **What to match** | `recent[3] = {card, color}`; `lastColor()` is the color in force; `calcLegality()` builds a table keyed by card id from color and content. | Color in force and "card on top" are fused. Flex (played-as color isn't the color to match), Triple Play (Wilds set no color), Flip (the face depends on the side) and tag matching (Junior's animals) can't be expressed. |
| **Stacking** | `draw2StackCount` plus `stackRule` 0/1/2, with legality special-cased in `play()`. Under rule 2 a WD4 loses its color change and can't be challenged. | Six official stacking models (spec 01 note 1) don't fit a 3-value switch. |
| **Drawing** | `draw(who, force)` from one shared deck, reshuffling `used` when empty; hands capped at `MAX_HOLD_CARDS = 26`, extra draws silently dropped. | No per-player draw source (Ultimate), no on-draw trigger (Creeper, Crash-Up), no draw-until primitive other than Draw to Match, and the cap changes outcomes under No Mercy-sized penalties. |
| **Turn order** | Fixed four seats (YOU, COM1-3), with 2/3/4 players handled by special cases in `getNext()`, `getOppo()` and `getPrev()`. `setNow()` jumps the pointer. | No eliminated seats (No Mercy, Ultimate, Challenge UNO, the deferred "shrinking table"), and no more than four players. |
| **Out-of-turn play** | None. The status loop only ever asks the current player. | Jump-In, every response card, and Avatar State all need an interrupt. |
| **Pickers** | `STAT_WILD_COLOR`, `STAT_DOUBT_WILD4`, `STAT_SEVEN_TARGET`, `STAT_BULLSEYE_TARGET`, `STAT_ASK_KEEP_PLAY`, each a separate UI state with its own AI hook (`calcBestColor4NowPlayer`, `calcBestSwapTarget4NowPlayer`, `calcBestBullseyeTarget4NowPlayer`, `needToChallenge`). | Every new choice is a new status, a new renderer branch, a new click handler and a new AI function. |
| **UNO call** | Not modelled at all. | Hail Mary, Dawg Pound, Flip Attack's missed-UNO penalty and Teams' "partner may call UNO for you" all key off it. |
| **Scoring** | `Player:getHandScore()` hard-codes 50/20/face; one-hand games only, with a running `sScore` for the human. | Every deck has its own table (Flip 20/30/40/60, No Mercy 20/50 plus 250 per knockout, All Wild 20/50, 30th Anniversary card 100). No match-to-500 or first-to-3-hands. |
| **Replay** (`save`/`loadReplay`/`forwardReplay`) | Text opcodes `ST DR PL DF CH SW CY S1 RF`; ids bounded to 0-63 in `loadReplay()`; effects re-derived on playback; randomness that can't be re-derived gets its own opcode. | Every random effect (wheels, launchers, coin flips, random targets) needs a logged outcome, and every new id range needs the loader edited. |
| **AI** (`src/ai.lua`, 883 lines) | `easyAI`, `hardAI`, `teamAI`, `sevenZeroAI` choose by per-content heuristics. | A card the AI has no heuristic for is mis-valued; there's no per-effect evaluation hook. |
| **Tests** (`tests/*.lua`) | `selfplay` checks card conservation (108, +8 with the Swap Pack), hand limits, legality against an independent `specLegal`, termination and replay reproduction; `humanplay`, `persist`, `realtime`, `uishots` cover UI and saving. | Conservation and `specLegal` are hard-coded to today's decks; the rule matrix is hand-listed. |
| **Settings UI** (`rulePages()`) | Data-driven descriptors (`arrows`, `select`, `toggle`) on two pages; `saveSettings()` writes `key=value` lines. | Descriptors can't be disabled, locked or hidden, so incompatible combinations can't be greyed out. |

**Conclusion:** almost nothing past the cheapest themed cards can be added cleanly without first
replacing the card-id scheme, pulling effects out of `doPlay()` into a queue, and generalizing the
pickers. That's why Phase 0 below is a refactor with no visible changes.

---

## Part 2: Principles that drive the order

1. **Build the primitive, then the cards.** About 150 themed bonus cards reduce to roughly fifteen
   primitives (A14). Each primitive ships with the official cards that need nothing else.
2. **Each phase unlocks a "content wave".** A phase is done when the system works *and* at least one
   real, sheet-verified product built on it is playable end to end, with AI and tests.
3. **Official rules are the default; house rules are options.** Where a sheet rules (Jump-In cancels,
   No Mercy 7-0 is built in, All Wild can't be challenged), that's the default. Popular house variants
   (Jump-In adds to a stack) become sub-options.
4. **Free toggles with guardrails (D3).** Every deck mode (Classic, Flip, No Mercy, All Wild, ...)
   and every house rule is a toggle the player can reach. A deck mode fixes the card list and the rules
   the product prints. When a toggle the player turns on conflicts with one already on, the old one
   switches off automatically and a short notice says so ("Flip turned off Swap Pack"). Toggles that
   only partly apply stay usable and say so ("7 only: this deck has no 0s"); rules a mode builds in
   show as on and locked. The compatibility table (Part 5) is the data behind all three behaviors.
5. **Popularity breaks ties.** Flip is the most reused mechanic in the survey, No Mercy the most
   requested modern one, Jump-In the most common house rule. Among things with equal prerequisites,
   those go first.
6. **Every random outcome is logged.** Replays must stay byte-reproducible, so wheels, launchers,
   coins and random targets record what happened instead of re-rolling.
7. **Never regress what exists.** Every phase keeps the current tests green, and old replays and
   settings files keep loading.

---

## Part 3: Implementation order

```
Phase 0  Foundations (registry, effect queue, rules config, pickers)    ── required by everything
Phase 1  Fidelity fixes + match scoring                                  ── needs 0
Phase 2  Effect primitives + themed bonus cards                          ── needs 0
Phase 3  Stacking policies + parameterized challenges                    ── needs 0
Phase 4  Deck presets (Iconic, All Wild, Express/Pocket, Junior, ...)     ── needs 0, 1 (scoring), 3
Phase 5  UNO Flip and its editions                                       ── needs 0, 3, 4
Phase 6  Elimination + Show 'Em No Mercy                                 ── needs 2, 3
Phase 7  Interrupts: Jump-In, response windows, UNO call                 ── needs 0, 3
Phase 8  Standing effects, on-draw triggers, player links                ── needs 2, 7
Phase 9  Randomizer devices (Attack, Spin, Tiki, Roboto, Blast, ...)     ── needs 2, 3, 6
Phase 10 Roles and owned objects (Power Grab, Colors Rule, Royal, Flex)  ── needs 7, 8
Phase 11 Teams                                                           ── needs 6, 7
Phase 12 Multi-play and multi-pile (Speed Pack, Triple Play, Tippo)      ── needs 7
Phase 13 Hidden information (Liar's UNO, duels, memory quizzes)          ── needs 7
Phase 14 Power frameworks (Ultimate, Elite NFL, Fandom NFL)              ── needs 6, 7, 8, 10
Phase 15 Prompt-and-fallback cards (honor system, reaction races)        ── needs 2
Phase 16 Ubisoft theme systems (Call of Yara economy, Valhalla board)    ── needs 2, 7, 13
Phase 17 Tournament ladder (escalating rules and player counts)          ── needs 1, 3, 6, 7
```

Phases 2, 3 and 4 can run in parallel once Phase 0 lands. Phases 5 and 6 are independent of each
other. Everything from Phase 7 on is ordered by dependency first, popularity second.

### Phase 0: Foundations (L, no visible change)

The goal is that the game plays exactly as it does today, but on structures that every later phase
needs. Do it in this order, keeping the tests green after each step.

**0a. Card registry.** Replace the three id formulas and the `content` enum with a table of card
definitions:

```lua
-- one entry per face; a deck is a list of {def, copies}
CardDef = {
    key = "red_draw2",          -- stable string id, used in replays v2 and saves
    face = "draw2",             -- what Jump-In / "identical card" compares
    color = RED,                -- printed color, or NONE for wilds
    number = nil,               -- 0-9 for number cards, nil otherwise
    kind = "action",            -- number | action | wild
    drawValue = 2,              -- for stacking policies (Phase 3)
    score = 20,                 -- per-deck scoring overrides it
    tags = {},                  -- icon subsets for predicates (Phase 2)
    effect = "draw2",           -- key into the effect table (0b)
    image = "front_r+", dark = "dark_r+",
    back = nil,                 -- the other side's CardDef for Flip (Phase 5)
}
```

Numeric ids are assigned when a deck is built, so the legality table and the card table keep working
unchanged. `Card.new()` takes a def instead of `(color, content)`. `Player:getHandScore()` and the
game-over scoring read `def.score` (through the deck's scoring table). `contentAnalysis` becomes
`faceAnalysis` keyed by `face`.

**0b. Effect resolution queue.** Move every branch of `doPlay()`'s chain into a named handler
`effects[key](ctx)` that only *pushes steps* (draw N to seat X, skip, reverse, ask a color, swap, ...)
onto a FIFO queue. One resolver pops steps, runs their animations and pickers, and moves the turn
pointer only once the queue is empty. Bullseye, 7-0 and the Swap Pack become ordinary handlers. This
is the change that makes cancel, reflect, redirect, triggered effects and multi-card plays possible
later.

**0c. Rules config.** Replace the per-rule fields with one `rules` table plus descriptors:

```lua
{ key = "jumpIn", kind = "toggle", default = false,
  group = "deck",                            -- deck modes form one exclusive group
  conflicts = { "speedPack" },               -- turning this on switches these off
  partialWhen = function(rules) ... end,     -- still usable; returns a note ("7 only")
  lockedBy  = function(rules) ... end }      -- shown on and locked by a mode
```

Turning a toggle on runs one resolver: it switches off everything in `conflicts` (both directions,
so the table only needs one side) and anything else in the same exclusive `group`, then returns the
list of what changed for the on-screen notice. The resolver is pure data plus one function, so the
tests can call it directly. `rulePages()`, `saveSettings()`/`loadSettings()` and the `persist` test
are generated from the descriptors. Old keys (`sevenZero=`, `stack=`, ...) keep loading, and a saved
file that somehow holds two conflicting toggles is repaired on load by the same resolver.

**0d. Match state.** Split `recent[3]` into the card on top and a separate `match` record
`{color, face, number, tags}`. `calcLegality()` becomes "is this def legal against `match` under the
active policies", still cached as a table keyed by id. Today's behavior falls out when `match.color`
is the played or called color and `match.face` is the top card's face.

**0e. Generic pickers.** One picker state per *kind* of choice, each with a filter and an AI callback:
`pickSeat(filter)`, `pickColor(allowed)`, `pickCards(fromSeat, min, max, filter, visible)`,
`pickYesNo`, `pickNumber`, `pickFromList`. The existing `STAT_*` pickers become thin wrappers. Every
later phase uses these instead of adding statuses.

**0f. Replay v2 and test generalization.** Replays get a header with a format version and a deck
manifest (def keys and copy counts); `PL`/`DR` carry def keys or numeric ids within the manifest, so
the 0-63 bound goes away. v1 replays load through a fixed v1 manifest. Add a generic `RN,<tag>,<value>`
opcode for logged random outcomes. In the tests, card conservation reads the deck manifest; the
self-play rule matrix is generated from the rules descriptors, skipping combinations Part 5 forbids;
`specLegal` stays an independent implementation (re-derived from the defs, not from the engine's
legality code) so it still catches engine bugs.

**0g. Seat list (D6).** All new Phase 0 code (effect targets, `pickSeat`, replay v2, rule
descriptors) takes seats from a list instead of assuming 0-3, and `getNext()`, `getPrev()` and
`getOppo()` move onto an ordered active-seat list now rather than in Phase 6. Replay v2's header
records the seat count. `getOppo()` is redefined as "partner seat" and used only by Teams/2vs2, since
"opposite" means nothing with odd or larger seat counts. The table layout, hand fans, animations and
AI stay four-seat; lifting that is its own phase after Teams.

*Exit criteria:* all current tests pass; old replays and settings load; a 10,000-game self-play run
shows identical win distributions to before the refactor on the same seeds.

### Phase 1: Fidelity fixes and match scoring (S-M)

* **Swap Pack to official** (sheet JCV59, Part F1): Wild Force Trade swaps *any two* seats (one
  `pickSeat` twice); Swap 1 lets the player *choose* which card to give back; Refresh Hand puts the
  old hand under the *discard* pile. Today's cards stay available under their real identities: the
  current Wild Swap Hands is the classic/Comeback card of that name, and the current Refresh Hand is
  Captain Marvel's Cosmic Crush, so both move into the Phase 2 card catalog rather than being lost.
* **Hand cap setting (D5).** `MAX_HOLD_CARDS` becomes a setting with a "no cap" choice; draws that
  hit the cap stay in the draw pile instead of vanishing (C12). The on-screen hand fan compresses so
  hands above 26 cards still fit. The "reaching the cap knocks you out" toggle comes in Phase 6, once
  seats can be knocked out. A companion toggle from UNO & Friends (spec 12): with 20 or more cards
  (adjustable) and a playable card, you can't draw.
* **Draw rules, named consistently.** The digital games use the same words for different things, so
  the settings say what they do. Gameloft's three draw types map onto settings we already have: Draw
  One is today's "keep", Draw and Play is "ask", and Draw Until Play is Draw to Match. Ubisoft's "Force
  Play" (a playable drawn card is played automatically) is today's "play". Gameloft's "Force Play" is
  a different rule, added as its own toggle: if your only playable cards are Wilds, you must play one
  rather than draw. Drawing while you hold a playable card stays allowed, as in the official rules and
  UNO & Friends.
* **UNO call, simple version (D7), on by default.** An UNO button for you that's live while you're
  about to play down to one card and until the next player acts; CPUs call with a per-difficulty
  forget chance and try to catch a missed call with a per-difficulty catch chance; a caught player
  draws 2. Calls, misses and catches are logged in the replay (`UN` opcode) so seeded games still
  reproduce. Phase 7 extends it for the cards that react to a call. Calibration from the shipped
  digital games (spec 10): CPUs call UNO 0% of the time in Uno^3, 40% in Uno (2020) and 50% in
  Undercover; the window to catch a missed call is 0.5-1.5 s; the penalty is 2 cards everywhere
  except Uno (2020), which draws 1.
* **Match play.** Per-deck scoring tables; "first to N points" (500 default; 250 for Express-sized
  decks; 1000 for No Mercy; 300 for UNO Undercover's Standard mode) and "first to 3 hands" (H2O).
  The score-limit menu offers Ubisoft's list: one round, 200, 300, 500, 750 or 1,000 (spec 11).
  Variants that knock players out (Challenge UNO, elimination by score) come with Phase 6. Include the
  official rule that a Draw Two or WD4 played as the last card still makes the next player draw
  before hands are scored (Uno^3 does this too, spec 10).
* **Score attack** (Uno^3, spec 10), a match-play option for a personal best: a match clock (160 s
  in Uno^3, or 6 rounds, whichever ends first), the round winner scores the value of every hand, you
  get 1 point per penalty card you make a CPU draw, and a time bonus of `round(200 × time left / total
  time)` at the end. Only your score counts.
* **Rule presets and Shuffle** (Ubisoft's "Today's Rules" and "Shuffle", spec 11). Named bundles of
  toggles ("Classic", "Chaotic", "Official", ...) picked in one click, and a "shuffle my rules every
  round" option that turns on a random subset of the toggles you've allowed. Both run through Phase
  0c's conflict resolver (D3), so a random set never contains a conflicting pair. Ubisoft's 14
  presets are server data, so ours are our own.
* **Who goes first.** A setting: the last winner (today's behavior), random, you always (Undercover),
  or the official draw-for-first-player, where everyone draws a card and the highest number starts,
  re-drawing ties (Uno^3, spec 10). The start card's action keeps applying as it does today
  (`STAT_NEW_GAME` already resolves an opening Draw Two, Skip or Reverse); deck presets that ignore
  starting actions (All Wild, Flex, Teams) switch that off in Phase 4.
* **Turn timer**, optional and off by default: N seconds for your turn (8 s in Uno 2020; 6 or 4 s
  in Uno Flash, #23), with a countdown that shakes near the end. On timeout the game draws for you:
  1 card (Uno 2020) or 2 (Uno Flash), as a setting. CPUs aren't timed. Timeouts are logged in the
  replay. Phase 7's reaction prompt (D10) reuses the same countdown.
* **Two-player rule table.** Formalize the existing Reverse-as-Skip into a per-effect 2-player
  override (Part 6, C13), so later phases fill in a row instead of adding special cases.
* **Easy-difficulty handicap (from UNO Undercover's "easing", spec 09).** Two behavior knobs per
  difficulty: the chance a CPU holds back its last card, and the chance it avoids hitting the human
  with Skip, Draw Two or WD4. They sit beside D7's forget and catch chances. Undercover's deck-side
  handicap (extra Wilds, Wilds withheld from the AI) is left out: it's hidden from the player.

*Content wave:* official Swap Pack; classic match play to 500; score attack; calling UNO; the
official draw for first player; an optional turn timer.

### Phase 2: Effect primitives and themed bonus cards (M)

Build the A14 primitives on the queue and pickers, each with an AI evaluator:

| Primitive | Built on | First official cards it unlocks |
|---|---|---|
| Target selector (next, chosen, all others, fewest/most cards, holders of X) | `pickSeat` + predicates | Power of Greyskull, Graduation, Badtz-Maru, Best of Both Worlds |
| Draw N / draw-until predicate (with cap) | queue step | Sorting Hat, Joker's wild, Bat Signal, Mutated Minion, King Pig |
| Reveal-or-draw | reveal animation + log line | Infinity Gauntlet, Kryptonite, Lotso (with backfire), Jellyfishing |
| Filtered discard (self / target / everyone, up-to-N) | `pickCards` | Olaf's Summertime, Super Charged, Robin's Rule, Best Friends |
| Give cards away | `pickCards` + `pickSeat` | Screen Slayer, Web Slinger, Power Ring, 30th Anniversary (100 pts) |
| Swap / rotate / pool-and-redeal / one-card pass | `swap(a, b, dir)` | Disney Parks Magic, Circle of Life, Duke Caboom, Batman Bomb |
| Hand-size equalizer | draw/discard steps | Power of Togetherness |
| Take a specific card (visible or blind) | `pickCards(visible)` | Mix Tape, Called Shot, Frankie's Hand |
| Pile search / take | deck/discard views | Accele-race, Ken You Dig It? |
| Multi-skip / skip-by-predicate | pointer steps | Web Swing, Skip Everyone |
| Card tags + tag overlay art | `def.tags`, `tools/gen_cards.py` | Voldemort/Harry 2-6-9, Triforce 3-6-9, Bat-family 1-4 |
| Coin / drop randomizer | `RN` opcode | 50/50 coin (#6), Welcome to the Jam (#191) |
| Paired sizing card (spec 09) | `pickCards(self, 1, 1)`; the card is tucked under the discard pile | Sets N for the card it pairs with: a number card's value, 1 for any other card, 0 means no effect. Used by Sleep, Toe Hold, Lucky Croc Tooth, Tsunami and Personal Shield |
| Chained actions | queue steps | Reverse Skip, Reverse Draw-Two, Skip Draw-Two |
| Card mutation and creation (C18) | def swap on a hand card, logged | Redecorate (recolor your hand), Double Cross (recolor 1-2 cards), Clone (duplicate a card) |
| Take from others' hands to a target | `pickSeat` + random picks, logged | Tsunami (N random cards from the other players to the target; skips special cards and 1-card hands) |
| Seat swap (C19) | reorders the Phase 0g seat list | Switcheroo; Highland Two-Step is the existing `swap(a, b)` between two opponents |

Then add a **Bonus Wild** setting: pick one themed card (or "random each game") and shuffle 4 copies
into the classic deck, matching the official 108+4 = 112 layout of most licensed decks (spec 07, 08).
Next to it, a **bonus card pool** setting in UNO Undercover's style: choose a set of special cards
(Undercover deals up to 7 at random from your collection, one copy each; its cut design was a
3-card loadout), with a "human-only" sub-option (C20).
Also add the cheap Add-On Packs whose cards are pure primitives (Reverse Pack minus Wild NO U,
Comeback, Billie Eilish), each as its own toggle.

**Table modifiers** (Ubisoft's Wild Weeks and Twitch disruptions, spec 11): single settings built on
the primitives above. Tiny Hands and Big Hands (deal 3 or 12; the deal-size range widens from 5-20 to
3-20); Attack! (every draw from the pile adds a random 1-12 extra cards, logged; pairs badly with "no
hand cap", so the description warns); Whirlpool (each turn a random card from your hand passes to the
next player); Shuffle Hands (pool and redeal every N turns, since this game is turn-based rather than
Ubisoft's every 60 s); Glitched (cards randomly transform, C18); and color bans ("Ban red cards",
"Red cards only" as a legality filter; Draw to Match stops at its cap if nothing playable can turn up).
The visibility modifiers (Fog of War, Flipped!) wait for Phase 13.

*Content wave:* the ~60 sheet-verified bonus cards from spec 07 and the Fandom line that need nothing
from later phases, plus the UNO Undercover Command Cards that need nothing later: the three combo
cards, Redecorate, Double Cross, Clone, Highland Two-Step, Switcheroo, Tsunami and the cut Plunder.
Sleep, Toe Hold and Lucky Croc Tooth wait for Phase 8 (timed statuses; the Tooth also needs Phase 7's
reflect), and Shooting Star for Phase 12. From Ubisoft's DLC (spec 11): Comin' Through, Get Down,
Cross-Fade, Dragon, A Little Help (C18), Just Dance Machine (a random action, logged), Typhon's Trick,
Fenyx's Power and Point Taken. Cards that need responses, standing effects or duels wait for their
phase; spec 07 already groups them by primitive, so the backlog is mechanical.

### Phase 3: Stacking policies and parameterized challenges (M)

* **Stack policy enum** replacing `stackRule`: `none`, `sameType` (Progressive: +2 on +2, WD4 on WD4,
  one per turn), `classicMixed` (today's rule 2, kept for compatibility), `equalOrHigher` (No Mercy),
  `colorGated` (Stack Pack), `anyHit` (Attack Mega Hit, play resumes after the first hitter). Each card
  def may carry its own stack rule, which beats the global one (C1). UNO Undercover's cut penalty modes
  (spec 09) add two optional policies that cover *every* effect card, not just draw cards: `passSame`
  ("Pass Penalties": a card of the same type passes the pending effect on to the next player without
  adding to it, so a Skip on a Skip passes the skip) and `amplifySame` ("Amplified Penalties": a card of
  the same type passes both effects on, so the penalties add up). Ubisoft's own Stacking toggle is
  `sameType` ("play the same type of card to add to the penalty", spec 11). Gameloft's mobile games
  add `doubleSame` ("Cumulate", spec 12): a matching Draw Two or WD4 passes on **double** the pending
  penalty (2, 4, 8, ... or 4, 8, 16, ...) instead of adding to it.
* **Challenge object** `{canChallenge, legalityCheck, onGuilty, onInnocent, wildsCountAsMatch}` used
  by WD4 (4/6), Flip's Wild Draw Two (2/4) and Wild Draw Color (until color / plus 2), Express's Wild
  Draw Two (4/4), Progressive's scaled penalty, and Flex's regular-side WD4.
* **WD4 rule as a three-way setting**, replacing today's on/off challenge toggle: *challengeable* (the
  official rule), *enforced* (an illegal WD4 can't be played at all, so there's nothing to challenge:
  Gameloft UNO Spin's Challenge Off, spec 12) or *free* (playable any time, no challenge: Ubisoft's No
  Bluffing, and today's "challenge off"). Spin's Off setting also drops UNO-call challenges; here that
  stays with the separate UNO-call toggle (D7).
* Stack Pack (color-gated cards, Wild Stack 3, Wild Stack Number with its flipped-card count).

*Content wave:* Progressive UNO (official variant), Stack Pack.

### Phase 4: Deck presets (M)

A "Deck" setting chooses a preset: card list, copy counts, scoring table, starting-card rule, deal
size bounds, color set, and the rules it forces. Presets in order:

1. **Iconic Series** (8 Wilds, per-decade color sets; recolor through `gen_cards.py`).
2. **All Wild** (112; every play legal; starting action ignored; WD4 unchallengeable).
3. **UNO Express / Pocket** (56-card decks, deal 5, to 250; Express's Wild Draw Two 4/4).
4. **UNO Junior** levels 1-2 (56; animal tag as a third match attribute), **My First UNO**,
   **Choo Choo** (drawn card playable at once).
5. **X Games** (renamed action set) and the H2O family (first to 3 hands).

`initialCards` gets clamped per preset (Part 6, C11).

*Content wave:* five official alternate decks.

### Phase 5: UNO Flip and its editions (L)

* Card defs get a `back` def; the deck has a `side` (light/dark); `match` reads the active face.
* The flip procedure from the sheets: invert the discard pile, then the draw pile, then every hand,
  so the new top card is the back of the old *bottom* card. A starting Flip flips immediately (2020
  print); post-flip, the exposed card's action doesn't apply and an exposed Wild's color is called by
  the Flip player.
* Per-side scoring, per-side AI evaluation (the AI must value what its hand looks like on the other
  side), dark-side art through `gen_cards.py`.
* Light/Dark face pairing isn't documented anywhere (F3): use a fixed, seeded pairing stored in the
  deck manifest so replays stay stable.
* Then the editions as data: Marvel (Super Hero / Villain wilds), Stranger Things (Jim Hopper,
  numbers 2-9 and 11), Transformers (Optimus / Megatron duels need Phase 13's reveal; ship them when it
  lands), Flip Express (56 cards, Draw Three dark side, Wild Draw Color capped at 5), Flip Splash.

*Content wave:* UNO Flip (2018 and 2020 prints), Flip Express, Flip Marvel, Flip Stranger Things.

### Phase 6: Elimination and Show 'Em No Mercy (L)

* **Seat deactivation.** The active-seat list from Phase 0g gains knockouts: a knocked-out seat is
  skipped, can't be targeted, and its hand goes aside. This is also the deferred "shrinking table"
  mode from Part C, which comes almost free here.
* **Cap knockout toggle (D5):** reaching the hand cap knocks you out, in any deck mode.
* **Elimination by score** (UNO Undercover's cut game type, spec 09): after each round the highest
  scorer is knocked out, until two players remain. A sub-option of match play, beside Challenge UNO's
  "out at 500 points held" (both need knockouts, so both land here rather than in Phase 1).
  Two more from Gameloft's mobile games (spec 12): **Elimination by strikes** (a strike each time you
  have no playable card; out at 3, 4 or 5) and **Drop-Out** (3 rounds; after each, the lowest-ranked
  player is out, with losers ranked by the value of the cards they hold).
* **No Mercy** (HWV18): the `equalOrHigher` stack policy, draw-until-playable then must play, Mercy
  Rule at 25+ cards checked after *every* hand change, Discard All, Skip Everyone, Wild Reverse Draw 4
  (and its 2-player rule), Color Roulette (the victim names the color), built-in 7-0, scoring
  20/50/250 per knockout/1000. Per-type copy counts aren't printed (F3); use the fan-wiki breakdown
  (168 total) as the provisional manifest and flag it in the deck description.
* No Mercy Expansion and the No Mercy Coin (doubles the played draw card's value; once per game).
* In a scored match, a Mercy knockout lasts the rest of that round only; the player is back for the
  next round. That's Ubisoft's in-game wording (spec 11) and fits the physical deck's 250 points per
  knockout.

*Content wave:* Show 'Em No Mercy, shrinking-table house rule, Challenge UNO elimination variant.

### Phase 7: Interrupts, response windows and UNO calls (L)

* **Interrupt windows.** After a card lands and before its queued effects resolve, open a window in a
  fixed priority order (C3): device races, then the response window for the effect's target, then
  Jump-In for everyone. The AI answers through per-window callbacks; the human gets a short timed
  prompt (configurable, off in replays, where answers are logged).
* **Jump-In** (official, sheet 41940): identical face, cancels and replaces the top card, play resumes
  from the jumper; "adds to the stack" as a sub-option, and a "numbers only" sub-option (UNO Party!'s
  and Ubisoft Party! Mania's Speed Play, spec 11).
* **Skip n' Flip** (Ubisoft, spec 11), a toggle that gives existing cards a response: a Skip played on
  a pending draw penalty redirects it to the next player, and a Reverse reflects it back to whoever
  played it. No new art. It runs through the same response window as the cards below.
* **Response cards** with three outcomes: block (ends the pending effect, and the whole stack, with no
  draw), reflect (sends it back to whoever played the last card of the stack), redirect (to a chosen
  seat). Defense Pack, Wild NO U, Super Star, Agent P, Avengers Assemble, BFF Power, Flitterific, This
  is the Way, Invisibility, Wild Petty Play, Ubisoft's Wild Blue Yonder (passes the penalty on to the
  next player) and Punching Things (reflects it at double).
* **Out-of-turn plays** that aren't reactions: Avatar State.
* **UNO call, extended.** Phase 1's call becomes an event other cards can react to: Hail Mary,
  Dawg Pound, Flip Attack's missed-UNO rule (2 presses), and Teams' partner calling for you.
* **Your reaction prompt (D10).** A short timed prompt appears only when you hold a card that can
  legally respond or jump in, and times out to "pass". An "always wait for me" option removes the
  timer.

*Content wave:* Jump-In, Defense Pack, Reverse Pack's Wild NO U, about a dozen response bonus cards.

### Phase 8: Standing effects, on-draw triggers and player links (M)

* A per-player and a global list of standing modifiers, each with a "starts", an "ends when" and a
  query hook (survey Part F2, item 12): color locks (Forces of Nature, the Expo color lock), immunity (Save the Day),
  repeating triggers (Hyperspeed, Black is My Happy Color).
* **Timed statuses** (spec 09): a turn counter on a seat's modifier that counts down at the start of
  that seat's turn, shows as a badge on its portrait, and clears at round end. A count of 0 expires on
  the next turn start, so the effect does nothing. UNO Undercover's Sleep (lose N turns), Toe Hold (up
  to 3 random cards locked for N turns, via a per-seat legality filter) and Lucky Croc Tooth (N turns of
  bouncing Draw Two / WD4 back to its player, a passive reflect using Phase 7's reflect operation) are
  the first users; any "until your next turn" card from other decks is a count of 1.
* **On-draw hook** that fires in every draw path, including penalty draws and draw-until loops:
  Creeper, Crash-Up.
* **Links between players:** Frenemies' Nemesis, Love Island's Coupled Up and Eggs In One Basket,
  Drawn Together. Ubisoft's version pins the link rules (spec 11): only one Drawn Together link
  exists at a time, and a new Drawn Together or a Point Taken breaks it.
* **More standing effects from Ubisoft's DLC** (spec 11): Explosive Results (the next draw by anyone,
  for any reason, gets 3 extra cards: a one-shot global trigger on the on-draw hook); Typhon's Curse
  (while you *hold* it, you draw a card each time you play: an effect attached to a card in hand,
  which travels with the card); Hot Number (only number cards may be played without penalty; anyone
  playing an action or Wild draws 1 afterwards; the game text gives no duration, so one lap, marked
  provisional per D9); Hurry Up! (a few turns of a 3-second timer, reusing Phase 1's turn timer; CPUs
  never time out, so it only presses the human).

*Content wave:* Frenemies Pack, Love Island deck, the remaining standing-effect bonus cards, and
UNO Undercover's Sleep, Toe Hold, Lucky Croc Tooth and the cut Personal Shield.

### Phase 9: Randomizer devices (M)

Each device is an outcome table with logged results (`RN`), a short animation and a deck preset.
Device odds aren't printed anywhere (F3); pick documented distributions and keep them in one data
file so they're easy to tune.

1. **UNO Attack** (launcher: press ends your turn; Mega Hit stacking) and **No Mercy Attack**
   (every press completed).
2. **UNO Spin** (per-edition wheels, spec 03).
3. **Tiki Twist, Roboto, Eye Eye, Wild Jackpot, Mario Kart Item Box.**
4. **UNO Blast** (accumulate-and-dump pile outside both decks; needs `drawSourceFor`).

### Phase 10: Roles and owned objects (M-L)

Things that belong to a *player* rather than a hand, so hand swaps don't move them (C4): Power Grab
towers (U/N/O/!), Colors Rule powers, Royal Revenge's King/Jester (the King names every Wild's color,
C6), Remix, and **Flex** (each player's Power Card; flexed color governs only your own play; the
all-red reset; "flip icon" numbers). Flex lands here, not in Phase 4, because its Power Cards are
owned objects and it is the main user of the `match` split.

### Phase 11: Teams (M)

Official **UNO Teams** (HXT58/JDM40): partners across, opening pass, half-hand handover when a partner
goes out, tagging back in, Wild Team Play and Wild Team Draw Four, passing-symbol cards. Rework today's
2vs2 into a Teams preset with the classic deck. With four seats this is exactly two teams of two; the
box's "2-4 teams" needs more seats (Part 7, D6). The simpler partner modes in Gameloft's UNO Spin and
UNO & Friends (2v2, both partners win when either goes out) are today's 2vs2 and stay as the
lightweight option.

### Phase 12: Multi-play and multi-pile (L)

* A **multi-play state** with a cap and a single "contribution" rule (C8): Speed Pack chains (only the
  last card fires), Power Sword, Team Attack, NDJOLIJEAN multi-discard, Fire Fist Ace, UNO
  Undercover's Shooting Star (1 to 4 cards of one color; the first must be a legal play, you may stop
  early, none of their actions fire, and the color becomes the last card's; spec 09 section 7).
* **Triple Play** (three piles, overload draw 1-4, Wilds set no color, the timer) and **Tippo**
  (two trays, Stop cards, the tilt penalty). Both need `match` to become per-pile.

### Phase 13: Hidden information (M-L)

Liar's UNO (face-down plays and bluff calls on the Phase 3 challenge object), simultaneous reveal and
duels (Kickin' Battle, Locked Up, Power of Friendship, the Transformers Flip wilds), memory quizzes
(Remember Me). The AI work is the cost here, not the rules. Also the visibility modifiers and cards
from Ubisoft (spec 11): Fog of War (opponents' card counts hidden too), Flipped! (you see everyone's
cards but your own), Rayman's Escape (peek at every opponent's hand, then hide your own card count),
and Valhalla's Battle (a secret color guess; ships with Phase 16).

### Phase 14: Power frameworks (L)

UNO Ultimate Marvel/DC (personal 56-card character decks via `drawSourceFor`, empty deck eliminates,
play → power → defeat → Danger order), Elite NFL lineups (3 of 8, single use), and the Fandom NFL team
rules from spec 08. Ship the framework with a handful of characters first; the add-on characters'
power text is still incomplete (F3). Fenyx's Quest's gods (spec 11) fit here too: each god is sealed
until you've played 5 cards, then gives a passive power for the match, which needs a per-player
progress counter alongside the power slot. UNO & Friends' career powers (spec 12) use the same
counter as a charge meter: every card played charges it, and the power fires on its own when full.
Freeze (about half the opponents' cards locked for 2 turns, the Toe Hold lock from Phase 8), Flurry
(all opponents draw 2), Transform (one special card per opponent becomes a number card, C18),
Safeguard (2 turns of protection from draw cards) and Sabotage (the opponent with the fewest cards
draws 4).

### Phase 15: Prompt-and-fallback cards (S)

One prompt framework for honor-system cards (dares, trivia, sound effects): the card shows its text,
and the engine applies its draw-penalty fallback as the real effect. Reaction races (Shark Attack,
Kevin's Chili, Touchdown!) resolve with simulated AI reaction times against a human button press.

### Phase 16: Ubisoft theme systems (L, optional)

Two Ubisoft DLC themes add whole subsystems on top of UNO, now fully specified (spec 11):

* **The Call of Yara:** a per-player currency (300 to start, +100 each turn, per stacked Draw Two and
  per Jump-In), four two-level services callable on your own turn with a 1-turn cooldown, and the
  Guerrilla broadcast Wild with six money events. Prices aren't in the install; pick them per D9.
* **Valhalla:** a numbered map where each number card you play moves your pawn, Cargo pickups,
  six event spaces, and two upgrades (Battle at 2 Cargo, Fast Travel at 4).

Both need a side panel on the table UI and new AI goals (spending, routing), which is why they sit
last.

### Phase 17: Tournament ladder (S-M, optional)

A sequence of matches where player count and rules escalate together, built from Phase 1's presets.
Gameloft's UNO ladder is a ready-made template (spec 12): 15 rounds, best of 5 each, from 2 players
with basic rules up to 4 players with Cumulate, 7-0 and Jump-In all on. UNO Spin's 12 cups add bonus
cups for Team, Elimination and Challenge UNO. It needs the rules it schedules (Phases 3, 6 and 7);
rewards stay cosmetic.

### Not planned

* **Different games under the UNO brand** (Skip-Bo, Phase 10, Dos, Stacko, ...): separate projects.
* **More than four seats on screen** (UNO Party!, Teams with 3-4 teams, Flip at 10 players): the
  engine is seat-count agnostic from Phase 0g (D6); the table layout, AI tuning and tests for 5+ seats
  are a dedicated phase after Teams, not scheduled yet.
* **Real-time reaction hardware** (Flash, Reflex, Showdown, Blitzo) beyond Phase 15's simulated races.
* **UNO 52's poker hands**: a different scoring game bolted onto UNO, revisit last.
* **Wagering / payout multipliers** (UNO Mobile): excluded on principle.
* **Non-UNO mini-games** (UNO & Friends' Recall, Path and Stacking solitaire; Free Fall): different
  games using UNO card art.
* **Hot Seat** (several humans on one device, as in UNO & Friends): needs a hand-hiding handover screen
  between turns and more than one human seat. Revisit with the more-seats UI phase (D6).

---

## Part 4: The conflict model

Most version-to-version conflicts disappear once the engine has three fixed answers: who wins when
rules disagree, in what order things happen in a turn, and what "the card to match" means.

### 4.1 Precedence ladder

When two rules say different things, the higher one wins:

1. **The card's own printed text** (its own stack rule, its own color-naming rule, its own challenge
   penalty, "can't go out on this card").
2. **The deck preset's printed rules** (No Mercy's built-in 7-0 and must-play; All Wild's no
   challenge; Attack's press-ends-turn).
3. **Mode rules** (Teams' half-hand pass, elimination, match scoring).
4. **House-rule toggles** the player turned on.
5. **Classic UNO defaults** (sheet 42003).

Two consequences worth stating: a Stack Pack card keeps its color gate even under No Mercy's
equal-or-higher policy (rule 1 beats rule 2), and a deck that prints a rule locks the matching toggle
rather than letting it double-apply (No Mercy + 7-0 runs 7-0 once).

### 4.2 Turn pipeline

Every turn, in this order:

1. **Start of turn:** standing effects that fire "at the start of your turn"; expire effects that
   last "until your next turn"; skip checks.
2. **Action:** play (one card, or a multi-play chain under Phase 12), draw, or press a device.
3. **On play:** the card leaves the hand; the top card and `match` update; the card's effect pushes
   steps onto the queue. *The hand is now possibly empty, but going out isn't checked yet.*
4. **Interrupt windows** (Phase 7), in priority order: device race, target's response window,
   Jump-In. A response rewrites or removes queued steps; Jump-In cancels the queued steps of the card
   it lands on and starts a new step 3 for the jumper.
5. **Resolve the queue** FIFO. Steps may push further steps (draw-until, on-draw triggers,
   reflected effects), which go to the back of the queue. Random outcomes are logged.
6. **After resolution:** Mercy Rule and other elimination checks; *then* going out (so a card that
   empties your hand and then deals you cards, or a swap that hands you new cards, is settled before
   anyone is declared out); then end-of-match checks.
7. **Pointer:** move once, by the net result of skips, reverses and jumps recorded during step 5.

Rules this pipeline settles in one place:

* An effect that targets a seat eliminated earlier in the same queue fizzles.
* "Play again" effects and skip effects compose by counting, not by overwriting.
* Mid-queue elimination never happens; partial draws are never interrupted by a knockout.
* A player who goes out by a discard effect (Roboto, Eye Eye, Spin To Go allow it) wins at step 6
  even if it wasn't their turn.

### 4.3 What to match

`match = {color, face, number, tags, pile}` is the only thing legality reads.

* Who sets `match.color`: the card's own rule (Color Roulette's victim; a Remix-named player); else a
  role (Royal Revenge's King); else the player of the card. Triple Play Wilds set none (the next card
  sets it). Flex sets it from the *printed* color, not the flexed one.
* WD4 legality checks the color in force *before* the Wild, after any pre-play power (Captain
  Marvel's) has resolved.
* Under Flip, `match` is recomputed from the new top face after every flip.
* Tags (Junior animals, themed icons) match only in decks that declare a tag as a match attribute;
  everywhere else tags are inert data for predicates.

---

## Part 5: Compatibility of deck modes and rule toggles

Legend: ✓ works unchanged · **P** works with the rule in the footnote · **L** locked by the deck
(forced on or off, shown but not editable) · — does nothing with this deck (stays selectable, with
the reason shown) · ✗ conflicts: turning one on switches the other off, with a notice (D3).

Deck modes are themselves one exclusive group: turning on Flip switches off No Mercy, and so on.

| Deck mode ↓ / toggle → | 7-0 | Jump-In | Stacking | Draw to match | Bullseye | WD-type challenge | Swap / Add-On packs | Bonus Wild | Teams |
|---|---|---|---|---|---|---|---|---|---|
| Classic 108 | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Iconic (112) | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ | ✓ |
| Express / Pocket | P¹ | ✓ | P² | ✓ | ✓ | P³ | P⁴ | ✓ | ✓ |
| Junior / My First | ✓ | ✓ | P² | ✓ | P⁵ | — | P⁴ ⁶ | P⁶ | ✓ |
| All Wild | — | ✗⁷ | P² | — | ✓ | L (off) | ✗⁸ | ✓ | ✓ |
| Flip | P¹ | P⁹ | P¹⁰ | ✓ | P⁵ | P³ | ✗¹¹ | ✗¹¹ | ✓ |
| No Mercy | L (on) | P¹² | L (≥ value) | L (on, must play) | P⁵ | — | P¹³ | ✓ | P¹⁴ |
| Flex | P¹ | P¹⁵ | P² | ✓ | P⁵ | P³ | ✓ | ✓ | ✓ |
| Attack / launcher | P¹ | P¹² | L (Mega Hit) | L (off) | P⁵ | P³ | P¹⁶ | ✓ | ✓ |
| Triple Play | ✓ | P¹⁷ | — | P¹⁷ | P⁵ | — | ✗ | ✗ | ✓ |
| Tippo | P¹ | P¹⁷ | ✓ | P¹⁷ | ✓ | L (none) | ✗ | ✗ | ✓ |
| Ultimate | ✗¹⁸ | ✗ | ✗ | ✗ | ✗ | — | ✗ | ✗ | ✗ |

1. Decks without 0s (Flip, Pocket, Attack, Power Grab, Colors Rule, Flex's 1-8) keep only the 7 half;
   the label says "7 only". Tippo's number range is set by its Stop-card layout; verify on build.
2. The deck's own draw cards (Draw 1, Wild Draw Two, Draw Three) get `drawValue`s; the global policy
   applies to them. All Wild's targeted draws stack only under `sameType`.
3. The challenge object uses the deck's printed penalties (Express WD2 4/4; Flip WD2 2/4 and Wild Draw
   Color; Flex regular-side WD4 6/4 with Wilds counting as a match).
4. Add-On Packs are printed for 108-card decks; allowed, with a warning that they swamp a 56-card deck.
5. Bullseye retargets the deck's own +N and Skip cards. Skip Everyone, Wild Draw Color and targeted
   draws already choose their own target and ignore it.
6. Allowed, but the description warns that it makes a kids' deck much more complicated.
7. With every card wild, "identical face" matches constantly and Jump-In becomes the whole game.
8. Colored add-on cards have no meaning in a colorless deck.
9. "Identical" means the same face on the active side.
10. Wild Draw Color is a draw-until, not a number: it can't join a stack and it ends any stack it's
    played on (it isn't legal on a pending stack unless the policy is `anyHit`-like). Draw Five and
    Draw One get values 5 and 1.
11. Single-sided cards can't flip. Allowed only once a Flip-native version exists.
12. Jump-In is suppressed while a stack or a launcher press is pending; it reopens once the penalty is
    taken. (Official rules never address Jump-In under No Mercy, Stack Pack or Mega Hit.)
13. The Swap and Reverse packs are fine. The Stack Pack is allowed with its own color gate (4.1), and
    its Stack 1 can never follow a +2 under the value rule; the description says so.
14. A knocked-out partner's team plays on with one seat; the team is out when both are.
15. "Identical" means same printed face *and* same played-as state; a flexed card can only be jumped
    by a card flexed the same way.
16. Hit cards and draw-card add-ons coexist; anything that says "draw" draws from the deck, not the
    launcher.
17. Jump-In and Draw to Match apply per pile: an identical card may jump onto any pile showing it;
    drawing stops when the card fits any pile.
18. Ultimate has personal decks, character ownership and elimination by empty deck; none of the
    classic toggles transfer. It's its own mode with its own settings page.

### Toggle-against-toggle interactions

Within one deck mode, the house rules interact as follows.

| Pair | Resolution |
|---|---|
| 7-0 + Swap Pack | Both call the same swap/rotate primitive; no conflict. Wild Pass Hands follows the current direction like the 0; Billie Eilish's Wild Pass Color always goes left (its own text, 4.1). |
| 7-0 + Teams | 7 may target anyone, partner included; nobody can swap with a seat holding 0 cards. |
| Jump-In + stacking | Default (official): the jumper's identical card replaces the top card, so the pending total stays the same and its target becomes the seat after the jumper. Sub-option "adds": the jumper's value is added as in Ubisoft's digital rule. |
| Jump-In + Bullseye | The jumper chooses a fresh target. |
| Jump-In + WD4 challenge | The cancelled WD4 can't be challenged. The jumper's WD4 is checked against the color in force before the cancelled card, and only its new victim may challenge. |
| Jump-In + 7-0 | A jumped 7 or 0 resolves for the jumper only; the cancelled one never swaps. |
| Stacking + WD4 challenge | Only the seat the stack finally lands on may challenge, and only the last WD4; the penalty scales with the stack under `sameType` (Progressive), stays 4/6-based otherwise. Choosing to stack waives the challenge. `classicMixed` keeps today's behavior (stacked WD4 can't be challenged and doesn't change color). |
| Stacking + Bullseye | The last stacker chooses who receives the total; that seat may keep stacking. |
| Stacking + Draw to Match | Taking a stack is a forced draw; Draw to Match never applies to it (already true in `doDraw`). |
| Stacking + response cards | Block ends the whole stack with no draw. Reflect sends the total to whoever played the last card of the stack. Redirect sends the total to the chosen seat, who may stack on it if the policy allows. Reflect on reflect is allowed (NO U on NO U); block can't be reflected. |
| Response window + Jump-In | The response window resolves first; Jump-In opens only on the resulting top card. |
| Draw to Match + Force Play | Unchanged from today. Under No Mercy both are locked on. |
| Swap Pack + stacking | Swap cards aren't legal on a pending stack; legality already only allows stack cards there. |
| Bonus Wild + anything | Each bonus card declares which primitives it uses; one that needs an unbuilt phase isn't offered. |
| Elimination + swaps | Eliminated seats are excluded from every target filter; a set-aside hand is never swapped. |
| Standing effects + hand swaps | Effects owned by a *player* stay with the player; effects attached to *cards* travel with them. |

---

## Part 6: Conflict catalog by theme

This extends Part F2 of the survey with the concrete engine rule for each conflict. C-numbers are used
in the plan above.

**C1. Stacking policy.** Six official models (spec 01 note 1) → the Phase 3 enum, with a card's own
rule beating the global one (4.1). `classicMixed` stays for players used to today's rule 2.

**C2. Response outcomes.** Block, reflect and redirect are three operations on the queued penalty
step, not three mechanics. Passive protection (Power Grab towers, Colors Rule Yellow, Remix Shield,
Save the Day) checks the *last* card of a stack. Whose turn follows: after block, the blocked seat
plays normally; after reflect or redirect, play continues from the seat after the one that finally
draws, which is the same rule as an ordinary draw penalty. (The Defense Pack sheet is silent on turn
order, spec 01 gap 6, so this is a design choice.) Deflects chain: each response applies its own
operation to the *current* total, so a Punching Things (reflect, ×2) answered by a Wild Blue Yonder
(pass on) sends the doubled total to the next player, and two Punching Things in a row quadruple it.
The hand cap (D5) and the Mercy rule are the only limits.

**C3. Out-of-turn priority.** Device race, then response window, then Jump-In. Powers that say "on
your turn" don't work on an out-of-turn play. No Jump-In during a mass discard or a multi-play chain
(it would let a player act between steps of one effect).

**C4. Hand movement and ownership.** One `swap(a, b)` and one `rotate(direction, count)` primitive.
Owned objects (Power Grab towers, Colors Rule powers, Flex Power Cards, Elite NFL lineups, standing
links) belong to the player and never move with the hand. In Teams, a seat with 0 cards can't be
swapped with.

**C5. Draw sources and draw-until.** `drawSourceFor(seat)` returns the shared deck, a personal deck
(Ultimate) or a device (Attack launcher, Blast pile). Draw-until loops reshuffle as usual, stop when
both piles are empty, and respect a per-card cap (Flip Express: 5) or a global safety cap (default
15). An on-draw trigger in the middle of a draw-until pauses the loop, resolves, then continues.

**C6. Color authority.** 4.3. Royal Revenge's King overrides only cards that don't name their own
color-setter.

**C7. Turn pointer.** Pointer moves are recorded during the queue and applied once (4.2 step 7). Flash's
random order disables Reverse and direction-based effects (shown greyed with that deck).

**C8. Multi-card plays.** One multi-play state with a per-card cap; caps don't add together (Speed Pack
chain inside a Spin "2x" is still one chain). In a chain, only the last card's action fires unless the
card says otherwise (NDJOLIJEAN: all fire). Two +2s in one turn count as one stack contribution under
`sameType` (Progressive's one-per-turn rule).

**C9. Conflicting and inert toggles (D3).** Driven by `conflicts`, `group`, `partialWhen` and
`lockedBy` on each descriptor (Part 5, Phase 0c). Turning on a toggle switches off whatever conflicts
with it and shows what changed; inert or partial toggles stay selectable and show the reason ("this
deck has no 0s").

**C10. Challenges.** The Phase 3 challenge object. Who may challenge: only the seat the penalty lands
on. Who plays next after a challenge (sheets are silent; Wikipedia's reading): success, the challenger
plays; failure, the challenger loses the turn. The chosen color stands either way.

**C11. Deck size against deal size.** Players × `initialCards` plus one starting card must leave at
least a few cards to draw. Clamp `initialCards` so that at least 10 cards remain (4 players × 20 cards
is 80, which is fine for 108 but impossible for a 56-card deck); presets set their own default (5 for
Express, Junior, Flip Express).

**C12. Hand cap.** `MAX_HOLD_CARDS = 26` silently drops extra draws today, which changes outcomes and
breaks card conservation under big penalties. Options: (a) raise the cap and compress the hand fan,
(b) keep the cap and leave capped draws in the deck (documented, conserved), (c) under No Mercy the
Mercy Rule makes the cap moot at 25. Decided (D5): the cap is a setting (including no cap), capped
draws stay in the deck as in (b), the hand fan compresses as in (a), and a separate toggle makes
reaching the cap a knockout.

**C13. Two-player overrides.** One table, filled per effect:

| Effect | 2-player behavior |
|---|---|
| Reverse | Acts as Skip (already implemented) |
| Skip Everyone, Skip Two | Play again |
| Wild Pass Hands, 0 (7-0) | Swap with the opponent |
| 7, Wild Swap Hands, Swap 1, Bullseye, any "chosen player" | Auto-target the opponent |
| Wild Force Trade (any two seats) | Swaps you and the opponent |
| Reverse Skip (Undercover) | You go again (as coded) |
| Skip Draw-Two, Reverse Draw-Two (Undercover) | The opponent draws 2 and loses their turn, then you play again (as coded) |
| Skip n' Flip (Ubisoft) | A Skip redirects to "the next player", who is the one that played the draw card, so it acts like Reverse's reflect |
| Cross-Fade (Ubisoft, "the player directly across") | Swap with the opponent. With 3 players nobody sits across, so the card is left out of the deck (our rule) |
| Highland Two-Step, Switcheroo, Tsunami (Undercover) | Need two opponents. Left out of the deck in 2-player games, as Undercover does for the first two |
| No Mercy Wild Reverse Draw 4 | Its player draws 4 unless the opponent stacks it back (sheet HWV18) |
| 50/50 coin (#6) | You must be one of the two players (sheet HBF05) |
| "Everyone except you", "fewest cards" | The opponent |
| Teams | Conflicts with a 2-player game: turning Teams on sets 4 players, as 2vs2 does today |

**C14. Discards outside normal play.** Each discard primitive carries `actionsFire = true/false` from
its sheet (spec F2 item 11): true for Roboto, Eye Eye, Wild Jackpot, Spin 2005, Blast and NDJOLIJEAN;
false where cards go to the *bottom* of the discard pile or the text says actions are inert. Going out
through such a discard counts at 4.2 step 6.

**C15. Persistent state across a flip.** Under Flip, standing effects tied to a *card* (a color lock
from a card on top) are recomputed after the flip; effects tied to a *player* persist. Stack totals in
progress when a Flip is played: Flip isn't legal on a pending stack.

**C16. Replay determinism.** Every random choice (device outcome, random target, AI timing in a race,
reshuffle order already handled by the seed) is logged with `RN`. Human response-window answers and
UNO-call timings are logged too, so replays don't depend on frame timing.

**C17. AI coverage.** A card is only offered in a deck once its effect has an AI evaluator. The
default evaluator ("treat as a Wild worth N") exists only so self-play tests can run while a card is
in development.

**C18. Card mutation and creation** (Redecorate, Double Cross, Clone; Ubisoft's A Little Help and
Glitched). A recolored card is given a
new def for the rest of the game (logged in the replay), so legality, Jump-In's "identical card",
scoring and AI all just read its current def. A cloned card is a real card from then on: it goes to
the discard pile and is reshuffled like any other. Card conservation counts card *objects* against
the deck manifest plus a logged "created" count, so a Clone doesn't fail the self-play invariant.

**C19. Seat swaps** (Switcheroo). Swapping two seats reorders the active-seat list, so turn order and
"next player" change while the hands and statuses stay with the players; on screen the two players'
positions swap. In Teams or 2vs2, a seat swap would break partners sitting across from each other, so
Switcheroo is left out of the deck with those modes on.

**C20. Human-only special cards** (Undercover's Command Cards are never dealt to the AI). Treat
"human-only" as a dealing rule only. If a hand swap, pass or Tsunami moves such a card to a CPU, it
belongs to that CPU and can be played (which C17 already requires to work). The alternative, cards
that refuse to move, would make every hand-movement effect special-case them.

**C21. Paying a paired card with your last card.** If the paired sizing card is the last card in your
hand, you go out once the effect resolves (4.2 step 6), as with any other card that empties your hand.
Undercover does the same. It differs in one case: when the special card *itself* is your last card,
Undercover ends the round at once and the effect never runs, whereas the turn pipeline resolves it
first. For most special cards that changes nothing (a paired card has nothing left to pair with), but
a Draw-Two combo as your last card makes the next player draw before scoring. That follows the
classic official rule for a last Draw Two, so the pipeline keeps it.

---

## Part 7: Decisions (settled 2026-10-23)

| # | Decision | Outcome |
|---|---|---|
| D1 | Swap Pack accuracy | The Swap Pack toggle switches to the official sheet: Wild Force Trade swaps any two players, Swap 1 lets you choose the card you give back, Refresh Hand goes under the discard pile. Today's Wild Swap Hands and Refresh Hand stay as separately named cards (the classic deck's Wild Swap Hands and a Cosmic Crush-style card), offered through later options (Phase 1). |
| D2 | Jump-In | Official cancel-and-replace by default, with an "adds to stack" sub-option (Phase 7). |
| D3 | How free combinations are | Every toggle, deck modes included, is available. Turning one on automatically switches off any conflicting toggle with a notice; toggles that only partly apply stay usable and explain why; rules a mode builds in show as locked (Phase 0c, Part 5, C9). |
| D4 | Themed bonus card names | Original, generic names and icons in the game; the inspiring product is noted only in the docs. |
| D5 | Hand cap | A setting, including "no cap"; capped draws stay in the deck; the hand fan compresses (Phase 1). A separate toggle makes reaching the cap a knockout (Phase 6). |
| D6 | More than four seats | Split: the engine becomes seat-count agnostic in Phase 0 (0g); the screen layout and AI for 5+ seats get their own phase after Teams. |
| D7 | Calling UNO | Simple version in Phase 1 (button, CPU forget and catch chances, draw 2 if caught), on by default; extended for reaction cards in Phase 7. |
| D8 | Honor-system cards | Only cards that print a draw-penalty fallback, with the fallback as the real effect (Phase 15). |
| D9 | Unprinted numbers | Documented values in easy-to-tune data files, marked "provisional" in the deck description. |
| D10 | Your reaction prompt | A short timed prompt only when you hold a legal response or Jump-In card, timing out to "pass"; an "always wait for me" option removes the timer (Phase 7). |

---

### Undercover rulings (spec 09 section 7)

Settled from the decompiled code, with this project's own choices where Undercover is silent or too
loose.

| # | Question | Outcome |
|---|---|---|
| U1 | Command Card points | Help-screen points (20-70). The shipped game scores them 0, most likely an oversight. |
| U2 | A special card moved into a CPU's hand | The CPU owns it and can play it; "human-only" only controls dealing (C20). Our decision; in Undercover it can't happen. |
| U3 | Skip Draw-Two (and Reverse Draw-Two) with 2 players | The opponent draws 2 and loses their turn, then you play again (as coded; C13). |
| U4 | Shooting Star | None of the placed cards' actions fire, and the color becomes the last card's (as coded). Our changes: the first card must be a legal play, and you may stop after 1-4 cards. |
| U5 | Pairing your last card | Allowed; you go out once the effect resolves (as coded; C21). |

---|---|---|
| U1 | Command Card points: the help screen prints 20-70, but the shipped game scores them 0 | Use the help-screen points; 0 looks like a missing `setValue` call, not a design choice |
| U2 | Can special cards moved to a CPU (by a hand swap, pass or Tsunami) be played by it? | Yes; "human-only" only controls dealing (C20) |
| U3 | Skip Draw-Two with 2 players | The opponent is skipped and draws 2 (C13) |
| U4 | Shooting Star: which of the up-to-4 cards' actions fire? | Only the last card's, as in C8 |
| U5 | Pairing your last card as the sizing card | Allowed; you go out once the effect resolves (C21) |

---

## Part 8: Testing strategy per phase

* **Self-play matrix** generated from rules descriptors and deck presets, run on fixed seeds. Because
  every toggle is reachable (D3), the matrix samples random toggle sets, passes each through the
  conflict resolver, and plays whatever comes out; the resolver itself gets unit tests that no
  conflicting pair survives and that every switched-off toggle is reported. Invariants: card conservation against the deck manifest, hand sizes within the
  cap, legality against `specLegal`, termination (with draw-until caps), replay reproduction.
* **Policy-specific tests** for every row of the toggle-against-toggle table, as scripted hands
  (`tests/humanplay.lua` style) that set up the exact situation (a +2 stack with a Jump-In waiting, a
  reflect on a reflect, a Flip played onto a pending stack).
* **Golden replays**: one recorded game per official product, checked into `tests/`, that must replay
  identically after every change.
* **UNO call**: with forget and catch chances at 0 and 1, scripted hands check the 2-card penalty
  fires exactly when it should, and replays reproduce every call.
* **Refactor guard** (Phase 0): win-rate and game-length distributions on 10,000 seeded games must
  match before and after.
