local ServerStorage = game:GetService("ServerStorage")

local StateManager = require(ServerStorage.Modules.Managers.StateManager)

local HumanData = {
	SharedFunctions = {
		TakeDamage = function(StateMachine, Context, Damage)
			print("took damage:", Damage)
		end,
	},
	Idle = {
		TakeDamage = function(StateMachine, Context, Damage)
			print("Idle took damage:", Damage)
		end,
		TriggerAttacking = function(StateMachine, Context, ...)
			StateManager:SetState(Context.ID, "Attacking")
			StateManager:Trigger(Context.ID, "TakeDamage", ...)
		end,
	},
	Attacking = {
		TakeDamage = function(StateMachine, Context, Damage)
			print("Attacking took damage:", Damage)
		end,
	},
}

return HumanData
