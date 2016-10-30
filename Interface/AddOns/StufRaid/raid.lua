if not StufRaid then return end

-- Raid Group module base
local core = StufRaid
local a = CreateFrame("Frame", nil, core)
core.raid = a
local invehicle, vehicleowner = core.invehicle, core.vehicleowner
local aggroed = core.aggroed

local units, groups, labels = { }, { }, { }
a.units, a.groups, a.labels = units, groups, labels

-- layout settings made local
local layout, s40
local bordc, aggroc, targetc
local hpdb, mpdb, namedb, hptdb, mptdb
local hpbgcm, hpbarcm, mpbgcm, mpbarcm, namecm, hptcm, mptcm
local showlooter, showleader, showcombaticon, charlimit
local bcount, dcount, acount, hidebuffs
local w, h, ooralpha, deadalpha = 0, 0, 1, 1
local dbver = 0

-- globals made local
local pairs = pairs
local strsub = string.utf8sub or string.sub
local UnitExists, UnitIsUnit = UnitExists, UnitIsUnit

-- local functions
local UpdateUnit, UpdateHealth


local tog = 0
local UnitAffectingCombat, UnitIsConnected = UnitAffectingCombat, UnitIsConnected
local UnitIsVisible, IsSpellInRange, UnitInRange = UnitIsVisible, IsSpellInRange, UnitInRange
local function UpdateGeneral()  -- update basic stuff
	tog = (tog > 2 and 0) or (tog + 1)
	for u, uf in pairs(units) do  -- periodically check for status flags and unit range
		local vu = invehicle[u] or u
		if showcombaticon and tog == 2 then  -- check for combat
			if UnitAffectingCombat(vu) then
				uf.combaticon:Show()
			else
				uf.combaticon:Hide()
			end
		elseif tog == 0 then  -- check if connected
			if not UnitIsConnected(u) and UnitExists(u) then
				uf.hptexttext:SetText(core.offlinetext)
				uf.dced = true
			elseif uf.dced then
				uf.dced = nil
				UpdateHealth(vu, uf)
			end
		end
		-- update overlay opacity
		if uf.dead or uf.dced then
			uf.border:SetAlpha(deadalpha)
		elseif not UnitIsVisible(vu) or (s40 and IsSpellInRange(s40, vu) ~= 1) or (not s40 and not UnitInRange(vu)) then
			uf.border:SetAlpha(ooralpha)
		else
			uf.border:SetAlpha(1)
		end
	end
end
local function UpdateAggro(atable)  -- check for aggro
	if aggroc.a < 0.05 then return end
	for u, value in pairs(atable) do
		local uf = units[u]
		if uf then
			if value == 1 then
				if not uf.aggroed then
					uf.border:SetBackdropBorderColor(aggroc.r, aggroc.g, aggroc.b, aggroc.a)
					uf.aggroed, uf.targeted = true, nil
				end
			elseif value == 0 and uf.aggroed then
				uf.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
				uf.aggroed = nil
			end
		end
	end
end
local function UpdateTarget(hastarget)  -- current target highlighting
	if targetc.a < 0.05 then return end
	if hastarget then
		for u, uf in pairs(units) do
			if not uf.aggroed then  -- color border if it's your current target and doesn't have aggro
				if UnitIsUnit("target", invehicle[u] or u) then
					if not uf.targeted then
						uf.border:SetBackdropBorderColor(targetc.r, targetc.g, targetc.b, targetc.a)
						uf.targeted = true
					end
				elseif uf.targeted then
					uf.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
					uf.targeted = nil
				end
			end
		end
	else
		for u, uf in pairs(units) do
			if uf.targeted then  -- clear target border
				uf.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
				uf.targeted = nil
			end
		end
	end
end

