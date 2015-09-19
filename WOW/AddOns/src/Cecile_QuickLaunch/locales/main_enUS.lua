----------------------------------------------------------------------------------------------------
-- localized English (main) strings
--

--get the add-on engine
local AddOnName, Engine = ...;

--force localization to Spanish (only for testing)
--_G.GAME_LOCALE = "esES"

--prepare locale
local L = LibStub("AceLocale-3.0"):NewLocale(AddOnName, "enUS", true);
if not L then return; end

--main strings
L["LOAD_MESSAGE"] = "%s (version |cff0070de%s|r) loaded, type /%s or /%s for options."
L["GENERAL"] = "General"
L["PROFILES"] = "Profiles"
L["GENERAL_SETTINGS"] = "General Settings"
L["OPEN_CONFIG"] = "Open Config"
L["OPEN_CONFIG_DESC"] = "Open the configuration window."
L["CONFIG_WINDOW"] = "%s (version |cff0070de%s|r) configuration tool."
