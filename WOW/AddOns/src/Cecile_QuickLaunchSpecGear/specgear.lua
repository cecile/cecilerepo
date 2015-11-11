----------------------------------------------------------------------------------------------------
-- search specgear module

--get the engine and create the module
local Engine = _G.Cecile_QuickLaunch;

--create the modules as submodule of search
local search = Engine.AddOn:GetModule("search");
local mod = search:NewModule("specgear");

--get the locale
local L=Engine.Locale;

mod.desc = L["SPECGEAR_MODULE"];

--debug
local debug = Engine.AddOn:GetModule("debug");

--module defaults
mod.Defaults = {
	profile = {
		autoEquipSet = true,
    tokenSpec = L["SPECGEAR_SPEC"],
    activeTag = L["SPECGEAR_ACTIVE"],
    inactiveTag = L["SPECGEAR_INACTIVE"],
	},
};

--module options table
mod.Options = {
	type = "group",
	name = mod.desc,
	args = {
    tokenSpec = {
      order = 1,
      type = "input",
      name = L["SPECGEAR_TOKEN_SPEC"],
      desc = L["SPECGEAR_TOKEN_SPEC_DESC"],
      get = function()
        return mod.Profile.tokenSpec;
      end,
      set = function(key, value)
        if not (value=="") then
          mod.Profile.tokenSpec = value;
        end
      end,
      disabled = function()
        return not mod:IsEnabled();
      end,
    },
    activeTag = {
      order = 2,
      type = "input",
      name = L["SPECGEAR_ACTIVE_TAG"],
      desc = L["SPECGEAR_ACTIVE_TAG_DESC"],
      get = function()
        return mod.Profile.activeTag;
      end,
      set = function(key, value)
        if not (value=="") then
          mod.Profile.activeTag = value;
        end
      end,
      disabled = function()
        return not mod:IsEnabled();
      end,
    },
    inactiveTag = {
      order = 3,
      type = "input",
      name = L["SPECGEAR_INACTIVE_TAG"],
      desc = L["SPECGEAR_INACTIVE_TAG_DESC"],
      get = function()
        return mod.Profile.inactiveTag;
      end,
      set = function(key, value)
        if not (value=="") then
          mod.Profile.inactiveTag = value;
        end
      end,
      disabled = function()
        return not mod:IsEnabled();
      end,
    },
    autoEquipSet = {
      order = 4,
      type = "toggle",
      name = L["SPECGEAR_AUTO_EQUIP_SET"],
      desc = L["SPECGEAR_AUTO_EQUIP_SET_DESC"],
      get = function()
        return mod.Profile.autoEquipSet;
      end,
      set = function(key, value)
        mod.Profile.autoEquipSet = value;
      end,
      disabled = function()
        return not mod:IsEnabled();
      end,
    },
	}
};

--equip a set
function mod.SetCurrentEquipmentSet(item)

  --if we dont have sets return
  if GetNumEquipmentSets() == 0 then
    return;
  end

  --loop the sets
  for i = 1, GetNumEquipmentSets() do

    --get the set name and if is equipped
    local name, _, _, isEquipped, _, _, _, _, _ = GetEquipmentSetInfo(i);

    --if the set is named as what we are searching
    if item.id == name then

      --if not equipped, just equip it
      if not isEquipped then
        UseEquipmentSet(name);
      end

      --all done
      return;

    end

  end
end

--switch spec
function mod.SpecSwitch(item)

  --if we need to auto equip the gear set
  if mod.Profile.autoEquipSet then

    --create a new item with the name of the specialization
    local name = select(2,GetSpecializationInfo(GetSpecialization(false, false, item.id)));
    local itemSet = { id = name } ;

    --equip the set
    mod.SetCurrentEquipmentSet(itemSet);

  end

  --set the spec
  SetActiveSpecGroup(item.id);

end

--populate specializations
function mod:PopulateSpecs()

  --options
  local tokenSpec = mod.Profile.tokenSpec;
  local activeTag = mod.Profile.activeTag;
  local inactiveTag = mod.Profile.inactiveTag;
  local activeIndex = GetActiveSpecGroup();
  local active=false;

  for index = 1, GetNumSpecGroups() do

    if GetSpecialization(false, false, index) then

      local specID, name, _, icon  = GetSpecializationInfo(GetSpecialization(false, false, index));

      --its this the active spec?
      active = (index == activeIndex and true or false);

      --base text
      searchableText = tokenSpec .. ": ";

      --complete the text
      searchableText = searchableText .. name .. " (" .. (active and activeTag or inactiveTag) .. ")";

      --add the text and function
      item = { text = searchableText , id=index, func = mod.SpecSwitch, icon=icon };

      --insert the result
      table.insert(mod.items,item);

    end

  end

end

--refresh the data
function mod:Refresh()

	debug("refreshing specs & gear data");

  mod:PopulateSpecs();

	debug("data refreshed");

end