
-- Using the Bagnon way to retrieve names, namespaces and stuff
local MODULE =  ...
local ADDON, Addon = MODULE:match("[^_]+"), _G[MODULE:match("[^_]+")]
local ItemLevel = Bagnon:NewModule("ItemLevel", Addon)

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
local GetDetailedItemLevelInfo = _G.GetDetailedItemLevelInfo -- 7.1.0
local GetItemInfo = _G.GetItemInfo
local GetItemQualityColor = _G.GetItemQualityColor
local IsArtifactRelicItem = _G.IsArtifactRelicItem -- 7.0.3

-- Cache of itemlevel texts
local cache = {}

-- Current game client build
local BUILD = tonumber((select(2, GetBuildInfo()))) 

-- Whether or not we need to scan for extra item levels on the artifact
local LEGION_730 = BUILD >= 24500 
local LEGION_730_CRUCIBLE = LEGION_730 and select(4, GetAchievementInfo(12072))

-- In case of a fresh character in patch 7.3.0, we listen for the achievement
if LEGION_730 and (not LEGION_730_CRUCIBLE) then
	local eventListener = CreateFrame("Frame")
	eventListener:RegisterEvent("ACHIEVEMENT_EARNED")
	eventListener:SetScript("OnEvent", function(self, event, id) 
		if (id == 12072) then
			LEGION_730_CRUCIBLE = true
			self:UnregisterEvent(event)
		end
	end)
end

-- Tooltip used for scanning
local scanner = CreateFrame("GameTooltip", "BagnonArtifactItemLevelScannerTooltip", WorldFrame, "GameTooltipTemplate")
local scannerName = scanner:GetName()

-- Tooltip and scanning by Phanx @ http://www.wowinterface.com/forums/showthread.php?p=271406
local S_ITEM_LEVEL = "^" .. string_gsub(_G.ITEM_LEVEL, "%%d", "(%%d+)")
local S_CONTAINER_SLOTS = _G.CONTAINER_SLOTS
S_CONTAINER_SLOTS = string_gsub(S_CONTAINER_SLOTS, "%%d", "(%%d+)")
S_CONTAINER_SLOTS = string_gsub(S_CONTAINER_SLOTS, "%%s", "(%.+)") -- in search patterns 's' are spaces, can't be using that
S_CONTAINER_SLOTS = "^" .. S_CONTAINER_SLOTS

-- Initialize the button
local initButton = function(self)

	-- Adding an extra layer to get it above glow and border textures
	local holder = _G[self:GetName().."ExtraInfoFrame"] or CreateFrame("Frame", self:GetName().."ExtraInfoFrame", self)
	holder:SetAllPoints()

	-- Using standard blizzard fonts here
	local itemLevel = holder:CreateFontString()
	itemLevel:SetDrawLayer("ARTWORK")
	itemLevel:SetPoint("TOPLEFT", 2, -2)
	itemLevel:SetFontObject(_G.NumberFont_Outline_Med or _G.NumberFontNormal) 
	itemLevel:SetFont(itemLevel:GetFont(), 14, "OUTLINE")
	itemLevel:SetShadowOffset(1, -1)
	itemLevel:SetShadowColor(0, 0, 0, .5)

	-- Move Pawn out of the way
	local upgradeIcon = self.UpgradeIcon
	if upgradeIcon then
		upgradeIcon:ClearAllPoints()
		upgradeIcon:SetPoint("BOTTOMRIGHT", 2, 0)
	end

	-- Store the reference for the next time
	cache[self] = itemLevel

	return itemLevel
end

-- Check if it's a caged battle pet
local battlePetInfo = function(itemLink)
	if (not string_find(itemLink, "battlepet")) then
		return
	end
	local data, name = string_match(itemLink, "|H(.-)|h(.-)|h")
	local  _, _, level, rarity = string_match(data, "(%w+):(%d+):(%d+):(%d+)")
	return true, level or 1, tonumber(rarity) or 0
end

