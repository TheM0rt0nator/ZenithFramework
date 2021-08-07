-- Zenith Framework
-- Author: TheM0rt0nator

local RunService = game:GetService("RunService")

local ModuleScriptLoader = require(script.ModuleScriptLoader)
local RemoteHandler = require(script.RemoteHandler)
local BindableHandler = require(script.BindableHandler)

local Framework = {}

if RunService:IsServer() then
    local newLoader = ModuleScriptLoader.new("Server")
    local remoteHandler = RemoteHandler.new()
    local bindableHandler = BindableHandler.new()

    return {
        require = newLoader, 
        getRemote = remoteHandler, 
        getBindable = bindableHandler
    }
elseif RunService:IsClient() then
    local newLoader = ModuleScriptLoader.new("Client")
    local remoteHandler = RemoteHandler.new()
    local bindableHandler = BindableHandler.new()

    return {
        require = newLoader, 
        getRemote = remoteHandler, 
        getBindable = bindableHandler
    }
end

return Framework