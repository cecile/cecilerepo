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
L["CONFIG_WINDOW"] = "%s (version |cff0070de%s|r) by |cffffffffCecile|r - |cff0070deEU|r - |cffff2020Zul'jin|r"
L["PROFILES"] = "Profiles"
L["BINDING_DESC"] = "Open Quick Launch"
L["LAUNCH_BINDING_DESC"] = "Launch Last Command"
L["ABOUT"] = [[

|cff0070deUsage:|r

First you need to set-up a |cff82c5ffkeybinding|r in the window settings to open the launcher, by default it's |cff82c5ffCTRL+SHIFT+P|r.

When the window pop-up you could start typing to search.

You could press |cff82c5ffENTER|r to select the first option or use |cff82c5ffTAB or SHIFT-TAB|r to navigate trough the results.

Alternatively you could use arrow keys or mouse wheel/click.

You could define |cff82c5ffAliases|r and |cff82c5ffBlacklist|r items in the search options.

The different |cff82c5ffsearch modules|r could be customized in the module list within the search options.

The window |cff82c5ffappearance|r could be change in the windows options.

|cff0070deExamples:|r

Summon a random pet:
|cff82c5ffCTRL+SHIFT+P|r pet |cff82c5ffSPACE|r rando |cff82c5ffENTER|r

Summon your second favorite mount:
|cff82c5ffCTRL+SHIFT+P|r mou |cff82c5ffSPACE|r favo |cff82c5ffTAB|r |cff82c5ffTAB|r |cff82c5ffTAB|r |cff82c5ffENTER|r

Summon your Soaring Skyterror:
|cff82c5ffCTRL+SHIFT+P|r mou |cff82c5ffSPACE|r skyt |cff82c5ffENTER|r

Open an AddOn configuration:
|cff82c5ffCTRL+SHIFT+P|r cfg |cff82c5ffSPACE|r <name> |cff82c5ffENTER|r

Open this AddOn configuration:
|cff82c5ffCTRL+SHIFT+P|r cql |cff82c5ffENTER|r

|cff0070deSearch Modules:|r

|cff82c5ffAchievements:|r
- Browse complete and uncompleted achievements and open achievements interface UI.
|cff82c5ffAddOns:|r
- Open AddOns configurations windows.
|cff82c5ffMounts:|r
- Summon random or any favorite or not favorite mount.
|cff82c5ffPets:|r
- Summon random or any favorite or not favorite companion pet.
|cff82c5ffSpecialization and Gear Sets:|r
- Change Specialization and gear sets.
|cff82c5ffSocial:|r
- Friends whisper and invite to party/raid. Convert to party/raid.]]