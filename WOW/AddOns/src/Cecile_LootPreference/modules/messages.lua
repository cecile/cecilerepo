local C_LP = select( 2, ... )
local L = C_LP.L;

C_LP.MESSAGES = {
	PREFERENCES_REQUEST = { prefix = "C_LP_REQUEST" },
	PREFERENCES_RESPONSE = { prefix = "C_LP_RESPONSE",max=200 },
}

function C_LP:InitMessages()

	for k,v in pairs(C_LP.MESSAGES) do
		v.prefix = v.prefix..C_LP.version.major..'_'..C_LP.version.minor
		RegisterAddonMessagePrefix(v.prefix)
		
		--print("registering prefix:"..v.prefix)
	end
	
	C_LP.mainframe:RegisterEvent("CHAT_MSG_ADDON");
end

function C_LP:SendPreferences()

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

function C_LP:RequestPreferences()
	--print("RequestPreferences")
	SendAddonMessage(C_LP.MESSAGES.PREFERENCES_REQUEST.prefix,msg,"GUILD")
end

function C_LP:MessageRecieve(message,sender,data)
	if message==C_LP.MESSAGES.PREFERENCES_REQUEST.prefix then
		if not (C_LP.myname==sender) then
			C_LP:SendPreferences()
		end
	elseif message==C_LP.MESSAGES.PREFERENCES_RESPONSE.prefix then
		if not (C_LP.myname==sender) then
			C_LP:PreferencesRecieve(sender,data)
		end
	end
end