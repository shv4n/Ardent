local ServerStorage = game:GetService("ServerStorage")

local StateManager = require(ServerStorage.Modules.Managers.StateManager)

local Characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

local function GenerateRandomSuffix(Length)
	local Suffix = ""
	for i = 1, Length do
		local RandomIndex = math.random(1, #Characters)
		Suffix = Suffix .. Characters:sub(RandomIndex, RandomIndex)
	end
	return Suffix
end

local EntityManager = {}
EntityManager.Entities = {}

local function CreateUniqueID(Prefix)
	local ID
	repeat
		ID = Prefix .. "_" .. GenerateRandomSuffix(8)
	until not EntityManager.Entities[ID]
	return ID
end

function EntityManager:CreateEntity(EntityName, StateModule, Player, Stats)
	local EntityID = CreateUniqueID(EntityName)

	local StateDefinitions = require(ServerStorage.Modules.StateMachines[StateModule])

	local Profile = {
		ID = EntityID,
		Character = nil,
		Player = Player,
		Data = { Posture = Stats and Stats.MaxPosture or 100 },
		Connections = {},
	}

	EntityManager.Entities[EntityID] = Profile
	StateManager:Register(EntityID, StateDefinitions, "Idle", Profile)

	if typeof(Player) == "Instance" then
		local function BindCharacter(Character)
			Character:SetAttribute("EntityID", EntityID)
			Character:SetAttribute("Posture", 0)
			Profile.Character = Character
		end

		Player:SetAttribute("EntityID", EntityID)

		if Player.Character then
			BindCharacter(Player.Character)
		end

		Profile.Connections.CharacterAdded = Player.CharacterAdded:Connect(BindCharacter)
	end

	warn("EntityManager:", EntityName, StateModule, Player)

	return Profile
end

function EntityManager:GetEntity(EntityID)
	return EntityManager.Entities[EntityID]
end

function EntityManager:GetEntityByCharacter(Character)
	local EntityID = Character:GetAttribute("EntityID")

	if not EntityID then
		return nil
	end

	return self:GetEntity(EntityID)
end

function EntityManager:ChangeState(Character, Action, ...)
	local Profile = EntityManager:GetEntityByCharacter(Character)

	if not Profile then
		return
	end

	local EntityID = Profile.ID

	StateManager:Trigger(EntityID, Action, ...)
end

function EntityManager:ForceState(Character, NewState, ...)
	local Profile = EntityManager:GetEntityByCharacter(Character)

	if not Profile then
		return
	end

	local EntityID = Profile.ID

	StateManager:SetState(EntityID, NewState, ...)
end

function EntityManager:DestroyEntity(Input)
	local EntityID

	if typeof(Input) == "Instance" then
		EntityID = Input:GetAttribute("EntityID")
	else
		EntityID = Input
	end

	local Profile = EntityManager:GetEntity(EntityID)

	if not Profile then
		return
	end

	for _, Connection in pairs(Profile.Connections) do
		Connection:Disconnect()
	end

	EntityManager.Entities[EntityID] = nil
	StateManager:Unregister(EntityID)
end

function EntityManager:GetState(Character)
	local Profile = EntityManager:GetEntityByCharacter(Character)

	if not Profile then
		return nil
	end

	local EntityID = Profile.ID

	return StateManager:GetState(EntityID)
end

return EntityManager
