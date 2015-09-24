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
L["PETS_PET"] = "Mascota"
L["PETS_FAVORITE"] = "favorita"
L["PETS_DISMISS"] = "Retirar"
L["PETS_RANDOM"] = "Aleatoria"
L["PETS_MODULE"] = "Módulo de Mascotas"
L["PETS_RETURN_FAVORITES"] = "Devolver Favoritas"
L["PETS_RETURN_FAVORITES_DESC"] = "Activar/Desactivar devolver mascotas favoritas"
L["PETS_RETURN_NO_FAVORITES"] = "Devolver No Favoritas"
L["PETS_RETURN_NO_FAVORITES_DESC"] = "Activar/Desactivar devolver mascotas no favoritas"
L["PETS_FAVORITE_TAG"] = "Etiqueta Favoritos"
L["PETS_FAVORITE_TAG_DESC"] = "Cambia la etiqueta para los items favoritos"
