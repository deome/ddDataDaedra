--------------------------------------------------------------------------------------------------
-----------------------------------   LibReader - by @Deome   ------------------------------------
local									VERSION = "1.60"										--
--																								--
--																								--
--------------------------------------   Obligatory Spam   ---------------------------------------
--																								--
-- 		"This Add-on is not created by, affiliated with or sponsored by ZeniMax 		  		--
--		Media Inc. or its affiliates. The Elder Scrolls® and related logos are registered 	 	--
--		trademarks of ZeniMax Media Inc. in the United States and/or other countries. 			--
--		All rights reserved."																	--
--																								--
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------------
-----------------------------------------   Globals   --------------------------------------------
--------------------------------------------------------------------------------------------------

local MAJOR, MINOR = "LibReader", 6
local LibReader, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not LibReader then return end


--------------------------------------------------------------------------------------------------
-----------------------------------   Global Declarations   --------------------------------------
--------------------------------------------------------------------------------------------------

function LibReader:GetGuildNames()				end
function LibReader:GetItemLinkFromSlot()		end
function LibReader:ParseItemLinkToTable() 		end
function LibReader:GetLinkValue() 				end
function LibReader:GetItemLinkQuality() 		end
function LibReader:GetItemLinkStyle() 			end
function LibReader:GetItemLinkTrait() 			end
function LibReader:GetItemLinkSetItem()			end
function LibReader:GetItemLinkItemType() 		end
function LibReader:GetItemLinkWeaponType() 		end
function LibReader:GetItemLinkArmorType()		end
function LibReader:GetItemLinkEquipType() 		end
function LibReader:GetItemLinkSlots()			end
function LibReader:FormatEventType() 			end
function LibReader:FormatHistoryCategory() 		end
function LibReader:FormatHistorySubCategory()	end
function LibReader:FormatGuildEvent() 			end


--------------------------------------------------------------------------------------------------
-------------------------------------   Table of Constants   -------------------------------------
--------------------------------------------------------------------------------------------------

LibReader.SlotTypes = {
[1] = SLOT_TYPE_QUEST_ITEM,
[2] = SLOT_TYPE_ITEM,
[3] = SLOT_TYPE_EQUIPMENT,
[4] = SLOT_TYPE_MY_TRADE,
[5] = SLOT_TYPE_THEIR_TRADE,
[6] = SLOT_TYPE_STORE_BUY,
[7] = SLOT_TYPE_STORE_BUYBACK,
[8] = SLOT_TYPE_BUY_MULTIPLE,
[9] = SLOT_TYPE_BANK_ITEM,
[10] = SLOT_TYPE_GUILD_BANK_ITEM,
[11] = SLOT_TYPE_MAIL_QUEUED_ATTACHMENT,
[12] = SLOT_TYPE_MAIL_ATTACHMENT,
[13] = SLOT_TYPE_LOOT,
[14] = SLOT_TYPE_ACHIEVEMENT_REWARD,
[15] = SLOT_TYPE_PENDING_CHARGE,
[16] = SLOT_TYPE_ENCHANTMENT,
[17] = SLOT_TYPE_ENCHANTMENT_RESULT,
[18] = SLOT_TYPE_TRADING_HOUSE_POST_ITEM,
[19] = SLOT_TYPE_TRADING_HOUSE_ITEM_RESULT,
[20] = SLOT_TYPE_TRADING_HOUSE_ITEM_LISTING,
[21] = SLOT_TYPE_REPAIR,
[22] = SLOT_TYPE_PENDING_REPAIR,
[23] = SLOT_TYPE_STACK_SPLIT,
[24] = SLOT_TYPE_CRAFTING_COMPONENT,
[25] = SLOT_TYPE_PENDING_CRAFTING_COMPONENT,
[26] = SLOT_TYPE_SMITHING_MATERIAL,
[27] = SLOT_TYPE_SMITHING_STYLE,
[28] = SLOT_TYPE_SMITHING_TRAIT,
[29] = SLOT_TYPE_SMITHING_BOOSTER,
[30] = SLOT_TYPE_LIST_DIALOG_ITEM,
[31] = SLOT_TYPE_DYEABLE_EQUIPMENT,
[32] = SLOT_TYPE_GUILD_SPECIFIC_ITEM,
[33] = SLOT_TYPE_GAMEPAD_INVENTORY_ITEM,
}

