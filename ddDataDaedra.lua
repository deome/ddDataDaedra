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

function ddDataDaedra:liminalBridge()
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
	zo_callLater(function() d("DataDaedra Loaded") end, 1000)
--	self:DisplayMsg(GetString(DD_ONLOAD), false)
end

local function onAddonLoaded(eventCode, addonName)	
	if addonName == ADDON_NAME then
		ddDataDaedra.dataCairn = ZO_SavedVars:NewAccountWide("ddDataCairn", SV_VERSION, nil, ddDataDaedra.dataCairn, "Global")
--		ddDataDaedra.dataCairn.Codex:Init()

--		TASKMASTER = LIB_LAM2:RegisterAddonPanel("ddCodex", ddDataDaedra:mPanel())
--		LIB_LAM2:RegisterOptionControls("ddCodex", ddDataDaedra:mControls())
		
--		ddDataDaedra:Hooks()
		ddDataDaedra:liminalBridge()
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
	end	
end


EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, onAddonLoaded)
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------