local GetLootMethod, UnitIsPartyLeader = GetLootMethod, UnitIsGroupLeader or UnitIsPartyLeader
local function UpdateRaid(inraid, incombat, hidearena)
	local haschild
	for u, uf in pairs(units) do
		units[u] = nil
	end
	if inraid and not hidearena then
		for index, gf in pairs(groups) do  -- update title visibility
			for i = 1, 40, 1 do
				local uf = gf:GetAttribute("child"..i)
				if not uf then break end
				if uf:IsShown() then
					local u = uf:GetAttribute("unit")
					uf.unit = u
					units[u] = uf
					
					if showlooter then uf.looticon:Hide() end
					if showleader then uf.leadericon:Hide() end
					
					if i == 1 then
						haschild = true
						labels[index]:Show()
					end
				elseif i == 1 then
					labels[index]:Hide()
				end
			end
		end
		if showlooter then  -- update loot icon
			local method, pid, rid = GetLootMethod()
			local looter = (method == "master" and "raid"..rid) or nil
			local uf = looter and units[looter]
			if uf then
				uf.looticon:Show()
			end
		end
		if showleader then  -- update leader icon
			if not leader or not UnitIsPartyLeader(leader) then  -- look for new leader
				for u, uf in pairs(units) do
					if UnitIsPartyLeader(u) then
						uf.leadericon:Show()
						leader = u
						break
					end
				end
			else  -- refresh current leader icon
				local uf = leader and units[leader]
				if uf then
					uf.leadericon:Show()
				end
			end
		end
		tog = 3
		UpdateGeneral()
	else
		for index, gf in pairs(groups) do
			labels[index]:Hide()
			if not incombat then
				if hidearena then
					gf:Hide()
				elseif not gf:IsShown() and not gf.db.hide then
					gf:Show()
				end
			end
		end
	end
	-- update anchor visibility, only done out of combat since it is protected
	if haschild and layout.showanchor and not incombat then
		a:EnableMouse(true)
		a:SetBackdropColor(0, 0, 0, 0.4)
	elseif not incombat then
		a:EnableMouse(false)
		a:SetBackdropColor(0, 0, 0, 0)
	end
end

-- Health
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local UnitGetIncomingHeals = UnitGetIncomingHeals
local UnitIsDeadOrGhost, UnitIsGhost = UnitIsDeadOrGhost, UnitIsGhost
function UpdateHealth(u, uf)
	uf = uf or units[vehicleowner[u] or u]
	if not uf then return end
	u = uf.activeunit
	if UnitIsDeadOrGhost(u) then
		uf.hptexttext:SetText((UnitIsGhost(u) and core.ghosttext) or core.deadtext)
		uf.hpbarbar:SetValue((hpdb.fulldead and 1) or 0.00001)
		uf.border:SetAlpha(deadalpha)
		uf.dead = true
	else
		local current, total = UnitHealth(u), UnitHealthMax(u) or 1
		local frac = (current == 0 and 0.00001) or (current >= total and 1) or (current / total)
		uf.frachp = frac
		uf.maxhp = total
		uf.hpbarbar:SetValue(frac)
		uf.hptexttext:SetValue(current, total, frac)
		uf.dead = nil
		if hpdb.incheal and uf.hpbar.incbar then
			local incheal = (UnitGetIncomingHeals(u) or 0) / total
			if incheal ~= uf.previnc then
				if incheal + frac > 1.1 then
					incheal = 1.1 - frac
				end
				if total <= 0 or incheal <= 0.0001 then
					uf.hpbar.incbar:Hide()
				else
					uf.hpbar.incbar:SetValue(incheal)
					uf.hpbar.incbar:Show()
				end
				uf.previnc = incheal
			end
		end
	end
end

-- Power
local UnitPower, UnitPowerMax, UnitPowerType = UnitPower, UnitPowerMax, UnitPowerType
local function UpdatePower(u, ptype, uf)
	uf = uf or units[vehicleowner[u] or u]
	if not uf then return end
	u = uf.activeunit
	if uf.powertype == 0 then
		local current, total = UnitPower(u), UnitPowerMax(u)
		local frac = (current == 0 and 0.00001) or (current >= total and 1) or (current / total)
		uf.mptexttext:SetValue(current, total, current == 0 and 0 or frac)
		uf.mpbarbar:SetValue(frac)
	else
		uf.mptexttext:SetText("")
		uf.mpbarbar:SetValue(0.00001)
	end
