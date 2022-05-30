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
local sTipName = "BagnonItemInfoScannerTooltip"
local sTip = _G[sTipName] or CreateFrame("GameTooltip", sTipName, WorldFrame, "GameTooltipTemplate")

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

-- Tooltip and scanning by Phanx
-- Source: http://www.wowinterface.com/forums/showthread.php?p=271406
local S_ILVL = "^" .. string_gsub(_G.ITEM_LEVEL, "%%d", "(%%d+)")

-- Redoing this to take other locales into consideration,
-- and to make sure we're capturing the slot count, and not the bag type.
local S_SLOTS = "^" .. (string_gsub(string_gsub(_G.CONTAINER_SLOTS, "%%([%d%$]-)d", "(%%d+)"), "%%([%d%$]-)s", "%.+"))

-- FontString Caches
local cache = {}

-- Quality colors for faster lookups
local colors = {
	[0] = { 157/255, 157/255, 157/255 }, -- Poor
	[1] = { 240/255, 240/255, 240/255 }, -- Common
	[2] = { 30/255, 178/255, 0/255 }, -- Uncommon
	[3] = { 0/255, 112/255, 221/255 }, -- Rare
	[4] = { 163/255, 53/255, 238/255 }, -- Epic
	[5] = { 225/255, 96/255, 0/255 }, -- Legendary
	[6] = { 229/255, 204/255, 127/255 }, -- Artifact
	[7] = { 79/255, 196/255, 225/255 }, -- Heirloom
	[8] = { 79/255, 196/255, 225/255 } -- Blizzard
}

-- Saved settings
_G.BagnonItemLevel_DB = {
	enableRarityColoring = true
}

-- Slash handler for user options
local slashHandler = function(msg, editBox)
	local action, element

	-- Remove spaces at the start and end
	msg = string_gsub(msg, "^%s+", "")
	msg = string_gsub(msg, "%s+$", "")

	-- Replace all space characters with single spaces
	msg = string_gsub(msg, "%s+", " ")

	-- Extract the arguments
	if (string_find(msg, "%s")) then
		action, element = string_split(" ", msg)
	end

	if (element == "color") then
		if (action == "enable") then
			BagnonItemLevel_DB.enableRarityColoring = true
		elseif (action == "disable") then
			BagnonItemLevel_DB.enableRarityColoring = false
		end
	end
end

-- Main Update
local Update = function(self)
	local message, r, g, b

	local itemLink = self:GetItem()
	if (itemLink) then
		local itemID = tonumber(string_match(itemLink, "item:(%d+)"))
		local _, _, itemRarity, itemLevel, _, _, _, _, itemEquipLoc = GetItemInfo(itemLink)

		-- Parse for battle pet info
		local isPet, petLevel, petRarity
		if (string_find(itemLink, "battlepet")) then
			local data, name = string_match(itemLink, "|H(.-)|h(.-)|h")
			local  _, _, level, rarity = string_match(data, "(%w+):(%d+):(%d+):(%d+)")
			isPet, petLevel, petRarity = true, level or 1, tonumber(rarity) or 0
		end

		-- Display container slots of equipped bags.
		if (itemEquipLoc == "INVTYPE_BAG") then
			local bag,slot = self:GetBag(),self:GetID()
			sTip.owner = self
			sTip.bag = bag
			sTip.slot = slot
			sTip:SetOwner(self, "ANCHOR_NONE")
			sTip:SetBagItem(bag,slot)

			for i = 3,4 do
				local line = _G[sTipName.."TextLeft"..i]
				if (line) then
					local msg = line:GetText()
					if (msg) and (string_find(msg, S_SLOTS)) then
						local bagSlots = string_match(msg, S_SLOTS)
						if (bagSlots) and (tonumber(bagSlots) > 0) then
							message = bagSlots
						end
						break
					end
				end
			end

		-- Display item level of equippable gear,
		-- artifact relics, and battle pet level.
		elseif ((itemRarity and itemRarity > 0) and ((itemEquipLoc and _G[itemEquipLoc]) or (itemID and IsArtifactRelicItem and IsArtifactRelicItem(itemID)))) or (isPet) then

			local tipLevel
			if (not isPet) then
				local bag,slot = self:GetBag(),self:GetID()
				sTip.owner = self
				sTip.bag = bag
				sTip.slot = slot
				sTip:SetOwner(self, "ANCHOR_NONE")
				sTip:SetBagItem(bag,slot)

				-- Check line 3 as some artifacts have the ilevel there.
				for i = 2,3 do
					local line = _G[sTipName.."TextLeft"..i]
					if (line) then
						local msg = line:GetText()
						if (msg) and (string_find(msg, S_ILVL)) then
							local ilvl = (string_match(msg, S_ILVL))
							if (ilvl) and (tonumber(ilvl) > 0) then
								tipLevel = ilvl
							end
							break
						end
					end
				end
			end

			if (BagnonItemLevel_DB.enableRarityColoring) then
				local col = color[petRarity or itemRarity]
				if (col) then
					r, g, b = col[1], col[2], col[3]
				end
			end
			message = tipLevel or petLevel or GetDetailedItemLevelInfo(itemLink) or itemLevel or ""
		end
	end

	if (message) then

		-- Retrieve or create the itemlevel fontstring.
		local ilvl = cache[self]
		if (not ilvl) then

			-- Retrieve or create plugin container
			-- used by all my Bagnon plugins.
			local name = self:GetName() .. "ExtraInfoFrame"
			local container = _G[name]
			if (not container) then
				container = CreateFrame("Frame", name, self)
				container:SetAllPoints()
			end

			-- Setup the item level fontstring
			ilvl = container:CreateFontString()
			ilvl:SetDrawLayer("ARTWORK", 1)
			ilvl:SetPoint("TOPLEFT", 2, -2)
			ilvl:SetFontObject(_G.NumberFont_Outline_Med or _G.NumberFontNormal)
			ilvl:SetShadowOffset(1, -1)
			ilvl:SetShadowColor(0, 0, 0, .5)

			-- Move conflicting items away.
			local UpgradeIcon = self.UpgradeIcon
			if (UpgradeIcon) then
				UpgradeIcon:ClearAllPoints()
				UpgradeIcon:SetPoint("BOTTOMRIGHT", 2, 0)
			end

			-- Store for next time.
			cache[self] = ilvl
		end

		-- Colorize.
		if (r) and (g) and (b) then
			ilvl:SetTextColor(r, g, b)
		else
			ilvl:SetTextColor(240/255, 240/255, 240/255)
		end

		ilvl:SetText(message)

	-- Clear existing entries
	-- if nothing should be shown.
	elseif (cache[self]) then
		cache[self]:SetText("")
	end
end

local item = Bagnon.ItemSlot or Bagnon.Item
if (item) and (item.Update) then

	-- Hook our update to Bagnon
	hooksecurefunc(item, "Update", Update)

	-- Register the chat command(s)
	-- *keep hash upper case, value lowercase
	for i,command in ipairs({ "bagnonitemlevel", "bilvl", "bil" }) do
		local name = "AZERITE_TEAM_PLUGIN_"..string_upper(command)
		_G["SLASH_"..name.."1"] = "/"..string_lower(command)
		_G.SlashCmdList[name] = slashHandler
	end

end