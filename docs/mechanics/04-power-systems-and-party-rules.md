# Final review 4: character/power systems, scoring variants, themed action sets

> Reference spec for `docs/gameversions.md` (see its Part F). Second pass: checked against Mattel's official instruction sheets (service.mattel.com). Claims marked "(sheet CODE)" are quoted or paraphrased from that sheet. Claims without a sheet code are still from secondary sources and are marked as such.

Research method, pass 2: downloaded Mattel's instruction sheets and read the text. Four sheets (HHV87, HPT45 and both French
versions) are scanned images, so I read them from the page images. Card text printed small on those images was enlarged and
read where it was legible, and is marked "(sheet CODE, card image)". Secondary sources used to fill gaps: gamerules.com
per-character pages for UNO Ultimate Marvel 1st Ed (readable this pass), RulesPal, ToyHype, The Toy Insider, and Wikipedia.
BoardGameGeek and the UNO fandom wiki were still blocked.

Confidence: HIGH = official sheet text (or sheet text plus a matching secondary source). MED = one detailed secondary
source, or a direct inference from sheet text. LOW = thin or inferred. UNVERIFIED = no sheet, and nothing reliable found.

Sheets read in this pass:

| Code | Product | Notes |
|---|---|---|
| HHV87 | UNO Ultimate Marvel (1st Ed, 2022: Black Panther, Captain Marvel, Iron Man, Thor) | Scanned; read from the page images |
| HPT45 | UNO Ultimate Marvel 2nd Ed (2023: Shuri, Captain America, Black Widow, Hulk). Mattel lists it as "UNO Ultimate™" | Scanned; read from the page images |
| HRF37 | UNO Ultimate DC (2023: Superman, Wonder Woman, Green Lantern, Aquaman) | Text |
| HHV91 / HHV92 / HHV93 | Ultimate add-on packs: Spider-Man (Character Pack 1), Doctor Strange (Pack 2), Scarlet Witch (Pack 3) | Text, but only a strategy blurb: no power text |
| HJX86 / HJX87 / HJX88 | Ultimate add-on packs: Miles Morales, Ms. Marvel, She-Hulk | Same: strategy blurb only |
| HPT40 | Ultimate add-on pack: Loki | Same |
| HPT39 | Ultimate add-on pack: Ant-Man | Its product page links to the Loki sheet (HPT40). HPT39-Eng.pdf returns 404, so there is no Ant-Man sheet |
| HJH90 | Classic UNO with one random UNO Ultimate chase foil | Classic rules plus a foil blurb |
| JDM38 | UNO Elite (NFL, 2024 Core) | Text |
| HPW20 / HPY63 | UNO NFL (all 32 teams) / Giant UNO NFL | Text: Wild Ice The Kicker |
| HPW22 | UNO Super Bowl LVII | Text: Wild Touchdown! |
| HYH50 | UNO Fandom NFL Dallas Cowboys | Text: Wild Hail Mary. JDK16 (Browns) has no sheet online |
| HMY49 / JJV58 | UNO Party (2022 Party Pack) / UNO Party (2024-25 reissue) | Text |
| JLH43 | Liar's UNO (2025) | The only sheet online is a multi-language PDF named "_German", and its first section is English |
| FNC47 | WWE UNO (older deck with Locked Up) | Text |
| JKH98 | UNO WWE (2025) | Text: Wild Payback |
| JCW36 / JCW37 | Not WWE: these are UNO Fandom Star Wars Posters / Dark Side | Pass 1 guessed they were WWE. Wrong |

Mattel's search returned nothing for NASCAR, Cricket, X Games, WWE Legends, a Thanos promo, or Super Bowl LIX.

---

## 1. UNO Ultimate Marvel (1st Ed 2022, 2nd Ed 2023), UNO Ultimate DC, add-ons, Thanos promo (#56-73, #395)

### 1.1 Core rules (shared by Marvel 1st/2nd Ed and DC unless noted)

