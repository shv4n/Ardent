local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataManager = require(ServerStorage.Modules.Managers.DataManager)
local EntityManager = require(ServerStorage.Modules.Managers.EntityManager)
local NetworkModule = require(ReplicatedStorage.Utility.Network)
local MovementService = require(ServerStorage.Modules.Services.MovementService)

local function PlayerAdded(Player)
	DataManager:PlayerAdded(Player)
end

local function PlayerRemoved(Player)
	DataManager:PlayerRemoved(Player)
end

Players.PlayerAdded:Connect(function(Player)
	PlayerAdded(Player)
	task.wait(1)

	--[[local Profile = EntityManager:GetEntityByCharacter(Player.Character)
	print("Profile exists:", Profile ~= nil)
	print("Max Posture:", Profile and Profile.Data.Posture)
	print("Current Posture:", Player.Character:GetAttribute("Posture"))]]

	EntityManager:ChangeState(Player.Character, "TriggerSprinting")
	task.wait(1)
	print("WOw")
	MovementService:Sliding(Player.Character)
end)

Players.PlayerRemoving:Connect(PlayerRemoved)

--[[NetworkModule:On("Sprint", function(player, data)
	print(string.format("[Network] %s started sprinting", player.Name))
	MovementService:Sprint(player.Character)
end)
NetworkModule:On("StopSprint", function(player, data)
	print(string.format("[Network] %s started sprinting", player.Name))
	MovementService:StopSprinting(player.Character)
end)
]]
