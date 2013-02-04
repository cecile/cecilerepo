local C_LP = select( 2, ... )
local L = C_LP.L;

C_LP.HookJournal = false
C_LP.DropDownsCreated = false

function C_LP.ItemDropDown_OnClick(self, arg1, arg2, checked)
	
	C_LP.myitems[arg1.itemID] = arg2;
	
	UIDropDownMenu_SetSelectedValue(arg1,C_LP.myitems[arg1.itemID])
	
	C_LP.Updated = true
		
end

function C_LP.ItemDropDown_Menu(frame)		
	
	local info = UIDropDownMenu_CreateInfo()
	info.arg1=frame
	
	info.func = C_LP.ItemDropDown_OnClick
	info.text, info.arg2, info.value = L["LOOT_NONE"], "", ""
	UIDropDownMenu_AddButton(info)	
	
	info.text, info.arg2, info.value = L["LOOT_MAIN"], "LOOT_MAIN", "LOOT_MAIN"
	UIDropDownMenu_AddButton(info)
	
	info.text, info.arg2, info.value = L["LOOT_MINOR"], "LOOT_MINOR", "LOOT_MINOR"
	UIDropDownMenu_AddButton(info)
	
	info.text, info.arg2, info.value = L["LOOT_OFF"], "LOOT_OFF", "LOOT_OFF"
	UIDropDownMenu_AddButton(info) 
	
	if(C_LP.myitems[frame.itemID]) then
		UIDropDownMenu_SetSelectedValue(frame,C_LP.myitems[frame.itemID])
	else
		UIDropDownMenu_SetSelectedValue(frame,"")
	end
end

function C_LP.LootFilter_Click(self, arg1, arg2)
    
	C_LP.CustomFilter = arg1
	
	EJ_SetLootFilter(0, 0);
	
    CloseDropDownMenus(1);
	
    EncounterJournal_LootUpdate();
end

function C_LP.LootFilter(self, level)

	EncounterJournal_InitLootFilter(self,level)
	local hasitems = false
	
	if (level == 1) then
		local info = UIDropDownMenu_CreateInfo()

		info.text = L["FILTER_MY_PREFERENCES"]
		info.checked = (C_LP.CustomFilter=="MY")
		info.arg1 = "MY";
		info.arg2 = 0;
		info.func = C_LP.LootFilter_Click;
		
		UIDropDownMenu_AddButton(info, level)		
		
		info.text = L["FILTER_GUILD_PREFERENCES"]
		info.checked = (C_LP.CustomFilter=="GUILD")
		info.arg1 = "GUILD";
		info.arg2 = 0;
		info.func = C_LP.LootFilter_Click;
		UIDropDownMenu_AddButton(info, level)
		
		for k,v in pairs(C_LP.guilditems) do				
			
			if (v.items) then
			
				hasitems = false
				for _,pref in pairs(v.items) do					
					hasitems=true
					break
				end
				
				if(hasitems) then
					class = C_LP.guilditems[k].class
					info.text = string.format(L["PLAYER_PREFERENCES"],RAID_CLASS_COLORS[class].colorStr,k)
					info.checked = (C_LP.CustomFilter==k)
					info.arg1 = k;
					info.arg2 = 0;
					info.func = C_LP.LootFilter_Click;		
					UIDropDownMenu_AddButton(info, level)
				end
			end			
		end
						
	end	
	
end

function C_LP.ClearFilter(self,arg1,arg2)
	C_LP.CustomFilter = false
	EncounterJournal_LootUpdate()
end

function C_LP.FilterItem(filter,itemID)

	if (filter=="MY") then	
	
		return C_LP.myitems[itemID] and (not (C_LP.myitems[itemID]=="") )
		
	elseif (filter=="GUILD") then	
	
		for k,v in pairs(C_LP.guilditems) do				
			if v.items[itemID] and (not (v.items[itemID]=="")) then	
				return true
			end
		end		
	else		
		return C_LP.guilditems[filter].items[itemID] and (not (C_LP.guilditems[filter].items[itemID]=="") )
	end
	
	return false
end

