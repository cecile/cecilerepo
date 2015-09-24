----------------------------------------------------------------------------------------------------
-- search addons config module

--get the engine and create the module
local Engine = select(2,...);

--create the modules as submodule of search
local search = Engine.AddOn:GetModule("search");
local mod = search:NewModule("addonsconfig");

--get the locale
local L=Engine.Locale;

--debug
local debug = Engine.AddOn:GetModule("debug");

--module defaults
mod.Defaults = {
	profile = {
		subsets = true,
		token = L["ADDONS_CONFIG_ITEM"],
	},
};

--Engine.Profile.search.addonsconfig.returnChildrens
--module options table
mod.Options = {
	order = 2,
	type = "group",
	name = L["ADDONS_MODULE"],
	cmdInline = true,
	args = {
		enable = {
			order = 1,
			type = "toggle",
			name = L["SEARCH_ENABLE_MODULE"],
			desc = L["SEARCH_ENABLE_MODULE_DESC"],
			get = function()
				return mod:IsEnabled();
			end,
			set = function(key, value)

				if(value) then
					mod:Enable();
				else
					mod:Disable();
				end

				Engine.Profile.search.disableModules[mod:GetName()] = (not value);
			end,
		},
		subsets = {
			order = 2,
			type = "toggle",
			name = L["ADDONS_RETURN_SUBSET"],
			desc = L["ADDONS_RETURN_SUBSET_DESC"],
			get = function()
				return Engine.Profile.search.addonsconfig.subsets;
			end,
			set = function(key, value)
				Engine.Profile.search.addonsconfig.subsets = value;
			end,
			disabled = function()
				return not mod:IsEnabled();
			end,
		},
		token = {
			order = 3,
			type = "input",
			name = L["SEARCH_TOKEN"],
			desc = L["SEARCH_TOKEN_DESC"],
			get = function()
				return Engine.Profile.search.addonsconfig.token;
			end,
			set = function(key, value)
				if not (value=="") then
					Engine.Profile.search.addonsconfig.token = value;
				end
			end,
			disabled = function()
				return not mod:IsEnabled();
			end,
		},
	}

};

--initialize the module
function mod:OnInitialize()

	--we dont have items
	mod.items = {};

	--get the window module
	mod.window = Engine.AddOn:GetModule("window");

	debug("search/addon config module initialize");

	mod.desc = L["ADDONS_MODULE"];

end

--create and stack with push and pop
function mod:CreateStack()
  -- stack table
  local t = {};

  -- entry table
  t._et = {};

  -- push a value on to the stack
  function t:push(...)
    if ... then
      local targs = {...};
      -- add values
      for _,v in ipairs(targs) do
        table.insert(self._et, v);
      end
    end
  end

  -- pop a value from the stack
  function t:pop(num)

    -- get num values from stack
    local num = num or 1

    -- return table
    local entries = {};

    -- get values into entries
    for i = 1, num do
      -- get last entry
      if #self._et ~= 0 then
        table.insert(entries, self._et[#self._et]);
        -- remove last value
        table.remove(self._et);
      else
        break;
      end
    end
    -- return unpacked entries
    return unpack(entries);
  end

  -- get entries
  function t:getn()
    return #self._et;
  end

  -- list values
  function t:list()
    for i,v in pairs(self._et) do
      print(i, v);
    end
  end

  --iterate values
  function t:iterate()
	return pairs(self._et);
  end

  return t;

end

function mod.openBlizConfig(item)

	--notify window
	mod.window.OnButtonClick(item);

	--open config twice (yes, if not does not work always)
	InterfaceOptionsFrame_OpenToCategory(item.data.id);
	InterfaceOptionsFrame_OpenToCategory(item.data.id);

end

--help function that remove wow color codes
function mod:RemoveColors(line)
	local str=line;
	local k,v;

	local escapes = {
		["|c%x%x%x%x%x%x%x%x"] = "", -- color start
		["|c%x%x%x%x%x%x"] = "", -- color start (w/o alpha)
		["|r"] = "", -- color end
	}

    for k, v in pairs(escapes) do
        str = gsub(str, k, v);
    end

    return str;

end

--create the list of AddOns config (blizzard)
function mod:PopulateAddonsConfig()

	--local vars
	local index,frame, parentText, searchableText,name,k,v;

	--options
	local subsets = Engine.Profile.search.addonsconfig.subsets;
	local token = Engine.Profile.search.addonsconfig.token;

	--create an stack
	local stack = mod:CreateStack();

	local lastParent = nil;

	--loop the tables
	for index,frame in pairs(_G.INTERFACEOPTIONS_ADDONCATEGORIES) do

		if not (lastParent==frame.parent) then
			lastParent = stack:pop();
		else
			lastParent = frame.parent;
		end

		--concatenate the parents names
		name = ""
		for k,v in stack:iterate() do
			name = name .. mod:RemoveColors(v).." / ";
		end

		--remove colors
		name = name .. mod:RemoveColors(frame.name);

		--format the search text
		searchableText = token..": "..name;

		--if its root or we want to return subsets
		if (frame.parent==nil) or (subsets) then
			--setup item
			item = { text = searchableText , id=frame, func = mod.openBlizConfig};

			--add the item
			table.insert(mod.items,item);
		end

		if frame.hasChildren then
			stack:push(frame.name);
			lastParent = frame.name;
		end

	end

	--sort the  talble
	table.sort(mod.items, function(a,b) return a.text < b.text end);


end

--refresh the data
function mod:Refresh()

	debug("refreshing Addons config data");

	--clear items
	mod.items = {};

	--populate Blizzard Addons config
	mod:PopulateAddonsConfig();

	debug("data refreshed");

end

--enable module
function mod:OnEnable()

	--we dont have items
	mod.items = {};

	debug(mod:GetName().." Enabled");

end

--disabled module
function mod:OnDisable()

	--we dont have items
	mod.items = {};

	debug(mod:GetName().." Disabled");
end
