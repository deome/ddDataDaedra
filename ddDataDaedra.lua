--------------------------------------------------------------------------------------------------
-----------------------------------------   DataDaedra   -----------------------------------------
---------------------------   by Deome (@deome) - heydeome@gmail.com   ---------------------------
local									VERSION = "2.0"											--
--																								--
--																								--
---------------------------------------   Deome's License   --------------------------------------
--																								--
-- 		Copyright (c) 2014, 2015, 2016 D. Deome (@deome) - heydeome@gmail.com					--
--																								--
-- 		This software is provided 'as-is', without any express or implied						--
-- 		warranty. In no event will the author(s) be held liable for any damages					--
-- 		arising from the use of this software. This software, and the ideas, processes, 		--
--		functions, and all other intellectual property contained within may not be modified,	--
--		distributed, or used in any other works without the written permission of the			--
--		author.																					--
--																								--
--		Any use with permission of author must include the above license and copyright,			--
--		and any other license and copyright notices noted within this software.			 		--
--																								--
-------------------------------------   ZO Obligatory Spam   -------------------------------------
--																								--
-- 		"This Add-on is not created by, affiliated with or sponsored by ZeniMax 		  		--
--		Media Inc. or its affiliates. The Elder Scrolls® and related logos are registered 	 	--
--		trademarks of ZeniMax Media Inc. in the United States and/or other countries. 			--
--		All rights reserved."																	--
--																								--
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------
----------------------------------------   Libraries   -------------------------------------------
--------------------------------------------------------------------------------------------------

local LIB_LAM2 	= LibStub("LibAddonMenu-2.0")
local LIB_LOG	= LibStub("LibLogos")


--------------------------------------------------------------------------------------------------
----------------------------------------   Namespace   -------------------------------------------
--------------------------------------------------------------------------------------------------

ddDataDaedra = {
	["name"] 						= "ddDataDaedra",
	["version"]						= VERSION,
	["savedVarsVersion"] 			= 8,
	["dataCairn"] = {
		["lastScan"]				= {},
		["prices"]					= {},
		["codex"] = {
			["init"]				= function() end,
--			["cTradeGuild"] 		= {},
--			["cNotes1"] 			= {},
--			["cNotes2"] 			= {},
--			["cNotes3"] 			= {},
--			["cNotes4"] 			= {},
--			["cResetButton"] 		= {},
--			["cPanelHeader"] 		= {},
			["cNotify"] 			= {},
			["cDebug"] 				= {},
--			["cwAvgSalePrice"]		= {},
--			["cSaveSalePrice"]		= {},
--			["cTwilight"]			= {},
--			["cTwilightLogin"]		= {},
--			["cTwilightZone"]		= {},
--			["cTwilightSummon"] 	= {},
--			["cTooltipDetails"] 	= {},
--			["cTooltipFontHeader"] 	= {},
--			["cTooltipFontBody"] 	= {},
--			["cTooltipQuality"] 	= {},
--			["cTooltipSeen"] 		= {},
--			["cMatMiser"] 			= {},
		},
		["UI"] = {
		},
	},
	["mPanel"] 						= function() end,
	["mControls"] 					= function() end,
--	["mTooltips"] 					= function() end,
--	["mDataCore"] 					= function() end,
	["mGeneral"]					= function() end,	
	["KeybindMaiden"]				= function() end,
	["KeybindTaskmaster"]			= function() end,
	["KeybindResetPrices"]			= function() end,
	["KeybindEasyButton"]			= function() end,
	["AddStatsSlotMenu"]			= function() end,
	["GetKeyedItem"] 				= function() end,
	["IsKeyedItem"] 				= function() end,
	["PendListing"] 				= function() end,
	["SavePrice"] 					= function() end,
	["ChatLinkStatsToChat"] 		= function() end,
	["SlotControlStatsToChat"] 		= function() end,
	["SeenToStr"]	 				= function() end,
	["wAvgToStr"]	 				= function() end,
	["StackToStr"]	 				= function() end,
	["InscribeCraftSigilstone"]		= function() end,
	["InscribeItemSigilstone"]		= function() end,
	["InscribePopupSigilstone"]		= function() end,
	["AlchemySigil"]				= function() end,
	["ProvisionerSigil"]			= function() end,
	["EnchantingSigil"] 			= function() end,
	["CreationSigil"] 				= function() end,
	["ImprovementSigil"] 			= function() end,
	["InscribeItemSigilstone"]		= function() end,
	["SigilDesign"]					= function() end,
	["LinkStatsToChat"]				= function() end,
	["EasyButton"] 					= function() end,
	["TwilightMaiden"]				= function() end,
	["TwilightSummons"]				= function() end,
	["BindPortal"] 					= function() end,
	["DisplayMsg"]					= function() end,	
	["Hooks"]						= function() end,
	["liminalBridge"] 				= function() end,
	["onAddonLoaded"] 				= function() end,
}


