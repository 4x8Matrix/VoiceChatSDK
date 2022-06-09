-- // Services
local RunService = game:GetService("RunService")

-- // Constants
local GAME_TESTING_PLACE_ID = 3640039652

-- // Variables
local IsStudio = RunService:IsStudio()
local IsTestingPlace = game.GameId == GAME_TESTING_PLACE_ID

-- // Functions
local function unpackFolderInto(folder, parent)
	local runtimeScripts = {}
	
	for _, object in ipairs(folder:GetChildren()) do
		if object:IsA("Script") or object:IsA("LocalScript") then
			object.Disabled = true

			table.insert(runtimeScripts, object)
		end

		object.Parent = parent
	end

	if #runtimeScripts > 0 then
		for _, container in ipairs(runtimeScripts) do
			container.Disabled = false
		end
	end
end

if IsStudio and not IsTestingPlace then
	return
end

for _, object in ipairs(script.Parent:GetChildren()) do
	if object == script then
		continue
	end

	unpackFolderInto(
		object,
		game:GetService(object.Name)
	)
end