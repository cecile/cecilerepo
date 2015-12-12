----------------------------------------------------------------------------------------------------
-- localized Spanish (Toys module) strings
--

--get the add-on engine
local Engine = _G.Cecile_QuickLaunch;

--Spanish or Latin America Spanish
local L = LibStub("AceLocale-3.0"):NewLocale(Engine.Name, "esES")
if not L then
  L = LibStub("AceLocale-3.0"):NewLocale(Engine.Name, "esMX");
  if not L then
    return;
  end
end

--Toys module
L["TOYS"] = "Toys"
L["TOYS_MODULE"] = "Toys"
L["TOYS_TOKEN"] = "Etiqueta Toys"
L["TOYS_TOKEN_DESC"] = "Cambia la etiqueta de Toys"