function C_LP.DoFilter()
	
	local Content = EncounterJournal.encounter
	local Instance = Content.instance
	local Info = Content.info

	local Title = Info.encounterTitle
	local Details = Info.detailsScroll
	local DetailsBar = Details.ScrollBar
	local Loot = Info.lootScroll	
	
	local Filter = Loot.classClearFilter
	local FilterClear = _G[Filter:GetName() .. 'ExitButton'] 	
	
	if (C_LP.CustomFilter) then		
		
		Loot.update = C_LP.DoFilter
		
		FilterClear:SetScript('OnClick', function()
			C_LP.ClearFilter(nil,nil,nil)
			EncounterJournal_LootUpdate()
		end)
		
		Loot:SetHeight(357)
		if(C_LP.CustomFilter=="MY") then
			Filter.text:SetText(L["FILTER_MY_PREFERENCES"])
		elseif(C_LP.CustomFilter=="GUILD") then
			Filter.text:SetText(L["FILTER_GUILD_PREFERENCES"])
		else
			class = C_LP.guilditems[C_LP.CustomFilter].class
			Filter.text:SetText(string.format(L["PLAYER_PREFERENCES"],RAID_CLASS_COLORS[class].colorStr,C_LP.CustomFilter))
		end
		Filter:Show()

		-- Update items
		local offset = HybridScrollFrame_GetOffset(Loot)
		local items = Loot.buttons
		
		local numButtons = #items
		local lastButton = offset + numButtons
		local buttonHeight = items[1]:GetHeight()
		local index = 0

		for i = 1, EJ_GetNumLoot() do
			local name, icon, slot, armorType, itemID, link, encounter = EJ_GetLootInfoByIndex(i)

			if C_LP.FilterItem(C_LP.CustomFilter,itemID) then
				index = index + 1
				
				if index > offset and index <= lastButton then
					local item = items[index - offset]
					item.name:SetText(name)
					item.icon:SetTexture(icon)
					item.slot:SetText(slot)
					item.armorType:SetText(armorType)
					item.boss:SetFormattedText(BOSS_INFO_STRING, EJ_GetEncounterInfo(encounter));					
					item.encounterID = encounter;
					item.itemID = itemID
					item.link = link
					item.index = i
					item:Show()
					
					if item.showingTooltip then
						GameTooltip:SetItemByID(itemID)
					end
				end
			end
		end

		for i = (index - offset + 1), numButtons do
			if items[i] then
				items[i]:Hide()
			end
		end

		HybridScrollFrame_Update(Loot, index * buttonHeight, Loot:GetHeight())		
	else
		Loot.update = EncounterJournal_LootUpdate
	end
	
end

function C_LP.EncounterJournal_OnHide()

	if C_LP.Updated then
		C_LP:SendPreferences()
		C_LP.Updated = false
	end
end

function C_LP.EncounterJournal_OnShow()

	C_LP.Updated = false
			
	C_LP:RequestPreferences()
	
	if not C_LP.DropDownsCreated then
			
		UIDropDownMenu_Initialize(EncounterJournal.encounter.info.lootScroll.lootFilter, C_LP.LootFilter, "MENU");
	
		buttons = EncounterJournal.encounter.info.lootScroll.buttons
		numButtons = #buttons
		
		for i = 1 , numButtons do
		
			width = 155
			local dropDown = CreateFrame("Frame", buttons[i]:GetName().."DD", buttons[i], "UIDropDownMenuTemplate")
			dropDown:SetPoint("CENTER",0,-20)
			UIDropDownMenu_SetWidth(dropDown, 115) 
			UIDropDownMenu_Initialize(dropDown, C_LP.ItemDropDown_Menu)
		
			dropDown:SetAlpha(0.5)		
			
			buttons[i].DD = dropDown;
			
			hooksecurefunc(buttons[i],"Show",function (object,text)
				if(object.itemID) then
					object.DD.itemID = object.itemID
					UIDropDownMenu_Initialize(object.DD, C_LP.ItemDropDown_Menu)				
				end
			end)
		end
		
		C_LP.DropDownsCreated = true
	end
end

function C_LP.EncounterJournal_OnLoad()
	
end

function C_LP:InitDungeonJournal()

	if not C_LP.HookJournal then
		EncounterJournal:HookScript("OnShow",C_LP.EncounterJournal_OnShow)
		EncounterJournal:HookScript("OnLoad",C_LP.EncounterJournal_OnLoad)
		EncounterJournal:HookScript("OnHide",C_LP.EncounterJournal_OnHide)
		
		hooksecurefunc("EncounterJournal_SetFilter",C_LP.ClearFilter)
		hooksecurefunc("EncounterJournal_LootUpdate",C_LP.DoFilter)
		
		C_LP.HookJournal = true
	end 
	
end