local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local defineModule = require(game.ServerScriptService.Server.Define)
local replicateRemote = replicatedStorage.Events.Replicate;
local hitRemote = replicatedStorage.Events.Hit;

local player = playersService.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local mouse = player:GetMouse();

local tool = script.Parent
local firePoint = tool:WaitForChild("ToolHandler")

local gunSettings = require(tool:WaitForChild("Settings"))
local equipped = false;


local ignoreList = {char, workspace.Effects}
local debrisService = game:GetService("Debris")
local doFire = false

--#region Connect & Equip
tool.Equipped:Connect(function()
    equipped = true;
end)

tool.Unequipped:Connect(function()
    equipped = false;
end)
--#endregion

--#region Local

local function castRay()
	local origin = firePoint.Position
	local direction = (mouse.Hit.p - firePoint.Position).Unit
	direction = direction * gunSettings.range

	local ray = Ray.new(origin, direction)
	--local hit, pos = workspace:FindPartOnRayWithIgnoreList(ray, ignoreList)


    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = ignoreList
    raycastParams.FilterDescendantsInstances = {workspace.Model}
    raycastParams.IgnoreWater = true

    local hit, pos = workspace:Raycast(ray, direction, raycastParams)


	replicatedStorage.Replicate:FireServer(tool, origin, pos)
	local visual = Instance.new("Part")
	local length = (pos - origin).Magnitude
	visual.Anchored = true
	visual.CanCollide = false
	visual.Material = Enum.Material.Neon
	visual.Color = gunSettings.rayColor
	visual.Size = Vector3.new(gunSettings.raySize.X, gunSettings.raySize.Y, length)
	visual.CFrame = CFrame.new(origin, pos) * CFrame.new(0,0,-length/2)
	visual.Parent = workspace.Effects
	debrisService:AddItem(visual, gunSettings.debrisTime)

	return hit, pos, direction, origin
end

local function gunEffects()
	for _, effect in pairs(firePoint:GetChildren()) do
		if effect:IsA("ParticleEmitter") then
			effect:Emit(50)
		end
		
		if effect:IsA("Sound") then
			effect:Play()
		end
	end
end

local function fire()
	local waitTime = 60/gunSettings.rateOfFire

	repeat
		if equipped and not tool.Debounce.Value then
			tool.Debounce.Value = true

			task.delay(waitTime, function()
				tool.Debounce.Value = false
			end)

			gunEffects()
			local hit, pos, direction, origin = castRay()

			if hit then
				local relCFrame = hit.CFrame:Inverse() * CFrame.new(pos)
				hitRemote:FireServer(tool, hit, direction, origin, relCFrame)
			end			
		end
		task.wait(waitTime)

	until not equipped or not doFire or gunSettings.fireMode ~= defineModule.WeaponMode.AUTO
end
--#endregion






--#region Mouse Interaction
mouse.Button1Down:Connect(function()
	doFire = true
	if char.Humanoid.Health > 0 then
		fire()
	end
end)

mouse.Button1Up:Connect(function()
	doFire = false
end)

--#endregion