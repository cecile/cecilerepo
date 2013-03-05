----------------------------------------------------------------------------------------------------
-- Loot handling module, for auto remove preferences after looted them
--

--get the addon  engine
local C_LP = select( 2, ... )

--get the locale table from engine
local L = C_LP.L;

--returm the iten id (numeric) from a item link
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

--helper function to see if a loot message contain a pattern
function C_LP:MatchLootFormat(msg, pattern)
	return msg:match(pattern:gsub("(%%s)", "(.+)"):gsub("(%%d)", "(.+)"))
end

--handle loot message event, get the item link from the localized string using the global localized
-- format for self loot messages, them get the id from the link and check if its on our own
-- preferences, if its so delete it from preferences and send our preference to the guild
function C_LP:HandleLoot(msg)

	local item, quantity = C_LP:MatchLootFormat(msg, _G.LOOT_ITEM_SELF_MULTIPLE)
	
	if(not item) then
	
		item, quantity = C_LP:MatchLootFormat(msg, _G.LOOT_ITEM_PUSHED_SELF_MULTIPLE)
		
		if(not item) then			
			quantity = 1
			item = C_LP:MatchLootFormat(msg, _G.LOOT_ITEM_SELF)
			
			if(not item) then		
				item = C_LP:MatchLootFormat(msg, _G.LOOT_ITEM_PUSHED_SELF)
			end
			
		end
		
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
