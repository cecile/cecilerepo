if ( GetLocale() ~= "esES" ) then
	return;
end

local C_LP = select( 2, ... );

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
}


