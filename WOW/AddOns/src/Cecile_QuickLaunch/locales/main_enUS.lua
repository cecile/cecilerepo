----------------------------------------------------------------------------------------------------
-- localized English (main) strings
--

--get the AddOn engine
local AddOnName, Engine = ...;

--force localization to Spanish (only for testing)
--_G.GAME_LOCALE = "esES"

--prepare locale
local L = LibStub("AceLocale-3.0"):NewLocale(AddOnName, "enUS", true);
if not L then return; end

--main strings
L["LOAD_MESSAGE"] = "%s (version |cff0070de%s|r) loaded, type /%s or /%s for options."
L["CONFIG_WINDOW"] = "%s (version |cff0070de%s|r)"
L["PROFILES"] = "Profiles"
L["BINDING_DESC"] = "Open Quick Launch"
L["ABOUT"] = [[

|cffff0000Warning|r: This AddOn its in a very early |cffff0000Beta Stage|r, use it at your own risk.

|cff0070deUsage:|r:

First you need to set-up a |cff82c5ffkeybinding|r in the window settings to open the launcher, by default it's |cff82c5ffCTRL+SHIFT+P|r.

When the window pop-up you could start typing to search.

You could press |cff82c5ffENTER|r to select the first option or use |cff82c5ffTAB or SHIFT-TAB|r to navigate trough the results.

Alternatively you could use mouse wheel/click, but honestly I don't recommend it.

You could define |cff82c5ffAliases|r and |cff82c5ffBlacklist|r items in the search options.

|cff0070deExamples:|r

Summon a random pet:
|cff82c5ffCTRL+SHIFT+P|r pet |cff82c5ffSPACE|r rand |cff82c5ffENTER|r

Dismount:
|cff82c5ffCTRL+SHIFT+P|r dism |cff82c5ffENTER|r

Summon your second favorite mount:
|cff82c5ffCTRL+SHIFT+P|r mou |cff82c5ffSPACE|r favo |cff82c5ffTAB|r |cff82c5ffTAB|r |cff82c5ffTAB|r |cff82c5ffENTER|r

Summon  your Soaring Skyterror:
|cff82c5ffCTRL+SHIFT+P|r mou |cff82c5ffSPACE|r skyt |cff82c5ffENTER|r

Open an AddOn configuration:
|cff82c5ffCTRL+SHIFT+P|r cfg |cff82c5ffSPACE|r <name> |cff82c5ffENTER|r

Open this AddOn configuration:
|cff82c5ffCTRL+SHIFT+P|r cql |cff82c5ffENTER|r

|cffffff00Created by|r

|cffffffffCecile|r - |cff0070deEU|r - |cffff2020Zul'jin|r
]]