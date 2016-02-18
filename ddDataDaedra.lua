--------------------------------------------------------------------------------------------------
-----------------------------------------   DataDaedra   -----------------------------------------
---------------------------   by Deome (@deome) - heydeome@gmail.com   ---------------------------
local									VERSION = "1.77"										--
--																								--
--																								--
---------------------------------------   Deome's License   --------------------------------------
--																								--
-- 		Copyright (c) 2014, 2015 D. Deome (@deome) - heydeome@gmail.com							--
--																								--
-- 		This software is provided 'as-is', without any express or implied						--
-- 		warranty. In no event will the author(s) be held liable for any damages					--
-- 		arising from the use of this software. This software, and the ideas, processes, 		--
--		functions, and all other intellectual property contained within may not be modified,	--
--		distributed, or used in any other works without the written permission of the			--
--		author, except where otherwise noted and licensed within this software.					--
--																								--
--		Any use with permission of author must include the above license and copyright,			--
--		unless otherwise specified by the author.												--
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
local LIB_LGH	= LibStub("LibGuildHistory")
local LIB_RDR 	= LibStub("LibReader")
local LIB_LOG	= LibStub("LibLogos")


--------------------------------------------------------------------------------------------------
----------------------------------------   Namespace   -------------------------------------------
--------------------------------------------------------------------------------------------------

ddDataDaedra = {
	["Name"] 						= "ddDataDaedra",
	["Version"]						= VERSION,
	["SavedVarsVersion"] 			= 7,
	["DataCairn"] = {
		["LastScan"]				= {},
		["Prices"]					= {},
		["Codex"] = {
			["Init"]				= function() end,
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
	["LiminalBridge"] 				= function() end,
	["Boot"] 						= function() end,
}


--------------------------------------------------------------------------------------------------
----------------------------------------   Constants   -------------------------------------------
--------------------------------------------------------------------------------------------------

local DataCairn			= ddDataDaedra.DataCairn
local Codex				= ddDataDaedra.DataCairn.Codex
local UI				= ddDataDaedra.DataCairn.UI
local ADDON_NAME 		= ddDataDaedra.Name
local SV_VERSION 		= ddDataDaedra.SavedVarsVersion
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
	local Codex = self.DataCairn.Codex
	local Menu = {																				
		Codex.cResetButton:Init(),
		Codex.cTradeGuild:Init(),
		Codex.cNotes1:Init(),
		Codex.cTwilight:Init(),
		Codex.cTwilightSummon:Init(),
		Codex.cTwilightLogin:Init(),
		Codex.cTwilightZone:Init(),
		self:mDataCore(),
		self:mTooltips(),
		self:mMiscellany(),
	}
	return Menu
end

function ddDataDaedra:mMiscellany()
	local Codex = self.DataCairn.Codex
	local Menu = {
		type = "submenu",
		name = "Miscellany",
		controls = {
			Codex.cwAvgSalePrice:Init(),
			Codex.cSaveSalePrice:Init(),
			Codex.cNotify:Init(),
			Codex.cDebug:Init(),
			Codex.cLGHDebug:Init(),
		},
	}
	return Menu
end

function ddDataDaedra:mTooltips()
	local Codex = self.DataCairn.Codex
	local Menu = {
		type = "submenu",
		name = "Tooltip Displays",
		controls = {
			Codex.cTooltipFontHeader:Init(),
			Codex.cTooltipFontBody:Init(),
			Codex.cMatMiser:Init(),
		},
	}
	return Menu
end

function ddDataDaedra:mDataCore()
	local Codex = self.DataCairn.Codex
	local Menu = {
		type = "submenu",
		name = "Core Pricing Data",
		controls = {
			Codex.cNotes2:Init(),
			Codex.cMaxSeen:Init(),
			Codex.cNotes4:Init(),
			Codex.cSetItem:Init(),
			Codex.cTrait:Init(),
			Codex.cQuality:Init(),
			Codex.cLevel:Init(),
			Codex.cEnchant:Init(),
		},
	}
	return Menu
end

function ddDataDaedra:mPanel()
	local Panel = {
		type = "panel",
		name = GetString(DD_TASKMASTER_NAME),
		displayName = GetString(DD_TASKMASTER_DISPLAYNAME),
		author = GetString(DD_TASKMASTER_AUTHOR),
		version = self.Version,
		registerForRefresh = true,
		registerForDefaults = true,
	}
	return Panel
end


--------------------------------------------------------------------------------------------------	
----------------------------------   LAM2 Modular Controls   -------------------------------------	
--------------------------------------------------------------------------------------------------	

function ddDataDaedra.DataCairn.Codex:Init()															-- Initializes all controls so that they're fully set up and ready to use,
	self.cNotes1:Init()																				-- regardless of whether they're displayed or active.
	self.cTwilight:Init()
	self.cTwilightLogin:Init()
	self.cTwilightZone:Init()
	self.cTwilightSummon:Init()
	self.cEasyButton:Init()
	self.cNotes2:Init()
	self.cResetButton:Init()
	self.cMaxSeen:Init()
	self.cNotes4:Init()
	self.cSetItem:Init()
	self.cTrait:Init()
	self.cQuality:Init()
	self.cLevel:Init()
	self.cEnchant:Init()
	self.cTooltipQuality:Init()
	self.cTradeGuild:Init()
	self.cDebug:Init()
	self.cLGHDebug:Init()
	self.cNotify:Init()
	self.cSaveSalePrice:Init()
	self.cwAvgSalePrice:Init()
	self.cTooltipFontHeader:Init()
	self.cTooltipFontBody:Init()
	self.cMatMiser:Init()
end

function Codex.cNotes1:Init()
	self.type = "description"
	self.title = GetString(DD_TASKMASTER_NOTES_1_TITLE)
	self.text = GetString(DD_TASKMASTER_NOTES_1_TEXT)
	self.width = "full"
	return self
end

function Codex.cNotes2:Init()
	self.type = "description"
	self.title = GetString(DD_TASKMASTER_NOTES_2_TITLE)
	self.text = GetString(DD_TASKMASTER_NOTES_2_TEXT)	
	self.width = "full"
	return self
end

function Codex.cNotes3:Init()
	self.type = "description"
	self.title = GetString(DD_TASKMASTER_NOTES_3_TITLE)
	self.text = GetString(DD_TASKMASTER_NOTES_3_TEXT)
	self.width = "full"
	return self
end

function Codex.cNotes4:Init()
	self.type = "description"
	self.title = GetString(DD_TASKMASTER_NOTES_4_TITLE)
	self.text = GetString(DD_TASKMASTER_NOTES_4_TEXT)	
	self.warning = GetString(DD_TASKMASTER_NOTES_4_WARNING)
	self.width = "full"
	return self
end

function Codex.cTwilight:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_ENABLE_TWILIGHT_NAME)
	self.tooltip = GetString(DD_TASKMASTER_ENABLE_TWILIGHT_TIP)
	self.width = "half"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function Codex.cTwilightLogin:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_ONLOGIN_TWILIGHT_NAME)
	self.tooltip = GetString(DD_TASKMASTER_ONLOGIN_TWILIGHT_TIP)
	self.width = "full"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	self.disabled = function() if not ddDataDaedra.DataCairn.Codex.cTwilight.getFunc() then self.setFunc(false) end; return not ddDataDaedra.DataCairn.Codex.cTwilight.getFunc() end
	return self
