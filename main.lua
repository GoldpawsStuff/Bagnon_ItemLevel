
-- Using the Bagnon way to retrieve names, namespaces and stuff
local MODULE =  ...
local ADDON, Addon = MODULE:match("[^_]+"), _G[MODULE:match("[^_]+")]
local Module = Bagnon:NewModule("ItemLevel", Addon)

-- Lua API
local _G = _G
local select = select
local string_find = string.find
local string_gsub = string.gsub
local string_match = string.match
local tonumber = tonumber

-- WoW API
local CreateFrame = _G.CreateFrame
local GetAchievementInfo = _G.GetAchievementInfo
local GetBuildInfo = _G.GetBuildInfo
local GetDetailedItemLevelInfo = _G.GetDetailedItemLevelInfo 
local GetItemInfo = _G.GetItemInfo
local GetItemQualityColor = _G.GetItemQualityColor
local IsArtifactRelicItem = _G.IsArtifactRelicItem 

-- Cache of itemlevel texts
local ButtonCache = {}

-- Tooltip used for scanning
local ScannerTip = CreateFrame("GameTooltip", "BagnonArtifactItemLevelScannerTooltip", WorldFrame, "GameTooltipTemplate")
local ScannerTipName = ScannerTip:GetName()

-- Tooltip and scanning by Phanx @ http://www.wowinterface.com/forums/showthread.php?p=271406
local S_ITEM_LEVEL = "^" .. string_gsub(_G.ITEM_LEVEL, "%%d", "(%%d+)")
local S_CONTAINER_SLOTS = "^" .. string_gsub(string_gsub(_G.CONTAINER_SLOTS, "%%d", "(%%d+)"), "%%s", "(%.+)")

-- Initialize the button
local CacheButton = function(self)

	-- Adding an extra layer to get it above glow and border textures
	local PluginContainerFrame = _G[self:GetName().."ExtraInfoFrame"] or CreateFrame("Frame", self:GetName().."ExtraInfoFrame", self)
	PluginContainerFrame:SetAllPoints()

	-- Using standard blizzard fonts here
	local ItemLevel = PluginContainerFrame:CreateFontString()
	ItemLevel:SetDrawLayer("ARTWORK", 1)
	ItemLevel:SetPoint("TOPLEFT", 2, -2)
	ItemLevel:SetFontObject(NumberFont_Outline_Med) 
	ItemLevel:SetShadowOffset(1, -1)
	ItemLevel:SetShadowColor(0, 0, 0, .5)

	-- Move Pawn out of the way
	local UpgradeIcon = self.UpgradeIcon
	if UpgradeIcon then
		UpgradeIcon:ClearAllPoints()
		UpgradeIcon:SetPoint("BOTTOMRIGHT", 2, 0)
	end

	-- Store the reference for the next time
	ButtonCache[self] = ItemLevel

	return ItemLevel
end

-- Check if it's a caged battle pet
local GetBattlePetInfo = function(itemLink)
	if (not string_find(itemLink, "battlepet")) then
		return
	end
	local data, name = string_match(itemLink, "|H(.-)|h(.-)|h")
	local  _, _, level, rarity = string_match(data, "(%w+):(%d+):(%d+):(%d+)")
	return true, level or 1, tonumber(rarity) or 0
end

local PostUpdateButton = function(self)
	local itemLink = self:GetItem() 
	if itemLink then

		-- Retrieve or create this button's itemlevel text
		local ItemLevel = ButtonCache[self] or CacheButton(self)

		-- Get some blizzard info about the current item
		local _, _, itemRarity, iLevel, _, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(itemLink)
		local effectiveLevel, previewLevel, origLevel = GetDetailedItemLevelInfo(itemLink)
		local isBattlePet, battlePetLevel, battlePetRarity = GetBattlePetInfo(itemLink)

		-- Retrieve the itemID from the itemLink
		local itemID = tonumber(string_match(itemLink, "item:(%d+)"))

		if (itemEquipLoc == "INVTYPE_BAG") then 

			ScannerTip.owner = self
			ScannerTip:SetOwner(self, "ANCHOR_NONE")
			ScannerTip:SetBagItem(self:GetBag(), self:GetID())

			local scannedSlots
			local line = _G[ScannerTipName.."TextLeft3"]
			if line then
				local msg = line:GetText()
				if msg and string_find(msg, S_CONTAINER_SLOTS) then
					local bagSlots = string_match(msg, S_CONTAINER_SLOTS)
					if bagSlots and (tonumber(bagSlots) > 0) then
						scannedSlots = bagSlots
					end
				else
					line = _G[ScannerTipName.."TextLeft4"]
					if line then
						local msg = line:GetText()
						if msg and string_find(msg, S_CONTAINER_SLOTS) then
							local bagSlots = string_match(msg, S_CONTAINER_SLOTS)
							if bagSlots and (tonumber(bagSlots) > 0) then
								scannedSlots = bagSlots
							end
						end
					end
				end
			end

			if scannedSlots then 
				--local r, g, b = GetItemQualityColor(itemRarity)
				local r, g, b = 240/255, 240/255, 240/255
				ItemLevel:SetTextColor(r, g, b)
				ItemLevel:SetText(scannedSlots)
			else 
				ItemLevel:SetText("")
			end 

		-- Display item level of equippable gear and artifact relics
		elseif ((itemRarity and (itemRarity > 0)) and ((itemEquipLoc and _G[itemEquipLoc]) or (itemID and IsArtifactRelicItem(itemID)))) or (isBattlePet) then

			local scannedLevel
			if (not isBattlePet) then
				ScannerTip.owner = self
				ScannerTip:SetOwner(self, "ANCHOR_NONE")
				ScannerTip:SetBagItem(self:GetBag(), self:GetID())

				local line = _G[ScannerTipName.."TextLeft2"]
				if line then
					local msg = line:GetText()
					if msg and string_find(msg, S_ITEM_LEVEL) then
						local ItemLevel = string_match(msg, S_ITEM_LEVEL)
						if ItemLevel and (tonumber(ItemLevel) > 0) then
							scannedLevel = ItemLevel
						end
					else
						-- Check line 3, some artifacts have the ilevel there
						line = _G[ScannerTipName.."TextLeft3"]
						if line then
							local msg = line:GetText()
							if msg and string_find(msg, S_ITEM_LEVEL) then
								local ItemLevel = string_match(msg, S_ITEM_LEVEL)
								if ItemLevel and (tonumber(ItemLevel) > 0) then
									scannedLevel = ItemLevel
								end
							end
						end
					end
				end
			end

			local r, g, b = GetItemQualityColor(battlePetRarity or itemRarity)
			ItemLevel:SetTextColor(r, g, b)
			ItemLevel:SetText(scannedLevel or battlePetLevel or effectiveLevel or iLevel or "")

		else
			ItemLevel:SetText("")
		end

	else
		if ButtonCache[self] then
			ButtonCache[self]:SetText("")
		end
	end	
end 

Module.OnEnable = function(self)
	hooksecurefunc(Bagnon.ItemSlot, "Update", PostUpdateButton)
end 
