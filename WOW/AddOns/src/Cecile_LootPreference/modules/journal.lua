----------------------------------------------------------------------------------------------------
-- Dungeon journal module, modify the dungeon journal to our needs
--

--get the addon  engine
local C_LP = select( 2, ... )

--get the locale table from engine
local L = C_LP.L;

--flags for the dungeon journal, controls if its hooked, if we have add the dropdowns for items, 
-- if we have a custom item filter (my preferences, guild preferences or player preferences),
-- and if we have change our preferences but our guild its not yet updated
C_LP.HookJournal = false
C_LP.DropDownsCreated = false
C_LP.CustomFilter = false
C_LP.Updated = false

--when we click in a option in the item preference dropdown, we set the preference in our item
--- database and we mark that we need to send updates to the guild
function C_LP.ItemDropDown_OnClick(self, arg1, arg2, checked)
	
	C_LP.myitems[arg1.itemID] = arg2;
	
	UIDropDownMenu_SetSelectedValue(arg1,C_LP.myitems[arg1.itemID])
	
	C_LP.Updated = true
		
end

--create our options for the preferences dropdown per item, we as well set to selected the
-- current preference for that item in our item database
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

--if one of our custom filters its clicked we close the dropdow menu, store
-- the custom filter and them update the loot window
function C_LP.LootFilter_Click(self, arg1, arg2)
    
	C_LP.CustomFilter = arg1
	
	EJ_SetLootFilter(0, 0);
	
    CloseDropDownMenus(1);
	
    EncounterJournal_LootUpdate();
end

--build our custom filters list, this will add "my preferences","guild preferences", and players that
-- have items preferences in the list
function C_LP.LootFilter(self, level)

	--call default function for compability
	EncounterJournal_InitLootFilter(self,level)
	
	--has items flag
	local hasitems = false
	
	--we modify only the fist menu level in the filter dropwdown
	if (level == 1) then
	
		--create the to options for "My Preferences" & "Guild Preferences"
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
		
		--cycle all people in the guild to see if actually they have any preference, if they have
		-- we add him to the list, using class color.
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

--when the cross for remove filter its click just clear our custom filter
function C_LP.ClearFilter(self,arg1,arg2)
	C_LP.CustomFilter = false
	EncounterJournal_LootUpdate()
end

--help function that will filter an item id with our filter, if the filter its our own we check
-- if the item its on our list, if the filter its the guild we check for every player in the guild
-- until we found one player that has a preference on it, if its a player just check that player 
-- items
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

--callback from dungeon journal when updated the items it the list its need it, thats its happen
-- not only when we filter, as well when we scrool the list
function C_LP.DoFilter()
	
	--get current values from dungeon journal, including the clear filter button
	local Content = EncounterJournal.encounter
	local Instance = Content.instance
	local Info = Content.info

	local Title = Info.encounterTitle
	local Details = Info.detailsScroll
	local DetailsBar = Details.ScrollBar
	local Loot = Info.lootScroll	
	
	local Filter = Loot.classClearFilter
	local FilterClear = _G[Filter:GetName() .. 'ExitButton'] 	
	
	--if we have a custom filter do our logic, if not default dungeon journal logic
	if (C_LP.CustomFilter) then		
		
		--set the update function to be this function
		Loot.update = C_LP.DoFilter
		
		--hook the on click on clear filter button to actual remove any filter, including custom
		FilterClear:SetScript('OnClick', function()
			C_LP.ClearFilter(nil,nil,nil)
			EncounterJournal_LootUpdate()
		end)
		
		--set filter localized type and with class color if its a player, and display it
		Loot:SetHeight(357)				
		if(C_LP.CustomFilter=="MY") then
			Filter.text:SetText(L["FILTER_MY_PREFERENCES"])
		elseif(C_LP.CustomFilter=="GUILD") then
			Filter.text:SetText(L["FILTER_GUILD_PREFERENCES"])
		else
			class = C_LP.guilditems[C_LP.CustomFilter].class
			Filter.text:SetText(string.format(L["PLAYER_PREFERENCES"],
				RAID_CLASS_COLORS[class].colorStr,C_LP.CustomFilter))
		end
		Filter:Show()

		-- calculate how many items we going to display
		local offset = HybridScrollFrame_GetOffset(Loot)
		local items = Loot.buttons
		
		local numButtons = #items
		local lastButton = offset + numButtons
		local buttonHeight = items[1]:GetHeight()
		local index = 0

		--for each button see if we filter in our custom filter, and if not set the data and display
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

		--hide not used buttons and update the frame
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

--if we close the frame and we have updated the preferences send it to the guild
function C_LP.EncounterJournal_OnHide()

	if C_LP.Updated then
		C_LP:SendPreferences()
		C_LP.Updated = false
	end
end

--when we open the dungeon journal we request updated from the guild, so we see updated information
-- if we haven yet add the dropdown to the items we add in this point, as well we set that we do not
-- need to send our preferences on close, until we change some preference
function C_LP.EncounterJournal_OnShow()	
	
	C_LP.Updated = false
			
	C_LP:RequestPreferences()
	
	--if we have not create the dropdowns
	if not C_LP.DropDownsCreated then
			
		--create the dropdown for the filter button
		UIDropDownMenu_Initialize(EncounterJournal.encounter.info.lootScroll.lootFilter, C_LP.LootFilter, "MENU");
	
		buttons = EncounterJournal.encounter.info.lootScroll.buttons
		numButtons = #buttons
		
		--go trought all the buttons and create a dropdown for each item
		for i = 1 , numButtons do
		
			width = 155
			local dropDown = CreateFrame("Frame", buttons[i]:GetName().."DD", buttons[i], "UIDropDownMenuTemplate")
			dropDown:SetPoint("CENTER",0,-20)
			UIDropDownMenu_SetWidth(dropDown, 115) 
			UIDropDownMenu_Initialize(dropDown, C_LP.ItemDropDown_Menu)
		
			dropDown:SetAlpha(0.5)		
			
			buttons[i].DD = dropDown;
			
			--hook the show method for each button so we update the options when we the journal
			-- change the items for each button since allways Show() its called for each one
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

--not in use, on load the main frame for dungeon journal
function C_LP.EncounterJournal_OnLoad()
		
end

--init our dungeon journal hooks methods and scripts
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