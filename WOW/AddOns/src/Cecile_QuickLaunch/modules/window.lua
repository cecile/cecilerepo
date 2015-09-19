----------------------------------------------------------------------------------------------------
-- window module

--get the engine and create the module
local Engine = select(2,...);
local mod = Engine.AddOn:NewModule("window");

--get the locale
local L=Engine.Locale;

--debug
local debug = Engine.AddOn:GetModule("debug");


--load profile settings
function mod:LoadProfileSettings()

end

function mod.OnEscapePressed()
	mod:Show(false);
end

function mod.OnButtonClick()
	mod:Show(false);
end

function mod.CreateBorder(object,direction,r,g,b)

	local size = math.abs(direction);

	local border = object.border;

	if border == nil then

		border = CreateFrame("Frame", nil, object);

	end

	if border:GetPoint() then
		border:ClearAllPoints();
	end

	border:Point('TOPLEFT', object, 'TOPLEFT', direction, -direction)
	border:Point('BOTTOMRIGHT', object, 'BOTTOMRIGHT', -direction, direction)

	border:SetFrameLevel(object:GetFrameLevel() + 1)

	border:SetBackdrop({
		edgeFile = [[Interface\BUTTONS\WHITE8X8]],
		edgeSize = size,
		insets = { left = size, right = size, top = size, bottom = size }
	});

	border:SetBackdropBorderColor(r, g, b, 1)

	object.border = border;
end

function mod.SetSolidColor(object, r,g,b,a)

	object.texture = object:CreateTexture(nil, "BACKGROUND");
	object.texture:SetAllPoints(true);
	object.texture:SetTexture(r,g,b,a);

end

function mod:CreateUIObject(class,parent,name,template)

	local frame = CreateFrame(class, name, parent, template);

	frame.CreateBorder = mod.CreateBorder;
	frame.SetSolidColor = mod.SetSolidColor;

	return frame;
end

function mod:GetMaxScroll()

	local onScreen = math.floor(mod.mainFrame.scrollArea:GetHeight() / 20);
	local toScroll = (mod.totalItems-1) - onScreen;
	local maxScroll = toScroll*20;

	maxScroll = math.max(maxScroll,0);

	return maxScroll;

end

function mod:SetScroll(value)
	mod.mainFrame.scrollArea:SetVerticalScroll(value);
	mod:UpdateSlider();
end

function mod:UpdateSlider()

	local maxScroll = mod:GetMaxScroll();

	local from = 0;
	local to = 0;

	if not (maxScroll==0) then
		local currentScroll = mod.mainFrame.scrollArea:GetVerticalScroll();
		local percent = currentScroll/maxScroll;

		from = 75*percent;
		to = 75*(1-percent);
	end

	mod.mainFrame.slider:ClearAllPoints();

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

function mod.OnButtonEnter(object)

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

	frame:Hide();

end

function mod:AddItem(item)

	if mod.totalItems<mod.maxItems then

		mod.totalItems = mod.totalItems + 1;

		local button = mod.mainFrame.scrollContent.items[mod.totalItems];

		button:SetScript("OnClick", nil);
		button:SetScript("OnClick", item.func);

		button.data = item;
		button.text:SetText(item.displayText);
		button:Show();

		if mod.totalItems == 1 then
			mod:SelectButton(button);
		end

	end

end


function mod:SelectButton(object)

	local key,value;

	for key,value in pairs(mod.mainFrame.scrollContent.items) do
		value:UnlockHighlight();
		value.selected = false;

		object.highlight:SetVertexColor(0.3,0.3,0.3);
	end

	mod.mainFrame.editBox.data = object.data;
	mod.mainFrame.editBox:SetScript("OnEnterPressed", object.data.func);

	object:LockHighlight();
	object.highlight:SetVertexColor(0.6,0.6,0.6);
	object.selected = true;

end

function mod:SelectButtonByIndex(index)

	local button = mod.mainFrame.scrollContent.items[index];

	mod:SelectButton(button);

end


function mod:GetSelectedButton()

	local result = nil;

	local key,value;

	for key,value in pairs(mod.mainFrame.scrollContent.items) do

		if value.selected then
			result = value;
			break;
		end
	end

	return result;

end

function mod.OnKeyDown(object,key)
	debug(key);
end

function mod.OnTabPressed(object)

	if mod.totalItems==0 then return; end

	local selected = mod:GetSelectedButton();

	if(not selected) then return; end

	local currentSelection = selected.position;
	local new = currentSelection+1;

	if new > mod.totalItems then
		new = 1;
	end

	if not (currentSelection==new) then

		mod:SelectButtonByIndex(new);
		mod:SetScroll(0);
		mod.ScrollingFunction(mod.mainFrame.scrollArea,-(4*(new-1)));

	end

end

function mod:ClearAllItems()

	local key,value;

	for key,value in pairs(mod.mainFrame.scrollContent.items) do
		value:Hide();
		value:SetScript("OnClick", nil);
		value.data=nil;
		value:UnlockHighlight();
		value.selected = false;
	end

	mod.totalItems=0;

	mod.mainFrame.editBox:SetScript("OnEnterPressed", nil);
end

function mod.OnTextChanged(self,char)

	local text = self:GetText();

	if not (self.lastText == text) then

		mod:ClearAllItems();

		self.lastText = text;

		if(text) then

			items = mod.search:FindAll(text);

			local key,value;

			for key,value in pairs(items) do

				mod:AddItem(value);

			end

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

	mod.mainFrame.editBox:SetFontObject(ChatFontNormal);
	mod.mainFrame.editBox:SetHeight(14);

	mod.mainFrame.editBox:SetSolidColor(0.0, 0.0, 0.0, 0.5);
	mod.mainFrame.editBox:CreateBorder(-2,0,0,0);
	mod.mainFrame.editBox:SetTextColor(1,1,1);

	mod.mainFrame.editBox:SetText("");
	mod.mainFrame.editBox:SetScript("OnEscapePressed", mod.OnEscapePressed);
	mod.mainFrame.editBox:SetScript("OnTextChanged", mod.OnTextChanged);
	mod.mainFrame.editBox:SetScript("OnKeyDown", mod.OnKeyDown);
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

end

--initialize the module
function mod:OnInitialize()

	--load profile settings
	mod:LoadProfileSettings();

	--create the UI
	mod:CreateUI();

	mod.search = Engine.AddOn:GetModule("search");

end

--enable module
function mod:OnEnable()

end

--show/hide the main window
function mod:Show(value)

	if(value) then
		if not mod.mainFrame:IsShown() then

			mod.search:Refresh();
			mod:SetScroll(0);
			mod.mainFrame.editBox:SetText("");
			mod:ClearAllItems();

			mod.mainFrame:Show();

		end
	else
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


