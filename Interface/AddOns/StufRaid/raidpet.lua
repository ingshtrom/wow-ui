if not StufRaid then return end

-- Raid Pet Group module base
local core = StufRaid
local a = CreateFrame("Frame", nil, core)
core.raidpet = a
local units = { }
a.units = units

-- layout settings made local
local bordc, targetc
local layout, s40, charlimit
local hpdb, namedb, hptdb
local hpbgcm, hpbarcm, namecm, hptcm
local w, h, deadalpha, ooralpha = 0, 0, 1, 1
local dbver = 0

-- globals made local
local pairs = pairs
local strsub = string.utf8sub or string.sub
local UnitExists, UnitIsUnit = UnitExists, UnitIsUnit


local tog
local UnitIsVisible, IsSpellInRange, UnitInRange = UnitIsVisible, IsSpellInRange, UnitInRange
local function UpdateGeneral()  -- update range and border fading
	tog = not tog
	if not tog then return end
	for u, uf in pairs(units) do
		if uf.dead then
			uf.border:SetAlpha(deadalpha)
		elseif not UnitIsVisible(u) or (s40 and IsSpellInRange(s40, u) ~= 1) or (not s40 and not UnitInRange(u)) then
			uf.border:SetAlpha(ooralpha)
		else
			uf.border:SetAlpha(1)
		end
	end
end
local function UpdateTarget(hastarget)
	if targetc.a < 0.05 then return end
	if hastarget then  -- set target border
		for u, uf in pairs(units) do
			if UnitIsUnit("target", u) then
				if not uf.targeted then
					uf.border:SetBackdropBorderColor(targetc.r, targetc.g, targetc.b, targetc.a)
					uf.targeted = true
				end
			elseif uf.targeted then
				uf.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
				uf.targeted = nil
			end
		end
	else  -- clear target border
		for u, uf in pairs(units) do
			if uf.targeted then
				uf.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
				uf.targeted = nil
			end
		end
	end
end
local function UpdateGroup(inraid, incombat, hidearena)
	if inraid and not hidearena then
		local child = a.group:GetAttribute("child1")
		if child and child:IsShown() then
			a.label:Show()
			if not incombat and layout.showanchor then
				a:EnableMouse(true)
				a:SetBackdropColor(0, 0, 0, 0.4)
			end
			for u, uf in pairs(units) do
				if not UnitExists(u) then
					units[u] = nil
				end
			end
		else
			a.label:Hide()
			if not incombat then
				a:EnableMouse(false)
				a:SetBackdropColor(0, 0, 0, 0)
			end
		end
	else
		a.label:Hide()
		for u, uf in pairs(units) do
			units[u] = nil
		end
		if not incombat then
			a:EnableMouse(false)
			a:SetBackdropColor(0, 0, 0, 0)
			if hidearena then
				a.group:Hide()
			elseif a.group:IsShown() and not a.group.db.hide then
				a.group:Show()
			end
		end
	end
end


-- Health
local UnitHealth, UnitHealthMax = UnitHealth, UnitHealthMax
local UnitIsDeadOrGhost = UnitIsDeadOrGhost
local function UpdateHealth(u, uf)
	uf = uf or units[u]
	if not uf then return end
	if UnitIsDeadOrGhost(u) then
		uf.hptexttext:SetText(core.deadtext)
		uf.hpbarbar:SetValue((hpdb.fulldead and 1) or 0.00001)
		uf.border:SetAlpha(deadalpha)
		uf.dead = true
	else
		local current, total = UnitHealth(u), UnitHealthMax(u)
		local frac = (current == 0 and 0.00001) or (current >= total and 1) or (current / total)
		uf.hpbarbar:SetValue(frac)
		uf.hptexttext:SetValue(current, total, frac)
		uf.dead = nil
	end
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
			local iconindex = GetRaidTargetIndex(u)
			if iconindex then
				SetRaidTargetIconTexture(uf.raidicon.icon, iconindex)
				uf.raidicon:Show()
			else
				uf.raidicon:Hide()
			end
		end
	end
end

local vehicleicon = "|TInterface\\GossipFrame\\BinderGossipIcon.blp:0:0:0:-1|t"
local gsub = string.gsub
local UnitName, UnitClass = UnitName, UnitClass
local invehicle = core.invehicle
local function UpdateUnit(u)
	local uf = units[u]
	if not uf then return end
	local owner = gsub(u, "pet", "")
	local name = UnitName(owner)

	uf.uname = name
	uf.class, uf.CLASS = UnitClass(owner)
	uf.nametexttext:SetValue(name, unit, charlimit, invehicle[owner] and vehicleicon or "")
	uf.nametexttext:SetTextColor(namecm(uf, layout.nametext, "fontcolor"))
	uf.border:SetBackdropBorderColor(bordc.r, bordc.g, bordc.b, bordc.a)
	uf.hpbar.bg:SetVertexColor(hpbgcm(uf, hpdb, "bgcolor", "bgalpha"))
	uf.hpbarbar:SetVertexColor(hpbarcm(uf, hpdb, "barcolor", "baralpha"))
	uf.hptexttext:SetTextColor(hptcm(uf, hptdb, "fontcolor"))
	UpdateHealth(u, uf)
	UpdateRaidTarget(u, uf)
