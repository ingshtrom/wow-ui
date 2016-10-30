
---------------------------------------------------------
-- Addon declaration
HandyNotes_CityGuide = LibStub("AceAddon-3.0"):NewAddon("HandyNotes_CityGuide","AceEvent-3.0")
local HC = HandyNotes_CityGuide
local HBD = LibStub("HereBeDragons-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("HandyNotes_CityGuide")


---------------------------------------------------------
-- Our db upvalue and db defaults
local CURRENT_DB_VERSION = 3   -- 2: added npcID; 3: Cata: added floors, index by npcID
local db
local defaults = {
	profile = {
		icon_scale = 1.0,
		icon_alpha = 1.0,
		worldmapfilter = { ["*"] = true },
		minimapfilter = { ["*"] = true },
	},
	factionrealm = {
		dbversion = 0,
		nodes = {
			["*"] = { }, 		-- mapname:mapfloor
		}
	},
	faction = {
		dbversion = 0,
		nodes = {
			["*"] = { }, 		-- mapname:mapfloor
		}
	},
}


---------------------------------------------------------
-- Localize some globals
local next = next
local select = select
local tonumber = tonumber
local string_find = string.find
local GameTooltip = GameTooltip
local WorldMapTooltip = WorldMapTooltip
local HandyNotes = HandyNotes


---------------------------------------------------------
-- Constants

local NPCTYPE_AUCTIONEER   = "A"
local NPCTYPE_BANKER       = "B"
local NPCTYPE_BATTLEMASTER = "W"
local NPCTYPE_STABLEMASTER = "S"

local OLDTYPE_SPIRITHEALER = "X" -- Removed (tracked by HandyNotes_Charon)

local OBJTYPE_MAILBOX      = "M" -- not yet implemented (tracked by HandyNotes_Mailboxes)
local OBJTYPE_GUILDBANK    = "G" -- not yet implemented
local OBJTYPE_BARBER       = "R" -- not yet implemented

local defkey = {}
local iconDB = {
	[NPCTYPE_AUCTIONEER]   = "Interface\\Minimap\\Tracking\\Auctioneer",
	[NPCTYPE_BANKER]       = "Interface\\Minimap\\Tracking\\Banker",
	[NPCTYPE_BATTLEMASTER] = "Interface\\Minimap\\Tracking\\BattleMaster",
	[NPCTYPE_STABLEMASTER] = "Interface\\Minimap\\Tracking\\StableMaster",

	[OLDTYPE_SPIRITHEALER] = "Interface\\Minimap\\Tracking\\TrivialQuests",  -- Removed (tracked by HandyNotes_Charon)

	[OBJTYPE_MAILBOX]      = "Interface\\Minimap\\Tracking\\Mailbox",   -- TODO: Mailbox (tracked by HandyNotes_Mailboxes)
	[OBJTYPE_GUILDBANK]    = "Interface\\Minimap\\Tracking\\Banker",    -- TODO: Guild Bank
	[OBJTYPE_BARBER]       = "Interface\\Minimap\\Tracking\\Banker",    -- TODO: Barber

	-- Default
	[defkey] = "Interface\\Minimap\\Tracking\\TrivialQuests", -- for DB errors??
		}

setmetatable(iconDB, {__index = function (t, k)
					local v = t[defkey]
					rawset(t, k, v) -- cache the value for next retrievals
					return v
				end})

local IgnoredNPCs = {
	-- Argent Squire (Alliance companion from Argent Tournament): http://www.wowhead.com/npc=33238, http://www.wowhead.com/item=44998
	[33238] = true, 
	-- Argent Gruntling (Horde companion from Argent Tournament): http://www.wowhead.com/npc=33239, http://www.wowhead.com/item=45022
	[33239] = true,

	-- Jeeves (Engineering companion): http://www.wowhead.com/npc=35642, http://www.wowhead.com/item=49040
	[35642] = true,

	-- Alliance Guild Page (Guild companion from "Horde Slayer"): http://www.wowhead.com/npc=49586, http://www.wowhead.com/item=65361
	[49586] = true,
	-- Alliance Guild Herald (Guild companion from "Profit Sharing"): http://www.wowhead.com/npc=49587, http://www.wowhead.com/item=65363
	[49587] = true,

	-- Horde Guild Page (Guild companion from "Horde Slayer"): http://www.wowhead.com/npc=49588, http://www.wowhead.com/item=65362
	[49588] = true,
	-- Horde Guild Herald (Guild companion from "Profit Sharing"): http://www.wowhead.com/npc=49590, http://www.wowhead.com/item=65364
	[49590] = true,
	}



-- because HandyNotes uses coords as their primary index for everything we have to translate it back to npcID

local coordsCache = {}  -- ["zone"] = { [coord] = "npcdata", },
--HandyNotes_CityGuide.cache = coordsCache --for debugging


---------------------------------------------------------
-- Plugin Handlers to HandyNotes

local HCHandler = {}

local function deletePin(button,  mapFloorId, vNpcid)
	local coord = strsplit(":", db.faction.nodes[mapFloorId][vNpcid])
	coord = tonumber(coord)

	db.faction.nodes[mapFloorId][vNpcid] = nil
	coordsCache[mapFloorId][coord] = nil

	HC:SendMessage("HandyNotes_NotifyUpdate", "CityGuide")
end
--[[
local function createWaypoint(button, mapFile, coord)
	local c, z = HandyNotes:GetCZ(mapFile)
	local x, y = HandyNotes:getXY(coord)
	local vType, vName, vGuild = strsplit(":", db.factionrealm.nodes[mapFile][coord])
	if TomTom then
		TomTom:AddZWaypoint(c, z, x*100, y*100, vName)
	elseif Cartographer_Waypoints then
		Cartographer_Waypoints:AddWaypoint(NotePoint:new(HandyNotes:GetCZToZone(c, z), x, y, vName))
	end
end
]]

local clickedNpcId, clickedZoneFloorId
local info = {}
local function generateMenu(button, level)
	if (not level) then return end
	for k in pairs(info) do info[k] = nil end
	if (level == 1) then
		-- Create the title of the menu
		--info.isTitle      = 1
		--info.text         = L["HandyNotes - CityGuide"]
		--info.notCheckable = 1
		--UIDropDownMenu_AddButton(info, level)

		local coord, vType, vName, vGuild = strsplit(":", db.faction.nodes[clickedZoneFloorId][clickedNpcId])
		local lGuild = ""
		if (vGuild ~= nil) and (vGuild ~= "") then
			lGuild = " <" .. vGuild .. ">"
		end

		info.disabled = false
		info.isTitle = true
		info.notCheckable = 1
		info.text = vName .. lGuild
		info.icon = iconDB[vType]
		UIDropDownMenu_AddButton(info, level)

--[[
--disabled until TomTom doesn't require Continent,Zone to index zones or someone finds translation function I don't have to implement
		if TomTom or Cartographer_Waypoints then
			-- Waypoint menu item
			info.disabled     = nil
			info.isTitle      = nil
			info.notCheckable = nil
			info.text = L["Create waypoint"]
			info.icon = nil
			info.func = createWaypoint
			info.arg1 = clickedZoneFloorId
			info.arg2 = clickedNpcId
			UIDropDownMenu_AddButton(info, level);
		end
]]
		-- Delete menu item
		info.disabled     = nil
		info.isTitle      = nil
		info.notCheckable = nil
		info.text = L["Delete note"]
		info.icon = nil
		info.func = deletePin
		info.arg1 = clickedZoneFloorId
		info.arg2 = clickedNpcId
		UIDropDownMenu_AddButton(info, level);

		-- Close menu item
		info.text         = L["Close"]
		info.icon         = nil
		info.func         = function() CloseDropDownMenus() end
		info.arg1         = nil
		info.arg2         = nil
		info.notCheckable = 1
		UIDropDownMenu_AddButton(info, level);
	end
end
local HC_Dropdown = CreateFrame("Frame", "HandyNotes_CityGuideDropdownMenu")
HC_Dropdown.displayMode = "MENU"
HC_Dropdown.initialize = generateMenu

function HCHandler:OnClick(button, down, mapFile, coord)
	if button == "RightButton" and not down then
		local floor = GetCurrentMapDungeonLevel() --we try to quess the floor number, as handynotes doesn't send it to us :(
		local mapFloorId = mapFile .. ":" .. floor


		if coordsCache[mapFloorId] == nil or coordsCache[mapFloorId][coord] == nil then 
			print("|cff6fafffHandyNotes_CityGuide:|r |cffff4f00Warning:|r Internal cache error - create")
			return
		end

		local vNpcid = coordsCache[mapFloorId][coord]
		if db.faction.nodes[mapFloorId][vNpcid] == nil then
			print("|cff6fafffHandyNotes_CityGuide:|r |cffff4f00Warning:|r Internal cache error - delete")
			return
		end

		clickedZoneFloorId = mapFloorId
		clickedNpcId = vNpcid
		
		ToggleDropDownMenu(1, nil, HC_Dropdown, self, 0, 0)
	end
end

function HCHandler:OnEnter(mapFile, coord)
	local floor = GetCurrentMapDungeonLevel() --we try to quess the floor number, as handynotes doesn't send it to us :(
	local mapFloorId = mapFile .. ":" .. floor

	if coordsCache[mapFloorId] == nil or coordsCache[mapFloorId][coord] == nil then 
		print("|cff6fafffHandyNotes_CityGuide:|r |cffff4f00Warning:|r Internal cache error - create")
		return
	end

	local vNpcid = coordsCache[mapFloorId][coord]
	if db.faction.nodes[mapFloorId][vNpcid] == nil then
		print("|cff6fafffHandyNotes_CityGuide:|r |cffff4f00Warning:|r Internal cache error - delete")
		return
	end

	local coord, vType, vName, vGuild = strsplit(":", db.faction.nodes[mapFloorId][vNpcid])


	local tooltip = self:GetParent() == WorldMapButton and WorldMapTooltip or GameTooltip
	if ( self:GetCenter() > UIParent:GetCenter() ) then -- compare X coordinate
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	tooltip:AddLine("|cffe0e0e0"..vName.."|r")
	if (vGuild ~= "") then tooltip:AddLine(vGuild) end
--	tooltip:AddLine(L["CityGuide"])
	tooltip:Show()
end

function HCHandler:OnLeave(mapFile, coord)
	if self:GetParent() == WorldMapButton then
		WorldMapTooltip:Hide()
	else
		GameTooltip:Hide()
	end
end

do
	local prevkey = nil

	-- This is a custom iterator we use to iterate over every node in a given zone
	local function worlditer(t, prevcoord)
		if not t then return nil end

		--local state, value = next(t, prestate)

		local value
		prevkey, value = next(t, prevkey)

		while prevkey do
			if value then
				local vCoord, vType, vName, vGuild = strsplit(":", value)
				if db.profile.worldmapfilter[vType] then
					local icon = iconDB[vType]
					vCoord = tonumber(vCoord)
					if vCoord then
						return vCoord, nil, icon, db.profile.icon_scale, db.profile.icon_alpha, nil
					end
				end
			end
			prevkey, value = next(t, prevkey)
		end
		return nil, nil, nil, nil, nil, nil
	end
	local function miniiter(t, prevcoord)
		if not t then return nil end

		local value
		prevkey, value = next(t, prevkey)

		while prevkey do
			if value then
				local vCoord, vType, vName, vGuild = strsplit(":", value)
				if db.profile.minimapfilter[vType] then
					local icon = iconDB[vType]
					vCoord = tonumber(vCoord)
					if vCoord then
						return vCoord, nil, icon, db.profile.icon_scale, db.profile.icon_alpha, nil
					end
				end
			end
			prevkey, value = next(t, prevkey)
		end
		return nil, nil, nil, nil, nil, nil
	end

	local function cacheCreate(nodes, mapFloorId)
		--if (coordsCache[mapFile] == nil) then coordsCache[mapFile] = {} end
		--if coordsCache[mapFile][dungeonLevel] ~= nil then return end --not empty = already filled in for this map
		if coordsCache[mapFloorId] ~= nil then return end --not empty = already filled in for this map

		local cacheTab = {}
		coordsCache[mapFloorId] = cacheTab

		for k, v in pairs(nodes) do
			local coord = strsplit(":", v)
			coord = tonumber(coord)
			if coord then cacheTab[coord] = k end
		end
	end

	function HCHandler:GetNodes(mapFile, minimap, dungeonLevel)
		local mapFloorId = mapFile .. ":" .. dungeonLevel
		cacheCreate(db.faction.nodes[mapFloorId], mapFloorId)
		prevkey = nil
		if minimap then
			--print("|cff6fafffHandyNotes_CityGuide:|r Sending nodes for minimap: "..mapFloorId.."...")
			return miniiter, db.faction.nodes[mapFloorId], nil
		else
			--print("|cff6fafffHandyNotes_CityGuide:|r Sending nodes for worldmap: "..mapFloorId.."...")
			return worlditer, db.faction.nodes[mapFloorId], nil
		end
	end

end


local function GetVFilters()
	local vnds = {
	[NPCTYPE_AUCTIONEER]   = L["TYPE_Auctioneer"],
	[NPCTYPE_BANKER]       = L["TYPE_Banker"],
	[NPCTYPE_BATTLEMASTER] = L["TYPE_BattleMaster"],
	[NPCTYPE_STABLEMASTER] = L["TYPE_StableMaster"],
--	[OLDTYPE_SPIRITHEALER] = L["TYPE_SpiritHealer"], -- Removed (tracked by HandyNotes_Charon)
		}

	local res = {}
	for id, text in pairs(vnds) do
		res[id] = "|T"..iconDB[id]..":18|t "..text
	end
	return res
end

---------------------------------------------------------
-- Options table

local options = {
	type = "group",
	name = "CityGuide",
	desc = "CityGuide",
	get = function(info) return db.profile[info.arg] end,
	set = function(info, v)
		db.profile[info.arg] = v
		HC:SendMessage("HandyNotes_NotifyUpdate", "CityGuide")
	end,
	args = {
		desc = {
			name = L["These settings control the look and feel of the CityGuide icons."],
			type = "description",
			order = 0,
		},
		icon_scale = {
			type = "range",
			name = L["Icon Scale"],
			desc = L["The scale of the icons"],
			min = 0.25, max = 2, step = 0.01,
			arg = "icon_scale",
			order = 10,
		},
		icon_alpha = {
			type = "range",
			name = L["Icon Alpha"],
			desc = L["The alpha transparency of the icons"],
			min = 0, max = 1, step = 0.01,
			arg = "icon_alpha",
			order = 20,
		},
		worldmapfilters = {
			type = "multiselect",
			name = L["World Map Filter"],
			desc = nil,
			order = 30,
			width = "full",
			get = function(info, k) return db.profile.worldmapfilter[k] end,
			set = function(info, k, v)
				db.profile.worldmapfilter[k] = v
				HC:SendMessage("HandyNotes_NotifyUpdate", "CityGuide")
			end,
			values = GetVFilters(),

		},
		minimapfilters = {
			type = "multiselect",
			name = L["Minimap Filter"],
			desc = nil,
			order = 40,
			width = "full",
			get = function(info, k) return db.profile.minimapfilter[k] end,
			set = function(info, k, v)
				db.profile.minimapfilter[k] = v
				HC:SendMessage("HandyNotes_NotifyUpdate", "CityGuide")
			end,
			values = GetVFilters(),

		},
	},
}


---------------------------------------------------------
-- NPC info tracking - TT handling

local tt = CreateFrame("GameTooltip")
tt:SetOwner(UIParent, "ANCHOR_NONE")
tt.left = {}
tt.right = {}

for i = 1, 30 do
	tt.left[i] = tt:CreateFontString()
	tt.left[i]:SetFontObject(GameFontNormal)
	tt.right[i] = tt:CreateFontString()
	tt.right[i]:SetFontObject(GameFontNormal)
	tt:AddFontStrings(tt.left[i], tt.right[i])
end


local LEVEL_start = "^" .. (type(LEVEL) == "string" and LEVEL or "Level")
local function FigureNPCGuild(unit)
	tt:ClearLines()
	tt:SetUnit(unit)
	if not tt:IsOwned(UIParent) then
		tt:SetOwner(UIParent, "ANCHOR_NONE")
	end
	local left_2 = tt.left[2]:GetText()
	if not left_2 or left_2:find(LEVEL_start) then
		return ""
	end
	return left_2
end

---------------------------------------------------------
-- Addon initialization, enabling and disabling

function HC:OnInitialize()
	-- Set up our database
	db = LibStub("AceDB-3.0"):New("HandyNotes_CityGuideDB", defaults)
	self.db = db

	if db.faction.dbversion > CURRENT_DB_VERSION then
		print("|cff6fafffHandyNotes_CityGuide:|r |cffff4f00Warning:|r Unknown database version. Please update to newer version.")
		print("|cff6fafffHandyNotes_CityGuide:|r |cffff4f00Warning:|r Addon has been disabled to protect your database.")
		self:Disable()
		return
	end

	if db.faction.dbversion ~= CURRENT_DB_VERSION then
		if db.faction.dbversion == 0 then
			-- addon was just installed
			db.faction.dbversion = CURRENT_DB_VERSION
		end

		if db.faction.dbversion < 3 then
			-- shouldn't happen
			db.faction.dbversion = 3 --first faction version
		end
	end

	if db.factionrealm.dbversion ~= CURRENT_DB_VERSION then
		if db.factionrealm.dbversion == 0 then
			-- addon was just installed
			db.factionrealm.dbversion = CURRENT_DB_VERSION
		end
	end

	if (db.factionrealm.dbversion > 0) and (db.factionrealm.dbversion < 3) then --move data from factionrealm to faction

		print("|cff6fafffHandyNotes_CityGuide:|r Upgrading databse...")
			
		local oldnodes = db.factionrealm.nodes
		local newnodes = db.faction.nodes
		for mapname, mapdata in pairs(oldnodes) do
			local mapId = HandyNotes:GetMapFiletoMapID(mapname)
			local floorcount = HBD:GetNumFloors(mapId)
			if floorcount == 0 then
				--print("|cff6fafffHandyNotes_CityGuide:|r Upgrading " .. mapname .. "...")
				local newmap = newnodes[mapname .. ":0"]
				for coord, vData in pairs(mapdata) do
					local vType, vName, vGuild, vNpcid = strsplit(":", vData)
					vNpcid = tonumber(vNpcid)
					if vNpcid and (vNpcid < 150000) and (vType ~= OLDTYPE_SPIRITHEALER) then -- remove NPCs without npcid or wrong npcids (current max ~ 50,000)
						local vInfo1 = coord .. ":" .. vType .. ":" .. vName .. ":" .. vGuild
						newmap[vNpcid] = vInfo1
					end
				end
			else
				if floorcount == nil then
					print("|cff6fafffHandyNotes_CityGuide:|r Skipped " .. mapname .. "... - removed map")
				else
					print("|cff6fafffHandyNotes_CityGuide:|r Skipped " .. mapname .. "... - cannot upgrade map with multiple floors")
				end
			end
		end
		db.factionrealm.nodes = {} -- remove old data
		db.factionrealm.dbversion = 3 -- converted to Cata data version
		print("|cff6fafffHandyNotes_CityGuide:|r Upgrade done.")
		
	end

	-- Initialize our database with HandyNotes
	HandyNotes:RegisterPluginDB("CityGuide", HCHandler, options)
end

function HC:OnEnable()
	self:RegisterEvent("PET_STABLE_SHOW")
	self:RegisterEvent("AUCTION_HOUSE_SHOW")
	self:RegisterEvent("BANKFRAME_OPENED")
	self:RegisterEvent("BATTLEFIELDS_SHOW")

--	self:RegisterEvent("CONFIRM_XP_LOSS")       -- Removed (tracked by HandyNotes_Charon)

--	self:RegisterEvent("MAIL_SHOW")             -- not yet implemented (tracked by HandyNotes_Mailboxes)
--	self:RegisterEvent("GUILDBANKFRAME_OPENED") -- not yet implemented
--	self:RegisterEvent("BARBER_SHOP_OPEN")      -- not yet implemented
end


local innkeepers = {}  -- table to store Innkeepers' npcids to not overwrite their icons

function HC:PET_STABLE_SHOW()
	self:AddNPCNote(NPCTYPE_STABLEMASTER)
end

function HC:AUCTION_HOUSE_SHOW()
	self:AddNPCNote(NPCTYPE_AUCTIONEER)
end

function HC:BANKFRAME_OPENED()
	self:AddNPCNote(NPCTYPE_BANKER )
end

function HC:BATTLEFIELDS_SHOW()
	self:AddNPCNote(NPCTYPE_BATTLEMASTER )
end

function HC:CONFIRM_XP_LOSS()                    -- Removed (tracked by HandyNotes_Charon)
--	self:AddNPCNote(OLDTYPE_SPIRITHEALER)
end

function HC:MAIL_SHOW()                          -- TODO
--	self:AddObjectNote(OBJTYPE_MAILBOX)
end

function HC:GUILDBANKFRAME_OPENED()              -- TODO
--	self:AddObjectNote(OBJTYPE_GUILDBANK)
end

function HC:BARBER_SHOP_OPEN()                   -- TODO
--	self:AddObjectNote(OBJTYPE_BARBER)
end



function HC:AddNPCNote(vType)
	if not UnitExists("npc") then
		-- fix for Call Stabled Pet and other cases, where NPC is not a real NPC (mailbox, barber, Guildbank)
		-- for pseudo-NPC use AddObjectNote(type, distance)
		return
	end

	local vName = UnitName("npc")
	local vGuild = FigureNPCGuild("npc")

	local vGuid = UnitGUID("npc")
	local type, zero, server_id, instance_id, zone_uid, npc_id, spawn_uid = strsplit("-", vGuid)
	local vNpcid = tonumber(npc_id, 16)

	self:AddCityGuideNote(vNpcid, vName, vGuild, vType)

end


local thres = 5 -- in yards
function HC:AddCityGuideNote(vNpcid, vName, vGuild, vType)

	if not vNpcid or IgnoredNPCs[vNpcid] then
		return -- this NPC is ignored
	end

	local x, y, mapID, floor = HBD:GetPlayerZonePosition()
	if not vName or not mapID then
		return
	end
	
--	local vInfo = vType .. ":" .. vName .. ":" .. vGuild .. ":" .. vNpcid

	local coord = HandyNotes:getCoord(x, y)
	local mapFile = HandyNotes:GetMapIDtoMapFile(mapID)
	if mapFile then
		local mapFloorId = mapFile .. ":" .. floor

		if coordsCache[mapFloorId] == nil then coordsCache[mapFloorId] = {} end

		if db.faction.nodes[mapFloorId][vNpcid] ~= nil then  -- If Already exists
			local vInfo = db.faction.nodes[mapFloorId][vNpcid]
			local ocoord = strsplit(":", vInfo)
			ocoord = tonumber(ocoord)
			if ocoord then
				local cx, cy = HandyNotes:getXY(ocoord)
				local dist = HBD:GetZoneDistance(mapID, floor, x, y, mapID, floor, cx, cy)
				if dist <= thres then 
					--return  -- update not required, bail out
					coord = ocoord -- do not move NPC
				else
					if coordsCache[mapFloorId][ocoord] == vNpcid then
						coordsCache[mapFloorId][ocoord] = nil  -- when npc is moved, old entry is removed
					end
				end
			else
				--create new one - old coords was not a number
			end
		end

		local vInfo3 = coord .. ":" .. vType .. ":" .. vName .. ":" .. vGuild

		db.faction.nodes[mapFloorId][vNpcid] = vInfo3

		coordsCache[mapFloorId][coord] = vNpcid

		self:SendMessage("HandyNotes_NotifyUpdate", "CityGuide")
	end
end
