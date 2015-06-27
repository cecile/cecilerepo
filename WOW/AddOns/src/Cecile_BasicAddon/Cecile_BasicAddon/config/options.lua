----------------------------------------------------------------------------------------------------
-- Addon Default Const, Options & Options UI
--

--get the engine & Locale
local AddOnName,Engine = ...;
local L = Engine.Locale;

--create the module
local mod = Engine.AddOn:NewModule("options");
	

--defaults
Engine.Defaults = {
	profile = {	
	}
};
	
--options table for the options ui
Engine.Options = {
	type = "group",
	name = Engine.Name,
	args = {

		Title = {
			order = 0,
			type = "description",
			fontSize = "large",
			name = string.format(L["CONFIG_WINDOW"],GetAddOnMetadata(AddOnName, "Title"),GetAddOnMetadata(AddOnName, "Version"))
		},
		Header = {
			order = 1,
			type = "header",
			name = "",
			width = "full",
		},	
		general = {
			order = 2,
			type = "group",
			name = L["GENERAL_SETTINGS"],
			cmdInline = true,
			args = {
				Frames_Header = {
					type = "description",
					order = 0,
					name = L["GENERAL_SETTINGS"],
					fontSize = "large",
				},				
			}
		},	
	},
};

-- Interface - Addons (Ace3 Blizzard Options)
Engine.blizzardOptions = {
	name = string.format(L["CONFIG_WINDOW"],GetAddOnMetadata(AddOnName, "Title"),GetAddOnMetadata(AddOnName, "Version")),
	handler = x,
	type = 'group',
	args = {
		showConfig = {
			order = 1,
			type = 'execute',
			name = L["OPEN_CONFIG"],
			desc = L["OPEN_CONFIG_DESC"],
			func = function() InterfaceOptionsFrameOkay:Click();
				LibStub("AceConfigDialog-3.0"):Open(AddOnName); 
				GameMenuButtonContinue:Click() 
			end,
		},
	},
}

--initialize module
function mod:OnInitialize()
end