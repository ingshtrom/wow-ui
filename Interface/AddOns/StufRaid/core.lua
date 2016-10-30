-- StufRaid by TotalPackage
-- http://www.wowinterface.com/
-- http://www.wowinterface.com/list.php?skinnerid=27891

-- addon base
local StufRaid = CreateFrame("Frame", "StufRaid", UIParent)
local a = StufRaid

-- libraries
local smed = LibStub("LibSharedMedia-3.0")
smed:Register("border", "Corners 1pt", "Interface\\AddOns\\StufRaid\\corners1pt.tga")

-- localization support
-- for external localization, make a mod titled StufRaidLocale and create table StufRaidLocalization
local rawget = rawget
local L = setmetatable(StufRaidLocalization or { }, {
	__index = function(self, key)
		return rawget(self, key) or key
	end
})

-- addon tables
a.inits, a.events, a.aggroed, a.invehicle, a.vehicleowner = { }, { }, { }, { }, { }
a.raidfuncs, a.genfuncs, a.aggrofuncs, a.targetfuncs = { }, { }, { }, { }
a.modules = { }
a.backdrop = { bgFile="", edgeFile="", edgeSize=16, insets = { left=4, right=4, top=4, bottom=4, }, }
a.whitecolor = { r=1, g=1, b=1, a=1, }
local inits, events, aggroed, invehicle, vehicleowner = a.inits, a.events, a.aggroed, a.invehicle, a.vehicleowner
local raidfuncs, genfuncs, aggrofuncs, targetfuncs = a.raidfuncs, a.genfuncs, a.aggrofuncs, a.targetfuncs
local backdrop = a.backdrop

-- globals made local
local pairs, ipairs, wipe = pairs, ipairs, wipe
local strmatch, strsub = strmatch, string.utf8sub or string.sub
local ceil, floor, tonumber = math.ceil, math.floor, tonumber
local CreateFrame = CreateFrame
local GameTooltip = GameTooltip
local InCombatLockdown = InCombatLockdown
local GetNumGroupMembers = GetNumGroupMembers
local UnitIsPlayer, UnitCanAttack, UnitReaction = UnitIsPlayer, UnitCanAttack, UnitReaction
local UnitIsPVP, UnitIsPVPSanctuary = UnitIsPVP, UnitIsPVPSanctuary
local UnitExists, UnitInRaid, UnitIsUnit = UnitExists, UnitInRaid, UnitIsUnit
local UnitHasVehicleUI = UnitHasVehicleUI

-- local variables
local db, dbc, panel
local powercolor, classcolor, reactioncolor, shortstart
local basec, backc, bordc, mousec, tshadowc
local texture, border, namefont, numfont, nK, nM
local balert, dalert
local binclude, bexclude, dinclude, dexclude
local numraid = 0

-- local functions
local UpdateBuff, UpdateDebuff
local nothing = function() end
local tempload
a.nofunc = nothing
local function ShowOptions()
	if not a.OpenOptions then
		LoadAddOn("StufRaid_Options")
	end
	if a.OpenOptions then
		a.OpenOptions(panel)
	else
		print("|cff00ff00StufRaid|r: "..L["StufRaid_Options not found."])
	end
end


a:SetScript("OnEvent", function(this, event, ...)
	events[event](...)
end)
a:RegisterEvent("ADDON_LOADED")
----------------------------------
events.ADDON_LOADED = function(a1)
----------------------------------
	if a1 ~= "StufRaid" then return end
	events.ADDON_LOADED = nothing
	a:UnregisterEvent("ADDON_LOADED")
	a:RegisterEvent("PLAYER_LOGIN")
	events.PLAYER_LOGIN = function()
		events.PLAYER_LOGIN = nil
		if InCombatLockdown() then
			if not tempload then
				tempload = function()
					if not events.ADDON_LOADED then return end
					events.ADDON_LOADED("StufRaid")
				end
				a.AddEvent("PLAYER_REGEN_ENABLED", tempload)
				print("|cff00ff00StufRaid|r: "..L["Waiting to load until after combat ends."])
			end
			return
		elseif tempload then
			a.RemoveEvent("PLAYER_REGEN_ENABLED", tempload)
		end
		ClickCastFrames = ClickCastFrames or {}
		
		-- Saved Variables
		if StufRaidDB == "perchar" then
			StufRaidCharLayoutDB = StufRaidCharLayoutDB or { }
			db = StufRaidCharLayoutDB
		elseif StufRaidDB and StufRaidDB.temp then
			StufRaidCharLayoutDB = StufRaidDB.temp
			db = StufRaidCharLayoutDB
			StufRaidDB = "perchar"
			print("|cff00ff00StufRaid|r: "..L["Settings copied to this character."])
		else
			StufRaidCharLayoutDB = nil
			StufRaidDB = StufRaidDB or { }
			db = StufRaidDB
		end
		
		if db.init ~= 1 or not StufRaidCharDB then
			LoadAddOn("StufRaid_Options")
			if a.LoadDefaults then
				a.LoadDefaults(db, db.init == 1)
				db.init = 1
			else
				return print("|cff00ff00StufRaid|r: "..L["StufRaid_Options is required to initialize settings."])
			end
		end

		dbc = StufRaidCharDB
		classcolor, powercolor, reactioncolor = db.classcolor, db.powercolor, db.reactioncolor
		basec, backc, bordc, mousec, targetc, tshadowc = db.basec, db.backc, db.bordc, db.mousec, db.targetc, db.tshadowc

		if db.initlegion ~= 1 then
			for i = 0, 20, 1 do
				local color = PowerBarColor[i]
				if color and (not powercolor[i] or not powercolor[i].r) then
					powercolor[i]={ r=color.r, g=color.g, b=color.b, }
				end
			end
			for class, color in pairs(CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS) do
				if not classcolor[class] or not classcolor[class].r then
					classcolor[class]={ r=color.r, g=color.g, b=color.b, }
				end
			end
			db.initlegion = 1
		end
		
		if not a.OpenOptions then -- AceConfig hack to be LOD friendly
			panel = CreateFrame("Frame")
			panel.name = "StufRaid"
			panel:SetScript("OnShow", ShowOptions)
			InterfaceOptions_AddCategory(panel)
		end
		SlashCmdList.STUFRAID = ShowOptions
		SLASH_STUFRAID1 = "/stufraid"
		
		local _, CLS = UnitClass("player")
		if CLS == "PALADIN" then
			a.s40 = GetSpellInfo(4987)
		elseif CLS == "PRIEST" then
			a.s40 = GetSpellInfo(2061)
		elseif CLS == "DRUID" then
			a.s40 = GetSpellInfo(8936)
		elseif CLS == "MAGE" then
			a.s40 = GetSpellInfo(475)
		elseif CLS == "SHAMAN" then
			a.s40 = GetSpellInfo(1064)
		elseif CLS == "MONK" then
			a.s40 = GetSpellInfo(209525)
		end
		
		-- Class Colors support
		if not db.nocustomclass and CUSTOM_CLASS_COLORS then
			a.CCC_CB = a.CCC_CB or function()
				for class, color in pairs(CUSTOM_CLASS_COLORS) do
					classcolor[class].r, classcolor[class].g, classcolor[class].b = color.r, color.g, color.b
				end
				a.UpdateSettings("global")
			end
			CUSTOM_CLASS_COLORS:RegisterCallback(a.CCC_CB)
			a.CCC_CB()
		end
		-- OneButtonConfig support
		CONFIGMODE_CALLBACKS = CONFIGMODE_CALLBACKS or {}
		CONFIGMODE_CALLBACKS.StufRaid = function(action, mode)
			if action == "ON" then
				if not StufRaid.GetOptionsTable then
					LoadAddOn("StufRaid_Options")
				end
				if StufRaid.GetOptionsTable then
					StufRaid:GetOptionsTable().args.raid.args.previewgroup.set(nil, true)
				end
			elseif action == "OFF" then
				if StufRaid.GetOptionsTable then
					StufRaid:GetOptionsTable().args.raid.args.previewgroup.set(nil, nil)
				end
			end
		end
		
		
		a.RunInitFunction()
		for _, func in ipairs(a.modules) do
			func()
		end
		a.modules = nil
	end
	if IsLoggedIn() then
		events.PLAYER_LOGIN()
	end
