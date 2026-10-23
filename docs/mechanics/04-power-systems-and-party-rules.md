# Final review 4: character/power systems, scoring variants, themed action sets

> Reference spec for `docs/gameversions.md` (see its Part F). Gathered from web-search snippets only; direct page fetches were blocked during research, so treat anything below HIGH as needing a check against the official instruction sheet before shipping.

Research method: WebSearch snippets only (35 queries; WebFetch/curl blocked). No primary PDF was readable in
full, so "exact wording" below means wording quoted in a snippet (usually from gamerules.com, RulesPal, a
Mattel instruction-sheet snippet, or a review). Confidence: HIGH = 2+ independent sources agree, MED = one
detailed plausible source, LOW = thin or inferred. "NOT FOUND" means the search turned up nothing usable, and
any existing claim in docs/gameversions.md on that point should stay unverified.

Primary documents that exist, if someone can open them outside this sandbox:
- UNO Ultimate Marvel 1st Ed: rulespal.com/uno-ultimate-marvel/rulebook; gamerules.com/rules/uno-ultimate-marvel/ (+ per-character pages -iron-man, -thor, -captain-marvel)
- UNO Ultimate Marvel 2nd Ed: rulespal.com/uno-ultimate-marvel-2nd-edition/rulebook
- UNO Ultimate DC: service.mattel.com/instruction_sheets/HRF37-Eng.pdf; rulespal.com/uno-ultimate-dc/rulebook; opinionatedgamers.com/2023/11/30/dale-yu-review-of-uno-ultimate-dc-version/
- Mattel UNO Ultimate FAQ: shop.mattel.com/pages/games-uno-ultimate-faqs
- UNO Elite NFL: service.mattel.com/instruction_sheets/JDM38-Eng.pdf
- UNO Party!: service.mattel.com/instruction_sheets/JJV58.pdf
- UNO WWE (2017): Mattel sheets JCW36 / JCW37 came up for the query but the snippets lacked the Locked Up text. Which product those codes are is unconfirmed.
- Liar's UNO: geekyhobbies.com/liars-uno-rules/; zatu.com/blogs/reviews/liar-s-uno-review

---

## 1. UNO Ultimate Marvel (1st Ed 2022, 2nd Ed), UNO Ultimate DC, expansions, Thanos promo (#56-73, #395)

### 1.1 Core rules (shared by Marvel 1st/2nd Ed and DC)

