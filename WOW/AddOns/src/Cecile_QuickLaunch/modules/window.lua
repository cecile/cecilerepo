----------------------------------------------------------------------------------------------------
-- window module

--get the engine and create the module
local Engine = select(2,...);
local mod = Engine.AddOn:NewModule("window");

--get the locale
local L=Engine.Locale;

--debug
local debug = Engine.AddOn:GetModule("debug");

--sharemedia
local LSM = LibStub("LibSharedMedia-3.0");

--load profile settings
function mod:LoadProfileSettings()

	--get the font
	mod.fontObject = LSM:Fetch("font", Engine.Profile.window.font.name);
	mod.fontSize = Engine.Profile.window.font.size;

end

--on escape presessed
function mod.OnEscapePressed()

	---hide the window
	mod:Show(false);
end

--default action on button click
function mod.OnButtonClick()

	--the the window
	mod:Show(false);

end

--create a border in a direction,size, and color
function mod.CreateBorder(object,direction,r,g,b)

	--the size does not have direction
	local size = math.abs(direction);

	--get the frame border if its has it
	local border = object.border;

	--if has not border create it
	if border == nil then
		border = CreateFrame("Frame", nil, object);
	end

	--if has anchors remove them
	if border:GetPoint() then
		border:ClearAllPoints();
	end

	--set the anchors base on our direction
	border:SetPoint('TOPLEFT', object, 'TOPLEFT', direction, -direction)
	border:SetPoint('BOTTOMRIGHT', object, 'BOTTOMRIGHT', -direction, direction)

	--se the right frame level
	border:SetFrameLevel(object:GetFrameLevel() + 1)

	--set a solid backdrop with right insets
	border:SetBackdrop({
		edgeFile = [[Interface\BUTTONS\WHITE8X8]],
		edgeSize = size,
		insets = { left = size, right = size, top = size, bottom = size }
	});

	--set the backdrop color
	border:SetBackdropBorderColor(r, g, b, 1)

	--store border
	object.border = border;
end

--se the frame to be just a single color frame
function mod.SetSolidColor(object, r,g,b,a)

	--create and set the texture
	object.texture = object:CreateTexture(nil, "BACKGROUND");
	object.texture:SetAllPoints(true);
	object.texture:SetTexture(r,g,b,a);

end

--create a UI object and inject our functions
function mod:CreateUIObject(class,parent,name,template)

	local frame = CreateFrame(class, name, parent, template);

	frame.CreateBorder = mod.CreateBorder;
	frame.SetSolidColor = mod.SetSolidColor;

	return frame;
end

--get the max possible scroll
function mod:GetMaxScroll()

	--get how many items could be drown on screen
	local onScreen = math.floor(mod.mainFrame.scrollArea:GetHeight() / 20);

	--get how we could scroll using how many we have and how manny fit
	local toScroll = (mod.totalItems-1) - onScreen;

	--get in ui coords
	local maxScroll = toScroll*20;

	--clamp negative values
	maxScroll = math.max(maxScroll,0);

	--return results
	return maxScroll;

end

--helper function to set the current scroll and update slider
function mod:SetScroll(value)
	mod.mainFrame.scrollArea:SetVerticalScroll(value);
	mod:UpdateSlider();
end

--update our slider
function mod:UpdateSlider()

	--get our max scroll
	local maxScroll = mod:GetMaxScroll();

	--by default slider cover all him box
	local from = 0;
	local to = 0;

	--if we have something to scroll
	if not (maxScroll==0) then

		--get current scroll
		local currentScroll = mod.mainFrame.scrollArea:GetVerticalScroll();

		--calculcate el % of our position
		local percent = currentScroll/maxScroll;

		--calculate from-to
		from = 75*percent;
		to = 75*(1-percent);
	end

	--remve anchors
	mod.mainFrame.slider:ClearAllPoints();

	--set new anchors
	mod.mainFrame.slider:SetPoint("TOPLEFT", 		mod.mainFrame.sliderBox,	"TOPLEFT", 		4, -4-from);
	mod.mainFrame.slider:SetPoint("TOPRIGHT",		mod.mainFrame.sliderBox,	"TOPRIGHT", 	-4, -4-from);
	mod.mainFrame.slider:SetPoint("BOTTOMLEFT", 	mod.mainFrame.sliderBox,	"BOTTOMLEFT", 	4, 4+to);
	mod.mainFrame.slider:SetPoint("BOTTOMRIGHT",	mod.mainFrame.sliderBox,	"BOTTOMRIGHT", 	4, 4+to);

