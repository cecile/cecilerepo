----------------------------------------------------------------------------------------------------
-- search module

--get the engine and create the module
local Engine = select(2,...);

--create the modules as submodule of search
local search = Engine.AddOn:GetModule("search");
local mod = search:NewModule("mounts");

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

	debug("search/mounts module initialize");

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

			--format the text
			searchableText = L["MOUNTS_MOUNT"] .. creatureName .. (isFavorite and L["MOUNT_FAVORITE"] or "");

			--set our function and text
	    	item = { text = searchableText , id=index, func = mod.summonMount};

	    	--add the item
	    	table.insert(mod.items,item);

	    end

	end

	--add on top a search for random mount
	searchableText = L["MOUNT_RANDOM"];
	item = { text = searchableText , id=0, func = mod.summonMount};
	table.insert(mod.items,1,item);

	--if we are mounted add a search text for dismount on top
	if mounted then
		searchableText = L["MOUNT_DISMOUNT"];
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

end
