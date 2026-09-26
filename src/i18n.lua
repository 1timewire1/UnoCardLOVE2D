-- Uno Card Game for LOVE2D
--
-- Lua port of "UnoCard" by Hikari Toyama (Apache License 2.0).
-- Original: https://github.com/shiawasenahikari/UnoCard
--
-- Text resources: English (en), Simplified Chinese (zh) and Japanese (ja).
--
-- Strings may contain color marks ([R], [B], [G], [W], [Y]) that tint the
-- remaining text, and "^" (an up arrow in the original) prompts. Card names
-- use the same marks (e.g. "[R]+2"). Player ids are 0 (you), 1 (west),
-- 2 (north), 3 (east). Color ids are 0 (none), 1 (red), 2 (blue), 3 (green),
-- 4 (yellow).

local fmt = string.format

--- Lacking colors line. Colors are given in N, E, W, S order.
local function lacks(prefix, n, e, w, s)
    local mark = "WRBGY"

    local function m(x)
        return 0 <= x and x <= 4 and mark:sub(x + 1, x + 1) or "W"
    end

    return fmt("%s[%s]N[%s]E[%s]W[%s]S", prefix, m(n), m(e), m(w), m(s))
end

local I18N = {}

--------------------------------------------------------------------------------
-- English
--------------------------------------------------------------------------------
do
    local COLORS = { [0] = "NONE", "[R]RED", "[B]BLUE", "[G]GREEN", "[Y]YELLOW" }
    local PLAYERS = { [0] = "YOU", "WEST", "NORTH", "EAST" }
    local function c(i) return COLORS[i] or "????" end
    local function p(i) return PLAYERS[i] or "????" end

    I18N.en = {
        name = "English",
        act_drawCard = function(i, s) return fmt("%s: Draw %s", p(i), s) end,
        act_drawCardCount = function(i1, i2)
            return i2 == 1 and fmt("%s: Draw a card", p(i1)) or fmt("%s: Draw %d cards", p(i1), i2)
        end,
        act_pass = function(i) return fmt("%s: Pass", p(i)) end,
        act_playCard = function(i, s) return fmt("%s: %s", p(i), s) end,
        act_playDraw2 = function(i1, i2, i3) return fmt("%s: Let %s draw %d cards", p(i1), p(i2), i3) end,
        act_playRev = function(i) return fmt("%s: Change direction", p(i)) end,
        act_playSkip = function(i1, i2)
            return i2 == 0 and fmt("%s: Skip your turn", p(i1)) or fmt("%s: Skip %s's turn", p(i1), p(i2))
        end,
        act_playWild = function(i1, i2) return fmt("%s: Change color to %s", p(i1), c(i2)) end,
        act_playWildDraw4 = function(i1, i2) return fmt("%s: Change color & let %s draw 4", p(i1), p(i2)) end,
        ask_bullseyeTarget = function() return "^ Choose who this card targets" end,
        ask_challenge = function(i) return fmt("^ Do you think your previous player still has %s?", c(i)) end,
        ask_color = function() return "^ Specify the following legal color" end,
        ask_keep_play = function() return "^ Play the drawn card?" end,
        ask_target = function() return "^ Specify the target to swap hand cards with" end,
        btn_ask = function(active) return active and "[Y]<ASK>" or "<ASK>" end,
        btn_auto = function() return "<AUTO>" end,
        btn_back = function() return "<BACK>" end,
        btn_keep = function(active) return active and "[R]<KEEP>" or "<KEEP>" end,
        btn_lang = function() return "[G]<EN>" end,
        btn_load = function() return "[G]<LOAD>" end,
        btn_play = function(active) return active and "[G]<PLAY>" or "<PLAY>" end,
        btn_save = function() return "[B]<SAVE>" end,
        btn_settings = function(active) return active and "[Y]<SETTINGS>" or "<SETTINGS>" end,
        info_0_rotate = function() return "Hand cards transferred to next" end,
        info_7_swap = function(i1, i2) return fmt("%s swapped hand cards with %s", p(i1), p(i2)) end,
        info_cannotDraw = function(i1, i2) return fmt("%s cannot hold more than %d cards", p(i1), i2) end,
        info_cannotPlay = function(s) return fmt("Cannot play %s", s) end,
        info_challenge = function(i1, i2, i3)
            return i2 == 0 and fmt("%s doubted that you still have %s", p(i1), c(i3))
                or fmt("%s doubted that %s still has %s", p(i1), p(i2), c(i3))
        end,
        info_challengeFailure = function(i)
            return i == 0 and "Challenge failure, you draw 6 cards" or fmt("Challenge failure, %s draws 6 cards", p(i))
        end,
        info_challengeSuccess = function(i)
            return i == 0 and "Challenge success, you draw 4 cards" or fmt("Challenge success, %s draws 4 cards", p(i))
        end,
        info_clickAgainToPlay = function(s) return fmt("Click again to play %s", s) end,
        info_dirChanged = function() return "Direction changed" end,
        info_gameOver = function(i1, i2)
            return i2 < 0 and fmt("Score: %d[R](%d)[W]. Click UNO to restart", i1, i2)
                or fmt("Score: %d[G](%+d)[W]. Click UNO to restart", i1, i2)
        end,
        info_loadFailed = function(s) return "[Y]Failed to load " .. s end,
        info_noReplays = function() return "No replays yet. Finish a game and <SAVE> it, or drop a .sav file here" end,
        info_pickReplay = function() return "SELECT A REPLAY  (or drop a .sav file onto the window)" end,
        info_ready = function() return "GET READY" end,
        info_ruleSettings = function() return "RULE SETTINGS" end,
        info_save = function(s)
            return (s == nil or s == "") and "Failed to save your game replay" or fmt("Replay file saved as %s", s)
        end,
        info_skipped = function(i) return fmt("%s: Skipped", p(i)) end,
        info_welcome = function() return "WELCOME TO UNO CARD GAME, CLICK UNO TO START" end,
        info_yourTurn = function() return "Select a card to play, or draw a card from deck" end,
        info_yourTurn_stackDraw2 = function(i1, i2)
            return (i2 or 1) == 1 and fmt("Stack a +2 card, or draw %d cards", i1)
                or fmt("Stack a +2/+4 card, or draw %d cards", i1)
        end,
        label_bgm = function() return "BGM" end,
        label_bullseye = function(active) return "Bullseye targeting: " .. (active and "[G]ON" or "[R]OFF") end,
        label_drawToMatch = function(active) return "Draw to match: " .. (active and "[G]ON" or "[R]OFF") end,
        label_forcePlay = function() return "When you draw a playable card:" end,
        label_initialCards = function(i) return fmt("Initial cards: %02d", i) end,
        label_lacks = function(n, e, w, s) return lacks("LACK:", n, e, w, s) end,
        label_leftArrow = function() return "[Y]＜－" end,
        label_level = function(i) return i == 0 and "Level: EASY" or "Level: HARD" end,
        label_no = function() return "NO" end,
        label_players = function(i) return i == 3 and "Players:   3P" or "Players:   4P" end,
        label_remain_used = function(i1, i2) return fmt("[Y]R%d[W]/[G]U%d", i1, i2) end,
        label_rightArrow = function() return "[Y]＋＞" end,
        label_score = function() return "SCORE" end,
        label_settingsPage = function(i1, i2) return fmt("PAGE %d/%d", i1, i2) end,
        label_sevenZeroRule = function(active) return "7-0 Rule: " .. (active and "[G]ON" or "[R]OFF") end,
        label_snd = function() return "SND" end,
        label_speed = function() return "SPEED" end,
        label_stackRule = function(i)
            return i == 0 and "Stackable cards: NONE" or i == 1 and "Stackable cards:   +2"
                or "Stackable cards: +2+4"
        end,
        label_twoVsTwoRule = function(active) return "2vs2 Rule: " .. (active and "[G]ON" or "[R]OFF") end,
        label_wildDraw4Challenge = function(active)
            return "Wild +4 challenge: " .. (active and "[G]ON" or "[R]OFF")
        end,
        label_yes = function() return "YES" end,
    }
