BINDING_HEADER_solQuickShifter = "solQuickShifter"
_G["BINDING_NAME_CLICK solQuickShifter:LeftButton"] = "Show Shift Selection (hold key)"

-- ////// MAIN

-- Creating the Fram where our Buttons live in
local 	solQuickShifterFrame=CreateFrame("Frame","solQuickShifterFrame",UIParent)
		solQuickShifterFrame:SetClampedToScreen( true )
		solQuickShifterFrame:SetMovable(true)
		solQuickShifterFrame:EnableMouse(true)
		solQuickShifterFrame:SetSize(100,100)
		solQuickShifterFrame:SetScale(1.0)
		solQuickShifterFrame:Hide()

local 	t=solQuickShifterFrame:CreateTexture(nil,"ARTWORK")
		t:SetAllPoints(solQuickShifterFrame)


-- for i=1, 5 do
-- 	icon, name, active, castable, spellId = GetShapeshiftFormInfo(i);
-- 		if active then
-- 			aString = "Y"
-- 		else
-- 			aString = "N"
-- 		end
-- 		DEFAULT_CHAT_FRAME:AddMessage("SQS: i:"..i.." active:"..aString.." name:"..tostring(name));
-- end


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
DEFAULT_CHAT_FRAME:AddMessage("|cffaad372".."sol".."|cfffff468".."QuckShifter".."|cffffffff: ".."loaded");
