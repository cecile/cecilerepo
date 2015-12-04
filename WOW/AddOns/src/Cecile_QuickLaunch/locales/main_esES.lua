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
L["CONFIG_WINDOW"] = "%s (version |cff0070de%s|r) creado por |cffffffffCecile|r - |cff0070deEU|r - |cffff2020Zul'jin|r"
L["PROFILES"] = "Perfiles"
L["BINDING_DESC"] = "Abrir Lanzador Rápido"
L["LAUNCH_BINDING_DESC"] = "Lanzar Último Comando"
L["ABOUT"] = [[

|cff0070deUso:|r

Primero tienes que configurar un |cff82c5ffatajo de teclado|r en las opciones de ventana para abrir el lanzador, por defecto es |cff82c5ffCONTROL+MAYUSCULAS+P|r.

Cuando se muestre la ventana puedes empezar a escribir para buscar.

Puedes pulsar |cff82c5ffINTRO|r para selecionar la primera opción o usar |cff82c5ffTABULADOR o MAYUSCULAS-TABULADOR|r para navegar por los resultados.

Alternativamente puedes usar los cursores y el ratón y su rueda.

Puedes definir |cff82c5ffSinónimos|r y |cff82c5ffuna lista negra|r en las opciones de Búsqueda.

Los diversos |cff82c5ffmódulos de busqueda|r se pueden personalizar en la lista de módulos dentro de las opciones de búsqueda.

Se puede cambiar la |cff82c5ffapariencia|r de la ventana en las opciones de la misma.

|cff0070deEjemplos:|r

Invocar una mascota aleatoria:
|cff82c5ffCONTROL+MAYUSCULAS+P|r masco |cff82c5ffESPACIO|r aleat |cff82c5ffENTER|r

Invocar tu segunda montura favorita:
|cff82c5ffCONTROL+MAYUSCULAS+P|r mont |cff82c5ffESPACIO|r favo |cff82c5ffTABULADOR|r |cff82c5ffTABULADOR|r |cff82c5ffTABULADOR|r |cff82c5ffINTRO|r

Invocar a tu Aterracielos volador:
|cff82c5ffCONTROL+MAYUSCULAS+P|r mont |cff82c5ffESPACIO|r aterr |cff82c5ffINTRO|r

Abrir la configruación de un AddOn:
|cff82c5ffCONTROL+MAYUSCULAS+P|r cfg |cff82c5ffESPACIO|r <nombre> |cff82c5ffINTRO|r

Abrir la configruación de este AddOn:
|cff82c5ffCONTROL+MAYUSCULAS+P|r cql |cff82c5ffINTRO|r

|cff0070deMódulos de Búsqueda:|r

|cff82c5ffLogros:|r
- Explorar logros completados y sin completar y abrir la interfaz de logros.
|cff82c5ffAddOns:|r
- Abrir las ventanas de configuración de AddOns.
|cff82c5ffMonturas:|r
- Invocar a una montura aleatoria o cualquier montura en particular.
|cff82c5ffMascotas:|r
- Invocar a tus mascotas de compañia aleatoria o cualquier otra en particular.
|cff82c5ffEspecialización y conjuntos:|r
- Cambiar de especialización o conjuntos de equipo.
|cff82c5ffSocial:|r
- Invitar a grupo o banda o susurrar a tus amigos. Coventir a banda o grupo.]]