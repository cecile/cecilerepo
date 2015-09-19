----------------------------------------------------------------------------------------------------
-- localized Spanish (window module) strings
--

--get the add-on engine
local AddOnName, Engine = ...;

--Spanish or Latin America Spanish
local L = LibStub("AceLocale-3.0"):NewLocale(AddOnName, "esES")
if not L then
	L = LibStub("AceLocale-3.0"):NewLocale(AddOnName, "esMX");
	if not L then
		return;
	end
end

--window module
L["WINDOW_ERROR_IN_COMBAT"] = "%s |cffff0000:no se puede abrir en combate.|r"
L["WINDOW_SETTINGS"] = "Opciones de la Ventana"
L["WINDOW_BINDING_LAUNCH"] = "Tecla rápida de Abrir Ventana"
L["WINDOW_BINDING_LAUNCH_DESC"] = "Cambia la tecla rápida para abrir la ventana"