end

-- AddOn Event Handling
local emulti = { }
--------------------------------
function a.AddEvent(event, func)
--------------------------------
	if not events[event] then  -- create new entry
		events[event] = func
		a:RegisterEvent(event)
	elseif events[event] == func then  -- same function, no need to add
		return
	elseif not emulti[event] then  -- setup multiple function calls for a single event
		emulti[event] = { events[event], func, }
		local mfee = emulti[event]
		events[event] = function(...)
			for _, f in ipairs(mfee) do
				f(...)
			end
		end
	else  -- add a new function to a multi-function event
		for index, ifunc in ipairs(emulti[event]) do
			if ifunc == func then return end
		end
		tinsert(emulti[event], func)
	end
end
-----------------------------------
function a.RemoveEvent(event, func)
-----------------------------------
	if not events[event] then return end
	if events[event] == func then
		events[event] = nil
		a:UnregisterEvent(event)
	elseif emulti[event] then
		for index, ifunc in ipairs(emulti[event]) do
			if ifunc == func then
				tremove(emulti[event], index)
				break
			end
		end
		if #emulti[event] == 0 then
			emulti[event] = nil
			events[event] = nil
			a:UnregisterEvent(event)
		end
	end
end

-- onupdate function handles all modules onupdate needs
local elapsed, tog = 2, nil
local function OnUpdate(this, a1)
	elapsed = elapsed + a1
	if elapsed < 0.19 then return end
	elapsed = 0
	
	tog = not tog
	if tog then
		local hasactivity
		for au in pairs(aggroed) do
			aggroed[au] = 0  -- had aggro before
			hasactivity = true
		end
		for i = 1, numraid, 1 do
			if UnitCanAttack("player", "raid"..i.."target") then
				local utt = "raid"..i.."targettarget"
				if UnitInRaid(utt) then
					for j = 1, numraid, 1 do
						if UnitIsUnit("raid"..j, utt) then
							aggroed["raid"..j] = 1  -- has aggro now
							hasactivity = true
							break
						end
					end
				end
			end
		end
		if hasactivity then  -- don't bother doing this if nothing changed
			for _, func in pairs(aggrofuncs) do  -- run aggro updating functions
				func(aggroed)
			end
			for au, value in pairs(aggroed) do  -- clear units that had aggro before but not now
				if value == 0 then
					aggroed[au] = nil
				end
			end
		end
	else
		for _, func in pairs(genfuncs) do  -- general updating
			func()
		end
	end
end

-- handle raid changes in and out of combat, function is delayed and throttled
local raidwait = CreateFrame("Frame", nil, a)
local waitelap, ouset = 0, nil
local function UpdateRoster(this, a1)
	waitelap = waitelap + a1
	if waitelap < 0.15 then return end
	waitelap = 0
	raidwait:SetScript("OnUpdate", nil)
	
	local inraid = IsInRaid()
	numraid = (inraid and GetNumGroupMembers()) or 0
	local incombat = InCombatLockdown()
	local hidearena = db.hidearena and select(2, IsInInstance()) == "arena"
	
	if inraid and not hidearena then  -- start the onupdate function if in raid, clear otherwise
		if not ouset then
			a:SetScript("OnUpdate", OnUpdate)
			for event, func in pairs(events) do
				a:RegisterEvent(event)
			end
			if targetc.a > 0 then
				a:RegisterEvent("PLAYER_TARGET_CHANGED")
			end
			ouset = true
		end
		for i = 1, numraid, 1 do
			events.UNIT_ENTERED_VEHICLE("raid"..i)
		end
	elseif ouset then
		OnUpdate(a, 2)
		a:SetScript("OnUpdate", nil)
		a:UnregisterAllEvents()
		a:RegisterEvent("GROUP_ROSTER_UPDATE")
		ouset = nil
		wipe(aggroed)
		wipe(invehicle)
		wipe(vehicleowner)
	end
	
	for _, func in pairs(raidfuncs) do  -- let other modules know that raid roster updated
		func(inraid, incombat, hidearena)
	end
	
	if incombat then  -- since anchor frames are protected, check for end of combat
		a:RegisterEvent("PLAYER_REGEN_ENABLED")
	else
		a:UnregisterEvent("PLAYER_REGEN_ENABLED")
	end
end
local function RaidWait()
	raidwait:SetScript("OnUpdate", UpdateRoster)
end
events.GROUP_ROSTER_UPDATE = RaidWait
events.PLAYER_REGEN_ENABLED = RaidWait

events.PLAYER_TARGET_CHANGED = function()
	local hastarget = UnitExists("target")
	for _, func in pairs(targetfuncs) do
		func(hastarget)
	end
end

events.UNIT_ENTERED_VEHICLE = function(u)
	local num = strmatch(u, "raid(%d+)")
	if not num then return end

	local pet = "raidpet"..num
	if UnitHasVehicleUI(u) then
		invehicle[u] = pet
		vehicleowner[pet] = u
	else
		invehicle[u] = nil
		vehicleowner[pet] = nil
	end
end
events.UNIT_EXITED_VEHICLE = function(u)
	if not invehicle[u] then return end
	local num = strmatch(u, "raid(%d+)")
	if num then
		invehicle[u] = nil
		vehicleowner["raidpet"..num] = nil
	end
end


