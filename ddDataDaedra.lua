--------------------------------------------------------------------------------------------------
-----------------------------------------   DataDaedra   -----------------------------------------
---------------------------   by Deome (@deome) - heydeome@gmail.com   ---------------------------
local									VERSION = "2.0.0"										--
--																								--
--																								--
---------------------------------------   Deome's License   --------------------------------------
--																								--
-- 		Copyright (c) 2014-2017 D. Deome (@deome) - heydeome@gmail.com							--
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
	["isScanning"]					= false,
	["dataCairn"] = {
		["lastScan"]				= {},
		["lastSale"]				= {},
		["numSales"]				= {},
		["prices"]					= {},
		["codex"] = {
			["init"]				= function() end,
			["cResetButton"] 		= {},
			["cPanelHeader"] 		= {},
			["cNotify"] 			= {},
			["cDebug"] 				= {},
			["cwAvgSalePrice"]		= {},
			["cSaveSalePrice"]		= {},
			["cInterval"]			= {},
			["cTooltipDetails"] 	= {},
			["cTooltipFontHeader"] 	= {},
			["cTooltipFontBody"] 	= {},
			["cTooltipQuality"] 	= {},
		},
		["UI"] = {
		},
	},
	["mPanel"] 						= function() end,
	["mControls"] 					= function() end,
	["chatLinkStatsToChat"] 		= function() end,
	["slotControlStatsToChat"] 		= function() end,
	["seenToStr"]	 				= function() end,
	["wAvgToStr"]	 				= function() end,
	["stackToStr"]	 				= function() end,
	["inscribeCraftSigilstone"]		= function() end,
	["inscribeItemSigilstone"]		= function() end,
	["inscribePopupSigilstone"]		= function() end,
	["alchemySigil"]				= function() end,
	["provisionerSigil"]			= function() end,
	["enchantingSigil"] 			= function() end,
	["creationSigil"] 				= function() end,
	["improvementSigil"] 			= function() end,
	["sigilDesign"]					= function() end,
	["linkStatsToChat"]				= function() end,
	["twilightMaiden"]				= function() end,
	["twilightSummons"]				= function() end,
	["displayMsg"]					= function() end,	
	["hooks"]						= function() end,
	["liminalBridge"] 				= function() end,
	["getKeyedItem"] 				= function() end,
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
local Sigil				= nil
local TooltipControl	= nil
local PopupControl 		= nil
local ResultControl		= nil
local SlotControl 		= nil
local craftingStation	= nil
local ACTIVE_SLOT		= nil
local NUMGUILDS			= GetNumGuilds()
local PostFunc 			= nil

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

local function getItemLinkFromSlotControl(slotControl)
	local InventorySlot, ItemLink
	
	if not slotControl.dataEntry then
		InventorySlot = slotControl
		return GetItemLink(InventorySlot.bagId, InventorySlot.slotIndex)

	elseif slotControl.dataEntry then
		InventorySlot = slotControl.dataEntry.data

		if InventorySlot.bagId and 
		InventorySlot.slotIndex then
			return GetItemLink(InventorySlot.bagId, InventorySlot.slotIndex)
		else
			return GetItemLink(InventorySlot.bag, InventorySlot.index)
		end
	else
		return ""
	end
end

local function pendListing()
	local twAvgSalePrice = ddDataDaedra.dataCairn.codex.cwAvgSalePrice.getFunc()
	local tSaveSalePrice = ddDataDaedra.dataCairn.codex.cSaveSalePrice.getFunc()
	PostFunc(TRADING_HOUSE)
	
	if TRADING_HOUSE.m_pendingItemSlot and 
	(twAvgSalePrice or tSaveSalePrice) then
		local ItemLink 		= GetItemLink(BAG_BACKPACK, TRADING_HOUSE.m_pendingItemSlot)
		local KeyedItem 	= getKeyedItem(ItemLink)
		local Stack 		= select(2, GetItemInfo(BAG_BACKPACK, TRADING_HOUSE.m_pendingItemSlot)) or 1
		
		if KeyedItem and
		(twAvgSalePrice or tSaveSalePrice) then
			if not KeyedItem.wAvg then KeyedItem.wAvg = 0 end
			if not KeyedItem.PostPrice then KeyedItem.PostPrice = 0 end
			
			if twAvgSalePrice and
			KeyedItem.wAvg ~= 0 then
				if tSaveSalePrice and
				KeyedItem.PostPrice ~= 0 and
				KeyedItem.PostPrice > KeyedItem.wAvg then
					TRADING_HOUSE:SetPendingPostPrice(LIB_LOG:Round(KeyedItem.PostPrice * Stack))
				else
					TRADING_HOUSE:SetPendingPostPrice(LIB_LOG:Round(KeyedItem.wAvg * Stack))
				end
			
			elseif tSaveSalePrice and
			KeyedItem.PostPrice ~= 0 then
				TRADING_HOUSE:SetPendingPostPrice(LIB_LOG:Round(KeyedItem.PostPrice * Stack))
			end
		end		
	end
end

local function savePrice()
	local CODEX				= ddDataDaedra.dataCairn.codex
	local tSaveSalePrice	= CODEX.cSaveSalePrice.getFunc()
	local itemLink 			= GetItemLink(BAG_BACKPACK, TRADING_HOUSE.m_pendingItemSlot)
	local Stack 			= select(2, GetItemInfo(BAG_BACKPACK, TRADING_HOUSE.m_pendingItemSlot))
	local KeyedItem			= getKeyedItem(itemLink)
	local PostPrice 		= LIB_LOG:Round(LIB_LOG:RoundTo100s(TRADING_HOUSE.m_invoiceSellPrice.sellPrice / Stack))
	
	if tSaveSalePrice then
		if KeyedItem then
			local wAvgPrice	= LIB_LOG:Round(LIB_LOG:RoundTo100s(KeyedItem.wAvg / Stack))
			
			if wAvgPrice ~= PostPrice then
				KeyedItem.PostPrice = PostPrice
			end
		else
			local PRICES		= ddDataDaedra.dataCairn.prices
			local ItemId		= parseLinkValue(itemLink, 3)
			local EnchtId		= parseLinkValue(itemLink, 6)
			local Trait			= parseItemLinkTrait(itemLink)
			local Level, VetRank = parseItemLinkLevel(itemLink)
			local Quality		= parseItemLinkQuality(itemLink)
			
			Values = { 
				["Seen"] 		= 0,
				["RawValue"] 	= 0, 
				["Weight"] 		= 0, 
				["wAvg"] 		= 0,
				["PostPrice"]	= PostPrice,
			}
			
			if PRICES[ItemId] then
				if PRICES[ItemId] then
					if PRICES[ItemId][Trait] then
						if PRICES[ItemId][Trait][Quality] then
							if PRICES[ItemId][Trait][Quality][Level] then
								if PRICES[ItemId][Trait][Quality][Level][VetRank] then
									if not PRICES[ItemId][Trait][Quality][Level][VetRank][EnchtId] then
										table.insert(PRICES[ItemId][Trait][Quality][Level][VetRank], EnchtId, Values)
									end

								end
							end
						end
					end
				end
			end
		end
	end
