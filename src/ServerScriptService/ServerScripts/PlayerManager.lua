local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local loadModule, getDataStream = table.unpack(require(ReplicatedStorage.ZenithFramework))

local playerAddedEvent = getDataStream("PlayerAdded", "BindableEvent")
local playerRemovedEvent = getDataStream("PlayerRemoved", "BindableEvent")

local PlayerManager = {}

function PlayerManager.playerAdded(player)
	playerAddedEvent:Fire(player)
end

function PlayerManager.playerRemoved(player)
	playerRemovedEvent:Fire(player)
end

Players.PlayerAdded:Connect(PlayerManager.playerAdded)
Players.PlayerRemoving:Connect(PlayerManager.playerRemoved)

return PlayerManager