end
local function UpdatePowerType(u, uf)
	uf = uf or units[u]
	if not uf then return end
	uf.powertype = ((invehicle[u] or vehicleowner[u]) and 1) or UnitPowerType(u)
	
	uf.hpbar.bg:SetVertexColor(hpbgcm(uf, hpdb, "bgcolor", "bgalpha"))
	uf.hpbarbar:SetVertexColor(hpbarcm(uf, hpdb, "barcolor", "baralpha"))
	uf.mpbar.bg:SetVertexColor(mpbgcm(uf, mpdb, "bgcolor", "bgalpha"))
	uf.mpbarbar:SetVertexColor(mpbarcm(uf, mpdb, "barcolor", "baralpha"))
	uf.nametexttext:SetTextColor(namecm(uf, namedb, "fontcolor"))
	uf.hptexttext:SetTextColor(hptcm(uf, hptdb, "fontcolor"))
	uf.mptexttext:SetTextColor(mptcm(uf, mptdb, "fontcolor"))
	
	UpdatePower(u, nil, uf)
end

-- Raid Target Icons
local GetRaidTargetIndex, SetRaidTargetIconTexture = GetRaidTargetIndex, SetRaidTargetIconTexture
local function UpdateRaidTarget(u, uf)
	if layout.raidicon.hide then return end
	if u and uf then
		local iconindex = GetRaidTargetIndex(u)
		if iconindex then
			SetRaidTargetIconTexture(uf.raidicon.icon, iconindex)
			uf.raidicon:Show()
		else
			uf.raidicon:Hide()
		end
	else
		for u, uf in pairs(units) do
			local iconindex = GetRaidTargetIndex(invehicle[u] or u)
			if iconindex then
				SetRaidTargetIconTexture(uf.raidicon.icon, iconindex)
				uf.raidicon:Show()
			else
				uf.raidicon:Hide()
			end
		end
	end
end

local UpdateAura = core.UpdateAura
local function UpdateRaidAura(u, uf)
	uf = uf or units[vehicleowner[u] or u]
	if uf then
		UpdateAura(uf.activeunit, uf, bcount, dcount, acount, hidebuffs)
	end
end

local function UpdateVehicle(u)  -- update to reflect vehicle possession
	local uf = units[u]
	if uf then
		uf.uname = nil
		UpdateUnit(u, uf)
	end
end

local UpdateAlerts = core.UpdateAlerts
local function UpdateReadyCheck()  -- ready check alerts
	core.CheckReady(true)
	for u, uf in pairs(units) do
		UpdateAlerts(u, uf, acount)
	end
end
local function UpdateReadyCheckFinish()
	core.CheckReady(false)
	for u, uf in pairs(units) do
		UpdateAlerts(u, uf, acount)
	end
end

local function VoiceStart(u)
	local uf = units[u]
	if uf then
		uf.voiceicon:Show()
	end
end
local function VoiceStop(u)
	local uf = units[u]
	if uf then
		uf.voiceicon:Hide()
	end
end

local function updatepet(uf, event, a1)
	if a1 == uf.unit then
		uf:UnregisterEvent("UNIT_PET")
		uf.uname = nil
		UpdateUnit(a1, uf)
	end
end

local UnitName, UnitClass = UnitName, UnitClass
UpdateUnit = function(u, uf)
	uf = uf or units[u]
	if not uf then return end
	
	local name = UnitName(u)
	local vu = invehicle[u] or u
	if uf.uname == name and uf.activeunit == vu then return end
	if uf.activeunit ~= vu and vehicleowner[vu] then
		uf:RegisterEvent("UNIT_PET")
		uf:SetScript("OnEvent", updatepet)
	end
	uf.uname, uf.activeunit = name, vu
	uf.class, uf.CLASS = UnitClass(u)
	uf.nametexttext:SetValue(name, u, charlimit, "")
	uf.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
	UpdatePowerType(vu, uf)
	UpdateHealth(vu, uf)
	UpdateRaidAura(vu, uf)
	UpdateRaidTarget(vu, uf)
	if uf.voiceicon then
		uf.voiceicon:Hide()
	end
	if uf.aggroed and not aggroed[vu] then
		uf.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
		uf.aggroed = nil
	elseif not uf.aggroed and aggroed[vu] then
		uf.border:SetBackdropBorderColor(aggroc.r, aggroc.g, aggroc.b, aggroc.a)
		uf.aggroed = true
		uf.targeted = nil
	end
end

local function FastHealthOnUpdate(this)
	this.dofasthp = not this.dofasthp
	if not this.dofasthp then return end
	UpdateHealth(this.unit, this.uf)
