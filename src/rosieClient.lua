-- rosie client
-- part of the rosie framework
-- written by nova

local RunService = game:GetService("RunService")

local rosieClient = {}
rosieClient.__index = rosieClient

rosieClient.instance = nil

function rosieClient.new()

	-- Check if an instance was already created
	if rosieClient.instance then
		return error("[rosie] Only one instance can be created")
	end

	local self = {
		-- Define members of the instance here, even if they're `nil` by default.
		systems = nil,
		updateEvent = nil,
		started = false,
	}

	-- Tell Lua to fall back to looking in MyClass.__index for missing fields.
	setmetatable(self, rosieClient)

	-- Initialize
	rosieClient:_init()


	return self
end

function rosieClient:_init()
	print("Rosie vNIL")
	rosieClient.instance = self
	rosieClient.systems = {}
end

function rosieClient:start()
	if self.started then
		return warn("[rosie] Rosie already started")
	end

	self.started = true
	
	-- run system start functions
	for _,system in ipairs(self.systems) do
		system.start()
	end

	-- update services
	RunService.Heartbeat:Connect(function ()
		for _,system in ipairs(self.systems) do
			if system.update then
				system.update()
			end
		end
	end)
end

function rosieClient:getInstance()
	return self.instance
end

function rosieClient:addSystems(systemsPath)
	for _,system in ipairs(systemsPath:GetChildren()) do 
		if not system:IsA("ModuleScript") then continue end
		table.insert(self.systems, require(system))
	end
	return self.systems
end

return rosieClient