# Ubisoft UNO (#115 and DLC): decompiled findings

> Reference spec for `docs/gameversions.md`, Part E2. It covers #115 and its DLC: #118–123, #386 and #390, plus themes our docs don't list.
>
> **Source.** The installed Steam build (`D:\SteamLibrary\steamapps\common\Uno`): Unity 2022.2.21f1, compiled with IL2CPP, metadata version 29.
>
> **Tools:**
> - Il2CppDumper v6.7.46 recovered the class, field and enum names.
> - UnityPy 1.25.4 read the asset files.
>
> **Where the rules text comes from.** Almost all of it is the game's own English localization, Ubisoft's "Oasis" XML. It ships as the TextAsset `oasis__global` (UTF-16, 4,077 entries) inside `resources.assets`, with one file per other language.
> - Where several strings describe the same card (theme-picker blurb, hint, tutorial), they agree unless noted.
> - Numbers come from serialized ScriptableObjects where these exist locally. Many tuning values are downloaded at runtime instead (`UplayDynamicGameplayConfig`, `*Config : OnlineData`), so they aren't in the install.

Confidence:
- **HIGH (loc)**: the game's own rules text.
- **HIGH (code)**: an enum or class name from the dump, or a serialized value read from the asset files.
- **MED**: inferred.

---

## 1. Themes and house rules in the code

**Themes** (`Theme_Enum`; each rules theme has its own `BehaviourBaseLogic*` class):

| Theme | Our ref | Rules? |
|---|---|---|
| Classic | #115 | base game |
| Rayman | #120 | yes |
| Rabbids | #118 | yes |
| JustDance | #119 | yes |
| Winter | not listed | **cosmetic only**: deck, board, frame, effect, music |
| Flip | UNO Flip, our Part A | yes, the Flip rules |
| GodMonster | #121 *Fenyx's Quest* (Immortals Fenyx Rising: Gods & Monsters) | yes |
| FiftyAnniversary | not listed | yes: one card, Wild 50/50 |
| FarCry | #122 *The Call of Yara* | yes |
| Valhalla | #123 | yes |
| LiveFeature | not listed | the live-ops wrapper for Wild Weeks and events (section 7) |
| Party | #386 *Party! Mania* | yes |
| NoMercy | #390 | yes |
| Brawlhalla | not listed | **cosmetic only**; it has no rules class |
| ShovelKnight | not listed | **cosmetic only**; it has no rules class |
| Flex | UNO Flex | yes, the Flex rules |

**House-rule flags** (`GameSetting.HouseRule`):

| Flag | Value |
|---|---|
| STACKING | 1 |
| SEVEN_ZERO | 2 |
| JUMP_IN | 4 |
| ELIMINATION | 8 |
| FORCE_PLAY | 16 |
| DRAW_TO_MATCH | 32 |
| VARIABLE_SCORE | 64 |
| FREE_WILD_DRAW4 | 128 |
| COLLABORATE | 256 |
| AICOOP | 512 |
| SKIPNFLIP | 8192 |
| DRAWNPLAY | 16384 |

The match-setup text confirms **six** player-facing toggles: Stacking, 7-0, Jump-In, Force Play, No Bluffing (`FREE_WILD_DRAW4`) and Draw-to-Match. That upgrades our MED to HIGH. The setup screen also has:
- **Skip n' Flip**, a newer rule (HIGH, loc): "Play Skip and Reverse cards on draw cards to pass on the effect to the next player or back to the person who played it." It is a deflect rule built on existing cards.
- **Score Limit:** one round, or 200, 300, 500, 750 or 1,000 points.
- **Today's Rules:** a daily preset. There are 14 named presets: Chaotic, Speedy, Slow, New Rules, Official 3, Tactical, Fan Favorites, Strategic Skip, Calm and Cozy, Change Up, Heavy Hand, Defense, Action and Challenging. Which toggles each one sets is server data and isn't in the install.
- **Shuffle:** the game re-shuffles your chosen rules every round.
- **Amiibo Mode:** a Switch-only extra.

