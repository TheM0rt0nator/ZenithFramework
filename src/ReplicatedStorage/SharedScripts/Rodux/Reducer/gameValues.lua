local ReplicatedStorage = game:GetService("ReplicatedStorage")

local loadModule = table.unpack(require(ReplicatedStorage.ZenithFramework))

local Rodux = loadModule("Rodux")
local Table = loadModule("Table")

return Rodux.createReducer({}, {
	setGameValues = function(state, action)
		local values = action.values
		if values then
			return Table.clone(values)
		end
		return state
	end;
})