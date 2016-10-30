if not StufRaid then return end

-- Raid Role Group module base
local core = StufRaid
local a = CreateFrame("Frame", nil, core)
core.raidrole = a
local invehicle, vehicleowner = core.invehicle, core.vehicleowner
local aggroed = core.aggroed

local units = { }
a.units = units

-- layout settings made local
local layout, laytar, s40
local bordc, aggroc, targetc
local hpdb, mpdb, namedb, hptdb, mptdb
local hpbgcm, hpbarcm, mpbgcm, mpbarcm, namecm, hptcm, mptcm
local showcombaticon, charlimit
local bcount, dcount, acount, hidebuffs
local w, h, ooralpha, deadalpha = 0, 0, 1, 1
local t_hpdb, t_namedb, t_hptdb
local t_namecm, t_hptcm, t_hpbgcm, t_hpbarcm
local t_showraidicon, t_charlimit
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
			if UnitAffectingCombat(u) then
				uf.combaticon:Show()
			else
				uf.combaticon:Hide()
			end
		elseif tog == 0 then  -- check if connected
			if not UnitIsConnected(u) and UnitExists(u) then
				uf.hptexttext:SetText(core.offlinetext)
				uf.dced = true
			elseif uf.dced then
				UpdateHealth(vu, uf)
				uf.dced = nil
			end
		end
		
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
					uf.aggroed = true
					uf.targeted = nil
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
			if uf.targeted then  -- color border if it's your current target and doesn't have aggro
				uf.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
				uf.targeted = nil
			end
		end
	end
end

local GetPartyAssignment = GetPartyAssignment
local function UpdateRaid(inraid, incombat, hidearena)
	local haschild
	for u, uf in pairs(units) do
		units[u] = nil
	end
	if inraid and not hidearena then  -- update title visibility
		for i = 1, 40, 1 do
			local uf = a.group:GetAttribute("child"..i)
			if not uf then break end
			if uf:IsShown() then
				local u = uf:GetAttribute("unit")
				uf.unit = u
				units[u] = uf
				if i == 1 then
					haschild = true
					a.label:Show()
				end
			end
		end
	end
	-- update anchor visibility
	if haschild then
		a.label:Show()
	else
		a.label:Hide()
	end
	if haschild and not incombat and layout.showanchor then
		a:EnableMouse(true)
		a:SetBackdropColor(0, 0, 0, 0.4)
	elseif not incombat then
		a:EnableMouse(false)
		a:SetBackdropColor(0, 0, 0, 0)
	end
end

-- Health
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local UnitIsDeadOrGhost, UnitIsGhost = UnitIsDeadOrGhost, UnitIsGhost
function UpdateHealth(u, uf)
	uf = uf or units[vehicleowner[u] or u]
	if not uf then return end
	u = uf.activeunit or u
	if UnitIsDeadOrGhost(u) then
		uf.hptexttext:SetText((UnitIsGhost(u) and core.ghosttext) or core.deadtext)
		uf.hpbarbar:SetValue((hpdb.fulldead and 1) or 0.00001)
		uf.border:SetAlpha(deadalpha)
		uf.dead = true
	else
		local current, total = UnitHealth(u), UnitHealthMax(u)
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
				if incheal == 0 then
					uf.hpbar.incbar:Hide()
				else
					uf.hpbar.incbar:SetValue((incheal > 1 and 1) or (incheal < 0 and 0) or incheal)
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
local function UpdateRaidAura(u)
	local uf = units[vehicleowner[u] or u]
	if uf then
		UpdateAura(uf.activeunit, uf, bcount, dcount, acount, hidebuffs)
	end
end

local function UpdateVehicle(u)  -- update vehicle alerts
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

local function updatepet(uf, event, a1)
	if a1 == uf.unit then
		uf:UnregisterEvent("UNIT_PET")
		uf.uname = nil
		UpdateUnit(a1, uf)
	end
end

local roleicon = {
	MAINTANK = "|TInterface\\GroupFrame\\UI-Group-MainTankIcon:0:0:0:-1|t",
	MAINASSIST = "|TInterface\\GroupFrame\\UI-Group-MainAssistIcon:0:0:0:-1|t",
}
local UnitName, UnitClass = UnitName, UnitClass
UpdateUnit = function(u, uf)
	uf = uf or units[u]
	if not uf then return end
	
	local role
	local name = UnitName(u)
	if UnitInRaid(u) then
		if GetPartyAssignment("MAINTANK", u) then
			role = "MAINTANK"
		elseif GetPartyAssignment("MAINASSIST", u) then
			role = "MAINASSIST"
		end
	end
	if not role then return end

	local vu = invehicle[u] or u
	if uf.uname ~= name or uf.role ~= role or uf.activeunit ~= vu then
		if uf.activeunit ~= vu and vehicleowner[vu] then
			uf:RegisterEvent("UNIT_PET")
			uf:SetScript("OnEvent", updatepet)
		end
		uf.uname, uf.role, uf.activeunit = name, role, vu
		uf.class, uf.CLASS = UnitClass(u)
		uf.nametexttext:SetValue(name, u, charlimit, roleicon[uf.role] or "")
		uf.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
		UpdateHealth(vu, uf)
		UpdatePowerType(vu, uf)
		UpdateRaidAura(vu, uf)
		UpdateRaidTarget(vu, uf)
		if uf.aggroed and not aggroed[vu] then
			uf.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
			uf.aggroed = nil
		elseif not uf.aggroed and aggroed[vu] then
			uf.border:SetBackdropBorderColor(aggroc.r, aggroc.g, aggroc.b, aggroc.a)
			uf.aggroed = true
			uf.targeted = nil
		end
	end
