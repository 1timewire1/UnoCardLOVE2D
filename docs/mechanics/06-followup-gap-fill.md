# Final review 6: follow-up gap-filling pass

> Reference spec for `docs/gameversions.md` (see its Part F). Gathered from web-search snippets only; direct page fetches were blocked during research, so treat anything below HIGH as needing a check against the official instruction sheet before shipping.

Method: WebSearch snippets only (WebFetch and curl are blocked). 31 searches in total. No repo files were edited.
Confidence: HIGH = 2+ independent sources agree; MED = one detailed source; LOW = thin, inferred or conflicting.

---

## 1. Wild Draw Four history (#8, #484)

**What the doc says now:**
- #8: WD4 "likely postdates 1980 (added ~1983)".
- #484: the 1973 print "predates Wild Draw Four (introduced 1992)".

**What I found:**
- **The "1992" date is wrong (HIGH).** Mattel bought International Games in 1992. Wikipedia and Mattel's 30th-anniversary instruction sheet both give that date. It is not when WD4 was introduced, so #484 has mixed the two up. WD4 is in decks long before 1992.
- **The "~1983" date has one weak source.** It traces to a Baidu Baike entry ("Wild Card"). That entry says the first version had only a basic colour-change Wild, and that the "1983 International Edition Rules" added WD4 together with its challenge rule (the "card verification mechanism"). There is no corroboration. **LOW.**
- **A source that disagrees:** RarePike's history page (a marketing page) says Robbins designed both Wild and Wild Draw Four into the 1971 deck to replace the role of the 8s in Crazy Eights. **LOW.**
- **Indirect evidence that WD4 existed in the 1970s (MED):**
  - Mattel's "UNO Iconic 1970s" retro reissue (GXV43) copies the 1970s look. It is 108 cards: 4×25 coloured cards plus 8 Wilds.
  - A 1970s-era manual excerpt found on manualsnet already discusses Draw Two versus Wild Draw Four.
  - eBay listings of sealed 1978 IGI Joliet decks exist, but no snippet listed their contents.
- **The original 1971/1973 deck:** I found no source that lists it card by card.
  - Sources agree it was a custom four-colour deck (0-9 plus action cards) rather than standard playing cards. **HIGH.**
  - Robbins's family had 5,000 copies printed for $8,000. Saltzman Printers in Maywood printed them for International Games of Joliet. **HIGH.**
  - The exact action-card mix and whether WD4 was in it are **unresolved**.

**Verdict:**
- #484 is **wrong** and should drop "introduced 1992".
- #8 should say that the date WD4 was introduced is unverified. The only dated claim is 1983, from Baidu (LOW). A Mattel 1970s reissue and 1970s rule text point to WD4 being in the deck by the late 1970s.
- Recommendation: don't assert any date. Treat WD4 and the challenge rule as standard for every era, with an optional "1971 classic" toggle that removes WD4, labelled as speculative.

**Sources:** en.wikipedia.org/wiki/Uno_(card_game); service.mattel.com/instruction_sheets/42885-0920_Uno_30th_Instr.pdf; baike.baidu.com/en/item/Wild%20Card/1464992; rarepike.com/four-colors/history/; manualsnet.com/uno/mattel-iconic-1970s-gxv43; nobleknight.com (Iconic 1970s); ebay.de/itm/197562489673

---

## 2. UNO X Games (#234)

**What the doc says now:** a renamed action-card set with new effects (Wild Draw 5/10, discard-down-to-5, reverse plus discard-a-colour). An earlier pass suspected this list was really No Mercy's.

**What I found:** the list belongs to X Games, and the doc is correct. BoardGameGeek (boardgame/12228, "UNO: X Games", Mattel, listed as 1999) has a card list that Analog.Games and an RPGGeek geeklist repeat. **HIGH**, although all three may share one origin.

