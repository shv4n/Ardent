local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local NetworkModule = require(ReplicatedStorage.Utility.Network)
local StateManager = require(ServerStorage.Modules.Managers.StateManager)
local EntityManager = require(ServerStorage.Modules.Managers.EntityManager)

NetworkModule:On("ToggleSprint", function(Player, Data)
	local Character = Player.Character
	local CurrentState = EntityManager:GetState(Character)

	if CurrentState == "Sprinting" then
		EntityManager:ChangeState(Character, "TriggerIdle")
	else
		EntityManager:ChangeState(Character, "TriggerSprint")
	end
end)

NetworkModule:On("TriggerSlide", function(Player, Data)
	local Character = Player.Character
	EntityManager:ChangeState(Character, "TriggerSlide")
end)

NetworkModule:On("StopSlide", function(Player, Data)
	local Character = Player.Character
	EntityManager:ChangeState(Character, "TriggerIdle")
end)