LibReader.Str_Item_Types = { 																		-- There are a LOT of tables here, and I decided to parse them this way for readility.
[ITEMTYPE_NONE] 					= SI_ITEMTYPE0, 												-- If you're reading this in a program that can't collapse tables: http://notepad-plus-plus.org/download/v6.6.9.html
[ITEMTYPE_WEAPON] 					= SI_ITEMTYPE1, 
[ITEMTYPE_ARMOR] 					= SI_ITEMTYPE2, 
[ITEMTYPE_PLUG] 					= SI_ITEMTYPE3, 
[ITEMTYPE_FOOD] 					= SI_ITEMTYPE4, 
[ITEMTYPE_TROPHY] 					= SI_ITEMTYPE5, 
[ITEMTYPE_SIEGE] 					= SI_ITEMTYPE6, 
[ITEMTYPE_POTION] 					= SI_ITEMTYPE7, 
[ITEMTYPE_RACIAL_STYLE_MOTIF] 		= SI_ITEMTYPE8, 
[ITEMTYPE_TOOL] 					= SI_ITEMTYPE9, 
[ITEMTYPE_INGREDIENT] 				= SI_ITEMTYPE10, 
[ITEMTYPE_ADDITIVE] 				= SI_ITEMTYPE11, 
[ITEMTYPE_DRINK] 					= SI_ITEMTYPE12, 
[ITEMTYPE_COSTUME] 					= SI_ITEMTYPE13, 
[ITEMTYPE_DISGUISE]  				= SI_ITEMTYPE14, 
[ITEMTYPE_TABARD]  					= SI_ITEMTYPE15, 
[ITEMTYPE_LURE]  					= SI_ITEMTYPE16, 
[ITEMTYPE_RAW_MATERIAL]  			= SI_ITEMTYPE17, 
[ITEMTYPE_CONTAINER]  				= SI_ITEMTYPE18, 
[ITEMTYPE_SOUL_GEM]  				= SI_ITEMTYPE19, 
[ITEMTYPE_GLYPH_WEAPON]  			= SI_ITEMTYPE20, 
[ITEMTYPE_GLYPH_ARMOR]  			= SI_ITEMTYPE21, 
[ITEMTYPE_LOCKPICK]  				= SI_ITEMTYPE22, 
[ITEMTYPE_WEAPON_BOOSTER]  			= SI_ITEMTYPE23, 
[ITEMTYPE_ARMOR_BOOSTER] 			= SI_ITEMTYPE24, 
[ITEMTYPE_ENCHANTMENT_BOOSTER] 		= SI_ITEMTYPE25, 
[ITEMTYPE_GLYPH_JEWELRY]  			= SI_ITEMTYPE26, 
[ITEMTYPE_SPICE]  					= SI_ITEMTYPE27, 
[ITEMTYPE_FLAVORING]  				= SI_ITEMTYPE28, 
[ITEMTYPE_RECIPE]  					= SI_ITEMTYPE29, 
[ITEMTYPE_POISON] 					= SI_ITEMTYPE30, 
[ITEMTYPE_REAGENT] 					= SI_ITEMTYPE31, 
[ITEMTYPE_DEPRECATED] 				= SI_ITEMTYPE32, 
[ITEMTYPE_ALCHEMY_BASE] 			= SI_ITEMTYPE33, 
[ITEMTYPE_COLLECTIBLE] 				= SI_ITEMTYPE34, 
[ITEMTYPE_BLACKSMITHING_RAW_MATERIAL] = SI_ITEMTYPE35, 
[ITEMTYPE_BLACKSMITHING_MATERIAL] 	= SI_ITEMTYPE36, 
[ITEMTYPE_WOODWORKING_RAW_MATERIAL] = SI_ITEMTYPE37, 
[ITEMTYPE_WOODWORKING_MATERIAL] 	= SI_ITEMTYPE38, 
[ITEMTYPE_CLOTHIER_RAW_MATERIAL] 	= SI_ITEMTYPE39, 
[ITEMTYPE_CLOTHIER_MATERIAL] 		= SI_ITEMTYPE40, 
[ITEMTYPE_BLACKSMITHING_BOOSTER] 	= SI_ITEMTYPE41, 
[ITEMTYPE_WOODWORKING_BOOSTER] 		= SI_ITEMTYPE42, 
[ITEMTYPE_CLOTHIER_BOOSTER] 		= SI_ITEMTYPE43, 
[ITEMTYPE_STYLE_MATERIAL] 			= SI_ITEMTYPE44, 
[ITEMTYPE_ARMOR_TRAIT] 				= SI_ITEMTYPE45, 
[ITEMTYPE_WEAPON_TRAIT] 			= SI_ITEMTYPE46, 
[ITEMTYPE_AVA_REPAIR] 				= SI_ITEMTYPE47, 
[ITEMTYPE_TRASH] 					= SI_ITEMTYPE48, 
[ITEMTYPE_SPELLCRAFTING_TABLET] 	= SI_ITEMTYPE49, 
[ITEMTYPE_MOUNT] 					= SI_ITEMTYPE50, 
[ITEMTYPE_ENCHANTING_RUNE_POTENCY] 	= SI_ITEMTYPE51, 
[ITEMTYPE_ENCHANTING_RUNE_ASPECT] 	= SI_ITEMTYPE52, 
[ITEMTYPE_ENCHANTING_RUNE_ESSENCE] 	= SI_ITEMTYPE53 
}

