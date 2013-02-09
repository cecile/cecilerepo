----------------------------------------------------------------------------------------------------
-- localized English (default) strings
--

--get the addon  engine
local C_LP = select( 2, ... )

--set the localized strings in the engine
C_LP.L = {
	LOOT_NONE = "No preference",
	LOOT_MAIN = "Main Spec",
	LOOT_MINOR = "Minor Upgrade",	
	LOOT_OFF = "Off Spec",	
	LOOT_PREFERENCES = "Loot Preferences",
	FILTER_MY_PREFERENCES = "My Preferences",
	FILTER_GUILD_PREFERENCES = "Guild Preferences",
	PLAYER_PREFERENCES = "|c%s%s|r Preferences",
	LOAD_MESSAGE = "%s (version |cff0070de%s|r) loaded.",
	LOOT_MESSAGE = "%s - %s looted, removed from preferences.",
	WRONG_VERSION = "%s - A new version (|cff0070de%s|r) for this addon its available, please update your version.",
	PLAYER_VERSION = "%s - Player %s has a outdated version (|cff0070de%s|r) for this addon.",
}