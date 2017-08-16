
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

			cache[self] = itemLevel
		end

		local _, _, itemRarity, iLevel, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)
		local itemID = tonumber(string_match(itemLink, "item:(%d+)"))

		-- Display item level of equippable gear and artifact relics
		if (itemRarity and (itemRarity > 1)) and ((itemEquipLoc and _G[itemEquipLoc]) or (itemID and IsArtifactRelicItem and IsArtifactRelicItem(itemID))) then
			local r, g, b = GetItemQualityColor(itemRarity)
			cache[self]:SetTextColor(r, g, b)
			cache[self]:SetText(iLevel or "")
		else
			cache[self]:SetText("")
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

