-- All functions related to basic Data Stores 

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local require = table.unpack(require(ReplicatedStorage.ZenithFramework))

local Table = require("Table")

local DataStore = {}
DataStore.Data = {}
DataStore.DataCache = {}

local AUTOSAVE_INTERVAL = 60
local WAIT_INTERVAL = 30

-- Returns the stored session data, and creates a table if it doesn't exist yet
function DataStore.getStoredData(dataStore)
	if not DataStore.Data[dataStore] then
		DataStore.Data[dataStore] = {}
		DataStore.DataCache[dataStore] = {}
	end
	return DataStore.Data[dataStore]
end

-- Sets the session data for a given data store with given index, merging it in if it is a table
function DataStore.setSessionData(dataStore, index, newData)
	assert(typeof(dataStore) == "Instance", "DataStore argument must be a DataStore instance")
	assert(typeof(index) == "string", "index argument must be a string")

	local data = DataStore.getStoredData(dataStore)
	data[index] = (data[index] and data[index]) or {}
	if typeof(newData) == "table" and typeof(data[index] == "table") then
		data[index] = Table.merge(data[index], newData)
	else
		data[index] = newData
	end

	DataStore.DataCache[dataStore][index] = newData
end

-- Gets the data in the given data store with the given index, saves it in the Data table and returns it
function DataStore.getData(dataStore, index)
	assert(typeof(dataStore) == "Instance", "dataStore argument must be a DataStore instance")
	assert(typeof(index) == "string", "index argument must be a string")

	local data = DataStore.getStoredData(dataStore)
	if data[index] then return data[index] end
	local success, data = pcall(function()
		dataStore:GetAsync(index)
	end)
	if success then 
		data[index] = data
		return data
	else
		warn("Failed to get data from DataStore: " , dataStore , " with index: " , index)
	end
end

-- Waits for the data and repeatedly tries the getData function until it gets the data
function DataStore.waitForData(dataStore, index)
	assert(typeof(dataStore) == "Instance", "dataStore argument must be a DataStore instance")
	assert(typeof(index) == "string", "index argument must be a string")

	local data = DataStore.getStoredData(dataStore)
	if data[index] then return data[index] end
	while not data[index] do
		DataStore.getData(dataStore, index)
		if not data[index] then
			task.wait(WAIT_INTERVAL)
		end
	end

	return data[index]
end

-- Completely overwrites the data in the given data store with the given index, saves it in the Data table and returns it
-- Also caches the data if it fails to save, to be picked up on the next autosave cycle
function DataStore.setDataAsync(dataStore, index, newData)
	assert(typeof(dataStore) == "Instance", "DataStore argument must be a DataStore instance")
	assert(typeof(index) == "string", "index argument must be a string")

	local data = DataStore.getStoredData(dataStore)
	local success, errorMessage = pcall(function()
		data:SetAsync(index, newData)
	end)
	if not success then
		warn("Failed to save data to DataStore: " , dataStore , " with index: " , index , " due to error: " , errorMessage)
	else
		DataStore.DataCache[dataStore][index] = nil
	end
end

-- Saves all data in all datastores
function DataStore.saveAllData()
	for dataStore, data in pairs(DataStore.DataCache) do
		for index, value in pairs(data) do
			DataStore.setDataAsync(dataStore, index, value)
		end
	end
end

-- Auto save all the datastores at a set interval
while task.wait(AUTOSAVE_INTERVAL) do
	DataStore.saveAllData()
end

game:BindToClose(function()
	-- If the current session is studio, do nothing
	if RunService:IsStudio() then
		return
	end

	DataStore.saveAllData()
end)

return DataStore