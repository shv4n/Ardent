local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Remotes = ReplicatedStorage:WaitForChild("Network")

local ClientRemote = Remotes:WaitForChild("Client")
local ServerRemote = Remotes:WaitForChild("Server")

local Network = {}
local Handlers = {}

-- Client -> Server
function Network:Send(Action, ...)
	if not RunService:IsClient() then
		warn("Network:Send() can only be called from the client.")
		return
	end
	ServerRemote:FireServer(Action, ...)
end

-- Server -> One Client
function Network:SendTo(Player, Action, ...)
	if not RunService:IsServer() then
		warn("Network:SendTo() can only be called from the server.")
		return
	end
	ClientRemote:FireClient(Player, Action, ...)
end

-- Server -> All Clients
function Network:Broadcast(Action, ...)
	if not RunService:IsServer() then
		warn("Network:Broadcast() can only be called from the server.")
		return
	end
	ClientRemote:FireAllClients(Action, ...)
end

-- Register a listener
function Network:On(Action, Callback)
	assert(Handlers[Action] == nil, ("Network action '%s' is already registered."):format(Action))
	Handlers[Action] = Callback
end

local function Dispatch(Action, ...)
	local Handler = Handlers[Action]

	if not Handler then
		warn(("No handler registered for network action '%s'"):format(tostring(Action)))
		return
	end

	Handler(...)
end

-- Event Connections
if RunService:IsServer() then
	ServerRemote.OnServerEvent:Connect(function(Player, Action, ...)
		if type(Action) ~= "string" then
			return
		end

		Dispatch(Action, Player, ...)
	end)
else
	ClientRemote.OnClientEvent:Connect(function(Action, ...)
		if type(Action) ~= "string" then
			return
		end

		Dispatch(Action, ...)
	end)
end

return Network
