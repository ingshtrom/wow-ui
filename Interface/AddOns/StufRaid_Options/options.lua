if not StufRaid then return end
local core = StufRaid
local db

-- libraries
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local smed = LibStub("LibSharedMedia-3.0")

-- for external localization, make a mod titled StufRaid_OptionsLocale and create table StufRaidOptionsLocalization
local rawget = rawget
local L = setmetatable(StufRaidOptionsLocalization or { 

}, 
{
	__index = function(self, key)
		return rawget(self, key) or key
	end
})

local GetSpellInfo = GetSpellInfo

-- setups blizzard options frame 
local optionframe, updateminmax
local function CreateOptionFrame()
	if optionframe then return end
	optionframe = AceConfigDialog:AddToBlizOptions("StufRaid", "StufRaid")
	optionframe.fshow = CreateFrame("Frame", nil, optionframe)
	optionframe.fshow:SetScript("OnShow", function(this)
		local w = InterfaceOptionsFrame:GetWidth()
		if not InterfaceOptionsFrame:IsMovable() then
			this.p, this.rt, this.rp, this.x, this.y = InterfaceOptionsFrame:GetPoint()
			InterfaceOptionsFrame:SetMovable(true)
			InterfaceOptionsFrame:RegisterForDrag("LeftButton")
			InterfaceOptionsFrame:SetScript("OnDragStart", InterfaceOptionsFrame.StartMoving)
			InterfaceOptionsFrame:SetScript("OnDragStop", InterfaceOptionsFrame.StopMovingOrSizing)
			this.moved = true
		end
		if w < 860 then
			this.oldw = w
			InterfaceOptionsFrame:SetWidth(860)
		else
			this.oldw = nil
		end
		updateminmax()
	end)
	optionframe.fshow:SetScript("OnHide", function(this)
		if this.oldw then
			InterfaceOptionsFrame:SetWidth(this.oldw)
			this.oldw = nil
		end
		if this.moved then
			InterfaceOptionsFrame:SetMovable(false)
			InterfaceOptionsFrame:RegisterForDrag()
			InterfaceOptionsFrame:SetScript("OnDragStart", nil)
			InterfaceOptionsFrame:SetScript("OnDragStop", nil)
			InterfaceOptionsFrame:ClearAllPoints()
			InterfaceOptionsFrame:SetPoint(this.p, this.rt, this.rp, this.x, this.y)
		end
	end)
end

