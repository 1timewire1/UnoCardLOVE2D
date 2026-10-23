# Final review 5: loose-end MECHANIC rows

> Reference spec for `docs/gameversions.md` (see its Part F). Gathered from web-search snippets only; direct page fetches were blocked during research, so treat anything below HIGH as needing a check against the official instruction sheet before shipping.

> **Sheet verification pass (2026-10-23):** service.mattel.com was reachable for this pass, so every row below that has an official Mattel instruction sheet was checked against it.
> - Items marked **"(sheet CODE) HIGH"** quote the sheet directly.
> - Items marked **UNVERIFIED** have no Mattel sheet. For Sonic, Pokémon, Coca-Cola, Cobs, UNO Master and NDJOLIJEAN, Mattel's site has no product page, or the page has no sheet. Those items keep their earlier web-snippet confidence.
> - The Fandom line is covered separately in `08-fandom-line.md`.

Method: WebSearch snippets only (WebFetch/curl blocked). About 42 searches were used, a little over budget.
Confidence: HIGH means 2+ independent sources agree. MED means one detailed, plausible source. LOW means thin or inferred.
"Fan wiki" means matteluno.fandom.com unless another wiki is named.

---

## *#21 Uno Mario Kart (Mattel GWM70)
- **Doc claim:** "Item-Box wild cards (5 effects)."
- **Found:** 112-card deck containing **8 "Wild Item Box" cards**. Every card shows an ITEM icon in the corner, and the icon is tied to the card's color. Items do nothing during normal play. When someone plays a Wild Item Box, they flip the top card of the draw pile and immediately apply that card's item:
  - **Mushroom** (red cards): play again / take an extra turn.
  - **Banana Peel** (yellow cards): the **previous** player (the one just before you in the current direction) draws 2.
  - **Green Shell** (green cards): choose any opponent to draw 1.
  - **Lightning** (blue cards): all opponents draw 1 each, then the Item Box player takes another turn.
  - **Bob-omb** (Wild cards): the Item Box player draws 2 and chooses the color that continues play.
  - If a Wild Item Box is the starting discard, the dealer chooses the starting color.
