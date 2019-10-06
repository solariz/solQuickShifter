BINDING_HEADER_solQuickShifter = "solQuickShifter"
_G["BINDING_NAME_CLICK solQuickShifter:LeftButton"] = "Show Shift Selection (hold key)"

VER = "2.05"
addon = "|cffaad372".."sol".."|cfffff468".."QuickShifter".."|cffffffff v"..VER;
SQS_DEBUG = false -- set to true to get debug infos, careful - spams your chat.
SQS_MOUNT = {}

-- ////// MAIN
L = {}
SQS_LOADED = false;
if (GetLocale() == 'deDE') then
	L["SQS_1_BEAR"] = "Bärengestalt"
	L["SQS_1_DIREBEAR"] = "Terrorbärengestalt"
	L["SQS_2_AQUATIC"] = "Wassergestalt"
	L["SQS_3_CAT"] = "Katzengestalt"
	L["SQS_4_TRAVEL"] = "Reisegestalt"
	L["SQS_5_MOONKIN"] = "Moonkingestalt"
	L["SQS_MOUNT_KODO_1"] = "Grauer Kodo"
	L["SQS_MOUNT_KODO_2"] = "Brauner Kodo"
	L["SQS_MOUNT_KODO_3"] = "weißer Kodo"
	L["SQS_MOUNT_KODO_4"] = "goldener Kodo"
	L["SQS_MOUNT_REINS"] = "Zügel des"
	L["SQS_MOUNT_HORN"] = "Horn des"
	L["SQS_MOUNT_WHISTLE"] = "Pfeife des"
else
	L["SQS_1_BEAR"] = "Bear Form"
	L["SQS_1_DIREBEAR"] = "Dire Bear Form"
	L["SQS_2_AQUATIC"] = "Aquatic Form"
	L["SQS_3_CAT"] = "Cat Form"
	L["SQS_4_TRAVEL"] = "Travel Form"
	L["SQS_5_MOONKIN"] = "Moonkin Form"
	L["SQS_MOUNT_KODO_1"] = "Teal Kodo"
	L["SQS_MOUNT_KODO_2"] = "Brown Kodo"
	L["SQS_MOUNT_KODO_3"] = "White Kodo"
	L["SQS_MOUNT_KODO_4"] = "Golden Kodo"	
	L["SQS_MOUNT_REINS"] = "Reins of"
	L["SQS_MOUNT_HORN"] = "Horn of"
	L["SQS_MOUNT_WHISTLE"] = "Whistle of"
end


-- Creating the Fram where our Buttons live in
     	solQuickShifterFrame=CreateFrame("Frame","solQuickShifterFrame",UIParent)
		solQuickShifterFrame:SetClampedToScreen( true )
		solQuickShifterFrame:SetMovable(true)
		solQuickShifterFrame:EnableMouse(true)
		solQuickShifterFrame:SetSize(100,100)
		solQuickShifterFrame:SetScale(1.0)
		solQuickShifterFrame:Hide()
		-- Warning Global Cooldown / Casting
		solQuickShifterFrameGCD = solQuickShifterFrame:CreateFontString("$parentTitleOptions", "ARTWORK", "GameFontNormalSmall");
		solQuickShifterFrameGCD:SetPoint("TOPLEFT", solQuickShifterFrame, "BOTTOMLEFT", -20, -2);
		solQuickShifterFrameGCD:SetText("* Casting / Global Cooldown *");
		solQuickShifterFrameGCD:Hide()

-- register events
	solQuickShifterFrame:RegisterEvent("UPDATE_SHAPESHIFT_FORM")
	solQuickShifterFrame:RegisterEvent("UNIT_POWER_UPDATE")
	solQuickShifterFrame:RegisterEvent("ADDON_LOADED")
	solQuickShifterFrame:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
	solQuickShifterFrame:RegisterEvent("PLAYER_MOUNT_DISPLAY_CHANGED")
	solQuickShifterFrame:RegisterEvent("BAG_UPDATE")	

	solQuickShifterFrame:SetScript("OnEvent", function(self, event, arg1, ...)
		if event == "ADDON_LOADED" and arg1 == "solQuickShifter" then
			-- initialize storage
			--if SQS == nil then
			if not type(SQS) or SQS == nil then
				SQS = {}
				SQS.OOM = true
				SQS.GCD = true
				SQS.PWRSHIFT = false
				SQS.disableMount = false
				DEFAULT_CHAT_FRAME:AddMessage(addon.." Settings default set.")
				_G["SQS"] = SQS
			else
				DEFAULT_CHAT_FRAME:AddMessage(addon.." Settings loaded.")
			end
			SQS.VER = VER
			SQS_CreateButton(1); -- Bear/Dire Bear Form
			SQS_CreateButton(2); -- Aquatic Form
			SQS_CreateButton(3); -- Cat Form
			SQS_CreateButton(4); -- Travel Form
			SQS_CreateButton(5); -- Moonkin Form
			SQS_CreateButton(9); -- cancel form
			SQS_CreateButton(10); -- unmount
			SQS_LOADED = true;
		else
			if SQS_LOADED == true and type(SQS) then
				if event == "BAG_UPDATE" then
					-- this is for the mount Info, we're just resetting the Cache here
					SQS_MOUNT[3] = time()-3600
				else
					SQS_UpdateButtonDisplay()
				end
			end
		end
	end)

local 	t=solQuickShifterFrame:CreateTexture(nil,"ARTWORK")
		t:SetAllPoints(solQuickShifterFrame)



--SQS_UpdateButtonDisplay()

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


-- ok, we're doneq
SQS_debug("+++ DEBUG ENABLED +++");
