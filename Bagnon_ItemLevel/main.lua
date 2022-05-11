if (not Bagnon) then
	return
end
if (function(addon)
	for i = 1,GetNumAddOns() do
		local name, _, _, loadable = GetAddOnInfo(i)
		if (name:lower() == addon:lower()) then
			local enabled = not(GetAddOnEnableState(UnitName("player"), i) == 0)
			if (enabled and loadable) then
				return true
			end
		end
	end
end)("Bagnon_ItemInfo") then
	print("|cffff1111"..(...).." was auto-disabled.")
	return
end

local MODULE =  ...
local ADDON, Addon = MODULE:match("[^_]+"), _G[MODULE:match("[^_]+")]
local Module = Bagnon:NewModule("ItemLevel", Addon)

-- Tooltip used for scanning
local ScannerTipName = "BagnonItemInfoScannerTooltip"
local ScannerTip = _G[ScannerTipName] or CreateFrame("GameTooltip", ScannerTipName, WorldFrame, "GameTooltipTemplate")

-- Lua API
local _G = _G
local select = select
local string_find = string.find
local string_gsub = string.gsub
local string_lower = string.lower
local string_match = string.match
local string_split = string.split
local string_upper = string.upper
local tonumber = tonumber

-- WoW API
local CreateFrame = _G.CreateFrame
local GetDetailedItemLevelInfo = _G.GetDetailedItemLevelInfo
local GetItemInfo = _G.GetItemInfo
local GetItemQualityColor = _G.GetItemQualityColor
local IsArtifactRelicItem = _G.IsArtifactRelicItem

-- Tooltip and scanning by Phanx @ http://www.wowinterface.com/forums/showthread.php?p=271406
local S_ITEM_LEVEL = "^" .. string_gsub(_G.ITEM_LEVEL, "%%d", "(%%d+)")

-- Redoing this to take other locales into consideration,
-- and to make sure we're capturing the slot count, and not the bag type.
local S_CONTAINER_SLOTS = "^" .. (string_gsub(string_gsub(CONTAINER_SLOTS, "%%([%d%$]-)d", "(%%d+)"), "%%([%d%$]-)s", "%.+"))
--local S_CONTAINER_SLOTS = "^" .. string_gsub(string_gsub(_G.CONTAINER_SLOTS, "%%d", "(%%d+)"), "%%s", "(%.+)")

-- FontString Caches
local Cache_ItemLevel = {}


-----------------------------------------------------------
-- Slash Command & Options Handling
-----------------------------------------------------------
do
	-- Saved settings
	BagnonItemLevel_DB = {
		enableRarityColoring = true
	}

	local slashCommand = function(msg, editBox)
		local action, element

		-- Remove spaces at the start and end
		msg = string_gsub(msg, "^%s+", "")
		msg = string_gsub(msg, "%s+$", "")

		-- Replace all space characters with single spaces
		msg = string_gsub(msg, "%s+", " ")

		-- Extract the arguments
		if string_find(msg, "%s") then
			action, element = string_split(" ", msg)
		else
			action = msg
		end

		if (action == "enable") then
			if (element == "color") then
				BagnonItemLevel_DB.enableRarityColoring = true
			end

		elseif (action == "disable") then
			if (element == "color") then
				BagnonItemLevel_DB.enableRarityColoring = false
			end
		end
	end

	-- Create a unique name for the command
	local commands = { "bagnonitemlevel", "bilvl", "bil" }
	for i = 1,#commands do
		-- Register the chat command, keep hash upper case, value lowercase
		local command = commands[i]
		local name = "AZERITE_TEAM_PLUGIN_"..string_upper(command)
		_G["SLASH_"..name.."1"] = "/"..string_lower(command)
		_G.SlashCmdList[name] = slashCommand
	end
end


-----------------------------------------------------------
-- Cache & Creation
-----------------------------------------------------------
-- Retrieve a button's plugin container
local GetPluginContainter = function(button)
	local name = button:GetName() .. "ExtraInfoFrame"
	local frame = _G[name]
	if (not frame) then
		frame = CreateFrame("Frame", name, button)
		frame:SetAllPoints()
	end
	return frame
end