end

function Codex.cTwilightZone:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_ONZONE_TWILIGHT_NAME)
	self.tooltip = GetString(DD_TASKMASTER_ONZONE_TWILIGHT_TIP)
	self.width = "full"
	
	self.default = false
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value; ddDataDaedra:TwilightZone() end
	self.disabled = function() if not ddDataDaedra.DataCairn.Codex.cTwilight.getFunc() then self.setFunc(false) end; return not ddDataDaedra.DataCairn.Codex.cTwilight.getFunc() end
	return self
end

function Codex.cTwilightSummon:Init()
	self.type = "button"
	self.name = GetString(DD_TASKMASTER_SUMMON_TWILIGHT_NAME)
	self.tooltip = GetString(DD_TASKMASTER_SUMMON_TWILIGHT_TIP)	
	self.width = "half"
	
	self.func = function() ddDataDaedra:TwilightSummons() end
	return self
end

function Codex.cEasyButton:Init()
	self.type = "button"
	self.name = GetString(DD_TASKMASTER_EASY_BUTTON_NAME)
	self.tooltip = GetString(DD_TASKMASTER_EASY_BUTTON_TIP)
	self.width = "half"
	
	self.func = function() ddDataDaedra:EasyButton() end
	return self
end

function Codex.cResetButton:Init()
	self.type = "button"
	self.name = GetString(DD_TASKMASTER_RESET_NAME)
	self.tooltip = GetString(DD_TASKMASTER_RESET_TIP)
	self.width = "half"
	
	self.func = function() ddDataDaedra.DataCairn = {}; ReloadUI() end
	return self
end

function Codex.cMaxSeen:Init()
	self.type = "slider"
	self.name = GetString(DD_TASKMASTER_MAX_SEEN_NAME)
	self.tooltip = GetString(DD_TASKMASTER_MAX_SEEN_TIP)
	self.width = "full"
	
	self.min = 50
	self.max = 1000
	self.step = 50
	self.default = 300
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function Codex.cwAvgSalePrice:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_WAVG_SALE_PRICE_NAME)
	self.tooltip = GetString(DD_TASKMASTER_WAVG_SALE_PRICE_TIP)
	self.width = "full"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function Codex.cSaveSalePrice:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_SAVE_SALE_PRICE_NAME)
	self.tooltip = GetString(DD_TASKMASTER_SAVE_SALE_PRICE_TIP)
	self.width = "full"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function Codex.cSetItem:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_ITEM_SET_NAME)
	self.tooltip = GetString(DD_TASKMASTER_ITEM_SET_TIP)
	self.warning = GetString(DD_TASKMASTER_ITEM_PRICING_KEY_WARNING)
	self.width = "full"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value; ddDataDaedra.DataCairn.Prices = {}; ddDataDaedra.DataCairn.LastScan = {} end
	return self
end

function Codex.cTrait:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_ITEM_TRAIT_NAME)
	self.tooltip = GetString(DD_TASKMASTER_ITEM_TRAIT_TIP)
	self.warning = GetString(DD_TASKMASTER_ITEM_PRICING_KEY_WARNING)	
	self.width = "full"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value; ddDataDaedra.DataCairn.Prices = {}; ddDataDaedra.DataCairn.LastScan = {} end
	self.disabled = function() if not ddDataDaedra.DataCairn.Codex.cSetItem.getFunc() then self.setFunc(false) end; return not ddDataDaedra.DataCairn.Codex.cSetItem.getFunc() end
	return self
end

function Codex.cQuality:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_ITEM_QUALITY_NAME)
	self.tooltip = GetString(DD_TASKMASTER_ITEM_QUALITY_TIP)
	self.warning = GetString(DD_TASKMASTER_ITEM_PRICING_KEY_WARNING)	
	self.width = "full"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value; ddDataDaedra.DataCairn.Prices = {}; ddDataDaedra.DataCairn.LastScan = {} end
	self.disabled = function() if not ddDataDaedra.DataCairn.Codex.cTrait.getFunc() then self.setFunc(false) end; return not ddDataDaedra.DataCairn.Codex.cTrait.getFunc() end
	return self
end

function Codex.cLevel:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_ITEM_LEVEL_NAME)
	self.tooltip = GetString(DD_TASKMASTER_ITEM_LEVEL_TIP)
	self.warning = GetString(DD_TASKMASTER_ITEM_PRICING_KEY_WARNING)	
	self.width = "full"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value; ddDataDaedra.DataCairn.Prices = {}; ddDataDaedra.DataCairn.LastScan = {} end
	self.disabled = function() if not ddDataDaedra.DataCairn.Codex.cQuality.getFunc() then self.setFunc(false) end; return not ddDataDaedra.DataCairn.Codex.cQuality.getFunc() end
	return self
end

function Codex.cEnchant:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_ITEM_ENCHANT_NAME)
	self.tooltip = GetString(DD_TASKMASTER_ITEM_ENCHANT_TIP)
	self.warning = GetString(DD_TASKMASTER_ITEM_PRICING_KEY_WARNING)	
	self.width = "full"
	
	self.default = false
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value; ddDataDaedra.DataCairn.Prices = {}; ddDataDaedra.DataCairn.LastScan = {} end
	self.disabled = function() if not ddDataDaedra.DataCairn.Codex.cLevel.getFunc() then self.setFunc(false) end; return not ddDataDaedra.DataCairn.Codex.cLevel.getFunc() end
	return self
end

function Codex.cTradeGuild:Init()
	self.type = "dropdown"
	self.name = GetString(DD_TASKMASTER_TRADE_GUILD_NAME)
	self.tooltip = GetString(DD_TASKMASTER_TRADE_GUILD_TIP)	
	self.width = "full"
	
	self.choices = select(2, LIB_RDR:GetGuildNames())
	self.default = self.choices[1]
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) 
		self.value = value;
		EVENT_MANAGER:UnregisterForEvent("ddTradeGuild", EVENT_OPEN_TRADING_HOUSE)
		EVENT_MANAGER:RegisterForEvent("ddTradeGuild", EVENT_OPEN_TRADING_HOUSE, function() zo_callLater(function() ddDataDaedra.BindPortal(value) end, 3000) end)
	end

	return self