The remaining flags, as far as the install shows:
- **COLLABORATE / AICOOP:** they back the 2v2 partner modes.
- **ELIMINATION, VARIABLE_SCORE, DRAWNPLAY:** they have no menu text in the install.

Rule notes from the text:
- **Force Play:** "If you draw a card on your turn and it's playable, it's automatically played."
- **Stacking:** "you may play the same type of card to add to the penalty". That is the same-type form: Draw Two on Draw Two, Wild Draw Four on Wild Draw Four.

## 2. Rabbids (#118): names confirmed; two effects corrected

| Card | In-game text (HIGH, loc) | Our doc |
|---|---|---|
| Comin' Through (50) | 5 cards are randomly distributed to your opponents, then 5 more randomly to ALL players, including you. | ✓ |
| Hurry Up! (50) | For the next few turns, everyone must finish their turn in **3 seconds** or draw a card and be skipped. | ✓ |
| Explosive Results (50) | The next player to draw a card **for any reason** must draw an **additional 3**. | ≈ The doc's "draws 4 total" is right for a single draw, but the trigger is *any* draw, not only a forced one. |
| Wild Blue Yonder (50) | Defend yourself from a Draw Two or Wild Draw Four **"by passing it along"**. Played on your turn, it acts as a Wild. | ✗ The doc says it *cancels* the penalty. It actually passes it on, a deflect rather than a block. |

## 3. Just Dance (#119): three of the four names in our doc are wrong

The game's card names differ from ours. "Scream & Shout", "Lean On" and "Worth It" appear **nowhere** in the localization. They look like Just Dance song titles that got mistaken for card names.

| In-game card | Text (HIGH, loc) | Our doc's entry |
|---|---|---|
| Just Dance Machine | Each player gets an **Experiment** card that produces a random action when played. | ✓ |
| **Get Down** | Everyone except the player with the lowest hand count randomly discards until all hands equal the lowest count. | "Scream & Shout": the effect is right, the name is wrong |
| **Cross-Fade** | Each player switches hands with the player directly across from them. | "Lean On": the effect is right, the name is wrong |
| **Hot Number** | Only number cards **and theme cards** may be played. Anyone who plays an action card or Wild must **draw a card afterwards**. | "Worth It": wrong name, and the effect is softer (a draw penalty, not a ban) |

## 4. Rayman (#120): two small corrections

| Card | Text (HIGH, loc) | Our doc |
|---|---|---|
| Dragon | All hands are shuffled together and randomly redistributed. | ✓ |
| Punching Things | Deflect a Draw Two or Wild Draw Four and double the penalty. Played normally, it acts as a Wild. | ✓ |
| Escape | A quick peek at the cards **your opponents** (plural) are holding, then hide your card total from everyone else. | ≈ The doc says *one* opponent and "until you call UNO". The text says all opponents and gives no end condition. |
| A Little Help | Clones the current top card of the discard pile. | ✓ |

## 5. Fenyx's Quest (#121): rewritten (our doc was LOW)

**The mechanic** (HIGH, loc):
- Each god starts **sealed** ("cursed").
- "Play 5 cards to help [god] break her/his seal." Once freed, the god gives you a **passive power** for the rest of the match.
- Our doc's "Golden Isle" doesn't appear in the text (MED: it may be marketing only).

| God | Saved power (HIGH, loc) | Our doc |
|---|---|---|
| Athena | After you play an **odd number card**, choose a player to **skip the round**, and discard a random card from your hand. | ✗ |
| Ares | Each time you play a card, discard **2 random cards of the same color** you played. | ≈ The scope is now settled: it's your own hand. |
| Aphrodite | Each time you play an **Action Card**, choose a card to **give to any player**, and discard a random card from your hand. | ✗ |
| Hephaistos | For every **3 cards** you've played, choose a color and discard all your cards of it. | ✓ |

**Theme cards our doc lacks** (HIGH, loc):
- **Typhon's Trick:** choose a player. They draw 4, then discard 2 random cards.
- **Typhon's Curse:** a cursed card. While you hold one, you draw a card **each time you play**.
- **Fenyx's Power:** choose 2 cards in your hand to discard.

## 6. Call of Yara (#122), Valhalla (#123), Party! Mania (#386) and No Mercy (#390)

