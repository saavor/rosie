-- rosie server
-- part of the rosie framework
-- written by nova

local rosieServer = {}

-- Services
local RunService = game:GetService("RunService")

-- Module Scripts
local rosieConfig = require(script.parent.rosieConfig)

local systems = {} -- Services table
local modules = {} -- Modules table

rosieServer.systems = systems
rosieServer.moodules = modules

local IsStarted = false

function rosieServer.addSystems(systemsPath)
	for _,system in ipairs(systemsPath:GetChildren()) do 
		if not system:IsA("ModuleScript") then continue end
		table.insert(systems, require(system))
	end
end

function rosieServer.addModules(modulesPath)
	for _,module in ipairs(modulesPath:GetChildren()) do 
		if not module:IsA("ModuleScript") then continue end
		table.insert(modules, require(module))
	end
end

function rosieServer.Start()
	if IsStarted then
		return warn("[rosie] Already started")
	end

	-- Print little message
	print("rosie (server) v" .. rosieConfig.version)

	-- run system start functions
	for _,system in ipairs(systems) do
		if system.Start then
			system.Start()
		end
	end

	-- Step services
	RunService.Heartbeat:Connect(function ()
		for _,system in ipairs(systems) do
			if system.Step then
				system.Step()
			end
		end
	end)

	-- Check if the user is trying to call update on the server
	for _,system in ipairs(systems) do
		if system.Update then
			error("[rosie] Update can't be used on the server.")
		end
	end
end

return rosieServer