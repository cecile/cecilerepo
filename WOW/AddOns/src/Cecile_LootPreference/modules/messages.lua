----------------------------------------------------------------------------------------------------
-- Messaging module, handle and send addon messages within the guild
--

--get the addon  engine
local C_LP = select( 2, ... )

--get the locale table from engine
local L = C_LP.L;

--messages init switch
C_LP.messagesInit = false

--list of messages that we handle, we have a flag to determine if they change by version, and the
-- max length of the message
C_LP.MESSAGES = {
	ADDON_VERSION = { prefix = "C_LP_ADDON_VER" , changeByVersion=false},
	WRONG_VERSION = { prefix = "C_LP_WRONG_VER" , changeByVersion=false},
	PREFERENCES_REQUEST = { prefix = "C_LP_REQUEST" , changeByVersion=true},
	PREFERENCES_RESPONSE = { prefix = "C_LP_RESPONSE",max=200, changeByVersion=true },
}

--init the messages, registering the prefix, for each prefix if the message change by version we add
-- the major and minor version of the addon, so players will not get messages from addon of
-- different versions, but will get it from diferent releases of the same version.
-- So when we need to perform a deep change in the messages system we must increase the minor
-- version, and if not just the release. After messages are registered start to get addon messages
function C_LP:InitMessages()

	for k,v in pairs(C_LP.MESSAGES) do
		if (v.changeByVersion) then
			v.prefix = v.prefix..C_LP.version.major..'_'..C_LP.version.minor
		end
		RegisterAddonMessagePrefix(v.prefix)
		
		--print("registering prefix:"..v.prefix)
	end

	C_LP.messagesInit = true
	C_LP.mainframe:RegisterEvent("CHAT_MSG_ADDON");
	
	--check version
	C_LP:CheckVersion()	
end

--send our preferences to guild channel, the items will send in format:
--  item:priority,item:priority,item:priority,item:priority,
--  item and priority will be hex values, when the messages its greater that MAX character we send
--  this items and continue with the rest in another message.
function C_LP:SendPreferences()

	if not C_LP.messagesInit then
		return
	end
	
	local msg = ""
	
	local id = ""
	local preference = ""
	
	for k,v in pairs(C_LP.myitems) do
	
		id = string.format("%X",k)
		
		if (not (v=="") ) then		
			preference = string.format("%X",C_LP.PRIORITY_SORT[v])
		else
			preference = "0"
		end
		
		msg = msg .. id .. ":" .. preference .. ","

		
		if strlen(msg)>C_LP.MESSAGES.PREFERENCES_RESPONSE.max then
			SendAddonMessage(C_LP.MESSAGES.PREFERENCES_RESPONSE.prefix,msg,"GUILD")
			--print("SendPreferences:"..msg)	
			msg = ""			
		end
	end

	if not (msg=="") then
		--print("SendPreferences:"..msg)	
	
		SendAddonMessage(C_LP.MESSAGES.PREFERENCES_RESPONSE.prefix,msg,"GUILD")
	end
end

--recive the preferences from a player, store on our guild database, decode the values from hex
-- to decimal, if we do not know wich class this player have we get it from the guild info
-- and store it.
function C_LP:PreferencesRecieve(sender,msg)
	
	--print("PreferencesRecieve:"..sender.."="..msg)
	
	if C_LP.guilditems[sender] == nil then
		C_LP.guilditems[sender] = {}
	end
	
	if C_LP.guilditems[sender].items == nil then
		C_LP.guilditems[sender].items = {}
	end
	
	if C_LP.guilditems[sender].class == nil then
		C_LP.guilditems[sender].class = C_LP:FindClass(sender)
	end
	
	for k, v in string.gmatch(msg, "(%w+):(%w+)") do	
	
		if(tonumber(v,16)) then
			priority = C_LP:GetKeyForValue(C_LP.PRIORITY_SORT,tonumber(v,16))
		else
			priority = ""
		end		
		
		C_LP.guilditems[sender].items[tonumber(k,16)] = priority
	end	
	
end

--send a message to request preferences from other guild players, we do not send preferences if
-- the messages module its not init yet
function C_LP:RequestPreferences()

	--print("RequestPreferences")
	if not C_LP.messagesInit then
		return
	end	
	
	SendAddonMessage(C_LP.MESSAGES.PREFERENCES_REQUEST.prefix,msg,"GUILD")
	
end

--recieve an addon messages, depending the message whe send preferences o we get a response
-- because we are using the guild channel we get our own messages as well so we need to filter
-- them in order to no response to ourself
function C_LP:MessageRecieve(message,sender,data)

	if message==C_LP.MESSAGES.PREFERENCES_REQUEST.prefix then
	
		if not (C_LP.myname==sender) then
			C_LP:SendPreferences()
		end
		
	elseif message==C_LP.MESSAGES.PREFERENCES_RESPONSE.prefix then
	
		if not (C_LP.myname==sender) then
			C_LP:PreferencesRecieve(sender,data)
		end
		
	elseif message==C_LP.MESSAGES.ADDON_VERSION.prefix then
	
		--if not (C_LP.myname==sender) then
			C_LP:OtherPlayerVersion(sender,data)
		--end
		
	elseif message==C_LP.MESSAGES.WRONG_VERSION.prefix then
	
		--if not (C_LP.myname==sender) then
			C_LP:MyWrongVersion(sender,data)
		--end		
		
	end	
end

--send our local version to the guild
function C_LP:SendMyVersion(version)

	--print("SendMyVersion:"..version)
	
	if not C_LP.messagesInit then
		return
	end	
			
	SendAddonMessage(C_LP.MESSAGES.ADDON_VERSION.prefix,version,"GUILD")
end

--send to a playar a message that he has a wrong version
function C_LP:SendWrongVersion(toPlayer,version)

	--print("SendWrongVersion:"..toPlayer.." "..version)
	
	if not C_LP.messagesInit then
		return
	end	
	
	SendAddonMessage(C_LP.MESSAGES.WRONG_VERSION.prefix,version,"WHISPER",toPlayer)
end