end

function Codex.cNotify:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_NOTIFICATIONS_NAME)
	self.tooltip = GetString(DD_TASKMASTER_NOTIFICATIONS_TIP)
	self.width = "full"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function Codex.cDebug:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_DEBUG_NAME)
	self.tooltip = GetString(DD_TASKMASTER_DEBUG_TIP)
	self.width = "full"

	self.default = false
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function Codex.cLGHDebug:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_LGH_DEBUG_NAME)
	self.tooltip = GetString(DD_TASKMASTER_LGH_DEBUG_TIP)
	self.warning = GetString(DD_TASKMASTER_LGH_DEBUG_WARNING)
	self.width = "full"

	self.default = false
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value, LIB_LGH.Debug = value, value end
	return self
end

function Codex.cTooltipDetails:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_TOOLTIP_DETAILS_NAME)
	self.tooltip = GetString(DD_TASKMASTER_TOOLTIP_DETAILS_TIP)
	self.warning = GetString(DD_TASKMASTER_TOOLTIP_DETAILS_WARNING)
	self.width = "full"
	
	self.default = false
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function Codex.cTooltipSeen:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_TOOLTIP_SEEN_NAME)
	self.tooltip = GetString(DD_TASKMASTER_TOOLTIP_SEEN_TIP)	
	self.width = "full"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function Codex.cTooltipQuality:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_TOOLTIP_QUALITY_NAME)
	self.tooltip = GetString(DD_TASKMASTER_TOOLTIP_QUALITY_TIP)	
	self.width = "full"
	
	self.default = false
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value end
	return self
end

function Codex.cTooltipFontHeader:Init()
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

function Codex.cTooltipFontBody:Init()
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

function Codex.cMatMiser:Init()
	self.type = "checkbox"
	self.name = GetString(DD_TASKMASTER_MAT_MISER_NAME)
	self.tooltip = GetString(DD_TASKMASTER_MAT_MISER_TIP)
	self.width = "full"
	
	self.default = true
	self.getFunc = function() if self.value == nil then self.value = self.default end return self.value end
	self.setFunc = function(value) self.value = value; ReloadUI() end
	return self
end



--------------------------------------------------------------------------------------------------
----------------------------------------   Key Bindings   ----------------------------------------
--------------------------------------------------------------------------------------------------

function ddDataDaedra.KeybindMaiden()
	ddDataDaedra:TwilightSummons()
end

function ddDataDaedra.KeybindTaskmaster()
	LIB_LAM2:OpenToPanel(TASKMASTER)
end

function ddDataDaedra.KeybindResetPrices()
	ddDataDaedra.DataCairn.Codex.cResetButton.func()
end

function ddDataDaedra.KeybindEasyButton()
	ddDataDaedra:EasyButton()
end

function ddDataDaedra:Commands(args)
	if #args < 1 or 
	#args > 1 then
       return
	
	elseif args[1] == "twilight" then
		self.KeybindMaiden()
	
	elseif args[1] == "taskmaster" or 
	args[1] == "settings" then
		self.KeybindTaskmaster()
	
	elseif args[1] == "reset" then
		self.KeybindResetPrices()
	
	elseif args[1] == "easy" then
		self.KeybindEasyButton()
    end
end


--------------------------------------------------------------------------------------------------
----------------------------------------   UI Bindings   -----------------------------------------
--------------------------------------------------------------------------------------------------

function ddDataDaedra:SeenToStr(seen, maxSeen)
	local LowSeen		= math.floor(maxSeen * (1/3))
	local HighSeen		= math.ceil(maxSeen * (2/3))
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

function ddDataDaedra:StackToStr(wAvg, stack)
	return zo_strformat(GetString(DD_TOOLTIP_STAT_STACK), ZO_CommaDelimitNumber(LIB_LOG:Round(wAvg * stack)), zo_iconFormat("esoui/art/currency/currency_gold.dds", 18, 18), stack)
end

function ddDataDaedra:ResizeSigil(tooltip, label)
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

function ddDataDaedra:CreateItemSigil(tooltip, keyedItem, stack)
	if not tooltip.labelPool then
        tooltip.labelPool = ZO_ControlPool:New("ZO_TooltipLabel", tooltip, "Label")
    end
	if not stack or stack < 2 then stack = 1 end
	local vMaxSeen			= self.DataCairn.Codex.cMaxSeen.getFunc()
	local FontHeader		= self.DataCairn.Codex.cTooltipFontHeader.getFunc()
	local FontBody			= self.DataCairn.Codex.cTooltipFontBody.getFunc()
	local SigilHeader 		= tooltip.labelPool:AcquireObject()
    local SigilLabel 		= tooltip.labelPool:AcquireObject()
	local BulletIcon		= zo_iconFormat(GetString(DD_ICON_BULLET), 12, 12)
	local Str_Buffer 		= " "..BulletIcon.." "
	local Str_Seen			= self:SeenToStr(keyedItem.Seen, vMaxSeen)
	local Str_wAvg			= self:wAvgToStr(keyedItem.wAvg)
	local Str_Stack			= self:StackToStr(keyedItem.wAvg, stack)
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
	self:ResizeSigil(tooltip, SigilLabel)
end

function ddDataDaedra:CreateMiserSigil(tooltip, str_TotalCost)
	if not tooltip.labelPool then
        tooltip.labelPool = ZO_ControlPool:New("ZO_TooltipLabel", tooltip, "Label")
    end

	local FontHeader	= self.DataCairn.Codex.cTooltipFontHeader.getFunc()
	local FontBody		= self.DataCairn.Codex.cTooltipFontBody.getFunc()
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
	self:ResizeSigil(tooltip, MiserLabel)
end

function ddDataDaedra:InscribePopupSigilstone(tooltip)
	if tooltip == PopupControl then return end
	PopupControl = tooltip

	local ResultKeyedItem 	= self:GetKeyedItem(PopupControl.lastLink)
	
	if ResultKeyedItem and
	ResultKeyedItem.wAvg and
	ResultKeyedItem.Seen and
	ResultKeyedItem.wAvg > 0 and
	ResultKeyedItem.Seen > 0 then
		self:CreateItemSigil(tooltip, ResultKeyedItem)
	end
end

