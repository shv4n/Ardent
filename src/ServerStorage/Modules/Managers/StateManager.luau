local StateManager = {}

StateManager.StateDefinitions = {}
StateManager.CurrentState = {}
StateManager.Context = {}

function StateManager:Register(EntityID, StateDefinitions, CurrentState, Context)
	StateManager.StateDefinitions[EntityID] = StateDefinitions
	StateManager.CurrentState[EntityID] = CurrentState
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

	warn(NewState .. " doesn't exist for " .. EntityID)
	if not StateDefinitions[NewState] then
		return
	end

	StateManager.CurrentState[EntityID] = NewState
end

function StateManager:Trigger(EntityID, Action, ...)
	local StateDefinitions = StateManager.StateDefinitions[EntityID]
	local CurrentState = StateManager.CurrentState[EntityID]
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

return StateManager
