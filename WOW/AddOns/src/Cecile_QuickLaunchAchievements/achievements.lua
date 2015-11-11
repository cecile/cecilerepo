----------------------------------------------------------------------------------------------------
-- search achievements module

--get the engine and create the module
local Engine = _G.Cecile_QuickLaunch;

--create the modules as submodule of search
local search = Engine.AddOn:GetModule("search");
local mod = search:NewModule("achievements");

--get the locale
local L=Engine.Locale;

mod.desc = L["ACHIEVEMENTS_MODULE"];

--debug
local debug = Engine.AddOn:GetModule("debug");

--module defaults
mod.Defaults  = {
  profile = {
    completed = true,
    uncompleted = true,
    category = true,
    token = L["ACHIEVEMENTS_ACHIEVEMENT"],
    completedTag = L["ACHIEVEMENTS_COMPLETED"],
    uncompletedTag = L["ACHIEVEMENTS_UNCOMPLETED"],
  },
};

--module options table
mod.Options = {
  type = "group",
  name = mod.desc,
  args = {
    completed = {
      order = 1,
      type = "toggle",
      name = L["ACHIEVEMENTS_RETURN_COMPLETED"],
      desc = L["ACHIEVEMENTS_RETURN_COMPLETED_DESC"],
      get = function()
        return mod.Profile.completed;
      end,
      set = function(key, value)
        mod.Profile.completed = value;
      end,
      disabled = function()
        return not mod:IsEnabled();
      end,
    },
    uncompleted = {
      order = 2,
      type = "toggle",
      name = L["ACHIEVEMENTS_RETURN_UNCOMPLETED"],
      desc = L["ACHIEVEMENTS_RETURN_UNCOMPLETED_DESC"],
      get = function()
        return mod.Profile.uncompleted;
      end,
      set = function(key, value)
        mod.Profile.uncompleted = value;
      end,
      disabled = function()
        return not mod:IsEnabled();
      end,
    },
    category = {
      order = 3,
      type = "toggle",
      name = L["ACHIEVEMENTS_RETURN_CATEGORY"],
      desc = L["ACHIEVEMENTS_RETURN_CATEGORY_DESC"],
      get = function()
        return mod.Profile.category;
      end,
      set = function(key, value)
        mod.Profile.category = value;
      end,
      disabled = function()
        return not mod:IsEnabled();
      end,
    },
    token = {
      order = 4,
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
    completedTag = {
      order = 5,
      type = "input",
      name = L["ACHIEVEMENTS_COMPLETED_TAG"],
      desc = L["ACHIEVEMENTS_COMPLETED_TAG_DESC"],
      get = function()
        return mod.Profile.completedTag;
      end,
      set = function(key, value)
        if not (value=="") then
          mod.Profile.completedTag = value;
        end
      end,
      disabled = function()
        return not mod:IsEnabled();
      end,
    },
    uncompletedTag = {
      order = 6,
      type = "input",
      name = L["ACHIEVEMENTS_UNCOMPLETED_TAG"],
      desc = L["ACHIEVEMENTS_UNCOMPLETED_TAG_DESC"],
      get = function()
        return mod.Profile.uncompletedTag;
      end,
      set = function(key, value)
        if not (value=="") then
          mod.Profile.uncompletedTag = value;
        end
      end,
      disabled = function()
        return not mod:IsEnabled();
      end,
    },
  }

};

--open an achievement
function mod.openAchievement(item)

  --open achievement window
  if not AchievementFrame or not AchievementFrame:IsShown() then
    ToggleAchievementFrame();
  end

  --get archivement category and info
  local category = GetAchievementCategory(item.id);
  local _, parentID = GetCategoryInfo(category);
  local i,entry;

  --select the archivement in the UI
  AchievementFrame_SelectAchievement(item.id);

  -- expand category list to achievement's location
  if parentID == -1 then
      for i, entry in next, ACHIEVEMENTUI_CATEGORIES do
          if entry.id == category then
              entry.collapsed = false;
          elseif entry.parent == category then
              entry.hidden = false;
          end
      end
      --update the UI
      AchievementFrameCategories_Update();
  end


end

--populate the list
function mod:PopulateAchievements()

  local categories = GetCategoryList();

  local id, name, points, completed, month, day, year, description, flags, icon, rewardText, isGuildAch, wasEarnedByMe, earnedBy;
  local category,number,categoryName,parentCategoryID,parentCategoryName;

  --options
  local token = mod.Profile.token;
  local completedTag = mod.Profile.completedTag;
  local uncompletedTag = mod.Profile.uncompletedTag;
  local showCompleted = mod.Profile.completed;
  local showUncompleted = mod.Profile.uncompleted;
  local showCategory = mod.Profile.category;

  --goes trought the categories
  for _,category in pairs(categories) do

    --get the category name and the parent
    categoryName, parentCategoryID, _ = GetCategoryInfo(category);

    --if we have parent get it
    if not (parentCategoryID == -1) then
      parentCategoryName = select(1,GetCategoryInfo(parentCategoryID));
    end

    --go trough the archivements
    for number=1,GetCategoryNumAchievements(category) do

      --get info about the archivement
      id, name, points, completed, month, day, year, description, flags, icon, rewardText, isGuildAch, wasEarnedByMe, earnedBy = GetAchievementInfo(category, number);

      --if we have name
      if name then

        --base text
        searchableText = token .. ": ";

        --if we need to show the category
        if showCategory then
          if parentCategoryID == -1 then
            searchableText = searchableText .. "["..categoryName.."] ";
          else
            searchableText = searchableText .. " [".. parentCategoryName .. "/" .. categoryName.."] ";
          end
        end

        --complete the text
        searchableText = searchableText .. name .. " (" .. (completed and completedTag or uncompletedTag) .. ")";

        --if we need to add it
        if ( completed and showCompleted) or (not(completed) and showUncompleted) then

          --add the text and function
          item = { text = searchableText , id=id, func = mod.openAchievement, icon=icon };

          --insert the result
          table.insert(mod.items,item);

        end

      end

    end

  end

end

--refresh the data
function mod:Refresh()

  debug("refreshing achievements data");

  --populate the data
  mod:PopulateAchievements();

  debug("data refreshed");

end