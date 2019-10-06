local addon, private = ...

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
	TextOptions:SetJustifyH("left")
	TextOptions:SetText("I keep this Addon minimalistic, so the options here a rather tiny compared to some other addons.\nActually I currently add just some toggle for experimental features.\nFor mor Information please read and comment on the Curseforge project website or github.\n\n|cffa330c9- And so fate shall provide you with epic drops -\n\n|cffaad372Thanks\nAuthor: Wildnis  (druid, EU-Lakeshire, Horde)\n");

	-- Display On/Off OOM
	local DisplayLock = makeCheckbox(
		"OOM Display",									-- label
		"Shapeshift button will be gray if out of Mana. (experimental)",	-- description
		function(self, value)
			SQS.OOM = value
		end);	-- onClick
	DisplayLock:SetChecked(SQS.OOM);
	DisplayLock:SetPoint("TOPLEFT", TextOptions, "BOTTOMLEFT", 0, -12);

	-- Display On/Off Powershift
	local DisplayLock2 = makeCheckbox(
		"Powershift",									-- label
		"If Enabled you can Powershift by selecting the same form you are already in. Game than will shift you back to caster and in same form again. If Disabled the button will ignore the click if you are already in this form. (experimental, reload required to activate)",	-- description
		function(self, value)
			SQS.PWRSHIFT = value
		end);	-- onClick
	DisplayLock2:SetChecked(SQS.PWRSHIFT);
	DisplayLock2:SetPoint("TOPLEFT", DisplayLock, "BOTTOMLEFT", 0, -12);


	-- Display On/Off GCD / Spell Check
	local DisplayLock3 = makeCheckbox(
		"Global Cooldown / Casting Warning",									-- label
		"If Enabled a Active Global Cooldown will be displayed on the Shift Buttons as Indicator that a shift may not be possible. It's just a visual reminder of a active Global Cooldown.",	-- description
		function(self, value)
			SQS.GCD = value
		end);	-- onClick
	DisplayLock3:SetChecked(SQS.GCD);
	DisplayLock3:SetPoint("TOPLEFT", DisplayLock2, "BOTTOMLEFT", 0, -12);

	-- Display Disable mounting options
	local DisplayLock4 = makeCheckbox(
		"Disable Mount Handling",									-- label
		"If this Disable Flag is checked this Addon will not offer any Mounting/Dismounting Options; If not checked Addon search for a mount and offer a button to mount.",	-- description
		function(self, value)
			SQS.disableMount = value
		end);	-- onClick
	DisplayLock4:SetChecked(SQS.disableMount);
	DisplayLock4:SetPoint("TOPLEFT", DisplayLock3, "BOTTOMLEFT", 0, -12);

	self:SetScript("OnShow", nil);
end);

-- end