--------------------------------------------------------------------------------------------------
----------------------------------------   Constants   -------------------------------------------
--------------------------------------------------------------------------------------------------

local DATACAIRN			= ddDataDaedra.dataCairn
local CODEX				= ddDataDaedra.dataCairn.codex
local PRICES			= ddDataDaedra.dataCairn.prices
local ADDON_NAME 		= ddDataDaedra.name
local SV_VERSION 		= ddDataDaedra.savedVarsVersion
local TASKMASTER		= nil
local fonts	= {
	"DataDaedraHeader",
	"DataDaedraBody",
	"ZoFontBookTabletTitle", 	
	"ZoFontBookTablet",
	"ZoFontBookScrollTitle", 
    "ZoFontBookScroll",
	"ZoFontBookNoteTitle", 
	"ZoFontBookNote",
	"ZoFontBookLetterTitle", 
	"ZoFontBookLetter",
	"ZoFontBookRubbingTitle", 
	"ZoFontBookRubbing",	
	"ZoFontBookSkinTitle", 
	"ZoFontBookSkin",
	"ZoFontBookPaperTitle",
    "ZoFontBookPaper",
	"ZoFontTooltipTitle",
	"ZoFontTooltipSubtitle",	
	"ZoFontHeader4", 
	"ZoFontHeader3", 
    "ZoFontHeader2", 
    "ZoFontHeader", 
	"ZoFontGameLargeBoldShadow",
	"ZoFontGameLargeBold",
	"ZoFontGameLarge",
	"ZoFontGameShadow",
	"ZoFontGameOutline",
	"ZoFontGameBold",
	"ZoFontGameMedium", 
	"ZoFontGame",
    "ZoFontGameSmall",
}
local GuildIndex = nil
local Category = nil
local FirstRequest = nil

local CompletionFunctions =
{
	[GUILD_HISTORY_GENERAL]			= {},
	[GUILD_HISTORY_BANK]			= {},
	[GUILD_HISTORY_STORE]			= {},
	[GUILD_HISTORY_COMBAT]			= {}, --unused
	[GUILD_HISTORY_ALLIANCE_WAR]	= {},
}

local Str_Item_Quality = { 
[ITEM_QUALITY_NORMAL] 					= SI_ITEMQUALITY1, 
[ITEM_QUALITY_MAGIC] 					= SI_ITEMQUALITY2, 
[ITEM_QUALITY_ARCANE] 					= SI_ITEMQUALITY3, 
[ITEM_QUALITY_ARTIFACT] 				= SI_ITEMQUALITY4, 
[ITEM_QUALITY_LEGENDARY] 				= SI_ITEMQUALITY5,
[ITEM_QUALITY_TRASH] 					= SI_ITEMQUALITY0,
}