- **Confidence:** HIGH for the mechanism and the color-to-item mapping (gamerules.com, Geeky Hobbies, rulespal and the fan wiki agree). MED-HIGH for the per-item effects, which come from the fan wiki's two pages and match the gamerules summary ("another turn / choose an opponent to draw 1 / make everyone else draw 2"). One conflict: the gamerules phrase "everyone else draw 2" doesn't match the wiki's Banana = previous player draws 2. The wiki is the more specific source.
- **Still open:** whether the flipped card goes back on top of the draw pile or is discarded. The official sheet is service.mattel.com/instruction_sheets/GWM70-Eng.pdf.
- **Sources:** gamerules.com/rules/uno-mario-kart; matteluno.fandom.com/wiki/Wild_Item_Box_Card; geekyhobbies.com (Mario Kart rules); rulespal.com/uno-mario-kart/rulebook.
- **Verdict:** Doc row is right but too vague. Replace it with the list above.
- **SHEET-VERIFIED (sheet GWM70) HIGH:**
  - **Deck:** 112 cards = 76 numbers + 8 Draw Two + 8 Reverse + 8 Skip + **4 Wild Draw Four + 8 Wild Item Box**. There are **no plain Wild cards**.
  - **Where the flipped card goes:** "take the top card from the Draw Pile and place it face-up on the Discard Pile." It becomes the new top card: "WHEN PLAY CONTINUES, MATCH THE TOP CARD ON THE DISCARD PILE AS USUAL." The Item Box player does **not** name a color, except through Bob-omb.
  - If the flipped card is an action card (Draw Two, Reverse, Skip, Wild Draw 4), "you DO NOT TAKE THE ACTION on the card, you ONLY take the action associated with the Item."
  - **Item effects, exact text:**
    - MUSHROOM: "Take another turn" (if you can't play, you still draw as normal).
    - BANANA PEEL: "The player in current order whose turn was immediately BEFORE you must draw two cards". A player who was skipped still counts.
    - GREEN SHELL: "Any player of your choice must draw one card".
    - LIGHTNING: "All players EXCEPT you must draw one card. Then you get to immediately take another turn".
    - BOB-OMB: "you must draw two cards … since the top card on the Discard Pile is a Wild card, you get to choose the color".
  - A starting Item Box: "the person to the left of the dealer chooses the color".
  - Scoring: Item Box 50. A wrongly challenged Wild Draw Four challenger draws 6.
  - **Not on the sheet:** the item-to-color mapping (Mushroom = red, etc.) is not printed. The sheet only implies Bob-omb sits on Wild cards. Keep the mapping at MED (fan wiki).

## *#26 Uno Super Mario (HJC89, 112 cards)
- **Doc claim:** "Super Star" counters plus customizable wilds.
- **Found:**
  - **2 Super Star cards.** Each is a Wild. If you play it in response to a Draw Two or Wild Draw Four aimed at you, the player who played that draw card must draw the 2 or 4 instead. The Super Star player names the next color. Worth 50 points.
  - **2 Wild Customizable cards.** Blank and erasable; you write your own rule before the game. Worth 50 points.
  - Deck math: 76 numbers + 24 actions + 4 Wild + 4 WD4 + 2 + 2 = 112.
  - An older mariowiki revision describes a different split ("two Invincible Mario and two White Mario" cards, 108 standard cards). This probably refers to an earlier printing or is an outdated page.
- **Confidence:** HIGH for card counts and for Super Star as a deflect/bounce wild (mariowiki, rulespal, Diabolical Plots review). MED on edge cases. It is unconfirmed whether a Super Star can be bounced back by another Super Star, and whether it works against a stacked penalty.
- **Sources:** mariowiki.com/Super_Mario_UNO; rulespal.com/uno-super-mario/rulebook; diabolicalplots.com review; shop.mattel.com HJC89.
- **Verdict:** Right, needs detail. "Counters" means a reflect: the original player takes the draw. It does not cancel the draw.
- **SHEET-VERIFIED (sheet HJC89; the sheet is internally labeled DRD00-0970, so it is the same rules as the 2016 DRD00 deck) HIGH:**
  - Deck: 112 = 76 numbers + 24 actions + 4 Wild + 4 Wild Draw Four + **2 "Mario Super Star" + 2 "Mario Customizable"**.
  - Super Star, exact text: "Play this card whenever an opponent plays a Draw +2 or Draw +4 card on you and bounce the power right back at them. Now they have to draw +2 or +4 cards! This card is also a wild card, so you choose the color."
  - Customizable: "Use a #2 pencil to write any house rule … the cards are erasable". It is a Wild.
  - Both are worth 50 points. A starting Super Star or Customizable: the player left of the dealer picks the color.
  - Still open (the sheet is silent): Super Star vs Super Star, and Super Star vs stacking. Stacking isn't in these rules at all.

## *#6 Uno 50th Anniversary Premium Set (HBF05)
- **Doc claim:** "50/50" card, coin flip decides who draws 4 extra.
- **Found:**
  - The set includes **4 "Wild 50/50" cards** and a 50th Anniversary gold coin.
  - When you play a 50/50, you **choose two players** and assign one to heads and one to tails. You then flip the coin, and the loser of the flip draws 4.
  - It is a Wild, so the player names a color.
  - Worth 50 points.
- **Confidence:** HIGH for "coin decides who draws 4" (Mattel product copy, Ubisoft DLC, Nintendowire). MED for the "choose two players, assign heads and tails" procedure (fan wiki only).
- **Still open:** whether the card's player may name themselves as one of the two. The official sheet is service.mattel.com/instruction_sheets/HBF05-Eng.pdf, and a manualshelf mirror exists.
- **Sources:** matteluno.fandom.com/wiki/Wild_50/50_Card; nintendowire.com 2021-06-03; nintendo.com DLC page; service.mattel.com HBF05-Eng.pdf.
- **Verdict:** Right, needs detail on the two-player selection.
- **SHEET-VERIFIED (sheet HBF05) HIGH:**
  - Deck: 112 = 76 + 24 + 4 Wild + 4 Wild Draw Four + **4 Wild 50/50**, plus 1 gold coin.
  - Exact text: "When you play this card, choose 2 players and then you decide which one will be 'Heads' and which one will be 'Tails' (if it's a two-player game, you will either be 'heads' or 'tails'). Next, flip the UNO® 50th Anniversary gold coin … (the 'UNO' side of the coin is 'Heads' and the '50/50' side is 'Tails'). If the coin comes up 'Heads,' the 'Tails' player must draw FOUR cards, and vice-versa. This card is also a Wild card, so you choose the color".
  - A starting 50/50: the player left of the dealer picks the color. Worth 50 points.
  - No skip is attached.
  - **Answer to the open question:** the card's player *may* be one of the two. The text says "choose 2 players" without excluding yourself, and in a 2-player game you must be one of them. Engine: allow self-inclusion.

## *#7 Nonpartisan Uno (Walmart exclusive, Nov 19 2019)
- **Doc claim:** "Veto" out-of-turn interrupt card.
- **Found:**
  - Orange and purple replace red and blue. The box is purple.
  - The **VETO card** shows the word "POLITICS" under a no or stop symbol. Coverage disagrees on the exact art.
  - Rule as reported: **if anyone starts talking politics during the game, any player may grab the Veto card and play it on that person. This skips the offender's next turn, and they must change the subject.** One outlet says the card is handed to the offender.
  - The trigger is a real-world conversation, not a game state. It has no defined timing relative to card play: "anyone can grab it" at any moment.
  - The copy count is not stated. It reads like a single shared card rather than a card dealt into hands.
- **Confidence:** HIGH for the effect "skip the offender's next turn" (CNN, KARE11/WUSA9, ClickOrlando and others all agree). LOW for any exact timing rules, because none were found.
- **Sources:** cnn.com 2019-11-19; wusa9.com / kare11.com; clickorlando.com 2019-11-20; matteluno.fandom.com/wiki/Nonpartisan_Uno.
- **Verdict:** Right as far as it goes. This is an **honor-system / unenforceable** card in the same category as the doc's "Unenforceable" row (Wild Don't Talk, etc.). A digital version could be a "skip target player's next turn, playable anytime" interrupt. The doc should move it to the honor-system category rather than treat it as a real game-state interrupt.

