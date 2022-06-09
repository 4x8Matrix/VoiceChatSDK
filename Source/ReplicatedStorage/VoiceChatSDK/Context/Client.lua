-- // Services
local RunService = game:GetService("RunService")
local PlayersService = game:GetService("Players")
local VoiceChatInternal = game:GetService("VoiceChatInternal")

-- // Vendor Modules
local Signal = require(script.Parent.Parent.Vendor.Signal)
local Janitor = require(script.Parent.Parent.Vendor.Janitor)

-- // Local Modules
local Client = require(script.Parent.Parent.Modules.Client)
local Net = require(script.Parent.Parent.Modules.Net)

-- // Variables
local LocalPlayer = PlayersService.LocalPlayer
local VoiceChatSDK = {}

VoiceChatSDK.enum = {}

-- // Events
VoiceChatSDK.onPlayerMuted = Signal.new()
VoiceChatSDK.onPlayerUnmuted = Signal.new()
VoiceChatSDK.onPlayerVolumeChanged = Signal.new()

VoiceChatSDK.onVoiceClientAdded = Signal.new()
VoiceChatSDK.onVoiceClientRemoved = Signal.new()
VoiceChatSDK.onVoiceChatClientsUpdated = Signal.new()

-- // Public Functions
function VoiceChatSDK.playerHasVoiceChat(player)
	local _, result = xpcall(function()
		return VoiceChatInternal:IsVoiceEnabledForUserIdAsync(player.UserId)
	end, function()
		result = false
	end)

	return result
end

function VoiceChatSDK.setVoiceChatChannel(channel)
	VoiceChatSDK._channel = VoiceChatSDK.enum.Channel[channel]
end

function VoiceChatSDK.setPlayerEmitter(player, emitter)
	local client = VoiceChatSDK.getClientAsync(player)

	client:setTarget(emitter)
end

function VoiceChatSDK.getClientAsync(player)
	while not VoiceChatSDK._clients[player] do
		task.wait()
	end

	return VoiceChatSDK._clients[player]
end

function VoiceChatSDK.isPlayerMuted(player)
	return table.find(VoiceChatSDK._muted, player) ~= nil
end

function VoiceChatSDK.mutePlayer(player)
	local voiceChatClient = VoiceChatSDK.getClientAsync(player)

	voiceChatClient:mute()
	VoiceChatSDK.onPlayerMuted:Fire(player, true)
	table.insert(VoiceChatSDK._muted, player)
end

function VoiceChatSDK.unmutePlayer(player)
	local voiceChatClient = VoiceChatSDK.getClientAsync(player)
	local index = table.find(VoiceChatSDK._muted, player)

	voiceChatClient:unmute()
	VoiceChatSDK.onPlayerUnmuted:Fire(player, true)

	if index then
		table.remove(VoiceChatSDK._muted, index)
	end
end

function VoiceChatSDK.setPlayerVolume(player, value)
	local voiceChatClient = VoiceChatSDK.getClientAsync(player)

	voiceChatClient:setVolume(value or 0)
	VoiceChatSDK.onPlayerVolumeChanged:Fire(player, value)
end

function VoiceChatSDK.getActiveVoiceChatPlayers()
	return VoiceChatSDK._voiceChatClients
end

-- // Private Functions
function VoiceChatSDK._onPlayerRemoving(player)
	while not VoiceChatSDK._clients[player] do
		task.wait()
	end
	
	VoiceChatSDK._clients[player]:destroyClient()
end

function VoiceChatSDK._onPlayerAdded(player)
	if player ~= LocalPlayer then
		VoiceChatSDK._clients[player] = Client.new(VoiceChatSDK, player)
	end
end

function VoiceChatSDK.deinit()
	VoiceChatSDK._janitor:Clean()
end

function VoiceChatSDK.init()
	if not VoiceChatSDK.playerHasVoiceChat(LocalPlayer) then
		Net.pushRemote("SetVoiceChatState")
	end

	--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

	for _, enumModule in ipairs(script.Parent.Parent.Enums:GetChildren()) do
		VoiceChatSDK.enum[enumModule.Name] = require(enumModule)
	end

	--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

	VoiceChatSDK._janitor = Janitor.new()
	VoiceChatSDK._clients = {}
	VoiceChatSDK._channel = "Center"

	--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

	VoiceChatSDK._janitor:Add(PlayersService.PlayerAdded:Connect(function(player)
		VoiceChatSDK._onPlayerAdded(player)
	end))

	VoiceChatSDK._janitor:Add(PlayersService.PlayerRemoving:Connect(function(player)
		VoiceChatSDK._onPlayerRemoving(player)
	end))

	VoiceChatSDK._janitor:Add(Net.listenToRemote("ReplicateMuteRequest", function(_, player)
		VoiceChatSDK.onPlayerUnmuted:Fire(player)

		if player ~= LocalPlayer then
			VoiceChatSDK.unmutePlayer(player)
		end
	end))

	VoiceChatSDK._janitor:Add(Net.listenToRemote("ReplicateUnmuteRequest", function(_, player)
		VoiceChatSDK.onPlayerMuted:Fire(player)

		if player ~= LocalPlayer then
			VoiceChatSDK.mutePlayer(player)
		end
	end))

	VoiceChatSDK._janitor:Add(Net.listenToRemote("SetVoiceChatClients", function(clients)
		local oldClients = VoiceChatSDK._voiceChatClients

		while not oldClients do
			oldClients = VoiceChatSDK._voiceChatClients

			task.wait()
		end

		VoiceChatSDK._voiceChatClients = clients
		VoiceChatSDK.onVoiceChatClientsUpdated:Fire(clients)

		for _, client in ipairs(clients) do
			if not table.find(oldClients, client) then
				VoiceChatSDK.onVoiceClientAdded:Fire(client)
			end
		end

		for _, client in ipairs(oldClients) do
			if not table.find(clients, client) then
				VoiceChatSDK.onVoiceClientRemoved:Fire(client)
			end
		end
	end))

	VoiceChatSDK._janitor:Add(RunService.RenderStepped:Connect(function(...)
		for _, voiceChatClient in pairs(VoiceChatSDK._clients) do
			voiceChatClient:update(...)
		end
	end))

	--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

	for _, player in ipairs(PlayersService:GetPlayers()) do
		VoiceChatSDK._onPlayerAdded(player)
	end

	--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

	VoiceChatSDK._muted = Net.pushRemote("SyncMutedPlayers")
	VoiceChatSDK._voiceChatClients = Net.pushRemote("SyncVoiceChatClients")

	--- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---

	return VoiceChatSDK
end

-- // Module
return VoiceChatSDK.init()