function ddDataDaedra:InscribeItemSigilstone(tooltip, itemLink, stack)
	if not tooltip or 
	not itemLink or 
	itemLink == "" then 
		return 

	elseif not stack or
	stack < 2 then 
		stack = 1
	end

	local ResultKeyedItem 	= self:GetKeyedItem(itemLink)
	
	if ResultKeyedItem and
	ResultKeyedItem.wAvg and
	ResultKeyedItem.Seen and
	ResultKeyedItem.wAvg > 0 and
	ResultKeyedItem.Seen > 0 then
		self:CreateItemSigil(tooltip, ResultKeyedItem, stack)
	end
end

function ddDataDaedra:InscribeCraftSigilstone(tooltip, resultLink, resultStack, str_TotalCost)
	if not tooltip then return end
	local ResultKeyedItem = self:GetKeyedItem(resultLink)

	if not resultStack or 
	resultStack < 2 then 
		resultStack = 1 
	end
	
	if ResultKeyedItem and
	ResultKeyedItem.wAvg and
	ResultKeyedItem.Seen and
	ResultKeyedItem.wAvg > 0 and
	ResultKeyedItem.Seen > 0 then
		self:CreateItemSigil(tooltip, ResultKeyedItem, resultStack)
	end

	self:CreateMiserSigil(tooltip, str_TotalCost)
end

function ddDataDaedra:AlchemySigil(self, tooltip)
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
	local SolventKeyedItem = self:GetKeyedItem(SolventItemLink)
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
	local Reagent1KeyedItem = self:GetKeyedItem(Reagent1ItemLink)
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
	local Reagent2KeyedItem = self:GetKeyedItem(Reagent2ItemLink)
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
	local Reagent3KeyedItem = self:GetKeyedItem(Reagent3ItemLink)
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
		
		self:InscribeCraftSigilstone(tooltip, PotionLink, PotionCount, Str_TotalReagentCost)
	end
end

function ddDataDaedra:ProvisionerSigil(self, tooltip)
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
		MatKeyedItem1 = self:GetKeyedItem(MatLink1)
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
		MatKeyedItem2 = self:GetKeyedItem(MatLink2)
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
		MatKeyedItem3 = self:GetKeyedItem(MatLink3)
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
		MatKeyedItem4 = self:GetKeyedItem(MatLink4)
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
		MatKeyedItem5 = self:GetKeyedItem(MatLink5)
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
		
		self:InscribeCraftSigilstone(tooltip, RecipeLink, RecipeCount, Str_TotalIngredientCost)
	end
end

function ddDataDaedra:EnchantingSigil(self, tooltip)
	if not tooltip or
	tooltip == ResultControl then
		return
	end
	ResultControl = tooltip
	craftingStation = ENCHANTING
	
	local EnchantingResultItemLink = GetEnchantingResultingItemLink(craftingStation:GetAllCraftingBagAndSlots())
	
	local RunePotencySlot = ZO_EnchantingTopLevelRuneSlotContainerPotencyRune
	local RunePotencyItemLink = GetItemLink(craftingStation.runeSlots[1]:GetBagAndSlot())
	local RunePotencyKeyedItem = self:GetKeyedItem(RunePotencyItemLink)
	local RunePotencyIcon = zo_iconFormat(GetItemInfo(craftingStation.runeSlots[3]:GetBagAndSlot()), 28, 28)
	local RunePotencyCost = 0
	local RunePotencyName = GetItemLinkEnchantingRuneName(RunePotencyItemLink)
	
	if RunePotencyKeyedItem and
	RunePotencyKeyedItem.wAvg ~= 0 then
		RunePotencyCost = RunePotencyKeyedItem.wAvg
	end

	local RuneEssenceSlot = ZO_EnchantingTopLevelRuneSlotContainerEssenceRune
	local RuneEssenceItemLink = GetItemLink(RuneEssenceSlot.bagId, RuneEssenceSlot.slotIndex)
	local RuneEssenceKeyedItem = self:GetKeyedItem(RuneEssenceItemLink)
	local RuneEssenceIcon = zo_iconFormat(GetItemInfo(RuneEssenceSlot.bagId, RuneEssenceSlot.slotIndex), 28, 28)
	local RuneEssenceCost = 0
	local RuneEssenceName = GetItemLinkEnchantingRuneName(RuneEssenceItemLink)
	
	if RuneEssenceKeyedItem and
	RuneEssenceKeyedItem.wAvg ~= 0 then
		RuneEssenceCost = RuneEssenceKeyedItem.wAvg
	end
	
	local RuneAspectSlot = ZO_EnchantingTopLevelRuneSlotContainerAspectRune
	local RuneAspectItemLink = GetItemLink(RuneAspectSlot.bagId, RuneAspectSlot.slotIndex)
	local RuneAspectKeyedItem = self:GetKeyedItem(RuneAspectItemLink)
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
		
		self:InscribeCraftSigilstone(tooltip, EnchantingResultItemLink, 1, Str_TotaGlyphCost)
	end
end

function ddDataDaedra:ImprovementSigil(self, tooltip)
	if not tooltip or
	tooltip == ResultControl then
		return
	end
	ResultControl = tooltip
	local Panel = SMITHING.improvementPanel
	
	local ImproveResultItemLink = GetSmithingImprovedItemLink(Panel:GetCurrentImprovementParams(), LINK_STYLE_BRACKETS)
	local BoosterLink = GetSmithingImprovementItemLink(GetCraftingInteractionType(), Panel.boosterSlot.index, LINK_STYLE_BRACKETS)

	local BoosterKeyedItem = self:GetKeyedItem(BoosterLink)
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
		self:InscribeCraftSigilstone(tooltip, ImproveResultItemLink, 1, Str_TotalImprovementCost)
	end	
end

function ddDataDaedra:CreationSigil(self, tooltip)
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
	local MatKeyedItem = self:GetKeyedItem(MatItemLink)
	local MatCost = 0
	
	if MatKeyedItem and
	MatKeyedItem.wAvg ~= 0 then
		MatCost = MatKeyedItem.wAvg * MatCount
	end
	
	local StyleItemLink = GetSmithingStyleItemLink(StyleList.styleIndex, LINK_STYLE_BRACKETS)
	local StyleKeyedItem = self:GetKeyedItem(StyleItemLink)
	local StyleCost = 0
	
	if StyleKeyedItem and
	StyleKeyedItem.wAvg ~= 0 then
		StyleCost = StyleKeyedItem.wAvg
	end
	
	local TraitItemLink = GetSmithingTraitItemLink(TraitList.traitIndex, LINK_STYLE_BRACKETS)
	local TraitKeyedItem = self:GetKeyedItem(TraitItemLink)
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
		
		self:InscribeCraftSigilstone(tooltip, ResultItemLink, 1, Str_TotalSmithingCost)
	end
