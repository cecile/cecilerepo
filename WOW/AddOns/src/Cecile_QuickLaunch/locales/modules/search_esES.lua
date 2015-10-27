----------------------------------------------------------------------------------------------------
-- localized Spanish (search module) strings
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

--search module
L["SEARCH_NAME"] = "Búsqueda"
L["SEARCH_ENABLE_MODULE"] = "Activado"
L["SEARCH_ENABLE_MODULE_DESC"] = "Activa/Desactiva este módulo"
L["SEARCH_ALIASES"] = "Sinónimos"
L["SEARCH_ALIASES_DESC"] = "Elije un sinónimo"
L["SEARCH_ALIAS_NAME"] = "Nombre del sinónimo"
L["SEARCH_ALIAS_VALUE"] = "Valor del sinónimo"
L["SEARCH_ALIAS_SAVE"] = "Grabar"
L["SEARCH_ALIAS_SAVE_DESC"] = "Grabar el sinónimo"
L["SEARCH_ALIAS_NEW"] = "Nuevo"
L["SEARCH_ALIAS_NEW_DESC"] = "Nuevo sinónimo"
L["SEARCH_ALIAS_DELETE"] = "Borrar"
L["SEARCH_ALIAS_DELETE_DESC"] = "Borra el sinónimo"
L["SEARCH_TOKEN"] = "Símbolo de busqueda"
L["SEARCH_TOKEN_DESC"] = "Cambia el símbolo generado por las busquedas"