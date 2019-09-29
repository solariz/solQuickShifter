
local addon, private = ...
local version = GetAddOnMetadata(addon, "Version");

local Options = CreateFrame("Frame", "SQSOptions", InterfaceOptionsFramePanelContainer);
Options.name = addon;
InterfaceOptions_AddCategory(Options);

function private.ShowOptions()
	InterfaceOptionsFrame_OpenToCategory(Options);
end;

Options:Hide();
Options:SetScript("OnShow", function(self)

	local function makeCheckbox(label, description, onClick)
		local check = CreateFrame("CheckButton", "SQS_Checkbox_"..label, self, "InterfaceOptionsCheckButtonTemplate");
		check:SetScript("OnClick", function(self)
			-- 856 = igMainMenuOptionCheckBoxOn
			-- 857 = igMainMenuOptionCheckBoxOff
			local click = self:GetChecked() and 856 or 857
			PlaySound(click)
			onClick(self, self:GetChecked() and true or false)
		end);
		check.label = _G[check:GetName().."Text"];
		check.label:SetText(label);
		check.tooltipText = label;
		check.tooltipRequirement = description;
		return check;
	end;
	
	-- Title
	local TitleOptions = self:CreateFontString("$parentTitleOptions", "ARTWORK", "GameFontNormalLarge");
	TitleOptions:SetPoint("TOPLEFT", 16, -16);
	TitleOptions:SetText("|cffaad372"..addon.." |r");
	
	-- Text
	local TextOptions = self:CreateFontString("$parentTitleOptions", "ARTWORK", "GameFontNormalSmall");
	TextOptions:SetPoint("TOPLEFT", TitleOptions, "BOTTOMLEFT", 0, -12);
	TextOptions:SetText("I keep this Addon minimalistic, so the options here a rather tiny compared to some other addons.\n|rActually I currently add just some toggle for experimental features.\n|rFor mor Information please read and comment on the Curseforge project website or github.\n\n|r|r|cffa330c9- And so fate shall provide you with epic drops -\n\n|r|r|cffaad372Thanks\nAuthor: Wildnis  (druid, EU-Lakeshire, Horde)\n|r");

	-- Display On/Off
	local DisplayLock = makeCheckbox(
		"OOM Display",									-- label
		"Shapeshift button will be gray if out of Mana. (experimental)",	-- description
		function(self, value)
			SQS.OOM = not value
		end);	-- onClick
	DisplayLock:SetChecked(not SQS.OOM);
	DisplayLock:SetPoint("TOPLEFT", TextOptions, "BOTTOMLEFT", 0, -12);
	

	self:SetScript("OnShow", nil);
end);

-- end