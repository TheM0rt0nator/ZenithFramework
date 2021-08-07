-- Handles creation and referencing of RemoteEvents and RemoteFunctions
-- Author: TheM0rt0nator

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Remotes = {}
Remotes.__index = Remotes

local RemotesFolder

if RunService:IsServer() then
    RemotesFolder = Instance.new("Folder")
    RemotesFolder.Name = "Remotes"
    RemotesFolder.Parent = ReplicatedStorage
elseif RunService:IsClient() then
    RemotesFolder = ReplicatedStorage:WaitForChild("Remotes")
end

function Remotes.new()
    return setmetatable({}, Remotes)
end

-- If server, creates a new remote called remoteName if it doesn't exist
-- If client, returns the remote for use
function Remotes:GetRemote(remoteName, remoteType)
    assert(typeof(remoteName) == "string" and (remoteType == "RemoteEvent" or remoteType == "RemoteFunction"), "Invalid arguments while trying to get remote")

    if RunService:IsServer() then
        if RemotesFolder:FindFirstChild(remoteName) then 
            return RemotesFolder:FindFirstChild(remoteName)
        else
            local newRemote = Instance.new(remoteType, RemotesFolder)
            newRemote.Name = remoteName

            return newRemote
        end
    elseif RunService:IsClient() then
        if RemotesFolder:FindFirstChild(remoteName) then
            return RemotesFolder:FindFirstChild(remoteName)
        end

        warn(remoteName .. " of type " .. remoteType .. " was not found")
    end
end

-- When the module is called like a function, either creates the remote or returns the already created remote
function Remotes:__call(remoteName, remoteType)
    return self:GetRemote(remoteName, remoteType)
end

return Remotes