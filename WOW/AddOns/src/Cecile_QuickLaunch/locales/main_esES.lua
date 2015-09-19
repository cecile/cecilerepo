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
L["GENERAL"] = "General"
L["PROFILES"] = "Perfiles"
L["GENERAL_SETTINGS"] = "Opciones Generales"
L["OPEN_CONFIG"] = "Abrir Configuración"
L["OPEN_CONFIG_DESC"] = "Abre la ventana de configuración."
L["CONFIG_WINDOW"] = "%s (versión |cff0070de%s|r) herramienta de configuración."
L["BINDIGN_DESC"] = "Abrir Lanzador Rápido"
L["ABOUT"] = [[

|cffff0000Advertencia|r: Este Add-On es una versión preliminar |cffff0000en estado Alpha|r, usalo bajo tu responsabilidad.

|cff0070deUso:|r:

Primero tienes que configurar un |cff82c5ffatajo de teclado|r en las opciones de ventana para abrir el lanzador, por defecto es |cff82c5ffCONTROL+MAYUSCULAS+P|r.

Cuando se muestre la ventana puedes empezar a escribir para buscar.

Puedes pulsar |cff82c5ffINTRO|r para selecionar la primera opción o usar |cff82c5ffTABULADOR o MAYUSCULAS-TABULADOR|r para navegar por los resultados.

Alternativamente puedes usar el ratón y su rueda, pero no te lo recomiendo.

|cff0070deEjemplos:|r

Invocar una mascota aleatoria:
|cff82c5ffCONTROL+MAYUSCULAS+P|r masco |cff82c5ffESPACIO|r aleat |cff82c5ffENTER|r

Desmontarse:
|cff82c5ffCONTROL+MAYUSCULAS+P|r desmon |cff82c5ffENTER|r

Invocar tu segunda montura favorita:
|cff82c5ffCONTROL+MAYUSCULAS+P|r mont |cff82c5ffESPACIO|r favo |cff82c5ffTABULADOR|r |cff82c5ffTABULADOR|r |cff82c5ffTABULADOR|r |cff82c5ffINTRO|r

Invocar a tu Aterracielos volador:
|cff82c5ffCONTROL+MAYUSCULAS+P|r mont |cff82c5ffESPACIO|r aterr |cff82c5ffINTRO|r

|cffffff00Creado por|r

|cffffffffCecile|r - |cff0070deEU|r - |cffff2020Zul'jin|r
]]