end

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
		CODEX.cNotify:init(),
		CODEX.cDebug:init(),	
--		CODEX.cResetButton:init(),
		CODEX.cInterval:init(),
		CODEX.cwAvgSalePrice:init(),		
		CODEX.cSaveSalePrice:init(),
		CODEX.cTooltipFontHeader:init(),
		CODEX.cTooltipFontBody:init(),		
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
	self.cInterval:init()																				-- regardless of whether they're displayed or active.
--	self.cResetButton:init()
--	self.cTooltipQuality:init()
	self.cDebug:init()
	self.cNotify:init()
	self.cSaveSalePrice:init()
	self.cwAvgSalePrice:init()
	self.cTooltipFontHeader:init()
	self.cTooltipFontBody:init()

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

function CODEX.cInterval:init()
	self.type = "slider"
	self.name = GetString(DD_TASKMASTER_INTERVAL_NAME)
	self.tooltip = GetString(DD_TASKMASTER_INTERVAL_TIP)
	self.width = "full"
	
	self.min = 1
	self.max = 10
	self.step = 1
	self.default = 3
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) EVENT_MANAGER:UnregisterForUpdate(ddDataDaedra.name) 
		self.value = value 
		EVENT_MANAGER:RegisterForUpdate(ddDataDaedra.name, (self.value * 60 * 1000), function() ddDataDaedra:twilightSummons() end) 
	end
	return self
end

function CODEX.cSaveSalePrice:init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_SAVE_SALE_PRICE_NAME)
	self.tooltip = GetString(DD_TASKMASTER_SAVE_SALE_PRICE_TIP)
	self.width = "full"
	
	self.default = false
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function CODEX.cwAvgSalePrice:init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_WAVG_SALE_PRICE_NAME)
	self.tooltip = GetString(DD_TASKMASTER_WAVG_SALE_PRICE_TIP)
	self.width = "full"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function CODEX.cTooltipFontHeader:init()
	self.type = "dropdown"
	self.name = GetString(DD_TASKMASTER_TOOLTIP_HEADER_FONT_NAME)
	self.tooltip = GetString(DD_TASKMASTER_TOOLTIP_HEADER_FONT_TIP)
	self.width = "full"
	
	self.choices = fonts
	self.default = fonts[1]
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function CODEX.cTooltipFontBody:init()
	self.type = "dropdown"
	self.name = GetString(DD_TASKMASTER_TOOLTIP_BODY_FONT_NAME)
	self.tooltip = GetString(DD_TASKMASTER_TOOLTIP_BODY_FONT_TIP)
	self.width = "full"
	
	self.choices = fonts
	self.default = fonts[2]
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

function ddDataDaedra:seenToStr(seen)
	local LowSeen		= 25
	local HighSeen		= 100
	local Str_SeenColor = "|cFF0000"

	if seen > LowSeen and 
	seen < HighSeen then
		Str_SeenColor = "|cFFFF00"
	elseif seen >= HighSeen then
		Str_SeenColor = "|c00FF00"
	end
	
	return zo_strformat(GetString(DD_TOOLTIP_STAT_SEEN), Str_SeenColor, ZO_CommaDelimitNumber(seen), zo_iconFormat("esoui/art/miscellaneous/search_icon.dds", 32, 32))
end

function ddDataDaedra:wAvgToStr(wAvg)
	return zo_strformat(GetString(DD_TOOLTIP_STAT_WAVG), ZO_CommaDelimitNumber(LIB_LOG:Round(wAvg)), zo_iconFormat("esoui/art/currency/currency_gold.dds", 18, 18))
end

function ddDataDaedra:stackToStr(wAvg, stack)
	return zo_strformat(GetString(DD_TOOLTIP_STAT_STACK), ZO_CommaDelimitNumber(LIB_LOG:Round(wAvg * stack)), zo_iconFormat("esoui/art/currency/currency_gold.dds", 18, 18), stack)
end

function ddDataDaedra:resizeSigil(tooltip, label)
	local DimDefault 	= 416
	local Pad1, Pad2	= tooltip:GetResizeToFitPadding()
	local labelWidth	= label:GetTextWidth()

	if (labelWidth + Pad1) > DimDefault then
		local NewDim = Pad1 + labelWidth
		tooltip:SetDimensionConstraints(NewDim, -1, NewDim, -1)
	else
		tooltip:SetDimensionConstraints(DimDefault, -1, DimDefault, -1)
	end
end

function ddDataDaedra:createItemSigil(tooltip, keyedItem, stack)
	if not tooltip.labelPool then
        tooltip.labelPool = ZO_ControlPool:New("ZO_TooltipLabel", tooltip, "Label")
    end
	if not stack or stack < 2 then stack = 1 end
	local FontHeader		= self.dataCairn.codex.cTooltipFontHeader.getFunc()
	local FontBody			= self.dataCairn.codex.cTooltipFontBody.getFunc()
	local SigilHeader 		= tooltip.labelPool:AcquireObject()
    local SigilLabel 		= tooltip.labelPool:AcquireObject()
	local BulletIcon		= zo_iconFormat(GetString(DD_ICON_BULLET), 12, 12)
	local Str_Buffer 		= " "..BulletIcon.." "
	local Str_Seen			= self:seenToStr(keyedItem.Seen)
	local Str_wAvg			= self:wAvgToStr(keyedItem.wAvg)
	local Str_Stack			= self:stackToStr(keyedItem.wAvg, stack)
	local Str_Sigil			= Str_Seen..Str_Buffer..Str_wAvg
	
	if stack > 1 then 
		Str_Sigil = Str_Sigil..Str_Buffer..Str_Stack 
	end

	tooltip:AddVerticalPadding(20)
	ZO_Tooltip_AddDivider(tooltip)

	tooltip:AddControl(SigilHeader)
	SigilHeader:SetAnchor(CENTER)
	SigilHeader:SetHorizontalAlignment(CENTER)
	SigilHeader:SetFont(FontHeader)
	SigilHeader:SetModifyTextType(MODIFY_TEXT_TYPE_NONE)
	SigilHeader:SetColor(ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB())
	SigilHeader:SetText(GetString(DD_TOOLTIP_HEADER))
	
	tooltip:AddControl(SigilLabel)
	SigilLabel:SetAnchor(CENTER)
	SigilLabel:SetHorizontalAlignment(CENTER)
	SigilLabel:SetFont(FontBody)
	SigilLabel:SetModifyTextType(MODIFY_TEXT_TYPE_NONE)	
	SigilLabel:SetColor(ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB())
	SigilLabel:SetText(Str_Sigil)
	self:resizeSigil(tooltip, SigilLabel)
end

