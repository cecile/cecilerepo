----------------------------------------------------------------------------------------------------
-- search addons config module

--get the engine and create the module
local Engine = _G.Cecile_QuickLaunch;

--create the modules as submodule of search
local search = Engine.AddOn:GetModule("search");
local mod = search:NewModule("addons");

--debug
local debug = Engine.AddOn:GetModule("debug");

--get the locale
local L=Engine.Locale;

mod.desc = L["ADDONS_MODULE"];

--module vars
mod.Vars = {
  subsets =  {
    type = "boolean",
    default = true,
    order = 1,
    label = L["ADDONS_RETURN_SUBSET"],
    desc = L["ADDONS_RETURN_SUBSET_DESC"]
  },
  token =  {
    type = "string",
    default = L["ADDONS_CONFIG_ITEM"],
    order = 2,
    label = L["SEARCH_TOKEN"],
    desc = L["SEARCH_TOKEN_DESC"]
  },
};

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

	--open config twice (yes, if not does not work always)
	InterfaceOptionsFrame_OpenToCategory(item.id);
	InterfaceOptionsFrame_OpenToCategory(item.id);

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
	local subsets = mod.Profile.subsets;
	local token = mod.Profile.token;

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

	--populate Blizzard Addons config
	mod:PopulateAddonsConfig();

	debug("data refreshed");

end