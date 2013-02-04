local C_LP = select( 2, ... )
local L = C_LP.L;

C_LP.TooltipHook = false

function C_LP.TooltipHookFunc(tooltip, ...)

	local item, link = tooltip:GetItem()	
	local itemID = tonumber(link:match("item:(%d+)"))
	
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
	
	local total = #results
	if not (total==0) then	
	
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

