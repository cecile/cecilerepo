----------------------------------------------------------------------------------------------------
-- search mounts module

--get the engine and create the module
local Engine = select(2,...);

--create the modules as submodule of search
local search = Engine.AddOn:GetModule("search");
local mod = search:NewModule("mounts");

--get the locale
local L=Engine.Locale;

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
	order = 2,
	type = "group",
	name = L["MOUNTS_MODULE"],
	cmdInline = true,
	args = {
		enable = {
			order = 1,
			type = "toggle",
			name = L["SEARCH_ENABLE_MODULE"],
			desc = L["SEARCH_ENABLE_MODULE_DESC"],
			get = function()
				return mod:IsEnabled();
			end,
			set = function(key, value)

				if(value) then
					mod:Enable();
				else
					mod:Disable();
				end

				Engine.Profile.search.disableModules[mod:GetName()] = (not value);

			end,
		},
		favorites = {
			order = 2,
			type = "toggle",
			name = L["MOUNT_RETURN_FAVORITES"],
			desc = L["MOUNT_RETURN_FAVORITES_DESC"],
			get = function()
				return Engine.Profile.search.mounts.favorites;
			end,
			set = function(key, value)
				Engine.Profile.search.mounts.favorites = value;
			end,
			disabled = function()
				return not mod:IsEnabled();
			end,
		},
		noFavorites = {
			order = 4,
			type = "toggle",
			name = L["MOUNT_RETURN_NO_FAVORITES"],
			desc = L["MOUNT_RETURN_NO_FAVORITES_DESC"],
			get = function()
				return Engine.Profile.search.mounts.noFavorites;
			end,
			set = function(key, value)
				Engine.Profile.search.mounts.noFavorites = value;
			end,
			disabled = function()
				return not mod:IsEnabled();
			end,
		},
		token = {
			order = 5,
			type = "input",
			name = L["SEARCH_TOKEN"],
			desc = L["SEARCH_TOKEN_DESC"],
			get = function()
				return Engine.Profile.search.mounts.token;
			end,
			set = function(key, value)
				if not (value=="") then
					Engine.Profile.search.mounts.token = value;
				end
			end,
			disabled = function()
				return not mod:IsEnabled();
			end,
		},
		favoriteTag = {
			order = 6,
			type = "input",
			name = L["MOUNT_FAVORITE_TAG"],
			desc = L["MOUNT_FAVORITE_TAG_DESC"],
			get = function()
				return Engine.Profile.search.mounts.favoriteTag;
			end,
			set = function(key, value)
				if not (value=="") then
					Engine.Profile.search.mounts.favoriteTag = value;
				end
			end,
			disabled = function()
				return not mod:IsEnabled();
			end,
		},
	}

};


--initialize the module
function mod:OnInitialize()

	--we dont have items
	mod.items = {};

	--get the window module
	mod.window = Engine.AddOn:GetModule("window");

	debug("search/mounts module initialize");

	mod.desc = L["MOUNTS_MODULE"];
end

--summon a mount
function mod.summonMount(item)

	--notify the window
	mod.window.OnButtonClick(item);

	--summon the mount
	C_MountJournal.Summon(item.data.id);

end

--dismount
function mod.dismmissMount(item)

	--notify the window
	mod.window.OnButtonClick(item);

	--dismount
	C_MountJournal.Dismiss();

end

--create the list of mounts
function mod:PopulateMounts()

	---local variables
	local index,item;

	--options
	local token = Engine.Profile.search.mounts.token;
	local favorites = Engine.Profile.search.mounts.favorites;
	local noFavorites = Engine.Profile.search.mounts.noFavorites;
	local favoriteTag = Engine.Profile.search.mounts.favoriteTag;

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
	    		item = { text = searchableText , id=index, func = mod.summonMount};

	    		--add the item
	    		table.insert(mod.items,item);

	    	end

	    end

	end

	--add on top a search for random mount
	searchableText = token .. ": " .. L["MOUNT_RANDOM"] .. " (".. favoriteTag .. ")";
	item = { text = searchableText , id=0, func = mod.summonMount};
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

	--clear items
	mod.items = {};

	--populate the mounts
	mod:PopulateMounts();

	debug("data refreshed");

end

--enable module
function mod:OnEnable()

	--we dont have items
	mod.items = {};

	debug(mod:GetName().." Enabled");

end

--disabled module
function mod:OnDisable()

	--we dont have items
	mod.items = {};

	debug(mod:GetName().." Disabled");
end