end

local RunQueue
local RegisterUnitWatch, UnregisterUnitWatch, SecureButton_GetUnit = RegisterUnitWatch, UnregisterUnitWatch, SecureButton_GetUnit
local function HideTarget(t)
	if not t then return end
	UnregisterUnitWatch(t)
	t:Hide()
end
local function UpdateRoleTarget(t)
	if not t or not t:IsShown() or not t.nametexttext then return end
	local u = SecureButton_GetUnit(t)
	local name = UnitName(u)
	t.unit = u
	if not u or not name then return end
	if t.uname ~= name then
		t.uname = name
		t.class, t.CLASS = UnitClass(u)
		t.nametexttext:SetValue(name, nil, t_charlimit, "")
		t.nametexttext:SetTextColor(t_namecm(t, t_namedb, "fontcolor"))
		t.hptexttext:SetTextColor(t_hptcm(t, t_hptdb, "fontcolor"))
		t.hpbar.bg:SetVertexColor(t_hpbgcm(t, t_hpdb, "bgcolor", "bgalpha"))
		t.hpbarbar:SetVertexColor(t_hpbarcm(t, t_hpdb, "barcolor", "baralpha"))
	end
	if UnitIsDeadOrGhost(u) then
		t.hptexttext:SetText((UnitIsGhost(u) and core.ghosttext) or core.deadtext)
		t.hpbarbar:SetValue((t_hpdb.fulldead and 1) or 0.00001)
	elseif not UnitIsConnected(u) then
		t.hptexttext:SetText(core.offlinetext)
		t.hpbarbar:SetValue((t_hpdb.fulldead and 1) or 0.00001)
	else
		local current, total = UnitHealth(u), UnitHealthMax(u)
		local frac = (current == 0 and 0.00001) or (current >= total and 1) or (current / total)
		t.hpbarbar:SetValue(frac)
		t.hptexttext:SetValue(current, total, frac)
	end
	if t_showraidicon then
		local iconindex = GetRaidTargetIndex(u)
		if iconindex then
			SetRaidTargetIconTexture(t.raidicon.icon, iconindex)
			t.raidicon:Show()
		else
			t.raidicon:Hide()
		end
	end
	if UnitIsUnit("target", u) then
		if not t.targeted then
			t.border:SetBackdropBorderColor(targetc.r, targetc.g, targetc.b, targetc.a)
			t.targeted = true
		end
	elseif t.targeted then
		t.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
		t.targeted = nil
	end
end
local function RoleOnUpdate(uf, a1)
	uf.elapsed = (uf.elapsed or 0) + a1
	if uf.elapsed < 0.19 then return end
	uf.elapsed = 0
	
	uf.tog = not uf.tog
	UpdateRoleTarget((uf.tog and uf.target) or uf.targettarget)
end
local function CreateTargetUnit(uf, which, x, y)
	local t = uf[which]  -- create role target
	if not t then
		t = CreateFrame("Button", uf:GetName()..which, uf, "SecureActionButtonTemplate")
		t:SetAttribute("useparent-unit", true)
		t:SetAttribute("unitsuffix", which)
		t:SetAttribute("type1", "target")
		t:SetAttribute("*type1", "target")
		t:SetScript("OnShow", UpdateRoleTarget)
		t:Hide()
		RegisterUnitWatch(t)
		ClickCastFrames[t] = true
		uf[which] = t
	end
	t:SetWidth(laytar.w)
	t:SetHeight(laytar.h)
	t:SetPoint("TOPLEFT", uf, "TOPLEFT", x, y)
	core.CreateUnitBase(t, layout, a, laytar)
end
local function CreateTargets(uf)
	if InCombatLockdown() then  -- cannot be in combat to create or setup role targets
		core.combatqueue = core.combatqueue or { }
		core.combatqueue[uf] = true
		return core.AddEvent("PLAYER_REGEN_ENABLED", RunQueue)
	end
	if laytar.showt then
		CreateTargetUnit(uf, "target", laytar.tx, laytar.ty)
		if laytar.showtt then
			CreateTargetUnit(uf, "targettarget", laytar.ttx, laytar.tty)
		else
			HideTarget(uf.targettarget)
		end
	else
		HideTarget(uf.target)
		HideTarget(uf.targettarget)
	end
end
RunQueue = function()  -- in case targets weren't created during combat
	core.RemoveEvent("PLAYER_REGEN_ENABLED", RunQueue)
	for uf in pairs(core.combatqueue) do
		CreateTargets(uf)
		core.combatqueue[uf] = nil
	end