LibReader.Str_Equipment_Type = {
[EQUIP_TYPE_INVALID]	= "",
[EQUIP_TYPE_HEAD] 		= SI_EQUIPTYPE1, 
[EQUIP_TYPE_NECK] 		= SI_EQUIPTYPE2, 
[EQUIP_TYPE_CHEST] 		= SI_EQUIPTYPE3, 
[EQUIP_TYPE_SHOULDERS] 	= SI_EQUIPTYPE4, 
[EQUIP_TYPE_ONE_HAND] 	= SI_EQUIPTYPE5, 
[EQUIP_TYPE_TWO_HAND] 	= SI_EQUIPTYPE6, 
[EQUIP_TYPE_OFF_HAND] 	= SI_EQUIPTYPE7, 
[EQUIP_TYPE_WAIST] 		= SI_EQUIPTYPE8,
[EQUIP_TYPE_LEGS] 		= SI_EQUIPTYPE9, 
[EQUIP_TYPE_FEET] 		= SI_EQUIPTYPE10, 
[EQUIP_TYPE_COSTUME] 	= SI_EQUIPTYPE11, 
[EQUIP_TYPE_RING] 		= SI_EQUIPTYPE12, 
[EQUIP_TYPE_HAND] 		= SI_EQUIPTYPE13, 
[EQUIP_TYPE_MAIN_HAND] 	= SI_EQUIPTYPE14, 
}

LibReader.Str_Equipment_Slot = { 
[EQUIP_SLOT_HEAD] 			= SI_EQUIPSLOT0, 
[EQUIP_SLOT_NECK] 			= SI_EQUIPSLOT1, 
[EQUIP_SLOT_CHEST] 			= SI_EQUIPSLOT2, 
[EQUIP_SLOT_SHOULDERS] 		= SI_EQUIPSLOT3, 
[EQUIP_SLOT_MAIN_HAND] 		= SI_EQUIPSLOT4, 
[EQUIP_SLOT_OFF_HAND] 		= SI_EQUIPSLOT5, 
[EQUIP_SLOT_WAIST] 			= SI_EQUIPSLOT6, 
[EQUIP_SLOT_WRIST] 			= SI_EQUIPSLOT7, 
[EQUIP_SLOT_LEGS] 			= SI_EQUIPSLOT8,
[EQUIP_SLOT_FEET] 			= SI_EQUIPSLOT9, 
[EQUIP_SLOT_COSTUME] 		= SI_EQUIPSLOT10, 
[EQUIP_SLOT_RING1] 			= SI_EQUIPSLOT11, 
[EQUIP_SLOT_RING2] 			= SI_EQUIPSLOT12, 
[EQUIP_SLOT_TRINKET1] 		= SI_EQUIPSLOT13, 
[EQUIP_SLOT_TRINKET2] 		= SI_EQUIPSLOT14, 
[EQUIP_SLOT_RANGED] 		= SI_EQUIPSLOT15, 
[EQUIP_SLOT_HAND] 			= SI_EQUIPSLOT16, 
[EQUIP_SLOT_CLASS1] 		= SI_EQUIPSLOT17, 
[EQUIP_SLOT_CLASS2] 		= SI_EQUIPSLOT18, 
[EQUIP_SLOT_CLASS3] 		= SI_EQUIPSLOT19, 
[EQUIP_SLOT_BACKUP_MAIN] 	= SI_EQUIPSLOT20, 
[EQUIP_SLOT_BACKUP_OFF] 	= SI_EQUIPSLOT21 
}