end

function ddDataDaedra:SigilDesign(tooltip)
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
			self:InscribeItemSigilstone(tooltip, ItemLink, Stack)
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
			
			self:InscribeItemSigilstone(tooltip, ItemLink, 1)
			return
		
		elseif TRADING_HOUSE:IsAtTradingHouse() and 
		TH:IsInSearchMode() and
		Row.timeRemaining and 
		Row.timeRemaining > 0 then
			ItemLink = GetTradingHouseSearchResultItemLink(Row.slotIndex)
			self:InscribeItemSigilstone(tooltip, ItemLink, Stack)
			return

		elseif TRADING_HOUSE:IsAtTradingHouse() and
		Row.bagId then 
			ItemLink = GetItemLink(Row.bagId, Row.slotIndex)
			self:InscribeItemSigilstone(tooltip, ItemLink, Stack)
			return
			
		elseif TRADING_HOUSE:IsAtTradingHouse() and
		TH:IsInListingsMode() then
			ItemLink = GetTradingHouseListingItemLink(Row.slotIndex)
			self:InscribeItemSigilstone(tooltip, ItemLink, Stack)
			return
			
		elseif Row.bagId then 
			ItemLink = GetItemLink(Row.bagId, Row.slotIndex)
			
			if tooltip ~= ComparativeTooltip1 or ComparativeTooltip2 then								-- They inherit from ItemTooltip, so we have to rule them out specifically
				self:InscribeItemSigilstone(tooltip, ItemLink, Stack)
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

function ddDataDaedra:LinkStatsToChat(itemLink)
	if not itemLink or itemLink == "" then return end
	itemLink = string.gsub(itemLink, "|H0", "|H1")
	local KeyedItem = self:GetKeyedItem(itemLink)
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

function ddDataDaedra:ChatLinkStatsToChat(itemLink, button, control)
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
				if self:IsKeyedItem(itemLink) then
					AddMenuItem(GetString(SI_ITEM_ACTION_DD_STATS_TO_CHAT), function() self:LinkStatsToChat(itemLink) end) 
				end
				
				AddMenuItem(GetString(SI_ITEM_ACTION_LINK_TO_CHAT), function() ZO_LinkHandler_InsertLink(zo_strformat(SI_TOOLTIP_ITEM_NAME, itemLink)) end)
				ShowMenu(control)
			end
		end
	end
end

function ddDataDaedra:SlotControlStatsToChat()
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
	
	local ItemLink = LIB_RDR:GetItemLinkFromSlotControl(SlotControl)
	if self:IsKeyedItem(ItemLink) then
		zo_callLater(function() AddMenuItem(GetString(SI_ITEM_ACTION_DD_STATS_TO_CHAT), function() ddDataDaedra:LinkStatsToChat(ItemLink) end, MENU_ADD_OPTION_LABEL); ShowMenu(self) end, 50)
	end
end

-------

function ddDataDaedra:IsKeyedItem(itemLink)
	local KeyedItem = self:GetKeyedItem(itemLink)
	
	if not KeyedItem then 
		return false 
	else 
		return true 
	end
end

function ddDataDaedra:GetKeyedItem(itemLink)
	local Codex			= self.DataCairn.Codex
	local Prices		= self.DataCairn.Prices
	local tSetItem		= Codex.cSetItem.getFunc()
	local tTrait		= Codex.cTrait.getFunc()
	local tQuality		= Codex.cQuality.getFunc()
	local tLevel		= Codex.cLevel.getFunc()
	local tEnchant 		= Codex.cEnchant.getFunc()
	local ItemId		= LIB_RDR:GetLinkValue(itemLink, 3)
	local EnchtId		= LIB_RDR:GetLinkValue(itemLink, 6)
	local SetItem		= LIB_RDR:GetItemLinkSetItem(itemLink)
	local Trait			= LIB_RDR:GetItemLinkTrait(itemLink)
	local Level, VetRank = LIB_RDR:GetItemLinkLevel(itemLink)
	local Quality		= LIB_RDR:GetItemLinkQuality(itemLink)
	
	if Prices[ItemId] then
		if tSetItem then
			if Prices[ItemId][SetItem] then
				if tTrait then
					if Prices[ItemId][SetItem][Trait] then
						if tQuality then
							if Prices[ItemId][SetItem][Trait][Quality] then
								if tLevel then
									if Prices[ItemId][SetItem][Trait][Quality][Level] then
										if Prices[ItemId][SetItem][Trait][Quality][Level][VetRank] then
											if tEnchant then
												if Prices[ItemId][SetItem][Trait][Quality][Level][VetRank][EnchtId] then
													return Prices[ItemId][SetItem][Trait][Quality][Level][VetRank][EnchtId]
												end
											elseif Prices[ItemId][SetItem][Trait][Quality][Level][VetRank] then
												return Prices[ItemId][SetItem][Trait][Quality][Level][VetRank]
											end
										elseif Prices[ItemId][SetItem][Trait][Quality][Level] then
											return Prices[ItemId][SetItem][Trait][Quality][Level]
										end
									end
								elseif Prices[ItemId][SetItem][Trait][Quality] then
									return Prices[ItemId][SetItem][Trait][Quality]
								end
							end
						elseif Prices[ItemId][SetItem][Trait] then
							return Prices[ItemId][SetItem][Trait]
						end
					end
				elseif Prices[ItemId][SetItem] then
					return Prices[ItemId][SetItem]
				end
			end
		elseif Prices[ItemId] then
			return Prices[ItemId]
		end
	end
	return nil
end

function ddDataDaedra:DisplayMsg(msgString, boolDebug)												
	local tDebug = self.DataCairn.Codex.cDebug.getFunc()											
	local tNotify = self.DataCairn.Codex.cNotify.getFunc()											
	
	if tDebug and 
	boolDebug then
		d(GetString(DD_DEBUG) .. msgString)																	

	elseif tNotify and
	not boolDebug then
		d(GetString(DD_MONIKER) .. msgString)
		
	else
		return
	end
end

function ddDataDaedra.BindPortal(tradeGuild)
	NUMGUILDS = GetNumGuilds()
	local TradeGuildId
	local currStore = GetSelectedTradingHouseGuildId()
	
	for GuildId = 1, NUMGUILDS do 
		local Name = GetGuildName(GuildId)
		if not Name or 
		not tradeGuild then 
			break
		elseif Name == tradeGuild then
			TradeGuildId = GetGuildId(GuildId)
			break
		end
	end
	
	if TradeGuildId and
	currStore and
	TradeGuildId ~= 0 and
	currStore ~= 0 and
	currStore ~= TradeGuildId then
		SelectTradingHouseGuildId(TradeGuildId)
		TRADING_HOUSE:UpdateForGuildChange()
	end
