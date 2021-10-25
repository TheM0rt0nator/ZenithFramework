local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local StarterPlayer = game:GetService("StarterPlayer")

local SHARED_MODULE_PATHS = {
	ReplicatedStorage.SharedScripts;
	ReplicatedStorage.ZenithFramework.Libraries;
}
local SERVER_MODULES_PATH
local CLIENT_MODULES_PATH = StarterPlayer.StarterPlayerScripts.ClientScripts

local ModuleScriptLoader = {}
ModuleScriptLoader.__index = ModuleScriptLoader

-- Creates new module loader which can be used to reference any module in the above paths
function ModuleScriptLoader.new(loadLocation)
	local self = setmetatable({}, ModuleScriptLoader)

	print("New module script loader made")
	self._modules = {}

	if loadLocation == "Server" then
		SERVER_MODULES_PATH = ServerScriptService.ServerScripts
	end

	self:AddModules(loadLocation)
	self:AddModules("Shared")

	return self
end

-- Loads all the module scripts in _modules
function ModuleScriptLoader:LoadAll()
	for moduleName, module in pairs(self._modules) do
		if module:GetAttribute("AutoLoad") == nil or module:GetAttribute("AutoLoad") then
			require(module)
		end
	end

	warn("Loaded all modules successfully!")
end

-- Looks for the module in the table and returns it if found
function ModuleScriptLoader:RequireModule(moduleName)
	assert(type(moduleName) == "string")

	if self._modules[moduleName] then
		return require(self._modules[moduleName])
	end
end

-- Adds modules from the given location to the ._modules table
function ModuleScriptLoader:AddModules(location)
	assert(type(location) == "string" and self["get" .. location .. "Modules"])

	for _, module in pairs(self["get" .. location .. "Modules"]()) do
		if not self._modules[module.Name] then
			self._modules[module.Name] = module
		end
	end
end

-- Returns a table of all module scripts in SHARED_MODULES_PATH
function ModuleScriptLoader.getSharedModules()
	local sharedModules = {}
	for _, path in pairs(SHARED_MODULE_PATHS) do
		for _, module in pairs(path:GetDescendants()) do
			if module:IsA("ModuleScript") then
				table.insert(sharedModules, module)
			end
		end
	end

	return sharedModules
end

-- Returns a table of all module scripts in SERVER_MODULES_PATH
function ModuleScriptLoader.getServerModules()
	local serverModules = {}
	for _, module in pairs(SERVER_MODULES_PATH:GetDescendants()) do
		if module:IsA("ModuleScript") then
			table.insert(serverModules, module)
		end
	end

	return serverModules
end

-- Returns a table of all module scripts in CLIENT_MODULES_PATH
function ModuleScriptLoader.getClientModules()
	local clientModules = {}
	for _, module in pairs(CLIENT_MODULES_PATH:GetDescendants()) do
		if module:IsA("ModuleScript") then
			table.insert(clientModules, module)
		end
	end

	return clientModules
end

-- When the loader is called, requires the given module name and returns it
function ModuleScriptLoader:__call(moduleName)
	return self:RequireModule(moduleName)
end

return ModuleScriptLoader