| Rule element | Spec | Confidence |
|---|---|---|
| Players / age | 2-4 players, 7+. | HIGH (sheets HHV87, HPT45, HRF37) |
| Win condition | Two ways to win: (1) "If you get rid of all the cards in your hand, you WIN!" (2) "If you are the last player with cards in your Character Deck, you WIN!" Note: "If the last card you play to win has a Danger Icon on it, you DO NOT have to draw a Danger Card. You still win." | HIGH (sheets HHV87, HPT45, HRF37) |
| Elimination | "If your Character Deck ever runs out of cards you are OUT OF THE GAME." The trigger is the deck running out (from a burn, an add or a draw). The sheet does not say whether you are out the instant it hits 0 or only when you next need a card. gamerules: "If a player burns out, they are out of the game." Suggested engine reading: you are out the moment your Character Deck is empty. | HIGH (the rule); MED (exact timing) |
| Contents | Marvel 1st Ed: "228 Cards – including 4 Character Decks, 4 Character Cards, and 1 Danger Deck (32 Danger Cards.)" plus "1 Box Topper (4 Foil Cards)". Marvel 2nd Ed and DC: "224 Cards" with the same breakdown (the DC foils come in a "Blind Bag"). | HIGH (sheets HHV87, HPT45, HRF37) |
| Character Deck size | 56 cards per character: 47 playing cards, 1 Character Card, 4 Enemy cards and 4 Event cards (gamerules, 1st Ed). This matches the sheets: 4 × 56 = 224, 32 Danger cards = 8 per character, and each add-on pack holds 58 cards including 2 foils (= 56). The 1st Ed's printed "228" probably counts the 4 foils. In 2nd Ed and DC, the 8 Danger cards per character also include Items/Locations, so the 4+4 split is 1st Ed only. | HIGH (56 total and 8 Danger per character); MED (the 47/4/4 split) |
| Character choice | "Each player chooses the identity of a Marvel [DC] character who has powers you can use on EVERY TURN!" Each Character Deck has its own power and its own Wild Cards. | HIGH (sheets) |
| Setup | First game: "Unwrap each deck but DON'T SHUFFLE THEM YET!" Every game: (1) choose a character; return unused decks to the box. (2) Separate your Character Deck from the Danger cards (1st Ed: the purple "Enemy" and "Event" cards; 2nd Ed adds "Item"). (3) Combine everyone's Danger cards and shuffle them into one Danger Deck, using ONLY the Danger cards of characters in this game. (4) Put your Character Card where everyone can see it. (5) Shuffle your Character Deck. (6) Take the top 7 as your hand; the rest is your face-down Character Deck Draw Pile. | HIGH (sheets HHV87, HPT45, HRF37) |
| Start of play | "The youngest player goes first. Play any card from your hand face-up to the middle of the playing area to begin a Discard Pile that all players will share." Clockwise, unless that opening card is a Reverse. There is no flip from a shared deck. | HIGH (sheets) |
| Keyword "Add" | "Take the number of cards indicated from your Character Deck and add them to your hand." Your turn continues. | HIGH (sheets) |
| Keyword "Draw" | "Draw the required amount (such as a 'Draw 2' Card) from your Character Deck Draw Pile and lose your turn." | HIGH (sheets) |
| Normal draw | "If you DO NOT HAVE a matching card, DRAW ONE CARD from your Character Deck. If your new card can be played you may play it now. If your new card cannot be played, add it to your hand." You may also choose to draw instead of playing. This ordinary draw is NOT the "Draw" keyword: it does not cost an extra turn. | HIGH (sheets) |
| Keyword "Burn" | "Take the number of cards indicated from the top of your Character Deck and put them face-up in a pile, known as the Burn Pile, next to your Character Deck." Burn one card at a time. "Sometimes a card will instruct you to burn cards from your hand instead of your Character Deck. Unless the location is specified, burn always means from your Character Deck." | HIGH (sheets) |
| Keyword "Recover" | "Take the number of cards indicated one at a time from the top of your Burn Pile (unless otherwise specified) and place them on the bottom of your Character Deck." Recovered cards go to the DECK, not to your hand. | HIGH (sheets HHV87, HPT45, HRF37). Pass 1 did not have this keyword. |
| Turn sequence | "Start of Your Turn: resolve any start-of-turn effects from attacking Enemies, Events, [Items,] Action Cards, or opponent-controlled character powers. If you have a character power that activates at the start of your turn, you may activate it now. Play: play a card from your hand. If you have a character power that activates based on the card you played, resolve its effects now. Battle: if you have an Enemy attacking you and the card you played satisfies the Enemy's defeat cost, defeat the Enemy. Danger: if the card you played to the Discard Pile shows a Danger Icon, flip over the top card of the Danger Deck and resolve its effects. End of Turn: resolve any end-of-turn effects." | HIGH (sheets HHV87, HPT45, HRF37) |
| Danger icon: who is affected | The player who played the icon card flips the Danger card, and an Enemy goes "in front of your Character Card" (the flipper's). Events say who they hit (e.g. "Skip the next player", "All players add 1 card..."). | HIGH (sheets; pass 1 had LOW) |
| Danger Deck runs out | "Gather the cards from the Danger Deck Discard Pile, shuffle them and then create a new Danger Deck." | HIGH (sheets) |
| Event card | "An Event Card immediately forces one or more players to take an action. After the action ... has been taken, the Event is considered completed. Place the card in the Danger Discard Pile." | HIGH (sheets) |
| Enemy card | "When you draw an Enemy Card, place it in front of your Character Card. This Enemy is now attacking your character. If an Enemy Card is already there it is replaced by the new one. Move the previous Enemy to the Danger Deck Discard Pile (this does NOT count as 'defeating' the Enemy)." Each card lists WHEN FLIPPED (on-reveal effect), WHILE ATTACKING (ongoing rule) and TO DEFEAT (cost), plus an edition number. | HIGH (sheets) |
| Defeating an Enemy | "An Enemy is only defeated when the player plays a card that matches the type of card listed in the 'To Defeat' section. An Enemy cannot be defeated on the turn it is drawn. ... Wild Cards cannot be used to defeat an Enemy unless the defeat cost specifically shows a Wild Symbol." With several symbols, matching any one is enough. A defeated Enemy goes to the Danger Deck Discard Pile. | HIGH (sheets) |
| Defeat Cost symbols | Red card, Yellow card, Blue card, Green card, Number card (#), Wild card (4-color square), Action card (arrows), and "Card with a [Danger icon]". | HIGH (sheets HHV87, HPT45, HRF37) |
| Item card (2nd Ed) | "Item Cards, when revealed, are immediately placed next to your Character Card. The Item has a secondary Character Power that you can choose to use." Example: Body Armor, "Ignore add effects from Enemy Cards." | HIGH (sheet HPT45) |
| Item card (DC: fuller rules) | "When drawn, immediately place it next to your Character Card. They are not character-specific so any player can attach any Item Card to their character. You may only have up to 3 Item Cards attached to your character at any time." If you draw a 4th, discard one attached Item or the new one. "Some Item Cards stay in play for a time while others make you 'destroy' them in order to take advantage of their effect. ... If another card tells you to 'destroy' an Item Card, you don't get to enjoy the 'destroy effect'." If you have several start-of-turn Items, you choose their order. | HIGH (sheet HRF37) |
| Location card (DC) | "When a Location Card is drawn, it is placed in the center of the playing area and affects all players. A Location Card stays in play until a new Location Card is played, or the action of a different type of card destroys it." Only one Location is in play at a time. Example Event: Destruction Wave, "Destroy the current Location." | HIGH (sheet HRF37) |
| Action cards | Draw Two ("The next player must draw 2 cards and lose their turn"), Reverse, Skip, and Wild. "Action Cards can be played on other Action Cards of the same type ... Wild Cards can be played on top of any card." Skip: "The next player loses their turn. Attacking Enemies do not affect you if you are skipped. NOTE: If you are waiting to have your turn skipped and you get hit by any other effect that would skip you or cause you to lose a turn, that effect is ignored." Each deck's Wilds carry their own printed instructions. | HIGH (sheets) |
| UNO call | "If someone catches you and calls out 'UNO' before you (and before the next player begins their turn), then you must draw 2 cards!" The sheet does not say whether this "draw" also costs a turn. It comes from your Character Deck, since there is no other pile. | HIGH (penalty); MED (source pile) |
| Card text vs rules | When a card's text contradicts the main rules, the card wins. Not on the sheets (secondary sources only). The sheets say rules will expand ("scan the QR code to find the latest UNO Ultimate™ instructions" on HPT45/HRF37). | MED |
| Foils | Core boxes include 4 foils (Marvel: "Box Topper"; DC: "Blind Bag"). Each add-on pack has 2 foils. Foils are "collectible versions of the Wild and Character Cards"; you may swap them in for the matching normal card. Five rarity levels, shown by a colored dot: Common (green), Uncommon (blue), Rare (yellow), Super Rare (red), Ultra Rare (purple). No rule effect. Chase foils also come in specially marked classic UNO packs (sheet HJH90: 113 cards = 112 + 1 foil). | HIGH (sheets HHV87, HPT45, HRF37, HJH90, add-on sheets) |
| Add-on rule | "If you are using the cards from an Add-On Pack, make sure all the cards in the game are for the Superheroes currently playing" (no Danger cards from a character who isn't playing). | HIGH (sheets) |

### 1.2 Character roster and powers

| Product | Character | Power (name: text) | Deck-specific Wild cards | Confidence |
|---|---|---|---|---|
| Marvel 1st Ed (HHV87) | Iron Man | **Proton Cannon**: "When you play a card with a [Danger icon], all other players burn 1 card." | Power Drain: "Other players cannot use their character powers until the start of your next turn." Repulsor Blast: "In the current order of play, all other players flip a Danger Card and do what it says." Reactor Burn: "All other players add 1 card." Unibeam Barrage: "All other players burn 3 cards." | Power HIGH (sheet HHV87 card image, partly legible, plus gamerules). Wilds MED (gamerules) |
| Marvel 1st Ed | Thor | **Lightning Charge**: "When you change the active color, the next player burns 2 cards." | Thunder Plunder: "Choose a player to skip their next turn." Bifrost Blow: "Choose a player to burn cards equal to the number of Enemies currently attacking all players." Asgard Assault: "Choose a player to add 1 card and burn 1 card." Mjolnir's Revenge: "Defeat an Enemy attacking you. The next player must burn 1 card." | Power HIGH (sheet HHV87 card image shows "Lightning [Charge]: When you change t... the next player b..."; gamerules gives the full text). Wilds MED (gamerules). "Lightning Charge" is the power name, not a card name. |
| Marvel 1st Ed | Captain Marvel | **Cosmic Energy**: "Once per turn, before you play a card, you may add 1 card to change the active color to a color of your choice." | Photonic Beam: "Choose a player to add 1 card and flip a Danger Card." Seventh Sense: "Recover 3 cards." Higher, Further, Faster: "The next player adds 3 cards." Cosmic Fusion: "If played on top of another Wild Card, you may play again." | Power HIGH (sheet HHV87 card image, fully legible). Wilds MED (gamerules) |
| Marvel 1st Ed | Black Panther | **Vibranium Armor**: "When you defeat an Enemy, recover 2 cards." (Recover = Burn Pile → bottom of your Character Deck.) | Wakanda Forever: "Defeat an Enemy who is attacking you." (sheet HHV87 example). Vibranium Claws: "No Skip Cards may be played by anyone until the start of your next turn." Energy Dagger: "Recover 4 cards. All other players recover 2 cards." Kinetic Absorption: "Choose a player to add 1 card. You recover 2 cards." | Power HIGH (sheet HHV87 card image, plus gamerules). Wakanda Forever HIGH. Other Wilds MED (gamerules). CORRECTED: Vibranium Armor is the power, not a foil card, and Kinetic Absorption is a Wild, not the power. |
| Marvel 2nd Ed (HPT45) | Shuri | **Wakandan Tech**: "When any Item Card is revealed or destroyed, you may immediately exchange a card in your hand with a card in your Burn Pile." | Silent Strike: "Choose a player to add 1 card and skip their turn. If you have an Item attached, that player also burns 2 cards and you recover 2 cards." Other Wilds UNVERIFIED. | HIGH (sheet HPT45 card images) |
| Marvel 2nd Ed | Captain America | **"I can do this all day."**: "When you burn 2 or more cards, you may burn 1 less card." | UNVERIFIED | HIGH (sheet HPT45 card image) |
| Marvel 2nd Ed | Hulk | **"Don't make me an[gry]..."**: "If there are 12+ cards in your [Burn] Pile, Hulk is enraged. When en[raged], all other players burn 2 cards [at the] start of your turn." | UNVERIFIED | MED-HIGH (sheet HPT45 card image; the right edge is hidden behind another card, and the bracketed words are my reconstruction) |
| Marvel 2nd Ed | Black Widow | **Interro[gation?]**: "When you change t[he active color?], choose a player to bu[rn ...] from their hand a[nd ...]". Mostly hidden behind the Hulk card in the image. Strategy blurb: "Maximize her character power by eliminating opponents' ability to play cards or remove wild card threats." | UNVERIFIED | LOW-MED (fragment only). Exact text still UNVERIFIED. |
| DC (HRF37) | Superman | **Impervious**: "When you lose your turn, choose a player to burn 2 cards." Blurb: "a well-balanced deck of utility wild cards ... his power is reactive make sure to always be on your toes when someone tries to skip you." | UNVERIFIED | HIGH (sheet HRF37) |
| DC | Wonder Woman | **Amazonian Fury**: "When you defeat an Enemy, choose a player to add 1 card and burn 1 card." Blurb: play "!" cards to bring Enemies out, then defeat them. | UNVERIFIED | HIGH (sheet HRF37) |
| DC | Green Lantern | **Construct Creation**: "During your turn, instead of playing a card from your hand, you may burn 2 cards and play a card from your Burn Pile." | UNVERIFIED | HIGH (sheet HRF37). Note: the power REPLACES your hand play for that turn. |
| DC | Aquaman | **Aquatic Aftershock**: "When you change the active color, until the start of your next turn, the next player to change the active color burns 2 cards." Locations are a separate part of his deck: "Aquaman needs to have his locations in play ... get the benefits of battling in your character-specific locations as well as from your character power." | UNVERIFIED | HIGH (sheet HRF37). CORRECTED: pass 1 said the power scales with Locations. It doesn't; the Locations are a separate part of his deck. |
| DC (deck unknown) | n/a | Wild "Ends of the Earth": "Choose an Enemy Card in the Danger Discard Pile. Trigger its 'when flipped' ability. You may burn a card from your hand that matches its defeat cost." | n/a | HIGH for the text (sheet HRF37); which character owns it is UNVERIFIED |
| DC | Batman / Joker / Harley Quinn | Not in the core box. Batman/Harley add-on packs: no Mattel sheet found and no power text. | n/a | HIGH that they are not in the core box; powers UNVERIFIED |
| Add-on (HHV91, "Character Pack 1") | Spider-Man | Exact power text UNVERIFIED. Sheet blurb: "His power reflects his commitment to deal with Enemies. Use his Wild Cards to make players flip Danger Cards and move around Enemies. Sometimes you will want to take an Enemy from another player so that you can defeat it in order to set up your character power." So the power probably triggers on defeating an Enemy. | Wilds that force Danger flips and move Enemies (names UNVERIFIED) | Theme HIGH (sheet); power text UNVERIFIED |
| Add-on (HHV92, Pack 2) | Doctor Strange | UNVERIFIED. Blurb: "Try to change the active color as much as you can to maximize his character power. Use his Wild Cards for both supporting his character power and stopping players from playing certain cards." The power triggers on color changes. | names UNVERIFIED | Theme HIGH (sheet) |
| Add-on (HHV93, Pack 3) | Scarlet Witch | UNVERIFIED. Blurb: "What she lacks in card burning and skips she makes up with controlling what cards people play. Use her vast array of Reverse Cards ... You might want to hold onto some reverses to recover burned cards." The deck is heavy on Reverses, and Reverses let her recover. | names UNVERIFIED | Theme HIGH (sheet) |
| Add-on (HJX86) | Miles Morales | Power name **Spider Sense** (text UNVERIFIED): "Use his Spider Sense power to ensure you keep your best cards from being burned. Use his Wild Cards to control what Danger Cards players can get. Avoid dangerous turns by skipping any player and avoiding all negative effects on cards. Use your camouflage cards when you are down to a few cards to ensure you can go out." | "camouflage" cards (names UNVERIFIED) | Name HIGH (sheet); text UNVERIFIED |
| Add-on (HJX87) | Ms. Marvel | UNVERIFIED. Blurb: "Ms. Marvel's fantastic elasticity allows her to make other players burn cards when she adds or draws cards ... spreading out burns to all other players." The power triggers when she adds or draws. | **Stretch-n-Fetch** Wilds (they use cards you have burned) | Theme and Wild name HIGH (sheet) |
| Add-on (HJX88) | She-Hulk | UNVERIFIED. Blurb: "Her Character Power allows her to choose which ability to use when she changes color ... Her Action Cards provide utility as well." The power triggers on a color change and offers a choice of effects. | names UNVERIFIED | Theme HIGH (sheet) |
| Add-on (HPT40) | Loki (PLAYABLE) | UNVERIFIED. Blurb: "Always make sure you are paying attention to when a Danger Icon Card is played to get the most out of Loki's character power." The power triggers on Danger Icon plays, possibly anyone's. | **Simple Illusion** ("copy another powerful Wild Card"), **Your Savior is Here** (uses information gathered from other players) | HIGH that the Loki pack is a playable character (sheet HPT40). Loki is also an Enemy in Thor's 1st Ed Danger cards, so both versions exist; don't merge them. |
| Add-on (HPT39) | Ant-Man | No sheet (the product page links the Loki sheet; HPT39-Eng.pdf is 404). Power UNVERIFIED. | UNVERIFIED | Product exists (Mattel listing) |
| Other Marvel add-ons | Shang-Chi, Venom, Spider-Man 2099, Spider-Gwen, Rocket, Groot, Mighty Thor, etc. | No Mattel sheet found. The SDCC 2023 Spider-Man 2099 vs. Venom 2-pack: each deck has 57 cards, all foil, with "4 attack cards ... and 4 event cards per deck" (ToyHype). | UNVERIFIED | Powers UNVERIFIED |

Every add-on sheet says: "NOTE: The UNO Ultimate™ Core Card Game is required for use with this deck. CONTENTS: 58 Cards (including 2 foil cards)." (sheets HHV91-93, HJX86-88, HPT40). Any add-on mixes with any core box (the core sheets give the example of swapping out Thor for Spider-Man).

### 1.3 Danger cards found

Marvel 1st Ed: each character brings 4 Enemies and 4 Events. Card text below is from gamerules unless a sheet is cited. gamerules does not list defeat costs.

| Deck | Card | Type | Effect | Confidence |
|---|---|---|---|---|
| Black Panther | Baron Zemo | Enemy | Flipped: burn 1 card. Attacking: "When you play a Wild Card, burn 1 card." To defeat: play a red card. | HIGH (sheet HHV87 example card) |
| Black Panther | Klaw | Enemy | Flipped: burn 2 cards. Attacking: at the start of your turn, flip a Danger card. | MED |
| Black Panther | Killmonger | Enemy | Flipped: burn a Wild Card from your hand, then add 1. Attacking: when you play a Wild Card, add 1. | MED |
| Black Panther | Morlun | Enemy | Flipped: skip the next player. Attacking: you cannot recover cards. | MED |
| Black Panther | Trip Up | Event | "Skip the next player." | HIGH (sheet HHV87 example card) |
| Black Panther | Rejuvenate / Jolt / Flee | Event | Recover 2 / all players with an Enemy attacking add 1 / if an Enemy is attacking you, discard it from play. | MED (Jolt also appears on sheet HHV87's layout image) |
| Thor | Loki | Enemy | Flipped: reverse the order of play. Attacking: you cannot play Reverse cards. To defeat: a red or green card (pass-1 snippet only). | MED (effects, gamerules); LOW (defeat cost) |
| Thor | Malekith / Destroyer / Hela | Enemy | Malekith: flipped, burn a number card from your hand then add 1; attacking, whenever you burn, burn 1 more. Destroyer: flipped, all players burn 1; attacking, burn 2 at the start of your turn. Hela: flipped, burn 1 per active player; attacking, all players burn 1. | MED |
| Thor | Block / Trample / Overload / Shock | Event | The next card played cannot be a Wild / Add 2 / all players with Enemies attacking burn 2 / Burn 2. | MED |
| Captain Marvel | Skrulls / Yon-Rogg / Ronan / Supreme Intelligence | Enemy | Skrulls: flipped, change the active color; attacking, you cannot play cards that make others add or draw. Yon-Rogg: flipped, burn 1 from your hand then add 1; attacking, when you change the active color, add 2. Ronan: flipped, burn 2; attacking, if you make someone add or draw, you must do the same. Supreme Intelligence: flipped, burn 1 per Enemy in play; attacking, when you change the active color, burn 2. | MED (Yon-Rogg also appears on sheet HHV87's layout image) |
| Captain Marvel | Setback / Burning Charge / Plan Ahead / Chroma Break | Event | Add 1 / Burn 3 / burn 1 from your hand (unless it's your last card) / change the active color. | MED |
| Iron Man | Hydra Agent / Whiplash / Madam Masque / M.O.D.O.K. | Enemy | Hydra Agent: flipped, all players add 1; attacking, burn 1 at the start of your turn. Whiplash: flipped, burn 1; attacking, add 1 at the start of your turn. Madam Masque: flipped, burn 2; attacking, you can only play Number cards. M.O.D.O.K.: flipped, burn a Wild from your hand then add 1; attacking, whenever you add or draw, the number goes up by 1. | MED |
| Iron Man | Rewind / Conspiracy / Full Support / Meltdown | Event | Reverse / all players add 2 / all players with more than 1 card in hand burn 1 from their hand / all players burn 2. | MED |
| Marvel 2nd Ed (Captain America's) | Red Skull | Enemy | Flipped: "All players add 1 card." Attacking: "At the start of your turn, all players burn 1 card." To defeat: play a Wild card. | HIGH (sheet HPT45 example card) |
| Marvel 2nd Ed (Captain America's) | Backlash | Event | "All players add 1 card and then burn 2 cards." | HIGH (sheet HPT45) |
| Marvel 2nd Ed (Captain America's) | Body Armor | Item | "Ignore add effects from Enemy Cards." | HIGH (sheet HPT45) |
| Marvel 2nd Ed | Red Guardian, Abomination | Enemy | Named on sheet HPT45's layout image. Text illegible. | Names only |
| DC | King Shark | Enemy | Flipped: "Add 1 card. Reverse." Attacking: "Your Wild Cards read as blank." To defeat: a single symbol (the extracted text lost which one). | HIGH (sheet HRF37 example card), except the cost |
| DC | Destruction Wave | Event | "Destroy the current Location." | HIGH (sheet HRF37) |
| DC | Metropolis | Location | "At the start of a player's turn they may shuffle a non-[?] card from their hand into their Character Deck and then add [1] card." The text is in a symbol font; I decoded it, and one icon is unreadable. | MED-HIGH (sheet HRF37) |
| Promo | Thanos (#395) | Unknown | No Mattel sheet, and no card text found. | UNVERIFIED |

### Edge cases & rulings (Ultimate)
- Official turn order (sheet): play your card → resolve on-play character powers → Battle (defeat your Enemy if this card pays its cost) → Danger flip → end-of-turn effects. So Iron Man's Proton Cannon burn happens BEFORE the Danger card he triggers. Black Panther or Wonder Woman can defeat their current Enemy with a Danger-icon card, recover or punish, and only then flip a new Danger card. A newly flipped Enemy cannot be defeated that turn.
- Thor's and Aquaman's powers say "When you change the active color". Choosing the color that is already active is not a change (MED inference). Only changes made by that character's own plays count.
- Enemy replacement is officially "NOT ... defeating", so Vibranium Armor, Amazonian Fury and Spider-Man-style on-defeat powers do NOT fire (HIGH).
- Wild cards never pay a defeat cost unless the cost shows the Wild symbol (HIGH). "Card with a [Danger icon]" is its own cost symbol.
- "Draw" loses the turn; "Add" doesn't; the ordinary no-match draw doesn't (HIGH). Most character-power penalties use Add or Burn, so they don't skip turns. Superman's "When you lose your turn" fires on Skip, Draw Two, Thunder Plunder, Silent Strike, etc. If you are already due to be skipped, a second skip/lose-turn effect "is ignored" (HIGH, Skip text), so Superman fires at most once per lost turn.
- A skipped player is not affected by their attacking Enemy that turn ("Attacking Enemies do not affect you if you are skipped").
- Personal draw piles mean no shared-deck reshuffle. An empty Character Deck means elimination. The Danger Deck DOES reshuffle from its discard pile.
- Recover moves cards from the Burn Pile to the BOTTOM of your Character Deck, never to your hand, so it extends your life rather than your options. Green Lantern and Shuri are the exceptions that reach into the Burn Pile directly.
- Items (2nd Ed/DC): at most 3 attached (DC text). Items are not character-specific.
- Locations (DC): one at a time, shared by all players, replaced by the next Location or destroyed by a card.

---

## 2. UNO Elite NFL (#408-409, #467-474)

| Element | Spec | Confidence |
|---|---|---|
| Contents (JDM38, 2024 Core) | "112 UNO Cards, 56 NFL Player Cards, 4 Foil NFL Player Cards." 2-7 players, 7+. | HIGH (sheet JDM38) |
| Where actions live | "Most of the traditional actions you take (like Skip, Reverse and more) are found on the NFL Player Cards." The UNO deck's own Action Cards are Elite Wild, Wild Recover and Recover (the only ones the sheet lists). | HIGH (sheet JDM38) |
| Unlock trigger | "Whenever you play a card with an 'Elite' Icon you may activate the power of an NFL Player Card from your 'Lineup'." "You may ONLY activate a Player Card if it matches the color of the card you played." Example: a Red 3 with an Elite Icon lets you activate a red Player Card. "Elite Icons do not count as a matching symbol." Activation is optional ("you may choose NOT to activate"). | HIGH (sheet JDM38) |
| Player Deck and Lineup (Quick Play) | Deal 8 NFL Player Cards face down to each player as their Player Deck; the rest are unused. Each player shuffles and flips the top 3 face up in a row: that is the Lineup. Each Player Card has one color (red, blue, green or yellow). | HIGH (sheet JDM38). CORRECTED: pass 1's "4 base + 4 base foils + 2 dual + 1 wild" lineup was wrong. Those are foil TYPES, not a lineup. |
| Are powers reusable? | NO. "Use its power ..., then place it FACE-UP in a Player Card Discard Pile next to your Player Deck. When you're done, draw 1 card from the top of your Player Deck and add it to your Lineup, bringing it back up to 3. Your turn is now over." | HIGH (sheet JDM38) |
| Player Deck runs out | "DO NOT shuffle the discards to form a new deck. Use Recover Action Cards ... to get Player Cards back into your Player Deck." | HIGH (sheet JDM38) |
| Elite Wild | Played on any card. "You choose the color that continues play. If any of the cards in your Lineup match the color you chose, you may activate one of those Player Cards." | HIGH (sheet JDM38) |
| Wild Recover | Played on any card. "Take up to 3 Player Cards of your choice from your Player Card Discard Pile and put them under your Player Deck in any order." You choose the color. | HIGH (sheet JDM38) |
| Recover (colored action) | "Take any one Player Card of your choice from your Player Card Discard Pile and put it under your Player Deck." | HIGH (sheet JDM38) |
| Player Card action icons | Skip ("the next player in current order skips their next turn"); Reverse; Draw ("Draw the number of UNO cards indicated by the number from the Draw Pile"); Peek ("Look at another player's hand"); Play Again ("you get to immediately take another turn"); Discard (the next player discards 1 UNO or Player card, depending on the icon); Recover (1 UNO card from the discard pile to your hand, or 1 Player Card to the bottom of your Player Deck); Swap ("Take a card at random from another player's hand and then give them a card of your choice from your hand"). Modifier icons: Target (you pick which other player is affected) and Everyone (every other player is affected). Some icons say whether they act on an UNO card or a Player Card. | HIGH (sheet JDM38) |
| "Point values" (+2, +3) | The "+2" and "+3" printed beside names in the sheet's examples (Jalen Hurts +2 +2, Cooper Kupp +2, Dak Prescott +3, DK Metcalf +2) are almost certainly Draw icons with their numbers. The quick-reference key prints "+1" and "+3" next to the Draw icon. The sheet has no point, salary or lineup-cap system. | MED-HIGH (sheet JDM38; my reading of the icons) |
| Draft Mode | Flip (players + 2) Player Cards and draft one each, youngest first, in snake order. Return the 2 leftovers to the bottom of the pile and repeat until everyone has 8. | HIGH (sheet JDM38) |
| Dynasty Mode / deck construction | Players build from their own collections (Starter Pack or Draft Packs). Rules: exactly 8 Player Cards; no more than 1 card per real player (by name); at least 1 card of each color (a Dual card counts as one of its colors); no more than 2 Wild and/or 2 Dual Color cards; no more than 4 instances of any single action icon (each icon on a multi-icon card counts; modifiers such as numbers, Target and Everyone don't make an icon unique). | HIGH (sheet JDM38) |
| Foil types | Base Color Foil: "the same as a regular Player Card except for the foil", one in each of the 4 colors for every player in the line. Dual Color Foil: 2 colors (Green/Blue or Red/Yellow), activated by an Elite card of either color. Wild Foil: "counts as all 4 colors and can be activated by ANY card showing an Elite Icon, regardless of color." | HIGH (sheet JDM38) |
| Rarity tiers (Viper, Kaleidoscope, Hypnotic) | Not on the sheet. The only rule-relevant types are Base / Dual / Wild. Treat named parallels as cosmetic. | MED (absence from the sheet) |
| Example player powers | The sheet shows no action text. Individual player icon sets are UNVERIFIED. | UNVERIFIED |
| UNO call / win | Standard: 2-card penalty, and you win on your last UNO card. | HIGH (sheet JDM38) |
| Colorblind symbols | Cards carry color symbols. | HIGH (sheet JDM38) |

### Edge cases & rulings (Elite)
- One activation per Elite-icon play, from the Lineup only. Activating ends your turn ("Your turn is now over"). So a Play Again icon is the only way to keep going.
- An Elite game with no lineup has almost no basic actions. In an engine, model actions as "Player Card icons", not as deck cards.
- Dual and Wild foils match the color of the Elite card played (or, for Elite Wild, the color you name), not the current discard color (HIGH).
- Player Cards are consumed. A lineup can shrink below 3 when the Player Deck is empty; the only refill is Recover / Wild Recover.

---

## 3. UNO NFL / Super Bowl / Fandom NFL team decks (#218-224, #440-466)

| Element | Spec | Confidence |
|---|---|---|
| UNO NFL all-32-teams (HPW20) and Giant UNO NFL (HPY63) | 112 cards "including a Special Rule card": **Wild Ice The Kicker**. "When you play this card, the next player in order must successfully 'kick a field goal' or draw 3 cards. If the 'football' goes between the 'goalposts,' the kick is good! If it does not, the kick is no good and they must draw three cards. This card is also a wild card, so you choose the color that resumes play." The kicker flicks a paper football (folded from the instruction sheet) through goalposts that another player makes with their hands, about two feet away. Scores 50. 2-10 players. | HIGH (sheets HPW20, HPY63) |
| UNO Super Bowl LVII (HPW22) | 112 cards "including a Special Rule card": **Wild Touchdown!** "When you play this card, every other player must quickly raise their arms and signal a touchdown! The last player to do so must draw 3 cards. This card is also a wild card, so you choose the color that resumes play." Scores 50. | HIGH (sheet HPW22). The survey doc's "signal touchdown or draw 3" is CONFIRMED. |
| Super Bowl LIX (#466, 2025) | Mattel pre-sold Chiefs and Eagles versions and shipped only the winner's (Eagles). Toy Insider: "a special Super Bowl Touchdown rule" and one collectible foil card per pack. No Mattel sheet online. The Touchdown rule is presumably the LVII Wild Touchdown! text above. The "extra card" is the collectible foil. | MED (Toy Insider); the LIX rule text itself is UNVERIFIED |
| Fandom NFL Dallas Cowboys (HYH50) | 113 cards: 112 with a Special Rule card, plus 1 foil, "an alternate version of the Wild Hail Mary Card that is unique to this deck". If you use the foil, remove the regular Wild Hail Mary. **Wild Hail Mary**: "When a player is down to their last card and yells 'UNO!', it's time to throw up a prayer and immediately play the Hail Mary card. First, name a color. If that is the color of the player's last card, you get to discard down to 1 card. Play then continues with the player to your left in the color you chose. If multiple people try to play a Hail Mary at the same time, it goes to the player who gets their card to the discard pile first." | HIGH (sheet HYH50) |
| Fandom NFL scoring quirk | HYH50 scores ALL number cards at 5 points (not face value); actions 20; Wilds 50. | HIGH (sheet HYH50) |
| Other Fandom NFL teams (JDK16 Browns, etc.) | No sheet online. Presumably the same Hail Mary format. | UNVERIFIED |
| Fandom line format | Classic deck + one special rule card + one collectible foil. | HIGH (Mattel press + sheet HYH50) |

### Edge cases & rulings (NFL)
- Ice The Kicker and Touchdown are physical dexterity/reaction rules. In a digital port, model Touchdown as a reaction race (the slowest responder, or the AI with the longest simulated delay, draws 3) and Ice The Kicker as a skill check or a random chance with a 3-card miss penalty. Flag both as adaptations.
- Wild Hail Mary is an out-of-turn interrupt that fires when ANOTHER player calls UNO. The holder names a color. If it matches the UNO caller's last card, the Hail Mary player discards down to 1 card. The sheet's wording "you get to discard down to 1 card" reads as the Hail Mary player benefiting, and play continues to the left of the Hail Mary player. Which cards are discarded (player's choice?) and where they go are not stated. Suggested: the player chooses which to keep, and the discards go under the discard pile. Flag as house-defined. In an engine this needs an interrupt window right after any UNO call.

---

## 4. Liar's UNO (#475), sheet JLH43 (2025)

| Card / rule | Spec | Confidence |
|---|---|---|
| Contents / players | 112 cards, 2-6 players, 7+. | HIGH (sheet JLH43) |
| Liar's Cards | "More than half the deck is made up of 'Liar's Cards.' Each Number Card in every color has one Regular Card and one Liar's Card, and almost all the Action Cards are Liar's Cards!" Regular Cards are always played FACE UP; Liar's Cards are always played FACE DOWN. | HIGH (sheet JLH43). CORRECTED: pass 1 said number cards only. Action cards are Liar's cards too. |
| Actions | "All Action cards (except the Wild Liar's Challenge Card) are Liar's Cards and you MUST play them FACE DOWN." Action set: Draw Two, Reverse, Skip, Wild Draw 4, Wild Liar's Challenge (no plain Wild in the scoring list). Wild Draw 4 here has NO legality challenge: "the next player must draw 4 cards and lose their turn." | HIGH (sheet JLH43) |
| Playing a Liar's Card | If it matches the top card, play it face down and say what it is (the truth). If it doesn't match, play it face down and LIE, "However, your lie must be plausible": the claim must be a legal play on the top card (any card of the same color, a matching number, or "even a Wild Draw 4!"). | HIGH (sheet JLH43) |
| Cheating with a Regular Card | "You MAY NOT play a Regular Card face down and try to pass it off as a Liar's Card. If you get caught doing so, you must take the card back and draw 6 cards!" | HIGH (sheet JLH43) |
| Who may challenge, and when | "After you play a card FACE DOWN, any player may challenge you. If no one challenges you before the next player begins their turn, you're safe." | HIGH (sheet JLH43) |
| Unchallenged | "If you said the card was an Action Card, the action takes effect whether you were lying or not." | HIGH (sheet JLH43) |
| Challenge: truth | "If you were telling the TRUTH, the player who challenged you must draw 1 card." | HIGH (sheet JLH43) |
| Challenge: lie | "If you were LYING, you must take the card back AND draw 1 card." The caught card returns to the liar's hand. | HIGH (sheet JLH43) |
| Winning | "When a player plays their final card, if no one challenges them, they win. If challenged and caught lying, they must take their card back, draw 1 card as a penalty and then play continues." | HIGH (sheet JLH43) |
| Special rules (always on) | "7's Swap: When you play a 7 card of any color, you MUST swap your hand with another player of your choice." "0's Pass: ALL players must pass their hand to the next player in the current direction of play." "If a 7 or 0 is challenged, the penalty card is drawn AFTER any exchange of hands." | HIGH (sheet JLH43) |
| Wild Liar's Challenge | Always played FACE UP. You choose a color. All other players put a card of that color face down and announce it. Wilds don't count. Anyone without that color may put down any card but MUST claim it is that color. You may challenge players one at a time; a caught liar takes their card back and draws 1. You continue until you have challenged everyone or reveal someone who told the truth. Then that player and all unchallenged players put their cards under the Wild Liar's Challenge card, and play continues in your color. "If someone discards their LAST card this way, they win (if multiple players go out, they win TOGETHER)." | HIGH (sheet JLH43) |
| Starter card | "If it's a Liar's Card, treat it as a normal card." | HIGH (sheet JLH43) |
| Scoring | Numbers face value; Skip/Reverse/Draw 2 = 20; Wild Draw 4 / Wild Liar's Challenge = 50. | HIGH (sheet JLH43) |

### Edge cases & rulings (Liar's)
- Still not on the sheet: (a) if several players want to challenge at once, who goes first (suggested: first to speak, or for the AI, the next player in turn order first); (b) whether a successful bluff's CLAIMED identity is what the next player must match (implied yes, since the claim must be plausible and unchallenged actions take effect); (c) whether a challenge may come after a claimed action has already taken effect (the window runs until the next player BEGINS their turn, and a claimed Skip/Draw Two hits that player, so the engine must open the challenge window before applying the claimed action).
- Engine model: a face-down play stores {actual, claimed}. The top-card identity for matching is `claimed` until revealed. On a caught lie, return the card to the liar's hand (sheet), revert the top card to the previous discard, and draw 1. For a 7/0 claim, apply the hand exchange first and the penalty draw after (sheet).
- Last card: the challenge window must close before the win is decided (sheet: "if no one challenges them, they win").

---

## 5. UNO Cricket (India) (#229)

UNVERIFIED. Mattel's instruction-sheet search returns no Cricket or India-specific UNO, and Wikipedia's UNO article does not list one. There is still no evidence for the survey doc's Four/Six/Wicket/Over card list or its run-scoring loop. Recommend marking #229 "existence/mechanics unverified".

## 6. UNO X Games (#234)

UNVERIFIED. No Mattel sheet, and no Wikipedia mention. Every "Wild Draw 10" hit belongs to UNO Show 'em No Mercy, so the survey doc's "Wild Draw 5/10, discard-down-to-5" list is probably conflated with No Mercy. Do not implement from the current description.

## 7. UNO WWE: Locked Up (FNC47), Wild Payback (JKH98, 2025); WWE Legends "1-2-3"; NASCAR "Drafting"

| Card | Spec | Confidence |
|---|---|---|
| WWE UNO (FNC47) contents | 112 cards: 19 of each color (0-9), 8 each of Draw Two / Reverse / Skip, 4 Wild, 4 Wild Draw Four, and **4 Locked Up**. That is the standard 108 plus 4 Locked Up cards; there is no separate "Special Rule card". Older-style rules: 500-point game; the deck's own WD4 challenge wording (guilty → challenged player draws 4; innocent → challenger draws 6). | HIGH (sheet FNC47). CORRECTED: pass 1 said "a Special Rule card". |
| Locked Up (FNC47) | "When you play this card, choose another player and then the two of you are locked into a battle, and only one will survive. First, both players pick a high value number card (0-9) from their hand. Next, both players reveal their cards at the same time. Whoever has the LOWEST card must take BOTH cards back into their hand! This card is also a wild card, so the player who played it chooses a color that resumes play. If this card is turned up at the beginning of play, the person to the left of the dealer chooses the color that begins play." Scores 50. | HIGH (sheet FNC47). The survey doc's #232 "lower takes both" is CONFIRMED. |
| UNO WWE 2025 (JKH98), NEW | 112 cards, 2-10 players, 7+. Classic rules (modern WD4 challenge: guilty → you draw 4; innocent → challenger draws 6). Special card **Payback** (scored as "Wild Payback", 50 pts): "When you play this card, all other players must reveal their hands and discard any Wild Cards they have. Wild Cards are placed at the bottom of the Discard Pile, and players then draw the same number of cards from the Draw Pile. If a player has no Wild Cards, they are safe and take no action. This is also a Wild Card, so the player who played it gets to choose a color to continue play." Number of Payback copies: not stated (112 − 108 standard suggests 4, unconfirmed). | HIGH (sheet JKH98); copy count MED |
| 1-2-3 (WWE Legends) | No sheet, nothing found. | UNVERIFIED |
| NASCAR Drafting (#233) | Mattel lists no NASCAR UNO at all. | UNVERIFIED |

### Edge cases & rulings (WWE)
- Locked Up, still undecided by the sheet: ties (suggested: both keep their own card, nothing happens, or both draw 1; label as house rule), and a duelist with no number card (suggested: they automatically lose and take the opponent's card). "Pick a high value number card" is advice, not a requirement: any number card may be chosen. The winner's chosen card leaves their hand (into the loser's hand), so winning a duel is net −1 card.
- Payback: "discard any Wild Cards" includes Wild Draw 4 and any other Wild-type card. Discards go to the BOTTOM of the discard pile (they do not change the top card), and each affected player draws one replacement per Wild. Hand size stays the same; only the Wilds are lost. Payback does not hit the player who played it.

---

## 8. UNO Party! (#30) and the Ubisoft "Party Mania!" DLC (#386)

| Element | Spec | Confidence |
|---|---|---|
| SKUs | HMY49 "UNO Party Pack" (2022 sheet): 224 cards, 6-16 players. JJV58 "UNO Party" (2024-25 reissue): 168 cards, 6-14 players. Same rules text in both. | HIGH (sheets HMY49, JJV58). The pass-1 conflict is resolved: two SKUs. |
| Extra cards | A Direction Tracker card (flip it whenever a Reverse is played) and Link Cards (for Drawn Together). Remove both before shuffling. | HIGH (sheets) |
| Turn | "On your turn, try to get rid of all your cards by playing ONE CARD onto the Discard Pile." Otherwise classic (modern WD4 challenge: guilty → you draw 4; innocent → challenger draws 6). | HIGH (sheets) |
| Speed Play | "If you have a NUMBER CARD in your hand that matches both the Number AND Color of the card on the top of the Discard Pile, you may play your card out of turn. Play then continues from you. But you better be quick; if the player whose turn it is plays first, you are out of luck. NOTE: if you accidentally play a NON-MATCHING card you must take back the card PLUS draw one card from the Draw Pile." | HIGH (sheets). Note: NUMBER cards only, with a misplay penalty. |
| Point Taken (colored action, 20 pts) | "Count down out loud from 3…2…1! On '1', ALL players point at 1 other player. Count how many fingers are pointing at each player, then each player in turn order must draw as many cards as there are players pointing at them (up to 5)." | HIGH (sheets). New: the draw is capped at 5. |
| Wild Pile Up (50 pts) | "Take the top card from the Draw Pile and place it face up in front of you to create a mini-pile (If the card is Wild, add another card until you get a non-Wild Card). The next player must play a card of the same color (Wild Cards count but DO NOT change the color and matching Action Cards may be played but DO NOT take effect) and pass the mini-pile to the next player, and so on. Finally, when the mini-pile reaches a player who can't play a card, the WHOLE mini-pile goes into their hand! Play continues from them with the next player in current turn order. NOTE: The color that was used in the mini-pile is the color that continues play, you DO NOT get to choose the color." | HIGH (sheets) |
| Wild Drawn Together (50 pts) | "Select two players and place a Link Card in front of both of them, then choose the color that continues play. Moving forward, every time one of these players must draw card(s), the other player draws the same amount. If two players are already linked, choose two new players. The Drawn Together link ends when a Point Taken Card is played." Only one link exists at a time; a new Drawn Together moves it. The sheet doesn't forbid choosing yourself ("select two players"). | HIGH (sheets). Duration resolved: until a Point Taken is played (or the link is moved). |
| Scoring | Numbers face value (HMY49 prints "(1-9)", JJV58 "(0-9)"); Skip/Reverse/Draw 2/Point Taken = 20; Wild/Wild Draw 4/Wild Drawn Together/Wild Pile Up = 50. | HIGH (sheets) |
| Teams | No team play on either sheet. Remove the team claim. | HIGH (absent from both sheets) |
| Copies of each special card | Not stated on the sheets (text extraction). | UNVERIFIED |

### Edge cases & rulings (Party!)
- Point Taken: everyone, including the card's player, points at one OTHER player, so self-pointing is not allowed (sheet). Cap 5 per player. If Point Taken is played while two players are linked, the link ends. Suggested order: break the link before resolving the Point Taken draws, so the linked mirror doesn't apply (the sheet doesn't specify; flag it).
- Drawn Together: a linked draw does not chain, because only one link pair exists. A mirrored draw should not itself trigger a mirror back (no recursion).
- Pile Up: matching is by the mini-pile's color only (not number). Actions inside it are inert. Wilds count but don't change the color. The loser takes the whole mini-pile, and play continues from them in the mini-pile's color. Pile Up doesn't say whether the receiving player also loses their turn. "Play continues from them with the next player" means they do not get to play.

---

## 9. UNO & Friends companions: skipped (no budget).

---

## Cross-mechanic interaction notes

1. **Ultimate "Draw" vs standard Draw-card stacking.** In Ultimate, "Draw" = take from your OWN Character Deck and lose your turn; "Add" doesn't lose it, and neither does the ordinary no-match draw (sheet). With Stacking on, a stacked +2/+4 total comes from the victim's personal deck and brings them closer to elimination. Recommendation: one "lose turn" event per resolved stack. This matches the official Skip note that a second lose-turn effect on someone already losing a turn "is ignored", so Superman's Impervious fires once.
2. **Superman + Skip/Stacking/Jump-In.** Impervious triggers on Skip effects and Draw penalties. Being bypassed by a Jump-In is NOT losing a turn (official Ultimate has no Jump-In). A Skip Everyone (No Mercy toggle) would fire every Superman at once; resolve them in turn order.
3. **Thor / Aquaman / Doctor Strange / She-Hulk + color changes.** These trigger on "When you change the active color" (Thor and Aquaman sheet text; Strange and She-Hulk from their blurbs). Only the character's own color changes count. A 7-0 hand swap doesn't change color. Jump-In and Party Speed Play need an exact color match, so they never change color. Aquaman's trap is "until the start of your next turn": the first OTHER player to change color burns 2, then it's spent.
4. **Proton Cannon + Danger flip order.** Settled by the sheet's turn sequence: the on-play power (burn) resolves before Battle and before the Danger flip. If a Danger-icon card is jumped in out of turn (house toggle), the jumper flips the Danger card and an Enemy attacks the jumper.
5. **On-defeat powers vs Enemy replacement.** Officially, replacement "does NOT count as defeating". A newly flipped Enemy can't be defeated the turn it arrives. If a Jump-In card pays the jumper's own Enemy's cost, recommend it still defeats that Enemy (Battle step is tied to the play).
6. **Enemy ongoing effects vs standard toggles.** Loki (Thor's Enemy) forbids Reverse cards, which also blocks a Reverse-to-deflect stacking house rule. In 2 players, Loki's on-flip reversal does nothing. King Shark's "Your Wild Cards read as blank" means Wilds lose their printed effect but still match and change color (MED reading). Madam Masque ("only Number cards") blocks stack responses entirely.
7. **Elimination vs Stacking/No Mercy.** Ultimate eliminates when the Character Deck runs out; No Mercy eliminates at 25+ cards in hand. Define one elimination check after a penalty fully resolves, and stop drawing at an empty deck (no reshuffle).
8. **Personal draw piles vs every shared-deck mechanic.** Ultimate has no shared draw pile, so Party!'s Pile Up, Liar's penalties, Locked Up, Point Taken, Drawn Together and Payback must all draw from the drawer's own Character Deck. Payback's "Wild Cards are placed at the bottom of the Discard Pile" still works with the shared discard pile. Engine needs `drawSourceFor(player)`.
9. **Green Lantern's Construct Creation + Liar's UNO.** Burn Pile cards are face up and public, so a Burn-Pile play can never be a face-down bluff.
10. **Liar's UNO + Stacking.** Liar's action cards ARE face-down (sheet), so a fake Draw Two or fake Wild Draw 4 is legal and, if unchallenged, "takes effect whether you were lying or not". With Stacking on, a stack can include fakes. Recommendation: the challenge window for each face-down card closes before the next player may respond with a stacked card. A successful challenge then unwinds only that card's contribution. Note that Liar's WD4 has no colour-legality challenge, only the lie challenge.
11. **Liar's UNO + 7-0.** 7-0 is always on in Liar's UNO (sheet). Official timing: if a 7 or 0 is challenged, "the penalty card is drawn AFTER any exchange of hands". So the swap/pass happens on play, and the caught liar takes their card back into the hand they now hold. Implement it exactly that way. Pass 1's "resolve challenge before effect" recommendation is superseded for 7/0. For other claimed actions, the challenge window still has to close before the action lands (see Liar's edge cases).
12. **Speed Play (Party!) vs Jump-In.** Not identical: Speed Play allows NUMBER cards only, and has a misplay penalty (take back + draw 1). Implement it as the Jump-In toggle with a "numbers only" flag and the penalty, not as a pure alias.
13. **Drawn Together + Stacking/No Mercy.** The linked partner of a stack victim draws the full stacked amount. With No Mercy's 25-card elimination, that can eliminate a bystander. Recommend an option to cap the mirror draw. Only one link exists at a time (sheet), and a Point Taken ends it.
14. **Pile Up + Stacking.** Actions inside a Pile Up mini-pile "DO NOT take effect" (sheet), so Draw cards can't stack inside it. Forbid starting a Pile Up while a draw stack is open (one pending pile at a time).
15. **Point Taken in small games.** Party is officially 6-16 (HMY49) / 6-14 (JJV58). At 2 players it degenerates into each player drawing 1. Gate it behind a player-count check or label it "weak below 6" (this engine maxes at 4).
16. **Elite NFL Player Card actions + standard toggles.** A Player Card's Draw icon makes a player "Draw the number of UNO cards indicated", and activating a Player Card ends your turn. Recommendation: a power-sourced draw is NOT stackable (it doesn't come from a played Draw card); resolve it immediately. Play Again + 7-0 or Jump-In: Play Again is an immediate extra turn for the activator, so close any Jump-In window first.
17. **Locked Up + Jump-In / 7-0.** During the duel no other plays are allowed, and a duelist's chosen card must not be stealable by a 7-0 swap. Resolve the duel atomically.
18. **Character powers + Jump-In timing.** Powers that say "during your turn" or "once per turn" (Cosmic Energy, Construct Creation) are not usable on a Jump-In play. Construct Creation also REPLACES your hand play, so it can never be combined with a Jump-In.
19. **Captain Marvel's Cosmic Energy + Wild Draw Four challenge.** She changes the color BEFORE playing, so the WD4 legality check must use the color AFTER her power. Standard Ultimate decks have no WD4, so this only matters when mixing modes.
20. **Elite Wild Foil "all four colors" + color-based Defeat Costs.** Confirmed: a Wild Foil counts as all 4 colors for ACTIVATION (sheet). Lineup cards are never played to the discard pile, so they never pay an Ultimate defeat cost or count for matching.
21. **Wild Hail Mary (Fandom NFL) + UNO-call mechanics.** Hail Mary is an interrupt triggered by an opponent's UNO call. If the engine auto-calls UNO for AI or human players, it must still open a Hail Mary window. With Jump-In or Speed Play on, the Hail Mary resolves first ("immediately").
22. **Payback (WWE 2025) + No Mercy / Liar's.** Payback strips other players' Wilds, including any No Mercy Wild Draw 6/10 or Liar's Wild Challenge cards in a mixed deck, and they draw replacements. With Drawn Together, each replacement draw is mirrored to the linked partner, which is probably unintended. Recommend that replacement draws do not trigger links.

---

## Gaps (still open after the sheet pass)
1. Exact power text: Black Widow (only a fragment), Hulk (partly hidden), and every add-on character (Spider-Man, Doctor Strange, Scarlet Witch, Miles Morales "Spider Sense", Ms. Marvel, She-Hulk, Loki, Ant-Man, and the non-sheet packs). The add-on sheets carry only strategy blurbs.
2. Wild card text for the Marvel 2nd Ed and DC decks (only Silent Strike and Ends of the Earth are known). Full Danger lists for 2nd Ed and DC. Defeat costs for most 1st Ed Enemies.
3. Thanos promo (#395): no sheet, no text.
4. Elite NFL: individual Player Card icon sets (e.g. Mahomes, Kelce). Whether Viper, Kaleidoscope or Hypnotic parallels have any rule effect (the sheet suggests not).
5. Super Bowl LIX's printed rule text (presumed the same as LVII's Wild Touchdown!). Other Fandom NFL team decks (JDK16 has no sheet).
6. Cricket (India), X Games, WWE Legends 1-2-3, NASCAR Drafting: no Mattel sheet and nothing found. Mark unverified in the survey doc.
7. UNO Party!: copies of each special card. The Payback copy count in UNO WWE (JKH98).
8. Liar's UNO: challenge priority when several players want to challenge.
