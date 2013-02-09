----------------------------------------------------------------------------------------------------
-- localized Spanish strings
--

--get the addon  engine
local C_LP = select( 2, ... )

--check spanish locale
if not ( ( GetLocale() == "esES" ) or ( GetLocale() == "esMX" ) ) then
	return;
end

--set the localized strings in the engine
C_LP.L = {
	LOOT_NONE = "Sin Preferencia",
	LOOT_MAIN = "Especializaci\195\179n principal",
	LOOT_MINOR = "Mejora Menor",	
	LOOT_OFF = "Equipo Secundario",	
	LOOT_PREFERENCES = "Preferencias de despojo",
	FILTER_MY_PREFERENCES = "Mis Preferencias",
	FILTER_GUILD_PREFERENCES = "Preferencias de Hermandad",
	PLAYER_PREFERENCES = "Preferenciass de |c%s%s|r",
	LOAD_MESSAGE = "%s (versi\195\179n |cff0070de%s|r) cargado.",
	LOOT_MESSAGE = "%s - %s obtenido, eliminado de las preferencias.",
	WRONG_VERSION = "%s - Una nueva versi\195\179n (|cff0070de%s|r) de este addon esta disponible, por favor actualice su versi\195\179n.",
	PLAYER_VERSION = "%s - El jugador %s tiene una versi\195\179n(|cff0070de%s|r) del addon desactualizada.",
}


