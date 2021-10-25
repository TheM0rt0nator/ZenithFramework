-- Useful functions to do with the Players mouse

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService  = game:GetService("RunService")

local require = table.unpack(require(ReplicatedStorage.ZenithFramework))

local Raycast = require("Raycast")

local Mouse = {}

if RunService:IsClient() then
	function Mouse.findHitWithWhitelist(mouse, filterInstances, distance)
		local camera = workspace.CurrentCamera
		local unitRay = camera:ScreenPointToRay(mouse.X, mouse.Y, 0)
		local raycastResult = Raycast.new(filterInstances, "Whitelist", unitRay.Origin, unitRay.Direction, distance)
		return raycastResult.Instance
	end
end

return Mouse