local updateButton = (GetDetailedItemLevelInfo and IsArtifactRelicItem) and function(self)
	local itemLink = self:GetItem() 
	if itemLink then

		-- Retrieve or create this button's itemlevel text
		local itemLevel = cache[self] or initButton(self)

		-- Get some blizzard info about the current item
		local _, _, itemRarity, iLevel, _, itemType, itemSubType, _, itemEquipLoc = GetItemInfo(itemLink)
		local effectiveLevel, previewLevel, origLevel = GetDetailedItemLevelInfo(itemLink)
		local isBattlePet, battlePetLevel, battlePetRarity = battlePetInfo(itemLink)

		-- Retrieve the itemID from the itemLink
		local itemID = tonumber(string_match(itemLink, "item:(%d+)"))

		if (itemEquipLoc == "INVTYPE_BAG") then 

			scanner.owner = self
			scanner:SetOwner(self, "ANCHOR_NONE")
			scanner:SetBagItem(self:GetBag(), self:GetID())

			local scannedSlots
			local line = _G[scannerName.."TextLeft3"]
			if line then
				local msg = line:GetText()
				if msg and string_find(msg, S_CONTAINER_SLOTS) then
					local bagSlots = string_match(msg, S_CONTAINER_SLOTS)
					if bagSlots and (tonumber(bagSlots) > 0) then
						scannedSlots = bagSlots
					end
				else
					line = _G[scannerName.."TextLeft4"]
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
				itemLevel:SetTextColor(r, g, b)
				itemLevel:SetText(scannedSlots)
			else 
				itemLevel:SetText("")
			end 

		-- Display item level of equippable gear and artifact relics
		elseif ((itemRarity and (itemRarity > 0)) and ((itemEquipLoc and _G[itemEquipLoc]) or (itemID and IsArtifactRelicItem(itemID)))) or (isBattlePet) then

			local scannedLevel
			if (not isBattlePet) then
				scanner.owner = self
				scanner:SetOwner(self, "ANCHOR_NONE")
				scanner:SetBagItem(self:GetBag(), self:GetID())

				local line = _G[scannerName.."TextLeft2"]
				if line then
					local msg = line:GetText()
					if msg and string_find(msg, S_ITEM_LEVEL) then
						local itemLevel = string_match(msg, S_ITEM_LEVEL)
						if itemLevel and (tonumber(itemLevel) > 0) then
							scannedLevel = itemLevel
						end
					else
						-- Check line 3, some artifacts have the ilevel there
						line = _G[scannerName.."TextLeft3"]
						if line then
							local msg = line:GetText()
							if msg and string_find(msg, S_ITEM_LEVEL) then
								local itemLevel = string_match(msg, S_ITEM_LEVEL)
								if itemLevel and (tonumber(itemLevel) > 0) then
									scannedLevel = itemLevel
								end
							end
						end
					end
				end
			end

			local r, g, b = GetItemQualityColor(battlePetRarity or itemRarity)
			itemLevel:SetTextColor(r, g, b)
			itemLevel:SetText(scannedLevel or battlePetLevel or effectiveLevel or iLevel or "")

		else
			itemLevel:SetText("")
		end

	else
		if cache[self] then
			cache[self]:SetText("")
		end
	end	
end 
or 
IsArtifactRelicItem and function(self)
	local itemLink = self:GetItem() 
	if itemLink then

		-- Retrieve or create this button's itemlevel text
		local itemLevel = cache[self] or initButton(self)

		-- Get some blizzard info about the current item
		local _, _, itemRarity, iLevel, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)
		local isBattlePet, battlePetLevel, battlePetRarity = battlePetInfo(itemLink)

		-- Retrieve the itemID from the itemLink
		local itemID = tonumber(string_match(itemLink, "item:(%d+)"))

		-- Display item level of equippable gear and artifact relics
		if ((itemRarity and (itemRarity > 1)) and ((itemEquipLoc and _G[itemEquipLoc]) or (itemID and IsArtifactRelicItem(itemID)))) or (isBattlePet) then
			local r, g, b = GetItemQualityColor(battlePetRarity or itemRarity)
			itemLevel:SetTextColor(r, g, b)
			itemLevel:SetText(battlePetLevel or iLevel or "")
		else
			itemLevel:SetText("")
		end

	else
		if cache[self] then
			cache[self]:SetText("")
		end
	end	
end 
or 
function(self)
	local itemLink = self:GetItem() 
	if itemLink then

		-- Retrieve or create this button's itemlevel text
		local itemLevel = cache[self] or initButton(self)

		-- Get some blizzard info about the current item
		local _, _, itemRarity, iLevel, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)

		-- Retrieve the itemID from the itemLink
		local itemID = tonumber(string_match(itemLink, "item:(%d+)"))

		-- Retrieve potential BattlePet information
		local isBattlePet, battlePetLevel, battlePetRarity = battlePetInfo(itemLink)

		-- Display item level of equippable gear and artifact relics
		if ((itemRarity and (itemRarity > 1)) and ((itemEquipLoc and _G[itemEquipLoc]))) or (isBattlePet) then
			local r, g, b = GetItemQualityColor(battlePetRarity or itemRarity)
			itemLevel:SetTextColor(r, g, b)
			itemLevel:SetText(battlePetLevel or iLevel or "")
		else
			itemLevel:SetText("")
		end

	else
		if cache[self] then
			cache[self]:SetText("")
		end
	end	
end 

ItemLevel.OnEnable = function(self)
	hooksecurefunc(Bagnon.ItemSlot, "Update", updateButton)
end 
