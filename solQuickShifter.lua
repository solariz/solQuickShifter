BINDING_HEADER_solQuickShifter = "solQuickShifter"
_G["BINDING_NAME_CLICK solQuickShifter:LeftButton"] = "Show Shift Selection (hold key)"

VER = "2.02"

-- ////// MAIN
L = {}
if (GetLocale() == 'deDE') then
	L["SQS_1_BEAR"] = "Bärengestalt"
	L["SQS_1_DIREBEAR"] = "Terrorbärengestalt"
	L["SQS_2_AQUATIC"] = "Wassergestalt"
	L["SQS_3_CAT"] = "Katzengestalt"
	L["SQS_4_TRAVEL"] = "Reisegestalt"
	L["SQS_5_MOONKIN"] = "Moonkingestalt"
else
	L["SQS_1_BEAR"] = "Bear Form"
	L["SQS_1_DIREBEAR"] = "Dire Bear Form"
	L["SQS_2_AQUATIC"] = "Aquatic Form"
	L["SQS_3_CAT"] = "Cat Form"
	L["SQS_4_TRAVEL"] = "Travel Form"
	L["SQS_5_MOONKIN"] = "Moonkin Form"
end


-- Creating the Fram where our Buttons live in
local 	solQuickShifterFrame=CreateFrame("Frame","solQuickShifterFrame",UIParent)
		solQuickShifterFrame:SetClampedToScreen( true )
		solQuickShifterFrame:SetMovable(true)
		solQuickShifterFrame:EnableMouse(true)
		solQuickShifterFrame:SetSize(100,100)
		solQuickShifterFrame:SetScale(1.0)
		solQuickShifterFrame:Hide()

-- register events
	solQuickShifterFrame:RegisterEvent("PORTRAITS_UPDATED")
	solQuickShifterFrame:SetScript("OnEvent", function(self, event, ...)
 		SQS_UpdateButtonDisplay()
	end)


local 	t=solQuickShifterFrame:CreateTexture(nil,"ARTWORK")
		t:SetAllPoints(solQuickShifterFrame)


SQS_CreateButton(1); -- Bear/Dire Bear Form
SQS_CreateButton(2); -- Aquatic Form
SQS_CreateButton(3); -- Cat Form
SQS_CreateButton(4); -- Travel Form
SQS_CreateButton(5); -- Moonkin Form
SQS_CreateButton(9); -- cancel form
SQS_UpdateButtonDisplay()

-- activation when pressing hotkey
local	toggleframe = CreateFrame("Button","solQuickShifter",UIParent,"SecureHandlerClickTemplate")
		toggleframe:RegisterEvent("PLAYER_TARGET_CHANGED")
		toggleframe:RegisterForClicks("AnyUp", "AnyDown")
		toggleframe:SetFrameRef("ParentFrame",solQuickShifterFrame)
		toggleframe:SetAttribute("_onclick",[[
			ParentFrame = self:GetFrameRef("ParentFrame")
			if down then
				ParentFrame:SetPoint("CENTER","$cursor")
				ParentFrame:Show()
			else
				ParentFrame:Hide()
			end
		]])


-- ok, we're done
DEFAULT_CHAT_FRAME:AddMessage("|cffaad372".."sol".."|cfffff468".."QuickShifter".."|cffffffff: ".."loaded "..VER);
