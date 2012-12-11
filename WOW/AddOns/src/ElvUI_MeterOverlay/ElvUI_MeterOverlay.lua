if not IsAddOnLoaded( "ElvUI" )  then return end

local E, L, V, P, G, _ = unpack(ElvUI); --Inport: Engine, Locales, PrivateDB, ProfileDB, GlobalDB, Localize Underscore
local DT = E:GetModule('DataTexts')

local CURRENT_SEGMENT 	= "Current"
local OVERALL_SEGMENT 	= "Overall"

local CURRENT_DATA 		= "CurrentFightData"
local LAST_DATA 		= "LastFightData"
local OVERALL_DATA 		= "OverallData"

local TYPE_DPS			= "DPS"
local TYPE_HEAL			= "Heal"
local TYPE_BOTH			= "DPS & Heal"

local FORMAT_OWN_DPS			= "Own DPS"
local FORMAT_OWN_HPS			= "Own HPS"
local FORMAT_RAID_DPS			= "Raid DPS"
local FORMAT_RAID_HPS			= "Raid HPS"
local FORMAT_OWN_DPS_OWN_HPS	= "Own DPS / Own HPS"
local FORMAT_RAID_DPS_OWN_DPS	= "Raid DPS / Own DPS"
local FORMAT_RAID_HPS_OWN_HPS	= "Raid HPS / OWn HPS"

local config = {
	lines = 10,
	segment = CURRENT_SEGMENT,
	type= TYPE_DPS,
	format = FORMAT_OWN_DPS,
	labels = true,
}

local lastPanel
local displayString = ''

local CONFIG = false

local function OnEvent(self, event, ...)

	if not CONFIG then

		if E.db.MeterOverlay == nil then
			E.db.MeterOverlay = {
				lines = 10,
				segment = CURRENT_SEGMENT,
				type = TYPE_DPS,
				format = FORMAT_OWN_DPS,
				labels = true,
			}
		else
			config = E.db.MeterOverlay
			
			if config.format==nil then
				config.format = FORMAT_OWN_DPS
			end			
			
			if config.labels==nil then
				config.labels = true
			end
			
		end		
		
		CONFIG = true
	end

end

EMO = {
	desc = 'Damage Meter Overlay'
}

_G.EMO = EMO

local DTRMenu = CreateFrame("Frame", "DTRMenu", E.UIParent, "UIDropDownMenuTemplate")

local lastSegment=0

