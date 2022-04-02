local playerService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local dataModule = require(script.Parent.Data)
local defineModule = require(script.Parent.Define)

local random = Random.new()
local message = replicatedStorage.Message;
local remaining = replicatedStorage.Remaining;

local gameRunner = {}
local competitors = {}


--Local Functions
local function getPlayerIntable(player)
    for i, competitor in pairs(competitors) do
        if competitor == player then
            return i, player
        end
    end
end

local function removePlayerIntable(player)
    local index, _ = getPlayerIntable(player)
    if index then
        table.remove(competitors, index)
    end
end


-- Local:
local function preparePlayer(player)
    local char = player.Character or player.CharacterAdded:Wait()
    local humanoid = char:WaitForChild("Humanoid")
    local defaultGunName = defineModule.WeaponName.M1911;
    local defaultWeapon = replicatedStorage.Weapons[defaultGunName]:Clone();

    humanoid.Died:Connect(function()
        removePlayerIntable(player)
    end)
end

local function addPlayersToTable()
    for _, player in pairs(playerService:GetPlayers()) do
        local char = player.Character or player.CharacterAdded:Wait();
        if (char.Humanoid.Health > 0) then
            table.insert(competitors, player)
            preparePlayer(player)
        end
    end
end

-- Service
playerService.PlayerMembershipChanged:Connect(function(player)
    removePlayerIntable(player);

end)







return gameRunner