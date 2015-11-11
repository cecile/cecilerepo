----------------------------------------------------------------------------------------------------
-- localized Spanish (specgear module) strings
--

--get the add-on engine
local AddOnName, Engine = ...;

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

--specgear module
L["SPECGEAR_MODULE"] = "Especializaciones y Conjuntos de Equipo"
L["SPECGEAR_SPEC"] = "Especialización"
L["SPECGEAR_ACTIVE"] = "activa"
L["SPECGEAR_INACTIVE"] = "inactiva"
L["SPECGEAR_AUTO_EQUIP_SET"] = "Auto equipar conjunto"
L["SPECGEAR_AUTO_EQUIP_SET_DESC"] = "Al elegir una especialización auto equipar el conjunto que tenga el mismo nombre que la especialización"
L["SPECGEAR_TOKEN_SPEC"] = "Etiqueta Especialización"
L["SPECGEAR_TOKEN_SPEC_DESC"] = "Cambia la etiqueta para especializaciones"
L["SPECGEAR_ACTIVE_TAG"] = "Etiqueta Activa"
L["SPECGEAR_ACTIVE_TAG_DESC"] = "Cambia la etiqueta para la especialización activa"
L["SPECGEAR_INACTIVE_TAG"] = "Etiqueta Inactiva"
L["SPECGEAR_INACTIVE_TAG_DESC"] = "Cambia la etiqueta para la especialización inactiva"