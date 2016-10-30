local addonName, addon, _ = ...
_G[addonName] = addon

local showGlobalPriceChanges = true
local showPlayerPriceChanges = true

-- GLOBALS: _G, ITEM_QUALITY_COLORS, AUCTION_CREATOR, UNKNOWN, C_PetJournal, gAtrZC, gAtr_ScanDB, Atr_Col3_Heading, AUCTIONATOR_A_TIPS, ATR_BINDTYPE_UNKNOWN, ATR_CAN_BE_AUCTIONED, AUCTIONATOR_DB_MAXHIST_DAYS, AUCTIONATOR_PRICING_HISTORY
-- GLOBALS: GetItemInfo, Atr_FindScan, Atr_GetScanDay_Today, Atr_GetBondType, Atr_GetCurrentPane, Atr_GetAuctionBuyout, ParseHist, AtrReadBindText
-- GLOBALS: strjoin, type, table, wipe, pairs, select, tContains, time

--[[ 	BattlePets	 ]]--
-- prevent lua error when requesting binding information with invalid args
local orig_Atr_GetBondType = Atr_GetBondType
function Atr_GetBondType(itemID)
	if not itemID or type(itemID) ~= "number" then
		return ATR_BINDTYPE_UNKNOWN
	else
		return orig_Atr_GetBondType(itemID)
	end
end

-- allow price requests for battle pet links
local orig_Atr_GetAuctionBuyout = Atr_GetAuctionBuyout
function Atr_GetAuctionBuyout(item)
	if type(item) == "string" then
		local linkType, id = item:match("^.-H([^:]+):?([^:]*)")
		if linkType == "battlepet" then
			item = C_PetJournal.GetPetInfoBySpeciesID(id*1)
		end
	end
	return orig_Atr_GetAuctionBuyout(item)
end

-- item binding scanning fails on items with multiple extra lines
-- such as "heroic", "transmogrified", ...
local orig_AtrReadBindText = AtrReadBindText
function AtrReadBindText(itemID, txt)
	local binding = orig_AtrReadBindText(itemID, txt)
	local lineNum = 3
	while binding == ATR_BINDTYPE_UNKNOWN do
		local left = _G['AtrBindTypeToolTipTextLeft'..lineNum]
		if not left then break end
		binding = orig_AtrReadBindText(itemID, left:GetText())
		lineNum = lineNum + 1
	end
	return binding
end

--[[ 	Data Retrieval	 ]]--
function addon:GetAuctionState(itemLink)
	local itemName = GetItemInfo(itemLink)
	if not itemName then
		local speciesID = itemLink:match("battlepet:(%d+)")
		-- probably a battle pet, API works with number or string
		itemName = speciesID and C_PetJournal.GetPetInfoBySpeciesID(speciesID)
	end
	if not itemName then return end

	local auctionCount, referencePrice, isFreshData
	local data = Atr_FindScan(gAtrZC.RawItemIDfromLink(itemLink), itemName)

	-- referencePrice: price we discovered in our latest single item scan since logon
	if data and data.whenScanned ~= 0 then
		-- scanned this session
		referencePrice = data.yourWorstPrice
		auctionCount = data.numMatchesWithBuyout or 0
		isFreshData = true
	else
		-- no scan data this session, search in today's data
		data = gAtr_ScanDB[itemName]
		referencePrice = data and data.mr
		-- seen today but don't have any information on availablilty counts
		auctionCount = (referencePrice and not data.po) and -1 or 0
	end

	local previousPrice
	local today = Atr_GetScanDay_Today()
	for history = today-1, today - AUCTIONATOR_DB_MAXHIST_DAYS, -1 do
		previousPrice = data and (data["L"..history] or data["H"..history])
		if previousPrice then
			break
		end
	end

	return previousPrice, referencePrice, auctionCount, isFreshData
end

function addon:GetCompareValue(itemLink)
	local itemName = GetItemInfo(itemLink)
	if not itemName then
		local linkType, id = itemLink:match("^.-H([^:]+):?([^:]*)")
		if linkType == "battlepet" then
			itemName = C_PetJournal.GetPetInfoBySpeciesID(id*1)
		end
	end

	local history = AUCTIONATOR_PRICING_HISTORY[itemName]
	if history then
		local historyDate, playerPrice = 0, 0
		for tag, hist in pairs(history) do
			-- Auc throws error in ParseHist('is', hist), but data is available via regular tag
			if tag ~= "is" then
				local when, type, price, stacksize, numauctions = ParseHist(tag, hist)
				if when > historyDate then
					historyDate  = when
					playerPrice = price
				end
			end
		end
		return playerPrice > 0 and playerPrice or nil
	end
end

