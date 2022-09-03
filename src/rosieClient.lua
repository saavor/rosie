-- rosie client
-- part of the rosie framework
-- written by nova

local rosieClient = {}

-- Services
local RunService = game:GetService("RunService")

-- Module Scripts
local rosieConfig = require(script.parent.rosieConfig)

local systems = {} -- Services table
local modules = {} -- Modules table

rosieClient.systems = systems
rosieClient.moodules = modules

local IsStarted = false

function rosieClient.addSystems(systemsPath)
	for _,system in ipairs(systemsPath:GetChildren()) do 
		if not system:IsA("ModuleScript") then continue end
		table.insert(systems, require(system))
	end
end

function rosieClient.addModules(modulesPath)
	for _,module in ipairs(modulesPath:GetChildren()) do 
		if not module:IsA("ModuleScript") then continue end
		table.insert(modules, require(module))
	end
end

function rosieClient.Start()
	if IsStarted then
		return warn("[rosie] Already started")
	end

	-- Print little message
	print("rosie v" .. rosieConfig.version)


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

	-- Update services
	RunService.RenderStepped:Connect(function ()
		for _,system in ipairs(systems) do
			if system.Update then
				system.Update()
			end
		end
	end)
end

return rosieClient