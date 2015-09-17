----------------------------------------------------------------------------------------------------
-- localized Spanish (main) strings
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

--main strings
L["LOAD_MESSAGE"] = "%s (versión |cff0070de%s|r) cargado, escribe /%s o /%s para opciones."
L["CONFIG_NAME"] = "Cecile Basic AddOn"
L["GENERAL"] = "General"
L["PROFILES"] = "Perfiles"
L["GENERAL_SETTINGS"] = "Opciones Generales"
L["OPEN_CONFIG"] = "Abrir Configuración"
L["OPEN_CONFIG_DESC"] = "Abre la ventana de configuración."
L["CONFIG_WINDOW"] = "%s (versión |cff0070de%s|r) herramienta de configuración."