-- register modules
------------------------------------------------------------------------------------
function a.AddInitFunction(name, initfunc, raidfunc, genfunc, aggrofunc, targetfunc)
------------------------------------------------------------------------------------
	inits[name] = initfunc  -- handles initialization and caching of settings
	raidfuncs[name] = raidfunc  -- called when raid roster is updated, arg1 is inraid, arg2 is incombat
	genfuncs[name] = genfunc  -- called in OnUpdate while in raid
	aggrofuncs[name] = aggrofunc  -- called when aggro changed is detected, arg1 is the table of aggroed raid units
	targetfuncs[name] = targetfunc  -- called when player target changes, arg1 is hastarget
end

-- update cache and tell other modules that variables are initialized/changed
----------------------------
function a.RunInitFunction()
----------------------------
	shortstart = db.shortstart
	texture = smed:Fetch("statusbar", db.texture)
	border = smed:Fetch("border", db.border)
	namefont = smed:Fetch("font", db.namefont)
	numfont = smed:Fetch("font", db.numfont)
	backdrop.bgFile = texture
	backdrop.edgeFile = border
	a.texture, a.border, a.namefont, a.numfont = texture, border, namefont, numfont

	balert, dalert = dbc.balert, dbc.dalert
	binclude, bexclude = nil, dbc.bexclude
	dinclude, dexclude = nil, dbc.dexclude
	for _, _ in pairs(dbc.binclude) do  -- checks if buff include filter table is not empty
		binclude = dbc.binclude
		break
	end
	for _, _ in pairs(dbc.dinclude) do  -- checks if debuff include filter table is not empty
		dinclude = dbc.dinclude
		break
	end
	db.nK = db.nK or "K"
	db.nM = db.nM or "M"
	nK, nM = db.nK, db.nM
	if db.inactivec and db.inactivec.a and db.inactivec.a > 0 then
		local r, g, b = db.inactivec.r * 255, db.inactivec.g * 255, db.inactivec.b * 255
		a.deadtext = format("|cff%02x%02x%02x%s|r", r, g, b, db.deadtext)
		a.ghosttext = format("|cff%02x%02x%02x%s|r", r, g, b, db.ghosttext)
		a.offlinetext = format("|cff%02x%02x%02x%s|r", r, g, b, db.offlinetext)
	else
		a.deadtext, a.ghosttext, a.offlinetext = db.deadtext, db.ghosttext, db.offlinetext
	end

	UpdateBuff = a.buff_funcs[dbc.bshow or "raid"]
	UpdateDebuff = a.debuff_funcs[dbc.dshow or "raid"]

	for layname, func in pairs(inits) do
		func(db, dbc)
	end

	a:RegisterEvent("GROUP_ROSTER_UPDATE")

	if UnitExists("raid1") then
		UpdateRoster(nil, 2)
	end
end

-------------------------------
function a.UpdateSettings(name)
-------------------------------
	if InCombatLockdown() then
		return print("|cff00ff00StufRaid|r: "..L["Cannot apply settings while in combat."])
	end
	if name == "global" then
		return a.RunInitFunction()
	end
	
	name = (name == "raidroletarget" and "raidrole") or name
	if inits[name] then
		inits[name](db, dbc)
	end
end

-- SetText functions for name text
local setftext, settext = BankFrameTitleText.SetFormattedText, BankFrameTitleText.SetText
local setname = {
	namegroup = function(fs, name, unit, charlimit, icon)
		local _, _, gn = GetRaidRosterInfo(tonumber(strmatch(unit, "raid(%d+)")) or 1)
		setftext(fs, "%d.%s", gn, charlimit and strsub(name, 1, charlimit) or name)
	end,
	name = function(fs, name, unit, charlimit, icon)
		setftext(fs, "%s%s", icon or "", charlimit and strsub(name, 1, charlimit) or name)
	end,
}

-- SetValue functions for health/power text
local settextvalue = {  -- settext functions for health/power text
	deficit = function(f, cur, tot, val)  -- deficit text that shows loss value, hidden if value is greater than 99%
		if val < 0.99 then
			local d = cur - tot
			if d > -shortstart then
				setftext(f, "%d", d)
			elseif d > -10000 then
				setftext(f, "%.1f%s", d * 0.001, nK)
			elseif d > -1000000 then
				setftext(f, "%d%s", d * 0.001, nK)
			else
				setftext(f, "%.1f%s", d * 0.000001, nM)
			end
		else
			settext(f, "")
		end
	end,
	perc = function(f, cur, tot, val)  -- percentage text, hidden if value is greater than 99%
		if val < 0.99 then
			setftext(f, "%d%%", 100 * val + 0.5)
		else
			settext(f, "")
		end
	end,
	percnosign = function(f, cur, tot, val)  -- percentage text with no percent sign
		if val < 0.99 then
			setftext(f, "%d", 100 * val + 0.5)
		else
			settext(f, "")
		end
	end,
	remain = function(f, cur, tot, val)  -- current value remaining text, hidden if value is greater than 99%
		if val < 0.99 then
			if cur < shortstart then
				setftext(f, "%d", cur)
			elseif cur < 1000000 then
				setftext(f, "%.1f%s", cur * 0.001, nK)
			else
				setftext(f, "%.1f%s", cur * 0.000001, nM)
			end
		else
			settext(f, "")
		end
	end,
	full = function(f, cur, tot, val)  -- shows current value with max value, always shown
		if cur < shortstart then
			if tot < shortstart then
				setftext(f, "%d/%d", cur, tot)
			elseif tot < 1000000 then
				setftext(f, "%d/%.1f%s", cur, tot * 0.001, nK)
			else
				setftext(f, "%d/%.1f%s", cur, tot * 0.000001, nM)
			end
		elseif cur < 1000000 then
			if tot < 1000000 then
				setftext(f, "%.1f%s/%.1f%s", cur * 0.001, nK, tot * 0.001, nK)
			else
				setftext(f, "%.1f%s/%.1f%s", cur * 0.001, nK, tot * 0.000001, nM)
			end
		else
			setftext(f, "%.1f%s/%.1f%s", cur * 0.000001, nM, tot * 0.000001, nM)
		end
	end,
	juststatus = function(f) settext(f, "") end,
	hide = nothing,
}

-- SetValue functions for statusbars
local setw, seth, setcoord = BankPortraitTexture.SetWidth, BankPortraitTexture.SetHeight, BankPortraitTexture.SetTexCoord
local function verval(val)
	return (not val and 0.99999) or ((val >= 1) and 0.99999) or ((val <= 0) and 0.00001) or val
