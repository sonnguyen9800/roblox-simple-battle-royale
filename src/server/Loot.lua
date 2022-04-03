local replicatedStorage = game:GetService("ReplicatedStorage")
local lootSpawns = workspace.LootSpawns


local weaponFolder = replicatedStorage.Common.Weapon
local random = Random.new()
local weapons = require(script.Parent.Weapon)
local lootModule = {}

for _, spawnPoint in pairs(lootSpawns:GetChildren()) do
spawnPoint.Anchored = true
spawnPoint.CanCollide = false
spawnPoint.Transparency = 1
end

-- Local function
local function makeWeaponModel(weapon)
    local weaponModel = Instance.new("Model")

    for _, child in pairs(weaponModel:GetDescendants()) do
        if child:IsA("BasePart") then
            
            child.Parent = weaponModel
            child.Anchored = true
            child:ClearAllChildren()
        end
    end
    weaponModel:Destroy()
    return weaponModel
end

-- Public 

lootModule.spawnWeapons = function()
    for _, spawnPoint in pairs(lootSpawns:GetChildren()) do
        local oldModel = spawnPoint:FindFirstChildOfClass("Model")
        if oldModel then
            oldModel:Destroy()
        end

        local weaponPool =  weaponFolder:GetChildren()
        local randomIndex = random:NextInteger(1, #weaponPool);

        local weapon = weaponPool[randomIndex]:Clone()
        local weaponName = weapon.Name
        
        local weaponModel = makeWeaponModel(weapon)
        weaponModel.Parent = spawnPoint

        -- Create part
        local parimaryPart = Instance.new("Part")
        parimaryPart.Anchored = true;
        parimaryPart.CanCollide = false;
        parimaryPart.Transparency = 1
        parimaryPart.CFrame, parimaryPart.Size = weaponModel:GetBoundingBox()

        parimaryPart.Parent = weaponModel
        weaponModel.PrimaryPart = parimaryPart

        local newCFrame = CFrame.new(spawnPoint.CFrame.Position)*CFrame.new(0,1,0)

        parimaryPart.Touched:Connect(function(hit)
            local player, char = weapons.playerFromHit(hit)
            if player and char then
                local tool = weaponFolder:FindFirstChild(weaponName):Clone()

                tool.Parent = player.Backpack
                char.Humanoid:EquipTool(tool)
                weaponModel:Destroy();
            end
        end)

    end
end

return lootModule