| Card | Effect |
|---|---|
| Can-Can | Wild, draw 10 |
| Nuclear Air | Wild, draw 5 |
| Dirt-Dive | Discard all but 5 cards |
| Fakie | Wild, and all players trade hands |
| Drop a Hill | Wild, and draw a new hand |
| Alley-Oop | Reverse, and discard all cards of one colour |
| Tailwhip, Lipslide | Trick cards that replace Reverse and Skip |

No Mercy's set is different: Wild Draw 6, Wild Draw 10, Wild Reverse Draw 4, Skip Everyone, Discard All (of a colour), Colour Roulette, the 25-card Mercy rule, and 7-swap/0-pass. No Mercy has no Draw 5 and no discard-down-to-5. The only overlaps are "draw 10" and a "discard a colour" idea.

**Verdict:**
- The doc is **right**. It needs more detail: add Fakie (everyone trades hands) and Drop a Hill (redraw a new hand) to the A8 description.
- Release year 1999, per BGG. **MED.**
- I did not find which colour or number each card is, or exact counts.

**Sources:** boardgamegeek.com/boardgame/12228/uno-x-games; analog.games (uno-x-games); rpggeek.com/geeklist/24324

---

## 3. UNO Show 'Em No Mercy Deadpool (#406) and Reverse Draw 10 promo (#407)

**What the doc says now:**
- #406: a new "Wild Reverse Draw Ten" card.
- #407: a promo card that combines reverse and draw 10.

**What I found:**
- **The edition exists (HIGH).** Sources: the matteluno fandom page, a bamsmackpow article on the Deadpool & Wolverine tie-in, eBay and WorthPoint listings ("Deadpool Chimichanga" packaging), and a Target product reference.
- **Card list:**
  - The fandom wiki says the edition adds a new **Wild Reverse Draw Ten** card, alongside the No Mercy Wild Colour Roulette, Wild Draw 10 and Wild Reverse Draw 4. **MED.**
  - A retail listing says it has **3 new Wild cards: "Gimme!", "Maximum Effort", and "Rock, Paper, Scissors, Shoot!"**. **MED.**
  - Bamsmackpow names "Wild Maximum Effort" too, so that card is **HIGH**.
  - None of the snippets gave the effects of these three cards.
- **Where it was sold (conflict):**
  - The fandom wiki says the edition was sold only at Target.
  - An eBay listing has a "DEADPOOL UNO SHOW EM NO MERCY **SDCC 2024** Mattel Exclusive Foil Holo Card".
  - So #407's promo card is plausibly the SDCC 2024 foil exclusive. That it is specifically the Reverse Draw 10 is **LOW to MED**: the listing title doesn't name the card face in the snippet.
- **What Wild Reverse Draw 10 does:** I found no printed text. Going by No Mercy's Wild Reverse Draw 4, it most likely reverses direction, then the new next player draws 10 and the player picks a colour, and it stacks under No Mercy rules. This is an analogy, so **LOW**.

**Verdict:**
- Both rows are **right that the card exists**. #406 **needs detail**: it is missing the Gimme!, Maximum Effort and Rock-Paper-Scissors-Shoot! wilds, whose effects are still unknown.
- #407: note "likely the SDCC 2024 foil promo".

**Sources:** matteluno.fandom.com/wiki/Uno_Show_'Em_No_Mercy_Deadpool; bamsmackpow.com/posts/uno-show-em-no-mercy-deadpool-edition-...; worthpoint.com/worthopedia/mattel-uno-show-em-mercy-deadpool-4770727963; ebay.com/itm/126602711869; ebay.com/p/19070515733

---

## 4. UNO Flip: Flip card as the first discard, and face pairing

**Flip as the first card turned up:**
- Mattel's GDR44 sheet says that if an action card starts the discard pile, you follow the "Functions of Action Cards" section. The snippets cut off before the Flip entry. The official wording is **unconfirmed**.
- Two third-party sources say **all cards flip and the game starts on the Dark side**:
  - gamerules.com: "all cards are flipped, and the game begins on the dark side"
  - manuals.plus: "the game immediately starts on the Dark Side"
  - Together these are **MED** (two sources, neither official).
