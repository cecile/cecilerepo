----------------------------------------------------------------------------------------------------
-- Boss module, show tooltip on bosses
--

--get the addon  engine
local C_LP = select( 2, ... )

--get the locale table from engine
local L = C_LP.L;

--switch to know if we have hook allready map boss buttons
C_LP.mapBoosButtonsHooked = false

--name, instanceType, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID = GetInstanceInfo()
--difficultyIndex:
-- 0 = None
-- 1 = 5 Player & Scenario
-- 2 = 5 Player (Heroic)
-- 3 = 10 Player
-- 4 = 25 Player
-- 5 = 10 Player (Heroic)
-- 6 = 25 Player (Heroic)
-- 7 = Raid Finder
-- 8 = Challenge Mode
-- 9 = 40 Player
--
local DJ_DIFF_5MAN              = 1
local DJ_DIFF_5MAN_HEROIC       = 2

local DJ_DIFF_10MAN             = 1
local DJ_DIFF_25MAN             = 2
local DJ_DIFF_10MAN_HEROIC      = 3
local DJ_DIFF_25MAN_HEROIC      = 4
local DJ_DIFF_LFRAID            = 5

C_LP.difficultToDJ = {
	[1]  	= DJ_DIFF_5MAN,
	[2]  	= DJ_DIFF_5MAN_HEROIC,
	[3]  	= DJ_DIFF_10MAN,
	[4]  	= DJ_DIFF_25MAN,
	[5]  	= DJ_DIFF_10MAN_HEROIC,
	[6]  	= DJ_DIFF_25MAN_HEROIC,
	[7]  	= DJ_DIFF_LFRAID,
	[8]  	= DJ_DIFF_5MAN_HEROIC,
	[9] 	= DJ_DIFF_25MAN,
}

local DJ_DIFF_DUNGEON_TBL = 
{
    [DJ_DIFF_5MAN] 			= { size =  5, prefix = PLAYER_DIFFICULTY1 },
    [DJ_DIFF_5MAN_HEROIC] 	= { size =  5, prefix = PLAYER_DIFFICULTY2 },
}
 
local DJ_DIFF_RAID_TBL = 
{    
    [DJ_DIFF_10MAN] 		= { size = 10, prefix = PLAYER_DIFFICULTY1 },
	[DJ_DIFF_25MAN] 		= { size = 25, prefix = PLAYER_DIFFICULTY1 },
    [DJ_DIFF_10MAN_HEROIC] 	= { size = 10, prefix = PLAYER_DIFFICULTY2 },    
    [DJ_DIFF_25MAN_HEROIC] 	= { size = 25, prefix = PLAYER_DIFFICULTY2 },
	[DJ_DIFF_LFRAID] 		= { size = 25, prefix = PLAYER_DIFFICULTY3 },
}

