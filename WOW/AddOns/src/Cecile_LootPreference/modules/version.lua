----------------------------------------------------------------------------------------------------
-- version module, controls if we have the latest version of the addon, and notify players
--

--get the addon  engine
local C_LP = select( 2, ... )

--get the locale table from engine
local L = C_LP.L;

--default addon version
C_LP.version = {
	label = "0.0.0",
	major = 0,
	minor = 0,
	release = 0
}

--flag to know if we are outdated, for ignoring version message if we allready know
C_LP.outdatedVersion = false

--collection of outdated players, to do not notify them if we allready done
C_LP.playersOutdated = {}

--get a version table from a version string
function C_LP:GetVersion(versionStr)

	local version = {}
	
	version.label = versionStr
	version.major,version.minor,version.release = strsplit(".",versionStr)	
	
	return version
end

--get version from metadata
function C_LP:InitVersion()
	
	C_LP.version = C_LP:GetVersion(GetAddOnMetadata("Cecile_LootPreference", "Version"))
	
end

--for checking if our version its out to date we send our version to the guild
function C_LP:CheckVersion()	

	C_LP:SendMyVersion(C_LP.version.label)		
	
end

--compare two versions and returns : 0 if are equals, 1 if the first its higher, or 2 if the second
function C_LP:CompareVersions(version1,version2)

	if (version1.major>version2.major) then
		return 1
	elseif version1.major<version2.major then
		return 2
	--equal major version
	else
		if (version1.minor>version2.minor) then
			return 1
		elseif version1.minor<version2.minor then
			return 2
		--equal major and minor version
		else				
			if (version1.release>version2.release) then
				return 1
			elseif version1.release<version2.release then
				return 2
			--equal major, minor and release version
			else
				return 0
			end														
		end		
	end
	
end

--a player has send him version to the guild
function C_LP:OtherPlayerVersion(player,version)
	
	--if we allready know that we are outdated skip it
	if(C_LP.outdatedVersion) then
		return
	end	
	
	local otherVersion = C_LP:GetVersion(version)
	
	local compare = C_LP:CompareVersions(C_LP.version,otherVersion)
	
	--if our version its higher thant the other player, we notify him that has a wrong version
	if (compare==1) then
		C_LP:PlayerWrongVersion(player,version)
	--if our version its lower thant the other player, we print a message and we set that we have
	-- an outdated version, so we do not display the message anymore during this session
	elseif (compare==2) then	
		C_LP:MyWrongVersion(player,version)
	end	

end

--if the player if outdated, notify him, but if we haven allready doing it this sesion we skip it
-- we store the versions of notified players
function C_LP:PlayerWrongVersion(player,version)

	if C_LP.playersOutdated[player] == nil then
	
		C_LP.playersOutdated[player] = version
		C_LP:SendWrongVersion(player,C_LP.version.label)
		
		print(string.format(L["PLAYER_VERSION"],C_LP.title,player,version))
		
	end
	
end
--a player notified us that we have a wrong version
function C_LP:MyWrongVersion(player,version)

	--if we allready know that we are outdated skip it
	if(C_LP.outdatedVersion) then
		return
	end
	
	print(string.format(L["WRONG_VERSION"],C_LP.title,version))
	
	C_LP.outdatedVersion = true
	
end