end
local setbarvalue = {  -- setvalue functions for statusbars
	h = function(f, val, bv)  -- horizontal orientation
		val = verval(val)
		setw(f, val * (f.bv or bv or 1))
		setcoord(f, 0, val, 0, 1)
	end,
	hr = function(f, val, bv)  -- horizontal with reverse fill
		val = verval(val)
		setw(f, val * (f.bv or bv or 1))
		setcoord(f, 1-val, 1, 0, 1)
	end,
	hf = function(f, val, bv)  -- horizontal that fills with loss
		val = verval(val)
		setw(f, val * (f.bv or bv or 1))
		setcoord(f, 0, val, 0, 1)
	end,
	hrf = function(f, val, bv)  -- horizontal that reverse fills with loss
		val = verval(val)
		setw(f, (1.00001-val) * (f.bv or bv or 1))
		setcoord(f, val, 1, 0, 1)
	end,
	v = function(f, val, bv)  -- vertical orientation
		val = verval(val)
		seth(f, val * (f.bv or bv or 1))
		setcoord(f, val,0, 0,0, val,1, 0,1)
	end,
	vr = function(f, val, bv)  -- vertical with reverse fill
		val = verval(val)
		seth(f, val * (f.bv or bv or 1))
		setcoord(f, 1,0, 1-val,0, 1,1, 1-val,1)
	end,
	vf = function(f, val, bv)  -- vertical that fills with loss
		val = verval(val)
		seth(f, val * (f.bv or bv or 1))
		setcoord(f, val,0, 0,0, val,1, 0,1)
	end,
	vrf = function(f, val, bv)  -- vertical that reverse fills with loss
		val = verval(val)
		seth(f, (1.00001-val) * (f.bv or bv or 1))
		setcoord(f, 1,0, val,0, 1,1, val,1)
	end,
	hide = nothing,
}

-- color methods
local c, r, g, b, alpha, colormethods
colormethods = {
	class = function(p, db, choice, calpha)
		c = classcolor[p.CLASS or "PRIEST"] or classcolor.PRIEST
		return c.r, c.g, c.b, (calpha and db[calpha]) or c.a or 1
	end,
	classdark = function(p, db, choice, calpha)
		r, g, b, alpha = colormethods.class(p, db, choice, calpha)
		return r*0.3, g*0.3, b*0.3, alpha
	end,
	reaction = function(p, db, choice, calpha)
		local u, reaction = p.unit or "player", nil
		if UnitIsPlayer(u) then
			if UnitCanAttack(u, "player") then 
				reaction = 2
			elseif UnitCanAttack("player", u) then  -- Players we can attack but which are not hostile are yellow
				reaction = 4
			elseif UnitIsPVP(u) and not UnitIsPVPSanctuary(u) and not UnitIsPVPSanctuary("player") then  -- Players we can assist but are PvP flagged are green
				reaction = 6
			else
				reaction = 8
			end
		else  -- NPC
			reaction = UnitReaction(u, "player")
		end
		c = reaction and reactioncolor[reaction] or db[choice or "bgcolor"] or a.whitecolor
		return c.r, c.g, c.b, (calpha and db[calpha]) or c.a or 1
	end,
	reactiondark = function(p, db, choice, calpha)
		r, g, b, alpha = colormethods.reaction(p, db, choice, calpha)
		return r*0.3, g*0.3, b*0.3, alpha
	end,
	reactionnpc = function(p, db, choice, calpha)
		return colormethods[UnitIsPlayer(p.unit) and "class" or "reaction"](p, db, choice, calpha)
	end,
	reactionnpcdark = function(p, db, choice, calpha)
		return colormethods[UnitIsPlayer(p.unit) and "classdark" or "reactiondark"](p, db, choice, calpha)
	end,
	power = function(p, db, choice, calpha)
		c = powercolor[p.powertype or UnitPowerType(p.unit) or 1] or powercolor[1]
		return c.r, c.g, c.b, (calpha and db[calpha]) or c.a or 1
	end,
	powerdark = function(p, db, choice, calpha)
		r, g, b, alpha = colormethods.power(p, db, choice, calpha)
		return r*0.3, g*0.3, b*0.3, alpha
	end,
	solid = function(p, db, choice, calpha)
		c = db[choice or "bgcolor"]
		if c then
			return c.r, c.g, c.b, (calpha and db[calpha]) or c.a or 1
		else
			return 1, 1, 1, 1
		end
	end,
	hide = function(p) return 0, 0, 0, 0 end,
}
a.colormethods = colormethods

-- aura filter queues
local tindex = 0
local taura = { }
local function queueaura(icon, cnt, typ, duration, endtime, name)
	tindex = tindex + 1
	local t = taura[tindex]
	if not t then
		taura[tindex] = { }
		t = taura[tindex]
	end
	t.icon, t.cnt, t.typ, t.duration, t.endtime, t.name = icon, cnt > 1 and cnt or "", typ or "none", duration, endtime, name
end
local function clearqueue()
	for i = 1, tindex, 1 do
		local t = taura[i]
		t.icon, t.cnt, t.typ, t.duration, t.endtime, t.name = nil, nil, nil, nil, nil, nil
	end
	tindex = 0
end

local checkready
---------------------------
function a.CheckReady(flag)
---------------------------
	checkready = flag
end

local GetReadyCheckStatus = GetReadyCheckStatus
local UnitBuff, UnitDebuff, DebuffTypeColor = UnitBuff, UnitDebuff, DebuffTypeColor
--------------------------------------
function a.UpdateAlerts(u, uf, acount)  -- update alert icons
--------------------------------------
	if not uf or not acount then return end

	if checkready then  -- prevents checking for ready status if unnecessary
		local status = GetReadyCheckStatus(u)
		if status then  -- ready check icons
			if status == "ready" then
				queueaura("Interface\\RaidFrame\\ReadyCheck-Ready", 0, 0, nil, nil, "Ready")
			elseif status == "notready" then
				queueaura("Interface\\RaidFrame\\ReadyCheck-NotReady", 0, 0, nil, nil, "Not Ready")
			else
				queueaura("Interface\\RaidFrame\\ReadyCheck-Waiting", 0, 0, nil, nil, "Pending")
			end
		end
	end
	if vehicleowner[u] or invehicle[u] then  -- adds vehicle icon to alerts
		queueaura("Interface\\GossipFrame\\BinderGossipIcon.blp", 0, 0, nil, nil, "Vehicle")
	end
	for i = 1, 32, 1 do  -- check for alerts from buffs
		local bname, _, bicon, bcount, _, bduration, bendtime = UnitBuff(u, i)
		if not bname then break end
		if balert[bname] then
			queueaura(bicon, bcount, 0, bduration, bendtime, bname)
		end
	end
	for i = 1, 40, 1 do  -- check for alerts from debuffs
		local dname, _, dicon, dcount, dtype, dduration, dendtime = UnitDebuff(u, i)
		if not dname then break end
		if dalert[dname] then
			queueaura(dicon, dcount, dtype, dduration, dendtime, dname)
		end
	end
	local alert = uf.alert
	for i = 1, acount, 1 do  -- now handle the alert icons
		local ai, ti = alert[i], taura[i]
		if ti and ti.icon then
			ai.texture:SetTexture(ti.icon)
			ai.aname = ti.name
			if ti.typ == 0 then
				ai.indicator:SetAlpha(0)
				ai.count:SetText("")
			else
				local dc = DebuffTypeColor[ti.typ] or DebuffTypeColor.none
				ai.indicator:SetVertexColor(dc.r, dc.g, dc.b, 1)
				ai.count:SetText(ti.cnt)
			end
			if alert.showpie then
				local duration, endtime = ti.duration, ti.endtime
				if duration and duration > 0 then
					ai.pie:SetCooldown(endtime - duration, duration)
					ai.pie:Show()
				else
					ai.pie:Hide()
				end
			end
			ai:Show()
		else
			ai:Hide()
		end
	end
	clearqueue()
