local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")

local DataManager = require(ServerStorage.Modules.Managers.DataManager)
local EntityManager = require(ServerStorage.Modules.Managers.EntityManager)

local function PlayerAdded(Player)
	DataManager:PlayerAdded(Player)
end

local function PlayerRemoved(Player)
	DataManager:PlayerRemoved(Player)
end

--[[Players.PlayerAdded:Connect(function(Player)
	PlayerAdded(Player)
	task.wait(3)
	print("Profile:", DataManager:GetClientData(Player))
	local EntityID = Player.Character:GetAttribute("EntityID")
	print("EntityID:", EntityID)
	print("Entity:", EntityManager:GetEntity(EntityID))
	EntityManager:ChangeState(Player.Character, "TakeDamage", 10)
	task.wait(1)
	DataManager:TestExternalSteal(Player)
end)]]

Players.PlayerAdded:Connect(PlayerAdded)
Players.PlayerRemoving:Connect(PlayerRemoved)
