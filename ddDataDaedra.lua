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
			["cEasyButton"]			= {},
			["cTradeGuild"] 		= {},
			["cNotes1"] 			= {},
			["cNotes2"] 			= {},
			["cNotes3"] 			= {},
			["cNotes4"] 			= {},
			["cResetButton"] 		= {},
			["cPanelHeader"] 		= {},
			["cNotify"] 			= {},
			["cDebug"] 				= {},
			["cLGHDebug"] 			= {},
			["cMaxSeen"] 			= {},
			["cwAvgSalePrice"]		= {},
			["cSaveSalePrice"]		= {},
			["cTrait"] 				= {},
			["cSetItem"] 			= {},
			["cQuality"] 			= {},
			["cLevel"] 				= {},
			["cEnchant"]			= {},
			["cTwilight"]			= {},
			["cTwilightLogin"]		= {},
			["cTwilightZone"]		= {},
			["cTwilightSummon"] 	= {},
			["cTooltipDetails"] 	= {},
			["cTooltipFontHeader"] 	= {},
			["cTooltipFontBody"] 	= {},
			["cTooltipQuality"] 	= {},
			["cTooltipSeen"] 		= {},
			["cMatMiser"] 			= {},
		},
		["UI"] = {
		},
	},
	["mPanel"] 						= function() end,
	["mControls"] 					= function() end,
	["mTooltips"] 					= function() end,
	["mDataCore"] 					= function() end,
	["mMiscellany"]					= function() end,	
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
	["TwilightCallback"]			= function() end,
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
local ADDON_NAME 		= ddDataDaedra.name
local SV_VERSION 		= ddDataDaedra.savedVarsVersion
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

--------------------------------------------------------------------------------------------------
----------------------------------------   Key Bindings   ----------------------------------------
--------------------------------------------------------------------------------------------------

function ddDataDaedra:Commands(args)
	if #args < 1 or 
	#args > 1 then
       return
	
	elseif args[1] == "twilight" then
--		self.KeybindMaiden()
	
	elseif args[1] == "taskmaster" or 
	args[1] == "settings" then
--		self.KeybindTaskmaster()
	
	elseif args[1] == "reset" then
--		self.KeybindResetPrices()
    end
end


--------------------------------------------------------------------------------------------------
----------------------------------------   UI Bindings   -----------------------------------------
--------------------------------------------------------------------------------------------------

--------------------------------------------------------------------------------------------------
-----------------------------------------   Arcana   ---------------------------------------------
--------------------------------------------------------------------------------------------------

function ddDataDaedra:DisplayMsg(msgString, boolDebug)												
--	local tDebug = self.DataCairn.Codex.cDebug.getFunc()											
--	local tNotify = self.DataCairn.Codex.cNotify.getFunc()											
	
--	if tDebug and 
--	boolDebug then
--		d(GetString(DD_DEBUG) .. msgString)																	

--	elseif tNotify and
--	not boolDebug then
--		d(GetString(DD_MONIKER) .. msgString)
		zo_callLater(function() d(GetString(DD_MONIKER) .. msgString) end, 1000)
		
--	else
--		return
--	end
end

function ddDataDaedra:hooks()
--	ZO_PreHook(TRADING_HOUSE, "PostPendingItem", function() self:SavePrice() end)
--	ZO_PreHook("ZO_InventorySlot_ShowContextMenu", function(rowControl) SlotControl = rowControl; self:SlotControlStatsToChat() end)
	
--	ZO_PreHookHandler(ItemTooltip, 	'OnUpdate',		function(tooltip) self:SigilDesign(tooltip) end)
--	ZO_PreHookHandler(ItemTooltip, 	'OnCleared',	function() TooltipControl = nil end)
--	ZO_PreHookHandler(PopupTooltip, 'OnUpdate',		function(tooltip) self:InscribePopupSigilstone(tooltip) end)
--	ZO_PreHookHandler(PopupTooltip,	'OnCleared',	function() PopupControl = nil end)
	
--	if self.DataCairn.Codex.cMatMiser.getFunc() then
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

--	ddDataDaedra.dataCairn.Codex:Init()
--	TASKMASTER = LIB_LAM2:RegisterAddonPanel("ddCodex", ddDataDaedra:mPanel())
--	LIB_LAM2:RegisterOptionControls("ddCodex", ddDataDaedra:mControls())
	self:hooks()
	
	SLASH_COMMANDS["/dd"] = function(args) 
		local arguments = {}
		local searchResult = { string.match(args,"^(%S*)%s*(.-)$") }
		for i,v in pairs(searchResult) do
			if (v ~= nil and v ~= "") then
				arguments[i] = string.lower(v)
			end
		end
		
		self:commands(arguments)
	end
	
	self:DisplayMsg(GetString(DD_ONLOAD), false)
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