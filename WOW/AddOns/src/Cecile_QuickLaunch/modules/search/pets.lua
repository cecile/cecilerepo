----------------------------------------------------------------------------------------------------
-- search module

--get the engine and create the module
local Engine = select(2,...);

--create the modules as submodule of search
local search = Engine.AddOn:GetModule("search");
local mod = search:NewModule("pets");


--get the locale
local L=Engine.Locale;

--debug
local debug = Engine.AddOn:GetModule("debug");


--initialize the module
function mod:OnInitialize()

	--we dont have items
	mod.items = {};

	--get the window module
	mod.window = Engine.AddOn:GetModule("window");

	debug("search/pets module initialize");

end

--summon a pet if item.data.id==0 its random
function mod.summonPet(item)

	--notify window
	mod.window.OnButtonClick(item);

	--check if its summon normal o random (favorite)
	if(item.data.id==0) then
		C_PetJournal.SummonRandomPet(false);
	else
		C_PetJournal.SummonPetByGUID(item.data.id);
	end

end

--populate the list
function mod:PopulatePets()

	--lcoal vars
	local index,item;

	--get number of pets
	local numPets = C_PetJournal.GetNumPets();

	--for formating the text
	local searchableText = "";

	--loop the pets
	for index = 1, numPets do
		local petID, speciesID, owned, customName, level, favorite, isRevoked, speciesName, icon, petType, companionID, tooltip, description, isWild, canBattle, isTradeable, isUnique, obtainable = C_PetJournal.GetPetInfoByIndex(index)

		--if we own the pet
		if owned then

			--format the text
			searchableText = L["PETS_PET"].. (customName and customName or speciesName) .. (favorite and L["PETS_FAVORITE"] or "");

			--add the text and function
	    	item = { text = searchableText , id=petID, func = mod.summonPet; };

	    	--insert the result
	    	table.insert(mod.items,item);

		end

	end

	--get the GUID for summoned pet
	local summonedPetGUID = C_PetJournal.GetSummonedPetGUID();

	--add a random favorite pet on top
	searchableText = L["PETS_RANDOM"];
    item = { text = searchableText , id=0, func = mod.summonPet; };
    table.insert(mod.items,1,item);

	--if we have a pet sumoned create a search for dismiss
	if not (summonedPetGUID  == nil) then

		--create the text
		searchableText = L["PETS_DISMISS"];

		--set the text and function, we calling again to summon will dismm it
    	item = { text = searchableText , id=summonedPetGUID, func = mod.summonPet; };
    	table.insert(mod.items,1,item);

	end

end

--refresh the data
function mod:Refresh()

	debug("refreshing pet data");

	--clear items
	mod.items = {};

	--populate the data
	mod:PopulatePets();

	debug("data refreshed");

end

--enable module
function mod:OnEnable()

end
