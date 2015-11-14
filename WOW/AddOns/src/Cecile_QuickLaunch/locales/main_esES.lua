----------------------------------------------------------------------------------------------------
-- localized Spanish (main) strings
--

--get the AddOn engine
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
L["CONFIG_WINDOW"] = "%s (version |cff0070de%s|r)"
L["PROFILES"] = "Perfiles"
L["BINDING_DESC"] = "Abrir Lanzador Rápido"
L["LAUNCH_BINDING_DESC"] = "Lanzar Último Comando"
L["ABOUT"] = [[


|cff0070deUso:|r:

Primero tienes que configurar un |cff82c5ffatajo de teclado|r en las opciones de ventana para abrir el lanzador, por defecto es |cff82c5ffCONTROL+MAYUSCULAS+P|r.

Cuando se muestre la ventana puedes empezar a escribir para buscar.

Puedes pulsar |cff82c5ffINTRO|r para selecionar la primera opción o usar |cff82c5ffTABULADOR o MAYUSCULAS-TABULADOR|r para navegar por los resultados.

Alternativamente puedes usar el ratón y su rueda, pero no te lo recomiendo.

Puedes definir |cff82c5ffSinónimos|r y |cff82c5ffuna lista negra|r en las opciones de Búsqueda.

|cff0070deEjemplos:|r

Invocar una mascota aleatoria:
|cff82c5ffCONTROL+MAYUSCULAS+P|r masco |cff82c5ffESPACIO|r aleat |cff82c5ffENTER|r

Desmontarse:
|cff82c5ffCONTROL+MAYUSCULAS+P|r desmon |cff82c5ffENTER|r

Invocar tu segunda montura favorita:
|cff82c5ffCONTROL+MAYUSCULAS+P|r mont |cff82c5ffESPACIO|r favo |cff82c5ffTABULADOR|r |cff82c5ffTABULADOR|r |cff82c5ffTABULADOR|r |cff82c5ffINTRO|r

Invocar a tu Aterracielos volador:
|cff82c5ffCONTROL+MAYUSCULAS+P|r mont |cff82c5ffESPACIO|r aterr |cff82c5ffINTRO|r

Abrir la configruación de un AddOn:
|cff82c5ffCONTROL+MAYUSCULAS+P|r cfg |cff82c5ffESPACIO|r <nombre> |cff82c5ffINTRO|r

Abrir la configruación de este AddOn:
|cff82c5ffCONTROL+MAYUSCULAS+P|r cql |cff82c5ffINTRO|r

|cffffff00Creado por|r

|cffffffffCecile|r - |cff0070deEU|r - |cffff2020Zul'jin|r
]]