local function OnUpdate(self, t)

	local rdps = 0
	local mydps = 0
	local rhps = 0
	local myhps = 0	
	
	lastPanel = self

	local now = time()

	if now - lastSegment > 1 then

		local dataset = OVERALL_DATA

		if config.segment==CURRENT_SEGMENT then
			if InCombatLockdown() then
				dataset=CURRENT_DATA
			else
				dataset=LAST_DATA
			end
		end		
						
		if (config.format == FORMAT_OWN_DPS ) then
		
			rdps,mydps = EMO.getRaidValuePerSecond(dataset, TYPE_DPS)
			if config.labels then
				self.text:SetFormattedText(displayString, "DPS: ", mydps/1000)
			else
				self.text:SetFormattedText(displayString, "", mydps/1000)
			end
			
		elseif (config.format == FORMAT_OWN_HPS ) then
		
			rhps,myhps = EMO.getRaidValuePerSecond(dataset, TYPE_HPS)
			if config.labels then
				self.text:SetFormattedText(displayString, "HPS: ", myhps/1000)
			else
				self.text:SetFormattedText(displayString, "", myhps/1000)
			end
			
		elseif (config.format == FORMAT_RAID_DPS ) then
		
			rdps,mydps = EMO.getRaidValuePerSecond(dataset, TYPE_DPS)
			if config.labels then
				self.text:SetFormattedText(displayString, "RDPS: ", rdps/1000)
			else
				self.text:SetFormattedText(displayString, "", rdps/1000)
			end
			
		elseif (config.format == FORMAT_RAID_HPS ) then
		
			rhps,myhps = EMO.getRaidValuePerSecond(dataset, TYPE_HPS)
			
			if config.labels then
				self.text:SetFormattedText(displayString, "RHPS: ", rhps/1000)
			else
				self.text:SetFormattedText(displayString, "", rhps/1000)
			end
			
		elseif (config.format == FORMAT_OWN_DPS_OWN_HPS ) then
		
			rdps,mydps = EMO.getRaidValuePerSecond(dataset, TYPE_DPS)
			rhps,myhps = EMO.getRaidValuePerSecond(dataset, TYPE_HPS)
			
			if config.labels then
				self.text:SetText(string.join(displayString:format("DPS: ",mydps/1000)," ",displayString:format(" HPS: ",myhps/1000)))			
			else
				self.text:SetText(string.join(displayString:format("",mydps/1000)," ",displayString:format("-",myhps/1000)))			
			end
			
		elseif (config.format == FORMAT_RAID_DPS_OWN_DPS ) then
		
			rdps,mydps = EMO.getRaidValuePerSecond(dataset, TYPE_DPS)
		
			if config.labels then
				self.text:SetText(string.join(displayString:format("RDPS: ",rdps/1000)," ",displayString:format(" DPS: ",mydps/1000)))			
			else
				self.text:SetText(string.join(displayString:format("",rdps/1000)," ",displayString:format("-",mydps/1000)))			
			end
			
		elseif (config.format == FORMAT_RAID_HPS_OWN_HPS ) then
		
			rhps,myhps = EMO.getRaidValuePerSecond(dataset, TYPE_HPS)
			
			if config.labels then
				self.text:SetText(string.join(displayString:format("RHPS: ",rhps/1000)," ",displayString:format(" HPS: ",myhps/1000)))			
			else
				self.text:SetText(string.join(displayString:format("",rhps/1000)," ",displayString:format("-",myhps/1000)))			
			end
		end
		
		lastSegment = now
	end

end


local function ValueColorUpdate(hex, r, g, b)
	displayString = string.join("", "%s", hex, "%.1fK|r")

	if lastPanel ~= nil then
		OnEvent(lastPanel)
	end
end

E['valueColorUpdateFuncs'][ValueColorUpdate] = true;

local ConvertDataSet={}
ConvertDataSet[OVERALL_DATA] = "Overall Data"
ConvertDataSet[CURRENT_DATA]= "Current Fight"
ConvertDataSet[LAST_DATA] = "Last Fight"

local tthead = {r=0.4,g=0.78,b=1}
local theal = {r=0,g=1,b=0}
local tdamage = {r=1,g=0,b=0}
local notgroup = {r = 0.35686274509804, g = 0.56470588235294, b = 0.031372549019608}
local colortable = {}
for class, color in pairs(_G["RAID_CLASS_COLORS"]) do
 colortable[class] = { r = color.r, g = color.g, b = color.b }
end

colortable["PET"] = {r = 0.09, g = 0.61, b = 0.55}
colortable["UNKNOWN"] = {r = 0.49803921568627, g = 0.49803921568627, b = 0.49803921568627}
colortable["MOB"] = {r = 0.58, g = 0.24, b = 0.63}
colortable["UNGROUPED"] = {r = 0.63, g = 0.58, b = 0.24}
colortable["HOSTILE"] = {r = 0.7, g = 0.1, b = 0.1}

-- Formats a number into human readable form.
function FormatNumber(number)
	if number then

		if number > 1000000 then
			return 	("%02.2fM"):format(number / 1000000)
		else
			if number > 10000 then
				return 	("%02.1fK"):format(number / 1000)
			else
				return math.floor(number)
			end
		end
	else
		return 0
	end
end