- I found no source in this pass for the other version (bury the Flip and turn another card). The conflict may come from house-rule sites, or from mixing it up with the Wild Draw Two rule: gathertogethergames says to bury a Wild Draw 2 if it comes up first.
- Recommendation: default to starting on the Dark side, and offer a "redraw instead" toggle.

**Light-to-Dark pairing:**
- No source documents which Light face is printed behind which Dark face. Wikipedia, Mattel, Asmodee and officialgamerules give only the counts for each side. **Undocumented.**
- From memory, not sourced (**LOW**): players report that the pairings are not systematic. For example, a Wild is not always backed by a Wild.
- Recommendation for the port: generate a fixed pairing table, or shuffle the pairing at deck build, and say so in the options rather than claiming accuracy.

**Verdict:** add detail ("starts on Dark side", MED) and record the pairing as unknown.

**Sources:** service.mattel.com GDR44 UNO Flip PDF; gamerules.com/rules/uno-flip/; manuals.plus/asin/B07JKB2H59; gathertogethergames.com/uno-flip; en.wikipedia.org/wiki/Uno_Flip!; geekyhobbies.com UNO Flip review

---

## 5. Fandom NFL "Touchdown", WWE "Locked Up", NASCAR "Drafting"

**NFL Touchdown (#218 and others):**
- A Walmart listing confirms a "Special 'Touchdown' Rule" on the NFL Super Bowl LVII/LVIII editions. **HIGH** that the rule exists.
- Mattel instruction sheets HPW20 and HPW22 came up, but the snippets didn't include the rule text. **The exact text was not found.**
- The doc's paraphrase ("signal touchdown or draw 3") is still unverified. **LOW.**
- Next step for a human: the HPW22-Eng.pdf instruction sheet on service.mattel.com has the text.

**WWE Locked Up (#230-232):**
- Retail listings say the player who plays it picks another player to battle in a showdown where "only one will survive". **MED.**
- I found no snippet giving the resolution: who takes the cards, and whether there is an extra penalty.
- The doc's "lower value takes both" (#232, which the doc rates HIGH) was **not re-confirmed** in this pass, and no "plus extra" draw turned up.
- Keep it as is, and add a tie-break rule as a port option.

**NASCAR Drafting (#233):**
- The search found nothing about a 2005 NASCAR UNO or a Drafting card.
- The doc's "play up to 2 extra matching-colour cards after a wild" is **unverified (LOW)**.

**Verdict:** all three **still need the exact text**. Don't upgrade their confidence.

**Sources:** walmart.com/c/kp/touchdown-nfl; service.mattel.com/instruction_sheets/HPW22-Eng.pdf and HPW20-Eng.pdf; ebay.com/p/12013972982; walmart.com/ip/115756602

---

## 6. Rows never re-verified

**#291 Nike Zoom Freak 3: the doc is WRONG to say "standard rules" (HIGH).**
- Sources: Business Wire's Mattel release of 2021-10-27, nssmag, FashionUnited and Pocket Gamer.
- The UNO x Nike x Giannis collection for UNO's 50th anniversary included a Giannis UNO deck with a **new "Force a Turnover" rule**. The rule lets a player steal an extra discard; some outlets phrase it as "steal the ball".
- Mattel also mentions a special 3-4 card design.
- The rule was also playable in the UNO! mobile app.
- The Zoom Freak 3 shoe itself is apparel (UNO wild-card toe art, 5 colourways).
- Fix: split the row, or re-describe it as "Giannis deck: Force a Turnover steal rule". I did not find the exact rule text.

**#305 Vacation Uno:** not searched (search budget ran out). Unverified.

**#318 Ryan's World:** not searched. Unverified. The doc's note that "Pocket Watch" is the media company is correct from general knowledge.

**#337/#338 Diary of a Wimpy Kid "Cheese Touch": there is a CONFLICT, and the doc probably has the wrong effect.**
- **Fundex manual** (manualslib, manualsdir, manualmachine and manualshelf all host it), **MED-HIGH**:
  - 112-card deck with **4 Cheese Touch cards**.
  - It is a **yellow** card, playable only on yellow ("cheese-coloured") cards.
  - The **next player draws 2** ("its cooties are passed on").
  - If that player has no yellow to play, they **draw 2 more**.
  - After that, it acts as a normal yellow card. It scores 50 points.
- **UNO Variations (fan site, LOW-MED)** describes a "Cheese Touch" **Wild**: everyone, including the player, shows their yellow cards, and anyone holding yellow draws 2. This matches the doc's current text.
- Possibly 2010 (Fundex) and 2012 are different printings with different effects, but nothing confirms that.
- Whether they are distinct products: I found only the Fundex edition. **Not resolved.**
- Fix: replace the effect with the Fundex rule, or record both versions.

**#340 Uno Pocket Geox: the row's "standard rules" is wrong, and Part A's "52 cards" conflicts with what I found.**
- eBay.de and Vinted listings confirm a Geox-branded Mattel UNO Pocket in a white metal tin. **MED.**
- For the same promo family, Casio's 2024 gift-with-purchase page says UNO Pocket is a **56-card**, half-size deck (54×80 mm) with "half the number of cards". **MED.**
- I did not confirm the composition (1-9 only, draw-1).
- Fix: the row should point to the Pocket reduced deck, and the count should read "56 (per Casio)", not 52, unless a source for 52 exists.

**#352 Artlist Dog reissue (2006):** not searched. Unverified.

**#355 Utterly Butterly Omega 3:** not searched. Unverified.

**#367 Arby's Get Wild 4 plus glow stickers:**
- Two searches found nothing about any Arby's UNO promo, whether Get Wild or Wild Jackpot.
- Part A's link to Wild Jackpot and the row's "standard rules" are **both unverified**.
- The title ("Get Wild 4" with "make your own wild" stickers) suggests standard rules plus blank wilds, not Wild Jackpot. **LOW.**
- Fix: flag the Part A link as unsourced.

**#436 Premium Pack:** not searched. Unverified.

**Sources:** businesswire.com/news/home/20211027005392/en/; nssmag.com/en/sports/27884/...; fashionunited.com/news/fashion/nike-partners-with-uno-on-collection/2021102843224; pocketgamer.com/uno-mobile/50th-anniversary-nike-nba-mvp-giannis; manualslib.com/manual/55531/Fundex-Games-Uno-Diary-Of-A-Wimpy-Kid.html; manualsdir.com/manuals/103490/...; unovariations.blogspot.com/p/special-wild-cards.html; casio.com/sg/news/events/2024/uno-gwp/; ebay.de/itm/156574324616

---

## Changes for the doc, in priority order

1. #484: drop "introduced 1992", which is Mattel's acquisition date. #8: mark the 1983 date for WD4 as LOW (Baidu only).
2. #291: not standard rules. The Giannis deck adds "Force a Turnover".
3. #337/#338: the Cheese Touch effect conflicts. The Fundex manual describes a yellow card where the next player draws 2, plus 2 more if they have no yellow.
4. #340: Pocket format with 56 cards, not standard rules.
5. #406: add the Gimme!, Maximum Effort and Rock-Paper-Scissors-Shoot! wilds. #407: likely the SDCC 2024 foil.
6. #234: the doc is right. Add Fakie and Drop a Hill.
7. Flip: Flip as the first discard starts the game on the Dark side (MED). The face pairing is undocumented.
8. Still unverified: Touchdown, Locked Up, Drafting, Arby's, and #305, #318, #352, #355 and #436.
