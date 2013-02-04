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
	
		table.sort(results, function(a,b) 		
			return C_LP.PRIORITY_SORT[a.priority] > C_LP.PRIORITY_SORT[b.priority]
		end)
		
		tooltip:AddLine("")
		tooltip:AddLine(L["LOOT_PREFERENCES"])
		
		for i = 1, total do		
			classcolor = RAID_CLASS_COLORS[results[i].class]		
			tooltip:AddDoubleLine(results[i].player,L[results[i].priority],classcolor.r,classcolor.g,classcolor.b)
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

