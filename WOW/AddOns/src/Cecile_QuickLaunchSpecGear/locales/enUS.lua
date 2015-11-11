----------------------------------------------------------------------------------------------------
-- localized English (specgear module) strings
--

--get the add-on engine
local Engine = _G.Cecile_QuickLaunch;

--prepare locale
local L = LibStub("AceLocale-3.0"):NewLocale(Engine.Name, "enUS", true);
if not L then return; end

--specgear module
L["SPECGEAR_MODULE"] = "Specialization and Gear Sets"
L["SPECGEAR_SPEC"] = "Specialization"
L["SPECGEAR_ACTIVE"] = "active"
L["SPECGEAR_INACTIVE"] = "inactive"
L["SPECGEAR_AUTO_EQUIP_SET"] = "Auto equip set"
L["SPECGEAR_AUTO_EQUIP_SET_DESC"] = "When choosing a specialization auto equip the equipment set that has the same name as the specialization"
L["SPECGEAR_TOKEN_SPEC"] = "Specialization token"
L["SPECGEAR_TOKEN_SPEC_DESC"] = "Change the specialization token"
L["SPECGEAR_ACTIVE_TAG"] = "Active Tag"
L["SPECGEAR_ACTIVE_TAG_DESC"] = "Change the active specialization tag"
L["SPECGEAR_INACTIVE_TAG"] = "Inactive Tag"
L["SPECGEAR_INACTIVE_TAG_DESC"] = "Change the inactive specialization tag"
