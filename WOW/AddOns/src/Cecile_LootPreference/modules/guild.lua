local C_LP = select( 2, ... )

C_LP.guildinit = false
C_LP.epgp = false

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

function C_LP:FindEPGP()
	C_LP.epgp = false
	C_LP.epgp_basegp = 1
	
	local info = GetGuildInfoText()
	if info then
		local lines = {string.split("\n", info)}
		local in_block = false
		
		for _,line in pairs(lines) do			
			if line == "-EPGP-" then
			in_block = not in_block
			elseif in_block then
				C_LP.epgp = true
				local v = line:match("@BASE_GP:(%d+)")
				if (v) then
					C_LP.epgp_basegp = tonumber(v)					
					break
				end
			end
		end
		
	end
end

function C_LP:DecodeEPGPNote(note)
	if note then
		if note == "" then
			return 0, 0
		else
			local ep, gp = string.match(note, "^(%d+),(%d+)$")
			if ep then
				return tonumber(ep), tonumber(gp)
			end
		end
	end  
end

function C_LP:GetPRFromNote(note)
	local pr = 0
	local ep,gp = C_LP:DecodeEPGPNote(note)
 
	if ep then
		pr = ep/(gp+C_LP.epgp_basegp)
	end 
 
	return pr
end

function C_LP:GetPR(player)
	
	local pr = 0
	
	local numTotalGuildMembers = GetNumGuildMembers(true)
	
	for gm = 1, numTotalGuildMembers do		
		
		local name, rank, rankIndex, level, class, zone, note, 
		officernote, online, status, classFileName, 
		achievementPoints, achievementRank, isMobile, canSoR, repStanding = GetGuildRosterInfo(gm)
		
		if name == player then					
			pr = C_LP:GetPRFromNote(officernote)						
			break
		end
	end			
	return pr
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
