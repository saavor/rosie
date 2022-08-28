-- rosie server
-- part of the rosie framework
-- written by nova

local RunService = game:GetService("RunService")

local rosieServer = {}
rosieServer.__index = rosieServer

rosieServer.instance = nil

function rosieServer.new()

	-- Check if an instance was already created
	if rosieServer.instance then
		return error("[rosie] Only one instance can be created")
	end

	local self = {
		-- Define members of the instance here, even if they're `nil` by default.
		systems = nil,
		updateEvent = nil,
		started = false,
	}

	-- Tell Lua to fall back to looking in MyClass.__index for missing fields.
	setmetatable(self, rosieServer)

	-- Initialize
	rosieServer:_init()


	return self
end

function rosieServer:_init()
	print("Rosie (Server) vNIL")
	rosieServer.instance = self
	rosieServer.systems = {}
end

function rosieServer:start()
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

function rosieServer:getInstance()
	return self.instance
end

function rosieServer:addSystems(systemsPath)
	for _,system in ipairs(systemsPath:GetChildren()) do 
		if not system:IsA("ModuleScript") then continue end
		table.insert(self.systems, require(system))
	end
	return self.systems
end

return rosieServer