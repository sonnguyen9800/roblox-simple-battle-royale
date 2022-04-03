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


local function spawnPlayers()
    local spawnPoints = workspace.Spawns:GetChildren()
    for _, player in pairs(competitors) do
        local char = player.Character or player.CharacterAdded:Wait()

        local randomVal = random.NextInteger(1, defineModule.GameRunner.NUM_SPAWN_POINT)

        char:SetPrimaryPartCFrame(spawnPoints.Cframe * CFrame.new(0,2,0))
    end
end

local function loadAllPlayers()
    for _, player in pairs(competitors) do
        player:LoadCharacter()
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


-- GameLoop

gameRunner.gameLoop = function()
    while task.wait(0.5) do
        if #playerService:GetPlayers()< defineModule.GameRunner.MIN_PLAYERS then
            message.Value = "There must be "..defineModule.GameRunner.MIN_PLAYERS.. " players to start"
        else
            local intermission = defineModule.GameRunner.INTERMISSION_LENGTH
            repeat
                message.Value = intermission - 1
                task.wait(1)

            until intermission == 0
            
            message.Value = "Get Ready for the game"
            task.wait(2)
            addPlayersToTable()
            spawnPlayers();


            local gameTime = defineModule.GameRunner.ROUND_LENGTH

            repeat
                message.Value = "Time Remaining" .. gameTime
                remaining.Value = #competitors.. " remaining"
                gameTime = gameTime - 1
                task.wait(1)

            until #competitors <= 1 or gameTime == 0

            loadAllPlayers()
            remaining.Value = ""
            if gameTime == 0 or #competitors == 0 then
                message.Value = "There were no victors"
            else
                local winner = competitors[1]
                dataModule.increment(winner, defineModule.WinCounter, 1)
                dataModule.increment(winner, defineModule.CoinName, defineModule.GameRunner.PRIZE_AMOUNG)
            end
             
        end
    end
end

-- Service
playerService.PlayerMembershipChanged:Connect(function(player)
    removePlayerIntable(player);

end)







return gameRunner