LibReader.Equipment_Type_In_Slot = {
[EQUIP_SLOT_MAIN_HAND]  = { EQUIP_TYPE_MAIN_HAND, EQUIP_TYPE_ONE_HAND, EQUIP_TYPE_TWO_HAND },			-- To those who know where I got this: I have absolutely no clue how to credit, ask, or otherwise do right
[EQUIP_SLOT_OFF_HAND]   = { EQUIP_TYPE_OFF_HAND, EQUIP_TYPE_ONE_HAND },								-- by the authors and the community.
[EQUIP_SLOT_BACKUP_MAIN]= { EQUIP_TYPE_MAIN_HAND, EQUIP_TYPE_ONE_HAND, EQUIP_TYPE_TWO_HAND },			-- So I'm simply going to say: "This isn't mine, and it's too gods-damned useful to leave it out."
[EQUIP_SLOT_BACKUP_OFF] = { EQUIP_TYPE_OFF_HAND, EQUIP_TYPE_ONE_HAND },									-- I only changed the name and reformatted it a little.
[EQUIP_SLOT_HEAD]       = { EQUIP_TYPE_HEAD },
[EQUIP_SLOT_CHEST]      = { EQUIP_TYPE_CHEST },
[EQUIP_SLOT_SHOULDERS]  = { EQUIP_TYPE_SHOULDERS},
[EQUIP_SLOT_WAIST]      = { EQUIP_TYPE_WAIST },
[EQUIP_SLOT_HAND]       = { EQUIP_TYPE_HAND },
[EQUIP_SLOT_LEGS]       = { EQUIP_TYPE_LEGS },
[EQUIP_SLOT_FEET]       = { EQUIP_TYPE_FEET },
[EQUIP_SLOT_COSTUME]    = { EQUIP_TYPE_COSTUME },
[EQUIP_SLOT_NECK]       = { EQUIP_TYPE_NECK },
[EQUIP_SLOT_RING1]      = { EQUIP_TYPE_RING },
[EQUIP_SLOT_RING2]      = { EQUIP_TYPE_RING },
}