end
local UpdateAlerts = a.UpdateAlerts
---------------------------------------------------------------
function a.UpdateAura(u, uf, bcount, dcount, acount, hidebuffs)
---------------------------------------------------------------
	if not uf then return end
	local hasdebuff
	if dcount then  -- update debuff icons
		UpdateDebuff(u, dcount)
		local debuff = uf.debuff
		for i = 1, dcount, 1 do  -- now show/hide debuff icons
			local d, ti = debuff[i], taura[i]
			if ti and ti.icon then
				local dc = DebuffTypeColor[ti.typ]
				d.texture:SetTexture(ti.icon)
				d.aname = ti.name
				d.indicator:SetVertexColor(dc.r, dc.g, dc.b, 1)
				d.count:SetText(ti.cnt)
				d:Show()
				if debuff.showpie then
					local duration, endtime = ti.duration, ti.endtime
					if duration and duration > 0 then
						d.pie:SetCooldown(endtime - duration, duration)
						d.pie:Show()
					else
						d.pie:Hide()
					end
				end
				hasdebuff = true
			else
				d:Hide()
			end
		end
		clearqueue()
	end

	if bcount then -- update buff icons
		local buff = uf.buff
		if hidebuffs and hasdebuff then
			for i = 1, bcount, 1 do
				buff[i]:Hide()
			end
		else
			UpdateBuff(u, bcount)
			for i = 1, bcount, 1 do
				local b, ti = buff[i], taura[i]
				if ti and ti.icon then
					b.texture:SetTexture(ti.icon)
					b.aname = ti.name
					b.count:SetText(ti.cnt)
					if buff.showpie then
						local duration, endtime = ti.duration, ti.endtime
						if duration and duration > 0 then
							b.pie:SetCooldown(endtime - duration, duration)
							b.pie:Show()
						else
							b.pie:Hide()
						end
					end
					b:Show()
				else
					b:Hide()
				end
			end
			clearqueue()
		end
	end

	UpdateAlerts(u, uf, acount)
end

-- functions to be cached and used based on user settings
a.debuff_funcs = {
	raid = function(u, count)  -- what blizzard labels as curable debuffs
		for i = 1, count, 1 do
			local dname, _, dicon, dcount, dtype, dduration, dendtime = UnitDebuff(u, i, "RAID")
			if not dname then break end
			if not dexclude[dname] then
				queueaura(dicon, dcount, dtype, dduration, dendtime, dname)
			end
		end
		if not dinclude then return end
		for i = 1, 40, 1 do  -- in addition to curable, include these also
			local dname, _, dicon, dcount, dtype, dduration, dendtime = UnitDebuff(u, i)
			if not dname then break end
			if dinclude[dname] then
				queueaura(dicon, dcount, dtype, dduration, dendtime, dname)
			end
		end
	end,
	all = function(u, count)  -- all debuffs are shown, no filter of any kind is applied
		for i = 1, count, 1 do
			local dname, _, dicon, dcount, dtype, dduration, dendtime = UnitDebuff(u, i)
			if not dname then break end
			if not dexclude[dname] then
				queueaura(dicon, dcount, dtype, dduration, dendtime, dname)
			end
		end
	end,
	justinclude = function(u, count)  -- only include debuffs that are found in the filter
		if not dinclude then return end
		for i = 1, 40, 1 do
			local dname, _, dicon, dcount, dtype, dduration, dendtime = UnitDebuff(u, i)
			if not dname then break end
			if dinclude[dname] then
				queueaura(dicon, dcount, dtype, dduration, dendtime, dname)
			end
		end
	end,
	hide = nothing,
}
a.buff_funcs = {
	raid = function(u, count)  -- blizzard's castable buffs, both include and exclude filter is applied
		for i = 1, count, 1 do
			local bname, _, bicon, bcount, _, bduration, bendtime = UnitBuff(u, i, "RAID")
			if not bname then break end
			if not bexclude[bname] then
				queueaura(bicon, bcount, 0, bduration, bendtime, bname)
			end
		end
		if not binclude then return end
		for i = 1, 32, 1 do  -- in addition to castable, include these also
			local bname, _, bicon, bcount, _, bduration, bendtime = UnitBuff(u, i)
			if not bname then break end
			if binclude[bname] then
				queueaura(bicon, bcount, 0, bduration, bendtime, bname)
			end
		end
	end,
	all = function(u, count)  -- show all buffs, no filter of any kind is applied
		for i = 1, count, 1 do
			local bname, _, bicon, bcount, _, bduration, bendtime = UnitBuff(u, i)
			if not bname then break end
			if not bexclude[bname] then
				queueaura(bicon, bcount, 0, bduration, bendtime, bname)
			end
		end
	end,
	mine = function(u, count)  -- only show player buffs, exclude filter is applied
		if not bexclude then return end
		for i = 1, 32, 1 do
			local bname, _, bicon, bcount, _, bduration, bendtime, bismine = UnitBuff(u, i)
			if not bname or not (bismine == "player" or bismine == "vehicle") then break end
			if not bexclude[bname] then
				queueaura(bicon, bcount, 0, bduration, bendtime, bname)
			end
		end
	end,
	mineinclude = function(u, count)  -- only show player buffs that are in the include filter
		if not binclude then return end
		for i = 1, 32, 1 do
			local bname, _, bicon, bcount, _, bduration, bendtime, bismine = UnitBuff(u, i)
			if not bname or not (bismine == "player" or bismine == "vehicle") then break end
			if binclude[bname] then
				queueaura(bicon, bcount, 0, bduration, bendtime, bname)
			end
		end
	end,
	justinclude = function(u, count)
		if not binclude then return end
		for i = 1, 32, 1 do
			local bname, _, bicon, bcount, _, bduration, bendtime = UnitBuff(u, i)
			if not bname then break end
			if binclude[bname] then
				queueaura(bicon, bcount, 0, bduration, bendtime, bname)
			end
		end
	end,
	hide = nothing,
}