end

--------------------------------------------------------------------------------
-- Simplified Chinese
--------------------------------------------------------------------------------
do
    local COLORS = { [0] = "无色", "[R]红色", "[B]蓝色", "[G]绿色", "[Y]黄色" }
    local PLAYERS = { [0] = "你", "西家", "北家", "东家" }
    local function c(i) return COLORS[i] or "????" end
    local function p(i) return PLAYERS[i] or "????" end

    I18N.zh = {
        name = "简体中文",
        act_drawCard = function(i, s) return fmt("%s: 摸到 %s", p(i), s) end,
        act_drawCardCount = function(i1, i2) return fmt("%s: 摸 %d 张牌", p(i1), i2) end,
        act_pass = function(i) return fmt("%s: 过牌", p(i)) end,
        act_playCard = function(i, s) return fmt("%s: %s", p(i), s) end,
        act_playDraw2 = function(i1, i2, i3) return fmt("%s: 令%s摸 %d 张牌", p(i1), p(i2), i3) end,
        act_playRev = function(i) return fmt("%s: 改变方向", p(i)) end,
        act_playSkip = function(i1, i2) return fmt("%s: 跳过%s的回合", p(i1), p(i2)) end,
        act_playWild = function(i1, i2) return fmt("%s: 将接下来的合法颜色改为%s", p(i1), c(i2)) end,
        act_playWildDraw4 = function(i1, i2) return fmt("%s: 变色 & 令%s摸 4 张牌", p(i1), p(i2)) end,
        ask_bullseyeTarget = function() return "^ Choose who this card targets" end,
        ask_challenge = function(i) return fmt("^ 你是否认为你的上家仍有%s牌?", c(i)) end,
        ask_color = function() return "^ 指定接下来的合法颜色" end,
        ask_keep_play = function() return "^ 是否打出摸到的牌?" end,
        ask_target = function() return "^ 指定换牌目标" end,
        btn_ask = function(active) return active and "[Y]<可选>" or "<可选>" end,
        btn_auto = function() return "<托管>" end,
        btn_back = function() return "<返回>" end,
        btn_keep = function(active) return active and "[R]<保留>" or "<保留>" end,
        btn_lang = function() return "[G]<中文>" end,
        btn_load = function() return "[G]<读取>" end,
        btn_play = function(active) return active and "[G]<打出>" or "<打出>" end,
        btn_save = function() return "[B]<保存>" end,
        btn_settings = function(active) return active and "[Y]<设置>" or "<设置>" end,
        info_0_rotate = function() return "所有人将牌传给下家" end,
        info_7_swap = function(i1, i2) return fmt("%s和%s换牌", p(i1), p(i2)) end,
        info_cannotDraw = function(i1, i2) return fmt("%s最多保留 %d 张牌", p(i1), i2) end,
        info_cannotPlay = function(s) return fmt("无法打出 %s", s) end,
        info_challenge = function(i1, i2, i3) return fmt("%s认为%s仍有%s牌", p(i1), p(i2), c(i3)) end,
        info_challengeFailure = function(i) return fmt("挑战失败, %s摸 6 张牌", p(i)) end,
        info_challengeSuccess = function(i) return fmt("挑战成功, %s摸 4 张牌", p(i)) end,
        info_clickAgainToPlay = function(s) return fmt("再次点击以打出 %s", s) end,
        info_dirChanged = function() return "方向已改变" end,
        -- (The original colors these the other way round; fixed to match the
        -- English and Japanese texts: red for a loss, green for a gain.)
        info_gameOver = function(i1, i2)
            return i2 < 0 and fmt("你的分数为 %d[R](%d)[W], 点击 UNO 重新开始游戏", i1, i2)
                or fmt("你的分数为 %d[G](%+d)[W], 点击 UNO 重新开始游戏", i1, i2)
        end,
        info_loadFailed = function(s) return "[Y]读取失败 " .. s end,
        info_noReplays = function() return "还没有回放. 请先完成一局并<保存>, 或将 .sav 文件拖到此窗口" end,
        info_pickReplay = function() return "选择回放文件  (或将 .sav 文件拖到窗口中)" end,
        info_ready = function() return "准备" end,
        info_ruleSettings = function() return "规则设置" end,
        info_save = function(s)
            return (s == nil or s == "") and "回放文件保存失败" or fmt("回放文件已保存为 %s", s)
        end,
        info_skipped = function(i) return fmt("%s: 被跳过", p(i)) end,
        info_welcome = function() return "欢迎来到 UNO, 点击 UNO 开始游戏" end,
        info_yourTurn = function() return "选择一张牌打出, 或从发牌堆摸一张牌" end,
        info_yourTurn_stackDraw2 = function(i1, i2)
            return (i2 or 1) == 1 and fmt("叠加一张 +2, 或从发牌堆摸 %d 张牌", i1)
                or fmt("叠加一张 +2/+4, 或从发牌堆摸 %d 张牌", i1)
        end,
        label_bgm = function() return "音乐" end,
        label_bullseye = function(active) return "Bullseye targeting: " .. (active and "[G]ON" or "[R]OFF") end,
        label_drawToMatch = function(active) return "Draw to match: " .. (active and "[G]ON" or "[R]OFF") end,
        label_forcePlay = function() return "摸到可出的牌时, 是否打出:" end,
        label_initialCards = function(i) return fmt("发牌张数: %02d", i) end,
        label_lacks = function(n, e, w, s) return lacks("缺色:", n, e, w, s) end,
        label_leftArrow = function() return "[Y]＜－" end,
        label_level = function(i) return i == 0 and "难易度: 简单" or "难易度: 困难" end,
        label_no = function() return "否" end,
        label_players = function(i) return i == 3 and "Players:   3P" or "Players:   4P" end,
        label_remain_used = function(i1, i2) return fmt("[Y]剩%d[G]用%d", i1, i2) end,
        label_rightArrow = function() return "[Y]＋＞" end,
        label_score = function() return "分数" end,
        label_settingsPage = function(i1, i2) return fmt("PAGE %d/%d", i1, i2) end,
        label_sevenZeroRule = function(active) return "7-0 Rule: " .. (active and "[G]ON" or "[R]OFF") end,
        label_snd = function() return "音效" end,
        label_speed = function() return "速度" end,
        label_stackRule = function(i)
            return i == 0 and "允许叠牌: 　　　无" or i == 1 and "允许叠牌: 只有＋２"
                or "允许叠牌: ＋２＋４"
        end,
        label_twoVsTwoRule = function(active) return "2vs2 Rule: " .. (active and "[G]ON" or "[R]OFF") end,
        label_wildDraw4Challenge = function(active)
            return "Wild +4 challenge: " .. (active and "[G]ON" or "[R]OFF")
        end,
        label_yes = function() return "是" end,
    }
