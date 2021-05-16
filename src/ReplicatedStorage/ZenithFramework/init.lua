-- Zenith Framework
-- Author: TheM0rt0nator

local RunService = game:GetService("RunService")

local ModuleScriptLoader = require(script.ModuleScriptLoader)

local Framework = {}

if RunService:IsServer() then
    local newLoader = ModuleScriptLoader.new("Server")

    return newLoader
elseif RunService:IsClient() then
    local newLoader = ModuleScriptLoader.new("Client")

    return newLoader
end

return Framework