function ddDataDaedra:createMiserSigil(tooltip, str_TotalCost)
	if not tooltip.labelPool then
        tooltip.labelPool = ZO_ControlPool:New("ZO_TooltipLabel", tooltip, "Label")
    end

	local FontHeader	= self.dataCairn.codex.cTooltipFontHeader.getFunc()
	local FontBody		= self.dataCairn.codex.cTooltipFontBody.getFunc()
	local MiserHeader 	= tooltip.labelPool:AcquireObject()
    local MiserLabel 	= tooltip.labelPool:AcquireObject()
	
	tooltip:AddVerticalPadding(20)
	
	tooltip:AddControl(MiserHeader)
	MiserHeader:SetAnchor(CENTER)
	MiserHeader:SetHorizontalAlignment(CENTER)
	MiserHeader:SetFont(FontHeader)
	MiserHeader:SetModifyTextType(MODIFY_TEXT_TYPE_NONE)
	MiserHeader:SetColor(ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB())
	MiserHeader:SetText(GetString(DD_TOOLTIP_CRAFTING_HEADER))

	tooltip:AddControl(MiserLabel)
	MiserLabel:SetAnchor(CENTER)
	MiserLabel:SetHorizontalAlignment(CENTER)
	MiserLabel:SetFont(FontBody)
	MiserLabel:SetModifyTextType(MODIFY_TEXT_TYPE_NONE)
	MiserLabel:SetColor(ZO_TOOLTIP_DEFAULT_COLOR:UnpackRGB())
	MiserLabel:SetText(str_TotalCost)
	self:resizeSigil(tooltip, MiserLabel)
end

function ddDataDaedra:inscribePopupSigilstone(tooltip)
	if tooltip == PopupControl then return end
	PopupControl = tooltip

	local ResultKeyedItem 	= getKeyedItem(PopupControl.lastLink)
	
	if ResultKeyedItem and
	ResultKeyedItem.wAvg and
	ResultKeyedItem.Seen and
	ResultKeyedItem.wAvg > 0 and
	ResultKeyedItem.Seen > 0 then
		self:createItemSigil(tooltip, ResultKeyedItem)
	end
end

function ddDataDaedra:inscribeItemSigilstone(tooltip, itemLink, stack)
	if not tooltip or 
	not itemLink or 
	itemLink == "" then 
		return 

	elseif not stack or
	stack < 2 then 
		stack = 1
	end

	local ResultKeyedItem = getKeyedItem(itemLink)
	
	if ResultKeyedItem and
	ResultKeyedItem.wAvg and
	ResultKeyedItem.Seen and
	ResultKeyedItem.wAvg > 0 and
	ResultKeyedItem.Seen > 0 then
		self:createItemSigil(tooltip, ResultKeyedItem, stack)
	end
end

function ddDataDaedra:inscribeCraftSigilstone(tooltip, resultLink, resultStack, str_TotalCost)
	if not tooltip then return end
	local ResultKeyedItem = getKeyedItem(resultLink)

	if not resultStack or 
	resultStack < 2 then 
		resultStack = 1 
	end
	
	if ResultKeyedItem and
	ResultKeyedItem.wAvg and
	ResultKeyedItem.Seen and
	ResultKeyedItem.wAvg > 0 and
	ResultKeyedItem.Seen > 0 then
		self:createItemSigil(tooltip, ResultKeyedItem, resultStack)
	end

	self:createMiserSigil(tooltip, str_TotalCost)
end

function ddDataDaedra:alchemySigil(self, tooltip)
	if not tooltip or
	tooltip == ResultControl then
		return
	end
	ResultControl = tooltip
	craftingStation = ALCHEMY
	
	local SolventBagId = craftingStation.solventSlot.bagId
	local SolventSlotIndex = craftingStation.solventSlot.slotIndex
	local SolventItemLink = GetItemLink(SolventBagId, SolventSlotIndex, LINK_STYLE_BRACKETS)
	local SolventIcon = zo_iconFormat(GetItemLinkInfo(SolventItemLink), 28, 28)
	local SolventKeyedItem = getKeyedItem(SolventItemLink)
	local SolventCost = 0
	
	if SolventKeyedItem and
	SolventKeyedItem.wAvg and
	SolventKeyedItem.wAvg > 0 then
		SolventCost = SolventKeyedItem.wAvg
	end
	
	local Reagent1BagId	= craftingStation.reagentSlots[1].bagId
	local Reagent1SlotIndex = craftingStation.reagentSlots[1].slotIndex
	local Reagent1ItemLink = GetItemLink(Reagent1BagId, Reagent1SlotIndex, LINK_STYLE_BRACKETS)
	local Reagent1Icon = zo_iconFormat(GetItemLinkInfo(Reagent1ItemLink), 28, 28)
	local Reagent1KeyedItem = getKeyedItem(Reagent1ItemLink)
	local Reagent1Cost = 0
	
	if Reagent1KeyedItem and
	Reagent1KeyedItem.wAvg and
	Reagent1KeyedItem.wAvg > 0 then
		Reagent1Cost = Reagent1KeyedItem.wAvg
	end
	
	local Reagent2BagId = craftingStation.reagentSlots[2].bagId
	local Reagent2SlotIndex = craftingStation.reagentSlots[2].slotIndex
	local Reagent2ItemLink = GetItemLink(Reagent2BagId, Reagent2SlotIndex, LINK_STYLE_BRACKETS)
	local Reagent2Icon = zo_iconFormat(GetItemLinkInfo(Reagent2ItemLink), 28, 28)
	local Reagent2KeyedItem = getKeyedItem(Reagent2ItemLink)
	local Reagent2Cost = 0
	
	if Reagent2KeyedItem and
	Reagent2KeyedItem.wAvg and
	Reagent2KeyedItem.wAvg > 0 then
		Reagent2Cost = Reagent2KeyedItem.wAvg
	end
	
	local Reagent3BagId = craftingStation.reagentSlots[3].bagId
	local Reagent3SlotIndex = craftingStation.reagentSlots[3].slotIndex
	local Reagent3ItemLink = GetItemLink(Reagent3BagId, Reagent3SlotIndex, LINK_STYLE_BRACKETS)
	local Reagent3Icon = zo_iconFormat(GetItemLinkInfo(Reagent3ItemLink), 28, 28)
	local Reagent3KeyedItem = getKeyedItem(Reagent3ItemLink)
	local Reagent3Cost = 0
	
	if Reagent3KeyedItem and
	Reagent3KeyedItem.wAvg and
	Reagent3KeyedItem.wAvg > 0 then
		Reagent3Cost = Reagent3KeyedItem.wAvg
	end	
	
	local PotionLink = GetAlchemyResultingItemLink(SolventBagId, SolventSlotIndex, Reagent1BagId, Reagent1SlotIndex, Reagent2BagId, Reagent2SlotIndex, Reagent3BagId, Reagent3SlotIndex, LINK_STYLE_BRACKETS)
	local PotionCount = select(3, GetAlchemyResultingItemInfo(SolventBagId, SolventSlotIndex, Reagent1BagId, Reagent1SlotIndex, Reagent2BagId, Reagent2SlotIndex, Reagent3BagId, Reagent3SlotIndex, LINK_STYLE_BRACKETS))
	local TotalCost = LIB_LOG:Round(SolventCost + Reagent1Cost + Reagent2Cost + Reagent3Cost)
	
	if TotalCost ~= 0 then
		local Str_TotalReagentCost = ""
		local Str_Buffer = " "
		local GoldIcon = zo_iconFormat(GetString(DD_ICON_GOLD), 20, 20)
		local PlusIcon = zo_iconFormat("esoui/art/progression/addpoints_up.dds", 32, 32)
		local EqualsIcon = zo_iconFormat("/esoui/art/progression/progression_tabicon_passive_inactive.dds", 32, 32)
		local Str_TotalCost = zo_strformat(GetString(DD_TOOLTIP_CRAFTING_WAVG), ZO_CommaDelimitNumber(TotalCost), GoldIcon)
		
		if SolventCost > 0 and
		Reagent1Cost > 0 then
			Str_TotalReagentCost = SolventIcon..Str_Buffer..PlusIcon..Str_Buffer..Reagent1Icon
		
			if Reagent2Cost > 0 then
				Str_TotalReagentCost = Str_TotalReagentCost..Str_Buffer..PlusIcon..Str_Buffer..Reagent2Icon
			end
			if Reagent3Cost > 0 then
				Str_TotalReagentCost = Str_TotalReagentCost..Str_Buffer..PlusIcon..Str_Buffer..Reagent3Icon
			end
			
			Str_TotalReagentCost = Str_TotalReagentCost..EqualsIcon..Str_Buffer..Str_TotalCost
		end
		
		self:inscribeCraftSigilstone(tooltip, PotionLink, PotionCount, Str_TotalReagentCost)
	end
