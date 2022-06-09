-- // Services

-- // Modules
local Janitor = require(script.Parent.Parent.Vendor.Janitor)

-- // Constants
local MAX_VOICE_EMITTER_DISTANCE = 80
local MAX_VOLUME_INT = 10

local EMITTER_WAIT_TIME = math.huge
local EMITTER_PART_NAME = "VoiceChatSoundEmitter"
local EMITTER_PART_VOID = CFrame.new(
	0, 
	10000000, 
	0
)


-- // Variables
local VoiceChatClient = {}
local VoiceChatChannelCFrames = {
	["Left"] = Vector3.new(-1, 0, 0),
	["Right"] = Vector3.new(1, 0, 0),
	["Center"] = Vector3.new(0, 0, 1)
}

VoiceChatClient.__index = VoiceChatClient
VoiceChatClient.__tostring = function(self)
	return string.format("VoiceChatClient [%s]", self.player.Name)
end

-- // Functions
function VoiceChatClient:mute()
	self.muted = true
end

function VoiceChatClient:unmute()
	self.muted = false
end

function VoiceChatClient:setTarget(target)
	self.target = target
end

function VoiceChatClient:setVolume(volume)
	self.volume = math.clamp(volume, 0, MAX_VOLUME_INT)
end

function VoiceChatClient:destroyClient()
	self.emitter:Destroy()
	self.janitor:Clean()
end

function VoiceChatClient:update()
	if not self.emitter then
		return
	end

	if self.muted then
		self.emitter.CFrame = EMITTER_PART_VOID
	elseif self.target then
		self.emitter.CFrame = self.target.CFrame
	else
		local targetDirectionVector = VoiceChatChannelCFrames[self.SDK._channel]
		local targetDistance = math.clamp(MAX_VOICE_EMITTER_DISTANCE - ((self.volume / MAX_VOLUME_INT) * MAX_VOICE_EMITTER_DISTANCE), 1, MAX_VOICE_EMITTER_DISTANCE)
		local vectorOffset = Vector3.new(targetDistance, targetDistance, targetDistance) * targetDirectionVector

		self.emitter.CFrame = workspace.CurrentCamera.CFrame * CFrame.new(vectorOffset)
	end
end

function VoiceChatClient:_awaitEmitter()
	while not self.emitter do
		task.wait()
	end

	return self.emitter
end

function VoiceChatClient:_updateCharacterModel()
	self.componentsModel = Instance.new("Model")
	
	for _, object in ipairs(self.character:GetChildren()) do
		if object.Name == EMITTER_PART_NAME then
			continue
		end

		object.Parent = self.componentsModel
	end
	
	self.componentsModel.Name = "Components"
	self.componentsModel.Parent = self.character
end

function VoiceChatClient:_createEmitter()
	self.emitter = self.character:WaitForChild(
		EMITTER_PART_NAME, 
		EMITTER_WAIT_TIME
	)

	self.character.PrimaryPart = self.emitter
end

function VoiceChatClient:_onCharacterAdded(character)
	character:WaitForChild("HumanoidRootPart")
	character:WaitForChild("Humanoid")

	self.character = character
	self.rootPart = character.HumanoidRootPart
	self.humanoid = character.Humanoid
	
	self:_createEmitter()
	self:_updateCharacterModel()
end

function VoiceChatClient.new(voiceChatSDK, player)
	local self = setmetatable({}, VoiceChatClient)

	self.player = player
	self.janitor = Janitor.new()
	self.volume = 10

	self.SDK = voiceChatSDK

	self.janitor:Add(player.CharacterAdded:Connect(function(character)
		self:_onCharacterAdded(character)

		self.onChildAddedConnection = character.ChildAdded:Connect(function(objectReference)
			if objectReference:IsA("Tool") or objectReference.Name == EMITTER_PART_NAME then
				return
			end

			task.wait()
			while not self.componentsModel do
				task.wait()
			end

			objectReference.Parent = self.componentsModel
		end)
	end))

	self.janitor:Add(player.CharacterRemoving:Connect(function()
		self.character = nil

		if self.onChildAddedConnection then
			self.onChildAddedConnection:Disconnect()
			self.onChildAddedConnection = nil
		end

		if self.emitter then
			self.emitter:Destroy()
		end
	end))

	if player.Character then
		task.spawn(self._onCharacterAdded, self, player.Character)
	end

	return self
end

-- // Module
return VoiceChatClient