end

---scroll the window with mouse wheel
function mod.ScrollingFunction(self, arg)

	--get how much we could scroll
	local maxScroll = mod:GetMaxScroll();

	--get current scroll
	local currentScroll = mod.mainFrame.scrollArea:GetVerticalScroll();

	--get how much we want to scroll
	local scroll = currentScroll + (arg*-5);

	--clamp value
	scroll = math.min(scroll,maxScroll);
	scroll = math.max(scroll,0);

	--if actualy we are going to scroll
	if not (currentScroll == scroll) then
		mod:SetScroll(scroll);
	end
end

--on mouse over a button
function mod.OnButtonEnter(object)

	--if the object is not selected set the hightligh color
	if object.selected==false then
		object:UnlockHighlight();
		object.highlight:SetVertexColor(0.3,0.3,0.3);
	end

end

function mod.OnButtonLeave(object)
end


function mod:CreateScrollItem(text)

	--get the position for this item
	local position = (#mod.mainFrame.scrollContent.items);

	--create the item
	local frame = mod:CreateUIObject("Button",mod.mainFrame.scrollContent,"LauncherButton"..position, "OptionsListButtonTemplate");

	--calculate start and end Y position
	local startY = position * -20;
	local endY = startY-20;

	--set the font
	frame.text:SetFont(mod.fontObject,mod.fontSize);

	--position the object
	frame:SetPoint("TOPLEFT", 		mod.mainFrame.scrollContent,"TOPLEFT", 	0, startY);
	frame:SetPoint("TOPRIGHT", 		mod.mainFrame.scrollContent,"TOPRIGHT",	0, startY);
	frame:SetPoint("BOTTOMLEFT", 	mod.mainFrame.scrollContent,"TOPLEFT", 	0, endY);
	frame:SetPoint("BOTTOMRIGHT",	mod.mainFrame.scrollContent,"TOPRIGHT", 0, endY);

	--set scripts
	frame:SetScript("OnEnter", mod.OnButtonEnter)
	frame:SetScript("OnLeave", mod.OnButtonLeave)


	--set style
	frame:CreateBorder(-1,0,0,0);
	frame.text:SetTextColor(0.5,0.5,0.5);

	--set the text
	frame.text:SetText(text);

	--store position
	frame.position = position+1;

	--insert into our table
	table.insert(mod.mainFrame.scrollContent.items,frame);

	--hid this button
	frame:Hide();

end

--add a new item
function mod:AddItem(item)

	--if we are in our limit don't add
	if mod.totalItems<mod.maxItems then

		--count
		mod.totalItems = mod.totalItems + 1;

		--get the button
		local button = mod.mainFrame.scrollContent.items[mod.totalItems];

		--set the scripts
		button:SetScript("OnClick", nil);
		button:SetScript("OnClick", item.func);

		--store the data
		button.data = item;

		--set the text
		button.text:SetText(item.displayText);

		--display the button
		button:Show();

	end

end


--select a item
function mod:SelectButton(object)

	--goes trough the objects
	local key,value;

	--remove highlight and reset selected to all of them
	for key,value in pairs(mod.mainFrame.scrollContent.items) do
		value:UnlockHighlight();
		value.selected = false;

		object.highlight:SetVertexColor(0.3,0.3,0.3);
	end

	--store in the edit box the one we like
	mod.mainFrame.editBox.data = object.data;
	mod.mainFrame.editBox:SetScript("OnEnterPressed", object.data.func);

	--set this to selected
	object:LockHighlight();
	object.highlight:SetVertexColor(0.6,0.6,0.6);
	object.selected = true;

end

--select a object using a index
function mod:SelectButtonByIndex(index)

	--get the button and select it
	local button = mod.mainFrame.scrollContent.items[index];
	mod:SelectButton(button);

end

--get the current selected button
function mod:GetSelectedButton()

	--if we have none by default
	local result = nil;

	--local vars
	local key,value;

	--find it
	for key,value in pairs(mod.mainFrame.scrollContent.items) do

		if value.selected then
			result = value;
			break;
		end
	end

	--return value
	return result;

end

--if tab is press
function mod.OnTabPressed(object)

	--if we dont have item return
	if mod.totalItems==0 then return; end

	--get the current selected item
	local selected = mod:GetSelectedButton();

	--if we dont have return
	if(not selected) then return; end

	--go to the new position
	local currentSelection = selected.position;
	local new;

	--reverse with shift
	if IsShiftKeyDown() then
		new = currentSelection-1;
	else
		new = currentSelection+1;
	end

	--loop position
	if new > mod.totalItems then
		new = 1;
	elseif new < 1 then
		new = mod.totalItems;
	end

	--if actualy we are going anywhere
	if not (currentSelection==new) then

		--select the new position
		mod:SelectButtonByIndex(new);

		--scroll to it
		mod:SetScroll(0);
		mod.ScrollingFunction(mod.mainFrame.scrollArea,-(4*(new-1)));

	end

end

--remove all items
function mod:ClearAllItems()

	--local vars
	local key,value;

	--lopp the items
	for key,value in pairs(mod.mainFrame.scrollContent.items) do

		--reset object
		value:Hide();
		value:SetScript("OnClick", nil);
		value.data=nil;
		value:UnlockHighlight();
		value.selected = false;

	end

	--we dont have items
	mod.totalItems=0;

	--we dont do nothing on enter now
	mod.mainFrame.editBox:SetScript("OnEnterPressed", nil);
end

--if the text has change
function mod.OnTextChanged(self,char)

	--get the text
	local text = self:GetText();

	--if has change from the previous text
	if not (self.lastText == text) then

		--clear all items
		mod:ClearAllItems();

		--store as last text
		self.lastText = text;

		--if actually we have any text
		if(text) then

			--find items for it
			items = mod.search:FindAll(text);

			--loop trough the items and add them
			local key,value;

			for key,value in pairs(items) do
				mod:AddItem(value);
			end

			--if we have any item, select the first
			if mod.totalItems > 0 then
				mod:SelectButtonByIndex(1);
			end

			--reset scroll
			mod:SetScroll(0);

		end

	end

end



--create UI
function mod:CreateUI()

	--create main frame
	mod.mainFrame = mod:CreateUIObject("Frame",UIParent);

	mod.mainFrame:SetSize(800, 200);
	mod.mainFrame:SetPoint("CENTER", 0, 0);

	mod.mainFrame:SetSolidColor(0.2, 0.2, 0.2, 0.5);
	mod.mainFrame:CreateBorder(-2,0,0,0);
	mod.mainFrame:SetScript("OnMouseWheel", mod.ScrollingFunction);

	--create edit box
	mod.mainFrame.editBox = mod:CreateUIObject("EditBox",mod.mainFrame,"Launcher_Editbox");

	mod.mainFrame.editBox:SetPoint("TOPLEFT", 	mod.mainFrame, "TOPLEFT", 	8, -8);
	mod.mainFrame.editBox:SetPoint("TOPRIGHT", 	mod.mainFrame, "TOPRIGHT", -8, -8);

	mod.mainFrame.editBox:SetFont(mod.fontObject,mod.fontSize);
	mod.mainFrame.editBox:SetHeight(14);

	mod.mainFrame.editBox:SetSolidColor(0.0, 0.0, 0.0, 0.5);
	mod.mainFrame.editBox:CreateBorder(-2,0,0,0);
	mod.mainFrame.editBox:SetTextColor(1,1,1);

	mod.mainFrame.editBox:SetText("");
	mod.mainFrame.editBox:SetScript("OnEscapePressed", mod.OnEscapePressed);
	mod.mainFrame.editBox:SetScript("OnTextChanged", mod.OnTextChanged);
	mod.mainFrame.editBox:SetScript("OnTabPressed", mod.OnTabPressed);

	--create scroll area
	mod.mainFrame.scrollArea = mod:CreateUIObject("ScrollFrame",mod.mainFrame);

	mod.mainFrame.scrollArea:SetPoint("TOPLEFT", 		mod.mainFrame.editBox,	"BOTTOMLEFT", 	0, -10);
	mod.mainFrame.scrollArea:SetPoint("TOPRIGHT", 		mod.mainFrame.editBox,	"BOTTOMRIGHT", 	-20, -10);
	mod.mainFrame.scrollArea:SetPoint("BOTTOMLEFT", 	mod.mainFrame,			"BOTTOMLEFT", 	0, 10);
	mod.mainFrame.scrollArea:SetPoint("BOTTOMRIGHT",	mod.mainFrame,			"BOTTOMRIGHT", 	-20, 10);

	mod.mainFrame.scrollArea:SetSolidColor(0.0, 0.0, 0.0, 0.5);
	mod.mainFrame.scrollArea:CreateBorder(-2,0,0,0);

	--slider box
	mod.mainFrame.sliderBox = mod:CreateUIObject("Frame",mod.mainFrame);

	mod.mainFrame.sliderBox:SetPoint("TOPLEFT", 	mod.mainFrame.scrollArea,	"TOPRIGHT", 	5, 0);
	mod.mainFrame.sliderBox:SetPoint("TOPRIGHT",	mod.mainFrame.scrollArea,	"TOPRIGHT", 	20, 0);
	mod.mainFrame.sliderBox:SetPoint("BOTTOMLEFT", 	mod.mainFrame.scrollArea,	"BOTTOMLEFT", 	5, 0);
	mod.mainFrame.sliderBox:SetPoint("BOTTOMRIGHT",	mod.mainFrame.scrollArea,	"BOTTOMLEFT", 	20, 0);

	mod.mainFrame.sliderBox:SetSolidColor(0.0, 0.0, 0.0, 0.5);
	mod.mainFrame.sliderBox:CreateBorder(-2,0,0,0);

	--slider
	mod.mainFrame.slider = mod:CreateUIObject("Frame",mod.mainFrame);

	mod.mainFrame.slider:SetPoint("TOPLEFT", 		mod.mainFrame.sliderBox,	"TOPLEFT", 		4, -4);
	mod.mainFrame.slider:SetPoint("TOPRIGHT",		mod.mainFrame.sliderBox,	"TOPRIGHT", 	-4, -4);
	mod.mainFrame.slider:SetPoint("BOTTOMLEFT", 	mod.mainFrame.sliderBox,	"BOTTOMLEFT", 	4, 4);

	mod.mainFrame.slider.maxHeight = mod.mainFrame:GetHeight();

	mod.mainFrame.slider:SetPoint("BOTTOMRIGHT",	mod.mainFrame.sliderBox,	"BOTTOMRIGHT", 	4, 4);

	mod.mainFrame.slider:SetSolidColor(0.5, 0.5, 0.5, 0.5);

	--create scroll content
	mod.mainFrame.scrollContent = mod:CreateUIObject("Frame",mod.mainFrame.scrollArea);
	mod.mainFrame.scrollContent:SetWidth(800);
	mod.mainFrame.scrollContent:SetHeight(4000);
	mod.mainFrame.scrollContent:SetSolidColor(0.0, 0.0, 0.0, 0.5);

	--attach the scroll content to the scroll area
	mod.mainFrame.scrollArea:SetScrollChild(mod.mainFrame.scrollContent);

	--create empty items
	mod.mainFrame.scrollContent.items = {};

	--max number of items
	mod.maxItems = 200;

	local i;
	for i=1,mod.maxItems do
		mod:CreateScrollItem("test"..i);
	end

	--we dont have any item, yet
	mod.totalItems = 0;

	--hide the frame
	mod.mainFrame:Hide();

	debug("UI created");

end

--event when we enter combat
function mod.InCombat()
	mod.combat = true;
	mod:Show(false);
end

--event when we exit combat
function mod.OutOfCombat()
	mod.combat = false;
end

--save & remove a binding
function mod:SafeSetBinding(key, action)
	if key == "" then
		oldkey = GetBindingKey(action)
		if oldkey then
			SetBinding(oldkey, nil)
		end
	else
		SetBinding(key, action)
	end
	SaveBindings(GetCurrentBindingSet())
end


--set a default binding if no one has it
function mod:SetDefaultBinding(key,action)

	--get our binding
	local ourkey1,ourkey2 = GetBindingKey(action);

	--if we dont have it
	if (ourkey1==nil) and (ourkey2==nil) then

		--get possible action for this binding since SHIFT-P or CTRL-SHIFT-P look the same
		local possibleAction = GetBindingByKey(key);

		--by default we could set this binding
		local okToSet = true;

		--if any action
		if possibleAction then

			--get the action keys
			local key1,key2 = GetBindingKey(possibleAction);

			--if any key match our key
			if (key1 == key) or (key2 == key) then
				okToSet = false;
			end

		end

		--if ok to set
		if okToSet then
			mod:SafeSetBinding(key,action);
			debug("default binding '%s' set to '%s'", action, key);
		end

	end

end

--initialize the module
function mod:OnInitialize()

	--load profile settings
	mod:LoadProfileSettings();

	--create the UI
	mod:CreateUI();

	--save the serch module
	mod.search = Engine.AddOn:GetModule("search");

	--we are not in combat
	mod.combat = false;

	--handle in combat
	Engine.AddOn:RegisterEvent("PLAYER_REGEN_ENABLED",mod.OutOfCombat);
	Engine.AddOn:RegisterEvent("PLAYER_REGEN_DISABLED",mod.InCombat);

end

--enable module
function mod:OnEnable()

end

--show/hide the main window
function mod:Show(value)

	--if we like to show
	if(value) then

		--if we actually no shown
		if not mod.mainFrame:IsShown() then

			--if we are in combat display a message and return
			if mod.combat then
				--get version
				local Version = Engine.AddOn:GetModule("version");

				print(string.format(L["WINDOW_ERROR_IN_COMBAT"],Version.Title));
				return;
			end
			--reset UI
			mod.search:Refresh();
			mod:SetScroll(0);
			mod.mainFrame.editBox:SetText("");
			mod:ClearAllItems();

			--show the window
			mod.mainFrame:Show();

		end
	else

		--if we actually shown, hide
		if mod.mainFrame:IsShown() then
			mod.mainFrame:Hide();
		end
	end

end

--profile has change
function mod.OnProfileChanged(event)

	--load profile settings
	mod:LoadProfileSettings();

end

--handle commands
function mod.handleCommand(args)

	--has this module handle the command?
	handleIt = false;

	--if the command is 'show'
	if args=="launch" then

		--show
		mod:Show(true);

		--this module has handle the command
		handleIt = true;

	end

	return handleIt;

end

--module options table
mod.Options = {
	order = 3,
	type = "group",
	name = L["WINDOW_SETTINGS"],
	args = {
		Frames_Header = {
			type = "description",
			order = 0,
			name = L["WINDOW_SETTINGS"],
			fontSize = "large",
		},
		debug = {
			order = 1,
			type = "keybinding",
			name = L["WINDOW_BINDING_LAUNCH"],
			desc = L["WINDOW_BINDING_LAUNCH_DESC"],
			get = function()
				return GetBindingKey("LAUNCH_CQL");
			end,
			set = function(key, value)

				mod:SafeSetBinding(value, "LAUNCH_CQL");

			end,
		},
	}

};

--module defaults
mod.Defaults = {
	profile = {
		font = {
			name = "Cecile",
			size = 12,
		},
	},
};
