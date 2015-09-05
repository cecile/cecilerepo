----------------------------------------------------------------------------------------------------
-- localized Spanish strings
--

--get the addon engine
local AddOnName, Engine = ...;

--spanish or latin america spanish
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
L["CONFIG_WINDOW"] = "%s (version |cff0070de%s|r) herramienta de configuración."

--debug module
L["DEV_SETTINGS"] = "Opciones del desarollador"
L["DEBUGGING"] = "Activar Depuración"
L["DEBUGGING_DESC"] = "Activa la depuración del AddOn y muestra la ventana de depuración."
L["DEBUG_WINDOW_HELP"] = "Rueda de raton para desplazarse (pulsar shift para principio/fin). Click tiulo mover y esquina inferior derecha para tamaño."

--version module
L["WRONG_VERSION"] = "%s - Una nueva versión (|cff0070de%s|r) de este addon esta disponible, por favor actualice su versión."
L["PLAYER_VERSION"] = "%s - El jugador %s tiene una versión(|cff0070de%s|r) del addon desactualizada."
