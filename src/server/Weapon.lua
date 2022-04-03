local playerServices = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")


local hitRemote = replicatedStorage.Events.Hit
local replicateRemote = replicatedStorage.Events.Replicate

local dataModule = require(script.Parent.Data)
local defineModule = require(script.Parent.Define)

local weaponsModule = {}

-- Public

---- Verify player be hit
weaponsModule.playerFromHit = function(hit)
    local char = hit:FindFirstAncestorOfClass("Model")
    local player = playerServices:GetPlayerFromCharacter(char)

    return player, char
end

-- Verify hit
local function verifyHit(hit, direction, origin, relCframe, gunSettings)
    local targetPosition = (hit.CFrame).Position
    local serverDirection = targetPosition - origin

    if serverDirection.Magnitude > gunSettings.range then
        return
    end

    if serverDirection.Magnitude == 0 or direction.Magnitude == 0 then
        return
    end

    local combinedVectors = serverDirection:Dot(direction)
	local angle = combinedVectors/(direction.Magnitude * serverDirection.Magnitude)

	if angle > 1 then
		angle = 0
	elseif angle < -1 then
		angle = math.pi
	else
		angle = math.acos(angle)
	end
	angle = math.deg(angle)

	if angle <= defineModule.Security.SECURITY_ANGLE then
		return true
	end
    
end


-- Event Catch
hitRemote.OnServerEvent:Connect(function(player, weapon, hit, direction, origin, relCframe)
    local otherPlayer, char = weaponsModule.playerFromHit(hit)

    if char and char:FindFirstChildOfClass("Humanoid") and not weapon.Debounce.Value then
        local gunSettigns = require(weapon.Settings)
        if (verifyHit(hit, direction, origin, relCframe, gunSettigns)) then
            
            weapon.Debounce.Value = true
            local waittime = 60/gunSettigns.rateOfFire
            task.delay(waittime, function()
                weapon.Debounce.Value = false
            end)

            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if (humanoid.Health > 0 ) then
                
                local damage = gunSettigns.damage
                if hit.Name == "Head" then
                    damage = damage * gunSettigns.headshotMultiplier
                end

                humanoid.Health = humanoid.Health - damage;

                if (humanoid.Health <= 0) then
                    dataModule.increment(player, defineModule.KillCounter, 1)
                end
            end
        end
    end
    
end)






return weaponsModule