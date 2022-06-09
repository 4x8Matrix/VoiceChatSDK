-- // Services
local RunService = game:GetService("RunService")
local Children = {
	"Context",
	"Enums",
	"Modules",
	"Vendor",
	"Remotes"
}

for _, childName in ipairs(Children) do
	script:WaitForChild(childName)
end

if RunService:IsServer() then
	return require(script.Context.Server)
else
	return require(script.Context.Client)
end