		----------------------------------------------------------------------------------------------------
-- search module

--get the engine and create the module
local Engine = select(2,...);
local mod = Engine.AddOn:NewModule("search");

--get the locale
local L=Engine.Locale;

--debug
local debug = Engine.AddOn:GetModule("debug");


--initialize the module
function mod:OnInitialize()

	local item;
	local index;

	mod.items = {};

	mod.window = Engine.AddOn:GetModule("window");

end

function mod.summonMount(item)

	mod.window.OnButtonClick(item);

	C_MountJournal.Summon(item.data.id);

end

function mod.dismmissMount(item)

	mod.window.OnButtonClick(item);

	C_MountJournal.Dismiss();

end

function mod:PopulateMounts()

	local index,item;

	local numMounts = C_MountJournal.GetNumMounts();
	local searchableText = "";
	local mounted = false;

	for index = 1, numMounts do

		local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected = C_MountJournal.GetMountInfo(index);

		if isUsable and isCollected then

			if active then
				mounted = true;
			end

			searchableText = "Mount: ".. creatureName .. (isFavorite and " (favorite)" or "");
	    	item = { text = searchableText , id=index, func = mod.summonMount};
	    	table.insert(mod.items,item);

	    end

	end

	if mounted then
		searchableText = "Mount: Dismount";
    	item = { text = searchableText , id=index, func = mod.dismmissMount};
    	table.insert(mod.items,1,item);
	end

	searchableText = "Mount: Random (favorite)";
	item = { text = searchableText , id=0, func = mod.summonMount};
	table.insert(mod.items,1,item);

end

function mod.summonPet(item)

	mod.window.OnButtonClick(item);

	if(item.data.id==0) then
		C_PetJournal.SummonRandomPet(false);
	else
		C_PetJournal.SummonPetByGUID(item.data.id);
	end

end

function mod:PopulatePets()

	local index,item;

	local numPets = C_PetJournal.GetNumPets();
	local searchableText = "";

	for index = 1, numPets do
		local petID, speciesID, owned, customName, level, favorite, isRevoked, speciesName, icon, petType, companionID, tooltip, description, isWild, canBattle, isTradeable, isUnique, obtainable = C_PetJournal.GetPetInfoByIndex(index)

		if owned then

			searchableText = "Pet: ".. (customName and customName or speciesName) .. (favorite and " (favorite)" or "");
	    	item = { text = searchableText , id=petID, func = mod.summonPet; };
	    	table.insert(mod.items,item);

		end

	end

	local summonedPetGUID = C_PetJournal.GetSummonedPetGUID();

	if not (summonedPetGUID  == nil) then

		searchableText = "Pet: Dismiss";
    	item = { text = searchableText , id=summonedPetGUID, func = mod.summonPet; };
    	table.insert(mod.items,1,item);

	end

	searchableText = "Pet: Random (favorite)";
    item = { text = searchableText , id=0, func = mod.summonPet; };
    table.insert(mod.items,1,item);


end

function mod:Refresh()

	mod.items = {};

	mod:PopulateMounts();
	mod:PopulatePets();

end

function mod:MatchItem(item,text)

	local item = item:lower();
	local text = text:lower();

	local matchAllWords = true;

	local word;


	for word in string.gmatch(text, "[^ ]+") do

		matchAllWords = matchAllWords and (not (string.find(item,word)==nil) );

	end

	return matchAllWords;

end

function mod:ColorItem(item,text)

	local result = item;

	local item = item:lower();
	local text = text:lower();

	local word;

	local positions = {};
	local pos;

	for word in string.gmatch(text, "[^ ]+") do

		local startPos,endPos = string.find(item,word);
		pos = { from = startPos, to = endPos };

		table.insert(positions,pos);

	end

	table.sort(positions, function(a,b) return a.from < b.from end);

	local concatenated = "";
	local before,token, after;
	local acumulated = 0;

	for k,pos in pairs(positions) do

		concatenated = "";

		pos.from = pos.from + acumulated;
		pos.to = pos.to + acumulated;

		if not (pos.from==1) then
			before  = string.sub(result,1,pos.from-1);
		else
			before = "";
		end

		token = string.sub(result,pos.from,pos.to);
		after = string.sub(result,pos.to+1);

		result = before.."|cffffffff"..token.."|r"..after;

		acumulated = acumulated + 12;

	end


	return result;

end

function mod:FindAll(text)

	local result = {};

	if (text==nil) then return result; end
	if (text=="") then return result; end

	local word;
	local k,item;
	local words;


	local matchItem;
	for k, item in pairs(mod.items) do

		matchItem = mod:MatchItem(item.text,text);

		if matchItem then

			item.displayText =  mod:ColorItem(item.text,text);

			table.insert(result,item);

		end

	end

	return result;
end

--enable module
function mod:OnEnable()

end
