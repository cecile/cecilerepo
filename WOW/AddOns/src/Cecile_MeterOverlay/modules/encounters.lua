----------------------------------------------------------------------------------------------------
-- Encounters module : Handle different boss encounters AddOns
--

--if DB; or BigWigs its not present, don't use this module
local hasDBM 		= IsAddOnLoaded( "DBM-Core" );
local hasBigWigs 	= IsAddOnLoaded( "BigWigs" );

if not (hasDBM or hasBigWigs) then return; end


--get the engine and create the module
local Engine = select(2,...);
local mod = Engine.AddOn:NewModule("encounters");

--debug
local debug = Engine.AddOn:GetModule("debug");

--get locale
local L = Engine.Locale;

--not in use	
function mod.OnEvent()

end

function mod:getEncounterDB(encounter,instanceName,difficultyName)

	--init encounter db if not created
	if not Engine.GLOBAL.encounters then
		Engine.GLOBAL.encounters = {};
	end
	
	--init instance if not created
	if not Engine.GLOBAL.encounters[instanceName] then
		Engine.GLOBAL.encounters[instanceName] = {};
	end
	
	--init difficult if not created
	if not Engine.GLOBAL.encounters[instanceName][difficultyName] then
		Engine.GLOBAL.encounters[instanceName][difficultyName] = {};
	end	
	
	--init difficult if not created
	if not Engine.GLOBAL.encounters[instanceName][difficultyName][encounter] then
		Engine.GLOBAL.encounters[instanceName][difficultyName][encounter] = {};
	end	
		
	--get the db
	local encounterDB = Engine.GLOBAL.encounters[instanceName][difficultyName][encounter];
	
	
	if not encounterDB.records then
		encounterDB.records = {};
	end
	
	--if not topDPS
	if not encounterDB.records.DPS then
		encounterDB.records.DPS = {
			name = "",
			dps = 0,
			damage = 0,
			enclass = "",
			timestamp = 0,
		};
	end;
	
	--if not topHPS
	if not encounterDB.records.HPS then
		encounterDB.records.HPS = {
			name = "",
			hps = 0,
			healing = 0,
			enclass = "",
			timestamp = 0,
		};
	end;	

	--if not playerMaxDPS
	if not encounterDB.records.playerDPS then
		encounterDB.records.playerDPS = {
			name = "",
			dps = 0,
			damage = 0,
			enclass = "",
			timestamp = 0,
		};
	end;
	
	--if not playerMaxHPS
	if not encounterDB.records.playerHPS then
		encounterDB.records.playerHPS = {
			name = "",
			hps = 0,
			healing = 0,
			enclass = "",
			timestamp = 0,
		};
	end;		
	
	return encounterDB;
	
end

function mod:notifyNewRecord(current, new, mode,isPlayer)

	if(current.name == "") then
		debug("new %s %s record %s (%s) '%s': %s", 
			isPlayer and 'player' or 'top',
			(mode == Engine.TYPE_DPS) and 'DPS' or 'HPS',
			mod.encounterDB.name, mod.encounterDB.difficultyName,
			new.name,
			(mode == Engine.TYPE_DPS) and new.dps or new.hps
		);
	else
		debug("new %s %s record %s (%s) '%s': %s. Previous was '%s' : %s", 
			isPlayer and 'player' or 'top',
			(mode == Engine.TYPE_DPS) and 'DPS' or 'HPS',
			mod.encounterDB.name, mod.encounterDB.difficultyName,
			new.name, 
			(mode == Engine.TYPE_DPS) and new.dps or new.hps,
			current.name, 
			(mode == Engine.TYPE_DPS) and current.dps or current.hps
		);	
	end
			
end

function mod:notifyNotRecord(current, new, mode,isPlayer)

	debug("%s %s record retained %s (%s) '%s': %s. Attempt was '%s' : %s", 
		isPlayer and 'player' or 'top',
		(mode == Engine.TYPE_DPS) and 'DPS' or 'HPS',	
		mod.encounterDB.name, mod.encounterDB.difficultyName,
		current.name, 
		(mode == Engine.TYPE_DPS) and current.dps or current.hps,
		new.name, 
		(mode == Engine.TYPE_DPS) and new.dps or new.hps		
	);
	
end

