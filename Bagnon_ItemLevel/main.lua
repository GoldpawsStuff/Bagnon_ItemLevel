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

BagnonItemLevel_DB = {
	enableRarityColoring = true
}

local _G = _G
local string_match = string.match
local tonumber = tonumber

local CONTAINER_SLOTS = "^" .. (string.gsub(string.gsub(CONTAINER_SLOTS, "%%([%d%$]-)d", "(%%d+)"), "%%([%d%$]-)s", "%.+"))
local ITEM_LEVEL = "^" .. string.gsub(ITEM_LEVEL, "%%d", "(%%d+)")
local FONT = NumberFont_Outline_Med or NumberFontNormal
local TIP_NAME = "BagnonItemInfoScannerTooltip"
local TIP = _G[TIP_NAME] or CreateFrame("GameTooltip", TIP_NAME, WorldFrame, "GameTooltipTemplate")

local cache = {}
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

local update = function(self)

	local message, color

	if (self.hasItem) then -- and self.info.link

		local class, equip, level, quality = self.info.class, self.info.equip, self.info.level, self.info.quality
		local noequip = not equip or equip == "INVTYPE_BAG" or equip == "INVTYPE_NON_EQUIP" or equip == "INVTYPE_TABARD" or equip == "INVTYPE_AMMO" or equip == "INVTYPE_QUIVER" or equip == "INVTYPE_BODY"
		local isbag = equip == "INVTYPE_BAG"
		local isgear = quality and not noequip
		local ispet = class == Enum.ItemClass.Battlepet

		if (isgear or ispet) and (BagnonItemLevel_DB.enableRarityColoring) then
			color = quality and colors[quality]
			message = level
		end

		if (isgear or isbag) then

			if (not TIP.owner or not TIP.bag or not TIP.slot) then
				TIP.owner, TIP.bag,TIP.slot = self, self.bag, self:GetID()
				TIP:SetOwner(TIP.owner, "ANCHOR_NONE")
				TIP:SetBagItem(TIP.bag, TIP.bag)
			end

			if (isgear) then
				for i = 2,3 do
					local line = _G[TIP_NAME.."TextLeft"..i]
					if (not line) then
						break
					end

					local itemlevel = string_match(line:GetText() or "", ITEM_LEVEL)
					if (itemlevel) then
						itemlevel = tonumber(itemlevel)
						if (itemlevel > 0) then
							message = itemlevel
						end
						break
					end
				end
			end

			if (isbag) then
				for i = 3,4 do
					local line = _G[TIP_NAME.."TextLeft"..i]
					if (not line) then
						break
					end

					local numslots = string_match(line:GetText() or "", CONTAINER_SLOTS)
					if (numslots) then
						numslots = tonumber(numslots)
						if (numslots > 0) then
							message = numslots
						end
						break
					end
				end
			end

		end

	end

	if (message) then

		local label = cache[self]
		if (not label) then

			local name = self:GetName().."ExtraInfoFrame"
			local container = _G[name]
			if (not container) then
				container = CreateFrame("Frame", name, self)
				container:SetAllPoints()
			end

			label = container:CreateFontString()
			label:SetDrawLayer("ARTWORK", 1)
			label:SetPoint("TOPLEFT", 2, -2)
			label:SetFontObject(FONT)
			label:SetShadowOffset(1, -1)
			label:SetShadowColor(0, 0, 0, .5)

			local upgrade = self.UpgradeIcon
			if (upgrade) then
				upgrade:ClearAllPoints()
				upgrade:SetPoint("BOTTOMRIGHT", 2, 0)
			end

			cache[self] = label
		end

		label:SetText(message)

		if (color) then
			label:SetTextColor(color[1], color[2], color[3])
		else
			label:SetTextColor(.94, .94, .94)
		end

	elseif (cache[self]) then
		cache[self]:SetText("")
	end

end

local updates = BAGNON_ITEMINFO_UPDATES or {}
BAGNON_ITEMINFO_UPDATES = updates

table.insert(updates, update)

if (not BAGNON_ITEMINFO_DISPATCHER) then
	BAGNON_ITEMINFO_DISPATCHER = function(self)
		for _,update in ipairs(updates) do
			update(self)
		end
		TIP.owner, TIP.bag, TIP.slot = nil, nil, nil
	end
	hooksecurefunc(Bagnon.ItemSlot or Bagnon.Item, "Update", BAGNON_ITEMINFO_DISPATCHER)
end

SLASH_BAGNON_ITEMLEVEL1 = "/bil"
SlashCmdList["BAGNON_ITEMLEVEL"] = function(msg)
	if (not msg) then
		return
	end

	msg = string.gsub(msg, "^%s+", "")
	msg = string.gsub(msg, "%s+$", "")
	msg = string.gsub(msg, "%s+", " ")

	local action, element = string.split(" ", msg)

	if (element == "color") then
		if (action == "enable") then
			BagnonItemLevel_DB.enableRarityColoring = true
		elseif (action == "disable") then
			BagnonItemLevel_DB.enableRarityColoring = false
		end
	end
end
