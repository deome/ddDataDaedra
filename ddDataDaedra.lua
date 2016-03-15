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
local CODEX				= ddDataDaedra.dataCairn.codex
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
	local codex = self.dataCairn.codex
	local menu = {																				
--		codex.cResetButton:init(),
--		codex.cTradeGuild:init(),
--		codex.cNotes1:init(),
--		codex.cTwilight:init(),
--		codex.cTwilightSummon:init(),
--		codex.cTwilightLogin:init(),
--		codex.cTwilightZone:init(),
		self:mDataCore(),
		self:mTooltips(),
		self:mMiscellany(),
	}
	return menu
end

function ddDataDaedra:mMiscellany()
	local codex = self.dataCairn.codex
	local menu = {
		type = "submenu",
		name = "Miscellany",
		controls = {
--			codex.cwAvgSalePrice:init(),
--			codex.cSaveSalePrice:init(),
			codex.cNotify:init(),
			codex.cDebug:init(),
--			codex.cLGHDebug:init(),
		},
	}
	return menu
end

function ddDataDaedra:mTooltips()
	local codex = self.dataCairn.codex
	local menu = {
		type = "submenu",
		name = "Tooltip Displays",
		controls = {
--			codex.cTooltipFontHeader:init(),
--			codex.cTooltipFontBody:init(),
--			codex.cMatMiser:init(),
		},
	}
	return menu
end

function ddDataDaedra:mDataCore()
	local codex = self.dataCairn.codex
	local menu = {
		type = "submenu",
		name = "Core Pricing Data",
		controls = {
--			codex.cNotes2:init(),
--			codex.cMaxSeen:init(),
--			codex.cNotes4:init(),
--			codex.cSetItem:init(),
--			codex.cTrait:init(),
--			codex.cQuality:init(),
--			codex.cLevel:init(),
--			codex.cEnchant:init(),
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

function CODEX:init()															-- Initializes all controls so that they're fully set up and ready to use,
--	self.cNotes1:init()																					-- regardless of whether they're displayed or active.
--	self.cTwilight:init()
--	self.cTwilightLogin:init()
--	self.cTwilightZone:init()
--	self.cTwilightSummon:init()
--	self.cEasyButton:init()
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
--	self.cLGHDebug:init()
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

function ddDataDaedra:requestHistory(category, completionFunc)
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
	
	SLASH_COMMANDS["/dd"] = function(args) 																-- adds "/dd" and arguments to chatbox commands.
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
	
--	self:requestHistory(GUILD_HISTORY_STORE)
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