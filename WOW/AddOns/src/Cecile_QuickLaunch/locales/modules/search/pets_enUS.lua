----------------------------------------------------------------------------------------------------
-- localized English (pets module) strings
--

--get the add-on engine
local AddOnName, Engine = ...;

--prepare locale
local L = LibStub("AceLocale-3.0"):NewLocale(AddOnName, "enUS", true);
if not L then return; end

--pets module
L["PETS_PET"] = "Pet: "
L["PETS_FAVORITE"] = " (favorite)"
L["PETS_DISMISS"] = "Pet: Dismiss"
L["PETS_RANDOM"] = "Pet: Random (favorite)"