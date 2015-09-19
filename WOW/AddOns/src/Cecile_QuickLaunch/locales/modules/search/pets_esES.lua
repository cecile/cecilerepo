----------------------------------------------------------------------------------------------------
-- localized Spanish (pets module) strings
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

--pets module
L["PETS_PET"] = "Mascota: "
L["PETS_FAVORITE"] = " (favorita)"
L["PETS_DISMISS"] = "Mascota: Retirar"
L["PETS_RANDOM"] = "Mascota: Aleatoria (favorita)"