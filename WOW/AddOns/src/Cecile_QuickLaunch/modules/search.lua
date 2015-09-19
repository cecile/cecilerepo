----------------------------------------------------------------------------------------------------
-- search module

--get the engine and create the module
local Engine = select(2,...);
local mod = Engine.AddOn:NewModule("search");

--get the locale
local L=Engine.Locale;

--debug
local debug = Engine.AddOn:GetModule("debug");


--initialize the module
function mod:OnInitialize()

	mod.window = Engine.AddOn:GetModule("window");

	debug("search module initialize");

end

function mod:Refresh()

	debug("refreshing search data");

	--goes trough all the modules
	for name,module in pairs(self.modules) do
		module:Refresh();
	end

	debug("data refreshed");

end

--check if we match this item with the entered text
function mod:MatchItem(item,text)

	--set to lower case
	local item = item:lower();
	local text = text:lower();

	--flag to control if we match every wod
	local matchAllWords = true;

	--local vars
	local word;

	--go word by word and check if we match
	for word in string.gmatch(text, "[^ ]+") do
		matchAllWords = matchAllWords and (not (string.find(item,word)==nil) );
	end

	--return all words
	return matchAllWords;

end

--color string based on match
function mod:ColorItem(item,text)

	--our result
	local result = item;

	--convert to lower
	local item = item:lower();
	local text = text:lower();

	--local vars
	local word;
	local positions = {};
	local pos;

	--go word by word
	for word in string.gmatch(text, "[^ ]+") do

		--if we get one store the position on the string
		local startPos,endPos = string.find(item,word);
		pos = { from = startPos, to = endPos };

		table.insert(positions,pos);

	end

	--sort the positions
	table.sort(positions, function(a,b) return a.from < b.from end);

	--more local vars
	local concatenated = "";
	local before,token, after;

	--we have not modified, yet
	local acumulated = 0;

	--loop the words
	for k,pos in pairs(positions) do

		--empty result
		concatenated = "";

		--move if we have alreayd modified something
		pos.from = pos.from + acumulated;
		pos.to = pos.to + acumulated;

		--get before token string
		if not (pos.from==1) then
			before  = string.sub(result,1,pos.from-1);
		else
			before = "";
		end

		--get the token and after string
		token = string.sub(result,pos.from,pos.to);
		after = string.sub(result,pos.to+1);

		--colorize it
		result = before.."|cffffffff"..token.."|r"..after;

		--we increase next positions
		acumulated = acumulated + 12;

	end

	return result;

end

--find in a module
function mod:FindInModule(module,text)

	--our result
	local result = {};

	--local vars
	local word;
	local k,item;
	local words;

	--loop al items
	for k, item in pairs(module.items) do

		--if this item match
		if mod:MatchItem(item.text,text) then

			--add color
			item.displayText = mod:ColorItem(item.text,text);

			--insert into the table
			table.insert(result,item);

		end

	end

	return result;

end

--find all items using the text
function mod:FindAll(text)

	--our result
	local result = {};

	--local vars
	local items;

	--double check that we need something to search
	if (text==nil) then return result; end
	if (text=="") then return result; end

	--local vars
	local module,name, key, item

	--goes trough all the modules
	for name,module in pairs(self.modules) do

		--get the items for this module
		items = mod:FindInModule(module,text);

		--merge the tables
		for key,item in pairs(items) do
			table.insert(result,item);
		end

		--we dont need it anymore
		items = nil;

	end

	return result;
end

--enable module
function mod:OnEnable()

end
