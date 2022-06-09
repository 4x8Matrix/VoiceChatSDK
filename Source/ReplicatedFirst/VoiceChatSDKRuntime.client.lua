-- // Services
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Modules
local VoiceChatSDK = require(ReplicatedStorage:WaitForChild("VoiceChatSDK"))

-- // Constants
local RELOAD_SDK_KEYBIND_ENABLED = true
local RELOAD_SDK_KEYBIND = Enum.KeyCode.F5

local RELOAD_SDK_MOBILE_BUTTON = true
local RELOAD_SDK_MOBILE_BUTTON_ICON = ""
local RELOAD_SDK_MOBILE_BUTTON_TEXT = "Reload SDK"
local RELOAD_SDK_MOBILE_BUTTON_POSITION = UDim2.new(0, 0, 0, 0)

local RELOAD_ACTION_NAME = "VoiceChatSDK_RELOAD"

-- // Init
if RELOAD_SDK_KEYBIND_ENABLED then
	local function onReloadRequested(_, inputState)
		if inputState ~= Enum.UserInputState.Begin then
			return
		end

		VoiceChatSDK.deinit()
		VoiceChatSDK.init()

		warn("[VoiceChatSDK]: re-initialised VoiceChat SDK!")
	end

	ContextActionService:BindAction(
		RELOAD_ACTION_NAME,
		onReloadRequested, 
		RELOAD_SDK_MOBILE_BUTTON,
		RELOAD_SDK_KEYBIND
	)

	if RELOAD_SDK_MOBILE_BUTTON_ICON ~= "" then
		ContextActionService:SetImage(
			RELOAD_ACTION_NAME, 
			RELOAD_SDK_MOBILE_BUTTON_ICON
		)
	elseif RELOAD_SDK_MOBILE_BUTTON_TEXT ~= "" then
		ContextActionService:SetTitle(
			RELOAD_ACTION_NAME, 
			RELOAD_SDK_MOBILE_BUTTON_TEXT
		)
	end

	if RELOAD_SDK_MOBILE_BUTTON_POSITION ~= UDim2.new(0, 0, 0, 0) then
		ContextActionService:SetPosition(
			RELOAD_ACTION_NAME, 
			RELOAD_SDK_MOBILE_BUTTON_POSITION
		)
	end
end