-- turns the growth variable into usable information
local key = { L = "LEFT", R = "RIGHT", T = "TOP", B = "BOTTOM", }
local function GrowthBreakdown(var)
	local d1, d2, d3, d4 = strmatch(var or "TBLR", "(%u?)(%u?)(%u?)(%u?)")
	d1, d2, d3, d4 = key[d1 or "L"], key[d2 or "R"], key[d3 or "T"], key[d4 or "B"]

	local hdir, vdir, hfirst
	if d1 == "LEFT" or d1 == "RIGHT" then
		hdir, vdir, hfirst = (d1 == "RIGHT" and -1) or 1, (d3 == "BOTTOM" and 1) or -1, true
	else
		hdir, vdir, hfirst = (d3 == "RIGHT" and -1) or 1, (d1 == "BOTTOM" and 1) or -1, false
	end

	return d1, d2, d3, d4, hdir, vdir, hfirst
end
a.GrowthBreakdown = GrowthBreakdown


-- create movers out of group anchors
local StufRaidDD, canchor, clayout, ismoving
local bdrop = { }
local function OnDragStop(this)
	this:StopMovingOrSizing()
	ismoving = false
	this.layout.anchorx = floor(this:GetLeft() + 0.5)
	this.layout.anchory = floor(this:GetTop() - GetScreenHeight() + 0.5)
end
local function OnDragStart(this)
	if not this.layout.lockanchor and not InCombatLockdown() then
		this:StartMoving()
		if ismoving == nil then  -- add escape hack in case drag frame gets stucked in drag mode
			GameMenuFrame:HookScript("OnShow", function()
				if ismoving then
					OnDragStop(ismoving)
				end
			end)
		end
		ismoving = this
	end
end
local function SetAnchor(btn, a1)
	if a1 == "lockanchor" then
		clayout.lockanchor = not clayout.lockanchor
	elseif a1 == "showanchor" then
		clayout.showanchor = not clayout.showanchor
		if InCombatLockdown() then return end
		if clayout.showanchor then
			canchor:EnableMouse(true)
			canchor:SetBackdropColor(0, 0, 0, 0.4)
		else
			canchor:EnableMouse(false)
			canchor:SetBackdropColor(0, 0, 0, 0)
		end
	end
end
local function OnMouseUp(this, btn)
	if btn ~= "RightButton" then return end
	clayout, canchor = this.layout, this
	if not StufRaidDD then
		StufRaidDD = CreateFrame("Frame", "StufRaidDD", a)
		StufRaidDD.displayMode = "MENU"
		StufRaidDD.initialize = function(self, lvl)
			if lvl ~= 1 then return end
			local info = UIDropDownMenu_CreateInfo()
			info.arg1 = "lockanchor"
			info.func = SetAnchor
			info.checked = clayout.lockanchor
			info.text = L["Lock Anchor"]
			UIDropDownMenu_AddButton(info, lvl)
			
			info.arg1 = "showanchor"
			info.checked = nil
			info.text = L["Hide Anchor"]
			UIDropDownMenu_AddButton(info, lvl)
		end
	end
	ToggleDropDownMenu(1, nil, StufRaidDD, "cursor")
end
-------------------------------
function a.MakeMover(f, layout)  -- setup an anchor to be interactive
-------------------------------
	bdrop.bgFile = texture
	f:SetBackdrop(bdrop)
	f:SetBackdropColor(0, 0, 0, 0)
	f:SetWidth(12)
	f:SetHeight(12)
	f:SetMovable(true)
	f:RegisterForDrag("LeftButton")
	f:SetScript("OnDragStart", OnDragStart)
	f:SetScript("OnDragStop", OnDragStop)
	f:SetScript("OnMouseUp", OnMouseUp)
	f.layout = layout
end


----------------------------------------------------
function a.CreateBar(uf, layout, name, updatehealth)  -- create status bars for health or power
----------------------------------------------------
	local f = uf[name]
	local dbe = layout[name]
	if not f then
		f = CreateFrame("Frame", nil, uf.border)
		f.bg = f:CreateTexture(nil, "BACKGROUND")
		f.bg:SetAllPoints(f)
		f.barbase = CreateFrame("Frame", nil, uf.border)
		f.bar = f:CreateTexture(nil, "BORDER")
		if name == "hpbar" then f.incbar = f:CreateTexture(nil, "OVERLAY") end
		uf[name] = f
		uf[name.."bar"] = f.bar
		f.db = dbe
	end
	if dbe.hide then
		f.bar.SetValue = setbarvalue.hide
		return f:Hide()
	else
		f:Show()
	end
	f:SetWidth(dbe.w)
	f:SetHeight(dbe.h)
	f:SetAlpha(dbe.alpha or 1)
	f:SetFrameLevel(dbe.framelevel or 10)
	f:SetPoint("TOPLEFT", uf, "TOPLEFT", dbe.x, dbe.y)
	
	local bg, barbase, bar, incbar = f.bg, f.barbase, f.bar, f.incbar
	local cw = dbe.w - (dbe.barinsetleft or 0) - (dbe.barinsetright or 0)
	local ch = dbe.h - (dbe.barinsettop or 0) - (dbe.barinsetbottom or 0)
	
	barbase:SetWidth(cw)
	barbase:SetHeight(ch)
	barbase:SetPoint("TOPLEFT", f, "TOPLEFT", (dbe.barinsetleft or 0), -(dbe.barinsettop or 0))
	bar:ClearAllPoints()
	
	local t = dbe.texture and smed:Fetch("statusbar", dbe.texture) or texture
	bar:SetTexture(t)
	bg:SetTexture(t)
	
	if incbar then
		incbar:SetWidth(cw)
		incbar:SetHeight(ch)
		incbar:ClearAllPoints()
		incbar:SetTexture(t)
		incbar:SetVertexColor(0.4, 1, 0.4, 0.9)
		incbar:Hide()
	end

	if dbe.fasthp and updatehealth then
		f.unit, f.uf = uf.unit, uf
		f:SetScript("OnUpdate", updatehealth)
	else
		f:SetScript("OnUpdate", nil)
	end

	-- setup bar orientations and texture coordinates
	if dbe.vertical then
		bar.bv = ch
		bar:SetWidth(cw)
		if dbe.reverse then
			bar.SetValue = setbarvalue["vr"..(dbe.fill and "f" or "")]
			bar:SetPoint("TOP", barbase, "TOP")
			setbarvalue.vr(bg, 1, dbe.h)
		else
			bar.SetValue = setbarvalue["v"..(dbe.fill and "f" or "")]
			bar:SetPoint("BOTTOM", barbase, "BOTTOM")
			setbarvalue.v(bg, 1, dbe.h)
		end
		if incbar then
			if dbe.reverse then
				incbar:SetPoint(dbe.fill and "BOTTOM" or "TOP", bar, "BOTTOM")
				incbar.SetValue = setbarvalue.vrf
			else
				incbar:SetPoint(dbe.fill and "BOTTOM" or "TOP", bar, "BOTTOM")
				incbar.SetValue = setbarvalue.vf
			end
		end
	else
		bar.bv = cw
		bar:SetHeight(ch)
		if dbe.reverse then
			bar.SetValue = setbarvalue["hr"..(dbe.fill and "f" or "")]
			bar:SetPoint("RIGHT", barbase, "RIGHT")
			setbarvalue.hr(bg, 1, dbe.w)
		else
			bar.SetValue = setbarvalue["h"..(dbe.fill and "f" or "")]
			bar:SetPoint("LEFT", barbase, "LEFT")
			setbarvalue.h(bg, 1, dbe.w)
		end
		if incbar then
			if dbe.reverse then
				incbar:SetPoint(dbe.fill and "RIGHT" or "LEFT", bar, "LEFT")
				incbar.SetValue = setbarvalue.hrf
			else
				incbar:SetPoint(dbe.fill and "LEFT" or "RIGHT", bar, "RIGHT")
				incbar.SetValue = setbarvalue.hf
			end
		end
	end
