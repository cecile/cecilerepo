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

	--we dont have items

	mod.items = {};

	mod.window = Engine.AddOn:GetModule("window");

	debug("search module initialize");


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

	debug("refreshing search data");

	mod.items = {};

	mod:PopulateMounts();
	mod:PopulatePets();

	debug("data refreshed");

end

--check if we match this item with the entered text
function mod:MatchItem(item,text)

	--set to lower case
	local item = item:lower();
	local text = text:lower();

	--flag to control if we match every wod
	local matchAllWords = true;

	--local vars
	local word;

	--go word by word and check if we match
	for word in string.gmatch(text, "[^ ]+") do
		matchAllWords = matchAllWords and (not (string.find(item,word)==nil) );
	end

	--return all words
	return matchAllWords;

end

--color string based on match
function mod:ColorItem(item,text)

	--our result
	local result = item;

	--convert to lower
	local item = item:lower();
	local text = text:lower();

	--local vars
	local word;
	local positions = {};
	local pos;

	--go word by word
	for word in string.gmatch(text, "[^ ]+") do

		--if we get one store the position on the string
		local startPos,endPos = string.find(item,word);
		pos = { from = startPos, to = endPos };

		table.insert(positions,pos);

	end

	--sort the positions
	table.sort(positions, function(a,b) return a.from < b.from end);

	--more local vars
	local concatenated = "";
	local before,token, after;

	--we have not modified, yet
	local acumulated = 0;

	--loop the words
	for k,pos in pairs(positions) do

		--empty result
		concatenated = "";

		--move if we have alreayd modified something
		pos.from = pos.from + acumulated;
		pos.to = pos.to + acumulated;

		--get before token string
		if not (pos.from==1) then
			before  = string.sub(result,1,pos.from-1);
		else
			before = "";
		end

		--get the token and after string
		token = string.sub(result,pos.from,pos.to);
		after = string.sub(result,pos.to+1);

		--colorize it
		result = before.."|cffffffff"..token.."|r"..after;

		--we increase next positions
		acumulated = acumulated + 12;

	end

	return result;

end

--find all items using the text
function mod:FindAll(text)

	--our result
	local result = {};

	--double check that we need something to search
	if (text==nil) then return result; end
	if (text=="") then return result; end

	--local vars
	local word;
	local k,item;
	local words;

	--loop al items
	for k, item in pairs(mod.items) do

		--if this item match
		if mod:MatchItem(item.text,text) then

			--add color
			item.displayText =  mod:ColorItem(item.text,text);

			--insert into the table
			table.insert(result,item);

		end

	end

	return result;
end

--enable module
function mod:OnEnable()

end
