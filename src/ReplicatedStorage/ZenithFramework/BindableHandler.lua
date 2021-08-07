-- Handles creation and referencing of BindableEvents and BindableFunctions
-- Author: TheM0rt0nator

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local RunService = game:GetService("RunService")

local Bindables = {}
Bindables.__index = Bindables

local BindablesFolder

if RunService:IsServer() then
    BindablesFolder = Instance.new("Folder")
    BindablesFolder.Name = "BindablesFolder"
    BindablesFolder.Parent = ServerStorage
elseif RunService:IsClient() then
    BindablesFolder = Instance.new("Folder")
    BindablesFolder.Name = "BindablesFolder"
    BindablesFolder.Parent = ReplicatedStorage
end

function Bindables.new()
    return setmetatable({}, Bindables)
end

-- Creates a new bindable called remoteName if it doesn't exist
-- Returns the bindable for use if it does exist
function Bindables:GetBindable(bindableName, bindableType)
    assert(typeof(bindableName) == "string" and (bindableType == "BindableEvent" or bindableType == "BindableFunction"))

    if BindablesFolder:FindFirstChild(bindableName) then 
        return BindablesFolder:FindFirstChild(bindableName)
    else
        local newBindable = Instance.new(bindableType, BindablesFolder)
        newBindable.Name = bindableName

        return newBindable
    end
end

-- When the module is called like a function, either creates the bindable or returns the already created bindable
function Bindables:__call(bindableName, bindableType)
    return self:GetBindable(bindableName, bindableType)
end

return Bindables