end

------------------------------------------------
function a.CreateIcon(uf, layout, name, texture)  -- basic icon creator
------------------------------------------------
	local f = uf[name]
	local dbe = layout[name]
	if not dbe or dbe.hide then
		if f then
			f:SetAlpha(0)
		end
		return
	end
	if not f then
		f = CreateFrame("Frame", nil, uf.border)
		f.icon = f:CreateTexture(nil, "ARTWORK")
		f.icon:SetAllPoints()
		f.icon:SetTexture(texture)
		if name == "combaticon" then
			f.icon:SetTexCoord(.5625, .9, .08, .4375)
		end
		f:Hide()
		uf[name] = f
	end
	f:SetWidth(dbe.w)
	f:SetHeight(dbe.h)
	f:SetPoint("TOPLEFT", uf, "TOPLEFT", dbe.x, dbe.y)
	f:SetAlpha(dbe.alpha or 1)
	f:SetFrameLevel(dbe.framelevel or 11)
end


local function CheapOnEnter(this) -- buff tooltip
	if not this.aname then return end
	GameTooltip:SetOwner(this, "ANCHOR_BOTTOMRIGHT", 8, -16)
	GameTooltip:SetText(this.aname, 1, 1, 1)
	GameTooltip:Show()
end
local function CheapOnLeave(this)
	GameTooltip:Hide()
end

---------------------------------------
function a.CreateAura(uf, layout, name)  -- creates aura groups for buffs, debuffs, and alerts
---------------------------------------
	local f = uf[name]
	local dbe = layout[name]
	if not f then
		f = CreateFrame("Frame", nil, uf.border)
		f:SetWidth(1)
		f:SetHeight(1)
		uf[name] = f
	end
	if dbe.hide then
		return f:Hide()
	else
		f:Show()
	end
	f:SetPoint("TOPLEFT", uf, "TOPLEFT", dbe.x, dbe.y)
	f:SetAlpha(dbe.alpha or 1)
	f:SetFrameLevel(dbe.framelevel or 12)

	local w, h = dbe.w, dbe.h
	local d1, d2, d3, d4, hdir, vdir, hfirst = GrowthBreakdown(dbe.growth)
	local spacing, vspacing = dbe.hspacing or 0, dbe.vspacing or 0
	local cols, rows = dbe.cols or (hfirst and 2) or 1, dbe.rows or (hfirst and 1) or 2
	
	for i = 1, cols * rows, 1 do
		local icon = f[i]
		if not icon then
			icon = CreateFrame("Frame", nil, f)
			icon:Hide()
			
			icon.texture = icon:CreateTexture(nil, "BORDER")
			icon.texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
			icon.texture:SetAllPoints()
			
			icon.count = icon:CreateFontString(nil, "OVERLAY")
			icon.count:SetPoint("BOTTOMRIGHT")
			
			if name ~= "buff" then
				icon.indicator = icon:CreateTexture(nil, "ARTWORK")
				icon.indicator:SetTexture("Interface\\AddOns\\StufRaid\\indicator.tga")
				icon.indicator:SetAllPoints()
			end
			f[i] = icon
		end
		if dbe.mouseable then
			icon:SetScript("OnEnter", CheapOnEnter)
			icon:SetScript("OnLeave", CheapOnLeave)
			icon:EnableMouse(true)
		else
			icon:EnableMouse(nil)
		end
		icon:SetWidth(w)
		icon:SetHeight(h)
		icon:SetAlpha(1)
		icon:ClearAllPoints()
		
		if dbe.showpie then
			icon.pie = icon.pie or CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
			icon.pie:SetReverse(true)
			icon.pie.noCooldownCount = db.hidecc
			f.showpie = true
			icon.pie:Show()
		elseif icon.pie then
			f.showpie = nil
			icon.pie:Hide()
		end
		
		icon.count:SetFont(numfont, floor(h * 0.7))
		
		if hfirst then  -- LRTB, LRBT, RLTB, RLBT
			local crow = ceil(i / cols)
			if crow > rows then break end
			local ccol = i % cols
			ccol = (ccol == 0 and cols) or ccol
			if i == 1 then  -- first row, first col
				icon:SetPoint(d3..d1, f, d3..d1)
			elseif ccol == 1 then  -- start of a new row (first column)
				icon:SetPoint(d3, f[i - cols], d4, 0, vspacing * vdir)
			else
				icon:SetPoint(d1, f[i - 1], d2, spacing * hdir, 0)
			end
		else  -- TBLR, TBRL, BTLR, BTRL
			local ccol = ceil(i / rows)
			if ccol > cols then break end
			local crow = i % rows
			crow = (crow == 0 and rows) or crow
			if i == 1 then  -- first row, first col
				icon:SetPoint(d1..d3, f, d1..d3)
			elseif crow == 1 then  -- start of a new column (first row)
				icon:SetPoint(d3, f[i - rows], d4, spacing * hdir, 0)
			else
				icon:SetPoint(d1, f[i - 1], d2, 0, vspacing * vdir)
			end
		end
	end
	for i = cols * rows + 1, 256, 1 do
		if not f[i] then break end
		f[i]:SetAlpha(0)
	end
end

---------------------------------------
function a.CreateText(uf, layout, name)
---------------------------------------
	local f = uf[name]
	local dbe = layout[name]
	if not f then
		f = CreateFrame("Frame", nil, uf.border)
		f.fontstring = f:CreateFontString(nil, "ARTWORK")
		f.fontstring:SetAllPoints()
		uf[name] = f
		uf[name.."text"] = f.fontstring
	end
	local ft = f.fontstring
	if dbe.hide then
		f:Hide()
		ft:SetFont(namefont, 2)
		ft.SetValue = settextvalue.hide
	else
		f:Show()
		f:SetFrameLevel(dbe.framelevel or 13)
		f:SetWidth(dbe.w)
		f:SetHeight(dbe.h)
		f:SetAlpha(dbe.alpha or 1)
		f:SetPoint("TOPLEFT", uf, "TOPLEFT", dbe.x, dbe.y)
		
		ft:SetFont((name == "nametext" and namefont) or numfont, dbe.fontsize or 12, dbe.fontflags ~= "None" and dbe.fontflags)
		ft:SetShadowColor(tshadowc.r, tshadowc.g, tshadowc.b, tshadowc.a)
		ft:SetShadowOffset(dbe.shadowx or 0, dbe.shadowy or 0)
		ft:SetJustifyH(dbe.justifyH or "CENTER")
		ft:SetJustifyV(dbe.justifyV or "CENTER")
		if name == "nametext" then
			ft.SetValue = setname[dbe.showgroup and "namegroup" or "name"]
		else
			ft.SetValue = settextvalue[dbe.textformat or "hide"] or settextvalue.deficit
		end
	end