function DisplayTable(mode,repotType,amount)

	StatsTable,totalsum, totalpersec = EMO.getSumtable(mode, repotType)

	if repotType == TYPE_DPS then
		GameTooltip:AddDoubleLine("Damage Done",ConvertDataSet[mode],tdamage.r,tdamage.g,tdamage.b,tthead.r,tthead.g,tthead.b)
	elseif repotType == TYPE_HEAL then
		GameTooltip:AddDoubleLine("Healing Done",ConvertDataSet[mode],theal.r,theal.g,theal.b,tthead.r,tthead.g,tthead.b)
	end

	local numofcombatants = #StatsTable

	if numofcombatants == 0 then
		GameTooltip:AddLine("No data to display")
	else
		if numofcombatants > amount then
			numofcombatants = amount
		end

		local value = FormatNumber(totalsum)
		local vps = FormatNumber(totalpersec)
		local percent = 100

		GameTooltip:AddDoubleLine("Total",format("%s (%s) 100.0%%",value,vps))

		for i = 1, numofcombatants do

			if StatsTable[i].enclass then
				classc = colortable[StatsTable[i].enclass]
			else
				classc = notgroup
			end

			if repotType == TYPE_DPS then
				value = FormatNumber(StatsTable[i].damage)
				vps = FormatNumber(StatsTable[i].dps)
				percent = math.floor(1000*StatsTable[i].damage/totalsum)/10
			else
				value = FormatNumber(StatsTable[i].healing)
				vps = FormatNumber(StatsTable[i].hps)
				percent = math.floor(1000*StatsTable[i].healing/totalsum)/10
			end

			GameTooltip:AddDoubleLine(StatsTable[i].name,format("%s (%s) %.1f%%",value,vps,percent),classc.r,classc.g,classc.b,classc.r,classc.g,classc.b)

		end
	end
end





local function changeType (self,arg1)

	config.type = arg1

	CloseDropDownMenus()

	lastSegment=0
end

local function changeMode (self,arg1)

	config.segment = arg1

	CloseDropDownMenus()

	lastSegment=0
end

local function changeFormat (self,arg1)

	config.format = arg1

	CloseDropDownMenus()

	lastSegment=0
end

local function changeAmount (self,arg1)

	config.lines = arg1

	CloseDropDownMenus()

end

local function changeLabels (self,arg1)

	print("changeLabels")
	print(arg1)
	
	config.labels = arg1

	CloseDropDownMenus()

	lastSegment=0
	
	print(config.labels)
end


menuList = {
	{ text = "Meter Overlay", isTitle = true, notCheckable=true},
	{ text = "Segment", hasArrow = true, notCheckable=true,
		menuList = {}
	},
	{ text = "Overlay Type", hasArrow = true, notCheckable=true,
		menuList = {}
	},
	{ text = "Datatext Format", hasArrow = true, notCheckable=true,
		menuList = {}
	},	
	{ text = "Lines", hasArrow = true, notCheckable=true,
		menuList = {}
	}
}