local Str_Item_Trait = { 
[ITEM_TRAIT_TYPE_NONE] 					= SI_ITEMTRAITTYPE0, 
[ITEM_TRAIT_TYPE_WEAPON_POWERED] 		= SI_ITEMTRAITTYPE1, 
[ITEM_TRAIT_TYPE_WEAPON_CHARGED] 		= SI_ITEMTRAITTYPE2, 
[ITEM_TRAIT_TYPE_WEAPON_PRECISE] 		= SI_ITEMTRAITTYPE3, 
[ITEM_TRAIT_TYPE_WEAPON_INFUSED] 		= SI_ITEMTRAITTYPE4, 
[ITEM_TRAIT_TYPE_WEAPON_DEFENDING] 		= SI_ITEMTRAITTYPE5, 
[ITEM_TRAIT_TYPE_WEAPON_TRAINING] 		= SI_ITEMTRAITTYPE6, 
[ITEM_TRAIT_TYPE_WEAPON_SHARPENED] 		= SI_ITEMTRAITTYPE7, 
[ITEM_TRAIT_TYPE_WEAPON_WEIGHTED] 		= SI_ITEMTRAITTYPE8, 
[ITEM_TRAIT_TYPE_WEAPON_INTRICATE] 		= SI_ITEMTRAITTYPE9, 
[ITEM_TRAIT_TYPE_WEAPON_ORNATE] 		= SI_ITEMTRAITTYPE10, 
[ITEM_TRAIT_TYPE_ARMOR_STURDY] 			= SI_ITEMTRAITTYPE11, 
[ITEM_TRAIT_TYPE_ARMOR_IMPENETRABLE] 	= SI_ITEMTRAITTYPE12,
[ITEM_TRAIT_TYPE_ARMOR_REINFORCED] 		= SI_ITEMTRAITTYPE13, 
[ITEM_TRAIT_TYPE_ARMOR_WELL_FITTED] 	= SI_ITEMTRAITTYPE14, 
[ITEM_TRAIT_TYPE_ARMOR_TRAINING] 		= SI_ITEMTRAITTYPE15, 
[ITEM_TRAIT_TYPE_ARMOR_INFUSED] 		= SI_ITEMTRAITTYPE16, 
[ITEM_TRAIT_TYPE_ARMOR_EXPLORATION] 	= SI_ITEMTRAITTYPE17, 
[ITEM_TRAIT_TYPE_ARMOR_DIVINES] 		= SI_ITEMTRAITTYPE18, 
[ITEM_TRAIT_TYPE_ARMOR_ORNATE] 			= SI_ITEMTRAITTYPE19, 
[ITEM_TRAIT_TYPE_ARMOR_INTRICATE] 		= SI_ITEMTRAITTYPE20, 
[ITEM_TRAIT_TYPE_JEWELRY_HEALTHY] 		= SI_ITEMTRAITTYPE21, 
[ITEM_TRAIT_TYPE_JEWELRY_ARCANE] 		= SI_ITEMTRAITTYPE22, 
[ITEM_TRAIT_TYPE_JEWELRY_ROBUST] 		= SI_ITEMTRAITTYPE23, 
[ITEM_TRAIT_TYPE_JEWELRY_ORNATE] 		= SI_ITEMTRAITTYPE24,
[ITEM_TRAIT_TYPE_ARMOR_NIRNHONED]		= SI_ITEMTRAITTYPE25,
[ITEM_TRAIT_TYPE_WEAPON_NIRNHONED]		= SI_ITEMTRAITTYPE26,
}

--------------------------------------------------------------------------------------------------
-------------------------------   Modular Controls by @Deome   -----------------------------------
--																								--
--						 ----  For LibAddonMenu 2.0 by Seerah  ----								--
--				----   With gratitude and credit for this wonderful library   ----				--
--																								--
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
--			    -- Modular Controls allow even more customization for LAM2 --					--
--					        -- (which already offers so much!) --								--
--		  -- and make plugins, updates, and common settings simple for everyone --				--
--------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------
------------------------------------   LAM2 Panel Layout   ---------------------------------------
--------------------------------------------------------------------------------------------------

function ddDataDaedra:mControls()
	local CODEX = self.dataCairn.codex
	local menu = {																				
--		CODEX.cResetButton:init(),
--		CODEX.cTradeGuild:init(),
--		CODEX.cNotes1:init(),
--		CODEX.cTwilight:init(),
--		CODEX.cTwilightSummon:init(),
--		CODEX.cTwilightLogin:init(),
--		CODEX.cTwilightZone:init(),
--		self:mDataCore(),
--		self:mTooltips(),
		self:mGeneral(),
	}
	return menu
end

function ddDataDaedra:mGeneral()
	local CODEX = self.dataCairn.codex
	local menu = {
		type = "submenu",
		name = "General",
		controls = {
--			CODEX.cwAvgSalePrice:init(),
--			CODEX.cSaveSalePrice:init(),
			CODEX.cNotify:init(),
			CODEX.cDebug:init(),
--			CODEX.cLGHDebug:init(),
		},
	}
	return menu
end

function ddDataDaedra:mTooltips()
	local CODEX = self.dataCairn.codex
	local menu = {
		type = "submenu",
		name = "Tooltip Displays",
		controls = {
--			CODEX.cTooltipFontHeader:init(),
--			CODEX.cTooltipFontBody:init(),
--			CODEX.cMatMiser:init(),
		},
	}
	return menu