end


local SpellIsTargeting, SpellCanTargetUnit, SetCursor = SpellIsTargeting, SpellCanTargetUnit, SetCursor
local function OnEnter(this)  -- mouseover handler for individual raid units
	this.mouseborder:SetAlpha(mousec.a)
	local u = this.activeunit or this.unit
	if not u then return end
	if this.ttcombathide and InCombatLockdown() then  -- hide tooltip in combat
		-- do nothing
	elseif this.ttcustom then  -- show tooltip at custom point
		GameTooltip:SetOwner(this.anchor, "ANCHOR_"..(this.ttanchor or "TOPRIGHT"), this.ttx, this.tty)
		if SpellIsTargeting() then
			SetCursor(SpellCanTargetUnit(u) and "CAST_CURSOR" or "CAST_ERROR_CURSOR")
		end
		GameTooltip:SetUnit(u)
	else  -- default tooltip
		UnitFrame_UpdateTooltip(this)
	end
end
local function OnLeave(this)
	this.mouseborder:SetAlpha(0)
	GameTooltip:Hide()
end
--------------------------------------------------------------------
function a.CreateUnitBase(uf, layout, anchor, layout2, updatehealth)
--------------------------------------------------------------------
	if not uf.border then
		uf:RegisterForClicks("AnyUp")
		uf:SetScript("OnEnter", OnEnter)
		uf:SetScript("OnLeave", OnLeave)
		uf.layout = layout
		
		uf.bg = uf:CreateTexture(nil, "BACKGROUND")
		uf.bg:SetPoint("TOPLEFT", uf, "TOPLEFT", 0, 0)
		uf.bg:SetPoint("BOTTOMRIGHT", uf, "BOTTOMRIGHT", -1, 1)
		
		uf.border = CreateFrame("Frame", nil, uf)
		uf.border:SetPoint("TOPLEFT", uf, "TOPLEFT", -4, 4)
		uf.border:SetPoint("BOTTOMRIGHT", uf, "BOTTOMRIGHT", 3, -3)
		
		uf.mouseborder = CreateFrame("Frame", nil, uf.border)
		uf.mouseborder:SetAllPoints()
		uf.mouseborder:SetFrameLevel(13)
		
		ClickCastFrames[uf] = true
	end
	uf.bg:SetTexture(texture)
	uf.bg:SetVertexColor(basec.r, basec.g, basec.b, basec.a)
	
	uf.border:SetBackdrop(backdrop)
	uf.border:SetBackdropColor(backc.r, backc.g, backc.b, backc.a)
	uf.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
	
	uf.mouseborder:SetBackdrop(backdrop)
	uf.mouseborder:SetBackdropColor(0, 0, 0, 0)
	uf.mouseborder:SetBackdropBorderColor(mousec.r, mousec.g, mousec.b)
	uf.mouseborder:SetAlpha(0)
	
	uf.anchor = anchor
	uf.ttcombathide, uf.ttcustom, uf.ttanchor, uf.ttx, uf.tty = layout.ttcombathide, layout.ttcustom, layout.ttanchor, layout.ttx, layout.tty
	
	a.CreateBar(uf, layout2 or layout, "hpbar", updatehealth)
	a.CreateText(uf, layout2 or layout, "nametext")
	a.CreateText(uf, layout2 or layout, "hptext")
	a.CreateIcon(uf, layout2 or layout, "raidicon", "Interface\\TargetingFrame\\UI-RaidTargetingIcons")

	uf.unit = uf:GetAttribute("unit")
end

-- updates a group's attributes, label, and position
--   (header frame, label text, anchor, group settings, group filter/order, group by, layout width, layout height)
-------------------------------------------------------------------
function a.SetupGroup(f, label, anchor, gdb, gfilter, groupby, w, h)
-------------------------------------------------------------------
	local lc = db.fontcolor or a.whitecolor
	label:SetFont(namefont, db.fontsize or 6)
	label:SetTextColor(lc.r, lc.g, lc.b)
	label:SetAlpha(lc.a)
	label:SetText(gdb.label or gfilter)
	
	f:Hide()  -- hide header before settting attributes
	f:ClearAllPoints()
	label:ClearAllPoints()

	f:SetAttribute("groupFilter", gfilter)
	f:SetAttribute("groupingOrder", gfilter)
	f:SetAttribute("groupBy", groupby)
	
	local d1, d2, d3, d4, hdir, vdir, hfirst = GrowthBreakdown(gdb.growth)
	if hfirst then
		f:SetAttribute("point", d2)
		label:SetPoint(d2, anchor, "TOPLEFT", gdb.x, gdb.y - h/2)
		f:SetPoint("TOP"..d1, anchor, "TOPLEFT", gdb.x, gdb.y)
		f:SetAttribute("xOffset", (gdb.hspacing or 0) * (hdir == 1 and -1 or 1))
		f:SetAttribute("yOffset", 0)
		f:SetAttribute("maxColumns", gdb.rows or 1)
		f:SetAttribute("unitsPerColumn", gdb.cols or 5)
		if vdir == 1 then
			f:SetAttribute("columnSpacing", -((gdb.vspacing or 0) + h * 2))
		else
			f:SetAttribute("columnSpacing", gdb.vspacing or 0)
		end
		f:SetAttribute("columnAnchorPoint", "TOP")
	else
		f:SetAttribute("point", d2)
		label:SetPoint(d2, anchor, "TOPLEFT", gdb.x + w/2, gdb.y)
		f:SetPoint(d1.."LEFT", anchor, "TOPLEFT", gdb.x, gdb.y)
		f:SetAttribute("xOffset", 0)
		f:SetAttribute("yOffset", (gdb.vspacing or 0) * (vdir == 1 and -1 or 1))
		f:SetAttribute("maxColumns", gdb.cols or 1)
		f:SetAttribute("unitsPerColumn", gdb.rows or 5)
		
		if hdir == -1 then
			f:SetAttribute("columnSpacing", -((gdb.hspacing or 0) + w * 2))
		else
			f:SetAttribute("columnSpacing", gdb.hspacing or 0)
		end
		f:SetAttribute("columnAnchorPoint", "LEFT")
	end
	f:SetAttribute("sortDir", gdb.sortdir or "DESC")
	f:SetAttribute("sortMethod", (gdb.sortbyname and "NAME") or "INDEX")
	f:Show()
end


