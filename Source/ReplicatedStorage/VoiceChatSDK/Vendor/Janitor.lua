--[[
    Janitor.lua
    @Author: AsynchronousMatrix
    @Licence: ...
]]--

-- // Variables
local JanitorModule = { }
local JanitorObject = { Name = "Janitor" }

local _type = typeof or type

JanitorObject.__index = JanitorObject

-- // JanitorObject Functions
function JanitorObject:Add(DynamicObject)
    table.insert(self._Trash, DynamicObject)
end

function JanitorObject:Remove(DynamicObject)
    for Index, LocalDynamicObject in ipairs(self._Trash) do
        if LocalDynamicObject == DynamicObject then
            return table.remove(self._Trash, Index)
        end
    end
end

function JanitorObject:Deconstructor(Type, Callback)
    self._Deconstructors[Type] = Callback
end

function JanitorObject:Clean()
    for _, DynamicTrashObject in ipairs(self._Trash) do
        local DynamicTrashType = _type(DynamicTrashObject)

        if self._Deconstructors[DynamicTrashType] then
            self._Deconstructors[DynamicTrashType](DynamicTrashObject)
        end
    end
end

-- // JanitorModule Functions
function JanitorModule.new()
	local self = setmetatable({ 
        _Deconstructors = { },
        _Trash = { }
    }, JanitorObject)

    self:Deconstructor("function", function(Object)
        return Object() 
    end)

    self:Deconstructor("RBXScriptConnection", function(Object)
        return Object.Connected and Object:Disconnect()
    end)

	return self
end

-- // Module
return JanitorModule