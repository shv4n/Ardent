local ServerStorage = game:GetService("ServerStorage")

local StateManager = require(ServerStorage.Modules.Managers.StateManager)
local MovementService = require(ServerStorage.Modules.Services.MovementService)

local HumanData = {

	-- Shared

	SharedFunctions = {

		TakeDamage = function(StateMachine, Context, Damage)
			print("Took damage:", Damage)
		end,
	},

	-- Default

	Idle = {

		TakeDamage = function(StateMachine, Context, Damage)
			print("Idle took damage:", Damage)
		end,

		-- Movement

		TriggerSprint = function(StateMachine, Context)
			StateManager:SetState(Context.ID, "Sprinting")
			StateManager:Trigger(Context.ID, "StartSprint")
		end,

		-- Combat

		TriggerAttack = function(StateMachine, Context, ...)
			StateManager:SetState(Context.ID, "Attacking")
			StateManager:Trigger(Context.ID, "StartAttack", ...)
		end,
	},

	-- Movement

	Sprinting = {

		StartSprint = function(StateMachine, Context)
			MovementService:Sprint(Context.Character)
		end,

		StopSprint = function(StateMachine, Context)
			MovementService:StopSprinting(Context.Character)
		end,

		TriggerIdle = function(StateMachine, Context)
			StateManager:Trigger(Context.ID, "StopSprint")
			StateManager:SetState(Context.ID, "Idle")
		end,

		TriggerSlide = function(StateMachine, Context)
			StateManager:PushState(Context.ID, "Sliding")
			StateManager:Trigger(Context.ID, "StartSlide")
		end,

		OnResume = function(StateMachine, Context)
			MovementService:Sprint(Context.Character)
		end,
	},

	Sliding = {

		StartSlide = function(StateMachine, Context)
			MovementService:Sliding(Context.Character)
		end,

		StopSlide = function(StateMachine, Context)
			MovementService:StopSliding(Context.Character)
		end,

		TriggerIdle = function(StateMachine, Context)
			StateManager:Trigger(Context.ID, "StopSlide")
			StateManager:PopState(Context.ID)
		end,
	},

	Dashing = {

		StartDash = function(StateMachine, Context)
			-- MovementService:Dash(Context.Character)
		end,

		StopDash = function(StateMachine, Context) end,

		TriggerIdle = function(StateMachine, Context)
			StateManager:Trigger(Context.ID, "StopDash")
			StateManager:SetState(Context.ID, "Idle")
		end,
	},
}

return HumanData