end

function ddDataDaedra:TwilightMaiden(guildId)
	NUMGUILDS				= GetNumGuilds()
	local Prices			= self.DataCairn.Prices
	local Codex				= self.DataCairn.Codex
	local tEnchant 			= Codex.cEnchant.getFunc()
	local tLevel			= Codex.cLevel.getFunc()
	local tQuality			= Codex.cQuality.getFunc()
	local tTrait			= Codex.cTrait.getFunc()
	local tSetItem			= Codex.cSetItem.getFunc()
	local vMaxSeen			= Codex.cMaxSeen.getFunc()
	local CatId 			= GUILD_HISTORY_STORE
	local GuildName 		= GetGuildName(guildId) or ""
	local StoreEvents		= GetNumGuildEvents(guildId, CatId)
	local NewSales			= 0
	
	if not Codex.cTwilight.getFunc() then
		self:DisplayMsg(GetString(DD_TWILIGHT_DISMISS), false)
		return
	
	elseif guildId > NUMGUILDS then
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
	
	local LastScan = self.DataCairn.LastScan[GuildName] or 1
	
	for i = 1, StoreEvents, 1 do
		local EventType, SecsSinceEvent, Buyer, Seller, Quantity, ItemLink, Price, Tax = GetGuildEventInfo(guildId, CatId, i)
		local TimeStamp = GetTimeStamp() - SecsSinceEvent
		
		if EventType == GUILD_EVENT_ITEM_SOLD and 
		TimeStamp > LastScan and 
		ItemLink ~= "" then
			NewSales	= NewSales + 1
			Quantity 	= tonumber(Quantity)
			Price 		= tonumber(Price)
			
			local Quality		= LIB_RDR:GetItemLinkQuality(ItemLink)
			local SetItem 		= LIB_RDR:GetItemLinkSetItem(ItemLink)
			local Trait			= LIB_RDR:GetItemLinkTrait(ItemLink)
			local Level, VetRank = LIB_RDR:GetItemLinkLevel(ItemLink)
			local ItemId		= LIB_RDR:GetLinkValue(ItemLink, 3)
			local EnchtId		= LIB_RDR:GetLinkValue(ItemLink, 6)
			local Element		= (Price / Quantity) * Quantity
			local Tier1, Tier2, Tier3, Tier4, Tier5, Tier6, Values

			Values = { 
				["Seen"] 		= 1,
				["RawValue"] 	= Element, 
				["Weight"] 		= Quantity, 
				["wAvg"] 		= LIB_LOG:RoundTo100s(LIB_LOG:WeightedAverage(Price, Quantity)),
				["PostPrice"]	= 0,
			}
				
			if tEnchant then
				Tier6 	= { [EnchtId] 	= Values}
				Tier5 	= { [VetRank] 	= Tier6 }
				Tier4 	= { [Level] 	= Tier5 }
				Tier3 	= { [Quality] 	= Tier4 }
				Tier2	= { [Trait]	 	= Tier3 }
				Tier1	= { [SetItem] 	= Tier2 }
				
			elseif tLevel then
				Tier5 	= { [VetRank] 	= Values}
				Tier4 	= { [Level] 	= Tier5 }
				Tier3 	= { [Quality] 	= Tier4 }
				Tier2	= { [Trait]	 	= Tier3 }
				Tier1	= { [SetItem] 	= Tier2 }
			
			elseif tQuality then
				Tier3 	= { [Quality] 	= Values}
				Tier2	= { [Trait] 	= Tier3 }
				Tier1	= { [SetItem] 	= Tier2 }
			
			elseif tTrait then
				Tier2	= { [Trait] 	= Values}
				Tier1	= { [SetItem] 	= Tier2 }
			else
				Tier1	= { [SetItem] 	= Values}
			end
			
			if ItemId and (not Prices) then
				table.insert(Prices, ItemId, Tier1)
			
			elseif ItemId and (not Prices[ItemId]) then
				table.insert(Prices, ItemId, Tier1)

			elseif ItemId and Prices[ItemId] then
				if not tSetItem then
					local record = Prices[ItemId]
					if not record.Seen then 
						return 
					end

					if record.Seen <= vMaxSeen then
						record.Seen 	= record.Seen + 1
						record.RawValue	= record.RawValue + Element
						record.Weight	= record.Weight + Quantity						
						record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
				
					elseif record.Seen > vMaxSeen then
						record.Seen 	= 1
						record.RawValue = Element
						record.Weight 	= Quantity						
						record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
					end
					
				elseif not Prices[ItemId][SetItem] then
					table.insert(Prices[ItemId], SetItem, Tier2)
					
				elseif Prices[ItemId][SetItem] then
					if not tTrait then
						local record = Prices[ItemId][SetItem]
						if not record.Seen then 
							return 
						end

						if record.Seen <= vMaxSeen then
							record.Seen 	= record.Seen + 1
							record.RawValue	= record.RawValue + Element
							record.Weight	= record.Weight + Quantity							
							record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
					
						elseif record.Seen > vMaxSeen then
							record.Seen 	= 1
							record.RawValue = Element
							record.Weight 	= Quantity							
							record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
						end
						
					elseif not Prices[ItemId][SetItem][Trait] then
						table.insert(Prices[ItemId], Trait, Tier3)

					elseif Prices[ItemId][SetItem][Trait] then
						if not tQuality then
							local record = Prices[ItemId][SetItem][Trait]
							if not record.Seen then 
								return
							end
							
							if record.Seen <= vMaxSeen then
								record.Seen 	= record.Seen + 1
								record.RawValue	= record.RawValue + Element
								record.Weight	= record.Weight + Quantity								
								record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
						
							elseif record.Seen > vMaxSeen then
								record.Seen 	= 1
								record.RawValue = Element
								record.Weight 	= Quantity								
								record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
							end

						elseif not Prices[ItemId][SetItem][Trait][Quality] then
							table.insert(Prices[ItemId][SetItem][Trait], Quality, Tier4)
					
						elseif Prices[ItemId][SetItem][Trait][Quality] then
							if not tLevel then
								local record = Prices[ItemId][SetItem][Trait][Quality]
								if not record.Seen then 
									return 
								end

								if record.Seen <= vMaxSeen then
									record.Seen 	= record.Seen + 1
									record.RawValue	= record.RawValue + Element
									record.Weight	= record.Weight + Quantity									
									record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
							
								elseif record.Seen > vMaxSeen then
									record.Seen 	= 1
									record.RawValue = Element
									record.Weight 	= Quantity									
									record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
								end

							elseif not Prices[ItemId][SetItem][Trait][Quality][Level] then
								table.insert(Prices[ItemId][SetItem][Trait][Quality], Level, Tier5)
								
							elseif Prices[ItemId][SetItem][Trait][Quality][Level] then
								if not Prices[ItemId][SetItem][Trait][Quality][Level][VetRank] then
									table.insert(Prices[ItemId][SetItem][Trait][Quality][Level], VetRank, Tier6)
								
								elseif Prices[ItemId][SetItem][Trait][Quality][Level][VetRank] then	
									if not tEnchant then
										local record = Prices[ItemId][SetItem][Trait][Quality][Level][VetRank]
										if not record.Seen then 
											return 
										end
										
										if record.Seen <= vMaxSeen then
											record.Seen 	= record.Seen + 1
											record.RawValue	= record.RawValue + Element
											record.Weight	= record.Weight + Quantity											
											record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
									
										elseif record.Seen > vMaxSeen then
											record.Seen 	= 1
											record.RawValue = Element
											record.Weight 	= Quantity										
											record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
										end
								
									elseif not Prices[ItemId][SetItem][Trait][Quality][Level][VetRank][EnchtId] then
										table.insert(Prices[ItemId][SetItem][Trait][Quality][Level][VetRank], EnchtId, Values)
										
									elseif Prices[ItemId][SetItem][Trait][Quality][Level][VetRank][EnchtId] then
										local record = Prices[ItemId][SetItem][Trait][Quality][Level][VetRank][EnchtId]
										if not record.Seen then 
											return 
										end

										if record.Seen <= vMaxSeen then
											record.Seen 	= record.Seen + 1
											record.RawValue	= record.RawValue + Element
											record.Weight	= record.Weight + Quantity										
											record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
									
										elseif record.Seen > vMaxSeen then
											record.Seen 	= 1
											record.RawValue = Element
											record.Weight 	= Quantity
											record.wAvg 	= LIB_LOG:RoundTo100s(record.RawValue / record.Weight)
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
	
	if NewSales > 0 then
		self:DisplayMsg(zo_strformat(GetString(DD_TWILIGHT_NEWSALES), ZO_CommaDelimitNumber(NewSales), ZO_CommaDelimitNumber(StoreEvents), GuildName), false)
	end

	self.DataCairn.LastScan[GuildName] = GetTimeStamp()
	
	if guildId == NUMGUILDS then
		self:DisplayMsg(GetString(DD_TWILIGHT_COMPLETE), false)
	end
