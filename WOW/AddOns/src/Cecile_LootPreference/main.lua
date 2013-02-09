----------------------------------------------------------------------------------------------------
-- Main file, create the main addon frame and handle the addon events
--

--get the addon engine
local C_LP = select( 2, ... )

--set the global engine
_G.C_LP = C_LP

--create the main frame and store in the engine
local f = CreateFrame("Frame");
C_LP.mainframe = f;

--get the locale table from engine
local L = C_LP.L;

--event handler
function f:EventHandler(event,arg1,arg2,arg3,arg4)

	--guild updated event, pass to guild module
	if(event=="GUILD_ROSTER_UPDATE") then
	
		C_LP:OnGuildUpdate()	
		
	--addon message recieve, pass to messages module
	elseif(event=="CHAT_MSG_ADDON") then
	
		C_LP:MessageRecieve(arg1,arg4,arg2)
		
	--entering the world event, just to know when could hook tooltips, and pass to tooltip module
	-- display as well the localized wellcome message, them unregistering for not trigger anymore
	elseif(event=="PLAYER_ENTERING_WORLD") then
	
		C_LP:InitTooltip()		
		
		print(string.format(L["LOAD_MESSAGE"],C_LP.title,C_LP.version.label))			
		
		f:UnregisterEvent("PLAYER_ENTERING_WORLD")
		
	--loot items event , pass to the loot module
	elseif(event=="CHAT_MSG_LOOT") then
		
		C_LP:HandleLoot(arg1)
		
	--addons loaded event, for checking when dungeon journal its loaded to pass it to journal module
	-- as well when our addon its load we get our character/item database from savedvariables, if
	-- everything its doned we do not need to get the addon loaded event anymore.
	elseif(event=="ADDON_LOADED") then
		
		if ((arg1=="Cecile_LootPreference" or arg1=="Blizzard_EncounterJournal")) then	
		
			if(arg1=="Cecile_LootPreference") then					
				C_LP:InitConfig()			
			end			
			
			--only hook dungeon journal when both addons are loaded, them unregister event
			if (	IsAddOnLoaded("Blizzard_EncounterJournal") and 
					IsAddOnLoaded("Cecile_LootPreference") ) then	
				
				C_LP:InitDungeonJournal()	
				
				f:UnregisterEvent("ADDON_LOADED");
				
			end				
			
		end
		
	end	
end

--set the event handler for our addon frame
f:SetScript("OnEvent",f.EventHandler);

--set the events that we like to recieve
f:RegisterEvent("ADDON_LOADED");
f:RegisterEvent("GUILD_ROSTER_UPDATE");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
f:RegisterEvent("CHAT_MSG_LOOT");