end

function ddDataDaedra:provisionerSigil(self, tooltip)
	if not tooltip or
	tooltip == ResultControl then
		return
	end
	ResultControl = tooltip
	craftingStation = PROVISIONER
	
	local RecipeListIndex = craftingStation:GetSelectedRecipeListIndex()
	local RecipeIndex = craftingStation:GetSelectedRecipeIndex()
	local RecipeLink = GetRecipeResultItemLink(RecipeListIndex, RecipeIndex, LINK_STYLE_BRACKETS)
	local RecipeCount = select(3, GetRecipeResultItemInfo(RecipeListIndex, RecipeIndex))
	
	local MatIndex1 = craftingStation.ingredientRows[1].control.ingredientIndex
	local MatLink1, MatIcon1, MatKeyedItem1	
	local MatCost1 = 0

	if MatIndex1 then
		MatLink1 = GetRecipeIngredientItemLink(RecipeListIndex, RecipeIndex, MatIndex1, LINK_STYLE_BRACKETS)
		MatIcon1 = zo_iconFormat(select(2, GetRecipeIngredientItemInfo(RecipeListIndex, RecipeIndex, MatIndex1)), 28, 28)
		MatKeyedItem1 = getKeyedItem(MatLink1)
		MatCost1 = 0
				
		if MatKeyedItem1 and
		MatKeyedItem1.wAvg ~= 0 then
			MatCost1 = MatKeyedItem1.wAvg
		end
	end
		
	local MatIndex2 = craftingStation.ingredientRows[2].control.ingredientIndex
	local MatLink2, MatIcon2, MatKeyedItem2
	local MatCost2 = 0

	if MatIndex2 then
		MatLink2 = GetRecipeIngredientItemLink(RecipeListIndex, RecipeIndex, MatIndex2, LINK_STYLE_BRACKETS)
		MatIcon2 = zo_iconFormat(select(2, GetRecipeIngredientItemInfo(RecipeListIndex, RecipeIndex, MatIndex2)), 28, 28)
		MatKeyedItem2 = getKeyedItem(MatLink2)
		MatCost2 = 0
				
		if MatKeyedItem2 and
		MatKeyedItem2.wAvg ~= 0 then
			MatCost2 = MatKeyedItem2.wAvg
		end
	end
		
	local MatIndex3 = craftingStation.ingredientRows[3].control.ingredientIndex
	local MatLink3, MatIcon3, MatKeyedItem3	
	local MatCost3 = 0

	if MatIndex3 then
		MatLink3 = GetRecipeIngredientItemLink(RecipeListIndex, RecipeIndex, MatIndex3, LINK_STYLE_BRACKETS)
		MatIcon3 = zo_iconFormat(select(2, GetRecipeIngredientItemInfo(RecipeListIndex, RecipeIndex, MatIndex3)), 28, 28)
		MatKeyedItem3 = getKeyedItem(MatLink3)
		MatCost3 = 0
				
		if MatKeyedItem3 and
		MatKeyedItem3.wAvg ~= 0 then
			MatCost3 = MatKeyedItem3.wAvg
		end
	end
		
	local MatIndex4 = craftingStation.ingredientRows[4].control.ingredientIndex
	local MatLink4, MatIcon4, MatKeyedItem4	
	local MatCost4 = 0

	if MatIndex4 then
		MatLink4 = GetRecipeIngredientItemLink(RecipeListIndex, RecipeIndex, MatIndex4, LINK_STYLE_BRACKETS)
		MatIcon4 = zo_iconFormat(select(2, GetRecipeIngredientItemInfo(RecipeListIndex, RecipeIndex, MatIndex4)), 28, 28)
		MatKeyedItem4 = getKeyedItem(MatLink4)
		MatCost4 = 0
				
		if MatKeyedItem4 and
		MatKeyedItem4.wAvg ~= 0 then
			MatCost4 = MatKeyedItem4.wAvg
		end
	end
		
	local MatIndex5 = craftingStation.ingredientRows[5].control.ingredientIndex
	local MatLink5, MatIcon5, MatKeyedItem5	
	local MatCost5 = 0

	if MatIndex5 then
		MatLink5 = GetRecipeIngredientItemLink(RecipeListIndex, RecipeIndex, MatIndex5, LINK_STYLE_BRACKETS)
		MatIcon5 = zo_iconFormat(select(2, GetRecipeIngredientItemInfo(RecipeListIndex, RecipeIndex, MatIndex5)), 28, 28)
		MatKeyedItem5 = getKeyedItem(MatLink5)
		MatCost5 = 0
				
		if MatKeyedItem5 and
		MatKeyedItem5.wAvg ~= 0 then
			MatCost5 = MatKeyedItem5.wAvg
		end
	end
		
	local TotalCost = LIB_LOG:Round(MatCost1 + MatCost2 + MatCost3 + MatCost4 + MatCost5)
	
	if TotalCost ~= 0 then
		local Str_TotalIngredientCost = ""
		local Str_Buffer = " "
		local GoldIcon = zo_iconFormat("esoui/art/currency/currency_gold.dds", 20, 20)
		local PlusIcon = zo_iconFormat("esoui/art/progression/addpoints_up.dds", 32, 32)
		local EqualsIcon = zo_iconFormat("/esoui/art/progression/progression_tabicon_passive_inactive.dds", 32, 32)
		local Str_TotalCost = zo_strformat(GetString(DD_TOOLTIP_CRAFTING_WAVG), ZO_CommaDelimitNumber(TotalCost), GoldIcon)
		
		if MatCost1 > 0 then
			Str_TotalIngredientCost = MatIcon1
		end
		if MatCost2 > 0 then
			Str_TotalIngredientCost = Str_TotalIngredientCost..Str_Buffer..PlusIcon..Str_Buffer..MatIcon2
		end
		if MatCost3 > 0 then
			Str_TotalIngredientCost = Str_TotalIngredientCost..Str_Buffer..PlusIcon..Str_Buffer..MatIcon3
		end
		if MatCost4 > 0 then
			Str_TotalIngredientCost = Str_TotalIngredientCost..Str_Buffer..PlusIcon..Str_Buffer..MatIcon4
		end
		if MatCost5 > 0 then
			Str_TotalIngredientCost = Str_TotalIngredientCost..Str_Buffer..PlusIcon..Str_Buffer..MatIcon5
		end
		Str_TotalIngredientCost = Str_TotalIngredientCost..Str_Buffer..EqualsIcon..Str_Buffer..Str_TotalCost
		
		self:inscribeCraftSigilstone(tooltip, RecipeLink, RecipeCount, Str_TotalIngredientCost)
	end
