----------------------------------------------------------------------------------------------------
-- localized English (Toys module) strings
--

--get the add-on engine
local Engine = _G.Cecile_QuickLaunch;

--prepare locale
local L = LibStub("AceLocale-3.0"):NewLocale(Engine.Name, "enUS", true);
if not L then return; end

--Toys module
L["TOYS"] = "Toys"
L["TOYS_MODULE"] = "Toys"
L["TOYS_TOKEN"] = "Toys Token"
L["TOYS_TOKEN_DESC"] = "Change the Toys Token"
