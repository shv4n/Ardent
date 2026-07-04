local StateManager = {}

StateManager.StateDefinitions = {}
StateManager.CurrentState = {}
StateManager.Context = {}

function StateManager:Register(EntityID, StateDefinitions, CurrentState, Context)
	StateManager.StateDefinitions[EntityID] = StateDefinitions
	StateManager.CurrentState[EntityID] = { CurrentState }
	StateManager.Context[EntityID] = Context

	warn(string.format(
		[[
        StateManager
        ├─ EntityID      : %s
        ├─ CurrentState  : %s
        ├─ StateDefs     : %s
        └─ Context       : %s
        ]],
		EntityID,
		tostring(CurrentState),
		tostring(StateDefinitions),
		tostring(Context)
	))
end

function StateManager:Unregister(EntityID)
	StateManager.StateDefinitions[EntityID] = nil
	StateManager.CurrentState[EntityID] = nil
	StateManager.Context[EntityID] = nil
end

function StateManager:SetState(EntityID, NewState)
	local StateDefinitions = StateManager.StateDefinitions[EntityID]

	if not StateDefinitions[NewState] then
		warn(NewState .. " doesn't exist for " .. EntityID)
		return
	end

	StateManager.CurrentState[EntityID] = { NewState }
end

function StateManager:Trigger(EntityID, Action, ...)
	local StateDefinitions = StateManager.StateDefinitions[EntityID]
	local CurrentState = StateManager.CurrentState[EntityID][#StateManager.CurrentState[EntityID]]
	local StateTable = StateDefinitions[CurrentState]

	if StateTable[Action] then
		StateTable[Action](self, StateManager.Context[EntityID], ...)
	else
		local Handler = StateDefinitions.SharedFunctions[Action]
		if Handler then
			Handler(self, StateManager.Context[EntityID], ...)
		end
	end
end

function StateManager:PushState(EntityID, NewState)
	local StateDefinitions = StateManager.StateDefinitions[EntityID]

	if not StateDefinitions[NewState] then
		warn(NewState .. " doesn't exist for " .. EntityID)
		return
	end

	local Stack = StateManager.CurrentState[EntityID]
	table.insert(Stack, NewState)
end

function StateManager:PopState(EntityID)
	local Stack = StateManager.CurrentState[EntityID]

	if #Stack > 1 then
		table.remove(Stack)
		self:Trigger(EntityID, "OnResume")
	else
		warn("Cannot pop state for " .. EntityID .. " as it is the only state in the stack.")
	end
end

function StateManager:GetState(EntityID)
	local Stack = StateManager.CurrentState[EntityID]
	return Stack[#Stack]
end

return StateManager
