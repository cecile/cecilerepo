----------------------------------------------------------------------------------------------------
-- localized Spanish (mounts module) strings
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

--mounts module
L["MOUNTS_MOUNT"] = "Montura: "
L["MOUNT_FAVORITE"] = " (favorita)"
L["MOUNT_DISMOUNT"] = "Montura: Desmontar"
L["MOUNT_RANDOM"] = "Montura: Aleatoria (favorita)"