LibReader.Str_Item_Trait = { 
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

LibReader.Str_Item_Quality = { 
[ITEM_QUALITY_NORMAL] 					= SI_ITEMQUALITY1, 
[ITEM_QUALITY_MAGIC] 					= SI_ITEMQUALITY2, 
[ITEM_QUALITY_ARCANE] 					= SI_ITEMQUALITY3, 
[ITEM_QUALITY_ARTIFACT] 				= SI_ITEMQUALITY4, 
[ITEM_QUALITY_LEGENDARY] 				= SI_ITEMQUALITY5,
[ITEM_QUALITY_TRASH] 					= SI_ITEMQUALITY0,
}

--[[
LibReader.Str_Item_Style = { 
[ITEMSTYLE_NONE] 					= SI_ITEMSTYLE0, 
[ITEMSTYLE_RACIAL_BRETON] 			= SI_ITEMSTYLE1, 
[ITEMSTYLE_RACIAL_REDGUARD] 		= SI_ITEMSTYLE2, 
[ITEMSTYLE_RACIAL_ORC] 				= SI_ITEMSTYLE3, 
[ITEMSTYLE_RACIAL_DARK_ELF] 		= SI_ITEMSTYLE4, 
[ITEMSTYLE_RACIAL_NORD] 			= SI_ITEMSTYLE5, 
[ITEMSTYLE_RACIAL_ARGONIAN] 		= SI_ITEMSTYLE6, 
[ITEMSTYLE_RACIAL_HIGH_ELF] 		= SI_ITEMSTYLE7, 
[ITEMSTYLE_RACIAL_WOOD_ELF] 		= SI_ITEMSTYLE8, 
[ITEMSTYLE_RACIAL_KHAJIIT] 			= SI_ITEMSTYLE9, 
[ITEMSTYLE_UNIQUE] 					= SI_ITEMSTYLE10, 
[ITEMSTYLE_ORG_THIEVES_GUILD] 		= SI_ITEMSTYLE11, 
[ITEMSTYLE_ORG_DARK_BROTHERHOOD] 	= SI_ITEMSTYLE12, 
[ITEMSTYLE_DEPRECATED1] 			= SI_ITEMSTYLE13, 
[ITEMSTYLE_AREA_DWEMER] 			= SI_ITEMSTYLE14, 
[ITEMSTYLE_AREA_ANCIENT_ELF] 		= SI_ITEMSTYLE15, 
[ITEMSTYLE_AREA_IMPERIAL] 			= SI_ITEMSTYLE16, 
[ITEMSTYLE_AREA_REACH] 				= SI_ITEMSTYLE17, 
[ITEMSTYLE_ENEMY_BANDIT] 			= SI_ITEMSTYLE18, 
[ITEMSTYLE_ENEMY_PRIMITIVE] 		= SI_ITEMSTYLE19, 
[ITEMSTYLE_ENEMY_DAEDRIC] 			= SI_ITEMSTYLE20, 
[ITEMSTYLE_DEPRECATED2] 			= SI_ITEMSTYLE21, 
[ITEMSTYLE_DEPRECATED3] 			= SI_ITEMSTYLE22, 
[ITEMSTYLE_DEPRECATED4] 			= SI_ITEMSTYLE23, 
[ITEMSTYLE_DEPRECATED5] 			= SI_ITEMSTYLE24, 
[ITEMSTYLE_DEPRECATED6]	 			= SI_ITEMSTYLE25, 
[ITEMSTYLE_DEPRECATED7] 			= SI_ITEMSTYLE26, 
[ITEMSTYLE_RAIDS_CRAGLORN] 			= SI_ITEMSTYLE27, 
-- [ITEMSTYLE_DEPRECATED8] 			= SI_ITEMSTYLE28, 
[ITEMSTYLE_DEPRECATED9] 			= SI_ITEMSTYLE29, 
[ITEMSTYLE_AREA_SOUL_SHRIVEN] 		= SI_ITEMSTYLE30,
[ITEMSTYLE_ENEMY_DRAUGR] 			= SI_ITEMSTYLE31, 
[ITEMSTYLE_ENEMY_MAORMER] 			= SI_ITEMSTYLE32, 
[ITEMSTYLE_AREA_AKAVIRI] 			= SI_ITEMSTYLE33, 
[ITEMSTYLE_RACIAL_IMPERIAL] 		= SI_ITEMSTYLE34, 
[ITEMSTYLE_AREA_YOKUDAN] 			= SI_ITEMSTYLE35,
}

]]

LibReader.Str_Item_Style_Chapter = {
[ITEM_STYLE_CHAPTER_ALL] 			= SI_ITEMSTYLECHAPTER0,
[ITEM_STYLE_CHAPTER_HELMETS] 		= SI_ITEMSTYLECHAPTER1,
[ITEM_STYLE_CHAPTER_GLOVES] 		= SI_ITEMSTYLECHAPTER2,
[ITEM_STYLE_CHAPTER_BOOTS] 			= SI_ITEMSTYLECHAPTER3,
[ITEM_STYLE_CHAPTER_LEGS] 			= SI_ITEMSTYLECHAPTER4,
[ITEM_STYLE_CHAPTER_CHESTS] 		= SI_ITEMSTYLECHAPTER5,
[ITEM_STYLE_CHAPTER_BELTS] 			= SI_ITEMSTYLECHAPTER6,
[ITEM_STYLE_CHAPTER_SHOULDERS] 		= SI_ITEMSTYLECHAPTER7,
[ITEM_STYLE_CHAPTER_SWORDS] 		= SI_ITEMSTYLECHAPTER8,
[ITEM_STYLE_CHAPTER_MACES] 			= SI_ITEMSTYLECHAPTER9,
[ITEM_STYLE_CHAPTER_AXES] 			= SI_ITEMSTYLECHAPTER10,
[ITEM_STYLE_CHAPTER_DAGGERS] 		= SI_ITEMSTYLECHAPTER11,
[ITEM_STYLE_CHAPTER_STAVES] 		= SI_ITEMSTYLECHAPTER12,
[ITEM_STYLE_CHAPTER_SHIELDS] 		= SI_ITEMSTYLECHAPTER13,
[ITEM_STYLE_CHAPTER_BOWS] 			= SI_ITEMSTYLECHAPTER14,
}

LibReader.Str_Armor_Type = { 
[ARMORTYPE_NONE] 					= GetString(SI_ARMORTYPE0), 
[ARMORTYPE_LIGHT] 					= GetString(SI_ARMORTYPE1), 
[ARMORTYPE_MEDIUM] 					= GetString(SI_ARMORTYPE2), 
[ARMORTYPE_HEAVY] 					= GetString(SI_ARMORTYPE3), 
}

LibReader.Str_Weapon_Type = { 
[WEAPONTYPE_NONE] 					= GetString(SI_WEAPONTYPE0), 
[WEAPONTYPE_AXE] 					= GetString(SI_WEAPONTYPE1), 
[WEAPONTYPE_HAMMER] 				= GetString(SI_WEAPONTYPE2), 
[WEAPONTYPE_SWORD] 					= GetString(SI_WEAPONTYPE3), 
[WEAPONTYPE_TWO_HANDED_SWORD] 		= GetString(SI_WEAPONTYPE4), 
[WEAPONTYPE_TWO_HANDED_AXE] 		= GetString(SI_WEAPONTYPE5), 
[WEAPONTYPE_TWO_HANDED_HAMMER] 		= GetString(SI_WEAPONTYPE6), 
[WEAPONTYPE_PROP] 					= GetString(SI_WEAPONTYPE7), 
[WEAPONTYPE_BOW] 					= GetString(SI_WEAPONTYPE8), 
[WEAPONTYPE_HEALING_STAFF] 			= GetString(SI_WEAPONTYPE9), 
[WEAPONTYPE_RUNE] 					= GetString(SI_WEAPONTYPE10), 
[WEAPONTYPE_DAGGER] 				= GetString(SI_WEAPONTYPE11), 
[WEAPONTYPE_FIRE_STAFF] 			= GetString(SI_WEAPONTYPE12), 
[WEAPONTYPE_FROST_STAFF] 			= GetString(SI_WEAPONTYPE13), 
[WEAPONTYPE_SHIELD] 				= GetString(SI_WEAPONTYPE14), 
[WEAPONTYPE_LIGHTNING_STAFF] 		= GetString(SI_WEAPONTYPE15),
}

LibReader.Guild_Events = { 																								-- FYI, these don't have descriptive SI_'s. Event SI_'s are meant to take arguments from
GUILD_EVENT_GUILD_INVITE, 																								-- the event to complete a sentence. Putting them here would be an exercise in Mad Libs.
GUILD_EVENT_GUILD_REMOVE, 
GUILD_EVENT_GUILD_PROMOTE, 
GUILD_EVENT_GUILD_DEMOTE, 
GUILD_EVENT_GUILD_CREATE, 
GUILD_EVENT_GUILD_DELETE, 
GUILD_EVENT_GUILD_JOIN, 
GUILD_EVENT_GUILD_LEAVE, 
GUILD_EVENT_GUILD_INVITEREVOKED, 
GUILD_EVENT_GUILD_INVITEDECLINED, 
GUILD_EVENT_GUILD_INVITEPURGED, 
GUILD_EVENT_GUILD_KICKED, 
GUILD_EVENT_BANKITEM_ADDED, 
GUILD_EVENT_BANKITEM_REMOVED, 
GUILD_EVENT_ITEM_SOLD, 
GUILD_EVENT_KEEP_CLAIMED, 
GUILD_EVENT_KEEP_LOST, 
GUILD_EVENT_NAME_CHANGED, 
GUILD_EVENT_KEEP_RELEASED, 
GUILD_EVENT_HERALDRY_EDITED, 
GUILD_EVENT_BANKGOLD_ADDED, 
GUILD_EVENT_BANKGOLD_REMOVED, 
GUILD_EVENT_BANKGOLD_KIOSK_BID_REFUND, 
GUILD_EVENT_BANKGOLD_KIOSK_BID, 
GUILD_EVENT_GUILD_KIOSK_PURCHASED, 
GUILD_EVENT_BANKGOLD_PURCHASE_HERALDRY, 
GUILD_EVENT_BATTLE_STANDARD_PICKUP, 
GUILD_EVENT_BATTLE_STANDARD_PUTDOWN, 
GUILD_EVENT_BANKGOLD_GUILD_STORE_TAX, 
GUILD_EVENT_GUILD_KIOSK_PURCHASE_REFUND, 
GUILD_EVENT_MOTD_EDITED, 
GUILD_EVENT_ABOUT_US_EDITED, 
GUILD_EVENT_GUILD_STORE_UNLOCKED, 
GUILD_EVENT_GUILD_STORE_LOCKED, 
GUILD_EVENT_GUILD_BANK_UNLOCKED, 
GUILD_EVENT_GUILD_BANK_LOCKED, 
GUILD_EVENT_GUILD_STANDARD_UNLOCKED, 
GUILD_EVENT_GUILD_STANDARD_LOCKED, 
GUILD_EVENT_GUILD_TABARD_UNLOCKED, 
GUILD_EVENT_GUILD_TABARD_LOCKED,
GUILD_EVENT_ITEM_LISTED, 
GUILD_EVENT_GUILD_KIOSK_UNLOCKED, 
GUILD_EVENT_GUILD_KIOSK_LOCKED 
}

LibReader.Str_Guild_History_Categories = { 
[GUILD_HISTORY_GENERAL] 		= SI_GUILDHISTORYCATEGORY1, 
[GUILD_HISTORY_BANK] 			= SI_GUILDHISTORYCATEGORY2, 
[GUILD_HISTORY_STORE] 			= SI_GUILDHISTORYCATEGORY3, 
[GUILD_HISTORY_COMBAT] 			= SI_GUILDHISTORYCATEGORY4, 
[GUILD_HISTORY_ALLIANCE_WAR] 	= SI_GUILDHISTORYCATEGORY5 
}

LibReader.Str_Guild_History_SubCats = { 
	[GUILD_HISTORY_GENERAL] = { 
		[GUILD_HISTORY_GENERAL_ROSTER] = SI_GUILDHISTORYGENERALSUBCATEGORIES1, 
		[GUILD_HISTORY_GENERAL_CUSTOMIZATION] = SI_GUILDHISTORYGENERALSUBCATEGORIES2, 
		[GUILD_HISTORY_GENERAL_UNLOCKS] = SI_GUILDHISTORYGENERALSUBCATEGORIES3 }, 
	[GUILD_HISTORY_BANK] = { 
		[GUILD_HISTORY_BANK_DEPOSITS] = SI_GUILDHISTORYBANKSUBCATEGORIES1,  
		[GUILD_HISTORY_BANK_WITHDRAWALS] = SI_GUILDHISTORYBANKSUBCATEGORIES2 }, 
	[GUILD_HISTORY_STORE] = { 
		[GUILD_HISTORY_STORE_PURCHASES] = SI_GUILDHISTORYSTORESUBCATEGORIES1, 
		[GUILD_HISTORY_STORE_HIRED_TRADER] = SI_GUILDHISTORYSTORESUBCATEGORIES2 },
	[GUILD_HISTORY_COMBAT] = {},																												-- Empty SubCat, as of Update 4
	[GUILD_HISTORY_ALLIANCE_WAR] = { 
		[GUILD_HISTORY_ALLIANCE_WAR_OWNERSHIP] = SI_GUILDHISTORYALLIANCEWARSUBCATEGORIES1 },
}

LibReader.Format_Guild_Events = { 																												-- I suppose I could just use this for guild events table, but that
--																																				-- sounds awfully involved.
[0]  							= { GetGuildName(GuildId), LibReader:FormatHistoryCategory(CatId), timestamp, eventType, param1, param2, param3, param4, param5, param6 },	-- Default
[GUILD_EVENT_BANKITEM_ADDED] 	= { GetGuildName(guildId), LibReader:FormatHistoryCategory(CatId), timestamp, eventType, param1, param2, param3 },
[GUILD_EVENT_BANKITEM_REMOVED] 	= { GetGuildName(guildId), LibReader:FormatHistoryCategory(CatId), timestamp, eventType, param1, param2, param3 },
[GUILD_EVENT_ITEM_SOLD] 		= { GetGuildName(guildId), LibReader:FormatHistoryCategory(CatId), timestamp, eventType, param1, param2, param3, param4, param5, param6 },
[GUILD_EVENT_BANKGOLD_ADDED] 	= { GetGuildName(guildId), LibReader:FormatHistoryCategory(CatId), timestamp, eventType, param1, param2, param3 },	
[GUILD_EVENT_BANKGOLD_REMOVED] 	= { GetGuildName(guildId), LibReader:FormatHistoryCategory(CatId), LibReader:FormatHistorySubCategory(2), timestamp, eventType, param1, param2, param3 },
}


--------------------------------------------------------------------------------------------------
-----------------------------------------   Parsers   --------------------------------------------
--------------------------------------------------------------------------------------------------

function LibReader:GetGuildNames()
	local NumGuilds = GetNumGuilds()
	local lNames, sNames = {}, {}
		
	for GuildId = 1, NumGuilds do
		sNames[GuildId] = GetGuildName(GuildId)
		lNames[GuildId] = zo_strformat(SI_GUILD_SELECTOR_FORMAT, GetAllianceBannerIcon(GetGuildAlliance(GuildId)), GuildId, sNames[GuildId])
	end
	
	return lNames, sNames, NumGuilds
end


local function GetInfoFromRowControl(rowControl)
	--gotta do this in case deconstruction...
	local dataEntry = rowControl.dataEntry
	local bagId, slotIndex 

	--case to handle equiped items
	if(not dataEntry) then
		bagId = rowControl.bagId
		slotIndex = rowControl.slotIndex
	else
		bagId = dataEntry.data.bagId
		slotIndex = dataEntry.data.slotIndex
	end

	--case to handle list dialog, list dialog uses index instead of slotIndex and bag instead of badId...?
	if(dataEntry and not bagId and not slotIndex) then 
		bagId = rowControl.dataEntry.data.bag
		slotIndex = rowControl.dataEntry.data.index
	end

	return bagId, slotIndex
end


function LibReader:GetItemLinkFromSlotControl(slotControl)
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

function LibReader:GetItemLinkFromSlot(inventorySlot)
	local SlotType = inventorySlot.slotType
	
	if SlotType == ( SLOT_TYPE_ITEM or SLOT_TYPE_BANK_ITEM or SLOT_TYPE_GUILD_BANK_ITEM or
	SLOT_TYPE_EQUIPMENT or SLOT_TYPE_TRADING_HOUSE_POST_ITEM or SLOT_TYPE_REPAIR or 
	SLOT_TYPE_DYEABLE_EQUIPMENT	) then
		return GetItemLink(inventorySlot.bagId, inventorySlot.slotIndex)
		
	elseif SlotType == SLOT_TYPE_LOOT then
		return GetLootItemLink(inventorySlot.lootEntry.lootId)
	
	elseif SlotType == SLOT_TYPE_TRADING_HOUSE_ITEM_RESULT then
		return GetTradingHouseSearchResultItemLink(inventorySlot.slotIndex)
	
	elseif SlotType == SLOT_TYPE_TRADING_HOUSE_ITEM_LISTING then
		return GetTradingHouseListingItemLink(inventorySlot.slotIndex)
	
	elseif SlotType == SLOT_TYPE_STORE_BUY then
		return GetStoreItemLink(inventorySlot.index)
	
	elseif SlotType == SLOT_TYPE_STORE_BUYBACK then
		return GetBuybackItemLink(inventorySlot.index)
	end
	
	return ""
end

function LibReader:ParseItemLinkToTable(itemLink)
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

function LibReader:GetLinkValue(itemLink, place)
	if not itemLink then return nil end
	local LinkTable = self:ParseItemLinkToTable(itemLink)
	
	if (place <= 21 and place >= 1) then
		local val = tonumber(LinkTable[place])
		return val
	else
		return nil
	end
end

function LibReader:GetItemLinkLevel(itemLink)
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

function LibReader:GetItemLinkQuality(itemLink)
	if not itemLink then return nil end
	local iQuality = GetItemLinkQuality(itemLink)
	
	return iQuality, zo_strformat(self.Str_Item_Quality[iQuality])
end

function LibReader:GetItemLinkEnchantInfo(itemLink)
	if not itemLink then return nil end
	local HasEnchant, iChant, iChantSomeMore = GetItemLinkEnchantInfo(itemLink)
	
	return iChant, zo_strformat(SI_ITEM_FORMAT_STR_ENCHANT, iChant)
end

--[[

function LibReader:GetItemLinkStyle(itemLink)
	if not itemLink then return nil end
	local iStyle = select(5, GetItemLinkInfo(itemLink))
	
	return iStyle, zo_strformat(self.Str_Item_Style[iStyle])
end
]]

function LibReader:GetItemLinkTrait(itemLink)
	if not itemLink then return nil end
	local iTrait = select(1, GetItemLinkTraitInfo(itemLink))
	
	return iTrait, zo_strformat(self.Str_Item_Trait[iTrait])
end

function LibReader:GetItemLinkSetItem(itemLink)
	if not itemLink then return nil end
	local iHasSet, setName = GetItemLinkSetInfo(itemLink)
	if not iHasSet then iHasSet = 0 else iHasSet = 1 end
	return iHasSet, zo_strformat(SI_ITEM_FORMAT_STR_SET_NAME, setName)
end

function LibReader:GetItemLinkItemType(itemLink)
	if not itemLink then return nil end
	local iType = GetItemLinkItemType(itemLink)
	
	return iType, zo_strformat(self.Str_Item_Types[iType])
end

function LibReader:GetItemLinkWeaponType(itemLink)
	if not itemLink then return nil end
	local eWeapon = GetItemLinkWeaponType(itemLink)
	
	return eWeapon, self.Str_Weapon_Type[eWeapon]
end

function LibReader:GetItemLinkArmorType(itemLink)
	if not itemLink then return nil end
	local eArmor = GetItemLinkArmorType(itemLink)

	return eArmor, self.Str_Armor_Type[eArmor]
end

function LibReader:GetItemLinkEquipType(itemLink)
	if not itemLink then return nil end
	local eEquip = GetItemLinkEquipType(itemLink)

	return eEquip, zo_strformat(self.Str_Equipment_Type[eEquip])
end

function LibReader:GetItemLinkSlots(itemLink)
	if not itemLink then return nil end
	local eSlot1, eSlot2 = GetComparisonEquipSlotsFromItemLink(itemLink)

	return eSlot1, eSlot2, zo_strformat(self.Str_Equipment_Slot[eSlot1]), zo_strformat(self.Str_Equipment_Slot[eSlot2])
end

function LibReader:FormatHistoryCategory(CatId)
	if not CatId then return nil end
	
	return zo_strformat(self.Str_Guild_History_Categories[CatId])
end

function LibReader:FormatHistorySubCategory(CatId, SubCatId)
	if not SubCatId or not CatId then return nil end
	
	return zo_strformat(Str_Guild_History_SubCats[CatId][SubCatId])
end

function LibReader:FormatGuildEventType(eventType)
	if not eventType then 
		return nil
	end
	
	return self.Guild_Events[eventType]
end

function LibReader:FormatGuildEvent(GuildId, CatId, timestamp, eventType, param1, param2, param3, param4, param5, param6)
	if not GuildId or not CatId or not timestamp or not eventType or not param1 or not param2 or not param3 then return nil end

	if self.Format_Guild_Events[eventType] == nil then
		return self.Format_Guild_Events[0]
	else
		return self.Format_Guild_Events[eventType]
	end
end


--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------