### Call of Yara (Far Cry 6)

**Currency and income** (HIGH, code: the serialized `FarCryGameRuleDataMeta`):
- The currency is **"Yaran Pesos"**.
- Starting money: **300**.
- Income: **+100 each turn**, **+100 for stacking a Draw 2**, and **+100 for a Jump-In**. The last two are new to us.
- After using a service you wait out a **1-turn "Charging" cooldown**.
- You can only call a service on your own turn.

**Services** (HIGH, loc). Each character offers two levels:

| Character | Service name | Level 1 | Level 2 |
|---|---|---|---|
| Dani Rojas | "Guerrilleros weapons" | target player draws a random number of cards | (same wording) |
| Philly Barzaga | "Resolver gadgets" | combine 4 colors into a Wild | combine 4 colors into a Wild Draw 4 |
| Juan Cortez | "Supremo backpacks" | discard a random number of your cards | (same wording) |
| Lucky Mama | "Sabotage tools" | prevent one player's next service call | prevent all opponents' next calls |

- **Prices:** the text uses `{0}` placeholders, and the price table isn't in the install. Our doc's prices and card ranges (500/800 and so on) stay **MED**.
- **The theme's Wild card:** it's **"Guerrilla broadcast"**, not "Guerrilla Recorder", which doesn't appear in the text. It plays the "Guerrilla Radio", which triggers one of **6 events**:

| Event | Effect |
|---|---|
| Mafia deeds | steal all the target player's money |
| Act of benevolence | everyone gains X |
| Revolution! | lose X |
| Corruption | double your money |
| Opportunism | take X immediately |
| Good business | gain X for each card in your hand |

### Valhalla (Assassin's Creed): fully resolved (our doc was LOW-MED)

All HIGH (loc) unless marked.

- **Movement:** playing a **number card** moves your pawn to the map area with that number.
- **Map items:**
  - **Cargo:** collect it to unlock upgrades.
  - **Event** spaces: there are 6 events.

    | Event | Effect |
    |---|---|
    | Brotherhood | +1 Cargo for each color in your hand |
    | Raid | steal 2 Cargo from a target |
    | Prosperity | discard 1 card per Cargo you have |
    | Surprise Attack | the target draws as many cards as they have Cargo |
    | Glory Regained | take Cargo up to the current leader's total |
    | Animus Anomaly | discard all odd number cards in your hand |

- **Settlement upgrades:**
  - At **2 Cargo**, the **Longship** unlocks **Battle**: you spend your turn attacking a chosen opponent.
    - Both players secretly choose a color, and the defender blocks by matching it. Wild cards block every color.
    - If the defender misses, they **draw 1 card and burn 1 Cargo**.
  - At **4 Cargo**, the **Longhouse** unlocks **Fast Travel**: each card you play also discards all your other cards of that color.
- **The Wild card:** it's **"Sýnin the Raven"**, not "Eivor's Raven" (Eivor is only an avatar). It moves you to any area regardless of number.
- **Win condition:** no alternative is described, so it's still empty your hand (MED).

### Party! Mania (#386)

It's **3 cards plus a 4th rule**, as the onboarding screen says: "4 crazy rules".

| Card / rule | Effect (HIGH, loc) |
|---|---|
| Point Taken (20) | Everyone points at another player, and each targeted player draws one card per finger pointed at them. It breaks a Drawn Together link. |
| Wild Drawn Together (50) | Links two players, and whenever either one draws, the other draws the same amount. Only one link can exist at a time; a new Drawn Together or a Point Taken breaks it. |
| Wild Pile Up (50) | Flip the top draw card to set a mini-pile color. Players in turn must add that color, and the first who can't takes the mini-pile. Special cards have no effect in the mini-pile. |
| **Speed Play** (rule) | Play an identical **number** card out of turn. In effect, this is Jump-In limited to number cards. |
| Deck note | **This mode has no 0 cards.** A 7 still swaps hands. |

### No Mercy (#390)

The game has **7** named action cards, not 6. Ubisoft's point values are in parentheses.