end

function ddDataDaedra:enchantingSigil(self, tooltip)
	if not tooltip or
	tooltip == ResultControl then
		return
	end
	ResultControl = tooltip
	craftingStation = ENCHANTING
	
	local EnchantingResultItemLink = GetEnchantingResultingItemLink(craftingStation:GetAllCraftingBagAndSlots())
	
	local RunePotencySlot = ZO_EnchantingTopLevelRuneSlotContainerPotencyRune
	local RunePotencyItemLink = GetItemLink(craftingStation.runeSlots[1]:GetBagAndSlot())
	local RunePotencyKeyedItem = getKeyedItem(RunePotencyItemLink)
	local RunePotencyIcon = zo_iconFormat(GetItemInfo(craftingStation.runeSlots[3]:GetBagAndSlot()), 28, 28)
	local RunePotencyCost = 0
	local RunePotencyName = GetItemLinkEnchantingRuneName(RunePotencyItemLink)
	
	if RunePotencyKeyedItem and
	RunePotencyKeyedItem.wAvg ~= 0 then
		RunePotencyCost = RunePotencyKeyedItem.wAvg
	end

	local RuneEssenceSlot = ZO_EnchantingTopLevelRuneSlotContainerEssenceRune
	local RuneEssenceItemLink = GetItemLink(RuneEssenceSlot.bagId, RuneEssenceSlot.slotIndex)
	local RuneEssenceKeyedItem = getKeyedItem(RuneEssenceItemLink)
	local RuneEssenceIcon = zo_iconFormat(GetItemInfo(RuneEssenceSlot.bagId, RuneEssenceSlot.slotIndex), 28, 28)
	local RuneEssenceCost = 0
	local RuneEssenceName = GetItemLinkEnchantingRuneName(RuneEssenceItemLink)
	
	if RuneEssenceKeyedItem and
	RuneEssenceKeyedItem.wAvg ~= 0 then
		RuneEssenceCost = RuneEssenceKeyedItem.wAvg
	end
	
	local RuneAspectSlot = ZO_EnchantingTopLevelRuneSlotContainerAspectRune
	local RuneAspectItemLink = GetItemLink(RuneAspectSlot.bagId, RuneAspectSlot.slotIndex)
	local RuneAspectKeyedItem = getKeyedItem(RuneAspectItemLink)
	local RuneAspectIcon = zo_iconFormat(GetItemInfo(RuneAspectSlot.bagId, RuneAspectSlot.slotIndex), 28, 28)
	local RuneAspectCost = 0
	local RuneAspectName = GetItemLinkEnchantingRuneName(RuneAspectItemLink)	
	
	if RuneAspectKeyedItem and
	RuneAspectKeyedItem.wAvg ~= 0 then
		RuneAspectCost = RuneAspectKeyedItem.wAvg
	end
	
	local TotalCost = LIB_LOG:Round(RunePotencyCost + RuneEssenceCost + RuneAspectCost)

	if TotalCost ~= 0 then
		local Str_TotaGlyphCost = ""
		local Str_Buffer = " "
		local GoldIcon = zo_iconFormat("esoui/art/currency/currency_gold.dds", 20, 20)
		local PlusIcon = zo_iconFormat("esoui/art/progression/addpoints_up.dds", 32, 32)
		local EqualsIcon = zo_iconFormat("/esoui/art/progression/progression_tabicon_passive_inactive.dds", 32, 32)
		local Str_TotalCost = zo_strformat(GetString(DD_TOOLTIP_CRAFTING_WAVG), ZO_CommaDelimitNumber(TotalCost), GoldIcon)
		Str_TotaGlyphCost = RunePotencyIcon..Str_Buffer..PlusIcon..Str_Buffer..RuneEssenceIcon
		Str_TotaGlyphCost = Str_TotaGlyphCost..Str_Buffer..PlusIcon..Str_Buffer..RuneAspectIcon
		Str_TotaGlyphCost = Str_TotaGlyphCost..Str_Buffer..EqualsIcon..Str_Buffer..Str_TotalCost
		
		self:inscribeCraftSigilstone(tooltip, EnchantingResultItemLink, 1, Str_TotaGlyphCost)
	end
end

function ddDataDaedra:improvementSigil(self, tooltip)
	if not tooltip or
	tooltip == ResultControl then
		return
	end
	ResultControl = tooltip
	local Panel = SMITHING.improvementPanel
	
	local ImproveResultItemLink = GetSmithingImprovedItemLink(Panel:GetCurrentImprovementParams(), LINK_STYLE_BRACKETS)
	local BoosterLink = GetSmithingImprovementItemLink(GetCraftingInteractionType(), Panel.boosterSlot.index, LINK_STYLE_BRACKETS)

	local BoosterKeyedItem = getKeyedItem(BoosterLink)
	local BoosterCount = Panel.spinner.value
	local BoosterCost = 0
	
	if BoosterKeyedItem and
	BoosterKeyedItem.wAvg ~= 0 then
		BoosterCost = BoosterKeyedItem.wAvg * BoosterCount
	end

	local TotalCost = LIB_LOG:Round(BoosterCost)
	
	if TotalCost ~= 0 then
		local Str_TotalImprovementCost = ""
		local Str_Buffer = " "
		local GoldIcon = zo_iconFormat("esoui/art/currency/currency_gold.dds", 20, 20)
		local PlusIcon = zo_iconFormat("esoui/art/progression/addpoints_up.dds", 32, 32)
		local EqualsIcon = zo_iconFormat("/esoui/art/progression/progression_tabicon_passive_inactive.dds", 32, 32)
		local Str_TotalCost = zo_strformat(GetString(DD_TOOLTIP_CRAFTING_WAVG), ZO_CommaDelimitNumber(TotalCost), GoldIcon)
		local BoosterIcon = BoosterCount..zo_iconFormat(ZO_SmithingTopLevelImprovementPanelSlotContainerBoosterSlotIcon:GetTextureFileName(), 28, 28)		
		Str_TotalImprovementCost = BoosterIcon..Str_Buffer..EqualsIcon..Str_Buffer..Str_TotalCost
		
		ZO_SmithingTopLevelImprovementPanelResultTooltip:SetHidden(false)
		ZO_SmithingTopLevelImprovementPanelResultTooltip:ClearLines()
		Panel:SetupResultTooltip(Panel:GetCurrentImprovementParams())
		self:inscribeCraftSigilstone(tooltip, ImproveResultItemLink, 1, Str_TotalImprovementCost)
	end	
