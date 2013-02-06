local C_LP = select( 2, ... )

C_LP.guildinit = false

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
