local C_LP = select( 2, ... )
local f = CreateFrame("Frame");
C_LP.mainframe = f;
local L = C_LP.L;

function f:EventHandler(event,arg1,arg2,arg3,arg4)

	if(event=="GUILD_ROSTER_UPDATE") then			
		C_LP:OnGuildUpdate()		
	end
	
	if(event=="CHAT_MSG_ADDON") then
		C_LP:MessageRecieve(arg1,arg4,arg2)
	end
	
	if(event=="PLAYER_ENTERING_WORLD") then
		C_LP:InitTooltip()
		print(string.format(L["LOAD_MESSAGE"],C_LP.title,C_LP.version.label))			
		f:UnregisterEvent("PLAYER_ENTERING_WORLD");		
	end
	
	if(event=="ADDON_LOADED" and (arg1=="Cecile_LootPreference" or arg1=="Blizzard_EncounterJournal")) then	
		if(arg1=="Cecile_LootPreference") then					
			C_LP:InitConfig()			
		end
		if (IsAddOnLoaded("Blizzard_EncounterJournal") and IsAddOnLoaded("Cecile_LootPreference")) then	
			C_LP:InitDungeonJournal()			
			f:UnregisterEvent("ADDON_LOADED");
		end				
	end
	
end

f:SetScript("OnEvent",f.EventHandler);
f:RegisterEvent("ADDON_LOADED");
f:RegisterEvent("GUILD_ROSTER_UPDATE");
f:RegisterEvent("PLAYER_ENTERING_WORLD");