local function CreateMenu(self)

	if(config.segment==CURRENT_SEGMENT) then

		menuList[2].menuList = {
				{ notCheckable=false,text = "Current/Last Fight",checked=true,func = changeMode, arg1=CURRENT_SEGMENT},
				{ notCheckable=false,text = "Overall Data",func = changeMode, arg1=OVERALL_SEGMENT},
			}
	else
		menuList[2].menuList = {
				{ notCheckable=false,text = "Current/Last Fight",func = changeMode, arg1=CURRENT_SEGMENT},
				{ notCheckable=false,text = "Overall Data",checked=true,func = changeMode, arg1=OVERALL_SEGMENT},
			}

	end

	if(config.type==TYPE_DPS) then
		menuList[3].menuList = {
				{ notCheckable=false,text = TYPE_DPS,checked=true,func = changeType, arg1=TYPE_DPS},
				{ notCheckable=false,text = TYPE_HEAL,func = changeType, arg1=TYPE_HEAL},
				{ notCheckable=false,text = TYPE_BOTH,func = changeType, arg1=TYPE_BOTH},
			}
	elseif (config.type==TYPE_HEAL) then
		menuList[3].menuList = {
				{ notCheckable=false,text = TYPE_DPS,func = changeType, arg1=TYPE_DPS},
				{ notCheckable=false,text = TYPE_HEAL,checked=true,func = changeType, arg1=TYPE_HEAL},
				{ notCheckable=false,text = TYPE_BOTH,func = changeType, arg1=TYPE_BOTH},
			}
	else
		menuList[3].menuList = {
				{ notCheckable=false,text = TYPE_DPS,func = changeType, arg1=TYPE_DPS},
				{ notCheckable=false,text = TYPE_HEAL,func = changeType, arg1=TYPE_HEAL},
				{ notCheckable=false,text = TYPE_BOTH,checked=true,func = changeType, arg1=TYPE_BOTH},
			}
	end

	
	if(config.format==FORMAT_OWN_DPS) then
		menuList[4].menuList = {
				{ notCheckable=false,text = FORMAT_OWN_DPS,checked=true,func = changeFormat, arg1=FORMAT_OWN_DPS},
				{ notCheckable=false,text = FORMAT_OWN_HPS,func = changeFormat, arg1=FORMAT_OWN_HPS},
				{ notCheckable=false,text = FORMAT_RAID_DPS,func = changeFormat, arg1=FORMAT_RAID_DPS},
				{ notCheckable=false,text = FORMAT_RAID_HPS,func = changeFormat, arg1=FORMAT_RAID_HPS},
				{ notCheckable=false,text = FORMAT_OWN_DPS_OWN_HPS,func = changeFormat, arg1=FORMAT_OWN_DPS_OWN_HPS},
				{ notCheckable=false,text = FORMAT_RAID_DPS_OWN_DPS,func = changeFormat, arg1=FORMAT_RAID_DPS_OWN_DPS},
				{ notCheckable=false,text = FORMAT_RAID_HPS_OWN_HPS,func = changeFormat, arg1=FORMAT_RAID_HPS_OWN_HPS},
			}
	elseif (config.format==FORMAT_OWN_HPS) then
		menuList[4].menuList = {
				{ notCheckable=false,text = FORMAT_OWN_DPS,func = changeFormat, arg1=FORMAT_OWN_DPS},
				{ notCheckable=false,text = FORMAT_OWN_HPS,checked=true,func = changeFormat, arg1=FORMAT_OWN_HPS},
				{ notCheckable=false,text = FORMAT_RAID_DPS,func = changeFormat, arg1=FORMAT_RAID_DPS},
				{ notCheckable=false,text = FORMAT_RAID_HPS,func = changeFormat, arg1=FORMAT_RAID_HPS},
				{ notCheckable=false,text = FORMAT_OWN_DPS_OWN_HPS,func = changeFormat, arg1=FORMAT_OWN_DPS_OWN_HPS},
				{ notCheckable=false,text = FORMAT_RAID_DPS_OWN_DPS,func = changeFormat, arg1=FORMAT_RAID_DPS_OWN_DPS},
				{ notCheckable=false,text = FORMAT_RAID_HPS_OWN_HPS,func = changeFormat, arg1=FORMAT_RAID_HPS_OWN_HPS},				
			}
	elseif (config.format==FORMAT_RAID_DPS) then
		menuList[4].menuList = {
				{ notCheckable=false,text = FORMAT_OWN_DPS,func = changeFormat, arg1=FORMAT_OWN_DPS},
				{ notCheckable=false,text = FORMAT_OWN_HPS,func = changeFormat, arg1=FORMAT_OWN_HPS},
				{ notCheckable=false,text = FORMAT_RAID_DPS,checked=true,func = changeFormat, arg1=FORMAT_RAID_DPS},
				{ notCheckable=false,text = FORMAT_RAID_HPS,func = changeFormat, arg1=FORMAT_RAID_HPS},
				{ notCheckable=false,text = FORMAT_OWN_DPS_OWN_HPS,func = changeFormat, arg1=FORMAT_OWN_DPS_OWN_HPS},
				{ notCheckable=false,text = FORMAT_RAID_DPS_OWN_DPS,func = changeFormat, arg1=FORMAT_RAID_DPS_OWN_DPS},
				{ notCheckable=false,text = FORMAT_RAID_HPS_OWN_HPS,func = changeFormat, arg1=FORMAT_RAID_HPS_OWN_HPS},				
			}			
	elseif (config.format==FORMAT_OWN_DPS_OWN_HPS) then
		menuList[4].menuList = {
				{ notCheckable=false,text = FORMAT_OWN_DPS,func = changeFormat, arg1=FORMAT_OWN_DPS},
				{ notCheckable=false,text = FORMAT_OWN_HPS,func = changeFormat, arg1=FORMAT_OWN_HPS},
				{ notCheckable=false,text = FORMAT_RAID_DPS,func = changeFormat, arg1=FORMAT_RAID_DPS},
				{ notCheckable=false,text = FORMAT_RAID_HPS,func = changeFormat, arg1=FORMAT_RAID_HPS},
				{ notCheckable=false,text = FORMAT_OWN_DPS_OWN_HPS,checked=true,func = changeFormat, arg1=FORMAT_OWN_DPS_OWN_HPS},
				{ notCheckable=false,text = FORMAT_RAID_DPS_OWN_DPS,func = changeFormat, arg1=FORMAT_RAID_DPS_OWN_DPS},
				{ notCheckable=false,text = FORMAT_RAID_HPS_OWN_HPS,func = changeFormat, arg1=FORMAT_RAID_HPS_OWN_HPS},				
			}
	elseif (config.format==FORMAT_RAID_DPS_OWN_DPS) then
		menuList[4].menuList = {
				{ notCheckable=false,text = FORMAT_OWN_DPS,func = changeFormat, arg1=FORMAT_OWN_DPS},
				{ notCheckable=false,text = FORMAT_OWN_HPS,func = changeFormat, arg1=FORMAT_OWN_HPS},
				{ notCheckable=false,text = FORMAT_RAID_DPS,func = changeFormat, arg1=FORMAT_RAID_DPS},
				{ notCheckable=false,text = FORMAT_RAID_HPS,func = changeFormat, arg1=FORMAT_RAID_HPS},
				{ notCheckable=false,text = FORMAT_OWN_DPS_OWN_HPS,func = changeFormat, arg1=FORMAT_OWN_DPS_OWN_HPS},
				{ notCheckable=false,text = FORMAT_RAID_DPS_OWN_DPS,checked=true,func = changeFormat, arg1=FORMAT_RAID_DPS_OWN_DPS},
				{ notCheckable=false,text = FORMAT_RAID_HPS_OWN_HPS,func = changeFormat, arg1=FORMAT_RAID_HPS_OWN_HPS},				
			}
	elseif (config.format==FORMAT_RAID_HPS_OWN_HPS) then
		menuList[4].menuList = {
				{ notCheckable=false,text = FORMAT_OWN_DPS,func = changeFormat, arg1=FORMAT_OWN_DPS},
				{ notCheckable=false,text = FORMAT_OWN_HPS,func = changeFormat, arg1=FORMAT_OWN_HPS},
				{ notCheckable=false,text = FORMAT_RAID_DPS,func = changeFormat, arg1=FORMAT_RAID_DPS},
				{ notCheckable=false,text = FORMAT_RAID_HPS,func = changeFormat, arg1=FORMAT_RAID_HPS},
				{ notCheckable=false,text = FORMAT_OWN_DPS_OWN_HPS,func = changeFormat, arg1=FORMAT_OWN_DPS_OWN_HPS},
				{ notCheckable=false,text = FORMAT_RAID_DPS_OWN_DPS,func = changeFormat, arg1=FORMAT_RAID_DPS_OWN_DPS},
				{ notCheckable=false,text = FORMAT_RAID_HPS_OWN_HPS,checked=true,func = changeFormat, arg1=FORMAT_RAID_HPS_OWN_HPS},
					
			}			
	end	
	
	if(config.labels==true) then
		menuList[4].menuList[8]={notCheckable=false,checked=true,isNotRadio=true,text = "Display labels",func = changeLabels, arg1=false}
	else
		menuList[4].menuList[8]={notCheckable=false,checked=false,isNotRadio=true,text = "Display labels",func = changeLabels, arg1=true}
	end
	
	if(config.lines==5) then
		menuList[5].menuList = {
				{ notCheckable=false,text = "5",checked=true,func = changeAmount, arg1=5},
				{ notCheckable=false,text = "10",func = changeAmount, arg1=10},
				{ notCheckable=false,text = "15",func = changeAmount, arg1=15},
				{ notCheckable=false,text = "20",func = changeAmount, arg1=20},
				{ notCheckable=false,text = "25",func = changeAmount, arg1=25},
			}
	elseif (config.lines==10) then
		menuList[5].menuList = {
				{ notCheckable=false,text = "5",func = changeAmount, arg1=5},
				{ notCheckable=false,text = "10",checked=true,func = changeAmount, arg1=10},
				{ notCheckable=false,text = "15",func = changeAmount, arg1=15},
				{ notCheckable=false,text = "20",func = changeAmount, arg1=20},
				{ notCheckable=false,text = "25",func = changeAmount, arg1=25},
			}
	elseif (config.lines==15) then
		menuList[5].menuList = {
				{ notCheckable=false,text = "5",func = changeAmount, arg1=5},
				{ notCheckable=false,text = "10",func = changeAmount, arg1=10},
				{ notCheckable=false,text = "15",checked=true,func = changeAmount, arg1=15},
				{ notCheckable=false,text = "20",func = changeAmount, arg1=20},
				{ notCheckable=false,text = "25",func = changeAmount, arg1=25},
			}
	elseif (config.lines==20) then
		menuList[5].menuList = {
				{ notCheckable=false,text = "5",func = changeAmount, arg1=5},
				{ notCheckable=false,text = "10",func = changeAmount, arg1=10},
				{ notCheckable=false,text = "15",func = changeAmount, arg1=15},
				{ notCheckable=false,text = "20",checked=true,func = changeAmount, arg1=20},
				{ notCheckable=false,text = "25",func = changeAmount, arg1=25},
			}
	else
		menuList[5].menuList = {
				{ notCheckable=false,text = "5",func = changeAmount, arg1=5},
				{ notCheckable=false,text = "10",func = changeAmount, arg1=10},
				{ notCheckable=false,text = "15",func = changeAmount, arg1=15},
				{ notCheckable=false,text = "20",func = changeAmount, arg1=20},
				{ notCheckable=false,text = "25",checked=true,func = changeAmount, arg1=25},
			}
	end
