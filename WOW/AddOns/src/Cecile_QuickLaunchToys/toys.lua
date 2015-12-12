----------------------------------------------------------------------------------------------------
-- search toys module

--get the engine and create the module
local Engine = _G.Cecile_QuickLaunch;

--create the modules as submodule of search
local search = Engine.AddOn:GetModule("search");
local mod = search:NewModule("toys");

--debug
local debug = Engine.AddOn:GetModule("debug");

--get the locale
local L=Engine.Locale;

mod.desc = L["TOYS_MODULE"];

--module vars
mod.Vars = {
  token =  {
    type = "string",
    default = L["TOYS"],
    order = 1,
    label = L["TOYS_TOKEN"],
    desc = L["TOYS_TOKEN_DESC"],
  },
};

--populate
function mod:Populate()

  --options
  local token = mod.Profile.token;

  --get number of pets
  local numToys = C_ToyBox.GetNumToys();

  --local vars
  local idx,toyID, name, icon, fav,start, duration, enable, remain;

  for index = 1, numToys do

    idx = C_ToyBox.GetToyFromIndex(index);
    toyID, name, icon, fav = C_ToyBox.GetToyInfo(idx);

    if name ~= nil and toyID ~= nil then
      if _G.PlayerHasToy(toyID) then

        --base text
        searchableText = token .. ": ";

        --complete the text
        searchableText = searchableText .. name;

        --get the coldown
        start, duration, enable = GetItemCooldown(toyID);

        if start>0 then
          remain = duration - (GetTime() - start);
          searchableText = searchableText .. " ["..search:SecondsToClock(remain).."]";
        end

        --add the text and function
        item = { text = searchableText , id=toyID, type = "item", icon = icon};

        --insert the result
        table.insert(mod.items,item);


      end

    end

  end

end

--refresh the data
function mod:Refresh()

  debug("refreshing toys data");

  --populate data
  mod:Populate();

  debug("data refreshed");

end