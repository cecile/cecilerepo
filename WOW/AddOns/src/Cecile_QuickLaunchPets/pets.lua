----------------------------------------------------------------------------------------------------
-- search pets module

--get the engine and create the module
local Engine = _G.Cecile_QuickLaunch;

--create the modules as submodule of search
local search = Engine.AddOn:GetModule("search");
local mod = search:NewModule("pets");

--get the locale
local L=Engine.Locale;

mod.desc = L["PETS_MODULE"];

--debug
local debug = Engine.AddOn:GetModule("debug");

--module defaults
mod.Defaults = {
	profile = {
		favorites = true,
		noFavorites = true,
		token = L["PETS_PET"],
		favoriteTag = L["PETS_FAVORITE"],
	},
};

--module options table
mod.Options = {
	type = "group",
	name = mod.desc,
	cmdInline = true,
	args = {
		favorites = {
			order = 1,
			type = "toggle",
			name = L["PETS_RETURN_FAVORITES"],
			desc = L["PETS_RETURN_FAVORITES_DESC"],
			get = function()
				return mod.Profile.favorites;
			end,
			set = function(key, value)
				mod.Profile.favorites = value;
			end,
			disabled = function()
				return not mod:IsEnabled();
			end,
		},
		noFavorites = {
			order = 2,
			type = "toggle",
			name = L["PETS_RETURN_NO_FAVORITES"],
			desc = L["PETS_RETURN_NO_FAVORITES_DESC"],
			get = function()
				return mod.Profile.noFavorites;
			end,
			set = function(key, value)
				mod.Profile.noFavorites = value;
			end,
			disabled = function()
				return not mod:IsEnabled();
			end,
		},
		token = {
			order = 3,
			type = "input",
			name = L["SEARCH_TOKEN"],
			desc = L["SEARCH_TOKEN_DESC"],
			get = function()
				return mod.Profile.token;
			end,
			set = function(key, value)
				if not (value=="") then
					mod.Profile.token = value;
				end
			end,
			disabled = function()
				return not mod:IsEnabled();
			end,
		},
		favoriteTag = {
			order = 4,
			type = "input",
			name = L["PETS_FAVORITE_TAG"],
			desc = L["PETS_FAVORITE_TAG_DESC"],
			get = function()
				return mod.Profile.favoriteTag;
			end,
			set = function(key, value)
				if not (value=="") then
					mod.Profile.favoriteTag = value;
				end
			end,
			disabled = function()
				return not mod:IsEnabled();
			end,
		},
	}
};

--summon a pet if id==0 its random
function mod.summonPet(item)

	--check if its summon normal o random (favorite)
	if(item.id==0) then
		C_PetJournal.SummonRandomPet(false);
	else
		C_PetJournal.SummonPetByGUID(item.id);
	end

end

--populate the list
function mod:PopulatePets()

	--lcoal vars
	local index,item,creatureName;

	--options
	local token = mod.Profile.token;
	local favorites = mod.Profile.favorites;
	local noFavorites = mod.Profile.noFavorites;
	local favoriteTag = mod.Profile.favoriteTag;

	--get number of pets
	local numPets = C_PetJournal.GetNumPets();

	--for formating the text
	local searchableText = "";

	--loop the pets
	for index = 1, numPets do
		local petID, speciesID, owned, customName, level, isFavorite, isRevoked, speciesName, icon, petType, companionID, tooltip, description, isWild, canBattle, isTradeable, isUnique, obtainable = C_PetJournal.GetPetInfoByIndex(index)

		--if we own the pet
		if owned then


			searchableText = nil;

			creatureName = speciesName .. (customName and ( " [" .. customName .. "]" ) or "");

			if isFavorite and favorites then

				searchableText = token .. ": " .. creatureName .. " (".. favoriteTag .. ")";

			elseif noFavorites then

				searchableText = token .. ": " .. creatureName;

			end

			if searchableText then

				--add the text and function
	    		item = { text = searchableText , id=petID, func = mod.summonPet, icon = icon ;};

	    		--insert the result
	    		table.insert(mod.items,item);

	    	end

		end

	end

	--get the GUID for summoned pet
	local summonedPetGUID = C_PetJournal.GetSummonedPetGUID();

	--add a random favorite pet on top
	searchableText = token .. ": " .. L["PETS_RANDOM"] .. " (".. favoriteTag .. ")";
    item = { text = searchableText , id=0, func = mod.summonPet, icon = "Interface\\Icons\\INV_Misc_QuestionMark"; };
    table.insert(mod.items,1,item);

	--if we have a pet sumoned create a search for dismiss
	if not (summonedPetGUID  == nil) then

		--create the text
		searchableText = token .. ": " .. L["PETS_DISMISS"];

		--set the text and function, we calling again to summon will dismm it
    	item = { text = searchableText , id=summonedPetGUID, func = mod.summonPet; };
    	table.insert(mod.items,1,item);

	end

end

--refresh the data
function mod:Refresh()

	debug("refreshing pet data");

	--populate the data
	mod:PopulatePets();

	debug("data refreshed");

end