----------------------------------------------------------------------------------------------------
-- details module
--

--if Details its not present, dont use this module
if not IsAddOnLoaded( "Details" )  then return; end

--get the engine and create the module
local Engine = select(2,...);
local mod = Engine.AddOn:NewModule("details");

--debug
local debug = Engine.AddOn:GetModule("debug");

--toggle skada window
function mod.Toggle()
	local Details = _G._detalhes;

	for _, instance in Details:ListInstances() do
		if (instance.baseframe) then
			instance.baseframe:SetShown(not instance.baseframe:IsShown())
		end
	end
end

--get sum table
function mod.GetSumtable(tablename, mode)
	
	--get skada
	local Details = _G._detalhes;
	
	--default values
	local totalsum=0;
	local totalpersec=0;
	local sumtable={};
	local report_set = nil;
	
	--get the set
	if(tablename==Engine.CURRENT_DATA) then
		report_set = Details:GetCombat("current")
	elseif(tablename==Engine.OVERALL_DATA) then
		report_set = Details:GetCombat("overall")
	end
			
	if(report_set) then		
		-- For each item in dataset
		local nr = 1;
		local templable = {};
		
		local attribute;
		if (mode == Engine.TYPE_DPS) then
			attribute = DETAILS_ATTRIBUTE_DAMAGE;
		else
			attribute = DETAILS_ATTRIBUTE_HEAL;
		end

		local container = report_set:GetContainer(attribute)
		for i, player in container:ListActors() do
			if player:IsPlayer() then			
			
				--get the data from the player
				templable = {enclass=player:Class(),name=player:GetDisplayName(),damage= mode == Engine.TYPE_DPS and player.total or 0,healing= mode == Engine.TYPE_HEAL and player.total or 0,dps=0,hps=0};										
				
				--get the player active time
				local totaltime = player:Tempo() or 0;
				
				--calculate hps or dps
				if (mode==Engine.TYPE_DPS) then
					if (templable.damage>0) then
						templable.dps = templable.damage / math.max(1,totaltime);
						totalsum = totalsum + templable.damage;
						totalpersec = totalpersec + templable.dps;
						
						--insert the player
						table.insert(sumtable,templable);						
					end
				else
					if (templable.healing>0) then
						templable.hps = templable.healing / math.max(1,totaltime);					
						totalsum = totalsum + templable.healing;
						totalpersec = totalpersec + templable.hps;
						
						--insert the player
						table.insert(sumtable,templable);						
					end
				end
			end
		end
	end						
	
	--return values
	return sumtable, totalsum, totalpersec;
end

--return segment name
function mod.GetSegmentName()

	--return skada
	local Details = _G._detalhes;
	
	--find the set
	local report_set = Details:GetCombat("current")
	
	--get the name
	if(report_set) then	
		return report_set:GetCombatName(true);
	end	
	
end

--initialize module
function mod:OnInitialize()

	--get the generic meter
	mod.meter = Engine.AddOn:GetModule("meter");
			
	---register the damage meter
	mod.meter:RegisterMeter("Details",mod.GetSumtable,mod.GetSegmentName,mod.Toggle);

end