end

function ddDataDaedra:TwilightSummons()
	LIB_LGH:RequestHistory(GUILD_HISTORY_STORE, self.TwilightCallback)
end

function ddDataDaedra:TwilightZone()
	local Codex	= self.DataCairn.Codex
	
	if Codex.cTwilightZone.getFunc() then
		EVENT_MANAGER:RegisterForEvent("ddTwilightZone", EVENT_PLAYER_ACTIVATED, function() self:TwilightSummons() end)
--		self:DisplayMsg(GetString(DD_TWILIGHT_ONZONE), false)
	
	else
		EVENT_MANAGER:UnregisterForEvent("ddTwilightZone", EVENT_PLAYER_ACTIVATED)
--		self:DisplayMsg(GetString(DD_TWILIGHT_OFFZONE), false)
	end
end

function ddDataDaedra.TwilightCallback(guildId)
	ddDataDaedra:TwilightMaiden(guildId)
end

function ddDataDaedra:PendListing()
	local twAvgSalePrice = self.DataCairn.Codex.cwAvgSalePrice.getFunc()
	local tSaveSalePrice = self.DataCairn.Codex.cSaveSalePrice.getFunc()
	PostFunc(TRADING_HOUSE)
	
	if TRADING_HOUSE.m_pendingItemSlot and 
	(twAvgSalePrice or tSaveSalePrice) then
		local ItemLink 		= GetItemLink(BAG_BACKPACK, TRADING_HOUSE.m_pendingItemSlot)
		local KeyedItem 	= self:GetKeyedItem(ItemLink)
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

function ddDataDaedra:SavePrice()
	local Codex				= self.DataCairn.Codex
	local tSaveSalePrice	= Codex.cSaveSalePrice.getFunc()
	local ItemLink 			= GetItemLink(BAG_BACKPACK, TRADING_HOUSE.m_pendingItemSlot)
	local Stack 			= select(2, GetItemInfo(BAG_BACKPACK, TRADING_HOUSE.m_pendingItemSlot))
	local KeyedItem			= self:GetKeyedItem(ItemLink)
	local PostPrice 		= LIB_LOG:Round(LIB_LOG:RoundTo100s(TRADING_HOUSE.m_invoiceSellPrice.sellPrice / Stack))
	
	if tSaveSalePrice then
		if KeyedItem then
			local wAvgPrice	= LIB_LOG:Round(LIB_LOG:RoundTo100s(KeyedItem.wAvg / Stack))
			
			if wAvgPrice ~= PostPrice then
				KeyedItem.PostPrice = PostPrice
			end
		else
			local Prices		= self.DataCairn.Prices
			local tSetItem		= Codex.cSetItem.getFunc()
			local tTrait		= Codex.cTrait.getFunc()
			local tQuality		= Codex.cQuality.getFunc()
			local tLevel		= Codex.cLevel.getFunc()
			local tEnchant 		= Codex.cEnchant.getFunc()
			local ItemId		= LIB_RDR:GetLinkValue(ItemLink, 3)
			local EnchtId		= LIB_RDR:GetLinkValue(ItemLink, 6)
			local SetItem		= LIB_RDR:GetItemLinkSetItem(ItemLink)
			local Trait			= LIB_RDR:GetItemLinkTrait(ItemLink)
			local Level, VetRank = LIB_RDR:GetItemLinkLevel(ItemLink)
			local Quality		= LIB_RDR:GetItemLinkQuality(ItemLink)

			Values = { 
				["Seen"] 		= 0,
				["RawValue"] 	= 0, 
				["Weight"] 		= 0, 
				["wAvg"] 		= 0,
				["PostPrice"]	= PostPrice,
			}
			
			if Prices[ItemId] then
				if tSetItem then
					if Prices[ItemId][SetItem] then
						if tTrait then
							if Prices[ItemId][SetItem][Trait] then
								if tQuality then
									if Prices[ItemId][SetItem][Trait][Quality] then
										if tLevel then
											if Prices[ItemId][SetItem][Trait][Quality][Level] then
												if Prices[ItemId][SetItem][Trait][Quality][Level][VetRank] then
													if tEnchant then
														if not Prices[ItemId][SetItem][Trait][Quality][Level][VetRank][EnchtId] then
															table.insert(Prices[ItemId][SetItem][Trait][Quality][Level][VetRank], EnchtId, Values)
														end
													end
												elseif not Prices[ItemId][SetItem][Trait][Quality][Level][VetRank] then
													table.insert(Prices[ItemId][SetItem][Trait][Quality][Level], VetRank, Values)
												end
											elseif not Prices[ItemId][SetItem][Trait][Quality][Level] then
												table.insert(Prices[ItemId][SetItem][Trait][Quality], Level, { [VetRank] = Values })
											end
										end
									elseif not Prices[ItemId][SetItem][Trait][Quality] then
										table.insert(Prices[ItemId][SetItem][Trait], Quality, Values)
									end
								end
							elseif not Prices[ItemId][SetItem][Trait] then
								table.insert(Prices[ItemId][SetItem], Trait, Values)
							end
						end
					elseif not Prices[ItemId][SetItem] then
						table.insert(Prices[ItemId], SetItem, Values)
					end
				end
			elseif not Prices[ItemId] then
				table.insert(Prices, ItemId, Values)
			end
		end
	end