## *#96 Uno Cobs Game Changers (Australia, Mar 16 to Apr 1 2018)
- **Doc claim:** five named cards.
- **Found:**
  - This was a promotion with **13 different single cards**, one per specially marked Cobs Popcorn pack, meant to be shuffled into a standard deck (Inside FMCG).
  - Effects found (fan wiki unless noted):
    - **All Draw Two** (also listed as "Everyone Draws Two"; red only): every player draws 2. The wiki is unclear on whether this includes the card's player.
    - **Wild Draw Eight**: the next player draws 8 and loses their turn. Also confirmed by trade press as a "draw eight wild card".
    - **Wild Face Up**: everyone plays the rest of the game with their hand face-up.
    - **Wild Shuffle 'Em Up**: per the wiki, every player discards their whole hand, then draws the same number of cards from the discard pile. The wiki page is badly written, so the wording is suspect.
    - **See The Future**: listed in the set, but no effect was found. It presumably means looking at the top N cards of the draw pile, but that is unverified.
  - Other named cards from trade press, not in the doc:
    - a **Deflection card**: play it any time to bounce a card back onto the player who played it.
    - a **"Popcorn card"**: a real-world snack perk, only that player may eat the popcorn for one round.
  - The remaining 6 cards are unknown.
- **Confidence:** HIGH for the promotion (Inside FMCG, foodanddrinkbusiness, Convenience World). MED for Draw Eight. LOW-MED for Face Up, All Draw Two and Shuffle 'Em Up. LOW for See The Future.
- **Sources:** insidefmcg.com.au 2018-03-21; foodanddrinkbusiness.com.au; matteluno.fandom.com/wiki/Uno_Cobs_Game_Changers and the per-card pages.
- **Verdict:** The doc's list is incomplete (5 of 13). It should add Deflection and Popcorn and flag that 6 cards are unknown.
- **UNVERIFIED (no Mattel sheet):** this was an Australian retail promotion with no service.mattel.com entry. Nothing changes.

