
-- Using the Bagnon way to retrieve names, namespaces and stuff
local MODULE =  ...
local ADDON, Addon = MODULE:match("[^_]+"), _G[MODULE:match("[^_]+")]
local ItemLevel = Bagnon:NewModule("ItemLevel", Addon)

-- Lua API
local _G = _G
local string_match = string.match
local tonumber = tonumber

-- WoW API
local CreateFrame = _G.CreateFrame
local GetDetailedItemLevelInfo = _G.GetDetailedItemLevelInfo -- 7.1.0
local GetItemInfo = _G.GetItemInfo
local GetItemQualityColor = _G.GetItemQualityColor
local IsArtifactRelicItem = _G.IsArtifactRelicItem -- 7.0.3

-- Cache of itemlevel texts
local cache = {}

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
		if (itemRarity and (itemRarity > 1)) and ((itemEquipLoc and _G[itemEquipLoc]) or (itemID and IsArtifactRelicItem(itemID))) then
			local r, g, b = GetItemQualityColor(itemRarity)
			itemLevel:SetTextColor(r, g, b)
			itemLevel:SetText(effectiveLevel or iLevel or "")
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