end

function ddDataDaedra:creationSigil(self, tooltip)
	if not tooltip or
	tooltip == ResultControl then
		return
	end
	ResultControl = tooltip
	
	local Panel = SMITHING.creationPanel
	local MatList = Panel.materialList.selectedData
	local MatCount = Panel.materialQuantitySpinner.value
	local StyleList = Panel.styleList.selectedData
	local TraitList = Panel.traitList.selectedData
	
		
	local MatItemLink = GetSmithingPatternMaterialItemLink(MatList.patternIndex, MatList.materialIndex, LINK_STYLE_BRACKETS)
	local MatKeyedItem = getKeyedItem(MatItemLink)
	local MatCost = 0
	
	if MatKeyedItem and
	MatKeyedItem.wAvg ~= 0 then
		MatCost = MatKeyedItem.wAvg * MatCount
	end
	
	local StyleItemLink = GetSmithingStyleItemLink(StyleList.styleIndex, LINK_STYLE_BRACKETS)
	local StyleKeyedItem = getKeyedItem(StyleItemLink)
	local StyleCost = 0
	
	if StyleKeyedItem and
	StyleKeyedItem.wAvg ~= 0 then
		StyleCost = StyleKeyedItem.wAvg
	end
	
	local TraitItemLink = GetSmithingTraitItemLink(TraitList.traitIndex, LINK_STYLE_BRACKETS)
	local TraitKeyedItem = getKeyedItem(TraitItemLink)
	local TraitCost = 0
	
	if TraitKeyedItem and
	TraitKeyedItem.wAvg ~= 0 then
		TraitCost = TraitKeyedItem.wAvg
	end
	
	local ResultItemLink = GetSmithingPatternResultLink(MatList.patternIndex, MatList.materialIndex, MatCount, StyleList.styleIndex, TraitList.traitIndex, LINK_STYLE_BRACKETS)	
	local TotalCost = LIB_LOG:Round(MatCost + StyleCost + TraitCost)
	
	if TotalCost ~= 0 then
		local Str_TotalSmithingCost = ""
		local Str_Buffer = " "
		local MatIcon = MatCount..zo_iconFormat(MatList.icon, 28, 28)
		local StyleIcon = zo_iconFormat(StyleList.icon, 28, 28)
		local TraitIcon = zo_iconFormat(TraitList.icon, 28, 28)
		local GoldIcon = zo_iconFormat("esoui/art/currency/currency_gold.dds", 20, 20)
		local PlusIcon = zo_iconFormat("esoui/art/progression/addpoints_up.dds", 32, 32)
		local EqualsIcon = zo_iconFormat("/esoui/art/progression/progression_tabicon_passive_inactive.dds", 32, 32)
		local Str_TotalCost = zo_strformat(GetString(DD_TOOLTIP_CRAFTING_WAVG), ZO_CommaDelimitNumber(TotalCost), GoldIcon)
		Str_TotalSmithingCost = MatIcon..Str_Buffer..PlusIcon..Str_Buffer..StyleIcon
		
		if TraitCost ~= 0 then
			Str_TotalSmithingCost = Str_TotalSmithingCost..Str_Buffer..PlusIcon..Str_Buffer..TraitIcon
		end
		
		Str_TotalSmithingCost = Str_TotalSmithingCost..Str_Buffer..EqualsIcon..Str_Buffer..Str_TotalCost
		
		self:inscribeCraftSigilstone(tooltip, ResultItemLink, 1, Str_TotalSmithingCost)
	end
end

function ddDataDaedra:sigilDesign(tooltip)
	local MoC = moc()
	local TH = TRADING_HOUSE
	
	if not tooltip or
	not MoC.dataEntry or 
	not MoC.dataEntry.data or
	tooltip == TooltipControl then 
		return
	end
	
	TooltipControl = tooltip
	local Row = MoC.dataEntry.data
	local Index = Row.slotIndex
	local Stack = Row.stackCount
	local ItemLink

	if not tooltip or 
	tooltip:GetOwningWindow():GetName() == "ZO_SmithingTopLevelCreationPanel" or
	tooltip:GetOwningWindow():GetName() == "ZO_ListDialog1" or
	tooltip:GetOwningWindow():GetName() == "ZO_InteractWindow" or		-- GetQuestRewardItemLink
	tooltip:GetOwningWindow():GetName() == "ZO_QuickSlotCircle" or																	
	tooltip:GetOwningWindow():GetName() == "ZO_StablePanel" then																		
		return
	end
	
	if Row then
		if Row.lootId then
			ItemLink = GetLootItemLink(Row.lootId)
			Stack = Row.count
			self:inscribeItemSigilstone(tooltip, ItemLink, Stack)
			return
		
		elseif Row.index then
			if Row.craftingType then
				ItemLink = GetSmithingImprovementItemLink(Row.craftingType, Row.index)
			elseif tooltip:GetOwningWindow():GetName() == "ZO_StoreWindow" then
				ItemLink = GetStoreItemLink(Row.index)
			elseif tooltip:GetOwningWindow():GetName() == "ZO_BuyBack" then
				ItemLink = GetBuybackItemLink(Row.index)
			elseif tooltip:GetOwningWindow():GetName() == "ZO_QuestReward" then
				ItemLink = GetQuestRewardItemLink(Row.index)
			end
			
			self:inscribeItemSigilstone(tooltip, ItemLink, 1)
			return
		
		elseif TRADING_HOUSE:IsAtTradingHouse() and 
		TH:IsInSearchMode() and
		Row.timeRemaining and 
		Row.timeRemaining > 0 then
			ItemLink = GetTradingHouseSearchResultItemLink(Row.slotIndex)
			self:inscribeItemSigilstone(tooltip, ItemLink, Stack)
			return

		elseif TRADING_HOUSE:IsAtTradingHouse() and
		Row.bagId then 
			ItemLink = GetItemLink(Row.bagId, Row.slotIndex)
			self:inscribeItemSigilstone(tooltip, ItemLink, Stack)
			return
			
		elseif TRADING_HOUSE:IsAtTradingHouse() and
		TH:IsInListingsMode() then
			ItemLink = GetTradingHouseListingItemLink(Row.slotIndex)
			self:inscribeItemSigilstone(tooltip, ItemLink, Stack)
			return
			
		elseif Row.bagId then 
			ItemLink = GetItemLink(Row.bagId, Row.slotIndex)
			
			if tooltip ~= ComparativeTooltip1 or ComparativeTooltip2 then								-- They inherit from ItemTooltip, so we have to rule them out specifically
				self:inscribeItemSigilstone(tooltip, ItemLink, Stack)
				return
			end

		else
			return
		end
	end
