-- ////// functions
-- this file contains only own functions

function SQS_UpdateButtonDisplay()
	-- called to update the buttons if skill is castable / available or not
	-- local forms = GetNumShapeshiftForms(); --nope, only give me amount not the real IDs
	local forms = 5
	for i=1, forms do
		texture = GetShapeshiftFormInfo(i);
		if( texture == nil ) then
			if i == 1 then SQS_BTN_1:Hide(); 
			elseif i == 2 then SQS_BTN_2:Hide(); 
			elseif i == 3 then SQS_BTN_3:Hide(); 
			elseif i == 4 then SQS_BTN_4:Hide(); 
			elseif i == 5 then SQS_BTN_5:Hide(); 
			end;
		else
			if i == 1 then 
				SQS_BTN_1:Show();
				SQS_BTN_1.Texture:SetDesaturated(SQS_CheckNoMana(i))
			elseif i == 2 then 
				SQS_BTN_2:Show();
				SQS_BTN_2.Texture:SetDesaturated(SQS_CheckNoMana(i));
			elseif i == 3 then 
				SQS_BTN_3:Show();
				SQS_BTN_3.Texture:SetDesaturated(SQS_CheckNoMana(i));
			elseif i == 4 then 
				SQS_BTN_4:Show(); 
				SQS_BTN_4.Texture:SetDesaturated(SQS_CheckNoMana(i));
			elseif i == 5 then 
				SQS_BTN_5:Show(); 
				SQS_BTN_5.Texture:SetDesaturated(SQS_CheckNoMana(i));
			end;
		end
	end
end

function SQS_CheckNoMana(FormNum)
	-- checking if the spell is actually castable atm
	-- we return true if NOT and false if. sounds weird
	-- but I use that for the desaturate function, see in calling 
	-- function SQS_UpdateButtonDisplay
	if not type(SQS) or SQS == nil then
		return false
	end
	
	if SQS.OOM ~= true then
		return false 
	end

	-- DEFAULT_CHAT_FRAME:AddMessage(addon.." oom check:"..type(SQS.OOM)..":"..tostring(SQS.OOM))
	local SpellName, usable, nomana;
	if FormNum == 1 then 
		-- exception here because we have bear and dire bear
		usable, nomana = IsUsableSpell(L["SQS_1_BEAR"]);
		if nomana == true then 
			return true
		end
		usable, nomana = IsUsableSpell(L["SQS_1_DIREBEAR"]);
		if nomana == true then 
			return true
		end
	end
		
	-- now the others
	if FormNum == 2 then SpellName = L["SQS_2_AQUATIC"]
	elseif FormNum == 3 then SpellName = L["SQS_3_CAT"]
	elseif FormNum == 4 then SpellName = L["SQS_4_TRAVEL"]
	elseif FormNum == 5 then SpellName = L["SQS_5_MOONKIN"]
	end

	-- check
	usable, nomana = IsUsableSpell(SpellName);
	if nomana == true then 
		return true
	end

	-- no break? we assume is usable
	return false
end

