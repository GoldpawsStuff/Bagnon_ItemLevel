if (not Bagnon) then
	return
end
if (function(addon)
	for i = 1,GetNumAddOns() do
		if (string.lower((GetAddOnInfo(i))) == string.lower(addon)) then
			if (GetAddOnEnableState(UnitName("player"), i) ~= 0) then
				return true
			end
		end
	end
end)("Bagnon_ItemInfo") then 
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
local string_match = string.match
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
--local S_CONTAINER_SLOTS = "^" .. string_gsub(string_gsub(_G.CONTAINER_SLOTS, "%%d", "(%%d+)"), "%%s", "(%.+)")
local S_CONTAINER_SLOTS = "^" .. (string.gsub(string.gsub(CONTAINER_SLOTS, "%%([%d%$]-)d", "(%%d+)"), "%%([%d%$]-)s", "%.+"))

-- FontString Caches
local Cache_ItemLevel = {}

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
		local itemName, _itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice, itemClassID, itemSubClassID, bindType, expacID, itemSetID, isCraftingReagent = GetItemInfo(itemLink)
		local isBattlePet, battlePetLevel, battlePetRarity
		if (string_find(itemLink, "battlepet")) then
			local data, name = string_match(itemLink, "|H(.-)|h(.-)|h")
			local  _, _, level, rarity = string_match(data, "(%w+):(%d+):(%d+):(%d+)")
			isBattlePet, battlePetLevel, battlePetRarity = true, level or 1, tonumber(rarity) or 0
		end
		local itemID = tonumber(string_match(itemLink, "item:(%d+)"))

		if (itemEquipLoc == "INVTYPE_BAG") then 
			local bag,slot = self:GetBag(),self:GetID()
			ScannerTip.owner = self
			ScannerTip.bag = bag
			ScannerTip.slot = slot
			ScannerTip:SetOwner(self, "ANCHOR_NONE")
			ScannerTip:SetBagItem(bag,slot)

			local line = _G[ScannerTipName.."TextLeft3"]
			if (line) then
				local msg = line:GetText()
				if (msg) and (string_find(msg, S_CONTAINER_SLOTS)) then
					local bagSlots = string_match(msg, S_CONTAINER_SLOTS)
					if (bagSlots) and (tonumber(bagSlots) > 0) then
						displayMsg = bagSlots
					end
				else
					line = _G[ScannerTipName.."TextLeft4"]
					if (line) then
						local msg = line:GetText()
						if (msg) and (string_find(msg, S_CONTAINER_SLOTS)) then
							local bagSlots = string_match(msg, S_CONTAINER_SLOTS)
							if (bagSlots) and (tonumber(bagSlots) > 0) then
								displayMsg = bagSlots
							end
						end
					end
				end
			end

		-- Display item level of equippable gear and artifact relics, and battle pet level
		elseif ((itemRarity and (itemRarity > 0)) and ((itemEquipLoc and _G[itemEquipLoc]) or (itemID and IsArtifactRelicItem and IsArtifactRelicItem(itemID)))) or (isBattlePet) then

			local scannedLevel
			if (not isBattlePet) then
				local bag,slot = self:GetBag(),self:GetID()
				ScannerTip.owner = self
				ScannerTip.bag = bag
				ScannerTip.slot = slot
				ScannerTip:SetOwner(self, "ANCHOR_NONE")
				ScannerTip:SetBagItem(bag,slot)
	
				local line = _G[ScannerTipName.."TextLeft2"]
				if (line) then
					local msg = line:GetText()
					if (msg) and (string_find(msg, S_ITEM_LEVEL)) then
						local ilvl = (string_match(msg, S_ITEM_LEVEL))
						if (ilvl) and (tonumber(ilvl) > 0) then
							scannedLevel = ilvl
						end
					else
						-- Check line 3, some artifacts have the ilevel there
						line = _G[ScannerTipName.."TextLeft3"]
						if line then
							local msg = line:GetText()
							if (msg) and (string_find(msg, S_ITEM_LEVEL)) then
								local ilvl = (string_match(msg, S_ITEM_LEVEL))
								if (ilvl) and (tonumber(ilvl) > 0) then
									scannedLevel = ilvl
								end
							end
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
		if (displayR) and (displayG) and (displayB) then
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