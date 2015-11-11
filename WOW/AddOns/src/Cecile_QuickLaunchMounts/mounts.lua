----------------------------------------------------------------------------------------------------
-- search mounts module

--get the engine and create the module
local Engine = _G.Cecile_QuickLaunch;

--create the modules as submodule of search
local search = Engine.AddOn:GetModule("search");
local mod = search:NewModule("mounts");

--get the locale
local L=Engine.Locale;

mod.desc = L["MOUNTS_MODULE"];

--debug
local debug = Engine.AddOn:GetModule("debug");

--module defaults
mod.Defaults = {
	profile = {
		favorites = true,
		noFavorites = true,
		token = L["MOUNTS_MOUNT"],
		favoriteTag = L["MOUNT_FAVORITE"],
	},
};

--module options table
mod.Options = {
	type = "group",
	name = mod.desc,
	args = {
		favorites = {
			order = 1,
			type = "toggle",
			name = L["MOUNT_RETURN_FAVORITES"],
			desc = L["MOUNT_RETURN_FAVORITES_DESC"],
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
			name = L["MOUNT_RETURN_NO_FAVORITES"],
			desc = L["MOUNT_RETURN_NO_FAVORITES_DESC"],
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
			name = L["MOUNT_FAVORITE_TAG"],
			desc = L["MOUNT_FAVORITE_TAG_DESC"],
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

--summon a mount
function mod.summonMount(item)

	--summon the mount
	C_MountJournal.Summon(item.id);

end

--dismount
function mod.dismmissMount(item)

	--dismount
	C_MountJournal.Dismiss();

end

--create the list of mounts
function mod:PopulateMounts()

	---local variables
	local index,item;

	--options
	local token = mod.Profile.token;
	local favorites = mod.Profile.favorites;
	local noFavorites = mod.Profile.noFavorites;
	local favoriteTag = mod.Profile.favoriteTag;

	--get max num of mounts
	local numMounts = C_MountJournal.GetNumMounts();

	--to format the text
	local searchableText = "";

	--we are not mounted
	local mounted = false;

	--loop mounts
	for index = 1, numMounts do

		--get the mount details
		local creatureName, spellID, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected = C_MountJournal.GetMountInfo(index);

		--if its usable (faction, profesion, etc) and we have it
		if isUsable and isCollected then

			--if its active we are mounted
			if active then
				mounted = true;
			end

			searchableText = nil;

			if isFavorite and favorites then

				searchableText = token .. ": " .. creatureName .. " (".. favoriteTag .. ")";

			elseif noFavorites then

				searchableText = token .. ": " .. creatureName;

			end

			if searchableText then

				--set our function and text
	    		item = { text = searchableText , id=index, func = mod.summonMount, icon = icon};

	    		--add the item
	    		table.insert(mod.items,item);

	    	end

	    end

	end

	--add on top a search for random mount
	searchableText = token .. ": " .. L["MOUNT_RANDOM"] .. " (".. favoriteTag .. ")";
	item = { text = searchableText , id=0, func = mod.summonMount, icon = "Interface\\Icons\\INV_Misc_QuestionMark"};
	table.insert(mod.items,1,item);

	--if we are mounted add a search text for dismount on top
	if mounted then
		searchableText = token .. ": " .. L["MOUNT_DISMOUNT"];
    	item = { text = searchableText , id=index, func = mod.dismmissMount};
    	table.insert(mod.items,1,item);
	end

end

--refresh the data
function mod:Refresh()

	debug("refreshing mount data");

	--populate the mounts
	mod:PopulateMounts();

	debug("data refreshed");

end