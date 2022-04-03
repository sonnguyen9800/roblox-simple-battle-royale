local playersService = game:GetService("Players")

local replicatedStorage = game:GetService("ReplicatedStorage")
local player = playersService.LocalPlayer

local replicationRemote = replicatedStorage.Events.Replicate


local replicationModule = {}


replicationRemote.OnClientEvent:Connect(function(otherPlayer, gunSettings, cframe, length)
    if otherPlayer ~= player then
        local visual = Instance.new("Part")

        visual.Anchored = true;
        visual.CanCollide = false;
        visual.Mass = Enum.Material.Neon;
        visual.Color = gunSettings.rayColor;
        visual.Size = Vector3.new(gunSettings.raySize.x, gunSettings.raySize.Y, length)
        visual.CFrame = cframe
        visual.Parent = workspace.Effects
        game.Debris:AddItem(visual, gunSettings.debrisTime)
    end
    
end)



return replicationModule