----------------------------------------------------------------------------------------------------
-- Tolltip module, modify items tooltip to show preferences
--

--get the addon  engine
local C_LP = select( 2, ... )

--get the locale table from engine
local L = C_LP.L;

--tooltip hooked switch
C_LP.TooltipHook = false

--hook function for OnTooltipSetItem in tooltip frames, get the item id, build a list of people in
-- our guild that have this item as preference, if there its any get the PR value if we are using
-- EPGP and sort the list by loot priority, as well by PR if we using EPGP, add the list to the 
-- tooltip
function C_LP.TooltipHookFunc(tooltip, ...)

	local item, link = tooltip:GetItem()	
	
	if (link) then
	
		local itemID = tonumber(link:match("item:(%d+)"))
		
		--find preferences for this  item within the guild
		local results = {}
		local preference = {}
			
		for k,v in pairs(C_LP.guilditems) do	
				
			if v.items[itemID] and (not (v.items[itemID]=="")) then					
				
				preference = {}
				preference.player = k
				preference.class = v.class
				preference.priority = v.items[itemID]
				
				tinsert(results,preference)
				
			end
		end
		
		--if we have preferences
		local total = #results
		if not (total==0) then	
		
			--if we use EPGP sort by prioty & PR, if not sort by priority
			if C_LP.epgp then
				GuildRoster()
				for i = 1, total do			
					results[i].epgp_pr = C_LP:GetPR(results[i].player)
				end
				
				table.sort(results, function(a,b) 		
					if (a.priority == b.priority) then
						return a.epgp_pr>b.epgp_pr
					else
						return C_LP.PRIORITY_SORT[a.priority] > C_LP.PRIORITY_SORT[b.priority]
					end
				end)
				
			else
			
				table.sort(results, function(a,b) 		
					return C_LP.PRIORITY_SORT[a.priority] > C_LP.PRIORITY_SORT[b.priority]
				end)
			
			end
			
			--add the localized information to the tooltip, using class colors, if we are using EPGP 
			-- show the PR
			tooltip:AddLine("")
			tooltip:AddLine(L["LOOT_PREFERENCES"])
			
			local priority_text = ""
			
			for i = 1, total do	
				classcolor = RAID_CLASS_COLORS[results[i].class]
				
				priority_text = L[results[i].priority]
				
				if C_LP.epgp then
					priority_text = priority_text .. " (PR:" .. string.format("%.4g",results[i].epgp_pr)..")"
				end
				
				tooltip:AddDoubleLine(results[i].player,priority_text,classcolor.r,classcolor.g,classcolor.b)
			end
		end

	end
end

--hook all frame windows that are actually a tooltip, this will make it work in no standard tooltip
-- windows, for example in atlas loot tooltips.
function C_LP:InitTooltip()
			
	if not C_LP.TooltipHook then				
		
		local obj = EnumerateFrames()
			while obj do
			if obj:IsObjectType("GameTooltip") then
		
				obj:HookScript("OnTooltipSetItem", C_LP.TooltipHookFunc)
			end
			obj = EnumerateFrames(obj)
		end		
		
		C_LP.TooltipHook = true		
		
	end	
		
end