function mod:analyseRecord(current, possible, mode,isPlayer)
	
	--if not data return
	if not possible then return; end
	
	--do we have a new record?
	local newRecord = false;
	
	--check mode and if we have record
	if mode == Engine.TYPE_DPS then
	
		if current.dps == 0 then
			newRecord = true;				
		else		
			if possible.dps>current.dps then
				newRecord = true;
			end		
		end
		
	elseif mode == Engine.TYPE_HEAL then

		if current.hps == 0 then
			newRecord = true;
		else		
			if possible.hps>current.hps then			
				newRecord = true;
			end		
		end
	
	end
	
	if newRecord then
		
		--notify the record
		mod:notifyNewRecord(current, possible, mode,isPlayer);
		
		--copy the record
		current = possible;
		
		--store for this record the timestamp and group size
		current.timestamp = mod.timestamp;
		current.groupSize = mod.instanceGroupSize;

	else
	
		---notify attempt
		mod:notifyNotRecord(current, possible, mode,isPlayer);
		
	end
	
	--return the new (or same) record
	return current;
	
end

function mod:recordEncounter(encounter)

	debug("recordEncounter: '%s'", encounter);
	
	--get the localized difficult name
	local instanceName, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceMapID, instanceGroupSize  = GetInstanceInfo();

	--get the DB for this encounter
	mod.encounterDB = mod:getEncounterDB(encounter,instanceName,difficultyName);
	
	--store encounter data
	mod.encounterDB.name				= encounter;
	mod.encounterDB.instanceName 		= instanceName;
	mod.encounterDB.instanceType 		= instanceType;
	mod.encounterDB.difficultyID 		= difficultyID;
	mod.encounterDB.difficultyName 		= difficultyName;
	mod.encounterDB.maxPlayers 			= maxPlayers;
	
	--store in the mode the instance group size for record saving
	mod.instanceGroupSize = instanceGroupSize;
	
	--set timestamp for record saving
	mod.timestamp = time();
	
	--get top players
	local topDPS = mod.meter:GetTopPlayerData( Engine.CURRENT_DATA, Engine.TYPE_DPS );
	local topHPS = mod.meter:GetTopPlayerData( Engine.CURRENT_DATA, Engine.TYPE_HEAL );
	
	--get our player data
	local playerDPS = mod.meter:GetPlayerData( Engine.CURRENT_DATA, Engine.TYPE_DPS );
	local playerHPS = mod.meter:GetPlayerData( Engine.CURRENT_DATA, Engine.TYPE_HEAL );
	
	--get the current records
	local currentTopDPS 	= mod.encounterDB.records.DPS;
	local currentTopHPS 	= mod.encounterDB.records.HPS;
	local currentPlayerDPS 	= mod.encounterDB.records.playerDPS;
	local currentPlayerHPS 	= mod.encounterDB.records.playerHPS;

	--analyse top records
	mod.encounterDB.records.DPS = mod:analyseRecord(currentTopDPS, topDPS, Engine.TYPE_DPS,false);
	mod.encounterDB.records.HPS = mod:analyseRecord(currentTopHPS, topHPS, Engine.TYPE_HEAL,false);
	
	--analyse player records
	mod.encounterDB.records.playerDPS = mod:analyseRecord(currentPlayerDPS, playerDPS, Engine.TYPE_DPS,true);
	mod.encounterDB.records.playerHPS = mod:analyseRecord(currentPlayerHPS, playerHPS, Engine.TYPE_HEAL,true);		
	
end

function mod.dbmCallback(event, dbmModule)

	debug("dbmCallback: %s %s", event, dbmModule.combatInfo.name);
   
	mod:recordEncounter(dbmModule.combatInfo.name);

end

function mod.bwCallback(event, bwModule)

	debug("bwCallback: %s %s", event, bwModule.displayName);
	
	mod:recordEncounter(bwModule.displayName);	
	
end

--initialize module
function mod:OnInitialize()

	--store the meter
	mod.meter = Engine.AddOn:GetModule("meter");
	
	-- register DBM callbacks
	if hasDBM then		
	
		DBM:RegisterCallback("kill", mod.dbmCallback);
		debug("DBM callback registered");
		
	-- register BigWigs callbacks
	elseif hasBigWigs then
	
		debug("BigWigs message listener registered");	
		BigWigsLoader.RegisterMessage(mod, "BigWigs_OnBossWin", mod.bwCallback)
		
	end
	
	debug("Encounters module loaded");
end