end

local function FastHealthOnUpdate(this)
	this.dofasthp = not this.dofasthp
	if not this.dofasthp then return end
	UpdateHealth(this.unit, this.uf)
end
local function CreateRaidRoleUnit(uf)
	if uf.dbver == dbver then return end  -- don't update frame if unnecessary
	uf.dbver = dbver
	core.CreateUnitBase(uf, layout, a, nil, FastHealthOnUpdate)
	core.CreateBar(uf, layout, "mpbar")
	core.CreateText(uf, layout, "mptext")
	core.CreateAura(uf, layout, "buff")
	core.CreateAura(uf, layout, "debuff")
	core.CreateAura(uf, layout, "alert")
	core.CreateIcon(uf, layout, "combaticon", "Interface\\CharacterFrame\\UI-StateIcon")

	if uf.unit then
		units[uf.unit] = uf
	end
	uf:SetScript("OnUpdate", laytar.showt and RoleOnUpdate or nil)
	CreateTargets(uf)
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
	CreateRaidRoleUnit(uf)
end
local function CreateRaidRoleGroup()
	local db = layout.group
	local f = a.group
	if not db or db.hide then
		if f then
			f:Hide()
		end
		if a.label then
			a.label:SetAlpha(0)
		end
		return
	end
	if not f then
		f = CreateFrame("Frame", "StufRaidRoleHeader", a, "SecureRaidGroupHeaderTemplate")
		f:SetAttribute("minWidth", w)
		f:SetAttribute("minHeight", h)
		f.initialConfigFunction = HeaderConfig
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
		a.label = a:CreateFontString(nil, "ARTWORK")
		a.label:Hide()
		
		a.group = f
	end
	f:SetAttribute("minWidth", w)
	f:SetAttribute("minHeight", h)
	core.SetupGroup(f, a.label, a, db, "MAINTANK,MAINASSIST", "ROLE", w, h)
end

local cm = core.colormethods

local raidroleinit
raidroleinit = function(db, dbc)
	layout, laytar = db.raidrole, db.raidroletarget
	if db.raidrole.group.hide then
		core.AddInitFunction("raidrole", raidroleinit)
		CreateRaidRoleGroup()
		a.wasdisabled = true
		return
	elseif a.wasdisabled then
		core.AddInitFunction("raidrole", raidroleinit, UpdateRaid, UpdateGeneral, UpdateAggro, UpdateTarget)
		a.wasdisabled = nil
	end
	
	-- cache global settings
	bordc, targetc, aggroc = db.bordc, db.targetc, db.aggroc
	ooralpha, deadalpha = db.ooralpha, db.deadalpha
	s40 = core.s40
	
	-- cache raid role layout settings
	w, h = layout.w, layout.h
	hpdb, mpdb = layout.hpbar, layout.mpbar
	namedb, hptdb, mptdb = layout.nametext, layout.hptext, layout.mptext
	hpbgcm, hpbarcm = cm[hpdb.bgcolormethod or "solid"], cm[hpdb.barcolormethod or "solid"]
	mpbgcm, mpbarcm = cm[mpdb.bgcolormethod or "solid"], cm[mpdb.barcolormethod or "solid"]
	namecm = cm[namedb.colormethod or "class"]
	hptcm, mptcm = cm[hptdb.colormethod or "solid"], cm[mptdb.colormethod or "solid"]
	charlimit = namedb.chars > 0 and namedb.chars or nil
	showcombaticon = not layout.combaticon.hide
	bcount = not layout.buff.hide and dbc.bshow ~= "hide" and (layout.buff.cols * layout.buff.rows)
	dcount = not layout.debuff.hide and dbc.dshow ~= "hide" and (layout.debuff.cols * layout.debuff.rows)
	acount = not layout.alert.hide and (layout.alert.cols * layout.alert.rows)
	hidebuffs = layout.debuff.hidebuff
	
	t_hpdb, t_namedb, t_hptdb = laytar.hpbar, laytar.nametext, laytar.hptext
	t_namecm, t_hptcm = cm[t_namedb.colormethod or "solid"], cm[t_hptdb.colormethod or "solid"]
	t_hpbgcm, t_hpbarcm = cm[t_hpdb.bgcolormethod or "reactiondark"], cm[t_hpdb.barcolormethod or "reaction"]
	t_charlimit = t_namedb.chars > 0 and t_namedb.chars or nil
	t_showraidicon = not laytar.raidicon.hide
	
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
	
	CreateRaidRoleGroup()
	if dbver > 1 then  -- user must be configuring, so apply new settings
		for i = 1, 40, 1 do
			local child = a.group:GetAttribute("child"..i)
			if not child then break end
			local config = child:GetAttribute("initialConfigFunction")
			if config then config(child) end
			if child.unit and UnitExists(child.unit) then
				child.uname = nil
				UpdateUnit(child.unit, child)
			end
		end
		UpdateRaid(UnitExists("raid1"), InCombatLockdown())
	end
end
core.AddInitFunction("raidrole", raidroleinit, UpdateRaid, UpdateGeneral, UpdateAggro, UpdateTarget)
