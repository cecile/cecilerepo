----------------------------------------------------------------------------------------------------
-- Handle addon configuration
--

--get the engine & Addon
local Engine = select(2,...)
local AddOn = Engine.AddOn

--load libraries
local AceConfig = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")
local AceDB = LibStub("AceDB-3.0")
local AceDBOptions = LibStub("AceDBOptions-3.0")

--get locale
local L = Engine.Locale;

--defaults
Engine.DB = {};
Engine.DB.profile={};
Engine.Profile = Engine.DB.profile;

--return two slash commands from a addon name, for example Cecile_ExampleAddon will return cea & cecile_ea
function AddOn:GetSlashFromName(name)

	local slash1 = "";
	local slash2 = "";
	
	local i;
	local c;
	local picknext = true;
	local pickedfirstspace = false;
	
	for i = 1, string.len(name) do

		c = string.sub(name,i,i);
		
		if (picknext) then
			slash1 = slash1 .. string.lower(c);
			if pickedfirstspace then
				slash2 = slash2 .. string.lower(c);
			end			
			picknext = false;
		else
			if (c=="_") or (c==" ") then
				picknext = true;
				pickedfirstspace = true;
				slash2 =  slash2..string.lower(string.sub(name,1,i-1)).."_";
			elseif (c==string.upper(c)) then
				slash1 = slash1 .. string.lower(c);
				if pickedfirstspace then
					slash2 = slash2 .. string.lower(c);
				end
			end
		end		
	end
	if not pickedfirstspace then
		slash2 = slash2 .. string.lower(name);
	end

	return slash1,slash2;	
end

--setup options
function AddOn:SetupOptions()

	--setup module options and defaults
	local module,name
	local databaseName,databaseTable

	for name,module in pairs(self.modules) do

		--if this module has defaults
		if(module.Defaults) then

			--get all defaults tables of the module andd add then to the global defaults
			for databaseName,databaseTable in pairs(module.Defaults) do			
				Engine.Defaults[databaseName][name] = databaseTable;
			end

		end

		--if this module has an option table add to global options table
		if(module.Options) then
			Engine.Options.args[name] = module.Options;
		end

	end

	--create database
	Engine.DB = AceDB:New(Engine.Name.."DB", Engine.Defaults, true);
	Engine.GLOBAL = _G[Engine.Name.."DB"];

	--register profile changes callbacks
	Engine.DB.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged");
	Engine.DB.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged");
	Engine.DB.RegisterCallback(self, "OnProfileReset", "OnProfileChanged");

	--set profile
	Engine.Profile = Engine.DB.profile;
	
	-- Add the options and profiles to the config dialog
	Engine.Options.args['Profiles'] = AceDBOptions:GetOptionsTable(Engine.DB);
	Engine.Options.args['Profiles'].name=L["PROFILES"];
	AceConfig:RegisterOptionsTable(Engine.Name, Engine.Options);

	-- Add dual-spec support
	local LibDualSpec = LibStub('LibDualSpec-1.0');
	LibDualSpec:EnhanceDatabase(Engine.DB, Engine.Name);
	LibDualSpec:EnhanceOptions(Engine.Options.args['Profiles'], Engine.DB);

	--get version
	local Version = AddOn:GetModule("version");

	--blizzard options
	AceConfig:RegisterOptionsTable(Engine.Name.."Blizzard", Engine.blizzardOptions);
	AceConfigDialog:AddToBlizOptions(Engine.Name.."Blizzard", Engine.Name);
	
	--get the slash commmands
	Engine.slash1,Engine.slash2 = AddOn:GetSlashFromName(Engine.Name);
	
	-- Create slash commands
	_G["SLASH_"..Engine.Name.."1"] = "/"..Engine.slash1;
	_G["SLASH_"..Engine.Name.."2"] = "/"..Engine.slash2;
	SlashCmdList[Engine.Name] = AddOn.ShowConfig;	
end

-- Open config window
function AddOn:ShowConfig()
	LibStub("AceConfigDialog-3.0"):Open(Engine.Name); 
end

-- Called after profile changed, we reset our datatext
function AddOn:OnProfileChanged(event, database, newProfileKey)

	--set new profile
	Engine.Profile = database.profile;
	
	--notify modules profile change
	local module,name
	
	--if any module has a OnProfileChange trigger it
	for name,module in pairs(self.modules) do

		if module.OnProfileChanged and type(module.OnProfileChanged)=="function" then
			module.OnProfileChanged(event);
		end

	end

end