end

--------------------------------------------------------------------------------
-- Japanese
--------------------------------------------------------------------------------
do
    local COLORS = { [0] = "無色", "[R]赤色", "[B]青色", "[G]緑色", "[Y]黄色" }
    local PLAYERS = { [0] = "あなた", "西", "北", "東" }
    local function c(i) return COLORS[i] or "????" end
    local function p(i) return PLAYERS[i] or "????" end

    I18N.ja = {
        name = "日本語",
        act_drawCard = function(i, s) return fmt("%s: %s[W] を引く", p(i), s) end,
        act_drawCardCount = function(i1, i2) return fmt("%s: 手札を %d 枚引く", p(i1), i2) end,
        act_pass = function(i) return fmt("%s: パス", p(i)) end,
        act_playCard = function(i, s) return fmt("%s: %s", p(i), s) end,
        act_playDraw2 = function(i1, i2, i3) return fmt("%s: %sに手札を %d 枚引かせる", p(i1), p(i2), i3) end,
        act_playRev = function(i) return fmt("%s: 方向を変える", p(i)) end,
        act_playSkip = function(i1, i2) return fmt("%s: %sの番をスキップ", p(i1), p(i2)) end,
        act_playWild = function(i1, i2) return fmt("%s: 次の色を%s[W]に変える", p(i1), c(i2)) end,
        act_playWildDraw4 = function(i1, i2) return fmt("%s: 色を変更 & %sに手札を 4 枚引かせる", p(i1), p(i2)) end,
        ask_bullseyeTarget = function() return "^ Choose who this card targets" end,
        ask_challenge = function(i) return fmt("^ 前の方はまだ%sの手札[W]を持っていると思いますか?", c(i)) end,
        ask_color = function() return "^ 次の色を指定してください" end,
        ask_keep_play = function() return "^ 引いたカードすぐを出しますか?" end,
        ask_target = function() return "^ 手札を交換する相手を指定してください" end,
        btn_ask = function(active) return active and "[Y]<任意>" or "<任意>" end,
        btn_auto = function() return "<オート>" end,
        btn_back = function() return "<戻る>" end,
        btn_keep = function(active) return active and "[R]<保留>" or "<保留>" end,
        btn_lang = function() return "[G]<日本語>" end,
        btn_load = function() return "[G]<読取>" end,
        btn_play = function(active) return active and "[G]<出す>" or "<出す>" end,
        btn_save = function() return "[B]<保存>" end,
        btn_settings = function(active) return active and "[Y]<設定>" or "<設定>" end,
        info_0_rotate = function() return "手札を次の方に転送しました" end,
        info_7_swap = function(i1, i2) return fmt("%sは%sと手札を交換しました", p(i1), p(i2)) end,
        info_cannotDraw = function(i1, i2) return fmt("%sは手札を %d 枚以上持てません", p(i1), i2) end,
        info_cannotPlay = function(s) return fmt("%s[W] を出せません", s) end,
        info_challenge = function(i1, i2, i3) return fmt("%sは%sが%sの手札[W]を持っていると思う", p(i1), p(i2), c(i3)) end,
        info_challengeFailure = function(i) return fmt("チャレンジ失敗、%sは手札を 6 枚引く", p(i)) end,
        info_challengeSuccess = function(i) return fmt("チャレンジ成功、%sは手札を 4 枚引く", p(i)) end,
        info_clickAgainToPlay = function(s) return fmt("もう一度クリックして %s[W] を出す", s) end,
        info_dirChanged = function() return "方向が変わりました" end,
        info_gameOver = function(i1, i2)
            return i2 < 0 and fmt("スコア: %d[R](%d)[W]. UNO をクリックして再開", i1, i2)
                or fmt("スコア: %d[G](%+d)[W]. UNO をクリックして再開", i1, i2)
        end,
        info_loadFailed = function(s) return "[Y]読み込み失敗 " .. s end,
        info_noReplays = function() return "リプレイがありません。ゲーム後に<保存>するか、.sav をドロップしてください" end,
        info_pickReplay = function() return "リプレイを選択  (.sav ファイルをウィンドウにドロップでも可)" end,
        info_ready = function() return "準備完了" end,
        info_ruleSettings = function() return "ルール設定" end,
        info_save = function(s)
            return (s == nil or s == "") and "リプレイファイルは保存できませんでした"
                or fmt("リプレイファイルは %s として保存しました", s)
        end,
        info_skipped = function(i) return fmt("%sの番はスキップされました", p(i)) end,
        info_welcome = function() return "UNO へようこそ! UNO をクリックしてゲームスタート" end,
        info_yourTurn = function() return "手札を一枚出すか、デッキから手札を一枚引く" end,
        info_yourTurn_stackDraw2 = function(i1, i2)
            return (i2 or 1) == 1 and fmt("+2 を一枚重ねるか、デッキから手札を %d 枚引く", i1)
                or fmt("+2/+4 を一枚重ねるか、デッキから手札を %d 枚引く", i1)
        end,
        label_bgm = function() return "音楽" end,
        label_bullseye = function(active) return "Bullseye targeting: " .. (active and "[G]ON" or "[R]OFF") end,
        label_drawToMatch = function(active) return "Draw to match: " .. (active and "[G]ON" or "[R]OFF") end,
        label_forcePlay = function() return "出せる手札を引いた時:" end,
        label_initialCards = function(i) return fmt("最初の手札数: %02d", i) end,
        label_lacks = function(n, e, w, s) return lacks("欠色:", n, e, w, s) end,
        label_leftArrow = function() return "[Y]＜－" end,
        label_level = function(i) return i == 0 and "難易度: 　簡単" or "難易度: 難しい" end,
        label_no = function() return "いいえ" end,
        label_players = function(i) return i == 3 and "Players:   3P" or "Players:   4P" end,
        label_remain_used = function(i1, i2) return fmt("[Y]残%d[G]使%d", i1, i2) end,
        label_rightArrow = function() return "[Y]＋＞" end,
        label_score = function() return "スコア" end,
        label_settingsPage = function(i1, i2) return fmt("PAGE %d/%d", i1, i2) end,
        label_sevenZeroRule = function(active) return "7-0 Rule: " .. (active and "[G]ON" or "[R]OFF") end,
        label_snd = function() return "音声" end,
        label_speed = function() return "速さ" end,
        label_stackRule = function(i)
            return i == 0 and "積み重ね可: 　　なし" or i == 1 and "積み重ね可: ＋２のみ"
                or "積み重ね可: ＋２＋４"
        end,
        label_twoVsTwoRule = function(active) return "2vs2 Rule: " .. (active and "[G]ON" or "[R]OFF") end,
        label_wildDraw4Challenge = function(active)
            return "Wild +4 challenge: " .. (active and "[G]ON" or "[R]OFF")
        end,
        label_yes = function() return "はい" end,
    }
end

--- Language codes in the order they are cycled through by the <LANG> button.
I18N.order = { "en", "zh", "ja" }

return I18N