end
local function CreateRaidUnit(uf)  -- dress up the unit frame given by secure handlers
	if uf.dbver == dbver then return end  -- don't update frame if unnecessary
	uf.dbver = dbver
	core.CreateUnitBase(uf, layout, a, nil, FastHealthOnUpdate)

	core.CreateBar(uf, layout, "mpbar")
	core.CreateText(uf, layout, "mptext")
	
	core.CreateAura(uf, layout, "buff")
	core.CreateAura(uf, layout, "debuff")
	core.CreateAura(uf, layout, "alert")
	
	core.CreateIcon(uf, layout, "looticon", "Interface\\GroupFrame\\UI-Group-MasterLooter")
	core.CreateIcon(uf, layout, "leadericon", "Interface\\GroupFrame\\UI-Group-LeaderIcon")
	core.CreateIcon(uf, layout, "voiceicon", "Interface\\Common\\VoiceChat-Speaker")
	core.CreateIcon(uf, layout, "combaticon", "Interface\\CharacterFrame\\UI-StateIcon")

	if uf.unit then
		units[uf.unit] = uf
	end
end

local function UpdateAttribute(this, name, value)
	if name ~= "unit" then return end
	if value then
		units[value] = this
		this.unit = value
		UpdateUnit(value, this)
	else
		for u, uf in pairs(units) do
			if uf == this then
				units[u] = nil
			end
		end
	end
end
local function HeaderConfig(header, buttonName)
	local uf
	if type(buttonName) == "string" then
		uf = _G[buttonName]
	else
		return
	end
	uf:SetScript("OnAttributeChanged", UpdateAttribute)
	CreateRaidUnit(uf)
end

local function CreateRaidGroup(index)
	local db = layout["group"..index]
	local f, label = groups[index], labels[index]
	if not db or db.hide then
		if f then
			f:Hide()
		end
		if label then
			label:SetAlpha(0)
		end
		return
	end
	if not f then
		f = CreateFrame("Frame", "StufRaidHeader"..index, a, "SecureRaidGroupHeaderTemplate")
		f.initialConfigFunction = HeaderConfig
		f:SetAttribute("minWidth", w)
		f:SetAttribute("minHeight", h)
		f:SetAttribute("initialConfigFunction", [===[ 
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("minWidth"))
			self:SetHeight(header:GetAttribute("minHeight"))
			self:SetAttribute("type1", "target")
			self:SetAttribute("*type1", "target")
			self:SetAttribute("toggleForVehicle", true)
			header:CallMethod("initialConfigFunction", self:GetName())
		]===])
		f:SetAttribute("template", "SecureUnitButtonTemplate")
		f:SetWidth(8)
		f:SetHeight(8)
		f.db = db
		label = a:CreateFontString(nil, "ARTWORK")
		label:Hide()
		
		groups[index], labels[index] = f, label
	end
	f:SetAttribute("minWidth", w)
	f:SetAttribute("minHeight", h)
	if layout.byclass then
		core.SetupGroup(f, label, a, db, db.classorder or "WARRIOR", "CLASS", w, h)
	else
		core.SetupGroup(f, label, a, db, db.order or "1", "GROUP", w, h)
	end
	f:Show()
end

