local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local loadModule, getDataStream = table.unpack(require(ReplicatedStorage.ZenithFramework))

local DataStore = loadModule("DataStore")
local DefaultData = loadModule("DefaultData")
local Table = loadModule("Table")
local RoduxStore = loadModule("RoduxStore")
local CONFIG = loadModule("CONFIG")

local setPlayerSession = loadModule("setPlayerSession")

local TOTAL_LEAVING_FUNCS = 2

local PlayerDataStore = DataStoreService:GetDataStore("PlayerDataStore")

local PlayerDataManager = {
	loadedData = {};
	leftBools = {};
}

-- Sets up the check for when the rodux store changes to update the players data, and sets up the playerAdded/playerRemoving functions
function PlayerDataManager:initiate()
	task.spawn(function()
		for _, player in pairs(Players:GetPlayers()) do
			PlayerDataManager.playerAdded(player)
		end
	end)

	Players.PlayerAdded:Connect(PlayerDataManager.playerAdded)
	Players.PlayerRemoving:Connect(PlayerDataManager.playerRemoving)
end

-- Dispatches the new data to rodux for UI changes and then updates the data store directly
function PlayerDataManager:updatePlayerData(userId, action, ...)
	RoduxStore:dispatch(action(userId, ...))
	local newData = RoduxStore:getState().playerData[tostring(userId)]
	if not newData then return end
	DataStore.setSessionData(PlayerDataStore, "User_" .. userId, newData)
end

function PlayerDataManager:resetData(userId)
	PlayerDataManager:updatePlayerData(userId, setPlayerSession, DefaultData)
end

-- Yields until the players data has been sorted
function PlayerDataManager:waitForLoadedData(player)
	while not PlayerDataManager.loadedData[tostring(player.UserId)] do
		task.wait()
	end
end

function PlayerDataManager.playerAdded(player)
	local userId = player.UserId
	local playerDataIndex = "User_" .. userId
	if (not CONFIG.RESET_PLAYER_DATA or not RunService:IsStudio()) then
		local playersData = DataStore.getData(PlayerDataStore, playerDataIndex, Table.clone(DefaultData))
		RoduxStore:dispatch(setPlayerSession(userId, playersData or {}))
	elseif CONFIG.RESET_PLAYER_DATA and RunService:IsStudio() then
		PlayerDataManager:resetData(userId)
	end
	RoduxStore:waitForValue("playerData", tostring(player.UserId))
	PlayerDataManager.loadedData[tostring(player.UserId)] = true
end

function PlayerDataManager.playerRemoving(player)
	-- Here we wait for all the other leaving functions which effect data to be completed before removing the players data from rodux and saving it
	if not PlayerDataManager.leftBools[tostring(player.UserId)] or PlayerDataManager.leftBools[tostring(player.UserId)] < TOTAL_LEAVING_FUNCS then
		while not PlayerDataManager.leftBools[tostring(player.UserId)] or PlayerDataManager.leftBools[tostring(player.UserId)] < TOTAL_LEAVING_FUNCS do
			task.wait(0.1)
		end
	end
	local userId = player.UserId

	DataStore.removeSessionData(PlayerDataStore, "User_" .. userId, true)
	RoduxStore:dispatch(setPlayerSession(userId, Table.None))
	PlayerDataManager.loadedData[tostring(player.UserId)] = nil
	PlayerDataManager.leftBools[tostring(player.UserId)] = nil
end

return PlayerDataManager