local Cache_GetItemLevel = function(button)
	if (not Cache_ItemLevel[button]) then
		local ItemLevel = GetPluginContainter(button):CreateFontString()
		ItemLevel:SetDrawLayer("ARTWORK", 1)
		ItemLevel:SetPoint("TOPLEFT", 2, -2)
		ItemLevel:SetFontObject(_G.NumberFont_Outline_Med or _G.NumberFontNormal)
		ItemLevel:SetShadowOffset(1, -1)
		ItemLevel:SetShadowColor(0, 0, 0, .5)
		local UpgradeIcon = button.UpgradeIcon
		if UpgradeIcon then
			UpgradeIcon:ClearAllPoints()
			UpgradeIcon:SetPoint("BOTTOMRIGHT", 2, 0)
		end
		Cache_ItemLevel[button] = ItemLevel
	end
	return Cache_ItemLevel[button]
end

-----------------------------------------------------------
-- Main Update
-----------------------------------------------------------
local Update = function(self)
	local displayMsg, displayR, displayG, displayB
	local itemLink = self:GetItem()
	if (itemLink) then
		local _, _, itemRarity, itemLevel, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)
		local isBattlePet, battlePetLevel, battlePetRarity
		if (string_find(itemLink, "battlepet")) then
			local data, name = string_match(itemLink, "|H(.-)|h(.-)|h")
			local  _, _, level, rarity = string_match(data, "(%w+):(%d+):(%d+):(%d+)")
			isBattlePet, battlePetLevel, battlePetRarity = true, level or 1, tonumber(rarity) or 0
		end
		local itemID = tonumber(string_match(itemLink, "item:(%d+)"))

		-- Display container slots
		-- of equipped bags.
		if (itemEquipLoc == "INVTYPE_BAG") then
			local bag,slot = self:GetBag(),self:GetID()
			ScannerTip.owner = self
			ScannerTip.bag = bag
			ScannerTip.slot = slot
			ScannerTip:SetOwner(self, "ANCHOR_NONE")
			ScannerTip:SetBagItem(bag,slot)

			for i = 3,4 do
				local line = _G[ScannerTipName.."TextLeft"..i]
				if (line) then
					local msg = line:GetText()
					if (msg) and (string_find(msg, S_CONTAINER_SLOTS)) then
						local bagSlots = string_match(msg, S_CONTAINER_SLOTS)
						if (bagSlots) and (tonumber(bagSlots) > 0) then
							displayMsg = bagSlots
						end
						break
					end
				end
			end

		-- Display item level of equippable gear,
		-- artifact relics, and battle pet level.
		elseif ((itemRarity and itemRarity > 0) and ((itemEquipLoc and _G[itemEquipLoc]) or (itemID and IsArtifactRelicItem and IsArtifactRelicItem(itemID)))) or (isBattlePet) then

			local scannedLevel
			if (not isBattlePet) then
				local bag,slot = self:GetBag(),self:GetID()
				ScannerTip.owner = self
				ScannerTip.bag = bag
				ScannerTip.slot = slot
				ScannerTip:SetOwner(self, "ANCHOR_NONE")
				ScannerTip:SetBagItem(bag,slot)

				-- Check line 3 as well,
				-- some artifacts have the ilevel there.
				for i = 2,3 do
					local line = _G[ScannerTipName.."TextLeft"..i]
					if (line) then
						local msg = line:GetText()
						if (msg) and (string_find(msg, S_ITEM_LEVEL)) then
							local ilvl = (string_match(msg, S_ITEM_LEVEL))
							if (ilvl) and (tonumber(ilvl) > 0) then
								scannedLevel = ilvl
							end
							break
						end
					end
				end
			end

			displayR, displayG, displayB = GetItemQualityColor(battlePetRarity or itemRarity)
			displayMsg = scannedLevel or battlePetLevel or GetDetailedItemLevelInfo(itemLink) or itemLevel or ""
		end
	end

	if (displayMsg) then
		local ItemLevel = Cache_ItemLevel[self] or Cache_GetItemLevel(self)
		if (BagnonItemLevel_DB.enableRarityColoring) and (displayR) and (displayG) and (displayB) then
			ItemLevel:SetTextColor(displayR, displayG, displayB)
		else
			ItemLevel:SetTextColor(240/255, 240/255, 240/255)
		end
		ItemLevel:SetText(displayMsg)
	elseif (Cache_ItemLevel[self]) then
		Cache_ItemLevel[self]:SetText("")
	end
end

local item = Bagnon.ItemSlot or Bagnon.Item
if (item) and (item.Update) then
	hooksecurefunc(item, "Update", Update)
end