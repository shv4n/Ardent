local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ProfileStore = require(script.ProfileStore)
local EntityManager = require(ServerStorage.Modules.Managers.EntityManager)

local ProfileTemplate = {
	ClientData = {
		StateModule = "Human",
		FirstName = "",
		LastName = "",
		Title = "",
		Crowns = 0,
		MaxPosture = 75,
	},
}

local CachedProfiles = {}

local IS_STUDIO = game.PlaceId == 0

local profileStore
if IS_STUDIO then
	profileStore = ProfileStore.New("TEST_CLIENT", ProfileTemplate)
else
	profileStore = ProfileStore.New("ARDENT_CLIENT", ProfileTemplate)
end

local DataManager = {}

function DataManager:PlayerAdded(Player)
	local Profile = profileStore:StartSessionAsync("Player_" .. Player.UserId, {
		Cancel = function()
			return Player.Parent ~= Players
		end,
	})

	if Profile ~= nil then
		if not Player:IsDescendantOf(Players) then
			Profile:EndSession()
			return
		end

		Profile.OnLastSave:Connect(function(reason)
			if reason == "External" then
				CachedProfiles[Player] = nil
				if Player:IsDescendantOf(Players) then
					Player:Kick("Profile loaded on another server, please rejoin.")
				end
			end
		end)

		Profile.OnSessionEnd:Connect(function()
			CachedProfiles[Player] = nil
			if Player:IsDescendantOf(Players) then
				Player:Kick("Your session was ended, please rejoin.")
			end
		end)

		Profile:AddUserId(Player.UserId)
		Profile:Reconcile()
		CachedProfiles[Player] = Profile

		local StateModule = Profile.Data.ClientData.StateModule
		EntityManager:CreateEntity(Player.Name, StateModule, Player)
	else
		Player:Kick("Data error occurred. Please rejoin.")
	end
end

function DataManager:PlayerRemoved(Player)
	local Profile = CachedProfiles[Player]
	local EntityID = Player:GetAttribute("EntityID")

	if Profile ~= nil then
		Profile:EndSession()
		EntityManager:DestroyEntity(EntityID)
		CachedProfiles[Player] = nil
	end
end

function DataManager:GetClientData(Player)
	local Profile = CachedProfiles[Player]
	if Profile ~= nil then
		return Profile.Data.ClientData
	end
	return nil
end

function DataManager:TestExternalSteal(Player)
	local profile = CachedProfiles[Player]
	if profile then
		profile.OnLastSave:Fire("External")
	end
end

return DataManager
