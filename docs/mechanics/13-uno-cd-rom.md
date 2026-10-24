# UNO CD-ROM (#236): decompiled findings

> Reference spec for `docs/gameversions.md` (Part E4, row #236).
>
> **Source.** `UNO.ISO`, supplied by the user: a 95 MB disc image dated September 2000, "UNO(TM) CD-ROM v1.0".
>
> **How it was read:**
> - The image was copied into its own folder and extracted with 7-Zip.
> - The game files sit in InstallShield 6 cabinets (`data1.hdr` / `data*.cab`). They were unpacked with a small extractor written for this pass, following the cabinet layout documented by the open-source `unshield` project. All 180 files came out.
> - The rules engine is Java bytecode inside `support\uno-jpp-1.dll`, a Microsoft Visual J++ COM DLL. Its 123 classes were cut out by walking the class-file structure, then decompiled with **Vineflower 1.10.1**.
> - Nothing was installed or run.

Confidence:
- **HIGH (manual)**: the on-disc `useman.txt` / `readmeuno.rtf`.
- **HIGH (code)**: the decompiled engine.
- **MED**: inferred.

---

## 1. Corrections to `gameversions.md` E4

| Our doc says | Disc says | Source |
|---|---|---|
| Dev/pub Mattel Media / Mattel Interactive | **Developed by HotGen Studios** (London) and published by **Mattel Interactive**. The same studio made the Game Boy Color UNO (#237). The rules engine is a licensed Java library, package **`com.ogalala.uno`** (Ogalala). | manual credits, readme legal notice, class names |
| Dating unclear (2000 vs 2002) | **© 2000.** The disc files are dated May–September 2000, and the version is v1.0. A 2002 date would be a reissue. | readme, file dates |
| Mutant and Shark effects unknown | **Resolved** (section 2) | manual + code |

## 2. The New Special Cards

**What they are:**
- The cards are optional. The "New Special Cards" switch in **Setup New Game → Rules** turns them on.
- With it on, `UnoSpecialCards` replaces `UnoDefaults` as the rule set.
- **All three are colored cards, not wilds**, and the deck gets one of each per color (HIGH, code).
- That makes **12 new cards and a 120-card deck**: 4 colors × (25 standard + 3 new) + 4 Wild + 4 Wild Draw Four.

| Card (internal name) | Effect | Points |
|---|---|---|
| **Spy** (`Camouflage`) | **While it's in your hand, the other players can't see how many cards you hold.** A hand is flagged `hidden` whenever it contains one (`UnoCardSet.checkHidden`), and the front end draws it with its `-cards-hidden` state. Playing it does nothing: its action is `HIDE_HAND`, which maps to `UADoNothing`. It also has a **real rules effect**: CPU players **can't challenge a missed UNO from a hidden hand** (`UTChallengeUno` returns early on `hand.hidden`). | **75**, the highest-value card in the deck |
| **Shark** | Starting with the next player, each player in turn order is bitten with probability **1/N** (N = number of players); otherwise they're passed over. Players with empty hands are skipped. The loop can come round to whoever played it ("even the person playing this card might get bitten"). The victim takes a **4-card penalty** and loses their turn, the same as a draw card. (`UADoShark`) | 50 |
| **Mutant** | It plays like any card of its own color. On being played, it **takes the actual top card of the draw pile, puts it on the discard pile, and resolves that card's action as if it had been played** (`UAMutate`). If that card is a Wild Draw Four, the WD4 goes back into the pile and a random non-WD4 "decoy" card is substituted; the same happens if the draw pile is empty. Decoys are removed at the next reshuffle. | 20 |

Our doc's earlier wording for Mutant was "mutates into a randomly selected card of any color". It's more precise to say it draws the **next real card** off the pile, so the chances follow what's left in the deck.

## 3. Base rules as coded (HIGH, code + manual)

**Modes and setup:**
- **Modes:** Original (first to the score limit), **Challenge UNO** (the points left in your hand are added to your total, and you're out at the limit; the last two players go head-to-head), and **Team UNO** (2 v 2; when either partner goes out, the team scores both opponents' hands).
- **Setup options:**
  - Round Limit, 1–50
  - Score Limit, 100–3,000 (500 by default)
  - Game Type
  - New Special Cards on/off
  - number of opponents
  - Skill: Easy / Medium / Hard
  - AI delay, 0–4
  - Themes: Tabletop, Broadway, Circus and Space, which are cosmetic only
- **Instant UNO:** a single round with 4 players.

**Penalties and challenges:**
- **Draw Two, Wild Draw Four and Shark all go into a shared "penalty set".** At the start of your turn, a pending penalty means you may only pass and take the cards (`UADefaultMoveStart`). There's **no stacking**.
- **Going out on a Draw card:** if the last card played in a round is a Draw Two, Wild Draw Four or Shark, the next player still draws, and those cards count toward the score.
- **Wild Draw Four challenge** (only the player who has to draw may make it):
  - **Right:** the offender takes the 4.
  - **Wrong:** the challenger draws **4 + 2 = 6** and loses their turn.
- **UNO challenge:**
  - **Right:** the offender draws 2.
  - **Wrong: the challenger draws 2** (`UADefaultWrongChallenge` → `DRAW_TO_ACTOR, 2`). That penalty for a false accusation isn't in our docs.
  - **Timing:** you can only be caught from the moment your second-to-last card lands until the next player starts their turn.
- **Calling UNO too early:** the manual says pressing UNO while holding more than two cards also leaves you open to a challenge.

**Two players:** Skip and Reverse let you play again immediately.

**AI** (`UnoAI`, `UnoTacticsTable`):
- **Skill is one error threshold:** stupid 255, poor 144, average 80, smart 40, infallible 0, on a 0–255 scale.
- **That threshold is used three ways:**
  - how often the AI fails to challenge a *real* violation (an illegal WD4 or a missed UNO) — about (255 − t)/256 of the time it challenges;
  - how often it challenges *falsely* — about t/256;
  - how often it plays a Wild Draw Four illegally even though it holds a card of the current color.
- **How it chooses a card:** it plays the **highest point-value** legal card (to dump points), calls UNO as a separate check, and picks the **color it holds most of** when playing a Wild.

**Engine design worth knowing** (MED as a recommendation):
- Every card carries a *play action* and a *penalty action*, each an index into one shared `UnoActionTable` (Skip, Reverse, Draw, Wild, Mutate, Shark…) plus an argument.
- A rule set is just tables:
  - `SUIT_CARDS` / `NON_SUIT_CARDS` for the deck;
  - `PLAY_ACTIONS` / `PLAY_ARGS` for effects;
  - `PENALTY_VALUES` for points.
- New cards are added by adding table rows, not code. That maps well onto the card-definition approach in `docs/implementation-plan.md` (Phase 0).

## 4. What's worth taking

- **Spy / hidden hand size.** It needs a per-player "hand count visible" flag, which also affects:
  - **UI:** the hand count is drawn as hidden;
  - **AI:** the CPU can't use your count, and can't challenge a missed UNO from you.

  It's cheap, and it gives the plan's information mechanics (Reveal-or-draw and similar) a counterpart: a hide effect, not just reveals.
- **Shark.** A "roulette" penalty: walk the turn order, bite with probability 1/N at each step, and let it wrap round to the player who played it. It's a random-target draw built from existing parts: a seat pointer and RNG.
- **Mutant.** "Play the top card of the draw pile as if you'd played it." It can share the flip-onto-the-discard-pile step with Uno Mariokart's Wild Item Box (`gameversions.md` row #21), but the two differ in what resolves: the Item Box *ignores* the flipped card's own action and applies an item instead, while Mutant applies the flipped card's action.
- **A penalty for false UNO challenges.** A wrong UNO challenge costs the challenger 2 cards. This is a sub-option for D7 (UNO calls), to stop the AI or players from challenging at random.
- **Skill as one error rate**, used for missing real cheats, false challenges and illegal Wild Draw Four plays. It's a compact model for the plan's per-difficulty settings.
