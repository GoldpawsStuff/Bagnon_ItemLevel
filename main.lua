
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
local GetDetailedItemLevelInfo = _G.GetDetailedItemLevelInfo
local GetItemInfo = _G.GetItemInfo
local GetItemQualityColor = _G.GetItemQualityColor
local IsArtifactRelicItem = _G.IsArtifactRelicItem

-- Cache of itemlevel texts
local cache = {}

local updateSlot = function(self)

	local itemLink = self:GetItem() -- GetContainerItemLink(self:GetBag(), self:GetID())
	if itemLink then

		if (not cache[self]) then
			-- Adding an extra layer to get it above glow and border textures
			local holder = CreateFrame("Frame", nil, self)
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
			if self.UpgradeIcon then
				self.UpgradeIcon:ClearAllPoints()
				self.UpgradeIcon:SetPoint("BOTTOMLEFT", 0, 2)
			end

			cache[self] = itemLevel
		end

		local itemLevel = cache[self]

		local _, _, itemRarity, iLevel, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)
		local effectiveLevel, previewLevel, origLevel = GetDetailedItemLevelInfo and GetDetailedItemLevelInfo(itemLink)
		local itemID = tonumber(string_match(itemLink, "item:(%d+)"))

		-- Display item level of equippable gear and artifact relics
		if (itemRarity and (itemRarity > 1)) and ((itemEquipLoc and _G[itemEquipLoc]) or (itemID and IsArtifactRelicItem and IsArtifactRelicItem(itemID))) then
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

ItemLevel.OnEnable = function(self)
	hooksecurefunc(Bagnon.ItemSlot, "Update", updateSlot)
end

