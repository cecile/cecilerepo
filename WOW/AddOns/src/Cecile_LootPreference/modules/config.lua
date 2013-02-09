----------------------------------------------------------------------------------------------------
-- general configuration module
--

--get the addon  engine
local C_LP = select( 2, ... )

--get the locale table from engine
local L = C_LP.L;

--set default (empty) items preferences database : 
-- db = general , myitems = own items, guilditems = current character guild items
C_LP.db = {}
C_LP.myitems = {}
C_LP.guilditems = {}

--default addon tittle
C_LP.title="Cecile_LootPreference"

--sorting weights
C_LP.PRIORITY_SORT = {
	LOOT_MAIN = 10,
	LOOT_MINOR = 9,
	LOOT_OFF = 8,
}

--reverse lookup key from a table value
function C_LP:GetKeyForValue( t, value )
  for k,v in pairs(t) do
    if v==value then return k end
  end
  return nil
end

--init default config variables and items db
function C_LP:InitConfig()

	--get values from metadata
	C_LP.title = GetAddOnMetadata("Cecile_LootPreference", "Title") 
	C_LP:InitVersion()
	
	--get addon saved variables, init to empty if we dont have, yet
	if C_LP_DB == nil then
		C_LP_DB = {}
	end
	C_LP.db = C_LP_DB
	
	--store unit name, class  & realm
	C_LP.myname=UnitName("player")
	local _,myclass = UnitClass("player")
	
	local myrealm = GetRealmName();
	C_LP.myguild = "C_LPNOGUILD"
			
	--set items preferences databases
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