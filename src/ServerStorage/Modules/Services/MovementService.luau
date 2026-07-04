--[[Contains:
    Walking,
    Running,
	Dashing, 
    Crouching, THIS IS A MAYBE
    Sliding, 
    LedgeGrabbing, 
    Double jump?
    Wallrun?
    Wall Clinging?
    Obstacle vaulting?
    Flying? maybe -- for aurum and nokh
    Floating -- for thrones a maybe aswell
]]
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local EntityManager = require(ServerStorage.Modules.Managers.EntityManager)

local MovementService = {}

function MovementService:Sprint(Character)
	local Humanoid = Character.Humanoid
	local Profile = EntityManager:GetEntityByCharacter(Character)

	local Max = 24
	local Min = 17
	local Threshold = 0.50

	local function UpdateSpeed()
		local HealthPercent = Humanoid.Health / Humanoid.MaxHealth

		print(HealthPercent)

		if HealthPercent < Threshold then
			local Speed = Min + (Max - Min) * (HealthPercent / Threshold)
			Humanoid.WalkSpeed = Speed
			print(Speed)
		else
			Humanoid.WalkSpeed = Max
		end
	end

	UpdateSpeed() -- Call it once to set the initial speed based on current health

	Profile.Connections.SprintHealthListener = Humanoid.HealthChanged:Connect(UpdateSpeed)
end

function MovementService:StopSprinting(Character)
	local Humanoid = Character.Humanoid
	local Profile = EntityManager:GetEntityByCharacter(Character)

	Humanoid.WalkSpeed = Character:GetAttribute("DefaultWalkSpeed") or 16

	if Profile.Connections.SprintHealthListener ~= nil then
		Profile.Connections.SprintHealthListener:Disconnect()
		Profile.Connections.SprintHealthListener = nil
	end
end

function MovementService:Sliding(Character)
	local Humanoid = Character.Humanoid
	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

	local Profile = EntityManager:GetEntityByCharacter(Character)

	local Base = 28
	local CurrentSpeed = Humanoid.WalkSpeed
	local FlatGround = nil

	-- Last valid slide direction (used when we reach flat ground)
	local SlideDirection = Humanoid.MoveDirection.Unit
	print("SlideDirection at start:", SlideDirection, "MoveDirection was:", Humanoid.MoveDirection)

	local rayCastParams = RaycastParams.new()
	rayCastParams.FilterDescendantsInstances = { Character }
	rayCastParams.FilterType = Enum.RaycastFilterType.Exclude

	local BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.Name = "SlideVelocity"
	BodyVelocity.MaxForce = Vector3.new(1e5, 0, 1e5)
	BodyVelocity.Parent = HumanoidRootPart
	Profile.BodyVelocity = BodyVelocity

	Profile.Connections.SlideListener = RunService.Heartbeat:Connect(function(dt)
		local RayResult = workspace:Raycast(HumanoidRootPart.Position, Vector3.new(0, -10, 0), rayCastParams)

		if not RayResult then
			self:StopSliding(Character)
			return
		end

		local RayNormal = RayResult.Normal
		local Angle = math.acos(math.clamp(RayNormal:Dot(Vector3.yAxis), -1, 1))

		local Downhill = RayNormal:Cross(RayNormal:Cross(Vector3.yAxis))
		local Direction = (HumanoidRootPart.CFrame.LookVector * Vector3.new(1, 0, 1)).Unit

		local Uphill = Direction:Dot(SlideDirection) < -0.25

		if Uphill then
			self:StopSliding(Character)
			print("Stopped sliding because we are going uphill with character:", Character)
			return
		end

		if Angle < math.rad(3) then
			if FlatGround == nil then
				FlatGround = HumanoidRootPart.Position
			else
				local Distance = (HumanoidRootPart.Position - FlatGround).Magnitude

				if Distance >= 12 then
					self:StopSliding(Character)
					return
				end
			end
		else
			FlatGround = nil
		end

		local TargetSpeed = Base * (1 + math.sin(Angle))

		CurrentSpeed = math.lerp(CurrentSpeed, TargetSpeed, 8 * dt)

		BodyVelocity.Velocity = SlideDirection * CurrentSpeed
	end)
end

function MovementService:StopSliding(Character)
	print(self)
	local Humanoid = Character.Humanoid
	local Profile = EntityManager:GetEntityByCharacter(Character)

	if Profile.Connections.SlideListener ~= nil then
		Profile.Connections.SlideListener:Disconnect()
		Profile.Connections.SlideListener = nil
	end

	if Profile.BodyVelocity then
		Profile.BodyVelocity:Destroy()
		Profile.BodyVelocity = nil
	end

	if Profile.BodyVelocity == nil then
		print("BodyVelocity is nil")
	else
		print("BodyVelocity is not nil")
	end

	Humanoid.WalkSpeed = Character:GetAttribute("DefaultWalkSpeed") or 16
end

return MovementService