--on mouse over a boss button in the world map, modify tooltip to swho the players that has a 
-- preference on that concrete boss. If the player its in an instance the loot that this tooltip
-- uses its the same as the current instance, elsewhere the one in use in dungeon journal
function C_LP.MapBossButton_OnEnter(button)
	
	--get current difficult from raid, if not from dungeon journal
	local difficultyIndex = DJ_DIFF_LFRAID;
	--Path 5.2 remove GetInstanceDifficulty(), using GetInstanceInfo instead
	local difficultyValue = select(3,GetInstanceInfo())
	
	if difficultyValue == nil or difficultyValue == 0 then
		difficultyIndex = EJ_GetDifficulty()
	else
		difficultyIndex = C_LP.difficultToDJ[difficultyValue];
	end
		
	--set values in dungeon journal for get the right loot
	EJ_SetDifficulty(difficultyIndex)
	EJ_SelectInstance(button.instanceID)
	EJ_SelectEncounter(button.encounterID)		
	
	--control if any player have loot
	local anyplayer=false
	
	--loot for players found
	local playerLoot = {}
	
	--go trought all the loot
	for i = 1, EJ_GetNumLoot() do
	
		local name, icon, slot, armorType, itemID, link, encounter = EJ_GetLootInfoByIndex(i)
	
		--per item compare with our guild items and store the player, if the player its allready
		-- stored update the priority to the highger value
		for k,v in pairs(C_LP.guilditems) do
			if v.items[itemID] and (not (v.items[itemID]=="")) then
				
				preference = {}
				preference.player = k
				preference.class = v.class
				preference.priority = v.items[itemID]
					
				if playerLoot[k]==nil then								
					playerLoot[k]=preference
				else	
					if C_LP.PRIORITY_SORT[preference.priority] > C_LP.PRIORITY_SORT[playerLoot[k].priority] then
						playerLoot[k].priority=preference.priority
					end					
				end
				
				anyplayer = true
			end
		end
				
	end
		
	--if we have players with loot
	if (anyplayer) then
	
		--guild update for EPGP
		if C_LP.epgp then
			GuildRoster()
		end
		
		--since lua does not support sorting tables with keys we sort the keys, we calculate PR if
		-- EPGP its present, but first get the keys for the table and store them
		local keys = {}
		for k,v in pairs(playerLoot) do
			keys[#keys+1] = v.player
			if C_LP.epgp then
				v.epgp_pr = C_LP:GetPR(v.player)
			end
		end	
		
		--sort the key table by priority, if we use EPGP by PR+priority
		if C_LP.epgp then 
		
			table.sort(keys, function(a,b) 						

				if (playerLoot[a].priority == playerLoot[b].priority) then
					return playerLoot[a].epgp_pr>playerLoot[b].epgp_pr
				else
					return C_LP.PRIORITY_SORT[playerLoot[a].priority] > C_LP.PRIORITY_SORT[playerLoot[b].priority]
				end			
				
			end)	
		else
			table.sort(keys, function(a,b) 		
				
				return C_LP.PRIORITY_SORT[playerLoot[a].priority] > C_LP.PRIORITY_SORT[playerLoot[b].priority]
							
			end)		
		end

		--first line in tooltip, including mode
		local entry = nil;
		
        if EJ_InstanceIsRaid() then
            entry = DJ_DIFF_RAID_TBL[difficultyIndex];
		else
			entry = DJ_DIFF_DUNGEON_TBL[difficultyIndex];
        end
		
		local mode = ""
		
		if (entry) then 
			mode=string.format(ENCOUNTER_JOURNAL_DIFF_TEXT, entry.size, entry.prefix);
		end
		
		WorldMapTooltip:AddDoubleLine(L["LOOT_PREFERENCES"],mode,1.0,1.0,1.0,1.0,0.96,0.41)
			
		--for each sorted key get the values and display in the tooltip, display PR if we use EPGP
		for k,v in pairs(keys) do
			
			v=playerLoot[v]
			classcolor = RAID_CLASS_COLORS[v.class]				
			
			priority_text = L[v.priority]
			
			if C_LP.epgp then
				priority_text = priority_text .. " (PR:" .. string.format("%.4g",v.epgp_pr)..")"			
			end
			
			WorldMapTooltip:AddDoubleLine(v.player,priority_text,classcolor.r,classcolor.g,classcolor.b)
		end	
		
		WorldMapTooltip:Show()
	end
end

--trigger when boss buttons are added to world map, hook worldmap boss buttons, if they are not
-- hooked, so we could modify tooltips
function C_LP.EncounterJournal_AddMapButtons()
	
	local index = 1
	local continue = true
	local bossButton = nil
	while continue do
	
		bossButton = _G["EJMapButton"..index]
		
		if( bossButton == nil ) then
		
			continue = false
		else
			if not bossButton.isHooked then
			
				bossButton:HookScript("OnEnter",C_LP.MapBossButton_OnEnter)								
				bossButton.isHooked = true
				
			end
		end
		
		index = index + 1
	end
	
end

--hook map boss buttons, if its not hooked
function C_LP:HookMapBossButtons()

	if not mapBoosButtonsHooked then
		
		hooksecurefunc("EncounterJournal_AddMapButtons",C_LP.EncounterJournal_AddMapButtons)
		
		mapBoosButtonsHooked = true
	end
end

--init boss tooltip hook
function C_LP:InitBoss()

	C_LP:HookMapBossButtons()
	
end