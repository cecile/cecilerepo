----------------------------------------------------------------------------------------------------
-- localized English (default) strings
--

--get the addon engine
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

--debug module
L["DEV_SETTINGS"] = "Developer Settings"
L["DEBUGGING"] = "Enable Debugging"
L["DEBUGGING_DESC"] = "Enable AddOn debugging and show the debug window."
L["DEBUG_WINDOW_HELP"] = "Mouse wheel to scroll (with shift scroll top/bottom). Title bar drags. Bottom-right corner resizes."

--version module
L["WRONG_VERSION"] = "%s - A new version (|cff0070de%s|r) for this addon its available, please update your version."
L["PLAYER_VERSION"] = "%s - Player %s has a outdated version (|cff0070de%s|r) for this addon."