end

local function OnEnter(self)
	DT:SetupTooltip(self)

	GameTooltip:AddLine(EMO.desc,tthead.r,tthead.g,tthead.b)
	GameTooltip:AddLine(" ")

	local dataset = OVERALL_DATA

	if config.segment==CURRENT_SEGMENT then
		if InCombatLockdown() then
			dataset=CURRENT_DATA
		else
			dataset=LAST_DATA
		end
	end

	if config.type==TYPE_BOTH then
		DisplayTable(dataset, TYPE_DPS,config.lines)

		GameTooltip:AddLine(" ")

		DisplayTable(dataset, TYPE_HEAL,config.lines)		
	else
		DisplayTable(dataset, config.type,config.lines)

	end

	GameTooltip:Show()
	DTRMenu:Hide()
end

function OnLeave(self)
	GameTooltip:Hide()
	DTRMenu:Hide()
end
local function OnClick(self,btn)
	if btn == "RightButton" then
		GameTooltip:Hide()
		CreateMenu()
		EasyMenu(menuList, DTRMenu, "cursor", 0, 0, "MENU",2)
	else
		EMO.toggle()
	end
end

--[[
	DT:RegisterDatatext(name, events, eventFunc, updateFunc, clickFunc, onEnterFunc)

	name - name of the datatext (required)
	events - must be a table with string values of event names to register
	eventFunc - function that gets fired when an event gets triggered
	updateFunc - onUpdate script target function
	click - function to fire when clicking the datatext
	onEnterFunc - function to fire OnEnter
]]
DT:RegisterDatatext(EMO.desc, { "PLAYER_ENTERING_WORLD" }, OnEvent, OnUpdate, OnClick,OnEnter,OnLeave)