end

function ddDataDaedra:Hooks()
	ZO_PreHook(TRADING_HOUSE, "PostPendingItem", function() self:SavePrice() end)
	ZO_PreHook("ZO_InventorySlot_ShowContextMenu", function(rowControl) SlotControl = rowControl; self:SlotControlStatsToChat() end)
	
	ZO_PreHookHandler(ItemTooltip, 	'OnUpdate',		function(tooltip) self:SigilDesign(tooltip) end)
	ZO_PreHookHandler(ItemTooltip, 	'OnCleared',	function() TooltipControl = nil end)
	ZO_PreHookHandler(PopupTooltip, 'OnUpdate',		function(tooltip) self:InscribePopupSigilstone(tooltip) end)
	ZO_PreHookHandler(PopupTooltip,	'OnCleared',	function() PopupControl = nil end)
	
	if self.DataCairn.Codex.cMatMiser.getFunc() then
		ZO_PreHookHandler(ZO_SmithingTopLevelCreationPanelResultTooltip, "OnUpdate", function(tooltip) self:CreationSigil(self, tooltip) end)
		ZO_PreHookHandler(ZO_SmithingTopLevelCreationPanelResultTooltip, "OnCleared", function() ResultControl = nil end)
		
		ZO_PreHookHandler(ZO_SmithingTopLevelImprovementPanelResultTooltip, "OnUpdate", function(tooltip) self:ImprovementSigil(self, tooltip) end)
		ZO_PreHookHandler(ZO_SmithingTopLevelImprovementPanelResultTooltip, "OnCleared", function() ResultControl = nil end)
		
		ZO_PreHookHandler(ZO_EnchantingTopLevelTooltip, "OnUpdate", function(tooltip) self:EnchantingSigil(self, tooltip) end)
		ZO_PreHookHandler(ZO_EnchantingTopLevelTooltip, "OnCleared", function() ResultControl = nil end)
		
		ZO_PreHookHandler(ZO_ProvisionerTopLevelTooltip, "OnUpdate", function(tooltip) self:ProvisionerSigil(self, tooltip) end)
		ZO_PreHookHandler(ZO_ProvisionerTopLevelTooltip, "OnCleared", function() ResultControl = nil end)
		
		ZO_PreHookHandler(ZO_AlchemyTopLevelTooltip, "OnUpdate", function(tooltip) self:AlchemySigil(self, tooltip) end)
		ZO_PreHookHandler(ZO_AlchemyTopLevelTooltip, "OnCleared", function() ResultControl = nil end)
	end
	
	ZO_LinkHandler_OnLinkMouseUp = function(itemLink, button, control) self:ChatLinkStatsToChat(itemLink, button, control) end
	LINK_HANDLER:RegisterCallback(LINK_HANDLER.LINK_CLICKED_EVENT, function() self:InscribePopupSigilstone(self, PopupTooltip) end)	
	SMITHING.improvementPanel.spinner:RegisterCallback("OnValueChanged", function(value) ResultControl = nil self:ImprovementSigil(self, ZO_SmithingTopLevelImprovementPanelResultTooltip) end)
	PostFunc = TRADING_HOUSE.SetupPendingPost
	TRADING_HOUSE.SetupPendingPost = function() self:PendListing() end
end

function ddDataDaedra:LiminalBridge()
	local Codex			= self.DataCairn.Codex
	local vTradeGuild 	= Codex.cTradeGuild.getFunc()
	local tOnLogin 		= Codex.cTwilightLogin.getFunc()
	local tOnZone		= Codex.cTwilightZone.getFunc()
	LIB_LGH.Debug		= Codex.cLGHDebug.getFunc()

	if tOnZone then
		EVENT_MANAGER:RegisterForEvent("ddTwilightZone", EVENT_PLAYER_ACTIVATED, function() self:TwilightSummons() end)
		self:DisplayMsg(GetString(DD_TWILIGHT_SUMMON), false)
	
	elseif not tOnZone and
	tOnLogin then
		self:DisplayMsg(GetString(DD_TWILIGHT_SUMMON), false)
		self:TwilightSummons()
	end
	
	if vTradeGuild and
	vTradeGuild ~= "" then
		EVENT_MANAGER:RegisterForEvent("ddTradeGuild", EVENT_OPEN_TRADING_HOUSE, function() zo_callLater(function() ddDataDaedra.BindPortal(vTradeGuild) end, 1000) end)
	end
	
	SLASH_COMMANDS["/dd"] = function(args) 
		local arguments = {}
		local searchResult = { string.match(args,"^(%S*)%s*(.-)$") }
		for i,v in pairs(searchResult) do
			if (v ~= nil and v ~= "") then
				arguments[i] = string.lower(v)
			end
		end
		
		self:Commands(arguments)
	end
	
	self:DisplayMsg(GetString(DD_ONLOAD), false)
end

function ddDataDaedra.Boot(eventCode, addonName)
	if addonName ~= ADDON_NAME then
		return
	
	else
		ddDataDaedra.DataCairn = ZO_SavedVars:NewAccountWide("ddDataCairn", SV_VERSION, nil, ddDataDaedra.DataCairn, "Global")
		ddDataDaedra.DataCairn.Codex:Init()

		TASKMASTER = LIB_LAM2:RegisterAddonPanel("ddCodex", ddDataDaedra:mPanel())
		LIB_LAM2:RegisterOptionControls("ddCodex", ddDataDaedra:mControls())
		
		ddDataDaedra:Hooks()
		ddDataDaedra:LiminalBridge()
		EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
	end	
end


EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, ddDataDaedra.Boot)
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------