local up, down = " |TInterface\\BUTTONS\\Arrow-Up-%s:0|t", " |TInterface\\BUTTONS\\Arrow-Down-%s:0|t"
function addon:GetItemPriceInfo(itemLink)
	-- prevPrice = the price seen in previous scans
	local prevPrice, price, numAvailable, freshData = addon:GetAuctionState(itemLink)
	local itemPrice = price or Atr_GetAuctionBuyout(itemLink)
	if not itemPrice then return end

	local changeIndicator = ""
	if showGlobalPriceChanges then
		if prevPrice and itemPrice ~= prevPrice then
			changeIndicator = changeIndicator .. (itemPrice > prevPrice and up:format('Up') or down:format('Up'))
		end
	end

	if showPlayerPriceChanges then
		-- playerPrice: the price we asked for this item the last time
		local playerPrice = addon:GetCompareValue(itemLink)
		if playerPrice and itemPrice ~= playerPrice then
			changeIndicator = changeIndicator .. (itemPrice > playerPrice and up:format('Disabled') or down:format('Disabled'))
		end
	end

	-- highlight in red if scanned today and not available
	local priceText = ("%s|cFF%s%s|r"):format(changeIndicator,
		numAvailable == 0 and "FF0000" or "FFFFFF",
		itemPrice and gAtrZC.priceToMoneyString(itemPrice) or UNKNOWN)

	return priceText, changeIndicator ~= "" or numAvailable == 0
end

--[[ 	Data Display	 ]]--
function addon:SetToolipPriceInfo(tip, priceText)
	if not priceText or not tip then return end
	if tip.AddLine then
		-- GameTooltip widget, we're run right after Auc's line was added
		local aucPriceLine = tip:NumLines()
		_G[tip:GetName() .. "TextRight"..aucPriceLine]:SetText(priceText)
	else
		if not tip.value then
			tip.value = tip:CreateFontString(nil, "ARTWORK", "GameTooltipText")
		end
		tip.value:SetPoint("TOPRIGHT", tip.PetTypeTexture, "BOTTOMRIGHT", -4, -16)
		tip.value:SetText(priceText)
	end
end

hooksecurefunc("Atr_STWP_AddAuctionInfo", function(tip, xstring, link, auctionPrice)
	if AUCTIONATOR_A_TIPS ~= 1 then return end

	local itemID = link:match("item:(%d+)")
	local bondtype = itemID and Atr_GetBondType(itemID*1) or ATR_BINDTYPE_UNKNOWN

	if (bondtype == ATR_CAN_BE_AUCTIONED or bondtype == ATR_BINDTYPE_UNKNOWN) and xstring == "" then
		-- only apply to single item values (not stack prices)
		local priceText, hasData = addon:GetItemPriceInfo(link)
		if hasData then
			addon:SetToolipPriceInfo(tip, priceText)
		end
	end
end)

-- show pricing info for battle pets!
hooksecurefunc("BattlePetTooltipTemplate_SetBattlePet", function(tip, data)
	local link = ("%s\124Hbattlepet:%d:%d:%d:%d:%d:%d:%d\124h[%s]\124h\124r"):format(ITEM_QUALITY_COLORS[data.breedQuality].hex, data.speciesID, data.level, data.breedQuality, data.maxHealth, data.power, data.speed, data.name, data.name)

	local priceText = addon:GetItemPriceInfo(link)
	addon:SetToolipPriceInfo(tip, priceText)
end)

-- show auction owners
local owners = {}
hooksecurefunc(AtrScan, "CondenseAndSort", function(self)
	for i, sd in pairs(self.scanData) do
		wipe(owners)
		for k = 1, self.numMatches do
			local sorted = self.sortedData[k]
			if sd.owner and (not sorted.owner or not tContains(owners, sorted.owner))
				and sorted.stackSize == sd.stackSize and sorted.buyoutPrice == sd.buyoutPrice then
				table.insert(owners, sd.owner)
				table.sort(owners)
				sorted.owner = table.concat(owners, ', ')
			end
		end
	end
end)

local columnWidth = 140
local placeholder = "|T:1:%d|t"
hooksecurefunc("Atr_ShowCurrentAuctions", function()
	local scan = Atr_GetCurrentPane().activeScan
	if scan.whenScanned == 0 then return end
	local row, rowText, data, spacing, textWidth, lineText

	-- column header
	textWidth = Atr_Col3_Heading:GetStringWidth()
	spacing = textWidth < columnWidth and placeholder:format(columnWidth-textWidth) or ""
	Atr_Col3_Heading:SetText(strjoin("", Atr_Col3_Heading:GetText(), spacing, AUCTION_CREATOR))

	-- row data
	for i = 1, 12 do
		row = _G["AuctionatorEntry"..i]
		rowText = _G["AuctionatorEntry"..i.."_EntryText"]

		data = scan.sortedData[ row:GetID() ]
		if data and data.owner then
			textWidth = rowText:GetStringWidth()
			spacing = textWidth < columnWidth and placeholder:format(columnWidth-textWidth) or ""
			lineText = rowText:GetText()
			if lineText ~= "" then lineText = lineText .. " " end
			lineText = strjoin("", lineText, spacing, data.owner or "")

			rowText:SetText(lineText)
		end
	end
end)

hooksecurefunc('QueryAuctionItems', function(...)
	-- we only care about full scans
	if not select(10, ...) then return end
	for itemName, data in pairs (gAtr_ScanDB) do
		data.po = 1 -- just adding this as a marker so we know if this scan contains this item
	end
end)
