
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

local updateButton = (GetDetailedItemLevelInfo and IsArtifactRelicItem) and function(self)
	local itemLink = self:GetItem() 
	if itemLink then

		-- Retrieve or create this button's itemlevel text
		local itemLevel = cache[self] or initButton(self)

		-- Get some blizzard info about the current item
		local _, _, itemRarity, iLevel, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)
		local effectiveLevel, previewLevel, origLevel = GetDetailedItemLevelInfo(itemLink)

		-- Retrieve the itemID from the itemLink
		local itemID = tonumber(string_match(itemLink, "item:(%d+)"))

		-- Display item level of equippable gear and artifact relics
		if (itemRarity and (itemRarity > 0)) and ((itemEquipLoc and _G[itemEquipLoc]) or (itemID and IsArtifactRelicItem(itemID))) then

			local crucibleLevel
			if LEGION_730 then
			
				scanner.owner = self
				scanner:SetOwner(self, "ANCHOR_NONE")
				scanner:SetBagItem(self:GetBag(), self:GetID())

				local line = _G[scannerName.."TextLeft2"]
				if line then
					local msg = line:GetText()
					if msg and string_find(msg, S_ITEM_LEVEL) then
						local itemLevel = string_match(msg, S_ITEM_LEVEL)
						if itemLevel and (tonumber(itemLevel) > 0) then
							crucibleLevel = itemLevel
						end
					else
						-- Check line 3, some artifacts have the ilevel there
						line = _G[scannerName.."TextLeft3"]
						if line then
							local msg = line:GetText()
							if msg and string_find(msg, S_ITEM_LEVEL) then
								local itemLevel = string_match(msg, S_ITEM_LEVEL)
								if itemLevel and (tonumber(itemLevel) > 0) then
									crucibleLevel = itemLevel
								end
							end
						end
					end
				end
			end

			local r, g, b = GetItemQualityColor(itemRarity)
			itemLevel:SetTextColor(r, g, b)
			itemLevel:SetText(crucibleLevel or effectiveLevel or iLevel or "")
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

		-- Retrieve the itemID from the itemLink
		local itemID = tonumber(string_match(itemLink, "item:(%d+)"))

		-- Display item level of equippable gear and artifact relics
		if (itemRarity and (itemRarity > 1)) and ((itemEquipLoc and _G[itemEquipLoc]) or (itemID and IsArtifactRelicItem(itemID))) then
			local r, g, b = GetItemQualityColor(itemRarity)
			itemLevel:SetTextColor(r, g, b)
			itemLevel:SetText(iLevel or "")
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

		-- Display item level of equippable gear and artifact relics
		if (itemRarity and (itemRarity > 1)) and ((itemEquipLoc and _G[itemEquipLoc])) then
			local r, g, b = GetItemQualityColor(itemRarity)
			itemLevel:SetTextColor(r, g, b)
			itemLevel:SetText(iLevel or "")
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
