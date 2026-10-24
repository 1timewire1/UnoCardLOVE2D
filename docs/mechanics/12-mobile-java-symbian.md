# Mobile UNO (J2ME and Symbian): decompiled findings

> Reference spec for `docs/gameversions.md`. It covers rows #114/#241, #242, #243 and #240, Part E3, and one title our list doesn't have.
>
> **Sources.** Seven files the user supplied: six J2ME `.jar` files and one Symbian `.sis` (andrew-lviv.net repacks).
>
> **How each was read:**
> - Each file was copied into its own folder and only read, never run.
> - Java bytecode was decompiled with **Vineflower 1.10.1**. That jar was already on disk, and its SHA-1 matched Maven Central's published checksum.
> - Gameloft's text packs are LZMA-compressed ("alone" format) with a table of string end-offsets in front. They were unpacked with Python's `lzma` module.
> - The Symbian `.sis` (SIS v2) was split into its zlib-compressed blocks. File names were matched to blocks using the package's own index (its "controller").

Confidence:
- **HIGH (text)**: the game's own English strings.
- **HIGH (code)**: read from the decompiled code.
- **MED**: inferred.

| File | Title / build | Our ref |
|---|---|---|
| `UNO [640x480] (Nokia E6-00)` | Gameloft **UNO**, `GloftUNOG` v1.0.9, © 2011 | #114/#241 |
| `UNO [320x480] (Samsung GT-S5380K)` | the same game, v1.0.0, © 2010 Mattel | #114/#241 |
| `UNO HD [360x640] (Symbian^3)` | Gameloft **UNO HD**, native Symbian, UID `20035E07` | #114/#241 (the HD build) |
| `UNO Spin [480x800]` | Gameloft **UNO Spin**, `GloftUNO2` v1.1.4 | #242 |
| `UNO and Friends [480x800]` | Gameloft **UNO & Friends**, `GloftUNO3` v1.2.0, © 2012 | #243 |
| `UNO Free Fall [240x320]` | Player X **Uno FreeFall** v1.0.0 | #240 |
| `UNO 2 in 1 [240x320]` | Player X **Uno2in1**: FreeFall plus **"Uno Challenge"** by Oasys Mobile, © 2006 Mattel | **not in our list** |

A caveat on dates: the two Gameloft UNO JARs are 2010–2011 builds, not the 2009 original. The rules text is the same in both, and the same as in UNO HD.

---

## 1. Gameloft UNO (#114/#241) and UNO HD: confirmed and completed

**Custom Game: 8 settings** (HIGH, text: the "CUSTOM RULES" help and the option labels). Our doc says "9 toggleable rules, only 7-0 and Jump-in named". Here are all of them:

| Setting | Options |
|---|---|
| Game Mode | **Standard** (vs 3 opponents) · **Duel** (1 opponent, two-player rules) · **Challenge UNO** (each player's leftover hand value is added to a running total, and anyone who reaches the limit is out; last player standing wins). UNO HD drops Challenge UNO. |
| Penalties | **Standard** (you must take the Draw) · **Cumulate**: answer a Draw Two with a Draw Two, or a Wild Draw Four with a Wild Draw Four, and **the next player gets double the penalty**. It keeps passing while players match. |
| Draw Type | **Draw and Play** (you may play the drawn card) · **Draw One** (draw, then your turn ends) |
| Force Play | **On**: if your only playable cards are Wilds, you must play one · **Off**: play it or draw |
| UNO 7-0 | 0 = everyone passes their hand to the next player; 7 = swap hands with a player you choose |
| Jump-In | Play an identical card (same number and color) out of turn, and play continues from you. **If you jump in with a Draw Two or Wild Draw Four, it *cancels* the first card's effect.** |
| Difficulty | Easy / Normal / Hard ("the CPU will be more aggressive and tactical") |
| Final score | 250 / 500 / 1,000 / 2,000 / 3,000. It's the target in Standard and Duel, and the knockout limit in Challenge UNO. |

The "9" in our doc probably also counted the 1P–4P seat setup (Player / CPU / Off per seat). That seat setup exists in the text (MED).

**Other confirmed rules:**
- **Wild Draw Four challenge:** if the challenge is right, the player who played it draws 4; if it's wrong, the challenger draws **6**.
- **Missed UNO:** whoever forgets to call UNO draws 2, but only if they're caught before the next player plays.
- **Duel:** "Playing a Reverse card acts like a Skip. You may play a Skip/Reverse, then immediately play another card."

**Tournament: 15 rounds, each best-of-5 matches.** This confirms our doc and adds the actual table. The overall target is 5,000 points.

| Rounds | Players | Rules |
|---|---|---|
| 1–2 | 2 | Basic |
| 3–4 | 3 | Basic |
| 5 | 3 | Penalties (Cumulate) |
| 6 | 3 | 7-0 |
| 7 | 3 | Jump-In |
| 8 | 4 | Basic |
| 9 | 4 | Penalties |
| 10 | 4 | 7-0 |
| 11 | 4 | Jump-In |
| 12 | 4 | Penalties + 7-0 |
| 13 | 4 | 7-0 + Jump-In |
| 14 | 4 | Penalties + Jump-In |
| 15 | 4 | all three ("Final confrontation") |

**Rewards** are cosmetic: trophies, backgrounds, icons, and puzzle tiles that fill "reward tables" to unlock icons. That matches our "cosmetic/meta only" note.

**There's a cheat code** ("CHEATER!! YOU UNLOCKED EVERYTHING!" / "NOW YOU CAN'T LOSE!").

## 2. UNO Spin (#242): the wheel is the physical one, and the rules menu is bigger

**Spin cards** (HIGH, text): "When a Spin Card is played, the **next** player must spin the wheel." Spin cards score their face value.

**The deck is 108 cards with 20 Spin cards**, the same as the physical J3719 deck (HIGH, code). The user supplied 15 more device builds, and all 16 were decompiled; the deck-building routine produces the same deck in every one.

| Part of the deck | Count |
|---|---|
| Wild | 4 |
| Wild Draw Four | 4 |
| 0, per color | 1 |
| plain 1–5, per color | 1 of each |
| **Spin 1–5, per color** | **1 of each** (each replaces one copy of that number) |
| 6–9, per color | 2 of each |
| Draw Two, Reverse, Skip, per color | 2 of each |

- That's 25 cards per color.
- Spin cards are scored as their number, 1–5 (in the lite builds, by the `(value − 9)` branch of the scoring code).
- The two code lines number the cards differently: Spin cards are 10–14 in the lite builds and 15–19 in the full builds.

**The 16 builds are three versions of the game:**

| Family | Builds | Text strings | What's different |
|---|---|---|---|
| Lite, v1.0.2–1.0.4 | X2-00, GT-S3353, N80 | 546 | **9 cups**. Each cup's objective is "highest score in N matches", "top score in every match" or "win N in a row", with N from 3 to 5. Game Mode is only Standard / Duel. The settings are Penalties, Draw (Draw and Play / Draw One), Force Play and Jump-In. **No Team, no Elimination, no Challenge toggle, no Draw Until Play, no shop.** |
| Full, v1.0.5–1.1.1 | Asha 311, GT505, KP500, KU990, S5230, SGH-i900, Aino, C3-00, E71/E72, N5800/N97/X6, Satio, Vivaz | 744 | Everything described below. **Elimination strikes are adjustable (3, 4 or 5).** The tournament is **12 cups**: Study, Discovery and Advance, then **Bonus Cup 1** (Team, to 500); Conqueror, Challenger and Evolution, then **Bonus Cup 2** (Elimination, 5 strikes); Master, Elite and Legend, then **Bonus Cup 3** (Challenge UNO, out at 500). There's also a credits shop with avatars. |
| Touch, v1.1.4 | S8000 | 707 | Same features as Full, with touch-screen wording. It's the only build whose text is LZMA-compressed; the others store it uncompressed behind a flag byte. |

**The wheel has the 9 outcomes of the physical game** (our doc 03, sheet J3719):

| Outcome | Effect |
|---|---|
| Almost UNO | discard all but 2 cards |
| Discard Number | discard all cards of a number you choose (you may keep some) |
| Discard Color | discard all cards of a color you choose (you may keep some) |
| Draw Red | draw until you get a red card or a Wild, keeping everything drawn |
| Draw Blue | draw until you get a blue card or a Wild, keeping everything drawn |
| Trade Hands | everyone passes their hand to the left; anyone left holding 1 card must call UNO |
| Show Hand | show your hand to everyone |
| War | everyone reveals their highest number, the highest may discard it, and ties go to the next-highest card |
| UNO Spin | everyone races to touch the letters in order, and the winner discards one card of their choice |

**Custom rules** (HIGH, text). These add to the UNO list in section 1:

| Setting | Options |
|---|---|
| Game Mode | Standard · Duel · **Team** (2v2; when you or your partner wins, you both score) · **Elimination** (you get a strike whenever you have no playable card; it's out at **3, 4 or 5 strikes**, your choice; the Bonus Cup uses 5) · Challenge UNO |
| Penalties | Standard · Cumulative (as in section 1) |
| Draw Type | Draw and Play · Draw Only · **Draw Until Play** |
| Force Play | On / Off |
| **Challenge** | **On**: illegal Wild Draw Fours and missed UNO calls can be challenged · **Off**: an illegal Wild Draw Four **can't be played at all**, and there are no UNO challenges |
| Jump-In | as in section 1, where an action card cancels the first card's effect |
| Difficulty / Final score | as in section 1 |

**Tournament** (full builds): 12 cups, as listed in the build table above. The lite builds have 9 cups and no bonus modes.

## 3. UNO & Friends (#243): confirmed, plus powers and mini-games

All HIGH (text).

**World Tour:**
- **6 venues:** Brazil, USA, France, Hong Kong, Russia and Germany.
- **5 stages per venue**, 1–3 stars per stage, **90 stars** in total.
- **Venues** also cost stars to unlock, or tokens to skip ahead.
- **Bosses**, one per venue, fought in duels: the Captain, the Mentor, the Magician, the Gambler, the Pop Star and the Aristocrat.
- **Career games deal 5 cards** instead of 7.
- **The tutorial** is "8 out of 12 cards".

**Stage types:**

| Stage | What it is |
|---|---|
| Standard Game | classic UNO |
| Duel | 1-on-1; a Reverse acts as a Skip; bosses use powers |
| UNO Partner | 2v2; you win if you or your partner wins |
| **Drop-Out** | 3 rounds, and the lowest-ranked player is eliminated after each one |
| Jump-In / Best of 3 Jump-In | the Jump-In rule |
| UNO Recall | memory mini-game: flip pairs with the same color and number |
| UNO Path | mini-game: draw a path through neighbouring cards that match by color or number, diagonals allowed, against the clock |
| UNO Stacking | solitaire mini-game: play cards from the stacks onto your active card, chaining streaks, until the draw pile runs out. **Not** the stacking house rule. |

**Powers.** These exist only in Career mode. You buy one after beating that venue's boss. An equipped power lasts **5 games**. It **charges every time a card is played** and fires on its own when full.

| Power | Effect |
|---|---|
| Freeze | about half your opponents' cards are frozen for 2 turns |
| Flurry | all opponents draw 2 |
| Transform | each opponent has up to one special card turned into a number card |
| Safeguard | protection from draw cards for 2 turns |
| Sabotage | the opponent with the fewest cards draws 4 (random if tied) |

**Rules our doc doesn't have:**
- **Drawing is optional:** you may draw even if you hold a playable card.
- **20-card limit:** if you hold **20 or more cards** and at least one is playable, **you can't draw**.
- **Ranking:** when the round ends, the losers are ranked by the value of the cards they hold, lowest first.

**Other systems:**
- **Hotseat:** up to 4 players on one device, at least 2 of them human, with no scoring.
- **Quick Play:** scored by your longest play streak and your finishing position.
- **Tokens:** spent on stage fees and the shop, and won from a daily scratch card.
- **UNO Spin Challenge:** a string exists for it, apparently the wheel's race event reused (MED).

## 4. Player X / Oasys titles

- **UNO Free Fall (#240):** confirms the DIFFERENT-GAME tag. It's a falling-block puzzle.
  - You clear matching groups.
  - Special blocks link to all their neighbours, flip the board, or shuffle the blocks.
  - A gold block forms when a group is enclosed, and clearing one clears every group.
- **"Uno Challenge" (inside UNO 2 in 1): new to our list.**
  - By Oasys Mobile on Summus's platform, © 2006 Mattel.
  - Standard UNO with pass-and-play against human or computer seats (Robbie, Jack, Helen), a choice of win target, and a defunct online lobby with a leaderboard.
  - Rules are standard: 7 cards; a missed UNO costs 2 if challenged; the Wild Draw Four may be played only with no matching color; scoring is face value / 20 / 50.
  - Its "UnoPenalties" art is only the penalty pop-up, not a rules variant (MED).
  - Verdict: a plain port with no mechanics for us. Worth a Part D row for completeness.

## 5. What's worth taking

Each item is mapped to `docs/implementation-plan.md`.

- **"Cumulate" (doubling) stacking:** a matching Draw Two or Wild Draw Four passes on **double** the penalty, rather than adding to a running total.
  - It's another stacking model for Phase 3, alongside sameType and progressive.
  - Gameloft used the same model in UNO, UNO Spin and UNO HD.
- **Jump-In where an action card cancels:** jumping in with an identical Draw card *replaces* the first card's effect instead of adding to it.
  - This is already the plan's default (D2, the official rule from sheet 41940); Gameloft's text is a second confirmation.
  - Its interaction with stacking is settled in the plan's toggle-pair table.
- **A "Challenge" off switch** that also *enforces* the Wild Draw Four restriction (Spin's Off setting). That's a cleaner version of the plan's No Bluffing: no challenge, but no illegal play either.
- **"Draw Until Play"** as a third draw type (Spin), alongside Draw and Play and Draw One.
- **Modes:**
  - **Elimination by strikes** (Spin: a strike for having no playable card; out at 3, 4 or 5 strikes).
  - **Drop-Out** (Friends: the lowest-ranked player is eliminated each round, over 3 rounds).
  - **Challenge UNO** (the leftover-points knockout).

  All three are cheap Phase 6 elimination variants.
- **Friends' 20-card draw block:** at 20+ cards you can't draw if you can play. A neat counterweight to huge hands, and a companion to the plan's hand-cap setting (D5).
- **The tournament ladder** (section 1) as a ready-made campaign template: player count and rule set escalate together.