end


--------------------------------------------------------------------------------------------------
-----------------------------------------   Arcana   ---------------------------------------------
--------------------------------------------------------------------------------------------------

-- Copyright (c) 2014 Matthew Miller (Mattmillus)
--
-- Permission is hereby granted, free of charge, to any person
-- obtaining a copy of this software and associated documentation
-- files (the "Software"), to deal in the Software without
-- restriction, including without limitation the rights to use,
-- copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the
-- Software is furnished to do so, subject to the following
-- conditions:
--
-- The above copyright notice and this permission notice shall be
-- included in all copies or substantial portions of the Software.

function ddDataDaedra:linkStatsToChat(itemLink)
	if not itemLink or itemLink == "" then return end
	itemLink = string.gsub(itemLink, "|H0", "|H1")
	local KeyedItem = getKeyedItem(itemLink)
	local ChatEditControl = CHAT_SYSTEM.textEntry.editControl
	
	if not KeyedItem or
	not KeyedItem.wAvg or
	KeyedItem.wAvg == 0 or 
	not KeyedItem.Seen or
	KeyedItem.Seen == 0 then
		return
	end
	
	if not ChatEditControl:HasFocus() then 
		StartChatInput() 
	end
	
	ChatEditControl:InsertText(zo_strformat(GetString(DD_STATS_TO_CHAT), itemLink, KeyedItem.Seen, ZO_CommaDelimitNumber(LIB_LOG:Round(KeyedItem.wAvg))))
end

function ddDataDaedra:chatLinkStatsToChat(itemLink, button, control)
	if type(itemLink) == "string" and 
	#itemLink > 0 then
		local handled = LINK_HANDLER:FireCallbacks(LINK_HANDLER.LINK_MOUSE_UP_EVENT, itemLink, button, ZO_LinkHandler_ParseLink(itemLink))
		
		if not handled then
			ClearMenu()
			
			if (button == 1 and 
			ZO_PopupTooltip_SetLink) then
				ZO_PopupTooltip_SetLink(itemLink)
			
			elseif (button == 2 and 
			itemLink ~= "") then				
				if isKeyedItem(itemLink) then
					AddMenuItem(GetString(SI_ITEM_ACTION_DD_STATS_TO_CHAT), function() self:linkStatsToChat(itemLink) end) 
				end
				
				AddMenuItem(GetString(SI_ITEM_ACTION_LINK_TO_CHAT), function() ZO_LinkHandler_InsertLink(zo_strformat(SI_TOOLTIP_ITEM_NAME, itemLink)) end)
				ShowMenu(control)
			end
		end
	end
end

function ddDataDaedra:slotControlStatsToChat()
	if(SlotControl:GetOwningWindow() == ZO_TradingHouse) then return end
	if(ZO_PlayerInventoryBackpack:IsHidden() and 
	ZO_PlayerBankBackpack:IsHidden() and 
	ZO_GuildBankBackpack:IsHidden() and 
	ZO_SmithingTopLevelDeconstructionPanelInventoryBackpack:IsHidden() and 
	ZO_EnchantingTopLevelInventoryBackpack:IsHidden()) then 
		return 
	end
	
	if(SlotControl:GetParent() ~= ZO_Character) then
		SlotControl = SlotControl:GetParent()
	end
	
	local ItemLink = getItemLinkFromSlotControl(SlotControl)
	if isKeyedItem(ItemLink) then
		zo_callLater(function() AddMenuItem(GetString(SI_ITEM_ACTION_DD_STATS_TO_CHAT), function() ddDataDaedra:linkStatsToChat(ItemLink) end, MENU_ADD_OPTION_LABEL); ShowMenu(self) end, 50)
	end
end

---------------------------------------------------------------------------------------------------

function ddDataDaedra:getKeyedItem(itemLink)
	local codex			= ddDataDaedra.dataCairn.codex
	local PRICES		= ddDataDaedra.dataCairn.prices
	local ItemId		= parseLinkValue(itemLink, 3)
	local EnchtId		= parseLinkValue(itemLink, 6)
	local Trait			= parseItemLinkTrait(itemLink)
	local Level, VetRank = parseItemLinkLevel(itemLink)
	local Quality		= parseItemLinkQuality(itemLink)
	
	if PRICES[ItemId] then
		if PRICES[ItemId][Trait] then
			if PRICES[ItemId][Trait][Quality] then
				if PRICES[ItemId][Trait][Quality][Level] then
					if PRICES[ItemId][Trait][Quality][Level][VetRank] then
						if PRICES[ItemId][Trait][Quality][Level][VetRank][EnchtId] then
							return PRICES[ItemId][Trait][Quality][Level][VetRank][EnchtId]
						end
					end
				end
			end
		end
	end

	return nil
end

function ddDataDaedra:isKeyedItem(itemLink)
	local KeyedItem = self:getKeyedItem(itemLink)
	
	if not KeyedItem then 
		return false 
	else 
		return true 
	end
end

function ddDataDaedra:displayMsg(msgString, boolDebug)
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

function ddDataDaedra:twilightMaiden(guildId)
	local DATACAIRN			= self.dataCairn
	local CODEX				= self.dataCairn.codex
	local PRICES			= self.dataCairn.prices
	local numGuilds			= GetNumGuilds()
	local guildName 		= GetGuildName(guildId)
	local StoreEvents		= GetNumGuildEvents(guildId, GUILD_HISTORY_STORE)
	local NewSales			= 0
	
	if guildId > numGuilds then
		self:displayMsg(GetString(DD_TWILIGHT_COMPLETE), false)
		return
		
	elseif not numGuilds or 
	numGuilds < 1 or
	not guildName or
	guildName == "" or
	type(guildName) ~= "string" then
		return
	end
	
	local lastScan = DATACAIRN.lastScan[guildName] or 1
	local lastSale = DATACAIRN.lastSale[guildName] or 1
	
	for i = 1, StoreEvents, 1 do
		local EventType, secsSinceSale, Buyer, Seller, Quantity, itemLink, Price, Tax = GetGuildEventInfo(guildId, GUILD_HISTORY_STORE, i)
		local timeStamp = GetTimeStamp() - secsSinceSale

		if EventType == GUILD_EVENT_ITEM_SOLD and 
		timeStamp > lastScan and 
		itemLink ~= "" then
			if not lastSale or 
			timeStamp > lastSale then
				DATACAIRN.lastSale[guildName] = (timeStamp - secsSinceSale)
			end
			
			NewSales	= NewSales + 1
			Quantity 	= tonumber(Quantity)
			Price 		= tonumber(Price)
			
			local Quality		= parseItemLinkQuality(itemLink)
			local SetItem 		= parseItemLinkSetItem(itemLink)
			local Trait			= parseItemLinkTrait(itemLink)
			local Level, VetRank = parseItemLinkLevel(itemLink)
			local ItemId		= parseLinkValue(itemLink, 3)
			local EnchtId		= parseLinkValue(itemLink, 6)
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
--		self:displayMsg(zo_strformat(GetString(DD_TWILIGHT_NEWSALES), ZO_CommaDelimitNumber(NewSales), guildName), false)
	end

	DATACAIRN.lastScan[guildName] = GetTimeStamp()