end

local function UpdateVehicle(u)  -- update to reflect vehicle possession
	local num = strmatch(u, "raid(%d+)")
	if not num then return end
	
	local uf = units["raidpet"..num]
	if uf then
		local name = UnitName(u)
		uf.nametexttext:SetFormattedText("%s%s", invehicle[u] and vehicleicon or "", strsub(name, 1, charlimit))
	end
end

local function CreateRaidPetUnit(uf)
	if uf.dbver == dbver then return end
	
	core.CreateUnitBase(uf, layout, a)
	uf.dbver = dbver

	if uf.unit then
		units[uf.unit] = uf
	end
end

local function UpdateAttribute(this, name, value)
	if name ~= "unit" then return end
	if value then
		value = gsub(value, "petpet", "pet")
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
	UpdateGroup(UnitExists("raid1"), InCombatLockdown())
end
local function HeaderConfig(header, buttonName)
	local uf
	if type(buttonName) == "string" then
		uf = _G[buttonName]
	else
		return
	end
	uf:SetScript("OnAttributeChanged", UpdateAttribute)
	CreateRaidPetUnit(uf)
end

local function CreateRaidPetGroup()
	local f = a.group
	local db = layout.group
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
		f = CreateFrame("Frame", "StufRaidPetHeader", a, "SecureRaidPetHeaderTemplate")
		f:SetAttribute("minWidth", w)
		f:SetAttribute("minHeight", h)
		f.initialConfigFunction = HeaderConfig
		f:SetAttribute("initialConfigFunction", [===[ 
			local header = self:GetParent()
			self:SetWidth(header:GetAttribute("minWidth"))
			self:SetHeight(header:GetAttribute("minHeight"))
			self:SetAttribute("type1", "target")
			self:SetAttribute("*type1", "target")
			header:CallMethod("initialConfigFunction", self:GetName())
		]===])
		f:SetAttribute("template", "SecureUnitButtonTemplate")
		f:SetWidth(8)
		f:SetHeight(8)
		f.db = db
		a.label = f:CreateFontString(nil, "ARTWORK")
		a.label:Hide()
		
		a.group = f
	end
	f:SetAttribute("minWidth", w)
	f:SetAttribute("minHeight", h)
	core.SetupGroup(f, a.label, a, db, "1,2,3,4,5,6,7,8", "GROUP", w, h)
end

local cm = core.colormethods
local raidpetinit
raidpetinit = function(db)
	layout = db.raidpet
	if db.raidpet.group.hide then
		core.AddInitFunction("raidpet", raidpetinit)
		CreateRaidPetGroup()
		a.wasdisabled = true
		return
	elseif a.wasdisabled then
		core.AddInitFunction("raidpet", raidpetinit, UpdateGroup, UpdateGeneral, nil, UpdateTarget)
		a.wasdisabled = nil
	end
	
	-- cache global settings
	s40 = core.s40
	bordc, targetc = db.bordc, db.targetc
	
	-- cache raid layout settings
	w, h = layout.w, layout.h
	ooralpha, deadalpha = db.ooralpha, db.deadalpha
	namedb, hpdb, hptdb = layout.nametext, layout.hpbar, layout.hptext
	hpbgcm, hpbarcm = cm[hpdb.bgcolormethod or "solid"], cm[hpdb.barcolormethod or "solid"]
	namecm = cm[namedb.colormethod or "class"]
	hptcm = cm[hptdb.colormethod or "solid"]
	charlimit = namedb.chars > 0 and namedb.chars or nil
	
	if not a:IsMovable() then
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
	if not layout.raidicon.hide then
		core.AddEvent("RAID_TARGET_UPDATE", UpdateRaidTarget)
	elseif changed then
		core.RemoveEvent("RAID_TARGET_UPDATE", UpdateRaidTarget)
	end

	CreateRaidPetGroup()
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
		UpdateGroup(UnitExists("raid1"), InCombatLockdown())
	end
end
core.AddInitFunction("raidpet", raidpetinit, UpdateGroup, UpdateGeneral, nil, UpdateTarget)
