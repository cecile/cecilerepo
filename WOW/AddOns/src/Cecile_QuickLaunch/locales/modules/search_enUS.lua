----------------------------------------------------------------------------------------------------
-- localized English (search module) strings
--

--get the add-on engine
local AddOnName, Engine = ...;

--prepare locale
local L = LibStub("AceLocale-3.0"):NewLocale(AddOnName, "enUS", true);
if not L then return; end

--search module
L["SEARCH_NAME"] = "Search"
L["SEARCH_ENABLE_MODULE"] = "Enabled"
L["SEARCH_ENABLE_MODULE_DESC"] = "Enable/Disable this module"
L["SEARCH_ALIASES"] = "Aliases"
L["SEARCH_ALIASES_DESC"] = "Choose and alias"
L["SEARCH_ALIAS_NAME"] = "Alias Name"
L["SEARCH_ALIAS_VALUE"] = "Alias Value"
L["SEARCH_ALIAS_SAVE"] = "Save"
L["SEARCH_ALIAS_SAVE_DESC"] = "Save the alias"
L["SEARCH_ALIAS_NEW"] = "New"
L["SEARCH_ALIAS_NEW_DESC"] = "New alias"
L["SEARCH_ALIAS_DELETE"] = "Delete"
L["SEARCH_ALIAS_DELETE_DESC"] = "Delete the alias"
L["SEARCH_TOKEN"] = "Search Token"
L["SEARCH_TOKEN_DESC"] = "Change the search returned token"