function SQS_CreateButton(FormNum)
	Button = CreateFrame("Button", "SQS_BTN_"..FormNum, solQuickShifterFrame, "SecureActionButtonTemplate");
	Button:SetWidth(32);
	Button:SetHeight(32);
	Button:SetID(FormNum);

	-- Position of the button based on the Form
	if FormNum == 1 then
		-- bear
		Button:SetPoint("RIGHT")
	elseif FormNum == 2 then
		-- aqua
		Button:SetPoint("BOTTOMRIGHT", -16, 1)
	elseif FormNum == 3 then
		-- cat
		Button:SetPoint("LEFT")
	elseif FormNum == 4 then
		-- Travel
		Button:SetPoint("TOP")
	elseif FormNum == 5 then
		-- moonkin
		Button:SetPoint("BOTTOMLEFT", 16, 1)
	elseif FormNum == 9 then
		-- cancel form
		Button:SetPoint("CENTER")
	end
	Button.Texture = Button:CreateTexture(Button:GetName().."NormalTexture", "ARTWORK");
	Button.Texture:SetTexture(SQS_GetDefaultIcon(FormNum));
	Button.Texture:SetAllPoints();
	Button:RegisterForClicks("LeftButtonUp","RightButtonUp");
	Button:SetScript("OnEnter", function(self, ...)
		self.Texture:ClearAllPoints();
		self.Texture:SetTexture(SQS_GetHoverIcon(FormNum));
		self.Texture:SetPoint("TOPLEFT", -5, 5);
		self.Texture:SetPoint("BOTTOMRIGHT", 5, -5);
	end);
	Button:SetScript("OnLeave", function(self, ...)
		self.Texture:SetAllPoints();
		self.Texture:SetTexture(SQS_GetDefaultIcon(FormNum));
	end);
	-- using macro workaround, thanks bliz classic != classic, old function CastShapeshiftForm() is forbidden now :(
	-- this is specially shitty because all the stance/form names are translated to the client language
	-- so you cant just use a /cast cat form. Each language this "cat form" is different. In German it would be:
	-- /wirken Katzengestalt; luckily you can use /use and only need to translate the form name :(
	Button:SetAttribute("type","macro")
	Button:SetAttribute("macrotext",SQS_GetMacro(FormNum))
end


function SQS_GetHoverIcon(FormNum)
	-- retun a icon for each form button hover
	if FormNum == 1 then
		return "interface\\icons\\ability_hunter_pet_bear"
	elseif FormNum == 2 then
		return "interface\\icons\\spell_shadow_demonbreath"
	elseif FormNum == 3 then
		return "interface\\icons\\ability_druid_rake"
	elseif FormNum == 4 then
		return "interface\\icons\\inv_misc_head_tiger_01"
	elseif FormNum == 5 then
		return "interface\\icons\\inv_misc_monstertail_01"
	elseif FormNum == 9 then
		return "interface\\icons\\Spell_nature_wispsplode"
	end
end

function SQS_GetDefaultIcon(FormNum)
	-- retun a icon for each form button hover
	if FormNum == 1 then
		return "interface\\icons\\ability_racial_bearform"
	elseif FormNum == 2 then
		return "interface\\icons\\ability_druid_aquaticform"
	elseif FormNum == 3 then
		return "interface\\icons\\ability_druid_catform"
	elseif FormNum == 4 then
		return "interface\\icons\\ability_druid_travelform"
	elseif FormNum == 5 then
		return "interface\\icons\\spell_nature_forceofnature"
	elseif FormNum == 9 then
		return "interface\\icons\\spell_frost_wisp"
	end
end

function SQS_GetMacro(FormNum)
	-- retun the Macro to cast for each form
	
	local PowerShiftMacro = ""
	if SQS.PWRSHIFT ~= true then
		PowerShiftMacro = " [noform:"..FormNum.."]"
	end

	if FormNum == 1 then
		return "/dismount [mounted]\n/cancelform"..PowerShiftMacro.."\n/use [noform:"..FormNum.."] !"..L["SQS_1_DIREBEAR"].."\n/use [noform:"..FormNum.."]"..L["SQS_1_BEAR"]
	elseif FormNum == 2 then
		return "/dismount [mounted]\n/cancelform"..PowerShiftMacro.."\n/use [noform:"..FormNum..",swimming] !"..L["SQS_2_AQUATIC"]
	elseif FormNum == 3 then
		return "/dismount [mounted]\n/cancelform"..PowerShiftMacro.."\n/use [noform:"..FormNum.."] !"..L["SQS_3_CAT"]
	elseif FormNum == 4 then
		return "/dismount [mounted]\n/cancelform"..PowerShiftMacro.."\n/use [noform:"..FormNum.."] !"..L["SQS_4_TRAVEL"]
	elseif FormNum == 5 then
		return "/dismount [mounted]\n/cancelform"..PowerShiftMacro.."\n/use [noform:"..FormNum.."] !"..L["SQS_5_MOONKIN"]
	else
		return "/cancelform"
	end
end

 