| Card | Points |
|---|---|
| Draw Four (**colored**, not a wild) | 20 |
| Discard All | 20 |
| Skip Everyone | 20; you also take another turn |
| Wild Draw 6 | 50 |
| Wild Draw 10 | 50 |
| Wild Reverse Draw 4 | 50 |
| Wild Color Roulette | 50 |

- **Stacking:** play a draw card of **equal or higher** value, of any color.
- **Draw to match:** you draw until you get a playable card, and must play it.
- **7-0:** 7s swap hands and 0s pass hands.
- **Mercy rule** (25 or more cards): the tutorial calls it elimination from the game, but the in-match pop-up says "knocked out of the round… back in play for the next round". In other words, the knockout lasts for that round only when you play to a score.

## 7. Modes and modifiers that aren't DLC

**Wild Weeks** (HIGH, loc). A rotating monthly online event ("starting on the first Monday of every month"). It has 8 named modes:

| Mode | Effect |
|---|---|
| Flipped! | you see the backs of your own cards and the fronts of everyone else's |
| Fog of War | opponents' cards are completely hidden |
| Tiny Hands | 3-card deal |
| Big Hands | 12-card deal |
| Attack! | every draw from the pile adds a random 1–12 extra cards |
| Whirlpool | each turn, a random card from your hand passes to the next player |
| Glitched | cards randomly transform into other cards |
| Shuffle Hands | every 60 s, all hands are pooled and redealt |

**Twitch chat "disruptions"** (HIGH, loc). These are timed modifiers that the audience votes on:
- Twitch Plays UNO
- Hide Opponents' Cards
- Flip Host's Cards
- **Ban \<color\> Cards**
- **\<Color\> Cards Only**

**Wild 50/50** (the 50th-anniversary theme, HIGH, loc). Pick two players, who are assigned "UNO" (heads) and "50" (tails). A coin is tossed, and the losing player draws 4.

## 8. Ideas worth taking

Each item is mapped to `docs/implementation-plan.md`.

- **Skip n' Flip** (Phase 7 response cards):
  - A Skip on a pending draw *redirects* the penalty to the next player; a Reverse *reflects* it back.
  - This adds response behavior to existing cards, so no new card art is needed.
  - It reinforces the plan's block / reflect / redirect split.
- **Tie-break between deflect cards:** Wild Blue Yonder (pass it on) vs Punching Things (reflect it at double). This needs a rule in C2 for when a deflect meets a stack.
- **Lasting effects** (pairs with doc 09's turn-limited statuses):
  - Typhon's Curse: draw 1 whenever you play, while you hold the card.
  - Fenyx's god powers: passive powers unlocked after 5 plays.
  - Wild Drawn Together: a link that lasts until it's broken.
  - Hot Number: a table-wide play restriction with a penalty.
- **Small modifier presets for a "Today's Rules"–style menu:**
  - Tiny Hands and Big Hands (hand size)
  - Attack! (random extra draws)
  - Whirlpool (a card passes each turn)
  - Shuffle Hands (timed pooled redeal)
  - Fog of War and Flipped! (visibility)
  - color bans (Twitch)

  Most of these only change a single setting.
- **Score-limit choices** of 200/300/500/750/1,000 and a one-round mode. That's a reasonable default list.

Corrections for `gameversions.md` E2 (applied there):
- **#118 Rabbids:** Wild Blue Yonder passes the penalty on rather than cancelling it, and Explosive Results triggers on any draw.
- **#119 Just Dance:** the card names are Get Down, Cross-Fade and Hot Number, and Hot Number's effect is softer than described.
- **#120 Rayman:** Escape peeks at all opponents.
- **#121 Fenyx's Quest:** the god powers and the three Typhon/Fenyx cards in section 5.
- **#122 Call of Yara:** the Wild card is "Guerrilla broadcast"; also its six events and the two extra income sources.
- **#123 Valhalla:** the full ruleset in section 6.
- **#386 Party! Mania:** add the Speed Play rule and the no-zero deck.
- **#390 No Mercy:** list the 7 cards and the per-round Mercy wording.
- **#115 base game:** confirm the six house rules, and add Skip n' Flip, Score Limit, Today's Rules and Shuffle.