## *#428 Uno Expo 2025 (Japan, Ensky licensed; Myaku-Myaku art)
- **Doc claim:** "WORLD" wild restricts play to one color until a Wild or Wild Draw Four is played.
- **Found:**
  - 112 cards, including **4 original special-rule "WORLD" cards**.
  - The player who plays WORLD **declares red or blue** (Myaku-Myaku's colors). Until a Wild or Wild Draw Four is discarded, players may only discard red or blue cards, Wilds, or WORLD cards. A Wild or Wild Draw Four ends the effect.
  - The retailer wording is ambiguous on whether play is limited to the declared color only or to red and blue together. The literal text reads "red or blue cards".
- **Confidence:** MED (one detailed Japanese retailer listing).
- **Sources:** store.shopping.yahoo.co.jp listings (cast-shop od31806910, school-supply z27r1r12); amiami TOY-023507; hobbystock.
- **Verdict:** Mostly right. Add that the declared color is restricted to **red or blue** (not any color), and that WORLD cards can also be played during the restriction.

## *#400 "Uno Master"
- **Doc claim:** probably shorthand for Masters of the Universe's "Power of Greyskull" card.
- **Found:**
  - This is the real **UNO Master (Electronic)** by Spear's Games / Spear-Spiele (Mattel), 1997, mfr #52452 per the earlier finding.
  - It is standard UNO with an **electronic "UNO Master" timer** to keep play continuous. The timer has three skill levels: **8 s (easy), 6 s (medium), 4 s (hard)**.
  - On your turn you must play or draw a card and then press the red button before your time runs out. **If you're late, you draw 4 extra cards.**
  - The fan wiki also says it was known as "Uno Time" or "Uno Slam".
  - 2 to 10 players, about 20 minutes.
- **Confidence:** HIGH (BoardGameGeek #124363, spielregeln.tv, okkazeo.com, fan wiki, eBay.de all agree).
- **Sources:** boardgamegeek.com/boardgame/124363/uno-master; spielregeln.tv/uno-master; okkazeo.com/jeux/view/3153/Uno-Master; matteluno.fandom.com/wiki/Uno_Master; ebay.de/p/1223458896.
- **UNVERIFIED (no Mattel sheet):** Mattel's site has no "UNO Master" product. Searching "uno master" returns only the MOTU decks GVY91/JMF11 and "Disney Pixar Cars UNO Master Game" M2279, which is a different product. Earlier confidence stands.
- **Verdict:** **WRONG.** Masters of the Universe already has its own rows, #149 and #330. #400 is the 1997 electronic turn-timer game. The mechanic is a per-turn timer (8/6/4 s) with a draw-4 penalty, which fits the doc's existing timer row (Uno Rush) as a turn-timer option.

## #22 Uno The Office (GVH29)
- **Found:**
  - The "Kevin's Famous Chili" card is a **Wild**. When it is played, all players must drop their hands (cards) on the table. **The last player to drop their cards draws 2.**
  - The player who played it then names the color.
  - If it is the starting card, the player to the dealer's left picks the color.
  - Press coverage calls it "Kevin Malone's Famous Chili".
- **Confidence:** HIGH (Mattel GVH29 sheet snippet, Walmart, Entertainment Earth, TVWeb).
- **Verdict:** Right. Add "Wild, chooser names color". Digitally this is a reaction race, last to tap draws 2.
- **SHEET-VERIFIED (sheet GVH29) HIGH:**
  - Deck: 112 = 76 + 24 + 4 Wild + 4 Wild Draw Four + **4 Wild Kevin's Famous Chili**.
  - Colors are **pink, blue, green and yellow**. Pink replaces red.
  - Exact text: "When you play this card, everyone must IMMEDIATELY drop all their cards. The last person to drop their cards must then draw two cards from the Draw Pile! This card is also a wild card, so you choose the color that resumes play."
  - Starting card: the player left of the dealer picks the color. Worth 50 points.
  - The text says "everyone", so the player of the card is also in the race.

## #32 Sonic (HGJ78/HJG14) / #33 Minecraft (FPD61) / #34 Pokémon
- **#32:** "**Wild Victory Lap**" card: when played, all other players draw 1. It is a Wild. HIGH (Entertainment Earth and hobbyDB). Doc right; add "Wild".
  - **UNVERIFIED against a sheet, and the code is wrong:** on service.mattel.com, **HGJ78 is "UNO® Dragonball Z"**, whose card is "Wild Shenron's Wish" per Mattel's own copy. Its sheet is a scanned image with no text. **HJG14 has no product page.** Mattel's site has no Sonic UNO at all. Drop "HGJ78/HJG14" from #32. The Victory Lap effect stays at its earlier snippet confidence.
- **#33 SHEET-VERIFIED (sheet FPD61; HJC88, the 2021 reissue, has the identical text) HIGH:**
  - Deck: 112 = 76 + 24 + 4 Wild + 4 Wild Draw Four + **4 Creeper Cards**.
  - Exact text: "When you draw this card from the Draw Pile, you must immediately show it all the other players. Next, you have to draw 3 additional cards from the draw pile and add them to your hand. If one of these 3 additional cards is ALSO a Creeper card, DO NOT show it to the other players, simply keep it in your hand and use it as you would a regular wild card. The Creeper Card is also a wild card".
  - Worth 50 points.
  - **The DRAWER draws 3.** Mattel's own es-MX store copy ("los demás jugadores deben robar tres cartas") is wrong against the sheet.
  - Still unstated: whether the trigger applies during the opening deal or during a penalty draw. The literal "draw this card from the Draw Pile" covers penalty draws.
  - Note: UNO Cars has a *different* "Victory Lap" card. Everyone places their hand face down and passes it to the next player, and only the card's player may look and choose to keep or pass. The doc should not confuse the two.
- **#33 Creeper card:**
  - It acts as a **Wild** when played from hand.
  - Its special rule triggers when it is **drawn** from the draw pile: you must immediately show it to everyone, then **you (the drawer) draw 3 more cards**. You then keep the Creeper.
  - Per one rules site, if a second Creeper is among those 3 cards, it isn't triggered and just counts as a Wild.
  - Conflict: some retailer copy (Walmart) says "the other players have to draw three". Mattel's own copy says only "show it to all the other players". unorules and minecraft.wiki-type sources say the drawer takes 3.
  - Score is reported as 50 points by one source and 20 by another.
  - MED overall; who draws needs confirmation.
  - Doc row "forced reveal + draw 3" is right but ambiguous. Specify "drawer draws 3 (some copy says opponents)".
- **#34 "Trainer" full hand swap:** no corroboration found in 3 searches. LOW. The only Mattel Pokémon special cards found are the Japanese Snorlax/Greninja pair (see #35). A forum mentions an older Sun & Moon deck with "Ash's Pikachu" and "Ditto" special change-color cards.
  - Verdict: **unverified, possibly wrong.** Flag the row LOW.
  - **UNVERIFIED (no Mattel sheet):** service.mattel.com has no Pokémon UNO product, and the same applies to #35. Nothing changes.

## #35 Uno Pokémon (Asia) (Mattel Japan GNH17, Feb 2020, Sword & Shield art)
- **Found** (Mattel Japan official page, summarized via GAME Watch):
  - **Snorlax (カビゴン):** played like a Wild on anything. The player declares a color. The **next player draws 3 from the pile, then discards all their cards of the declared color.** Play then passes on.
  - **Greninja (ゲッコウガ):** played like a Wild. The **next player draws from the pile until a card of the declared color appears.** Then the player who played Greninja declares the color again.
  - The copy count is not stated. The product title says "with special rule cards Snorlax & Greninja".
- **Confidence:** MED-HIGH (mattel.co.jp product page plus GAME Watch article; the translation of the Snorlax effect was checked from the snippet).
- **Sources:** mattel.co.jp/toys/mattel_games/mattel_games-10988; game.watch.impress.co.jp/docs/news/1233203.html; nintendowire 2020-01-06.
- **Verdict:** Fill in the effects. The Snorlax "draw 3 then dump a color" wording is odd, since dumping a color helps the victim. Double-check the original Japanese before implementing.

## #36 Harry Potter and the Sorcerer's Stone / #388 Harry Potter (2003)
- **Found:**
  - **Mattel #42797** (manualshelf "Mattel Uno - Harry Potter 42797" manual; 2003 blog review; WorthPoint "2000 Mattel Special Edition") is the 2000-era Sorcerer's Stone edition. Its special cards:
    - **Howler Wild:** the player picks someone who must **recite every card in their hand** aloud. The Howler player then names the color. It may be played any time, even if you have another playable card. Geeky Hobbies adds that the targeted player loses their turn, and also the next player; the manual doesn't say this.
    - **Invisibility Cloak Wild:** play it to **cancel any Action card played on you** (Draw 3, WD4, Reverse, Skip, Howler), then name a new color.
  - In this edition the **Draw Twos are Draw Threes**.
  - Both special Wilds are redrawn if turned up as the starting card.
  - The **"Wild Voldemort"** card (discard all your Harry-image cards, i.e. 2/6/9s, last one sets color) belongs to the 2005/2010 deck (#175/#176).
  - The **Sorting Hat / Gryffindor draw-until** card belongs to the 2018 FNC42 deck (#177/#178).
- **Confidence:** HIGH that 42797 = Howler/Cloak (Mattel manual mirror, 2003 review, Geeky Hobbies, WorthPoint). HIGH that the Sorting Hat card is FNC42 (Mattel product page).
- **Sources:** manualshelf.com/manual/mattel/uno-harry-potter-42797; michaelhans.com/eclecticism/2003/07/05/harry-potter-uno; geekyhobbies.com/harry-potter-uno-card-game-review-and-rules; worthpoint "2000 Mattel"; shop.mattel.com FNC43 / creations FNC42.
- **Verdict:**
  - **#36 is WRONG.** It mixes cards from the 2005/2010 and 2018 decks. Replace it with Howler, Invisibility Cloak and Draw 3.
  - **#388 is WRONG.** #42797 does not have the Sorting Hat card.
  - #36 and #388 are very likely **the same product** (2000 release, still sold or reviewed in 2003). Merge them.
- **SHEET-VERIFIED (sheet 42797, all three English PDFs identical) HIGH:**
  - **110 cards** = 76 numbers + **8 Draw 3** + 8 Reverse + 8 Skip + 4 Wild + 4 Wild Draw Four + **1 Howler™ card (Wild) + 1 "Invisibility card (Wild)"**. Each special is **one copy**. The card is named "Invisibility", not "Invisibility Cloak".
  - The dealer is the player whose birthday is closest to 31 July.
  - Howler, exact text: "The person playing this card chooses anyone at the table to 'shout out' every card that they hold in their hand. Following that, the person who played the Howler™ calls for any color to continue play … Howler cards can be played at any time – even if the player has another playable card in hand." Starting card: return it and flip another.
  - "When someone is called on to shout out their cards, they may play an INVISIBILITY WILD … to cancel the effect of the Howler™. In this event, the person who plays the Invisibility Wild calls for any color".
  - Invisibility, exact text: "This is a safety card. A player can play this card to cancel the effect of any Action Card that has been played on them. They call for any color … This card can also be played as a standard Wild card." Starting card: return it.
  - **There is no turn loss on the Howler.** Geeky Hobbies' "target loses a turn" is not on the sheet.
  - Scoring: Draw 3 = 20, Howler and Invisibility = 50 each.
- **Related HP decks:**
  - **T8231** (the 2010 "40th Anniversary" tin), sheet HIGH: 112 cards with **4 Voldemort cards**. "When you play this card, you also get to discard all of the cards in your hand that feature Harry Potter's image (#2, #6, #9). Whichever Harry card you place on the top of the discard pile determines the color/number that continues play. You can even go out … but you must remember to yell 'UNO!' before you discard your final card. If you do not have any Harry cards, you can also play the Voldemort card like a regular Wild card". Confirms #175/#176.
  - **FNC42 / FNC43** (2018), sheet HIGH: 112 cards with **4 Wild Sorting Hat**. "choose another player and then that player must draw from the draw pile until they get a Gryffindor card. This card is also a wild card, so the player who played it chooses a color". The sheet does not define a "Gryffindor card". The doc's "1/2/3/4 of any color" is not on the sheet.
  - **42751** (an earlier HP UNO): its sheet is a scanned image with no extractable text, so it remains unverified.

## #40 Uno H2O
- **Found:** two new Wilds, **"Wild Downpour Draw 1" and "Wild Downpour Draw 2"**. When played, **all other players draw 1 or 2** respectively, and the player names the color. The fan "board game manuals" wiki calls them Wild Draw 1 / Wild Draw 2. UNO H2O Splash (2005) uses the same deck plus first-to-3-hands.
- **Confidence:** HIGH (BGG, rulespal). Copy count not found.
- **Verdict:** Right, needs detail. It is "all others", not just the next player.
- **SHEET-VERIFIED (sheet H3263, ©2004) HIGH:**
  - **108 cards.** No per-card counts are printed, so the Downpour copy count is still unknown.
  - The **object is "The first player to win three hands wins the game"**, not 500 points.
  - Exact text: "If a Wild Downpour One or a Wild Downpour Two card is played, all other players must either draw one or two cards depending on which Wild Downpour card is played. The player of the card may also call a new colour and play continues in the current direction." There is no skip.
  - The H2O Wild Draw 4 text has no challenge clause.

## #42 Uno Monster High, plus #261/#262/#397/#426
- **Found:**
  - The only confirmed bespoke card in the base Monster High UNO is **Creeperific "Urrrhhh"** (Wild x4, per #262's instruction sheet T8233). You pick a color from your hand and hand those cards out one at a time, clockwise starting on your left, until that color runs out, muttering "Urrrhhh". You then choose the color. Worth 50 points.
  - unorules dates this to the "original 2011" edition. The doc says 2013 (T8233). These may be one product, with the 2011/2013 difference being a release vs. reprint date.
  - I could **not** find a second bespoke Wild matching "multi-discard + share".
  - Fandom decks: **#397 (2024) "Frankie's Hand"** and **#426 (2025, JFP08) "Fearbook"** (the Fearbook rule is confirmed on Mattel's JFP08 page). BGG has "UNO: Monster High" #277452, a later (around 2019) deck, effect unknown.
- **Confidence:** HIGH for Creeperific. LOW that a second Wild exists.
- **Verdict:** #42 is probably the same product as #262. Its "color give-away" half = Creeperific. Its "multi-discard+share" half is unverified and may be a duplicate description of the same card. Recommend merging #42 into #262 and leaving #261 (2017) unresolved.
- **SHEET-VERIFIED (sheet T8233, two text versions: T8233-Eng and "T8233 Monster High Uno rules 1"; the packaging proof is T8233-0619) HIGH:**
  - **©2011.** Deck: 112 = 76 + 24 + 4 Wild + 4 Wild Draw Four + **4 Creeperific "Urrrhhh" Cards**.
  - Colors are **blue, green, pink and yellow**. Pink replaces red.
  - Exact text: "Discard this card and choose a color from your hand that you want to give away. Then, starting with the player to your left and going clockwise, give one card to each player in order until you run out of cards of that color … It's okay if players do not receive the same number of cards. This card is also a Wild card, so you call the color".
  - Worth 50 points.
  - **There is no second special card** in any T8233 version, so #42's "multi-discard+share" Wild is not on the sheet. The date is 2011 (the "2013" in #262 is wrong or a reprint).
  - Note that the hand-out is always "to your left, clockwise", whatever the current direction.
  - The 2024 Fandom Monster High (HYH54, "Wild Frankie's Hand") and Fearbook (JFP08) decks are covered in `08-fandom-line.md`.

## #199 Uno Coca-Cola (2004)
- **Found:** "**Thirst card**". The player who plays it chooses any other player, who **draws until they draw a red number card or a Wild**. That card is put straight onto the discard pile. The Thirst player then names the next color.
- **Confidence:** MED (one source, tarsasjatekok.com, quoting the English rule text; BGG/kallax confirm the 2004 date).
- **Verdict:** Doc is vague; fill in the effect.
- **UNVERIFIED (no Mattel sheet):** service.mattel.com has no Coca-Cola UNO product. MED stands.

## #200 Uno Jelly Belly
- **Found:** "Jelly Belly Uno Gift Box" (around 2012, Sweets & Snacks Expo licensed-product award). Bean-shaped cards, bundled with a 3.5 oz bag of jelly beans, and the rules "explain how to use the beans in play". The specific rule was not found.
- **Confidence:** MED that the product exists. LOW on the mechanic.
- **Verdict:** The doc's "resource-accumulation tied to draw cards" is unverified and plausibly invented. Mark it LOW.

## #215 / #227 NFL "Champs Card"; #217 MLB "Top 2"; #226 "Hot Corner"; #228 "Three-Pointer"; #225 Arsenal
- **Champs Card:** found for **UNO NFL AFC/NFC Edition (2006)**. The player chooses another player, who must **draw until they draw a "4" or have drawn 7 cards**. The Champs player names the color. MED (tarsasjatekok.com, single source).
  - Applying it to #215 Giants 2006 and #227 Patriots 2005 is inferred from the same-era, same-licensor family. LOW-MED.
- **#217 Top 2, #226 Hot Corner, #228 Three-Pointer, #225 Arsenal Red/Yellow:** **nothing found** (one search each for MLB/Mets, Kobe and Arsenal). LOW. These remain unverified one-liners. tarsasjatekok.com looks like the best next source for Sababa-era editions.

## #274 Uno One Piece Log Spin
- **Found:** a single eBay listing titled "Bandai ... One Piece UNO SPIN / log spin", a Japanese-language Bandai product with Straw Hat crew art. No rules were found.
- **Confidence:** MED that a One Piece-themed UNO Spin by Bandai exists. LOW on any rule differences.
- **Verdict:** Probably Uno Spin rules (spin results such as Colour Draw, Swap Hands, Colour Discard, Double Spin) with One Piece art. Treat it as a reskin of Uno Spin unless more evidence turns up.

## #308 Uno 30 Year Anniversary (2001, Mattel 42885)
- **Found:**
  - The official sheet (service.mattel.com/instruction_sheets/42885-0920_Uno_30th_Instr.pdf) lists **4 "Anniversary" cards** in addition to the 4 Wild and 4 WD4. They can be played "at any time on any color or number".
  - pickyourboardgame describes the effect as **the player hands all but one of their cards to another player**.
- **Confidence:** HIGH for the count and the play-on-anything rule. LOW-MED for the effect.
- **Verdict:** Doc is vague. The likely effect is "give all but one card to a chosen player". That's very strong, so verify it against the PDF before implementing.
- **SHEET-VERIFIED (sheet 42885-0920) HIGH:**
  - Deck: 112 = 76 + 8 Skip + 8 Reverse + 8 Draw 2 + 4 Wild + 4 Wild Draw 4 + **4 Anniversary cards**, plus a pencil and a score pad.
  - Exact text: "This card may be played at any time on any color or number. The player gives their entire hand to any other player except one card and says, 'Happy Anniversary!' That player then calls 'UNO,' and changes the color of play just like 'Wild.' Counts for **100 points**."
  - **Effect confirmed:** keep exactly 1 card and give all the rest to one chosen player. The Anniversary player is left on one card and calls UNO.
  - The grammar of "That player then calls UNO" refers back to the giver, who is the only one holding 1 card.
  - Read "at any time" as "regardless of what's on the discard" (Wild-style) and play it on your own turn. The sheet gives no out-of-turn procedure.
  - Worth 100 points, not 50.

## #327 King Size Uno (With Free Turn)
- **Found:** nothing. Mattel's "King-Size" line found was My First UNO (36 cards, W5817), which has no Free Turn card. LOW.
- **Verdict:** Unverified.

## #346 Uno x NDJOLIJEAN (Mattel Creations HYC81, Apr 26 2024)
- **Found:**
  - 112 holo-foil cards on 300 gsm stock.
  - Custom "**Shuffle Hands**" and "**Make Your Own Rule**" Wilds. These are the standard Shuffle Hands effect (collect, shuffle and redeal all hands) and a blank customizable Wild.
  - The instruction sheet adds artist rules for a faster game, including **discarding several cards at once if they share a number or symbol**.
- **Confidence:** HIGH (Mattel Creations product page, Dieline, Sortir à Paris).
- **Verdict:** Right.
- **Partly verified (Mattel Creations product JSON for HYC81, read directly; no service.mattel.com sheet):**
  - The copy confirms "112 cards on premium 300-gram card stock", the "Shuffle Hands" and "Make Your Own Rule" WILD cards, and the multi-discard rule: "discarding multiple cards on your turn as long as they all share the same number or symbol – and if they're action cards, all the actions take effect at once!"
  - New detail: **stacked action cards all resolve at once.**
  - The full instruction-sheet text is still unseen. MED-HIGH.

## #361 Uno Platica Polinesia
- **Found:** nothing. No search result mentions the name. LOW.
- **Verdict:** Unverified. The existence of this product is itself in question.

## #372 Uno Ito Family's Dining Table (伊東家の食卓, note the spelling 伊東)
- **Found:** nothing about an UNO tie-in in two Japanese searches. The TV show's 裏ワザ (life-hack) segments are what come up. LOW.
- **Verdict:** Unverified. The 12 variants could not be listed. Note the correct show name is 伊東家の食卓 (Itō-ke no Shokutaku).

## #1-5 Iconic Series (50th anniversary decade decks)
- **SHEET-VERIFIED (sheets GXV43 1970s, GXV45 1980s, GXV50 1990s, GXV51 2000s, GXV52 2010s) HIGH:**
  - Every deck is 112 cards = 76 numbers + 24 actions + **8 Wild** + 4 Wild Draw Four. There are no special cards, and the rules are standard.
  - **New detail: each decade uses its own 4-color set:**

    | Code | Decade | Colors |
    |---|---|---|
    | GXV43 | 1970s | orange, blue, red, yellow |
    | GXV45 | 1980s | purple, green, blue, orange |
    | GXV50 | 1990s | purple, blue, orange, pink |
    | GXV51 | 2000s | red, blue, green, yellow |
    | GXV52 | 2010s | pink, blue, green, yellow |

  - This matters only for palette and reskinning.

## #149 / #330 Masters of the Universe (spotted while checking #400)
- **SHEET-VERIFIED (sheet GVY91, ©2020) HIGH:**
  - GVY91 is the **non-Fandom** MOTU deck.
  - Colors are blue, red, green and **purple**. Purple replaces yellow.
  - Deck: 112 cards with **4 Wild Power of Greyskull**.
  - Exact text: "first hold it over your head and proclaim 'BY THE POWER OF GREYSKULL… I HAVE THE POWER!'. Lay the card on the discard pile, then all other players must draw three cards from the draw pile. Play then continues in the current order. This card is also a wild card".
  - This confirms #149.
  - **#330 is wrong to give GVY91 as the Fandom deck's code.** The Fandom MOTU deck is **HYH55**, and its rule is "The Armory of Grayskull". See 08.
  - **JMF11** (the MOTU movie deck, sheet HIGH) has a different card, the "Wild Power Sword": hold it to play up to 2 cards per turn, and lose it when anyone plays a Wild or a Power Sword.

---

## Rows where the doc is actually WRONG
1. **#400 "Uno Master":** not Masters of the Universe (already #149/#330). It is the 1997 Spear's Games electronic **turn-timer** UNO (8/6/4 s; late = draw 4).
2. **#388 Harry Potter (2003, Mattel #42797):** has no Sorting Hat card. 42797's cards are the **Howler** and **Invisibility Cloak** Wilds, plus Draw 3s. The Sorting Hat card is FNC42 (2018).
3. **#36 Harry Potter Sorcerer's Stone:** its cards are attributed to the wrong decks (Voldemort = 2005/2010, Gryffindor draw-until = 2018). It should match #388/42797. #36 and #388 are likely duplicates.
4. **#42 Monster High:** the second Wild ("multi-discard+share") is unsupported. The row duplicates #262's Creeperific card.
5. **#96 Cobs:** it is not a 5-card set. 13 cards exist, including Deflection and Popcorn.
6. **#428 Expo 2025:** a minor fix. The declared color is red or blue only, not any color.
7. **#34 Pokémon "Trainer" hand swap and #200 Jelly Belly "resource mechanic":** no support found. They are possibly fabricated and should be downgraded to LOW.

Added by the sheet pass:

8. **#32 Sonic:** the codes HGJ78/HJG14 are wrong. HGJ78 is UNO Dragon Ball Z.
9. **#36/#388:** the card is named "Invisibility", not "Invisibility Cloak". There is 1 copy each of Howler and Invisibility, and the deck has 110 cards. The Howler has no turn loss.
10. **#308:** the Anniversary card is worth 100 points.
11. **#40 H2O:** the win condition is the first player to win 3 hands.
12. **#330:** the Fandom MOTU code is HYH55, not GVY91.
13. **#33:** the drawer takes the 3 cards, per the sheet. The "others draw 3" retail copy is wrong.
14. **#6:** confirmed that the 50/50 player may name themselves as one of the two.
