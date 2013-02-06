local C_LP = select( 2, ... )
local L = C_LP.L;

function C_LP:GetIDFromLink(link)
	if not link then
		return
	end
	local found, _, str = link:find("^|c%x+|H(.+)|h%[.+%]")

	if not found then
		return
	end

	local _, id = (":"):split(str)
	return tonumber(id)
end

function C_LP:MatchLootFormat(msg, pattern)
	return msg:match(pattern:gsub("(%%s)", "(.+)"):gsub("(%%d)", "(.+)"))
end

function C_LP:HandleLoot(msg)

	local item, quantity = C_LP:MatchLootFormat(msg, _G.LOOT_ITEM_SELF_MULTIPLE)
	
	if(not item) then
		quantity = 1
		item = C_LP:MatchLootFormat(msg, _G.LOOT_ITEM_SELF)
	end
	
	if item then
		local itemID = C_LP:GetIDFromLink(item)
		
		if itemID then
			
			if C_LP.myitems[itemID] then
				
				if not (C_LP.myitems[itemID]=="") then
					C_LP.myitems[itemID] = ""
					C_LP:SendPreferences()
					print(string.format(L["LOOT_MESSAGE"],C_LP.title,item))
				end
				
			end
		end		
	end
	
end