local ServerStorage = game:GetService("ServerStorage")
local EntityManager = require(ServerStorage.Modules.Managers.EntityManager)
local function Clean(Data)
	return {
		Damage = Data.Damage,
		PostureDamage = 0,
		Stuns = Data.Stuns or false,
		StunTime = Data.StunTime or 0,
		Ragdoll = Data.Ragdoll or false,
	}
end
local function Blocked(Data)
	return {
		Damage = 0,
		PostureDamage = Data.PostureDamage,
	}
end
local function PostureBroken(Data)
	return {
		Damage = Data.BlockDamage,
		PostureDamage = 0,
		Stuns = Data.Stuns or false,
		StunTime = Data.StunTime or 0,
		Ragdoll = Data.Ragdoll or false,
	}
end

local function Parried(Data)
	return {
		Damage = 0,
		PostureDamage = 0,
	}
end
local DamageService = {}
local DamageTypes = {
	Clean = Clean,
	Blocked = Blocked,
	PostureBroken = PostureBroken,
	Parried = Parried,
}
function DamageService:CalculateDamage(AttackData, HitType)
	local Handler = DamageTypes[HitType]
	if not Handler then
		return 0
	end
	return Handler(AttackData)
end
function DamageService:ApplyDamage(AttackData, HitType, Character)
	local Profile = EntityManager:GetEntityByCharacter(Character)

	if not Profile then
		return
	end

	local CurrentPosture = Character:GetAttribute("Posture")
	local MaxPosture = Profile.Data.Posture
	local Humanoid = Character.Humanoid
	local FinalHitType = HitType

	if not AttackData.Blockable and HitType == "Blocked" then
		FinalHitType = "Clean"
	end

	local DamageResult = self:CalculateDamage(AttackData, FinalHitType)

	local NewPosture = CurrentPosture + DamageResult.PostureDamage

	if NewPosture >= MaxPosture then
		DamageResult = DamageTypes.PostureBroken(AttackData)
		Humanoid:TakeDamage(DamageResult.Damage)
		Character:SetAttribute("Posture", 0)
	else
		Humanoid:TakeDamage(DamageResult.Damage)
		Character:SetAttribute("Posture", math.clamp(NewPosture, 0, MaxPosture))
	end

	EntityManager:ChangeState(Character, "TakeDamage", DamageResult.Damage)
end
return DamageService