local cm = core.colormethods
local function raidinit(db, dbc)
	-- cache global settings
	bordc, targetc, aggroc = db.bordc, db.targetc, db.aggroc
	ooralpha, deadalpha = db.ooralpha, db.deadalpha
	s40 = core.s40
	
	-- cache raid layout settings
	layout = db.raid
	w, h = layout.w, layout.h
	hpdb, mpdb = layout.hpbar, layout.mpbar
	namedb, hptdb, mptdb = layout.nametext, layout.hptext, layout.mptext
	hpbgcm, hpbarcm = cm[hpdb.bgcolormethod or "solid"], cm[hpdb.barcolormethod or "solid"]
	mpbgcm, mpbarcm = cm[mpdb.bgcolormethod or "solid"], cm[mpdb.barcolormethod or "solid"]
	namecm = cm[namedb.colormethod or "class"]
	hptcm = cm[hptdb.colormethod or "solid"]
	mptcm = cm[mptdb.colormethod or "solid"]
	charlimit = namedb.chars > 0 and namedb.chars or nil
	showcombaticon, showlooter, showleader = not layout.combaticon.hide, not layout.looticon.hide, not layout.leadericon.hide
	bcount = not layout.buff.hide and dbc.bshow ~= "hide" and (layout.buff.cols * layout.buff.rows)
	dcount = not layout.debuff.hide and dbc.dshow ~= "hide" and (layout.debuff.cols * layout.debuff.rows)
	acount = not layout.alert.hide and (layout.alert.cols * layout.alert.rows)
	hidebuffs = layout.debuff.hidebuff
	
	if not a:IsMovable() then  -- setup the anchor frame and make it movable, handled in the core
		core.MakeMover(a, layout)
	end
	a:SetPoint("TOPLEFT", UIParent, "TOPLEFT", layout.anchorx, layout.anchory)
	if db.strata then a:SetFrameStrata(db.strata) end
	
	dbver = dbver + 1
	local changed
	if dbver > 1 then
		changed = true
	else
		core.AddEvent("UNIT_HEALTH", UpdateHealth)
		core.AddEvent("UNIT_MAXHEALTH", UpdateHealth)
		core.AddEvent("UNIT_ENTERED_VEHICLE", UpdateVehicle)
		core.AddEvent("UNIT_EXITED_VEHICLE", UpdateVehicle)
	end
	if hpdb.incheal then
		core.AddEvent("UNIT_HEAL_PREDICTION", UpdateHealth)
	elseif changed then
		core.RemoveEvent("UNIT_HEAL_PREDICTION", UpdateHealth)
	end
	if not layout.mpbar.hide or not layout.mptext.hide then
		core.AddEvent("UNIT_POWER", UpdatePower)
		core.AddEvent("UNIT_MAXPOWER", UpdatePower)
		core.AddEvent("UNIT_DISPLAYPOWER", UpdatePowerType)
	elseif changed then
		core.RemoveEvent("UNIT_POWER", UpdatePower)
		core.RemoveEvent("UNIT_MAXPOWER", UpdatePower)
		core.RemoveEvent("UNIT_DISPLAYPOWER", UpdatePowerType)
	end
	if bcount or dcount or acount then
		core.AddEvent("UNIT_AURA", UpdateRaidAura)
	elseif changed then
		core.RemoveEvent("UNIT_AURA", UpdateRaidAura)
	end
	if acount then
		core.AddEvent("READY_CHECK", UpdateReadyCheck)
		core.AddEvent("READY_CHECK_CONFIRM", UpdateReadyCheck)
		core.AddEvent("READY_CHECK_FINISHED", UpdateReadyCheckFinish)
	elseif changed then
		core.RemoveEvent("READY_CHECK", UpdateReadyCheck)
		core.RemoveEvent("READY_CHECK_CONFIRM", UpdateReadyCheck)
		core.RemoveEvent("READY_CHECK_FINISHED", UpdateReadyCheckFinish)
	end
	if not layout.raidicon.hide then
		core.AddEvent("RAID_TARGET_UPDATE", UpdateRaidTarget)
	elseif changed then
		core.RemoveEvent("RAID_TARGET_UPDATE", UpdateRaidTarget)
	end
	if not layout.voiceicon.hide then
		core.AddEvent("VOICE_START", VoiceStart)
		core.AddEvent("VOICE_STOP", VoiceStop)
	elseif changed then
		core.RemoveEvent("VOICE_START", VoiceStart)
		core.RemoveEvent("VOICE_STOP", VoiceStop)
	end
	
	for i = 1, 10, 1 do
		CreateRaidGroup(i)
	end
	if dbver > 1 then  -- user must be configuring, so apply new settings
		for index, gf in pairs(groups) do
			for i = 1, 40, 1 do
				local child = gf:GetAttribute("child"..i)
				if not child then break end
				local config = child:GetAttribute("initialConfigFunction")
				if config then config(child) end
				if child.unit and UnitExists(child.unit) then
					child.uname = nil
					UpdateUnit(child.unit, child)
				end
			end
		end
		UpdateRaid(UnitExists("raid1"), InCombatLockdown())
	end
end
core.AddInitFunction("raid", raidinit, UpdateRaid, UpdateGeneral, UpdateAggro, UpdateTarget)
