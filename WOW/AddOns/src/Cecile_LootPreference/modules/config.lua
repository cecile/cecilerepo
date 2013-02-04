local C_LP = select( 2, ... )
local L = C_LP.L;

C_LP.db = {}
C_LP.myitems = {}
C_LP.guilditems = {}

C_LP.title="Cecile_LootPreference"

C_LP.version = {
	label = "0.0.0",
	major = 0,
	minor = 0,
	release = 0
}

C_LP.CustomFilter = false
C_LP.Updated = false

C_LP.PRIORITY_SORT = {
	LOOT_MAIN = 10,
	LOOT_MINOR = 9,
	LOOT_OFF = 8,
}

function C_LP:GetKeyForValue( t, value )
  for k,v in pairs(t) do
    if v==value then return k end
  end
  return nil
end

function C_LP:InitConfig()

	C_LP.title = GetAddOnMetadata("Cecile_LootPreference", "Title") 
	C_LP.version.label = GetAddOnMetadata("Cecile_LootPreference", "Version") 
	C_LP.version.major,C_LP.version.minor,C_LP.version.release = strsplit(".",C_LP.version.label)	
	
	if C_LP_DB == nil then
		C_LP_DB = {}
	end
	C_LP.db = C_LP_DB
		
	C_LP.myname=UnitName("player")
	local _,myclass = UnitClass("player")
	
	local myrealm = GetRealmName();
	C_LP.myguild = "C_LPNOGUILD"
			
	if C_LP.db[myrealm]==nil then
		C_LP.db[myrealm] = {}
	end
	
	if C_LP.db[myrealm][C_LP.myguild]==nil then
		C_LP.db[myrealm][C_LP.myguild] = {}
	end
	
	if C_LP.db[myrealm][C_LP.myguild][C_LP.myname]==nil then
		C_LP.db[myrealm][C_LP.myguild][C_LP.myname] = {}
	end	
	
	if C_LP.db[myrealm][C_LP.myguild][C_LP.myname].items==nil then
		C_LP.db[myrealm][C_LP.myguild][C_LP.myname].items = {}
	end
		
	C_LP.db[myrealm][C_LP.myguild][C_LP.myname].class=myclass
	
	C_LP.guilditems = C_LP.db[myrealm][C_LP.myguild]
	C_LP.myitems = C_LP.db[myrealm][C_LP.myguild][C_LP.myname].items	
end