end

function ddDataDaedra:twilightSummons()
	local DATACAIRN = self.dataCairn
	local scanInterval = self.dataCairn.codex.cInterval.getFunc()
	local numGuilds = GetNumGuilds()
	
	if self.historyScan then
		self:displayMsg("twilightSummons shut down due to historyScan", true)
		return

	elseif numGuilds >= 1 then
		for guildId = 1, numGuilds, 1 do
--			self:displayMsg("Starting Twilight Maiden for " .. GetGuildName(guildId), true)
			self:twilightMaiden(guildId)
		end
	end
	
	self:displayMsg(GetString(DD_TWILIGHT_COMPLETE), true)
end

function ddDataDaedra:checkHistory() 
	local DATACAIRN = self.dataCairn
	local numGuilds = GetNumGuilds()
	local scanInterval = self.dataCairn.codex.cInterval.getFunc()

	self.historyScan = true
	
	if numGuilds >= 1 then
		for guildId = 1, numGuilds, 1 do
			local guildName = GetGuildName(guildId)
			local numEvents = GetNumGuildEvents(guildId, GUILD_HISTORY_STORE)
			local lastScan = DATACAIRN.lastScan[guildName]

			RequestGuildHistoryCategoryNewest(guildId, GUILD_HISTORY_STORE)

			if numEvents > 0 then
				local secsSinceSale = select(2, GetGuildEventInfo(guildId, GUILD_HISTORY_STORE, numEvents))

				if DoesGuildHistoryCategoryHaveMoreEvents(guildId, GUILD_HISTORY_STORE) and
				(not lastScan or ((GetTimeStamp() - secsSinceSale) > lastScan)) then
					self:displayMsg("Requesting guild store history page for " .. guildName, true)
					RequestGuildHistoryCategoryOlder(guildId, GUILD_HISTORY_STORE)
					zo_callLater(function() self:checkHistory() end, scanInterval * 1000)
					return
				end
			end
		end
	end
	
	self.historyScan = false
--	self:displayMsg("Guild history scan complete.", true)
end


function ddDataDaedra:hooks()
	ZO_PreHook(TRADING_HOUSE, "PostPendingItem", function() savePrice() end)
	ZO_PreHook("ZO_InventorySlot_ShowContextMenu", function(rowControl) SlotControl = rowControl; self:slotControlStatsToChat() end)
	
	ZO_PreHookHandler(ItemTooltip, 	'OnUpdate',		function(tooltip) self:sigilDesign(tooltip) end)
	ZO_PreHookHandler(ItemTooltip, 	'OnCleared',	function() TooltipControl = nil end)
	ZO_PreHookHandler(PopupTooltip, 'OnUpdate',		function(tooltip) self:inscribePopupSigilstone(tooltip) end)
	ZO_PreHookHandler(PopupTooltip,	'OnCleared',	function() PopupControl = nil end)
	
	ZO_PreHookHandler(ZO_SmithingTopLevelCreationPanelResultTooltip, "OnUpdate", function(tooltip) self:creationSigil(self, tooltip) end)
	ZO_PreHookHandler(ZO_SmithingTopLevelCreationPanelResultTooltip, "OnCleared", function() ResultControl = nil end)
		
	ZO_PreHookHandler(ZO_SmithingTopLevelImprovementPanelResultTooltip, "OnUpdate", function(tooltip) self:improvementSigil(self, tooltip) end)
	ZO_PreHookHandler(ZO_SmithingTopLevelImprovementPanelResultTooltip, "OnCleared", function() ResultControl = nil end)
		
	ZO_PreHookHandler(ZO_EnchantingTopLevelTooltip, "OnUpdate", function(tooltip) self:enchantingSigil(self, tooltip) end)
	ZO_PreHookHandler(ZO_EnchantingTopLevelTooltip, "OnCleared", function() ResultControl = nil end)
		
	ZO_PreHookHandler(ZO_ProvisionerTopLevelTooltip, "OnUpdate", function(tooltip) self:provisionerSigil(self, tooltip) end)
	ZO_PreHookHandler(ZO_ProvisionerTopLevelTooltip, "OnCleared", function() ResultControl = nil end)
		
	ZO_PreHookHandler(ZO_AlchemyTopLevelTooltip, "OnUpdate", function(tooltip) self:alchemySigil(self, tooltip) end)
	ZO_PreHookHandler(ZO_AlchemyTopLevelTooltip, "OnCleared", function() ResultControl = nil end)

	
	ZO_LinkHandler_OnLinkMouseUp = function(itemLink, button, control) self:chatLinkStatsToChat(itemLink, button, control) end
	LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_CLICKED_EVENT, function() self:inscribePopupSigilstone(self, PopupTooltip) end)	
	SMITHING.improvementPanel.spinner:RegisterCallback("OnValueChanged", function(value) ResultControl = nil self:improvementSigil(self, ZO_SmithingTopLevelImprovementPanelResultTooltip) end)
	PostFunc = TRADING_HOUSE.SetupPendingPost
	TRADING_HOUSE.SetupPendingPost = function() pendListing() end
end

function ddDataDaedra:liminalBridge()
	self.dataCairn = ZO_SavedVars:NewAccountWide("ddDataCairn", SV_VERSION, nil, self.dataCairn, "Global")

	self.dataCairn.codex:init()
	TASKMASTER = LIB_LAM2:RegisterAddonPanel("ddCodex", self:mPanel())
	LIB_LAM2:RegisterOptionControls("ddCodex", self:mControls())
	
	local scanInterval = self.dataCairn.codex.cInterval.getFunc()
	
	self:hooks()
	
	self:displayMsg(GetString(DD_ONLOAD), false)
	self.historyScan = true
	zo_callLater(function() self:checkHistory() end, scanInterval * 1000)
	EVENT_MANAGER:RegisterForUpdate(self.name, (scanInterval * 60 * 1000), function() self:twilightSummons() end)
	EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
end

local function onAddonLoaded(eventCode, addonName)	
	if addonName == ADDON_NAME then
--		zo_callLater(function() 
		ddDataDaedra:liminalBridge()
--		end, 1000)
	else
		return
	end	
end


EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, onAddonLoaded)
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------