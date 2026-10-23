# UNO Undercover (#235): decompiled verification and cut Command Cards

> Reference spec for `docs/gameversions.md` (see its Part E4, row #235 and Part B row #497). Unlike the earlier pass, which relied on secondary sources (MobyGames, RealArcadeapedia, Giant Bomb), this pass read the shipped game's own files. It used the Alawar/Real PC release (readme: "Copyright (C) 2008 Alawar Entertainment … (C) 2008 Real"; credits: Golden Goose Productions). `App.swf` was decompiled with JPEXS FFDec 2x (`ffdec-cli -export script`), and the plain XML data files were read directly.

Method and confidence:
- **HIGH (code)**: read from the decompiled ActionScript 3 in `App.swf`. The class paths below are packages inside that SWF.
- **HIGH (data)**: read from the game's shipped XML (`scripts/items.xml`, `scripts/missions/*.xml`, `l10n/en-US/*.xml`).
- **MED**: inferred from leftover assets or naming.

Source notes:
- The local install has a hand-edited `App.swf` and `scripts/items.xml` (2026-02-01), made to unlock the hidden cheat menu. The untouched 2008 originals sit next to them as `App - Copy.swf` and `items - Copy - Copy.xml`. **Everything below was read from the 2008 originals.**
- The `App.swf` edit changes a single line: `PausePopup` opens `CheatEntryPopup` instead of `HelpPopup`.
- The `items.xml` edit uncomments a `vouchers_wild` item, which was commented out in the shipped data.

---

## 1. Headline: "Command Cards" is the shipped name

The earlier pass concluded that the shipped game calls these cards "power-up cards" and **never** "command cards". That is wrong. "Command Card" is the game's own name for them, in code, data, UI and story text:
- **Code:** classes `com.ggg.uno.CommandCard`, `CommandCardPopup` and `com.ggg.app.CommandCardView`.
- **Data:** every special card in `items.xml` is `<type>commandcard</type>` with `<title>Command Card</title>`.
- **UI:** the help screen has a `COMMAND CARDS` page (`swfs/help_command_cards.swf`), and the UI string `COMMAND_CARDS` reads "COMMAND CARDS".
- **Story:** mission dialogue says it too, e.g. mission 8: pirate monkeys "plundering cruise ships for command cards".

"Power-up cards" is retail and press wording only. So #497 ("Cut command cards from Uno Undercover") is not an unknown prototype name. It refers to this exact card system, and the game files really do contain cut members of it (section 3).

## 2. The card set: 15 defined, 13 obtainable, not 9

`items.xml` defines **15** Command Cards, `c_1` to `c_15`. `CommandCard.as` force-links a popup class for each one. In the table:
- "Paired" means the card is played with a second card, number or not, which sets its count.
- The Pts column gives the points printed in the in-game help (`HELP_COMMAND_TITLE_Cn`).
- "Earned in" is the mission whose script awards the card via `<event type="getItem">`. All of those award lines are live, not commented out.

| id | Name | Color | Paired? | Help pts | Earned in | Status |
|---|---|---|---|---|---|---|
| c_1 | Redecorate | Wild | no | 70 | mission 10 | shipped |
| c_2 | **Plunder** | Yellow | – | – | **never** | **cut**: popup commented out, stub code |
| c_3 | Clone | Blue | no | 30 | mission 9 | shipped |
| c_4 | **Personal Shield** | Blue | yes | – | **never** | **cut**: merged into Croc Tooth |
| c_5 | Lucky Croc Tooth | Yellow | yes | 40 | mission 6 | shipped |
| c_6 | Shooting Star | Red | no | 50 | mission 8 | shipped (missing from our docs) |
| c_7 | Toe Hold | Blue | yes | 40 | mission 7 | shipped |
| c_8 | Double Cross | Wild | no | 50 | mission 12 | shipped |
| c_9 | Highland Two-Step | Green | no | 60 | mission 5 | shipped |
| c_10 | Sleep | Green | yes | 20 | mission 4 | shipped |
| c_11 | Tsunami | Blue | yes | 50 | mission 11 | shipped |
| c_12 | Switcheroo | Yellow | no | 30 | mission 13 | shipped |
| c_13 | Reverse Skip | Yellow | no | 40 | mission 1 | shipped (missing from our docs) |
| c_14 | Reverse Draw-Two | Red | no | 40 | mission 2 | shipped (missing from our docs) |
| c_15 | Skip Draw-Two | Green | no | 40 | mission 3 | shipped (missing from our docs) |

So the game has **13** obtainable cards, not 9. The secondary sources missed four:
- **Shooting Star**
- the three combo action cards: **Reverse Skip**, **Reverse Draw-Two** and **Skip Draw-Two**

### How Command Cards enter a game (HIGH, code: `GameController.newGame`)

- **Only cards you own:** the pool is the human's *owned* Command Cards (`InventoryManager.getItemsOfType("commandcard")`). They are not a fixed set "shuffled into play in both modes". A new profile has none, and Quick Play uses whatever the profile has unlocked in Adventure.
- **No swap cards in 2-player games:** Switcheroo (`c_12`) and Highland Two-Step (`c_9`) are excluded when there are only 2 players.
- **At most 7 per game:** if the pool holds more than 7, cards are removed at random until 7 are left (`while (_ccards.length > 7)`).
- **One copy each:** `CCARD_REPEAT = 1`. Each card is cloned once into the 108-card deck.
- **Human only:** the AI never holds Command Cards. Each one is bound to the human (`c.player = _ph`), and `CommandCard.canDealTo` returns `pl == _player`. `DrawPile.dealOne` skips past them when dealing to an AI.
- **Score 0, despite the help text:** a Command Card never calls `setValue`, so its score stays at the default 0. The help screen prints 20–70 points, but hands are actually scored at 0. This only matters in Standard mode.
- **How they match:** wild-colored Command Cards (`Color.NONE`) can be played on anything and open the color picker. Colored ones play on their own color, or on a wild of that color. Their "value" is their art path, so in practice they never match by symbol.

### Actual effects vs. our docs

Each card has three sources:
- the **card text**: the `items.xml` `<description>`, or the in-game help, which is near-identical;
- the **pop-up text**: the short `Cn_DESCRIPTION` string shown when the card is played;
- the **code**: the `com.ggg.uno.cards.*Popup` class.

Where they disagree, the code is what the game does.

- **Redecorate** (wild).
  - Code: you pick a color, then every non-wild, non-Command card **in the player's own hand** becomes that color (`RedecoratePopup.cb1`).
  - Card and pop-up text agree ("Change all your cards to the selected color").
  - **Doc is wrong:** it says the card recolors "the discard pile *and* every card in the deck".
- **Clone** (blue).
  - Code: pick one card in your hand, Command Cards included. The game adds **a duplicate of it** to your hand (`ClonePopup.cb2/cb4`).
  - The pop-up text says the same: "Create a copy of any card."
  - The card text says "convert any card … to match any other card", which is *not* what the code does.
  - **Doc is wrong:** "mimics/assumes the effect of any other card in the deck".
- **Lucky Croc Tooth** (yellow, paired).
  - Code: the paired card goes **under** the top discard. Its number (a non-number counts as 1) sets how many turns `HumanPlayer.enableTooth` stays on.
  - While it is on, any Draw Two or Wild Draw Four aimed at you is **redirected to the player who played it** (`draw2Next` / `wild4Next`: `victim = _lastPlayer`).
  - The pop-up text says the same: "Reverse the effects of Draw cards!"
  - The card text only says "protected from any Draw card".
  - **Doc is partly right:** the duration is correct, but the card *bounces* the penalty rather than just blocking it.
- **Shooting Star** (red).
  - Code: play up to **4 cards of one color** at once. The first card picked sets the color (`ShootingStarPopup`).
  - The chosen cards are moved straight onto the discard pile, bypassing the normal play logic, so **none of their actions fire** (a Skip, Draw Two or Wild Draw Four placed this way does nothing). The only lasting effect is that the active color becomes the color of the last card placed.
  - There is no matching check (the first card may be any color) and no stopping early (you keep placing until 4 cards or none of that color are left). See section 7.
  - **Not in our docs.**
- **Toe Hold** (blue, paired).
  - Code: the paired card sets N turns (a non-number counts as 1). You pick one opponent, and the game locks 3 random cards in their hand for N of their turns. It calls `AIPlayer.startToeHold` 3 times, and duplicate picks are possible, hence "up to three".
  - The help text matches the code. The `items.xml` text is out of date ("for a whole turn").
  - **Doc is roughly right:** "hold 3 random cards for several turns, duration tied to a paired card's number".
- **Double Cross** (wild).
  - Code: you pick a color, then choose 1–2 cards **from your own hand** to recolor to it (`DoubleCrossPopup`).
  - **Doc is wrong:** "changes the pile's color and two other cards in the deck".
- **Highland Two-Step** (green).
  - Code: pick two opponents, who swap whole hands.
  - **Doc is correct.**
- **Sleep** (green, paired).
  - Code: pick one opponent, who loses N turns (`AIPlayer.sleep`).
  - **Doc is correct.**
- **Tsunami** (blue, paired).
  - Code: pick one opponent, who then **takes N random cards out of the other players' hands**, not from the draw pile (`TsunamiPopup.playerSelected`).
  - It skips Command Cards, and skips any player holding exactly 1 card. It stops early if nothing is left to take.
  - **Doc is inaccurate:** "forces a selected opponent to draw cards".
- **Switcheroo** (yellow).
  - Code: swaps two opponents' **seats**, which changes turn order.
  - **Doc is correct.**
- **Reverse Skip** (yellow).
  - Code: reverses direction, then skips the next player in the new direction.
  - With 2 players, it gives the player who played it an extra turn.
- **Reverse Draw-Two** (red).
  - Code: reverses direction. The next player in the new direction draws 2 and loses their turn.
- **Skip Draw-Two** (green).
  - Code: the next player is skipped, and the player **after** them draws 2 and loses their turn. That punishes two players.
- **Paired-card edge case:** a paired **0** gives 0 turns, so Sleep, Toe Hold and Croc Tooth each expire on the target's very next activation, which means they do nothing.
- **When effects end:** every timed status (Sleep, Toe Hold, Croc Tooth) is cleared at round end.

Paired-play count: our docs single out Sleep and Tsunami as the "two-card combo" cards. Four shipped cards use the pairing step: **Croc Tooth, Toe Hold, Sleep and Tsunami**. Cut Personal Shield also used it.
- The pairing is not two cards played together from your hand. You play the Command Card first, and a pop-up then asks you to drop a second card from your hand into a slot.
- That second card is usually tucked under the discard pile (Croc Tooth, Toe Hold, Sleep, Tsunami).

## 3. Cut Command Card remnants (#497)

All findings are HIGH unless marked otherwise.

### Plunder (`c_2`)
- **Data:** the item is fully defined. Its text: "ARRR! A dirty pirate card. The person playing this card may select ANY card from their hand to remove from the game and immediately add the point value of that card to their score."
- **Card art:** it has finished art, a yellow card with a treasure chest (`images/cards/c_2.swf`).
- **Disabled in data:** its `<popup>PlunderPopup</popup>` line is commented out, so even if you own it, playing it does nothing.
- **Never awarded:** no mission awards it, and it has no help entry, no `C2_*` UI strings and no sound.
- **Code is a stub:** `com.ggg.uno.cards.PlunderPopup` still ships.
  - It loads `swfs/CC_plunderFX.swf`, `swfs/fx_plunder_intro.swf` and `swfs/fx_plunder_end.swf`. **None of these files exist.**
  - It asks you to pick **one opponent**, plays the outro, and does nothing else.
  - The target-an-opponent flow does not match the "remove your own card, bank its points" text. That suggests the design was still changing when the card was cut.
- **Likely placement (MED):** mission 8 is the "Monkey Pirates" cruise level, whose dialogue has pirates "plundering cruise ships for command cards". Mission 8 now awards Shooting Star instead, so Plunder was probably meant as that mission's reward.
- **Cheat-menu access:** the `getitem c_2` cheat (see "Other cut or dormant features" below) adds it to the inventory, but it stays inert because its popup is commented out.

### Personal Shield (`c_4`)
- **Data:** the item is fully defined. Its text: "Play this card along with any number card. Any time the person playing this card is targeted by another player to draw additional cards the cards will BOUNCE back, forcing the other player to draw them instead. This effect will persist for a number of turns equal to the number card played."
- **Card art:** it has finished art, a blue card with a heraldic shield (`c_4.swf`). Its `<popup>` is still active.
- **Never awarded:** no mission awards it, and it has no help entry or sound.
- **Code:** `PersonalShieldPopup` exists.
  - It loads `fx_personalshield_intro.swf` and `fx_personalshield_loop.swf`, **which do not exist**.
  - It borrows Two-Step's `C9_TITLE` / `C9_DESCRIPTION` strings (a copy-paste leftover).
  - It calls the same `HumanPlayer.enableTooth(n)` that Croc Tooth uses. It even forgets to discard the paired card.
- **What happened to it:** it was **folded into Lucky Croc Tooth**, which shipped with Personal Shield's *bounce-back* behavior.
  - The proof is in Croc Tooth's own implementation, which still uses the shield names: `HumanPlayer._shield` and `shield_cb`.
  - Croc Tooth's pop-up text also promises the bounce ("Reverse the effects of Draw cards!").

### First-draft combo cards: two-color art
- `images/cards/c_13.swf`, `c_14.swf` and `c_15.swf` are earlier art for the three combo cards. That art is still in the game but is never referenced, because `items.xml` points the combo cards at differently named files.
- Each early card is split between **two colors**:
  - Reverse/Skip in **blue/red**
  - Reverse/Draw-Two in **yellow/green**
  - Draw-Two/Skip in **red/yellow**
- That suggests a cut idea in which a combo card could be played on either of two colors. The shipped versions are single-color, and their art files are dated 10 days later (2008-06-14 vs 2008-06-04):
  - `c_reverse_skip_yellow`
  - `c_reverse_draw2_red`
  - `c_skip_draw2_green`
- There is also an unused **blue** Skip Draw-Two (`c_skip_draw2_blue.swf`). It is a leftover color variant.

### Deck Customization screen
- **The code still ships:** `com.ggg.app.DeckCustomization` and `CommandCardView` are both still in the game.
- **What it was for:** it was a pre-game screen where you dragged Command Cards from your collection into a **3-slot** loadout (`new SelectedCardView(3)`), which was then passed to `GameController.setCommandCards`.
- **Why it can't be reached:**
  - Nothing navigates to it. Its `deck_custom.xml` only routes *onward* to `pregame_info`.
  - Its background points to `deck_customization.swf`, which doesn't exist; the shipped file is `deck_custom.swf`.
  - `newGame()` overwrites `_ccards` anyway, using the "all owned, cap 7, random" rule.
- **Off-by-one in its loop:** `for (i = 1; i < 15; i++)` lists only `c_1` to `c_14`, so Skip Draw-Two could never be picked there.
- **Takeaway:** an earlier design had the player pick **3** Command Cards per match. The shipped game instead seeds up to **7** owned cards at random.

### Other cut or dormant features found along the way
- **Penalty modes.** The UI strings define three:
  - "Standard Penalties: Effect cards automatically affect the next player"
  - "**Pass Penalties**: Effect cards of the same type may be played to pass penalties on to the next player"
  - "**Amplified Penalties**: Play an effect card of the same type to pass BOTH effects to the next player!"
  - There is also a `penaltyBtn` tooltip ("Adjust Penalty rules"). But the options screen only builds Game Type and UNO-call buttons, and `GameController` sets `spec.penalty = "Standard"` without ever reading it.
  - So stacking ("Pass") and progressive stacking ("Amplified") were planned and cut. This is a direct match for this project's stacking house rules (file 01).
- **Elimination game type.** `RuleArbiter.elimination` and `GameController.roundOverHandler` implement it in full: after each round, the player with the highest score is removed (if that is the human, the game ends), and play continues until 2 remain. It has no UI string, it is not in `GameOptionsScreen.GAME_TYPES` (which offers only Single and Standard), and no mission uses it.
- **Wild Vouchers** (`vouchers_wild`) are commented out in the shipped `items.xml`.
- **Cheat console.** `CheatEntryPopup` accepts these commands, with no in-game way to open it in the shipped build:
  - `mission N`: jump to mission N
  - `win` / `lose`: end the current game
  - `getitem <id>`: add an item to the inventory
  - `debug`: lets the human play any card (`RuleArbiter.isValidPlay`)

## 4. Verifying the remaining E4 claims

| Claim in `gameversions.md` | Verdict | Evidence |
|---|---|---|
| Dev. Golden Goose Productions | **Confirmed** | `HELP_CREDITS_TEXT` |
| PC (Windows), 2008 | **Confirmed**, but "PC only" is slightly off: a Mac build also exists (MED) | Win32 Zinc/MDM wrapper (`mdm.*` classes, `uwta.zinc`); `App.swf` original dated 2008-07-03; the readme says ©2008. Softpedia lists a Mac OS X 10.4+ build, v3.6, dated 2008-12-22. |
| Distributed by RealNetworks/RealArcade | **Confirmed**; this local copy is the Alawar + Real release | readme; RealNetworks press release dated 2008-07-23: available "at RealArcade.com and GameHouse.com", with North American retail "later this Fall" |
| BREW/J2ME/Windows Mobile ports | **No evidence found** (LOW: not disproven) | The press release mentions only "downloadable PC and online game play", and Giant Bomb lists PC only. Web searches turned up only unrelated UNO phone games (Gameloft's UNO, Concrete Software's Windows Mobile UNO). The ports claim was probably mixed up with those. MobyGames blocked automated access, so its platform list was not checked. |
| No DS version | Not checkable from the PC build | – |
| Standard 108-card deck | **Confirmed, with caveats** | `FullDeck`: 4 colors × (one 0, two each of 1–9, two each of Skip, Reverse, Draw Two), plus 4 Wild and 4 Wild Draw Four. The difficulty "easing" setting adds `(easing − 50) / 10` extra **Wild** cards, rounded up by the loop, so +5 Wilds at mission 1's easing of 95. Command Cards are added on top. |
| "9 power-up cards, shuffled into play in both modes" | **Wrong** | 13 obtainable (15 defined), called Command Cards. Each player's set is their unlocked cards, capped at 7 per game, one copy each, human-only (see section 2) |
| Individual card effects | **Mixed** | Redecorate, Clone, Double Cross and Tsunami are wrong; Croc Tooth is incomplete (see section 2) |
| Felicia Blue vs. Madame Zero spy plot | **Confirmed** | mission dialogue, `H_PROF_MADAME_*` |
| Quick Play: same ruleset, no story | **Confirmed, with detail** | `main_menu.xml`: 5 players (Felicia + McHaggis, Houston, Louie and Dundee), default **Single** mode, easing 50, game type and UNO-call toggles |
| No mission-specific rule changes; venues just mean different AI | **Mostly right, needs nuance** | see below |

Detail on the last row:
- **AI logic is the same for every character.** `AIPlayer.doPlay` picks a random playable card and a random wild color, and calls UNO 50% of the time. "Personality" is only dialogue, emotes and scripted table-talk.
- **What varies per game is the spec:**
  - **player count**, from 2 to 6
  - **game type**: every campaign game is Single except one, mission 6's opera tournament, which is Standard
  - **easing**: a hidden **AI handicap**. It ramps 95 → 90 → 85 … → 50 across missions 1–4, then stays at 50.
  - **scripted `forcelose` opponents**: the mission 1 mansion game and the mission 8 monkey game
  - **tutorial** rules (mission 1)
- **What easing does** (a percent chance, rolled each time):
  - The AI refuses to play its **last** card.
  - The AI avoids Skip, Draw Two and Wild Draw Four when the human is next.
  - A Wild is held back from being dealt to the AI.
  - It also adds the extra Wilds mentioned in the deck row.

## 5. Base rules as coded (for reference)

- **Dealing:**
  - 7 cards each.
  - The starting discard is redrawn while it is any wild (Wild or Wild Draw Four).
  - An action card as the first discard has **no** effect, even though the help text describes the official start-card rules.
  - The human always goes first.
- **Matching:** play on color or value; Wilds always.
- **Wild Draw Four:** it can be played at any time, and there is **no challenge** rule.
- **No stacking:** the cut penalty modes in section 3 would have added it.
- **Draw Two / Wild Draw Four:** the victim draws 2 / 4 and loses their turn.
- **Reverse with 2 players:** it acts as a Skip.
- **Drawing on your turn:**
  - Draw exactly 1 card. You may play **only that card**, otherwise you pass.
  - You can't pass without drawing.
  - If the drawn card can't be played, the game passes for you automatically.
- **UNO calls:**
  - **Manual** mode: you must click UNO, or you can be caught.
  - **Automatic** mode: the game calls it for you.
  - Getting caught costs **2** cards (`unoChallenged`).
- **Scoring and modes:**
  - **Single** (the default): the first player out wins.
  - **Standard**: play to **300** points (not 500). The round winner scores the other players' remaining cards: number cards at face value, action cards 20, Wilds 50, Command Cards 0.
- **Idle prompt:** after 15 s idle, the human gets a table-talk nudge (`PLAYER_IDLE_15`). It is not a turn timeout.

## 6. Worth incorporating

Each item is mapped to `docs/implementation-plan.md`. They are ordered by how much they would add beyond what the plan already covers.

1. **Status effects that last a set number of turns.**
   - Undercover gives one player a standing effect with a turn count:
     - Sleep: skip N turns.
     - Toe Hold: N of the target's turns with 3 cards locked.
     - Croc Tooth: N turns of reflecting draw penalties.
   - The count goes down each time the affected player's turn starts (`PlayerEvent.ACTIVATE`), and is shown on their portrait (`setTimer`, `fx_sleep_timer`, `fx_portrait_zzz`, `fx_toehold_loop`).
   - Every effect clears at round end.
   - Phase 7 (reflect) and Phase 8's standing-effect query hook (locks, immunity) cover *what* such effects do, but the plan has no shared way to track *how long* they last. A per-seat status list with a turn count and a round-end clear would serve these cards and any timed card from other decks.
2. **Setting an effect's size with a second card.**
   - After the special card is played, a pop-up asks for one more card from the hand.
   - A number card sets N to its value; any other card counts as 1.
   - That card is used up: it is tucked under the discard (`addCardUnder`).
   - This is a new primitive. It trades a card from your hand for a stronger effect, and a 0 gives no effect.
   - It fits the planned unified "choice" interaction (one more choice type: "pick a card from your hand").
3. **Combo action cards: Reverse Skip, Reverse Draw-Two and Skip Draw-Two.**
   - These are cheap content, because each one just chains existing actions.
   - Turn order follows section 2:
     - Skip Draw-Two skips one player and makes the next one draw 2, so it hits two players.
     - Reverse Skip with 2 players gives the player who played it another turn.
   - The cut two-color art suggests a variant that can be played on either of two colors. It is optional.
4. **Effects that change hands or seats.** All of these use the planned target and card pickers:
   - **Clone:** add a copy of a chosen card in your own hand.
   - **Redecorate:** a wild that recolors every non-wild card in your hand.
   - **Double Cross:** a wild that recolors 1–2 chosen cards in your hand.
   - **Tsunami:** the target takes N random cards out of the other players' hands. It skips special cards and any player holding 1 card, which also means it can't knock someone out.
   - **Switcheroo:** two opponents swap seats.
   - **Highland Two-Step:** two opponents swap hands.

   Undercover leaves the two swap cards out of 2-player games. Keep that, or define what they do with 2 players.
5. **Shooting Star:** play up to 4 cards of one color as one action, with none of their actions firing. C8 (multi-card plays) already covers the chain; see section 7 for the rules this project chose.
6. **AI handicap ("easing").** A single percentage that drives several behaviours:
   - the AI holds its last card;
   - the AI avoids playing Skip, Draw Two or Wild Draw Four into the human;
   - the deck withholds Wilds from the AI and adds extra Wilds.

   The first two are behaviour changes that would make an "Easy" difficulty sit cleanly beside D7's per-difficulty forget/catch chances. Skip the deck changes: they are hidden from the player and would break the guarantee that a seeded game replays identically.
7. **Elimination by score.** After each round, the highest scorer is removed, and play continues until 2 players remain. This is an alternative to the "shrinking table" in Phase 6 and could be a sub-option there.
8. **Collect-and-equip special cards (optional, a meta layer).**
   - Shipped behaviour: up to 7 owned cards are seeded at random, one copy each.
   - The cut Deck Customization screen had you pick a 3-card loadout instead.
   - Either would work as an optional "bonus card pool" setting, rather than tying special cards to a campaign.

Not new: the cut Pass/Amplified penalty modes match Phase 3's planned stacking options (sameType; and progressive stacking, where the penalties add up).

## 7. Rulings on the plan's open questions (U1–U5)

Read from the code, not from play. Where Undercover has no ruling, the project's own decision is marked **our rule**.

| # | Question | What Undercover does | Our rule |
|---|---|---|---|
| U1 | Command Card points | A Command Card never gets a point value, so it scores **0**. The help screen lists 20–70 (Redecorate 70, Two-Step 60, ...). Its values for normal cards (20 actions, 50 wilds) do match the code, so the 0 is most likely an oversight, though that can't be proven. It only matters in the 300-point Standard mode, which the campaign uses once. | Use the help-screen points. |
| U2 | A special card moved into a CPU's hand | Can't happen. Two-Step's picker only lists CPU players, so it always swaps two CPU hands. Tsunami moves cards to a CPU and can take from your hand, but it skips Command Cards. No other card moves cards between players. The CPU's play check doesn't exclude Command Cards, so if one ever got there its pop-up would probably appear on the human's screen. | Yes, the CPU owns it and can play it; "human-only" only controls dealing. A design decision, not taken from Undercover. |
| U3 | Skip Draw-Two with 2 players | The opponent draws 2 and loses their turn, then you play again. With 3+ players it hits two different people; with 2 it hits the opponent once. Reverse Draw-Two runs the same 2-player code and gives the same result. | Same as Undercover. |
| U4 | Shooting Star's actions | **None fire.** The cards go straight to the discard pile; the active color becomes the last card's color. No matching check on the first card, and no stopping early. | Actions don't fire, as in Undercover. **Our rule:** the first card must be a legal play on the discard pile (the rest follow its color), and you may stop after any number from 1 to 4. |
| U5 | Pairing your last card | Allowed. The round ends only once the card's effect finishes, so the effect applies and then you win. The pairing pop-up even shows the UNO button when you're down to 2 cards. If the **special card itself** is your last card, the round ends immediately and its effect never runs. | Same as Undercover for pairing. For a special card played as your last card, the plan's turn pipeline resolves its effect before you go out (see the plan's C21). |