| Rule element | Spec | Confidence |
|---|---|---|
| Win condition | Two ways to win: (a) be first to empty your hand, or (b) be the last player with cards left in your Character Deck. | HIGH (RulesPal, gamerules, TTPM, Mattel DC sheet) |
| Character choice | Each player picks one character and plays with that character's own Character Deck, which has its own power and its own Wild cards. Powers "can be used on EVERY TURN". | HIGH |
| Setup: Danger Deck | Each player takes the purple Enemy and Event cards out of their Character Deck. All players' Enemy/Event cards are combined and shuffled into one shared Danger Deck. 2nd Ed: the Danger Deck has 32 cards and adds Item cards. DC: Event, Enemy, Item and Location cards. | HIGH (1st Ed), MED (2nd Ed 32-card count, DC Location) |
| Setup: hands | The Character Card goes face up in front of you where others can see it. Shuffle the rest of your Character Deck, take 7 as your hand, and keep the rest face down as your personal draw pile. There is no shared draw pile. | MED (RulesPal snippet) |
| First game | 1st Ed (gamerules) says not to shuffle everything together for the first game. 2nd Ed (RulesPal) says to unwrap decks without shuffling the first time. Both are pre-built learning orders; ignore them in a digital port. | MED |
| Character Deck size | NOT CONFIRMED. A 112-card box split across 4 characters would mean 28 per character including that character's Danger cards, but no source states it. | LOW (inference) |
| Keyword "Add" | Take the stated number of cards from YOUR Character Deck into your hand. You do NOT lose your turn. | MED (RulesPal) |
| Keyword "Draw" | Take the stated number from your Character Deck draw pile, and the drawing player loses their turn. | MED (RulesPal) |
| Keyword "Burn" | Move cards from the top of your own Character Deck straight into your personal face-up Burn Pile, without seeing or keeping them. Burning is the main attack: it drains the deck that keeps you alive. | HIGH (Goonhammer, gamerules, TTPM) |
| Burn Pile | Personal and face up. Some powers recover cards from it (Black Panther) or play cards from it (Green Lantern). | HIGH |
| Danger icon | Some colored cards carry a Danger icon. When a card with a Danger icon is played to the center pile, the next Danger card is flipped and resolved. Who it targets (the player who played the card, or the next player?) is NOT in the snippets. Reading the Iron Man and Black Panther strategy text (hold Danger cards and play them to bring Enemies out, then defeat them), the flip most likely affects the player who played the icon card. | HIGH (flip on play); LOW (who it targets) |
| Event card | Resolve immediately, then discard. No lasting presence. | HIGH |
| Enemy card | The Enemy "is now attacking your character" and sits in front of you. Max ONE Enemy per player. If you reveal a new Enemy while you already have one, the new one replaces the old one. Each Enemy lists (1) an on-reveal effect, (2) an ongoing rule change while it attacks you, and (3) a Defeat Cost: the kind of card you must play to defeat it. When the card you play pays the Defeat Cost, the Enemy is defeated and discarded. The 2nd Ed rulebook has a separate section on "Defeat Cost Symbols". | HIGH (the mechanism); exact symbol list NOT FOUND |
| Item card (2nd Ed, DC) | Exists. Effects NOT FOUND. Probably a persistent bonus kept in front of a player (inferred from the name). | MED (exists) / LOW (behaviour) |
| Location card (DC) | Exists. Aquaman's power depends on how many Locations he has in play. | MED |
| UNO call penalty | Failing to call UNO and being caught before the next player starts their turn: draw 2 cards from your Character Deck. | MED |
| Card text vs rules | When a card's text contradicts the main rules, the card wins. | HIGH |
| Elimination | Implied by the win condition: a player whose Character Deck is empty is out. The exact trigger is NOT FOUND (empty after a Burn? only when you must Draw/Add from an empty deck?). | MED (implied) / LOW (trigger timing) |
| Foils | 4 special foil cards per box; more come in other base sets and the expansions (collectible). | MED (Opinionated Gamers) |

### 1.2 Character roster and powers

