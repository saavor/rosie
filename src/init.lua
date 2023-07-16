--[[
    rosie
    written by nova <3
	(c) 2023
]]--

local rosie = {}

-- Services
local RunService = game:GetService("RunService")

rosie.systems = {} -- systems table

function rosie.loadSystem(system: ModuleScript)
	table.insert(rosie.systems, {
		name = system.Name,
		module = require(system)
	}) 
end

function rosie.loadSystems(systems)
	for _,system in ipairs(systems) do
		rosie.loadSystem(system)
	end
end

function rosie.loadSystemsFromFolder(folderPath: Folder)
	for _,system in ipairs(folderPath:GetChildren()) do 
		if not system:IsA("ModuleScript") then continue end -- If not a modulescript, then skip
		rosie.loadSystem(system)
	end
end

function rosie.start()
	for _,system in ipairs(rosie.systems) do
		
		-- run system start functions
		if system.module.start then
			system.module:start()
		end
		
		-- bind update functions
		if system.module.update then
			if RunService:IsServer() then
				return error("[rosie] update can only be used on the client!")
			end
			
			RunService:BindToRenderStep(system.name, Enum.RenderPriority.Camera.Value-1, function (delta: number)
				system.module:update(delta)
			end)
		end
		
		-- bind tick functions
		if system.module.tick then
			RunService.Heartbeat:Connect(function (delta: number)
				system.module:tick(delta)
			end)
		end
		
	end
end

return rosie