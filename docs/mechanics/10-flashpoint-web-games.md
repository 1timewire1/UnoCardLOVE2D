# Flashpoint web UNO games: decompiled findings

> Reference spec for `docs/gameversions.md` (it bears on Part D row #377 and Part E4). It covers the four UNO titles archived in BlueMaxima Flashpoint. Each archive was unzipped from the local Flashpoint `Data/Games` folder:
> - Flash SWFs were decompiled with JPEXS FFDec (`ffdec-cli -export script`).
> - HTML5 builds were read directly. That means the Construct 3 `data.json` for Showdown and the minified Impact.js `game.min.js` for Uno (2020).

Method and confidence:
- **HIGH (code)**: read from decompiled ActionScript or the shipped JavaScript or project data.
- **MED**: inferred from code paths that weren't traced end to end, or from asset names.

Only two of the four are Flash. Flashpoint archives HTML5 games as well.

| Title | Flashpoint archive | Tech | Origin (from archived host and code) |
|---|---|---|---|
| ¿Eres Un Experto Jugando A UNO Showdown? | `01cf8470-…` | HTML5, Construct 3 | `mattel-uno-test.melkart.io` |
| Uno^3 | `fb24ef48-…` | Flash (AS3) | `files.crazygames.com/unoonline.swf`; code is King.com (`com.midasplayer`, `king.game.uno`), © 2009 Mattel |
| Uno (2020) | `5e86a342-…` | HTML5, Impact.js 1.23 | `s3.amazonaws.com/mattelgames/Uno`; page title "WOC - UNO" |
| Uno Undercover Demo | `03dd6ecd-…` | Flash (AS3) | `games2.gamefools.com/onlinegames/UNOUndercover` |

---

## 1. ¿Eres Un Experto Jugando A UNO Showdown? (#377): resolved

**What it is.** A Spanish-language, 3-question rules quiz branded UNO Showdown (HIGH, project data).
- It is HTML5, not Flash. The Construct project is named `mattel_uno_test_production`, where "test" is Spanish for "quiz".
- It has four layouts: `inicio` (the start screen) plus `pregunta_1` to `pregunta_3` (the questions).
- Each question shows a card photo and three answer buttons. The answers are baked into sprite images. The answer-to-question mapping below comes from the layout instances.

| Layout | Card shown | Question | Answers (correct in bold) |
|---|---|---|---|
| pregunta_1 | a single green 4 (your last card) | "¡Solo te queda una carta! ¿qué tienes que gritar?" | **¡UNO!** · ¡Última! · ¡Burro! |
| pregunta_2 | Wild Draw Four | "¿Qué tienes que hacer si aparece esta carta?" | **Chupar 4 cartas** (draw 4) · Echar 4 cartas (discard 4) · Esperar 4 turnos para jugar (wait 4 turns) |
| pregunta_3 | Reverse | "¿Qué pasa cuando aparece esta carta?" | **Cambia el sentido del juego** (reverses play) · Cambia el color de la carta (changes the color) · Te levantas y das dos vueltas (stand up and spin twice) |

**Feedback screens.**
- Wrong answers get: "Casi, casi, inténtalo de nuevo…", "Mmm… ¿probamos de nuevo?" and "¿Probamos otra vez?"
- Correct answers get: "¡Yuju, casi estamos!" and "¡Increíble, sigue así!"
- Finishing the quiz shows: "¡Lo has conseguido! No hay quien pueda contigo".

**Verdict:** a promo tie-in with **no Showdown mechanics**. There is no Showdown unit, no duel and no Showdown cards, so it adds nothing to the rules survey. Part D can retag #377 from UNKNOWN to a resolved promo with no unique rule.

## 2. Uno^3 (King.com, 2009)

A 3-seat score-attack game: you against two bots, which are drawn from six named characters ("Señor Ordóñez", "Monsieur Tournesol", "Miss Purpleby" and others). The rules engine is `king.game.uno.Rules`, a state machine. All findings are HIGH (code) unless marked.

**Deck and setup**
- **Deck:** the standard 108 cards, with standard values: number cards at face value, Skip, Reverse and Draw Two at 20, Wild and Wild Draw Four at 50.
- **Choosing who starts:** each player draws 1 card and the **highest number starts** (`getWinningDrawPlayer`). That is the official choose-the-dealer rule.
  - `prepareDrawPileForDecidingCards` rearranges the deck so the three deciding cards are number cards of different ranks, which means a tie can't happen.
- **Hands:** 7 cards each.
- **First discard:** `prepareDrawPileForStartingCard` swaps the first non-wild card to the top, so the game never starts on a Wild.
- **First-card action applies.** The opening Skip, Reverse or Draw Two is resolved through the same code path as a played card. This matches the official start-card rules.

**Matching and play**
- **Matching:** play on color, number or symbol; Wilds can always be played.
- **After drawing:** you may only play the card you just drew (`lastDrawnCard_`). A Pass button ends the turn.
- **Optional draw:** when you hold a playable card, the game offers "play or draw" (`PLAYER_PLAY_OR_DRAW_CARD`).
- **Wild Draw Four restriction, enforced for bots only.** The in-game help states the official rule (play it only when you have no card of the matching color). `getPlayableCards` applies it to bots only:
  - bots drop Wild Draw Four whenever they hold the matching color;
  - bots drop a plain Wild whenever they hold a matching non-wild card.

  The human is never restricted, and there is no challenge.
- **Draw Two / Wild Draw Four:** the victim draws 2 or 4 and is skipped.
- **Going out on a Draw card:** if the last card played is a Draw Two or Wild Draw Four, the next player **still draws** before hands are scored. This is official scoring practice, and many digital versions skip it.

**UNO calls**
- **Calling it:** the UNO button is offered when you are about to go down to 1 card (`PLAYER_SAY_UNO`).
- **Catching a miss:** a missed UNO costs **2 cards** and is reported by another player, after a short delay once the next turn starts.
  - If **you** missed it, a bot reports you after 30 ticks.
  - If a **bot** missed it, you get a 15-tick window to click the bot's UNO button and report it.
- **Do bots ever call UNO?** `BotPlayer` has no handler that sets the "said UNO" flag (MED), so every bot that reaches 1 card can be caught.

**Bot behaviour**
- Bots play the **first** legal card in their hand.
- When playing is optional and they hold more than 3 cards, they decline to play half the time (`randomOptionalPlay_`).

**Match structure and scoring (the score-attack layer)**
- **Time limit:** the whole match has a **160-second clock** (`clock_.setMaxTime(160 * 30)` at 30 ticks per second). The match also ends after 6 rounds (`maxRounds_ = 6`), whichever comes first. The intro text says "three rounds", which disagrees with the code.
  - A `gameMode = 1` build stops after round 1 with "Register to continue playing". That is a guest mode.
- **Round scoring:** the round winner scores the total value of **every** hand.
- **"Extra" points:** each time a bot is forced to draw penalty cards after your play, you score the number of cards drawn (`addScore(…, "extra")`).
- **Time bonus:** at game end you score `round(200 × time left / total time)`.
- **Final score:** the human's total is submitted as the score (`gameEnd`). This was a King leaderboard game.

## 3. Uno (2020): "WOC - UNO", Mattel's HTML5 demo

An Impact.js demo hosted in Mattel's own S3 bucket. All findings are HIGH (code) unless marked.

**Builds and languages**
- The archive holds four entry points, `index.html` to `index4.html`. Each loads its own `game.min*.js` and `data*.json`.
- The four scripts differ **only** in the music paths (`media/sounds`, `media/2017` and `media/2010`) and which data file they load. Build 2 also blanks the rotating background.
- So the rules are identical in all four, and the builds look like a theme A/B test.
- The text is localized into English, Spanish (two variants), Portuguese, French, Italian and German.
- It is a trial: the strings include "Versión de prueba completa" (trial complete) and "Obtener la versión completa" (get the full version), plus a "play other demos" screen.

**Table and deck**
- **Players:** 3 seats (you, `AIPLAYER1` and `AIPLAYER2`).
- **Hands:** **5 cards**, not 7.
- **A non-standard 108-card deck** (`initialiseDeck`):
  - per color, **two** of each of 0–9, Draw Two, Skip and Reverse, which means two 0s;
  - **4 Wilds**;
  - **no Wild Draw Four**.
- **Drawing:** `getRandomCard` removes a random card from the remaining deck. That is equivalent to a shuffled deck.

**Turns**
- **Matching:** color or number/symbol; Wilds always. The CPU picks a random color for its Wilds.
- **8-second turn timer** (`playerTimer = 8`). The timer shakes under 3 seconds, and when it hits 0 the game **auto-draws** for you.
- **Draw Two:** the next player draws 2 and is skipped. Skip and Reverse are standard.
- **Ending:** a **single round**. The first player to empty their hand wins, with no scoring (`checkForGameCompletion`).

**UNO calls**
- **Your call:** if you have an UNO call pending and haven't pressed UNO within **1.5 s** of your turn starting, you draw a penalty card (`checkForPenalty`). The code draws 1 card (MED).
- **CPU calls:** a CPU that drops to 1 card calls UNO only **40%** of the time (`random(10) > 5`). Otherwise an **"UNO Challenge"** button appears so you can catch it, and the CPU then draws the penalty.

## 4. Uno Undercover Demo (GameFools web build)

This is a web build of the retail game; see doc 09 for the retail findings. All findings are HIGH (code).

**What is identical to retail**
- **Rules engine:** `GameController`, `RuleArbiter`, `FullDeck`, `AIPlayer`, `CommandCard` and every `cards/*Popup`. They show no structural difference from retail once the decompiler's naming noise is ignored: the demo was compiled without local variable names, so the comparison used function names, string literals and numeric constants.
- **Command Card definitions** in `items.xml`, including **Plunder's popup already commented out**. So the cut came **before** the demo shipped.
- **The Deck Customization screen** is present and unreachable, as in retail.

**What differs (web adaptations only)**
- web paths instead of Windows paths;
- `NullSerializer` instead of `ZincSerializer`, so nothing is saved;
- new `navigateURL` and `startOver` events, presumably the "buy the full game" link and restart;
- no `CreateProfilePopup`, and no Zinc/MDM desktop wrapper classes.

**Content**
- **Missions:** only missions 1–2, with an **earlier draft** of their scripts. Dialogue and milestone text differ, and some retail hooks are missing.
- **Awards:** they award `c_13` Reverse Skip (mission 1) and `c_14` Reverse Draw-Two (mission 2), as retail does.
- **Where it stops:** mission 2 ends with `beginMission mission3`, which isn't in the build. That's the end of the demo.
- **Leftover dialogue:** the dialogue files for **all 14 missions** still ship, including mission 8's "plundering cruise ships for command cards" line.
- **Characters:** only the characters, locations and swfs needed for California and the intro are included.

## 5. What's worth taking

Each item is mapped to `docs/implementation-plan.md`.

- **Draw for first player** (Uno^3).
  - Each player draws a card and the highest number starts, re-drawing on a tie.
  - It's a cheap, faithful option for who goes first.
  - It also gives a natural place to put the official start-card rules, which Uno^3 applies (an opening Skip, Reverse or Draw Two takes effect).
- **Going out on a Draw card still makes the next player draw before scoring** (Uno^3). This affects point totals in scored games. The plan already has it in Phase 1's match play.
- **Turn timer with auto-draw on timeout** (Uno 2020: 8 s; also Uno Flash #23).
  - The same machinery as D10's timed reaction prompt.
  - A per-turn version could be an optional "speed" setting.
- **UNO-call windows** (all three playable games). The CPU behavior is a fixed value in each: Uno^3's bots never call, Uno (2020)'s call 40% of the time, and Undercover's 50%.

  | Game | If you miss your call | Catching a CPU that missed | Penalty |
  |---|---|---|---|
  | Uno^3 | a bot reports you after 30 ticks (~1 s) | 15-tick (~0.5 s) window to click its UNO button; bots never call | 2 cards |
  | Uno (2020) | auto-penalty if you haven't pressed UNO 1.5 s into your turn | "UNO Challenge" button; CPUs call 40% of the time | 1 card (MED) |
  | Undercover | manual button, or Automatic mode calls for you | AI calls 50% of the time | 2 cards |

  That supports D7's design: per-difficulty forget and catch chances, with a short catch window.
- **Score-attack mode** (Uno^3).
  - A timed match: the round winner scores all hands, you get bonus points per penalty card you inflict, and a time bonus at the end.
  - It's an easy optional mode once scoring exists. It's not in the plan today.

Not worth taking:
- the Showdown quiz, which has no mechanics;
- Uno (2020)'s two-zero, no-Wild-Draw-Four deck, which is a simplification for the demo rather than a variant;
- the Undercover demo, which adds nothing beyond doc 09.
