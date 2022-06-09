-- // Service
local RunService = game:GetService("RunService")

-- // Variables
local Remotes = script.Parent.Parent.Remotes
local IsServer = RunService:IsServer()
local Net = {}

-- // Functions
function Net.listenToRemote(remoteName, callback)
	local remoteObject = Remotes:WaitForChild(remoteName)
	local eventName

	if remoteObject:IsA("RemoteEvent") then
		eventName = (IsServer and "OnServerEvent") or "OnClientEvent"

		return remoteObject[eventName]:Connect(callback)
	else
		eventName = (IsServer and "OnServerInvoke") or "OnClientInvoke"

		remoteObject[eventName] = callback
	end
end

function Net.pushRemote(remoteName, ...)
	local remoteObject = Remotes:WaitForChild(remoteName)
	local eventName

	if remoteObject:IsA("RemoteEvent") then
		eventName = (IsServer and "FireClient") or "FireServer"

		if IsServer and type(select(1, ...)) ~= "userdata" then
			eventName = "FireAllClients"
		end

		return remoteObject[eventName](remoteObject, ...)
	else
		eventName = (IsServer and "InvokeClient") or "InvokeServer"

		return remoteObject[eventName](remoteObject, ...)
	end
end

-- // Module
return Net