end

function ddDataDaedra:mDataCore()
	local CODEX = self.dataCairn.codex
	local menu = {
		type = "submenu",
		name = "Core Pricing Data",
		controls = {
--			CODEX.cNotes2:init(),
--			CODEX.cMaxSeen:init(),
--			CODEX.cNotes4:init(),
--			CODEX.cSetItem:init(),
--			CODEX.cTrait:init(),
--			CODEX.cQuality:init(),
--			CODEX.cLevel:init(),
--			CODEX.cEnchant:init(),
		},
	}
	return menu
end

function ddDataDaedra:mPanel()
	local Panel = {
		type = "panel",
		name = GetString(DD_TASKMASTER_NAME),
		displayName = GetString(DD_TASKMASTER_DISPLAYNAME),
		author = GetString(DD_TASKMASTER_AUTHOR),
		version = self.version,
		registerForRefresh = true,
		registerForDefaults = true,
	}
	return Panel
end


--------------------------------------------------------------------------------------------------	
----------------------------------   LAM2 Modular Controls   -------------------------------------	
--------------------------------------------------------------------------------------------------	

function CODEX:init()																					-- Initializes all controls so that they're fully set up and ready to use,
--	self.cNotes1:init()																					-- regardless of whether they're displayed or active.
--	self.cTwilight:init()
--	self.cTwilightLogin:init()
--	self.cTwilightZone:init()
--	self.cTwilightSummon:init()
--	self.cNotes2:init()
--	self.cResetButton:init()
--	self.cMaxSeen:init()
--	self.cNotes4:init()
--	self.cSetItem:init()
--	self.cTrait:init()
--	self.cQuality:init()
--	self.cLevel:init()
--	self.cEnchant:init()
--	self.cTooltipQuality:init()
--	self.cTradeGuild:init()
	self.cDebug:init()
	self.cNotify:init()
--	self.cSaveSalePrice:init()
--	self.cwAvgSalePrice:init()
--	self.cTooltipFontHeader:init()
--	self.cTooltipFontBody:init()
--	self.cMatMiser:init()
end

function CODEX.cNotify:init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_NOTIFICATIONS_NAME)
	self.tooltip = GetString(DD_TASKMASTER_NOTIFICATIONS_TIP)
	self.width = "full"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function CODEX.cDebug:init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_DEBUG_NAME)
	self.tooltip = GetString(DD_TASKMASTER_DEBUG_TIP)
	self.width = "full"

	self.default = false
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end



--------------------------------------------------------------------------------------------------
----------------------------------------   Key Bindings   ----------------------------------------
--------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------
----------------------------------------   UI Bindings   -----------------------------------------
--------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------
-----------------------------------------   Arcana   ---------------------------------------------
--------------------------------------------------------------------------------------------------

function ddDataDaedra:DisplayMsg(msgString, boolDebug)
	local CODEX	= self.dataCairn.codex
	local tDebug = CODEX.cDebug.getFunc()
	local tNotify = CODEX.cNotify.getFunc()											
	
	if tDebug and 
	boolDebug then
		zo_callLater(function() d(GetString(DD_DEBUG) .. msgString) end, 1000)

	elseif tNotify and
	not boolDebug then
		zo_callLater(function() d(GetString(DD_MONIKER) .. msgString) end, 1000)
	end
end

