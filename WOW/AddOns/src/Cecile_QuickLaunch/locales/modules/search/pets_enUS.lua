----------------------------------------------------------------------------------------------------
-- localized English (pets module) strings
--

--get the add-on engine
local AddOnName, Engine = ...;

--prepare locale
local L = LibStub("AceLocale-3.0"):NewLocale(AddOnName, "enUS", true);
if not L then return; end

--pets module
L["PETS_PET"] = "Pet"
L["PETS_FAVORITE"] = "favorite"
L["PETS_DISMISS"] = "Dismiss"
L["PETS_RANDOM"] = "Random"
L["PETS_MODULE"] = "Pets Module"
L["PETS_RETURN_FAVORITES"] = "Return Favorites"
L["PETS_RETURN_FAVORITES_DESC"] = "Enable/Disable returning favorites pets"
L["PETS_RETURN_NO_FAVORITES"] = "Return No Favorites"
L["PETS_RETURN_NO_FAVORITES_DESC"] = "Enable/Disable returning no favorites pets"
L["PETS_FAVORITE_TAG"] = "Favorite Tag"
L["PETS_FAVORITE_TAG_DESC"] = "Change the favorite items tag"