-------------------------------------------------
function core.LoadDefaults(db, onlychar, restore, perchar)
-------------------------------------------------
	CreateOptionFrame()
	if not StufRaidCharDB then
		StufRaidCharDB = {
			bshow = "raid", dshow = "raid",
			binclude = { }, bexclude = { },
			dinclude = { }, dexclude = { [GetSpellInfo(28169)] = true, }, -- Mutating Injection
			dalert = { },
			balert = { },
		}
		
		local function AddSpells(tdb, tspellid)
			for _, spellid in ipairs(tspellid) do
				local spellname = GetSpellInfo(spellid)
				if spellname then
					tdb[spellname] = true
				end
			end
		end
		AddSpells(StufRaidCharDB.dalert, {
			15007, -- Resurrection Sickness
			33786, -- Cyclone
			12294, -- Mortal Strike
			19434, -- Aimed Shot
			13218, -- Wound Poison
			13222, -- Wound Poison II
			13223, -- Wound Poison III
			13224, -- Wound Poison IV
			27189, -- Wound Poison V
			57974, -- Wound Poison VI
			57975, -- Wound Poison VII
			46911, -- Furious Attacks
			28526, -- Sapphiron Icebolt
			28622, -- Maexxna Web Wrap
			54378, -- Gluth Mortal Wound
			28410, -- Chains of Kel'Thuzad
			27808, -- Kel'Thuzad Frost Blast
			61079, -- Malygos Arcane Breath
			46392, -- Focused Assault (10-min WSG debuff)
			46393, -- Brutal Assault (15-min WSG debuff)
		})
		AddSpells(StufRaidCharDB.balert, {
			871, -- Shield Wall
			12975, -- Last Stand
			1022, -- Hand of Protection
			19752, -- Divine Intervention
			642, -- Divine Shield
			498, -- Divine Protection
			1022, -- Hand of Protection
			6940, -- Hand of Sacrifice
			5277, -- Evasion
			1856, -- Vanish
			31230, -- Cheat Death
			45182, -- Cheating Death
			31224, -- Cloak of Shadows
			5384, -- Feign Death
			35079, -- Misdirection
			29166, -- Innervate
			45438, -- Ice Block
			66, -- Invisibility
			20711, -- Spirit of Redemption
			47788, -- Guardian Spirit
			586, -- Fade
			33206, -- Pain Suppression
			52143, -- Master of Ghouls
			61999, -- Raise Ally
			23335, -- Silverwing Flag
			23333, -- Warsong Flag
			34976, -- Netherstorm Flag
			23505, -- Berserking (BG buff)
			34709, -- Shadow Sight (Arena buff)
		})
	end
	
	if onlychar then return end
	
	local cw, ch = floor(GetScreenWidth()/2), floor(GetScreenHeight()/2)
	local defaults = {
		texture = (StufDB and StufDB.global and StufDB.global.bartexture) or "Blizzard",
		namefont = (StufDB and StufDB.global and StufDB.global.font) or smed:GetDefault("font"),
		numfont = (StufDB and StufDB.global and StufDB.global.font) or smed:GetDefault("font"),
		border = "Corners 1pt",
		shortstart = 0,
		ooralpha=0.6, deadalpha=0.3,
		basec = { r=0.5, g=0.5, b=0.5, a=0.8, },
		backc = { r=0, g=0, b=0, a=0, },
		bordc = { r=0.2, g=0.2, b=0.2, a=0, },
		targetc = { r=0.7, g=0.7, b=0, a=0.7, },
		aggroc = { r=1, g=0, b=0, a=0.9, },
		mousec = { r=1, g=1, b=0.5, a=0.8, },
		tshadowc = { r=0, g=0, b=0, a=0.8, },
		powercolor = { },
		classcolor = { },
		reactioncolor = { },
		fontsize=6,
		fontcolor={ r=1, g=1, b=1, a=0.7 },
		deadtext = "dead",
		ghosttext = "ghost",
		offlinetext = "d/c",
		raid = {
			w=33, h=40,
			showanchor=true, anchorx=cw-140, anchory=-ch+50,
			ttcustom=true, ttanchor="TOPRIGHT", ttx=-100, tty=40, ttcombathide=nil,
			hpbar = {
				x=1, y=-1, w=30, h=35,
				barcolormethod="class", bgcolor={ r=0, g=0, b=0, a=1, }, baralpha=0.8,
				vertical=true, fill=true, reverse=true, fulldead=true,
			},
			mpbar = { x=1, y=-36, w=30, h=2, barcolormethod="power", bgcolormethod="powerdark", },
			nametext = { x=2, y=-1, w=28, h=9, fontsize=9, chars=4, colormethod="class", },
			hptext = { x=-1, y=-13, w=34, h=10, fontsize=9, fontcolor={ r=1, g=0, b=0, a=1, }, textformat="deficit" },
			mptext = { hide=true, x=1, y=-30, w=30, h=9, fontsize=8, textformat="perc", },
			buff = { x=1, y=-36, w=6, h=6, alpha=0.5, growth="BTLR", rows=6, cols=1, },
			debuff = { x=1, y=-36, w=10, h=10, alpha=0.8, growth="BTLR", rows=3, cols=1, hidebuff=true, },
			alert = { x=30, y=-36, w=10, h=10, alpha=0.9, growth="BTRL", rows=3, cols=1, },
			combaticon = { hide=true, x=5, y=-1, w=6, h=6, alpha=0.8, },
			raidicon = { x=0, y=-1, w=6, h=6, alpha=0.8, },
			voiceicon = { hide=true, x=12, y=-28, w=10, h=10, alpha=0.8, },
			leadericon = { x=27, y=0, w=6, h=6, alpha=0.8, },
			looticon = { x=22, y=0, w=6, h=6, alpha=0.8, },
			group1 = { order="1", classorder="WARRIOR", x=-10, y=-7, growth="TBLR", cols=1, rows=5, },  -- 1
			group2 = { order="2", classorder="ROGUE", x=-43, y=-7, growth="TBLR", cols=1, rows=5, },  -- 2
			group3 = { order="3", classorder="DEATHKNIGHT", x=-76, y=-7, growth="TBLR", cols=1, rows=5, },  -- 3
			group4 = { order="4", classorder="DRUID", x=-109, y=-7, growth="TBLR", cols=1, rows=5, },  -- 4
			group5 = { order="5", classorder="PALADIN", x=-142, y=-7, growth="TBLR", cols=1, rows=5, },  -- 5
			group6 = { order="6", classorder="SHAMAN", x=-175, y=-7, growth="TBLR", cols=1, rows=5, },  -- 6
			group7 = { order="7", classorder="HUNTER", x=-208, y=-7, growth="TBLR", cols=1, rows=5, },  -- 7
			group8 = { order="8", classorder="PRIEST", x=-241, y=-7, growth="TBLR", cols=1, rows=5, },  -- 8
			group9 = { hide=true, classorder="WARLOCK", x=-274, y=-7, growth="TBLR", cols=1, rows=5, },  -- 9
			group10 = { hide=true, classorder="MAGE", x=-307, y=-7, growth="TBLR", cols=1, rows=5, },  -- 10
		},
		raidpet = { 
			w=33, h=12,
			showanchor=true, anchorx=cw-140, anchory=-160-ch,
			ttcustom=true, ttanchor="BOTTOMRIGHT", ttx=8, tty=0,
			hpbar = {
				x=1, y=-1, w=30, h=10,
				barcolormethod="class", bgcolor={ r=0, g=0, b=0, a=1, }, baralpha=0.8,
				fill=true, reverse=true, fulldead=true,
			},
			nametext = { x=2, y=-1, w=28, h=10, justifyH="LEFT", fontsize=8, chars=1, colormethod="class", },
			hptext = { x=2, y=-1, w=30, h=10, justifyH="RIGHT", fontsize=6, fontcolor={ r=1, g=0, b=0, a=1, }, textformat="perc" },
			raidicon = { x=0, y=-1, w=6, h=6, alpha=0.8, },
			group = { x=-10, y=-7, growth="TBRL", label="Pets", cols=9, rows=3, },
		},
		raidrole = {
			w=33, h=40,
			showanchor=true, anchorx=cw-205, anchory=-ch+62,
			ttcustom=true, ttanchor="TOPRIGHT", ttx=-22, tty=30, ttcombathide=nil,
			hpbar = {
				x=1, y=-1, w=30, h=35,
				barcolormethod="class", bgcolor={ r=0, g=0, b=0, a=1, }, baralpha=0.8,
				vertical=true, fill=true, reverse=true, fulldead=true,
			},
			mpbar = { x=1, y=-36, w=30, h=2, barcolormethod="power", bgcolormethod="powerdark", },
			nametext = { x=2, y=-1, w=28, h=9, fontsize=9, chars=3, colormethod="class", },
			hptext = { x=-1, y=-13, w=34, h=10, fontsize=9, fontcolor={ r=1, g=0, b=0, a=1, }, textformat="deficit" },
			mptext = { hide=true, x=1, y=-30, w=30, h=9, fontsize=8, textformat="perc", },
			buff = { x=1, y=-36, w=6, h=6, alpha=0.6, growth="BTLR", rows=6, cols=1, },
			debuff = { x=1, y=-36, w=10, h=10, alpha=0.8, growth="BTLR", rows=3, cols=1, hidebuff=true, },
			alert = { x=30, y=-36, w=10, h=10, alpha=0.9, growth="BTRL", rows=3, cols=1, },
			combaticon = { hide=true, x=5, y=-1, w=6, h=6, alpha=0.8, },
			raidicon = { x=0, y=-1, w=6, h=6, alpha=0.8, },
			group = { x=-10, y=-7, growth="BTLR", label="Roles", cols=1, rows=5, },
		},
		raidroletarget = {
			w=66, h=16,  tx=34, ty=0,  ttx=34, tty=-17,
			showt=true, showtt=true,
			hpbar = {
				x=1, y=-1, w=63, h=13,
				barcolormethod="reactiondark", bgcolormethod="reaction", baralpha=0.8,
				vertical=nil, fill=true, reverse=true, fulldead=nil,
			},
			nametext = { x=6, y=-1, w=42, h=13, fontsize=9, justifyH="LEFT", chars=0, colormethod="reaction", },
			hptext = { x=42, y=-1, w=22, h=13, fontsize=9, justifyH="RIGHT", textformat="perc", },
			raidicon = { x=0, y=-2, w=10, h=10, alpha=0.8, },
		},
	}
	for class, color in pairs(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
		defaults.classcolor[class] = { r=color.r, g=color.g, b=color.b, }
	end
	for index, color in pairs(FACTION_BAR_COLORS) do
		defaults.reactioncolor[index] = { r=color.r, g=color.g, b=color.b, }
	end
	for i = 0, 20, 1 do
		local color = PowerBarColor[i]
		if color then
			defaults.powercolor[i] = { r=color.r, g=color.g, b=color.b, }
		end
	end
	if restore then
		if perchar then
			StufRaidCharLayoutDB = defaults
			StufRaidCharLayoutDB.init = 1
		else
			StufRaidDB = defaults
			StufRaidDB.init = 1
		end
		ReloadUI()
	else
		local function SetDefaults(db, t)
			for k,v in pairs(t) do
				if type(db[k]) == "table" then
					SetDefaults(db[k], v)
				else
					if db[k] == nil and type(v) ~= "boolean" then
						db[k] = v
					end
					if db[k] == false then
						db[k] = nil
					end
				end
			end
		end
		SetDefaults(db, defaults)
	end
end

local cm = core.colormethods
local currentlayout

-- group layout preview handlers --------------------------------------------------------------------------------------
local gpframe
local function TTPreviewOnEnter(this)
	if this.layout.ttcombathide and InCombatLockdown() then
		return
	elseif this.layout.ttcustom then
		GameTooltip:SetOwner(this.anchor, "ANCHOR_"..(this.layout.ttanchor or "TOPRIGHT"), this.layout.ttx, this.layout.tty)
	else
		GameTooltip_SetDefaultAnchor(GameTooltip, this)
	end
	GameTooltip:SetText("Stuf Raid Frames")
	GameTooltip:AddLine(L["Tooltip goes here"].." "..L["Tooltip goes here"])
	GameTooltip:AddLine(L["Tooltip goes here"])
	GameTooltip:Show()
end
local function TTPreviewOnLeave(this)
	GameTooltip:Hide()
end
local function getdummyframe(supergroup, group, i, j)
	gpframe[supergroup] = gpframe[supergroup] or { }
	gpframe[supergroup][group] = gpframe[supergroup][group] or { }
	local f = gpframe[supergroup][group][i.."_"..j]
	if not f then
		gpframe[supergroup][group][i.."_"..j] = CreateFrame("Frame", nil, gpframe)
		f = gpframe[supergroup][group][i.."_"..j]
		f:EnableMouse(true)
		f:SetScript("OnEnter", TTPreviewOnEnter)
		f:SetScript("OnLeave", TTPreviewOnLeave)
		f.texture = f:CreateTexture(nil, "BACKGROUND")
		f.texture:SetPoint("TOPLEFT")
		f.texture:SetPoint("BOTTOMRIGHT", -1, 1)
		f.texture:SetTexture(core.texture)
		f.texture:SetVertexColor(0.6, 1, 0.6, 0.5)
	end
	return f
end
local function hidegroupframes(supergroup, group)
	if gpframe[supergroup] and gpframe[supergroup][group] then
		for index, frame in pairs(gpframe[supergroup][group]) do
			frame:Hide()
		end
	end
end
local function ShowRoleTarget(uf, supergroup, layout, anchor, i, j)
	if supergroup ~= "raidrole" then return end
	local rrtdb = db.raidroletarget
	if not rrtdb.showt then return end
	local t = getdummyframe("raidroletarget", "target", i, j)
	t.layout, t.anchor = layout, anchor
	t:SetWidth(rrtdb.w)
	t:SetHeight(rrtdb.h)
	t:SetPoint("TOPLEFT", uf, "TOPLEFT", rrtdb.tx, rrtdb.ty)
	t:Show()
	if rrtdb.showtt then
		local tt = getdummyframe("raidroletarget", "targettarget", i, j)
		tt.layout, tt.anchor = layout, anchor
		tt:SetWidth(rrtdb.w)
		tt:SetHeight(rrtdb.h)
		tt:SetPoint("TOPLEFT", uf, "TOPLEFT", rrtdb.ttx, rrtdb.tty)
		tt:Show()
	end
end
local function ShowGroupPreview(supergroup, group, label, anchor)
	local layout = db[supergroup]
	local db = db[supergroup][group]
	if db.hide or not anchor then
		return hidegroupframes(supergroup, group)
	end
	label:Show()
	
	anchor:EnableMouse(true)
	anchor:SetBackdropColor(0, 0, 0, 0.4)
	
	hidegroupframes(supergroup, group)
	if supergroup == "raidrole" then
		hidegroupframes("raidroletarget", "target")
		hidegroupframes("raidroletarget", "targettarget")
	end
	local d1, d2, d3, d4, hdir, vdir, hfirst = core.GrowthBreakdown(db.growth)
	if hfirst then
		local cspacing
		if vdir == 1 then
			cspacing = -((db.vspacing or 0) + layout.h * 2)
		else
			cspacing = db.vspacing or 0
		end
		for i = 1, db.rows, 1 do
			for j = 1, db.cols, 1 do
				local uf = getdummyframe(supergroup, group, i, j)
				uf.layout, uf.anchor = layout, anchor
				uf:ClearAllPoints()
				uf:SetWidth(layout.w)
				uf:SetHeight(layout.h)
				if i == 1 and j == 1 then
					uf:SetPoint(d1, anchor, "TOPLEFT", db.x, db.y - layout.h/2)
				elseif j == 1 then
					uf:SetPoint("TOP", getdummyframe(supergroup, group, i-1, j), "BOTTOM", 0, -cspacing)
				else
					uf:SetPoint(d1, getdummyframe(supergroup, group, i, j-1), d2, hdir * (db.hspacing or 0), 0)
				end
				uf:Show()
				ShowRoleTarget(uf, supergroup, layout, anchor, i, j)
			end
		end
	else
		local cspacing
		if hdir == -1 then
			cspacing = -((db.hspacing or 0) + layout.w * 2)
		else
			cspacing = db.hspacing or 0
		end
		for i = 1, db.cols, 1 do
			for j = 1, db.rows, 1 do
				local uf = getdummyframe(supergroup, group, i, j)
				uf.layout, uf.anchor = layout, anchor
				uf:ClearAllPoints()
				uf:SetWidth(layout.w)
				uf:SetHeight(layout.h)
				if i == 1 and j == 1 then
					uf:SetPoint(d1, anchor, "TOPLEFT", db.x + layout.w/2, db.y)
				elseif j == 1 then
					uf:SetPoint("LEFT", getdummyframe(supergroup, group, i-1, j), "RIGHT", cspacing, 0)
				else
					uf:SetPoint(d1, getdummyframe(supergroup, group, i, j-1), d2, 0, vdir * (db.vspacing or 0))
				end
				uf:Show()
				ShowRoleTarget(uf, supergroup, layout, anchor, i, j)
			end
		end
	end
end
local function PreviewGroups()
	if not gpframe or not gpframe:IsShown() then return end
	for i = 1, 10, 1 do
		ShowGroupPreview("raid", "group"..i, core.raid.labels[i], core.raid)
	end
	ShowGroupPreview("raidpet", "group", core.raidpet.label, core.raidpet)
	ShowGroupPreview("raidrole", "group", core.raidrole.label, core.raidrole)
end
local previewgroup = {
	name=L["Preview Groups"], type="toggle", order=1,
	set=function(info, v)
		db = db or (StufRaidDB ~= "perchar" and StufRaidDB) or StufRaidCharLayoutDB
		if v then
			gpframe = gpframe or CreateFrame("Frame", nil, UIParent)
			gpframe:Show()
			PreviewGroups()
		elseif gpframe then
			gpframe:Hide()
			core.UpdateSettings("global")
		end
	end,
	get=function(info)
		return gpframe and gpframe:IsShown()
	end,
}

-- unit button layout preview -----------------------------------------------------------------------------------------
local lelap, scenario = 0, 0
local uf, dummyanchor, showpreview
local function ShowScenario(uf, layout, hpfrac, mpfrac, oor, dead, ghost, aggro, dc, buff, debuff, alert)
	oor = uf.lname ~= "raidroletarget" and oor
	aggro = uf.lname ~= "raidroletarget" and aggro

	local ctime = GetTime()
	local u = "player"
	uf.powertype = UnitPowerType(u)
	uf.uname = UnitName(u)
	uf.class, uf.CLASS = UnitClass(u)
	
	local lname = layout.nametext
	if lname and not lname.hide then
		local chars = lname.chars > 0 and lname.chars or nil
		uf.nametexttext:SetFormattedText("%s%s", lname.showgroup and "3." or "", strsub(uf.uname..uf.uname..uf.uname..uf.uname..uf.uname, 1, chars))
		uf.nametexttext:SetTextColor(cm[lname.colormethod or "class"](uf, lname, "fontcolor"))
	end
	
	local htotal = UnitHealthMax(u)
	local hcurrent = floor(htotal * hpfrac)
	local mtotal = UnitPowerMax(u)
	local mcurrent = floor(mtotal * mpfrac)
	
	if layout.hpbar and not layout.hpbar.hide then
		uf.hpbar.bg:SetVertexColor(cm[layout.hpbar.bgcolormethod or "solid"](uf, layout.hpbar, "bgcolor", "bgalpha"))
		uf.hpbarbar:SetVertexColor(cm[layout.hpbar.barcolormethod or "solid"](uf, layout.hpbar, "barcolor", "baralpha"))
		if dc or ghost or dead then
			uf.hpbarbar:SetValue((layout.hpbar.fulldead and 1) or hpfrac)
			uf.border:SetAlpha(db.deadalpha)
		else
			uf.hpbarbar:SetValue(hpfrac)
			uf.border:SetAlpha(oor and db.ooralpha or 1)
		end
	end
	if layout.hptext and not layout.hptext.hide then
		uf.hptexttext:SetTextColor(cm[layout.hptext.colormethod or "solid"](uf, layout.hptext, "fontcolor"))
		if dc or ghost or dead then
			uf.hptexttext:SetText((dc and core.offlinetext) or (ghost and core.ghosttext) or core.deadtext)
			uf.border:SetAlpha(db.deadalpha)
		else
			uf.hptexttext:SetValue(hcurrent, htotal, hpfrac)
			uf.border:SetAlpha(oor and db.ooralpha or 1)
		end
	end
	if layout.mpbar and not layout.mpbar.hide then
		uf.mpbar.bg:SetVertexColor(cm[layout.mpbar.bgcolormethod or "powerdark"](uf, layout.mpbar, "bgcolor", "bgalpha"))
		uf.mpbarbar:SetVertexColor(cm[layout.mpbar.barcolormethod or "power"](uf, layout.mpbar, "barcolor", "baralpha"))
		if uf.powertype == 0 then
			uf.mpbarbar:SetValue(mpfrac)
		else
			uf.mpbarbar:SetValue(0.00001)
		end
	end
	if layout.mptext and not layout.mptext.hide then
		uf.mptexttext:SetTextColor(cm[layout.mptext.colormethod or "solid"](uf, layout.mptext, "fontcolor"))
		if uf.powertype == 0 then
			uf.mptexttext:SetValue(mcurrent, mtotal, mpfrac)
		else
			uf.mptexttext:SetValue(1, 1, 1)
		end
	end
	
	local c = (aggro and db.aggroc) or (target and db.targetc) or db.bordc
	uf.border:SetBackdropBorderColor(c.r, c.g, c.b, c.a)

	local hasdebuff
	if debuff and layout.debuff and not layout.debuff.hide then
		for i = 1, layout.debuff.rows * layout.debuff.cols, 1 do  -- now show/hide debuff icons
			local randnum = (i % 4) + 1
			local dc = DebuffTypeColor[(randnum == 4 and "Curse") or (randnum == 3 and "Magic") or (randnum == 2 and "Poison") or "none"]
			local d = uf.debuff[i]
			d.texture:SetTexture("Interface\\Icons\\Spell_ChargeNegative")
			d.indicator:SetVertexColor(dc.r, dc.g, dc.b, 1)
			d.count:SetText(i)
			if uf.debuff.showpie then
				d.pie:SetCooldown(ctime, 10)
				d.pie:Show()
			end
			d:Show()
			hasdebuff = true
		end
		uf.debuff:Show()
	elseif uf.debuff then
		uf.debuff:Hide()
	end
	if buff and layout.buff and not layout.buff.hide then
		for i = 1, layout.buff.rows * layout.buff.cols, 1 do
			if hasdebuff and layout.debuff.hidebuff then
				uf.buff[i]:Hide()
			else
				local b = uf.buff[i]
				b.texture:SetTexture("Interface\\Icons\\Spell_ChargePositive")
				b.count:SetText(i)
				if uf.buff.showpie then
					b.pie:SetCooldown(ctime, 10)
					b.pie:Show()
				end
				b:Show()
			end
		end
		uf.buff:Show()
	elseif uf.buff then
		uf.buff:Hide()
	end
	if alert and layout.alert and not layout.alert.hide then
		for i = 1, layout.alert.rows * layout.alert.cols, 1 do  -- now handle the alert icons
			local ai = uf.alert[i]
			if i % 2 == 1 then
				ai.texture:SetTexture("Interface\\Icons\\Spell_ChargePositive")
				ai.indicator:SetAlpha(0)
			else
				ai.texture:SetTexture("Interface\\Icons\\Spell_ChargeNegative")
				local randnum = (i % 4) + 1
				local dc = DebuffTypeColor[(randnum == 4 and "Curse") or (randnum == 3 and "Magic") or (randnum == 2 and "Poison") or "none"]
				ai.indicator:SetVertexColor(dc.r, dc.g, dc.b, 1)
			end
			ai.count:SetText(i)
			if uf.alert.showpie then
				ai.pie:SetCooldown(ctime, 10)
				ai.pie:Show()
			end
			ai:Show()
		end
		uf.alert:Show()
	elseif uf.alert then
		uf.alert:Hide()
	end
	if not layout.raidicon.hide then
		SetRaidTargetIconTexture(uf.raidicon.icon, math.random(1,8))
		uf.raidicon:Show()
	elseif uf.raidicon then
		uf.raidicon:Hide()
	end
	if not strfind(showpreview or "blah", "action") then
		if layout.looticon and not layout.looticon.hide then
			uf.looticon:Show()
		elseif uf.looticon then
			uf.looticon:Hide()
		end
		if layout.leadericon and not layout.leadericon.hide then
			uf.leadericon:Show()
		elseif uf.leadericon then
			uf.leadericon:Hide()
		end
		if layout.voiceicon and not layout.voiceicon.hide then
			uf.voiceicon:Show()
		elseif uf.voiceicon then
			uf.voiceicon:Hide()
		end
		if layout.combaticon and not layout.combaticon.hide then
			uf.combaticon:Show()
		elseif uf.combaticon then
			uf.combaticon:Hide()
		end
	else
		if uf.looticon then uf.looticon:Hide() end
		if uf.leadericon then uf.leadericon:Hide() end
		if uf.voiceicon then uf.voiceicon:Hide() end
	end
end
local function PreviewOnUpdate(this, a1)
	lelap = lelap + a1
	if lelap < 2 then return end
	lelap = 0
	
	scenario = scenario + 1
	if scenario == 1 then
		ShowScenario(this, this.layout, 1, 1, nil, nil, nil, nil, nil, nil, nil, nil)
	elseif scenario == 2 then
		ShowScenario(this, this.layout, 1, 1, nil, nil, nil, nil, nil, true, nil, nil)
	elseif scenario == 3 then
		ShowScenario(this, this.layout, 0.6, 0.6, nil, nil, nil, nil, nil, nil, nil, nil)
	elseif scenario == 4 then
		ShowScenario(this, this.layout, 0.3, 0.3, nil, nil, nil, nil, nil, true, nil, true)
	elseif scenario == 5 then
		ShowScenario(this, this.layout, 0.1, 0.1, true, nil, nil, nil, nil, nil, true, true)
	elseif scenario == 6 then
		ShowScenario(this, this.layout, 0.00001, 0.00001, nil, true, nil, nil, nil, nil, nil, nil)
	elseif scenario == 7 then
		ShowScenario(this, this.layout, 1, 1, true, nil, nil, nil, nil, nil, nil, nil)
	elseif scenario == 8 then
		ShowScenario(this, this.layout, 0.6, 0.6, nil, nil, nil, true, nil, nil, nil, true)
	elseif scenario == 9 then
		ShowScenario(this, this.layout, 0.3, 0.3, true, nil, nil, true, nil, true, true, nil)
	elseif scenario == 10 then
		ShowScenario(this, this.layout, 0.6, 0.6, nil, nil, nil, nil, nil, true, true, true)
	elseif scenario > 10 then
		ShowScenario(this, this.layout, 0.00001, 0.00001, nil, true, nil, nil, nil, nil, nil, nil)
		scenario = 0
	end
end

local function UpdateLayoutFrame(layout)
	if not showpreview or not layout then return end
	if not uf then
		uf = CreateFrame("Button", nil, UIParent)
		dummyanchor = CreateFrame("Frame", nil, core)
		uf:SetMovable(true)
		uf:RegisterForDrag("LeftButton")
		uf:SetScript("OnDragStart", uf.StartMoving)
		uf:SetScript("OnDragStop", uf.StopMovingOrSizing)
	end
	uf.lname = layout
	layout = db[layout]
	uf.layout = layout
	uf:SetWidth(layout.w)
	uf:SetHeight(layout.h)
	core.CreateUnitBase(uf, layout, dummyanchor)

	if layout.mpbar then
		core.CreateBar(uf, layout, "mpbar")
	elseif uf.mpbar then
		uf.mpbar:Hide()
	end
	if layout.mptext then
		core.CreateText(uf, layout, "mptext")
	elseif uf.mptext then
		uf.mptext:Hide()
	end
	if layout.buff then
		core.CreateAura(uf, layout, "buff")
	elseif uf.buff then
		uf.buff:Hide()
	end
	if layout.debuff then
		core.CreateAura(uf, layout, "debuff")
	end
	if layout.alert then
		core.CreateAura(uf, layout, "alert")
	end
	if layout.looticon then
		core.CreateIcon(uf, layout, "looticon", "Interface\\GroupFrame\\UI-Group-MasterLooter")
	end
	if layout.leadericon then
		core.CreateIcon(uf, layout, "leadericon", "Interface\\GroupFrame\\UI-Group-LeaderIcon")
	end
	if layout.voiceicon then
		core.CreateIcon(uf, layout, "voiceicon", "Interface\\Common\\VoiceChat-Speaker")
	end
	if layout.combaticon then
		core.CreateIcon(uf, layout, "combaticon", "Interface\\CharacterFrame\\UI-StateIcon")
	end
	if strfind(showpreview or "blah", "zoom") then
		uf:SetScale(2.5)
	else
		uf:SetScale(1)
	end
	if strfind(showpreview or "blah", "action") then
		uf:SetScript("OnUpdate", PreviewOnUpdate)
		PreviewOnUpdate(uf, 10)
	else
		uf:SetScript("OnUpdate", nil)
		scenario = 0
		ShowScenario(uf, layout, 0.8, 0.8, nil, nil, nil, nil, nil, true, true, true)
	end
	uf:Show()
end
local preview = {
	name=L["Preview Unit Layout"], type="select", order=2,
	values={ none=L["None"], normal=L["Normal"], zoom2=L["Zoom"], normalaction=L["Normal with Events"], zoom2action=L["Zoom with Events"], },
	set=function(_, v)
		showpreview = v ~= "none" and v
		if showpreview then
			UpdateLayoutFrame(currentlayout)
			if uf then uf:SetPoint("CENTER") end
		elseif uf then
			uf:Hide()
		end
	end,
	get=function() return showpreview end,
}


local floor = floor
local type = type
local function shorten(num)
	if type(num) == "number" then
		return floor(num * 1000 + 0.5) / 1000
	end
	if num == false then
		return nil
	end
	return num
end


-- selection tables
local numformats = {
	deficit = L["Loss Value"], deficitnok = L["Loss Value with no 'K'"],
	perc = L["Percentage"], percnosign = L["Percentage w/o Sign"],
	remain = L["Remaining"],
	full = L["Current/Maximum"],
	juststatus = L["Only Inactive Status"],
}
local colormethods = {
	power=L["Power Type"], powerdark=L["Dark Power Type"],
	class=L["Class"], classdark=L["Dark Class"], 
	reaction=L["Reaction"], reactiondark=L["Dark Reaction"], 
	reactionnpc=L["Reaction NPC, Class PC"], reactionnpcdark=L["Dark Reaction NPC, Class PC"],
	solid=L["Custom"],
}
local strata = { L["BACKGROUND"], L["LOW"], L["MEDIUM"], L["HIGH"], L["DIALOG"], }
local stratakey = { "BACKGROUND", "LOW", "MEDIUM", "HIGH", "DIALOG", }

-- get/set functions
local function infobreakdown(info)
	db = db or (StufRaidDB ~= "perchar" and StufRaidDB) or StufRaidCharLayoutDB
	local num = #info
	local group, object, setting = info[num-2], info[num-1], info[num]
	return group, object, setting
end
local function getget(info)
	local group, object, setting = infobreakdown(info)
	if object == "global" then
		UpdateLayoutFrame(currentlayout)
		return db[setting]
	elseif group == "global" then
		UpdateLayoutFrame(currentlayout)
		return db[object][setting]
	elseif group == "StufRaid" then
		currentlayout = object
		UpdateLayoutFrame(currentlayout)
		return db[object][setting]
	else
		currentlayout = group
		UpdateLayoutFrame(currentlayout)
		return db[group][object][setting]
	end
end
local function get(info)
	local dbk = getget(info)
	if type(dbk) == "table" then
		return dbk.r, dbk.g, dbk.b, dbk.a
	else
		return dbk
	end
end
local function getornone(info)
	local dbk = getget(info)
	return not dbk and "None" or dbk
end
local function getorzero(info)
	local dbk = getget(info)
	return not dbk and 0 or dbk
end
local function getorone(info)
	local dbk = getget(info)
	return not dbk and 1 or dbk
end
local function getorten(info)
	local dbk = getget(info)
	return not dbk and 10 or dbk
end
local function getcolororblank(info)  -- get color or default blank
	local dbk = getget(info)
	if not dbk then
		return 0, 0, 0, 0
	else
		return dbk.r, dbk.g, dbk.b, dbk.a
	end
end
local function getcolororwhite(info)  -- get color or default white
	local dbk = getget(info)
	if not dbk then
		return 1, 1, 1, 1
	else
		return dbk.r, dbk.g, dbk.b, dbk.a
	end
end
local function getstrata(info)
	local dbk = getget(info)
	for i, k in ipairs(stratakey) do
		if k == dbk then return i end
	end
end
local function set(info, r, g, b, a)
	local group, object, setting = infobreakdown(info)
	if b then
		r, g, b, a = shorten(r), shorten(g), shorten(b), shorten(a)
	else
		r = shorten(r)
	end
	if object == "global" then
		if b then
			local dbk = db[setting]
			if dbk then
				dbk.r, dbk.g, dbk.b, dbk.a = r, g, b, a
			else
				db[setting] = { r=r, g=g, b=b, a=a, }
			end
		elseif setting == "strata" then
			db[setting] = stratakey[r] or nil
		else
			db[setting] = r
		end
		core.UpdateSettings("global")
	elseif group == "global" then
		if b then
			local dbk = db[object][setting]
			if dbk then
				dbk.r, dbk.g, dbk.b, dbk.a = r, g, b, a
			else
				db[object][setting] = { r=r, g=g, b=b, a=a, }
			end
		else
			db[object][setting] = r
		end
		core.UpdateSettings("global")
	elseif not group or group == "StufRaid" then
		if b then
			local dbk = db[object][setting]
			if dbk then
				dbk.r, dbk.g, dbk.b, dbk.a = r, g, b, a
			else
				db[object][setting] = { r=r, g=g, b=b, a=a, }
			end
		else
			db[object][setting] = r
		end
		core.UpdateSettings(object)
	else
		if b then
			local dbk = db[group][object][setting]
			if dbk then
				dbk.r, dbk.g, dbk.b, dbk.a = r, g, b, a
			else
				db[group][object][setting] = { r=r, g=g, b=b, a=a, }
			end
		else
			db[group][object][setting] = r
		end
		core.UpdateSettings(group)
	end
	UpdateLayoutFrame(currentlayout)
	PreviewGroups()
end


local hide = { name=_G.DISABLE or "Disable", type="toggle", set=set, get=get, order=1, }
local blank = { name=" ", type="header", order=3, }
local x = { name=L["X Position"], type="range", min=0, max=floor(GetScreenWidth()), step=1, set=set, get=getorzero, order=4, }
local y = { name=L["Y Position"], type="range", min=-floor(GetScreenHeight()), max=0, step=1, set=set, get=getorzero, order=5, }
local x2 = { name=L["X Position"], type="range", min=-1, max=1, step=1, set=set, get=getorzero, order=4, }
local y2 = { name=L["Y Position"], type="range", min=-1, max=1, step=1, set=set, get=getorzero, order=5, }
local w = { name=L["Width"], type="range", min=0, max=1, step=1, set=set, get=getorzero, order=6, }
local h = { name=L["Height"], type="range", min=0, max=1, step=1, set=set, get=getorzero, order=7, }

updateminmax = function()
	local sw, sh = floor(GetScreenWidth()), floor(GetScreenHeight())
	x2.min, x2.max = -sw, sw
	y2.min, y2.max = -sh, sh
	w.max, h.max = sw, sh
end

local alpha = { name=L["Alpha"], type="range", min=0, max=1, step=0.02, set=set, get=getorone, order=9, }
local framelevel = { name=L["Frame Level"], type="range", min=0, max=30, step=1, set=set, get=getorten, order=9, }
local blank2 = { name=" ", type="header", order=10.9, }
local blank3 = { name=" ", type="header", order=19.9, }
local blank4 = { name=" ", type="header", order=29.9, }

local font = { name=L["Font"], type="select", dialogControl="LSM30_Font", values=AceGUIWidgetLSMlists.font, set=set, get=get, order=40, }
local fontsize = { name=L["Font Size"], type="range", min=1, max=100, step=1, set=set, get=getorone, order=41, }
local fontflags = { 
	name=L["Font Extras"], type="select", values=fontflags, set=set, get=getornone, order=42, 
	values = { 
		None=L["None"], OUTLINE=L["OUTLINE"], THICKOUTLINE=L["THICKOUTLINE"], 
		MONOCHROME=L["MONOCHROME"], ["OUTLINE|MONOCHROME"]=L["OUTLINE|MONOCHROME"], 
		["THICKOUTLINE|MONOCHROME"]=L["THICKOUTLINE|MONOCHROME"], 
	},
}
local fontcolor = { name=L["Font Color"], type="color", hasAlpha=true, set=set, get=getcolororwhite, order=43, }

-- Elements
local baropts = { 
	hide=hide, blank=blank, 
	x=x2, y=y2, w=w, h=h, framelevel=framelevel, blank2=blank2,
	powernote = {
		name=L["Note that StufRaid's Power Bar is only enabled if the power type is mana."], type="description", width="full", order = 15.9,
		hidden=function(info)
			return info[#info-1] ~= "mpbar"
		end,
	},
	fasthp = {
		name=L["Fast Health Updates"], desc=L["Maybe updates health info faster but guarantees increased CPU usage."], type="toggle", width="double", order=15.9,
		set=set, get=get,
		hidden=function(info)
			return info[#info-1] ~= "hpbar"
		end,
	},
	texture = {
		name=L["Statusbar Texture"], type="select", width="double", order=16,
		dialogControl="LSM30_Statusbar", values=AceGUIWidgetLSMlists.statusbar, set=set,
		get=function(info)
			local dbk = getget(info)
			return not dbk and db and db.texture or dbk
		end,
	},
	bgcolormethod = { name=L["Backdrop Color Method"], width="double", type="select", values=colormethods, set=set, get=get, order=16.1, },
	bgcolor = { name=L["Backdrop Custom Color"], type="color", set=set, get=getcolororblank, order=17, },
	bgalpha = { name=L["Backdrop Alpha"], type="range", isPercent=true, min=0, max=1, step=0.02, set=set, get=getorone, order=18, },
	barcolormethod = { name=L["Bar Color Method"], width="double", type="select", values=colormethods, set=set, get=get, order=20, },
	barcolor = { name=L["Bar Custom Color"], type="color", set=set, get=getcolororblank, order=21, },
	baralpha = { name=L["Bar Alpha"], isPercent=true, type="range", min=0, max=1, step=0.02, set=set, get=getorone, order=22, },
	vertical = { name=L["Vertical Orientation"], type="toggle", set=set, get=get, order=25, },
	reverse = { name=L["Reverse Direction"], type="toggle", set=set, get=get, order=26, },
	fill = { name=L["Fill on Loss"], type="toggle", set=set, get=get, order=27, },
	fulldead = {
		name=L["Full Value If Inactive"], type="toggle", set=set, get=get, order=28,
		hidden=function(info)
			return info[#info-1] ~= "hpbar"
		end,
	},
	incheal = {
		name=L["Show Incoming Heals"], type="toggle", set=set, get=get, order=28.1,
		hidden=function(info)
			return info[#info-1] ~= "hpbar"
		end,
	},
	blank4=blank4,
	barinsetleft = { name=L["Bar Left Offset"], type="range", min=-20, max=20, step=1, set=set, get=get, order=30, },
	barinsetright = { name=L["Bar Right Offset"], type="range", min=-20, max=20, step=1, set=set, get=get, order=31, },
	barinsettop = { name=L["Bar Top Offset"], type="range", min=-20, max=20, step=1, set=set, get=get, order=32, },
	barinsetbottom = { name=L["Bar Bottom Offset"], type="range", min=-20, max=20, step=1, set=set, get=get, order=33, },
}
local hpbar = { name=L["Health Bar"], type="group", order=3, args=baropts, }
local mpbar = { name=L["Power Bar"], type="group", order=4, args=baropts, }

local textopts = {
	hide=hide, blank=blank,
	x=x2, y=y2, w=w, h=h, framelevel=framelevel, alpha=alpha, blank2=blank2,
	fontsize=fontsize, fontflags=fontflags, fontcolor=fontcolor,
	colormethod = { name=L["Color By"], type="select", values=colormethods, set=set, get=get, order=43.1, },
	justifyH = { name=L["H Justify"], type="select", values = { LEFT=L["Left"], CENTER=L["Center"], RIGHT=L["Right"], }, set=set, get=get, order=44, },
	justifyV = { name=L["V Justify"], type="select", values = { TOP=L["Top"], CENTER=L["Center"], BOTTOM=L["Bottom"], }, set=set, get=get, order=45, },
	shadowx = { name=L["Shadow Offset X"], type="range", min=-20, max=20, step=1, set=set, get=getorzero, order=46, },
	shadowy = { name=L["Shadow Offset Y"], type="range", min=-20, max=20, step=1, set=set, get=getorzero, order=47, },
	textformat = {
		name=L["Number Format"], type="select", values=numformats, set=set, get=get, order=48, 
		hidden=function(info)
			return info[#info-1] ~= "hptext" and info[#info-1] ~= "mptext"
		end,
	},
	showgroup = {
		name=L["Show Group Number"], type="toggle", set=set, get=get, order=48,
		hidden=function(info)
			return info[#info-1] ~= "nametext" or info[#info-2] == "raidroletarget" or info[#info-2] == "raidpet"
		end,
	},
	chars = {
		name=L["Characters Limit"], desc=L["Set to 0 to disable"], type="range", min=0, max=20, step=1, set=set, get=get, order=48,
		hidden=function(info)
			return info[#info-1] ~= "nametext"
		end,
	},
}
local nametext = { name=L["Name Text"], type="group", order=5, args=textopts, }
local hptext = { name=L["Health Text"], type="group", order=6, args=textopts, }
local mptext = { name=L["Power Text"], type="group", order=7, args=textopts, }

local cols = { name=L["Columns"], type="range", min=1, max=40, step=1, set=set, get=get, order=14.1, }
local rows = { name=L["Rows"], type="range", min=1, max=40, step=1, set=set, get=get, order=14.2, }
local acols = { name=L["Columns"], type="range", min=1, max=16, step=1, set=set, get=get, order=14.1, }
local arows = { name=L["Rows"], type="range", min=1, max=16, step=1, set=set, get=get, order=14.2, }
local hspacing = { name=L["Column Spacing"], type="range", min=-5, max=40, step=1, set=set, get=getorzero, order=15.1, }
local vspacing = { name=L["Row Spacing"], type="range", min=-5, max=40, step=1, set=set, get=getorzero, order=15.2, }
local growth = { 
	name=L["Growth"], type="select", set=set, get=get, order=16, 
	values = { 
		LRTB=L["Left"].." "..L["Right"]..", "..L["Top"].." "..L["Bottom"], LRBT=L["Left"].." "..L["Right"]..", "..L["Bottom"].." "..L["Top"], 
		RLTB=L["Right"].." "..L["Left"]..", "..L["Top"].." "..L["Bottom"], RLBT=L["Right"].." "..L["Left"]..", "..L["Bottom"].." "..L["Top"], 
		TBLR=L["Top"].." "..L["Bottom"]..", "..L["Left"].." "..L["Right"], TBRL=L["Top"].." "..L["Bottom"]..", "..L["Right"].." "..L["Left"], 
		BTLR=L["Bottom"].." "..L["Top"]..", "..L["Left"].." "..L["Right"], BTRL=L["Bottom"].." "..L["Top"]..", "..L["Right"].." "..L["Left"], 
	},
}
local baseaura = {
	hide=hide, blank=blank, 
	x=x2, y=y2, w=w, h=h, alpha=alpha, framelevel=framelevel, blank2=blank2,
	cols=acols, rows=arows, hspacing=hspacing, vspacing=vspacing,
	growth=growth,
	hidebuff = {
		name=L["Hide Buffs If Debuffed"], type="toggle", set=set, get=get, order=16,
		hidden=function(info)
			return info[#info-1] ~= "debuff"
		end,
	},
	mouseable = { name=L["Show Tooltips"], type="toggle", set=set, get=get, order=16.19, },
	showpie = { name=L["Show Cooldown Pie"], desc=L["Enabling may decrease performance."], type="toggle", set=set, get=get, order=16.2, },
	hidecc = { name=L["Hide OmniCC"], type="toggle", set=set, get=get, order=16.3, },
}
local buff = { name=L["Buff Icons"], type="group", order=8, args=baseaura, }
local debuff = { name=L["Debuff Icons"], type="group", order=9, args=baseaura, }
local alert = { name=L["Alert Icons"], type="group", order=10, args=baseaura, }

local basicicon = {
	hide=hide, blank=blank,
	x=x2, y=y2, w=w, h=h, framelevel=framelevel, alpha=alpha,
}
local raidicon = { name=L["Raid Target Icon"], type="group", order=11, args=basicicon, }
local combaticon = { name=L["Combat Icon"], type="group", order=12, args=basicicon, }
local voiceicon = { name=L["Voice Icon"], type="group", order=13, args=basicicon, }
local leadericon = { name=L["Leader Icon"], type="group", order=14, args=basicicon, }
local looticon = { name=L["Loot Icon"], type="group", order=15, args=basicicon, }



local unitw = { name=L["Unit Width"], type="range", min=10, max=400, step=1, set=set, get=get, order=3.1, }
local unith = { name=L["Unit Height"], type="range", min=10, max=400, step=1, set=set, get=get, order=3.2, }
local byclass = {
	name=L["Group by Class"], type="toggle", width="double", get=get, order=3.3,
	set=function(info, v)
		set(info, v)
	end,
}
local anchorblank = { name=" ", type="header", order=3.5, }
local showanchor = { name=L["Show Anchor"], type="toggle", set=set, get=get, order=3.6, }
local lockanchor = { name=L["Lock Anchor"], type="toggle", set=set, get=get, order=3.7, }
local ttcustom = { name=L["Custom Tooltip Position"], type="toggle", set=set, get=get, order=12, }
local ttanchor = { name=L["Tooltip Anchor"], type="select", order=13, set=set, get=get,
	values={
		TOP=L["TOP"], BOTTOM=L["BOTTOM"], LEFT=L["LEFT"], RIGHT=L["RIGHT"], CENTER="CENTER",
		TOPLEFT=L["TOP"]..L["LEFT"], TOPRIGHT=L["TOP"]..L["RIGHT"],
		BOTTOMLEFT=L["BOTTOM"]..L["LEFT"], BOTTOMRIGHT=L["BOTTOM"]..L["RIGHT"],
	},
}
local ttx = { name=L["Tooltip X"], type="range", min=-400, max=400, step=1, set=set, get=getorzero, order=14, }
local tty = { name=L["Tooltip Y"], type="range", min=-400, max=400, step=1, set=set, get=getorzero, order=15, }
local ttcombathide = { name=L["Hide Tooltip in Combat"], type="toggle", set=set, get=get, order=16, }


local classes = {  }
for class, _ in pairs(RAID_CLASS_COLORS) do
	classes[class] = L[class]
end
local groups = { }
for i = 1, 8, 1 do
	groups[i] = L["Group"].." "..i
end

local label = { name=L["Label Text"], type="input", set=set, get=get, order=8.3, }
local sortdir = { name=L["Sort Direction"], type="select", values={ ASC=L["Ascending"], DESC=L["Descending"], }, set=set, get=get, order=16.2, }
local sortbyname = { name=L["Sort by Name"], type="toggle", set=set, get=get, order=16.3, }

local groupopts = {
	hide=hide, blank=blank,
	x=x2, y=y2,
	groupblank = { name=" ", type="header", order=8, },
	groupnote = {
		name=L["Will not function properly if a group appears more than once under the 'Raid' supergroup."],
		type="description", width="double", order=8.1, },
	appfilter = {
		name=L["Add/Remove"], type="select", order=8.2,
		values=function(info)
			local layout, group, setting = infobreakdown(info)
			return db[layout].byclass and classes or groups
		end,
		set=function(info, v)
			local layout, group, setting = infobreakdown(info)
			local dg = db[layout][group]
			local order = db[layout].byclass and "classorder" or "order"
			v = tostring(v)
			if strfind(dg[order], v) then
				dg[order] = gsub(dg[order], ","..v, "")
				dg[order] = gsub(dg[order], v..",", "")
				dg[order] = gsub(dg[order], v, "")
			else
				dg[order] = (dg[order] == "" and v) or dg[order]..","..v
			end
			core.UpdateSettings(layout)
		end,
	},
	showorder = { 
		type="description", order=8.4,
		name=function(info)
			local layout, group, setting = infobreakdown(info)
			if db[layout].byclass then
				return L["Class Order: "]..(db[layout][group].classorder or "none")
			else
				return L["Group Order: "]..(db[layout][group].order or "none")
			end
		end,
	},
	label=label, blank2=blank2,
	cols=cols, rows=rows, hspacing=hspacing, vspacing=vspacing,
	growth=growth, sortdir=sortdir, sortbyname=sortbyname,
}
local simplegroup = {
	name=L["Header"], type="group", order=2,
	args = {
		hide=hide, blank=blank,
		x=x2, y=y2, label=label, 
		blank2=blank2,
		cols=cols, rows=rows, hspacing=hspacing, vspacing=vspacing,
		growth=growth, sortdir=sortdir, sortbyname=sortbyname,
	},
}

-- aura filter handlers
local temp = { }
local function getfiltervalues(info)
	local filter = gsub(info[#info], "remove", "")
	wipe(temp)
	if StufRaidCharDB[filter] then
		for entry, _ in pairs(StufRaidCharDB[filter]) do
			temp[entry] = entry
		end
		return temp
	end
end
local function addfilter(info, v)
	local filter = gsub(info[#info], "add", "")
	if tonumber(v) then
		v = GetSpellInfo(tonumber(v))
		if not v then
			return print("|cff00ff00StufRaid|r: "..L["Invalid spell ID."])
		end
	end
	StufRaidCharDB[filter][v] = true
	core.UpdateSettings("global")
end
local function removefilter(info, v)
	local filter = gsub(info[#info], "remove", "")
	StufRaidCharDB[filter][v] = nil
	core.UpdateSettings("global")
end


local options
options = {
	type="group",
	args = {
		global = {
			name=L["Global"], type="group", order=1,
			args = {
				desc = {
					name=L["Only configure while out of combat. For more info or to report bugs, go here:"],
					type="input", width="full", order=0.1, get=function() return "http://www.wowinterface.com/downloads/info11182.html" end, },
				texture = {
					name=L["Statusbar Texture"], desc=L["Changing this will override all current bar settings"], type="select", order=1.1,
					dialogControl="LSM30_Statusbar", values=AceGUIWidgetLSMlists.statusbar, confirm=true, get=get,
					set=function(...)
						for k, v in pairs(db) do
							if type(v) == "table" then
								if v.hpbar then v.hpbar.texture = nil end
								if v.mpbar then v.mpbar.texture = nil end
							end
						end
						set(...)
					end,
				},
				border = {
					name=L["Border Texture"], type="select", order=1.2, 
					dialogControl="LSM30_Border", values=AceGUIWidgetLSMlists.border, set=set, get=get, },
				namefont = { 
					name=L["Name Font"], type="select", order=1.3,
					dialogControl="LSM30_Font", values=AceGUIWidgetLSMlists.font, set=set, get=get, },
				numfont = { 
					name=L["Number Font"], type="select", order=1.4,
					dialogControl="LSM30_Font", values=AceGUIWidgetLSMlists.font, set=set, get=get, },
				strata = { name=L["Frame Strata"], type="select", values=strata, set=set, get=getstrata, order = 1.5, },
				shortstart = { 
					name=L["Number Shorten Start"], type="input", order=1.6,
					set=function(info, v)
						v = tonumber(v)
						db.shortstart = v or 0
						if not v then
							print("|cff00ff00StufRaid|r: "..L["Value must be a number."])
						end
						core.UpdateSettings("global")
					end,
					get=function() return tostring(db.shortstart) end
				},
				ooralpha = { name=L["Out-of-Range Fade Alpha"], type="range", min=0, max=1, step=0.05, set=set, get=getorone, order=1.7, },
				deadalpha = { name=L["Inactive Fade Alpha"], type="range", min=0, max=1, step=0.05, set=set, get=getorone, order=1.8, },
				fontsize = { name=L["Titles' Font Size"], type="range", min=2, max=30, step=1, set=set, get=get, order=1.9, },
				fontcolor = { name=L["Titles' Font Color"], type="color", hasAlpha=true, set=set, get=get, order=1.91, },
				hidearena = { name=L["Hide in Arena"], type="toggle", set=set, get=get, order=1.92, },
				blank=blank,
				deadtext = { name=L["Dead Text"], type="input", set=set, get=get, order=5, },
				ghosttext = { name=L["Ghost Text"], type="input", set=set, get=get, order=6, },
				offlinetext = { name=L["Offline Text"], type="input", set=set, get=get, order=7, },
				nK = { name=L["Thousand Short"], type="input", order=7.1, set=set, get=get, },
				nM = { name=L["Million Short"], type="input", order=7.2, set=set, get=get, },
				blank2=blank2,
				basec = {
					name=L["Base Color"], desc=L["Color that begins to appear as the frame fades"], type="color",
					hasAlpha=true, set=set, get=get, order=11.1, },
				backc = { name=L["Background Color"], type="color", hasAlpha=true, set=set, get=get, order=11.2, },
				bordc = { name=L["Border Color"], type="color", hasAlpha=true, set=set, get=get, order=11.3, },
				targetc = { name=L["Target Border Color"], type="color", hasAlpha=true, set=set, get=get, order=11.4, },
				aggroc = { name=L["Aggro Border Color"], type="color", hasAlpha=true, set=set, get=get, order=11.5, },
				mousec = { name=L["Mouseover Border Color"], type="color", hasAlpha=true, set=set, get=get, order=11.6, },
				tshadowc = { name=L["Text Shadow Color"], type="color", hasAlpha=true, set=set, get=get, order=11.7, },
				inactivec = { name=L["Inactive Text Color"], type="color", hasAlpha=true, set=set, get=getcolororblank, order=11.8, },
				classcolor = { name=L["Class Colors"], dialogInline=true, type="group", order=21, args = { }, },
				reactioncolor = { name=L["Reaction Colors"], dialogInline=true, type="group", order=22, args = { }, },
				powercolor = { name=L["Power Type Colors"], dialogInline=true, type="group", order=23, args = { }, },
				defaults = { 
					name=L["Restore Defaults"], desc=L["Automatically reloads UI"], type="execute", order=34,
					confirm=true, func=function()
						if StufRaidDB == "perchar" then
							core.LoadDefaults(StufRaidCharLayoutDB, nil, true, true)
						else
							core.LoadDefaults(StufRaidDB, nil, true)
						end
					end,
				},
				perchar = {
					name=L["Save Per Character"], desc=L["Automatically reloads UI and may reset settings for other characters."], type="toggle", confirm=true, order=35,
					set=function(info, v)
						if v then
							StufRaidCharLayoutDB = StufRaidDB
							StufRaidDB = "perchar"
							ReloadUI()
						else
							StufRaidDB = StufRaidCharLayoutDB
							StufRaidCharLayoutDB = nil
							ReloadUI()
						end
					end,
					get=function() return StufRaidDB == "perchar" or (type(StufRaidDB) == "table" and StufRaidDB.temp) end,
				},
				copyvars = {
					name=L["Copy to Next Char"], desc=L["Current settings will be copied to next character login."], type="execute", confirm=true, order=36,
					func=function() StufRaidDB = { temp = db, } end,
					hidden=function() return StufRaidDB ~= "perchar" end,
				},
				version = { name="v"..(GetAddOnMetadata("StufRaid", "Version") or "?.?.???"), type="description", width="full", order=40, },
			},
		},
		raid = {
			name=_G.RAID, type="group", order=2,
			args = {
				previewgroup=previewgroup, preview=preview, blank=blank,
				w=unitw, h=unith, byclass=byclass, anchorblank=anchorblank,
				showanchor=showanchor, lockanchor=lockanchor, anchorx=x, anchory=y, 
				posdesc = {
					name=L["Individual group headers each have their own position settings relative to this anchor.  Look under HeaderN to adjust them."],
					type="description", width="full", order=10.8, },
				blank2=blank2,
				ttcustom=ttcustom, ttanchor=ttanchor, ttx=ttx, tty=tty, ttcombathide=ttcombathide,
				hpbar=hpbar,
				mpbar=mpbar,
				nametext=nametext,
				hptext=hptext,
				mptext=mptext,
				buff=buff,
				debuff=debuff,
				alert=alert,
				combaticon=combaticon,
				raidicon=raidicon,
				voiceicon=voiceicon,
				leadericon=leadericon,
				looticon=looticon,
				incheal=incheal,
				group1 = { name=L["Header"]..1, type="group", order=60, args=groupopts, },
				group2 = { name=L["Header"]..2, type="group", order=61, args=groupopts, },
				group3 = { name=L["Header"]..3, type="group", order=62, args=groupopts, },
				group4 = { name=L["Header"]..4, type="group", order=63, args=groupopts, },
				group5 = { name=L["Header"]..5, type="group", order=64, args=groupopts, },
				group6 = { name=L["Header"]..6, type="group", order=65, args=groupopts, },
				group7 = { name=L["Header"]..7, type="group", order=66, args=groupopts, },
				group8 = { name=L["Header"]..8, type="group", order=67, args=groupopts, },
				group9 = { name=L["Header"]..9, type="group", order=68, args=groupopts, },
				group10 = { name=L["Header"]..10, type="group", order=69, args=groupopts, },
			},
		},
		raidpet = {
			name=_G.RAID.." ".._G.PETS, type="group", order=3,
			args = {
				previewgroup=previewgroup, preview=preview, blank=blank,
				w=unitw, h=unith, anchorblank=anchorblank,
				showanchor=showanchor, lockanchor=lockanchor, anchorx=x, anchory=y, blank2=blank2,
				ttcustom=ttcustom, ttanchor=ttanchor, ttx=ttx, tty=tty, ttcombathide=ttcombathide,
				hpbar=hpbar,
				nametext=nametext,
				hptext=hptext,
				raidicon=raidicon,
				group=simplegroup,
			},
		},
		raidrole = {
			name=_G.RAID.." "..(_G.ROLES or _G.ROLE), type="group", order=4,
			args = {
				previewgroup=previewgroup, preview=preview, blank=blank,
				w=unitw, h=unith, anchorblank=anchorblank,
				showanchor=showanchor, lockanchor=lockanchor, anchorx=x, anchory=y, blank2=blank2,
				ttcustom=ttcustom, ttanchor=ttanchor, ttx=ttx, tty=tty, ttcombathide=ttcombathide,
				hpbar=hpbar,
				mpbar=mpbar,
				nametext=nametext,
				hptext=hptext,
				mptext=mptext,
				buff=buff,
				debuff=debuff,
				alert=alert,
				combaticon=combaticon,
				raidicon=raidicon,
				incheal=incheal,
				group=simplegroup,
			},
		},
		raidroletarget = {
			name=_G.RAID.." "..(_G.ROLES or _G.ROLE).." ".._G.TARGET, type="group", order=5,
			args = {
				previewgroup=previewgroup, preview=preview, blank=blank,
				w=unitw, h=unith,
				showt = { name=_G.ENABLE.." ".._G.TARGET, type="toggle", width="double", set=set, get=get, order=10, },
				tx = { name=_G.TARGET.." "..L["X Position"], type="range", min=-300, max=300, step=1, set=set, get=get, order=11, },
				ty = { name=_G.TARGET.." "..L["Y Position"], type="range", min=-300, max=300, step=1, set=set, get=get, order=12, },
				showtt = { name=_G.ENABLE.." ".._G.TARGET.." ".._G.TARGET, type="toggle", width="double", set=set, get=get, order=13, },
				ttx = { name=_G.TARGET.." ".._G.TARGET.." "..L["X Position"], type="range", min=-300, max=300, step=1, set=set, get=get, order=14, },
				tty = { name=_G.TARGET.." ".._G.TARGET.." "..L["Y Position"], type="range", min=-300, max=300, step=1, set=set, get=get, order=15, },
				hpbar=hpbar,
				nametext=nametext,
				hptext=hptext,
				raidicon=raidicon,
			},
		},
		filter = {
			name=L["Aura Filters"], type="group", order=6,
			args = {
				filterhelp = {
					name=L["Filter inputs accept either spell name or spell ID. These settings are saved per character."],
					type="description", width="double", order=0.1, },
				bshow = {
					name=L["Buffs Filter"], type="select", width="double", order=1,
					values={
						raid=L["Castable, Plus Include and Minus Exclude"],
						all=L["All, Except Exclude"],
						mine=L["Any of Mine Except Exclude Filter"],
						mineinclude=L["Only Mine in Include Filter"],
						justinclude=L["Any in Include Filter"],
						hide=L["Disabled"],
					},
					set=function(info, v)
						StufRaidCharDB.bshow = v
						core.UpdateSettings("global")
					end,
					get=function(info) return StufRaidCharDB.bshow end,
				},
				bincludeadd = { name=L["Include Filter Add"], type="input", set=addfilter, order=1.2, },
				bincluderemove = { name=L["Include Filter Remove"], type="select", values=getfiltervalues, set=removefilter, order=1.3, },
				bexcludeadd = { name=L["Exclude Filter Add"], type="input", set=addfilter, order=1.4, },
				bexcluderemove = { name=L["Exclude Filter Remove"], type="select", values=getfiltervalues, set=removefilter, order=1.5, },
				blank=blank,
				dshow = {
					name=L["Debuffs Filter"], type="select", width="double", order=7,
					values={
						raid=L["Curable, Plus Include and Minus Exclude"],
						all=L["All, Except Exclude"],
						justinclude=L["Any in Include Filter"],
						hide=L["Disabled"],
					},
					set=function(info, v)
						StufRaidCharDB.dshow = v
						core.UpdateSettings("global")
					end,
					get=function(info) return StufRaidCharDB.dshow end,
				},
				dincludeadd = { name=L["Include Filter Add"], type="input", set=addfilter, order=7.2, },
				dincluderemove = { name=L["Include Filter Remove"], type="select", values=getfiltervalues, set=removefilter, order=7.3, },
				dexcludeadd = { name=L["Exclude Filter Add"], type="input", set=addfilter, order=7.4, },
				dexcluderemove = { name=L["Exclude Filter Remove"], type="select", values=getfiltervalues, set=removefilter, order=7.5, },
				alertheader = { name=L["Alerts Filter"], type="header", width="double", order=12, },
				alearthelp = {
					name=L["Special attention buffs/debuffs aside from the above filtering. This is also used for vehicle and ready check statuses."],
					type="description", width="double", order=12.1, },
				balertadd = { name=L["Buff Add"], type="input", set=addfilter, order=12.2, },
				balertremove = { name=L["Buff Remove"], type="select", values=getfiltervalues, set=removefilter, order=12.3, },
				dalertadd = { name=L["Debuff Add"], type="input", set=addfilter, order=12.4, },
				dalertremove = { name=L["Debuff Remove"], type="select", values=getfiltervalues, set=removefilter, order=12.5, },
			},
		},
	},
}


do  -- setup options for grouped colors
	local keys={
		powercolor={
			MANA=0, RAGE=1, FOCUS=2, ENERGY=3, HAPPINESS=4, RUNES=5, RUNIC_POWER=6, SOUL_SHARDS=7,
			LUNAR_POWER=8, HOLY_POWER=9, MAELSTROM=11, INSANITY=13, FURY=17, PAIN=18,
		},
		reactioncolor={},
	}
	local function getcolor(info)
		local blah, colorgroup, key = infobreakdown(info)
		local dbk = db[colorgroup][ keys[colorgroup][key] ]
		if not dbk then
			return 0, 0, 0, 0
		else
			return dbk.r, dbk.g, dbk.b, dbk.a
		end
	end
	local function setcolor(info, r, g, b, a)
		local _, colorgroup, key = infobreakdown(info)
		local dbk = db[colorgroup][ keys[colorgroup][key] ]
		r, g, b, a = shorten(r), shorten(g), shorten(b), shorten(a)
		if not dbk then
			db[colorgroup][ keys[colorgroup][key] ] = { r=r, g=g, b=b, a=a, }
		else
			dbk.r, dbk.g, dbk.b, dbk.a = r, g, b, a
		end
		core.UpdateSettings("global")
	end

	local oargs = options.args.global.args
	local cargs = oargs.classcolor.args
	local classcolorshide
	if CUSTOM_CLASS_COLORS then
		classcolorshide = function()
			return not db.nocustomclass
		end
		cargs.help = {
			name=L["Use !ClassColors"], type="toggle", width="double", order = 0.1,
			get = function() return not db.nocustomclass end,
			set = function(info, value)
				db.nocustomclass = not value
				if value then
					core.CCC_CB = core.CCC_CB or function()
						for class, color in pairs(CUSTOM_CLASS_COLORS) do
							local dgcc = db.classcolor[class]
							dgcc.r, dgcc.g, dgcc.b = color.r, color.g, color.b
						end
						core.UpdateSettings("global")
					end
					CUSTOM_CLASS_COLORS:RegisterCallback(core.CCC_CB)
					core.CCC_CB()
				elseif core.CCC_CB then
					CUSTOM_CLASS_COLORS:UnregisterCallback(core.CCC_CB)
				end
			end,
		}
	end
	for class, color in pairs(RAID_CLASS_COLORS) do
		cargs[class] = { name=class, type="color", set=set, get=getcolororblank, hidden=classcolorshide, }
	end
	
	local pargs = oargs.powercolor.args
	for power, index in pairs(keys.powercolor) do
		pargs[power] = { name=getglobal(power) or power, type="color", set=setcolor, get=getcolor, order=index, }
	end
	
	local rargs = oargs.reactioncolor.args
	for i = 1, 8, 1 do
		local key = _G["FACTION_STANDING_LABEL"..i]
		if key then
			rargs["faction"..i] = { name=key, type="color", set=setcolor, get=getcolor, order=i, }
			keys.reactioncolor["faction"..i] = i
		end
	end
end


-------------------------------
function core.GetOptionsTable()
-------------------------------
	return options, textopts
end

AceConfig:RegisterOptionsTable("StufRaid", options)
--------------------------------
function core.OpenOptions(frame)
--------------------------------
	if frame and not optionframe then
		frame.hidden = true
		CreateOptionFrame()
	end
	InterfaceOptionsFrame_OpenToCategory(optionframe)
end