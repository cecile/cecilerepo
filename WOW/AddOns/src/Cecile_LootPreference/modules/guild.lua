----------------------------------------------------------------------------------------------------
-- Guild module, to know our guild name, and guild changes
--

--get the addon  engine
local C_LP = select( 2, ... )

--guild init switch
C_LP.guildinit = false

--find the class of a giving player, only called when we dont have it stored
function C_LP:FindClass(player)	

	if C_LP.guildinit then
	
		local numTotalGuildMembers = GetNumGuildMembers()
		
		for i = 1, numTotalGuildMembers do		
			
			local name, rank, rankIndex, level, class, zone, note, 
			officernote, online, status, classFileName, 
			achievementPoints, achievementRank, isMobile, canSoR, repStanding = GetGuildRosterInfo(i)
			
			if name==player then
				return classFileName
			end					
		end		
	end
	
	return "PRIEST"
	
end

--init guild module, and send items database for our guild, remove from database unguiled data
-- when we init our guil data we register to recieve the addon messages since they will only work
-- in the guild channel
function C_LP:InitGuild()

	local myrealm = GetRealmName();
	
	if C_LP.myguild =="C_LPNOGUILD" then
		if( C_LP.db[myrealm] ) then
			C_LP.db[myrealm][C_LP.myguild] = nil;
		end
	end
	
	C_LP.myname=UnitName("player")	
	C_LP.myguild = GetGuildInfo("player")
	_,myclass = UnitClass("player")
	
	if C_LP.db[myrealm]==nil then
		C_LP.db[myrealm] = {}
	end
	
	if C_LP.db[myrealm][C_LP.myguild]==nil then
		C_LP.db[myrealm][C_LP.myguild] = {}
	end
	
	if C_LP.db[myrealm][C_LP.myguild][C_LP.myname]==nil then
		C_LP.db[myrealm][C_LP.myguild][C_LP.myname] = {}
	end

	C_LP.guilditems = C_LP.db[myrealm][C_LP.myguild]
	
	if C_LP.db[myrealm][C_LP.myguild][C_LP.myname].items==nil then
		C_LP.db[myrealm][C_LP.myguild][C_LP.myname].items = {}
	end
	
	C_LP.db[myrealm][C_LP.myguild][C_LP.myname].class=myclass
	C_LP.myitems = C_LP.db[myrealm][C_LP.myguild][C_LP.myname].items		
							
	--Only register messages if we are in a guild
	C_LP:InitMessages()
	
end

-- when the guild its updated (event), we check if we have EPGP and update values,
-- this olso will make that if the EPGP config values change we are updated.
-- additionally the first time that we get our guild name we set our items databases for our guild
function C_LP:OnGuildUpdate()
	
	if(GetGuildInfo("player")) then
	
		GuildRoster()
		C_LP:FindEPGP()
		
		if not C_LP.guildinit then
		
			C_LP:InitGuild()
		
			C_LP.guildinit = true
		
		end
		
	end

end
