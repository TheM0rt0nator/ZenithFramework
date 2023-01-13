local ReplicatedStorage = game:GetService("ReplicatedStorage")

local loadModule = table.unpack(require(ReplicatedStorage.ZenithFramework))

local makeActionCreator = loadModule("makeActionCreator")

return makeActionCreator("changeStats", function(userId, stat, newValue)
	return {
		userId = userId,
		stat = stat,
		newValue = newValue
	}
end)