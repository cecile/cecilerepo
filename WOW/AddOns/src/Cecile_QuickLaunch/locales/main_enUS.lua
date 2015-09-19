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
L["BINDIGN_DESC"] = "Open Quick Launch"
L["ABOUT"] = [[

|cffff0000Warning|r: This Add-On its in a very early |cffff0000Alpha Stage|r, use it at your own risk.

|cff0070deUsage:|r:

First you need to set-up a |cff82c5ffkeybinding|r in the window settings to open the launcher, by default it's |cff82c5ffCTRL+SHIT+P|r.

When the window pop-up you could start typing to search.

You could press |cff82c5ffENTER|r to select the first option or use |cff82c5ffTAB or SHIFT-TAB|r to navigate trough the results.

Alternatively you could use mouse wheel/click, but honestly I don't recommend it.

|cff0070deExamples:|r

Summon a random pet:
|cff82c5ffCTRL+SHIT+P|r pet |cff82c5ffSPACE|r rand |cff82c5ffENTER|r

Dismount:
|cff82c5ffCTRL+SHIT+P|r dism |cff82c5ffENTER|r

Summon your second favorite mount:
|cff82c5ffCTRL+SHIT+P|r mou |cff82c5ffSPACE|r favo |cff82c5ffTAB|r |cff82c5ffTAB|r |cff82c5ffTAB|r |cff82c5ffENTER|r

Summon  your Soaring Skyterror:
|cff82c5ffCTRL+SHIT+P|r mou |cff82c5ffSPACE|r skyt |cff82c5ffENTER|r

|cffffff00Created by|r

|cffffffffCecile|r - |cff0070deEU|r - |cffff2020Zul'jin|r
]]