| Product | Character | Power (snippet wording) | Deck-specific Wild cards found | Confidence |
|---|---|---|---|---|
| Marvel 1st Ed | Iron Man | **Proton Cannon**: "When you play a card with a danger symbol, all other players burn 1 card." | Power Drain: other players cannot use their character powers until the start of your next turn. Repulsor Blast: in the current order of play, all other players flip a Danger Card and do what it says. Reactor Burn: all other players Add 1 card. Unibeam Barrage: all other players burn 3 cards. | HIGH for the power (gamerules + Opinionated Gamers); MED for the Wilds (gamerules) |
| Marvel 1st Ed | Thor | Power is triggered only by a color change. gamerules lists **Lightning Charge**: changing the active color makes the next player burn 2 cards. If a Wild is played without changing the active color, only the Wild's effect happens and the power does not trigger. | Thunder Plunder: a chosen player skips their next turn. Bifrost Blow: a chosen player burns cards equal to the number of Enemies attacking everyone. Asgard Assault: a chosen player Adds 1 and burns 1. Mjolnir's Revenge: defeat an Enemy attacking you, and the next player burns 1. | MED (gamerules only). "Lightning Charge" may be the power name or a card name. |
| Marvel 1st Ed | Captain Marvel | **Cosmic Energy**: "Once per turn, before you play a card, you may add 1 card to change the active color to a color of your choice." | Photonic Beam, Seventh Sense, Higher Further Faster, Cosmic Fusion (effects NOT FOUND). | MED |
| Marvel 1st Ed | Black Panther | "When you defeat an Enemy, recover 2 cards from your Burn pile." (Recovered to where, the hand or the Character Deck, is NOT FOUND.) | Card names seen in listings: Kinetic Absorption (Common, may be the power name), Wakanda Forever, Energy Dagger, Vibranium Armor (rainbow foil). Effects NOT FOUND. | MED-HIGH for the power (2 sources agree on what it does) |
| Marvel 2nd Ed | Shuri, Black Widow, Hulk, Captain America | Powers NOT FOUND. | NOT FOUND | MED for the roster (RulesPal 2nd Ed rulebook). Retail listings labelled "2nd Edition" name the 1st Ed four instead, so sources conflict. Trust the rulebook. |
| DC core | Superman | "When you lose your turn, choose a player to burn 2 cards." Reviews call it a reactive power: stay alert when someone tries to skip you. | "balanced set of utility Wild Cards" (names NOT FOUND) | MED. The snippet warned that the sheet layout made the power-to-character mapping ambiguous, but the "skip" review hint fits Superman. |
| DC core | Wonder Woman | "When you defeat an Enemy, choose a player to add 1 card and burn 1 card." Strategy: play "!" (Danger) cards to bring Enemies out, then defeat them. | NOT FOUND | MED |
| DC core | Green Lantern | "During your turn you may burn 2 cards and play a card from your Burn Pile." Willpower theme. | NOT FOUND | MED |
| DC core | Aquaman | Power scales with the Locations he has in play. Exact text NOT FOUND. | NOT FOUND | LOW-MED |
| DC core | Batman / Joker | NOT in the core box (every source lists Superman, Aquaman, Wonder Woman, Green Lantern). Batman and Harley Quinn exist only as add-on packs (#72-73), and their powers were NOT FOUND. No playable Joker was found. | n/a | HIGH that they are not in the core box |
| Marvel expansions | Ms. Marvel, Spider-Man, Loki, Ant-Man, Shang-Chi, Dr. Strange, Scarlet Witch, She-Hulk, Miles Morales, Spider-Gwen, Spider-Man 2099, Venom, Rocket, Groot, Mighty Thor | NOT FOUND. Spider-Man and Ms. Marvel packs confirmed: each pack is a complete Character Deck with its own Wilds and Danger cards. A reviewer says some Spider-Man Wild and Danger wording is "slightly confusing". | NOT FOUND | HIGH that packs = 1 full Character Deck + its Danger cards; no power text found |

### 1.3 Danger cards found

| Card | Type | Effect | Confidence |
|---|---|---|---|
| Loki | Enemy (comes with Thor's deck) | On reveal: reverse the direction of play. While attacking you: you cannot play Reverse cards. Defeat Cost: a red or green card. | MED (gamerules) |
| Skrull(s) | Enemy (Captain Marvel's deck) | On reveal: change the active color to a color of your choice. Ongoing effect and Defeat Cost NOT FOUND. | LOW-MED |
| Thanos promo (#395) | Presumably an Enemy | NOT FOUND. Searches returned only other Thanos games (Marvel United, Love Letter, Crisis Protocol). The survey doc's "standing penalty until defeated" fits generic Enemy behaviour but is not verified for Thanos. | LOW |

Note on #61 "Loki Expansion Pack": in the core box, Loki is an ENEMY in the Danger Deck. A Loki add-on pack would make him a playable character. Confirm before cataloguing: either the pack is a playable Loki, or it is mis-titled.

### Edge cases & rulings (Ultimate)
- Thor: a Wild played without changing the active color does not trigger the power. Only an actual color change counts (MED). Choosing the same color does not count as a change.
- Iron Man's power triggers on playing ANY Danger-icon card. Order of resolution against the Danger flip itself is NOT FOUND. Suggested engine order: resolve the played card's normal effect, then the Danger flip, then on-play character powers. Expose this as a config constant.
- Enemy replacement: a new Enemy discards the old one with no defeat, so "on defeat" triggers (Black Panther, Wonder Woman) do NOT fire. This follows from "replace" (MED inference).
- "Draw" loses the turn and "Add" does not. Every penalty in a character power uses Add or Burn, never Draw, so those penalties do not skip anyone's turn.
- Personal draw piles mean there is no shared-deck reshuffle. Running out of cards means elimination, not a reshuffle.
- Mattel publishes an Ultimate FAQ, and the DC sheet says new cards and rules will be added over time (latest instructions via QR code). Rules have been revised; treat the snippet wording as possibly pre-errata.

---

## 2. UNO Elite NFL (#408-409, #467-474)

| Element | Spec | Confidence |
|---|---|---|
| Base deck | Per the Mattel press release (Aug 2024): 112 cards that play like regular UNO, plus 56 Player Cards featuring NFL players with one or more actions, plus 4 foil cards. | MED-HIGH |
| Where actions live | Normal UNO actions such as Skip and Reverse are printed on the NFL Player Cards, not in the main deck. | HIGH (JDM38 sheet + retailers) |
| Unlock trigger | Sheet: "Whenever you play a card with an 'Elite' Icon you may activate the power of an NFL Player Card from your 'Lineup'." Retailers add that the color must match: the power activates when a card with an Elite icon of the player card's color is played. | HIGH (trigger); MED (color-match requirement) |
| Lineup composition | Each player has 4 Base Player Cards, 4 Base Color Foil Cards (one each of red, blue, green, yellow), 2 Dual Color Foil Cards and 1 Wild Foil Card. | MED (blowoutcards break, quoting the rulebook) |
| Dual Color Foil | Has 2 colors (Green/Blue or Red/Yellow) and can be activated by an Elite card of either color. | MED (quoted from the rulebook) |
| Wild Foil / "Wild Viper" | Exists ("special Wild Viper Cards"). The survey doc says it counts as all 4 colors. This research pass did not re-confirm that, but it matches the Wild slot in the lineup. | LOW-MED |
| Point values | The sheet's examples show Player Cards with values like "+2" (Jalen Hurts, Cooper Kupp). Their purpose (lineup cap? end-of-game scoring?) is NOT FOUND. | LOW |
| Is a power used up? | Whether a Player Card can fire again after use (exhaust/flip?) is NOT FOUND. | LOW |
| Rarity tiers (Viper, Kaleidoscope, Hypnotic) | Kaleidoscope foils are mentioned only as a rarer pull in 2025 boxes. No source gives Kaleidoscope or Hypnotic any rule effect. Treat them as cosmetic. | LOW (absence of evidence) |
| Example powers | NOT FOUND (no Mahomes or Kelce text). | n/a |
| UNO call | Standard: call UNO at one card. | HIGH |

### Edge cases & rulings (Elite)
- The activation is "may". It is optional and one per Elite-icon play (MED).
- Since Skip and Reverse live on Player Cards, an Elite game with no lineup has no basic actions. In an engine, model this as "action effects come from a lineup lookup keyed by color", not as a deck change.
- Dual-color foils match the color of the Elite card played, not the current discard color (MED, from "activated by playing an Elite card of either color").

---

## 3. UNO Fandom NFL / UNO NFL team decks (#218-224, #440-466)

| Element | Spec | Confidence |
|---|---|---|
| Fandom line format | Each Fandom deck = classic deck + "a special rule specific to that deck theme and one collectible foil card". | HIGH (Mattel press) |
| "Touchdown" rule | Confirmed to EXIST: a Walmart listing for an "UNO NFL LVII ... with Special 'Touchdown' Rule" and Toy Insider's Super Bowl LIX coverage, "a special Super Bowl Touchdown rule". Text NOT FOUND. The survey doc's "signal touchdown or draw 3" is UNVERIFIED. | HIGH (exists) / LOW (effect) |
| Super Bowl LIX (#466) | Mattel pre-sold Chiefs and Eagles versions, and only the winner's (Eagles) shipped; losing-team preorders were refunded. Includes the Touchdown rule. An extra card beyond that was NOT FOUND. | MED-HIGH (logistics) / LOW (extra card) |
| Related, different rule | UNO NFL all-32-teams deck (HPW20): an "Ice the Kicker" rule where players try to flick a paper football through a goalpost made by another player's hands. A physical-dexterity rule. Do not merge it with Touchdown. | MED |
| Related foil | One Mattel sheet (HYH50; product unknown, NFL-adjacent) describes a foil that is "an alternate version of the Wild Hail Mary Card unique to this deck". A "Wild Hail Mary" card therefore exists in some football UNO deck. Effect NOT FOUND. | LOW-MED |

### Edge cases & rulings (Fandom NFL)
- A digital port can only implement a "Touchdown" toggle as a placeholder (e.g. a call-out/reaction prompt with a draw penalty) until the text is verified. Flag it as house-defined.

---

## 4. Liar's UNO: Trust No One (#475)

| Card / rule | Copies | Effect | Confidence |
|---|---|---|---|
| Regular number card | 1 of each number per color | Plays normally, face up. | MED (GeekyHobbies: "one Regular Card and one Liar's Card of each number and color") |
| Liar's number card | 1 of each number per color (so the number cards are doubled: half Regular, half Liar's) | Marked with a white circle in the corners. MUST always be played face down. When playing it, you announce what card it is, truthfully or not. | HIGH (GeekyHobbies, Play-in, Kmart, Avid Reader) |
| Action/Wild cards | NOT FOUND (the deck presumably keeps standard actions) | | LOW |
| Starter card | If the first discard flipped is a Liar's Card, treat it as a normal card. | MED (GeekyHobbies) |
| Challenge | After a Liar's play, opponents decide whether to challenge ("ask you to reveal the card you played"). | HIGH |
| Caught lying | The liar draws (Play-in: "you draw a card"). | HIGH that the liar draws; MED that it is exactly 1 card |
| Wrong challenge | The challenger draws instead. | HIGH (Zatu, CVS, Kmart) |
| UNO call | Still applies. | HIGH |

### Edge cases & rulings (Liar's)
- NOT FOUND, needing house decisions: (a) which opponents may challenge (anyone? first to speak? only the next player?); (b) what happens to a caught lie's card (returned to hand, or left on the pile with the claimed identity cancelled?); (c) whether the claim must be a legal match for the current top card (presumably yes, since you announce a card that "plays"); (d) whether a successfully bluffed card keeps its CLAIMED identity for the next match (presumably yes, the claim becomes the top card); (e) whether the penalty is more than 1 card.
- Suggested engine model: a face-down play stores {actual, claimed}; the top-card identity used for matching is `claimed` until revealed; on a successful challenge, revert the top card to the previous discard and return the card to the liar's hand, plus the penalty draw. Flag (b) as house rule.
- Last card: if a player's final card is a Liar's card played as a lie and nobody challenges, they win. The challenge window must close before the win is decided.

---

## 5. UNO Cricket (India) (#229)

NOT FOUND. Two targeted searches turned up only generic cricket card games (armchair cricket, pagat) and Mattel India listings for other decks (one 112-card India deck with "3 Customizable cards and 1 Special Rule card"). There is no evidence for the survey doc's Four/Six/Wicket/Over card list or its run-scoring-to-500 loop. Confidence that the product's mechanics are described correctly: LOW. Recommend downgrading #229 in the doc to "existence/mechanics unverified", or finding a box photo.

## 6. UNO X Games (#234)

NOT FOUND. Two searches turned up nothing on an X Games UNO. Every hit for "Wild Draw 10" belongs to UNO Show 'em No Mercy, so the survey doc's "Wild Draw 5/10, discard-down-to-5" list may be conflated with No Mercy. Confidence: LOW. Do not implement from the current description.

## 7. UNO WWE "Locked Up" / WWE Legends "1-2-3" / UNO NASCAR "Drafting"

| Card | Spec | Confidence |
|---|---|---|
| Locked Up (WWE 2017, 112 cards incl. a Special Rule card) | The player who plays it chooses another player to "lock into battle. Only one will survive!" Retail listings name it alongside Skip, Reverse, Draw Two and Wild. Resolution NOT FOUND. The survey doc's #232 entry says both reveal/compare a card and the lower value takes both into hand. | HIGH (exists + target choice); MED at best (resolution) |
| 1-2-3 (WWE Legends 2006) | NOT FOUND. | LOW |
| NASCAR Drafting (#233) | NOT FOUND (no NASCAR UNO surfaced at all). | LOW |

### Edge cases & rulings (Locked Up)
- Undecided: which card each player commits (highest number? player's choice? top of draw pile?); ties; what counts if a player has no number card; whether Locked Up also counts as a Wild for matching.
- Suggested default: each duelist chooses a number card face down, both reveal, the lower takes both cards into hand, and ties go to both drawing 1. Label as house rule.

---

## 8. UNO Party! (#30) and the Ubisoft "Party Mania!" DLC (#386)

| Element | Spec | Confidence |
|---|---|---|
| Player count | Mattel JJV58 listing: 6 to 14 players. Launch news (2022) and listing HMY49: up to 16. | Conflict, both HIGH-sourced: report both |
| Card count | JJV58 sheet: 168 cards. TTPM review and HMY49 listing: 224 cards. Possibly two SKUs/regions. | Conflict |
| Turn | "On your turn, try to get rid of all your cards by playing ONE CARD onto the Discard Pile." | HIGH |
| Point Taken | Everyone points at another player at once. Each player draws as many cards as there are fingers pointed at them. | HIGH (Mattel listing + news) |
| Drawn Together (Wild Drawn Together in DLC) | The player who plays it chooses two OTHER players and links them. Whenever one linked player draws a card, the partner must draw too. How long the link lasts is NOT FOUND (presumably until the end of the hand, or until a new link is made). | HIGH (effect) / LOW (duration) |
| Pile Up (Wild Pile Up) | Starts a mini discard pile that circles the table. Each player must match it and add to it. The first player who cannot takes the whole pile. | HIGH |
| Speed Play | A player may play out of turn if their card matches both number and color of the top discard, "if they are fast enough". This is Jump-In under another name. | HIGH |
| Teams | NOT FOUND. No source mentions team play in UNO Party!. The team claim should be removed or flagged as unverified. | LOW |
| Copies of each special card | NOT FOUND. | LOW |

### Edge cases & rulings (Party!)
- Point Taken: needs a rule for a player with no target, and in a digital port, AI target selection (likely "point at the leader"). Pointing at yourself is presumably not allowed.
- Drawn Together chains: if A is linked to B, and B is also linked to C by a second card, a single draw could cascade. Rule needed: a linked draw does not itself trigger further links (no recursion).
- Pile Up: it is unclear whether matching follows the mini pile's top card or the original card, whether action cards in the mini pile trigger their effects, and whether Draw cards add their penalty on top of the pile. Suggested: the mini pile's top card governs matching, actions are inert inside it, and the loser takes all cards.

---

## 9. UNO & Friends companions: skipped (no budget).

---

## Cross-mechanic interaction notes

1. **Ultimate "Draw" vs standard Draw-card stacking.** In Ultimate, "Draw" = take from your OWN Character Deck and lose your turn, and "Add" doesn't lose it. With Stacking on, a stacked +2/+4 total gets drawn from the victim's personal deck, which also brings them closer to elimination. Decide whether a stacked penalty counts as "Draw" (loses turn) for powers like Superman's "when you lose your turn". If so, every stack loser who plays Superman fires a 2-card burn. Recommendation: one "lose turn" event per resolved stack, not one per card.
2. **Superman + Skip/Stacking/Jump-In.** "When you lose your turn" fires on Skip, on Draw-and-lose-turn, and on being jumped over? Recommend: being bypassed by a Jump-In is NOT losing a turn. Only Skip effects and Draw penalties count. A Skip Everyone (No Mercy toggle) would fire every Superman at once, so resolve in turn order.
3. **Thor + 7-0 / Wild color choice.** Thor's power fires on an active-color change. Count changes from his own Wild only, from any card he plays that changes color by matching number, or also changes caused by others? Snippet: triggered by "changing the active color". A 7-0 hand swap doesn't change color. With Jump-In, a jump-in card of the same number but a different color is impossible (Jump-In needs an exact match), so no conflict there. Speed Play (Party!) is also exact match. Recommendation: trigger only when Thor is the player whose play changes the color.
4. **Iron Man's Proton Cannon + Jump-In.** If a Danger-icon card is jumped in out of turn, does the Danger flip and the burn still happen? Recommendation: yes, effects tie to the play, not the turn. But then it becomes ambiguous who the Danger flip targets ("the player who played it" is the safe definition).
5. **Black Panther / Wonder Woman "on defeat" vs Enemy replacement.** Replacement is not defeat. Also, if a Jump-In card pays an Enemy's Defeat Cost out of turn, recommend that it still defeats the Enemy (for the card owner only, since Enemies attack only the player they sit in front of).
6. **Enemy ongoing effects vs standard toggles.** Loki forbids playing Reverse. If Stacking allows Reverse-to-deflect (some house rules), Loki blocks the deflection. In 2-player games where Reverse acts as Skip, Loki's on-reveal reversal should do nothing. Reverse inside a 7-0 hand swap direction rule: Loki's reversal changes the direction a 0-card rotation uses.
7. **Elimination vs Stacking/No Mercy.** Ultimate eliminates on an empty Character Deck, and No Mercy eliminates at 25+ cards in hand. With both on, a player could hit both conditions in one stack. Define one elimination check after the penalty fully resolves. Note the cards drawn come from the personal deck: an empty deck mid-draw should stop the draw and eliminate, not reshuffle.
8. **Personal draw piles vs every shared-deck mechanic.** Ultimate has no shared draw pile, so Party!'s Pile Up, Liar's penalties, Locked Up's "loser draws", Point Taken and Drawn Together must all draw from the drawer's own Character Deck. Elite NFL and the others use a shared deck. Engine needs `drawSourceFor(player)`.
9. **Green Lantern playing from the Burn Pile + Liar's UNO.** Can a Burn-Pile card be played face down as a bluff? Recommend no: a Burn Pile is face up, so its identity is public.
10. **Liar's UNO + Stacking.** A face-down card claimed as a Draw Two (if Liar's ever applies to actions; currently number-only per source) could fake a stack. Recommend that Liar's cards be numbers only, as the sources indicate, so they never enter a stack. Also, the challenge window must close before Jump-In is allowed on the claimed card. Otherwise someone jumps in on a fake identity, and a later successful challenge would have to unwind two plays.
11. **Liar's UNO + 7-0.** A face-down "7" or "0" claim triggers a hand swap/rotation. If the claim is later caught, hands have already moved. Recommend: resolve the challenge window BEFORE applying the claimed card's effect.
12. **Speed Play (Party!) == Jump-In.** Implement as one toggle with a display alias. Party!'s exact-match condition (number AND color) is the standard Jump-In condition.
13. **Drawn Together + Stacking/No Mercy.** A linked partner of a stack victim draws the full stacked amount as well. Combined with No Mercy's 25-card elimination, that can eliminate a bystander. Recommend capping the mirror draw (or mirroring only voluntary draws) as an option.
14. **Pile Up + Stacking.** Both build a pile that "the first player who can't continue takes". Pile Up while a draw stack is open: forbid starting a Pile Up mid-stack (one pending-pile at a time).
15. **Point Taken in 2 players.** It degenerates into each player drawing 1. Party! requires 6+ players. Gate it behind a minimum-player check, or note that it is weak at 2-4 seats (this engine maxes at 4).
16. **Elite NFL Skip/Reverse on Player Cards + standard toggles.** If Stacking assumes Draw cards exist in the main deck but Elite moves actions onto Player Cards, an activated "Draw 2" power: does it start a stack? Recommend that a power-sourced draw be stackable only if a matching-color Draw card can answer it. Otherwise resolve immediately.
17. **Locked Up + Jump-In / 7-0.** During the duel, no other plays (jump-ins) are allowed. A duelist's committed card must not be stealable by a 7-0 swap. Resolve the duel atomically.
18. **Character powers + Jump-In timing in general.** Powers that say "during your turn" or "once per turn" (Captain Marvel's Cosmic Energy, Green Lantern) should not be usable on a Jump-In play. A Jump-In isn't your turn, and after the jump play turn order continues from the jumper.
19. **Captain Marvel's Cosmic Energy + Wild Draw Four challenge.** She can change the active color before playing, so a Wild+4 legality check ("no card of the current color") must use the color AFTER her power changes it.
20. **Elite NFL Wild/Viper "all four colors" + 7-0 or color-based Enemies.** If a Wild Foil counts as every color, it satisfies any color-based Defeat Cost (e.g. Loki's red-or-green) if the two systems were mixed. Decide whether a lineup card's color affects matching (it shouldn't: lineup cards are never played to the pile).

---

## Gaps (highest value to close with a real PDF/browser)
1. Exact power text for the Marvel 2nd Ed four (Shuri, Black Widow, Hulk, Captain America), Aquaman, and all 17 expansion characters.
2. The Danger icon's target player, the Defeat Cost symbol list, and Item card behaviour (RulesPal 2nd Ed page).
3. Ultimate Character Deck size, and the exact elimination trigger.
4. Elite NFL: lineup point values or cap, whether powers are reusable, any real player power text, and Viper's effect.
5. Fandom NFL Touchdown text; Super Bowl LIX extra card.
6. Liar's UNO: who may challenge, and what happens to a caught card.
7. Cricket, X Games, WWE 1-2-3, NASCAR Drafting: nothing found. The survey doc's entries for these should be marked unverified.
8. UNO Party!: team play is unverified (likely not real), and the 168- vs 224-card / 14- vs 16-player SKU split.
