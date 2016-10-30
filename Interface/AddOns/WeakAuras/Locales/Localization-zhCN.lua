if not(GetLocale() == "zhCN") then
    return;
end

local L = WeakAuras.L

-- Options translation
L["<"] = "＜"
L["<="] = "≤"
L["="] = "＝"
L[">"] = "＞"
L[">="] = "≥"
L["!="] = "≠"
L["10 Man Raid"] = "10人团队"
L["20 Man Raid"] = "20人团队" -- Needs review
L["25 Man Raid"] = "25人团队"
L["40 Man Raid"] = "40人团队" -- Needs review
L["5 Man Dungeon"] = "5人地下城"
L["Absorb"] = "吸收"
L["Absorbed"] = "已吸收"
L["Action Usable"] = "动作可以使用"
L["Additional Trigger Replacements"] = "额外触发器替代品" -- Needs review
L["Affected"] = "受到影响"
L["Aggro"] = "引起仇恨" -- Needs review
L["Alive"] = "存活"
L["Alliance"] = "联盟" -- Needs review
L["Allow partial matches"] = "允许部分匹配" -- Needs review
L["All Triggers"] = "全部符合"
L["Alternate Power"] = "特殊能量(BOSS战中)"
L["Always"] = "总是" -- Needs review
L["Always active trigger"] = "总是启用触发器" -- Needs review
L["Ambience"] = "环境音"
L["Amount"] = "数量"
L["Anticlockwise"] = "逆时针" -- Needs review
L["Any Triggers"] = "任意符合"
L["Arena"] = "竞技场"
L["Ascending"] = "升序"
L["Assist"] = "协助" -- Needs review
L["At Least One Enemy"] = "至少一个敌人"
L["Attackable"] = "可攻击的"
L["Aura"] = "光环"
L["Aura:"] = "光环:"
L["Aura Applied"] = "获得光环"
L["Aura Applied Dose"] = "光环堆叠"
L["Aura Broken"] = "光环被打破"
L["Aura Broken Spell"] = "打破光环法术"
L["Aura Name"] = "光环名或ID" -- Needs review
L["Aura Refresh"] = "光环被刷新"
L["Aura Removed"] = "光环被移除"
L["Aura Removed Dose"] = "光环效果减少"
L["Auras:"] = "光环:"
L["Aura Stack"] = "光环层数" -- Needs review
L["Aura Type"] = "光环类型"
L["Automatic"] = "自动"
L["Automatic Rotation"] = "自动旋转" -- Needs review
-- L["Back"] = ""
L["Back and Forth"] = "往返"
L["Battleground"] = "战场"
L["Battle.net Whisper"] = "战网好友密语"
L["BG>Raid>Party>Say"] = "战场>团队>小队>说"
L["BG-System Alliance"] = "联盟战场特定事件"
L["BG-System Horde"] = "部落战场特定事件"
L["BG-System Neutral"] = "战场普通事件"
L["BigWigs Addon"] = "BigWigs 插件" -- Needs review
L["BigWigs Message"] = "BigWigs信息" -- Needs review
L["BigWigs Timer"] = "BigWigs 计时器" -- Needs review
L["Blizzard Combat Text"] = "暴雪战斗文字"
L["Block"] = "格挡"
L["Blocked"] = "被格挡"
L["Boss Emote"] = "首领台词"
-- L["Boss Whisper"] = ""
L["Bottom"] = "下"
L["Bottom Left"] = "左下"
L["Bottom Right"] = "右下"
L["Bottom to Top"] = "从下到上"
L["Bounce"] = "弹跳"
L["Bounce with Decay"] = "衰减地弹跳"
L["Buff"] = "Buff"
L["Cast"] = "施法"
L["Caster"] = "施放者" -- Needs review
L["Cast Failed"] = "施法失败"
L["Cast Start"] = "开始施法"
L["Cast Success"] = "施法成功"
L["Cast Type"] = "施法类型"
L["Center"] = "中间"
L["Centered Horizontal"] = "中部水平对齐"
L["Centered Vertical"] = "中部垂直对齐"
L["Challenge"] = "挑战" -- Needs review
L["Channel"] = "频道"
L["Channel (Spell)"] = "引导法术"
L["Character Type"] = "角色类型"
L["Charges"] = "充能" -- Needs review
L["Chat Frame"] = "聊天窗口"
L["Chat Message"] = "聊天讯息"
-- L["Chest"] = ""
L["Children:"] = "子元素:"
L["Circle"] = "环形"
L["Circular"] = "圆形布局"
L["Class"] = "职业"
L["Click to close configuration"] = "点击关闭配置"
L["Click to open configuration"] = "点击打开配置"
L["Clockwise"] = "顺时针" -- Needs review
L["Clone per Event"] = "复制每项事件" -- Needs review
L["Clone per Match"] = "复制每项符合项" -- Needs review
L["Combat Log"] = "战斗记录"
L["Conditions"] = "常用状态"
L["Contains"] = "包含"
-- L["Cooldown Progress (Equipment Slot)"] = ""
L["Cooldown Progress (Item)"] = "冷却进度(物品)"
L["Cooldown Progress (Spell)"] = "冷却进度(法术)"
L["Cooldown Ready (Item)"] = "冷却完成(物品)"
L["Cooldown Ready (Spell)"] = "冷却完成(法术)"
L["Create"] = "创造物品"
L["Critical"] = "爆击(致命一击)"
L["Crowd Controlled"] = "被控制"
L["Crushing"] = "碾压"
L["Curse"] = "诅咒"
L["Custom"] = "自定义"
L["Custom Function"] = "自定义函数"
L["Damage"] = "伤害"
L["Damager"] = "伤害输出"
L["Damage Shield"] = "护盾(如:荆棘术)伤害"
L["Damage Shield Missed"] = "护盾伤害未命中"
L["Damage Split"] = "伤害分担"
L["DBM Announce"] = "DBM 通知" -- Needs review
L["DBM Timer"] = "DBM 计时器" -- Needs review
L["Death Knight Rune"] = "死亡骑士符文"
L["Debuff"] = "Debuff"
L["Defensive"] = "防御" -- Needs review
L["Deflect"] = "偏斜"
L["Descending"] = "降序"
L["Destination Name"] = "目标名称"
L["Destination Unit"] = "目标单位"
L["Dialog"] = "对话框" -- Needs review
L["Disease"] = "疾病"
L["Dispel"] = "驱散"
L["Dispel Failed"] = "驱散失败"
L["Dodge"] = "躲闪"
L["Done"] = "完成"
L["Down"] = "下"
L["Drain"] = "引导性吸取"
L["Drowning"] = "溺水"
L["Dungeon Difficulty"] = "地下城难度"
L["Durability Damage"] = "耐久度下降"
L["Durability Damage All"] = "耐久度上限下降"
L["Emote"] = "表情"
L["Empty"] = "高光 显示/隐藏" -- Needs review
L["Encounter ID"] = "首领战ID" -- Needs review
L["Energize"] = "能量值恢复"
L["Enrage"] = "激怒"
L["Environmental"] = "环境伤害"
L["Environment Type"] = "环境伤害类型"
-- L["Equipment Slot"] = ""
L["Evade"] = "闪避"
L["Event"] = "事件"
L["Event(s)"] = "事件"
L["Every Frame"] = "所有框架"
L["Extra Amount"] = "额外数量"
L["Extra Attacks"] = "额外攻击"
L["Extra Spell Name"] = "额外法术名称"
L["Fade In"] = "淡入"
L["Fade Out"] = "淡出"
L["Fail Alert"] = "失误警报" -- Needs review
L["Falling"] = "掉落"
L["Fatigue"] = "疲倦"
-- L["Feet"] = ""
-- L["Finger 1"] = ""
-- L["Finger 2"] = ""
L["Fire"] = "火焰"
L["Fishing Lure / Weapon Enchant (Old)"] = "鱼饵/武器附魔（旧的）" -- Needs review
L["Flash"] = "闪动"
L["Flex Raid"] = "弹性团队" -- Needs review
L["Flip"] = "翻转"
L["Focus"] = "焦点目标/集中值"
L["Form"] = "形态"
L["Friendly"] = "友善的"
L["Friendly Fire"] = "友方伤害" -- Needs review
L["From"] = "从"
L["Full"] = "完全" -- Needs review
L["Full/Empty"] = "全/空" -- Needs review
L["Glancing"] = "躲闪"
L["Global Cooldown"] = "公共CD(GCD)"
L["Glow"] = "发光"
L["Gradient"] = "梯度"
L["Gradient Pulse"] = "梯度脉动"
L["Group"] = "群组/队伍"
L["Group %s"] = "群组 %s"
L["Grow"] = "延伸"
L["GTFO Alert"] = "GTFO警报" -- Needs review
L["Guild"] = "公会"
-- L["Hands"] = ""
L["HasPet"] = "有宠物"
L["Has Vehicle UI"] = "有载具UI" -- Needs review
-- L["Head"] = ""
L["Heal"] = "治疗"
L["Healer"] = "治疗"
L["Health"] = "生命值"
L["Health (%)"] = "生命值百分比(%%)"
L["Heroic"] = "英雄难度"
L["Hide"] = "隐藏"
L["High Damage"] = "高伤害" -- Needs review
L["Higher Than Tank"] = "比MT高"
L["Horde"] = "部落" -- Needs review
L["Hostile"] = "敌对的"
L["Hostility"] = "敌对"
L["Humanoid"] = "人形态"
L["Hybrid"] = "混合" -- Needs review
L["Icon"] = "图标"
-- L["Id"] = ""
L["Ignore Rune CD"] = "忽略符文CD"
L["Immune"] = "免疫"
L["Include Bank"] = "包括银行中的"
L["Include Charges"] = "包含使用次数"
L["In Combat"] = "战斗中"
L["Inherited"] = "继承"
L["In Pet Battle"] = "宠物对战中"
L["Inside"] = "内部"
L["Instakill"] = "术士牺牲爪牙"
L["Instance"] = "即时" -- Needs review
L["Instance Type"] = "副本类型"
L["Interrupt"] = "打断"
L["Interruptible"] = "可打断"
L["In Vehicle"] = "在载具中"
L["Inverse"] = "反向"
L["Is Exactly"] = "完全匹配"
L["Is Moving"] = "移动中" -- Needs review
L["Is Off Hand"] = "是副手" -- Needs review
-- L["is useable"] = ""
L["Item"] = "物品"
L["Item Count"] = "物品数量"
L["Item Equipped"] = "已装备物品"
L["Item Set"] = "物品组" -- Needs review
L["Item Set Equipped"] = "已装备物品组" -- Needs review
L["Lava"] = "熔岩"
L["Leech"] = "吸取"
L["Left"] = "左"
L["Left to Right"] = "从左到右"
-- L["Legs"] = ""
L["Level"] = "等级"
L["Looking for Raid"] = "寻找团队" -- Needs review
L["Low Damage"] = "低伤害" -- Needs review
L["Lower Than Tank"] = "比MT低"
L["Magic"] = "魔法"
L["Main Hand"] = "主手"
L["Manual Rotation"] = "手动旋转"
-- L["Marked First"] = ""
-- L["Marked Last"] = ""
L["Master"] = "主声道"
L["Matches (Pattern)"] = "匹配(表达式)"
L["Message"] = "讯息"
L["Message type:"] = "讯息类型:"
L["Message Type"] = "讯息类型"
L["Miss"] = "未命中"
L["Missed"] = "未命中"
L["Missing"] = "缺少"
L["Miss Type"] = "未命中类型"
L["Monochrome"] = "单色" -- Needs review
L["Monochrome Outline"] = "单色轮廓" -- Needs review
L["Monochrome Thick Outline"] = "单色粗轮廓" -- Needs review
-- L["Monster Emote"] = ""
-- L["Monster Party"] = ""
-- L["Monster Say"] = ""
-- L["Monster Whisper"] = ""
L["Monster Yell"] = "怪物大喊"
L["Mounted"] = "在坐骑上"
L["Multistrike"] = "溅射"
L["Multi-target"] = "多目标"
L["Music"] = "音乐"
L["Mythic"] = "史诗"
L["Name"] = "名称"
-- L["Neck"] = ""
L["Neutral"] = "中立" -- Needs review
L["Never"] = "从不"
L["Next"] = "下一个"
L["No Children:"] = "没有子元素:"
L["No Instance"] = "没有队伍"
L["None"] = "无"
L["Non-player Character"] = "NPC"
L["Normal"] = "正常形态"
L["Not on cooldown"] = "不在冷却中" -- Needs review
L["Not On Threat Table"] = "不在仇恨列表"
L["Number"] = "数字"
L["Number Affected"] = "影响数"
L["Off Hand"] = "副手"
L["Officer"] = "官员"
L["On cooldown"] = "在冷却中" -- Needs review
-- L["Only if Primary"] = ""
L["Opaque"] = "不透明"
L["Orbit"] = "轨迹"
L["Outline"] = "轮廓"
L["Outside"] = "外部"
L["Overhealing"] = "过量治疗"
L["Overkill"] = "过量伤害"
L["Parry"] = "招架"
L["Party"] = "队伍"
L["Party Kill"] = "团/队击杀"
L["Passive"] = "被动" -- Needs review
L["Paused"] = "已暂停"
L["Periodic Spell"] = "周期法术"
L["Pet"] = "宠物"
L["Pet Behavior"] = "宠物姿态"
L["Player"] = "玩家"
L["Player Character"] = "玩家角色"
L["Player Class"] = "玩家职业"
L["Player Dungeon Role"] = "玩家地下城角色"
L["Player Faction"] = "玩家阵营" -- Needs review
L["Player Level"] = "玩家等级"
L["Player Name"] = "玩家名"
L["Player Race"] = "玩家种族" -- Needs review
L["Player(s) Affected"] = "受影响的玩家"
L["Player(s) Not Affected"] = "没有受影响的玩家"
L["Poison"] = "中毒"
L["Power"] = "能量"
L["Power (%)"] = "能量(%%)"
L["Power Type"] = "能量类型"
L["Preset"] = "预设"
L["Progress"] = "进度"
L["Pulse"] = "脉动"
L["PvP Flagged"] = "被标记为PVP状态"
L["PvP Talent selected"] = "已选PvP天赋" -- Needs review
L["Radius"] = "半径"
L["Raid"] = "团队"
L["Raid Warning"] = "团队警告" -- Needs review
L["Range"] = "远程攻击"
L["Ready Check"] = "就位确认" -- Needs review
L["Realm"] = "服务器" -- Needs review
L["Receiving display information"] = "从 %s 中接收群组信息"
L["Reflect"] = "反射"
L["Region type %s not supported"] = "不支持区域类 %s" -- Needs review
L["Relative"] = "相对持续时间"
L["Remaining Time"] = "剩余时间"
L["Requested display does not exist"] = "请求接收的图示不存在"
L["Requested display not authorized"] = "请求接收的图示没有授权"
L["Require Valid Target"] = "需要有效目标"
L["Resist"] = "抵抗"
L["Resisted"] = "被抵抗"
L["Resolve collisions dialog"] = [=[你安装的插件中定义了与|cFF8800FFWeakAuras|r 图示相同名称的变量。

你必须重新命名你的图示。

已解决: |cFFFF0000]=]
L["Resolve collisions dialog singular"] = [=[你安装的插件中定义了与|cFF8800FFWeakAuras|r 图示相同名称的变量。

你必须重新命名你的图示。

已解决: |cFFFF0000]=]
L["Resolve collisions dialog startup"] = [=[你安装的插件中定义了与|cFF8800FFWeakAuras|r 图示相同名称的变量。

你必须重新命名你的图示。

已解决: |cFFFF0000]=]
L["Resolve collisions dialog startup singular"] = [=[你安装的插件中定义了与|cFF8800FFWeakAuras|r 图示相同名称的变量。

你必须重新命名你的图示。

已解决: |cFFFF0000]=]
L["Resting"] = "休息状态"
L["Resurrect"] = "复活"
L["Right"] = "右"
L["Right to Left"] = "从右到左"
L["Rotate Left"] = "向左旋转"
L["Rotate Right"] = "向右旋转"
L["Rune"] = "符文"
L["Rune #1"] = "符文#1" -- Needs review
L["Rune #2"] = "符文 #2" -- Needs review
L["Rune #3"] = "符文 #3" -- Needs review
L["Rune #4"] = "符文 #4" -- Needs review
L["Rune #5"] = "符文 #5" -- Needs review
L["Rune #6"] = "符文 #6" -- Needs review
L["Runes Count"] = "符文计数" -- Needs review
L["%s - 1. Trigger"] = "%s - 1. 触发器" -- Needs review
L["%s - Alpha Animation"] = "%s - 透明度动画" -- Needs review
L["Say"] = "说"
L["Scenario"] = "场景" -- Needs review
L["%s - Color Animation"] = "%s - 颜色动画" -- Needs review
L["%s - Custom Text"] = "%s 自定义文字" -- Needs review
L["%s Duration Function"] = "%s 持续时间功能" -- Needs review
L["Seconds"] = "秒"
L["%s - Finish"] = "%s - 完成" -- Needs review
L["%s - Finish Action"] = "%s - 完成动作" -- Needs review
L["Shake"] = "晃动"
L["Shift-Click to pause"] = "Shift点击暂停"
L["Shift-Click to resume"] = "Shift点击继续"
-- L["Shoulder"] = ""
L["Show"] = "显示"
L["Show Code"] = "显示代码" -- Needs review
L["Shrink"] = "收缩"
L["%s Icon Function"] = "%s 图标功能" -- Needs review
L["%s - Init Action"] = "%s - 初始动作"
L["%s - %i. Trigger"] = "%s - %i. 触发器"
L["Slide from Bottom"] = "从下开始滑动"
L["Slide from Left"] = "从左开始滑动"
L["Slide from Right"] = "从右开始滑动"
L["Slide from Top"] = "从上开始滑动"
L["Slide to Bottom"] = "滑动到下方"
L["Slide to Left"] = "滑动到左边"
L["Slide to Right"] = "滑动到右边"
L["Slide to Top"] = "滑动到上方"
L["Slime"] = "淤泥"
L["%s - Main"] = "%s - 主要" -- Needs review
L["%s Name Function"] = "%s 名字功能" -- Needs review
L["Sound Effects"] = "音效"
L["Source Name"] = "来源名称"
L["Source Unit"] = "来源单位"
L["Spacing"] = "间距"
L["Specific Unit"] = "指定单位"
L["Spell"] = "法术"
L["Spell (Building)"] = "法术(攻城伤害)"
L["Spell/Encounter Id"] = "法术/战斗Id" -- Needs review
L["Spell Id"] = "法术Id" -- Needs review
L["Spell ID"] = "法术ID" -- Needs review
-- L["Spell Known"] = ""
L["Spell Name"] = "法术名称"
L["Spin"] = "旋转"
L["Spiral"] = "螺旋"
L["Spiral In And Out"] = "螺旋进入和退出"
L["%s - Rotate Animation"] = "%s - 旋转动画" -- Needs review
L["%s - Scale Animation"] = "%s - 尺寸动画" -- Needs review
L["%s Stacks Function"] = "%s 堆叠功能" -- Needs review
L["%s - Start"] = "%s - 开始" -- Needs review
L["%s - Start Action"] = "%s - 开始动作"
L["Stacks"] = "层数" -- Needs review
L["Stagger"] = "晕眩" -- Needs review
L["Stance/Form/Aura"] = "姿态/形态/光环"
L["Status"] = "状态"
L["%s Texture Function"] = "%s 材质功能" -- Needs review
L["Stolen"] = "偷取"
L["%s total auras"] = "%s 总光环数" -- Needs review
L["%s - Translate Animation"] = "%s - 平移动画" -- Needs review
L["%s Trigger Function"] = "%s 触发功能" -- Needs review
L["%s - Trigger Logic"] = "%s - 触发逻辑" -- Needs review
L["Summon"] = "召唤"
L["%s Untrigger Function"] = "%s 取消触发功能" -- Needs review
L["Swing"] = "近战攻击"
L["Swing Timer"] = "攻击间隔计时器"
L["System"] = "系统" -- Needs review
-- L["Tabard"] = ""
L["Talent selected"] = "天赋选择"
L["Talent Specialization"] = "专精" -- Needs review
L["Tank"] = "坦克"
L["Tanking And Highest"] = "做T并且最高"
L["Tanking But Not Highest"] = "做T但不是最高"
L["Target"] = "目标"
L["Thick Outline"] = "粗轮廓"
L["Threat Situation"] = "仇恨状况"
L["Tier "] = "层级" -- Needs review
L["Timed"] = "指定时间"
-- L["Timewalking"] = ""
L["Top"] = "上"
L["Top Left"] = "左上"
L["Top Right"] = "右上"
L["Top to Bottom"] = "从上到下"
L["Total"] = "总共"
L["Totem"] = "图腾"
L["Totem #%i"] = "图腾#%i" -- Needs review
L["Totem Name"] = "图腾名"
L["Totem Number"] = "图腾" -- Needs review
L["Transmission error"] = "传输错误"
L["Trigger:"] = "触发器"
L["Trigger State Updater"] = "触发器状态更新器" -- Needs review
L["Trigger Update"] = "触发器更新"
-- L["Trinket 1"] = ""
-- L["Trinket 2"] = ""
L["Undefined"] = "未定义"
L["Unit"] = "单位"
L["Unit Characteristics"] = "单位特性"
L["Unit Destroyed"] = "单位被摧毁(如:图腾,治疗结界)"
L["Unit Died"] = "单位死亡"
L["Up"] = "上"
L["Version error received higher"] = "此图示不相容于你目前使用的WeakAuras版本 - 它由版本%s创建，但是你的版本是%s。请更新你的WeakAuras版本。" -- Needs review
L["Version error received lower"] = "此图示不相容于你目前使用的WeakAuras版本 - 它由版本%s创建，但是你的版本是%s。请提示此人更新他的WeakAuras版本。" -- Needs review
-- L["Waist"] = ""
L["Weapon"] = "武器"
L["Weapon Enchant"] = "武器附魔" -- Needs review
L["Whisper"] = "密语"
L["Wobble"] = "摇晃"
-- L["Wrist"] = ""
L["Yell"] = "大喊"
L["Zone"] = "区域"
L["Zone ID"] = "区域ID" -- Needs review
L["Zone ID List"] = "区域ID列表" -- Needs review



