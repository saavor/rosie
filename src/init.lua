-- rosie
-- made with love by nova
-- (c) 2022

local RunService = game:GetService("RunService")

if RunService:IsServer() then
	-- running on server
	return require(script.rosieServer)
else
	-- running on client
	return require(script.rosieClient)
end