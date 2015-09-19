----------------------------------------------------------------------------------------------------
-- localized English (window module) strings
--

--get the add-on engine
local AddOnName, Engine = ...;

--prepare locale
local L = LibStub("AceLocale-3.0"):NewLocale(AddOnName, "enUS", true);
if not L then return; end

--window module
L["WINDOW_ERROR_IN_COMBAT"] = "%s |cffff0000: could not be open in combat.|r"
L["WINDOW_SETTINGS"] = "Window Settings"
L["WINDOW_BINDING_LAUNCH"] = "Open Launcher Keybinding"
L["WINDOW_BINDING_LAUNCH_DESC"] = "Change the Keybinding for opening the launcher"