-- // Services
local PlayersService = game:GetService("Players")

-- // Vendor Modules
local Signal = require(script.Parent.Parent.Vendor.Signal)
local Janitor = require(script.Parent.Parent.Vendor.Janitor)

-- // Local Modules
local Net = require(script.Parent.Parent.Modules.Net)

-- // Constants
local EMITTER_PART_VISIBLE = true

local EMITTER_PART_NAME = "VoiceChatSoundEmitter"
local EMITTER_PART_SIZE = Vector3.new()

-- // Variables
local VoiceChatSDK = {}
VoiceChatSDK._janitor = Janitor.new()
VoiceChatSDK._voiceChatClients = {}
VoiceChatSDK._janitors = {}
VoiceChatSDK._muted = {}

-- // Events
VoiceChatSDK.onPlayerMuted = Signal.new()
VoiceChatSDK.onPlayerUnmuted = Signal.new()

VoiceChatSDK.onVoiceChatClientsUpdated = Signal.new()

-- // Public Function
function VoiceChatSDK.mutePlayerAsync(player)
	table.insert(VoiceChatSDK._muted, player)
	Net.pushRemote("ReplicateMuteRequest", -1, player)
end

function VoiceChatSDK.unmutePlayerAsync(player)
	Net.pushRemote("ReplicateUnmuteRequest", -1, player)

	local index = table.find(VoiceChatSDK._muted, player)

	if index then
		return table.remove(VoiceChatSDK._muted, index)
	end
end

function VoiceChatSDK.getActiveVoiceChatPlayers()
	return VoiceChatSDK._voiceChatClients
end

function VoiceChatSDK.isVoiceEnabledForPlayer(player)
	return table.find(VoiceChatSDK._voiceChatClients, player) ~= nil
end

-- // Private Functions
function VoiceChatSDK._onPlayerCharacterAdded(_, character)
	local emitter = Instance.new("Part")
	emitter.Name = EMITTER_PART_NAME
	emitter.Size = EMITTER_PART_SIZE
	emitter.Anchored = true
	emitter.CanCollide = false
	emitter.CanTouch = false
	emitter.CanQuery = false
	emitter:ClearAllChildren()

	if EMITTER_PART_VISIBLE then
		emitter.BrickColor = BrickColor.Red()
		emitter.Transparency = 0.5
	end
	
	emitter.Parent = character
	return emitter
end

function VoiceChatSDK._onPlayerAdded(player)
	VoiceChatSDK._janitors[player] = Janitor.new()
	VoiceChatSDK._janitors[player]:Add(player.CharacterAdded:Connect(function(character)
		VoiceChatSDK._onPlayerCharacterAdded(player, character)
	end))

	if player.Character then
		VoiceChatSDK._onPlayerCharacterAdded(player, player.Character)
	end
end

function VoiceChatSDK._onPlayerRemoving(player)
	while not VoiceChatSDK._janitors[player] do
		task.wait()
	end

	VoiceChatSDK._janitors[player]:Clean()
	VoiceChatSDK._janitors[player] = nil
end

function VoiceChatSDK.deinit()
	VoiceChatSDK._janitor:Clean()
end

function VoiceChatSDK.init()
	Net.listenToRemote("SyncMutedPlayers", function()
		return VoiceChatSDK._muted
	end)

	Net.listenToRemote("SyncVoiceChatClients", function()
		return VoiceChatSDK._voiceChatClients
	end)

	VoiceChatSDK._janitor:Add(Net.listenToRemote("SetVoiceChatState", function(player)
		local index = table.find(VoiceChatSDK._voiceChatClients, player)

		if index then
			table.remove(VoiceChatSDK._voiceChatClients, index)
		end

		VoiceChatSDK.onVoiceChatClientsUpdated:Fire(VoiceChatSDK._voiceChatClients)
		Net.pushRemote("SetVoiceChatClients", VoiceChatSDK._voiceChatClients)
	end))

	VoiceChatSDK._janitor:Add(PlayersService.PlayerAdded:Connect(function(player)
		table.insert(VoiceChatSDK._voiceChatClients, player)
		
		VoiceChatSDK._onPlayerAdded(player)
		VoiceChatSDK.onVoiceChatClientsUpdated:Fire(VoiceChatSDK._voiceChatClients)
		Net.pushRemote("SetVoiceChatClients", VoiceChatSDK._voiceChatClients)
	end))

	VoiceChatSDK._janitor:Add(PlayersService.PlayerRemoving:Connect(function(player)
		VoiceChatSDK._onPlayerRemoving(player)
	end))

	VoiceChatSDK._janitor:Add(function()
		Net.listenToRemote("SyncMutedPlayers", nil)
		Net.listenToRemote("SyncVoiceChatClients", nil)
	end)

	return VoiceChatSDK
end

-- // Module
return VoiceChatSDK.init()