local function requestPage()
	local GuildId = GetGuildId(GuildIndex)
	
	local pageAvailable

	if (FirstRequest) then
		pageAvailable = RequestGuildHistoryCategoryNewest(GuildId, Category)
		ddDataDaedra:DisplayMsg("Requested first page in guild " .. GuildId .. " category " .. Category)
	else
		pageAvailable = RequestGuildHistoryCategoryOlder(GuildId, Category)
		ddDataDaedra:DisplayMsg("Requested next page in guild " .. GuildId .. " category " .. Category)
	end

	if (pageAvailable) then
		ddDataDaedra:DisplayMsg("Waiting for page in guild " .. GuildId .. " category " .. Category)
	else
		ddDataDaedra:DisplayMsg("Page is not available, advancing")
		
		for _, func in pairs(CompletionFunctions[Category]) do func(GuildId) end
		
		if (GuildIndex < GetNumGuilds()) then
			GuildIndex = GuildIndex + 1
			FirstRequest = true
			requestPage()
		else
			CompletionFunctions[Category] = {}
			
			for category, functions in pairs(CompletionFunctions) do
				if (#functions > 0) then
					GuildIndex = 1
					Category = category
					FirstRequest = true
					requestPage()
					return
				end
			end
			
			EVENT_MANAGER:UnregisterForEvent("LibGuildHistory", EVENT_GUILD_HISTORY_RESPONSE_RECEIVED)
			GuildIndex = nil
			Category = nil
		end	
	end
end

local function onGuildHistoryResponseReceived(eventCode, guildId, category)
	ddDataDaedra:DisplayMsg("History response received for guild " .. guildId .. " category " .. category)
	
	if (guildId == GetGuildId(GuildIndex) and category == Category) then
		if (FirstRequest) then
			FirstRequest = false
			requestPage()
		else
			zo_callLater(requestPage, 2000)
		end
	else
		ddDataDaedra:DisplayMsg("Warning: Another addon is interfering with LibGuildHistory")
	end
end

local function requestHistory(category, completionFunc)
	for _, func in pairs(CompletionFunctions[category]) do if (completionFunc == func) then return end end
	
	table.insert(CompletionFunctions[category], completionFunc)
	
	if (not GuildIndex) then
		EVENT_MANAGER:RegisterForEvent("ddGuildHistory", EVENT_GUILD_HISTORY_RESPONSE_RECEIVED, onGuildHistoryResponseReceived)
		GuildIndex = 1
		Category = category
		FirstRequest = true
		requestPage()
	end
end

local function parseItemLinkLevel(itemLink)
	if itemLink == nil then return nil end
	
	local vetRank = GetItemLinkRequiredVeteranRank(itemLink)
	local reqLevel = GetItemLinkRequiredLevel(itemLink)
	
	if not vetRank then 
		vetRank = 0 
	elseif not reqLevel then 
		reqLevel = 1 
	end
	
	if vetRank > 0 then
		return reqLevel, vetRank, zo_strformat(SI_ITEM_FORMAT_STR_LEVEL, reqLevel).." "..reqLevel, zo_strformat(SI_ITEM_FORMAT_STR_RANK, vetRank).." "..vetRank
	else
		return reqLevel, vetRank, zo_strformat(SI_ITEM_FORMAT_STR_LEVEL, reqLevel).." "..reqLevel, ""
	end
end

local function parseItemLinkQuality(itemLink)
	if not itemLink then return nil end
	local iQuality = GetItemLinkQuality(itemLink)
	
	return iQuality, zo_strformat(Str_Item_Quality[iQuality])
end

local function parseItemLinkSetItem(itemLink)
	if not itemLink then return nil end
	local iHasSet, setName = GetItemLinkSetInfo(itemLink)
	
	if not iHasSet then iHasSet = 0 else iHasSet = 1 end
	
	return iHasSet, zo_strformat(SI_ITEM_FORMAT_STR_SET_NAME, setName)
end

local function parseItemLinkTrait(itemLink)
	if not itemLink then return nil end
	local iTrait = select(1, GetItemLinkTraitInfo(itemLink))
	
	return iTrait, zo_strformat(Str_Item_Trait[iTrait])
end

local function parseItemLinkToTable(itemLink)
	if not itemLink then return nil end
	local ParsedItemLink = {}
	
	for val in string.gmatch(itemLink, "(%d-):") do
		if val ~= "" then
			table.insert(ParsedItemLink, val)
		else
			table.insert(ParsedItemLink, "item")
		end
	end
	
	return ParsedItemLink
end

local function parseLinkValue(itemLink, place)
	if not itemLink then return nil end
	local LinkTable = parseItemLinkToTable(itemLink)
	
	if (place <= 21 and place >= 1) then
		local val = tonumber(LinkTable[place])
		return val
	else
		return nil
	end
end

function ddDataDaedra:TwilightMaiden(guildId)
	NUMGUILDS				= GetNumGuilds()
	local DATACAIRN			= self.dataCairn
	local CODEX				= self.dataCairn.codex
	local PRICES			= self.dataCairn.prices
	local CatId 			= GUILD_HISTORY_STORE
	local GuildName 		= GetGuildName(guildId) or ""
	local StoreEvents		= GetNumGuildEvents(guildId, CatId)
	local NewSales			= 0
	
	if guildId > NUMGUILDS then
		self:DisplayMsg(GetString(DD_TWILIGHT_COMPLETE), false)
		return
		
	elseif not NUMGUILDS or 
	NUMGUILDS < 1 or
	not GuildName or
	GuildName == "" or
	type(GuildName) ~= "string" or
	not StoreEvents or
	StoreEvents < 1 then
		return
	end
	
	local LastScan = DATACAIRN.lastScan[GuildName] or 1
	
	for i = 1, StoreEvents, 1 do
		local EventType, SecsSinceEvent, Buyer, Seller, Quantity, ItemLink, Price, Tax = GetGuildEventInfo(guildId, CatId, i)
		local TimeStamp = GetTimeStamp() - SecsSinceEvent
		
		if EventType == GUILD_EVENT_ITEM_SOLD and 
		TimeStamp > LastScan and 
		ItemLink ~= "" then
			NewSales	= NewSales + 1
			Quantity 	= tonumber(Quantity)
			Price 		= tonumber(Price)
			
			local Quality		= parseItemLinkQuality(ItemLink)
			local SetItem 		= parseItemLinkSetItem(ItemLink)
			local Trait			= parseItemLinkTrait(ItemLink)
			local Level, VetRank = parseItemLinkLevel(ItemLink)
			local ItemId		= parseLinkValue(ItemLink, 3)
			local EnchtId		= parseLinkValue(ItemLink, 6)
			local Element		= (Price / Quantity) * Quantity
			local Tier1, Tier2, Tier3, Tier4, Tier5, Values

			Values = { 
				["Seen"] 		= 1,
				["RawValue"] 	= Element, 
				["Weight"] 		= Quantity, 
				["wAvg"] 		= LIB_LOG:RoundTo100s(LIB_LOG:WeightedAverage(Price, Quantity)),
				["PostPrice"]	= 0,
			}
				
			Tier5 	= { [EnchtId] 	= Values}
			Tier4 	= { [VetRank] 	= Tier5 }
			Tier3 	= { [Level] 	= Tier4 }
			Tier2 	= { [Quality] 	= Tier3 }
			Tier1	= { [Trait]	 	= Tier2 }
				
			if ItemId and (not PRICES) then
				table.insert(PRICES, ItemId, Tier1)
			
			elseif ItemId and (not PRICES[ItemId]) then
				table.insert(PRICES, ItemId, Tier1)

			elseif ItemId and PRICES[ItemId] then
				if not PRICES[ItemId][Trait] then
					table.insert(PRICES[ItemId], Trait, Tier2)
				
				elseif PRICES[ItemId][Trait] then
					if not PRICES[ItemId][Trait][Quality] then
						table.insert(PRICES[ItemId][Trait], Quality, Tier3)
			
					elseif PRICES[ItemId][Trait][Quality] then
						if not PRICES[ItemId][Trait][Quality][Level] then
							table.insert(PRICES[ItemId][Trait][Quality], Level, Tier4)
						
						elseif PRICES[ItemId][Trait][Quality][Level] then
							if not PRICES[ItemId][Trait][Quality][Level][VetRank] then
								table.insert(PRICES[ItemId][Trait][Quality][Level], VetRank, Tier5)
							
							elseif PRICES[ItemId][Trait][Quality][Level][VetRank] then	
								if not PRICES[ItemId][Trait][Quality][Level][VetRank][EnchtId] then
									table.insert(PRICES[ItemId][Trait][Quality][Level][VetRank], EnchtId, Values)
									
								elseif PRICES[ItemId][Trait][Quality][Level][VetRank][EnchtId] then
									local record = PRICES[ItemId][Trait][Quality][Level][VetRank][EnchtId]
									if record.Seen then 
										record.Seen 	= record.Seen + 1
										record.RawValue	= record.RawValue + Element
										record.Weight	= record.Weight + Quantity										
										record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
								
									else
										record.Seen 	= 1
										record.RawValue = Element
										record.Weight 	= Quantity
										record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
										record.PostPrice = 0
									end
								end
							end
						end
					end
				end
			end
		end
	end
	
	if NewSales > 0 then
		self:DisplayMsg(zo_strformat(GetString(DD_TWILIGHT_NEWSALES), ZO_CommaDelimitNumber(NewSales), ZO_CommaDelimitNumber(StoreEvents), GuildName), false)
	end

	DATACAIRN.lastScan[GuildName] = GetTimeStamp()
	
	if guildId == NUMGUILDS then
		self:DisplayMsg(GetString(DD_TWILIGHT_COMPLETE), false)
	end
end

function ddDataDaedra:TwilightSummons()
	NUMGUILDS = GetNumGuilds()
	
	for i = 1, NUMGUILDS, 1 do
		self:TwilightMaiden(i)
	end
end

function ddDataDaedra:hooks()
--	ZO_PreHook(TRADING_HOUSE, "PostPendingItem", function() self:SavePrice() end)
--	ZO_PreHook("ZO_InventorySlot_ShowContextMenu", function(rowControl) SlotControl = rowControl; self:SlotControlStatsToChat() end)
	
--	ZO_PreHookHandler(ItemTooltip, 	'OnUpdate',		function(tooltip) self:SigilDesign(tooltip) end)
--	ZO_PreHookHandler(ItemTooltip, 	'OnCleared',	function() TooltipControl = nil end)
--	ZO_PreHookHandler(PopupTooltip, 'OnUpdate',		function(tooltip) self:InscribePopupSigilstone(tooltip) end)
--	ZO_PreHookHandler(PopupTooltip,	'OnCleared',	function() PopupControl = nil end)
	
--	if self.dataCairn.codex.cMatMiser.getFunc() then
--		ZO_PreHookHandler(ZO_SmithingTopLevelCreationPanelResultTooltip, "OnUpdate", function(tooltip) self:CreationSigil(self, tooltip) end)
--		ZO_PreHookHandler(ZO_SmithingTopLevelCreationPanelResultTooltip, "OnCleared", function() ResultControl = nil end)
		
--		ZO_PreHookHandler(ZO_SmithingTopLevelImprovementPanelResultTooltip, "OnUpdate", function(tooltip) self:ImprovementSigil(self, tooltip) end)
--		ZO_PreHookHandler(ZO_SmithingTopLevelImprovementPanelResultTooltip, "OnCleared", function() ResultControl = nil end)
		
--		ZO_PreHookHandler(ZO_EnchantingTopLevelTooltip, "OnUpdate", function(tooltip) self:EnchantingSigil(self, tooltip) end)
--		ZO_PreHookHandler(ZO_EnchantingTopLevelTooltip, "OnCleared", function() ResultControl = nil end)
		
--		ZO_PreHookHandler(ZO_ProvisionerTopLevelTooltip, "OnUpdate", function(tooltip) self:ProvisionerSigil(self, tooltip) end)
--		ZO_PreHookHandler(ZO_ProvisionerTopLevelTooltip, "OnCleared", function() ResultControl = nil end)
		
--		ZO_PreHookHandler(ZO_AlchemyTopLevelTooltip, "OnUpdate", function(tooltip) self:AlchemySigil(self, tooltip) end)
--		ZO_PreHookHandler(ZO_AlchemyTopLevelTooltip, "OnCleared", function() ResultControl = nil end)
--	end
	
--	ZO_LinkHandler_OnLinkMouseUp = function(itemLink, button, control) self:ChatLinkStatsToChat(itemLink, button, control) end
--	LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_CLICKED_EVENT, function() self:InscribePopupSigilstone(self, PopupTooltip) end)	
--	SMITHING.improvementPanel.spinner:RegisterCallback("OnValueChanged", function(value) ResultControl = nil self:ImprovementSigil(self, ZO_SmithingTopLevelImprovementPanelResultTooltip) end)
--	PostFunc = TRADING_HOUSE.SetupPendingPost
--	TRADING_HOUSE.SetupPendingPost = function() self:PendListing() end
end

function ddDataDaedra:liminalBridge()
	self.dataCairn = ZO_SavedVars:NewAccountWide("ddDataCairn", SV_VERSION, nil, self.dataCairn, "Global")

	self.dataCairn.codex:init()
	TASKMASTER = LIB_LAM2:RegisterAddonPanel("ddCodex", self:mPanel())
	LIB_LAM2:RegisterOptionControls("ddCodex", self:mControls())
	
	self:hooks()
	
	self:DisplayMsg(GetString(DD_ONLOAD), false)
	
	self:TwilightSummons()
end

local function onAddonLoaded(eventCode, addonName)	
	if addonName == ADDON_NAME then
		ddDataDaedra:liminalBridge()
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
	end	
end


EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, onAddonLoaded)
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------