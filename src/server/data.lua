--Module Data
local playersService = game:GetService("Players")
local dataStoreService = game:GetService("DataStoreService")

--Load the Define Module
local defineModule = require(game.ServerScriptService.Server.Define);


local store = dataStoreService:GetDataStore(defineModule.DataStorageId);

local sessionData = {}
local dataMod = {};

--Core Functions
dataMod.SetupData = function(player)
    print("Setup Data: "..player.UserId)
    local key = player.UserId
    local data = dataMod.Load(player);

    local defaultData = {}
    defaultData[defineModule.CoinName] = 0;
    defaultData[defineModule.StageName] = 1;
    sessionData[key] = dataMod.recursiveCopy(defaultData);

    if (data) then
        for index, value in pairs(data) do
            --dataMod.set()
            print(index, value)
            dataMod.set(player, index, value)
        end

        print("Player Name: "..player.Name.. "'s data has been loaded")
    else
        print("Player Name" ..player.Name.. " is a new player");
    end
    
end

dataMod.Load = function(player)
    local key = player.UserId
    local data = nil
    local success, err = pcall(function()
         data = store:GetAsync(key);

    end)

    if not success then
        print("Error: "..err.. ". Retry loading.");
        dataMod.Load(player)
    end
    return data;
end

dataMod.set = function(player, stats, value)
    local key = player.UserId
    local playerData = sessionData[key]
    playerData[stats] = value;
    --update the leaderboard
    dataMod.updateLeaderBoard(player, stats, value)
end

dataMod.increment = function(player, stats, value)
    local key = player.UserId
    local playerData = sessionData[key]
    local oldData = playerData[stats];
    playerData[stats] = oldData + value;
    dataMod.updateLeaderBoard(player, stats,  oldData + value)
end

dataMod.get = function(player, stats)
    local key = player.UserId
    local playerData = sessionData[key]
    return playerData[stats]
end

dataMod.updateLeaderBoard = function(player, stats, value)
    local leaderstartsName = defineModule.LeaderstartsName
    player[leaderstartsName][stats].Value = value
end

dataMod.save = function(player)
    local key = player.UserId
    local data = dataMod.recursiveCopy(sessionData[key])

    local success, error = pcall(function()
        store:SetAsync(key, data)    
    end)

    if success then
        print("Data of "..player.Name.." has been saved")
    else
        print("Save error"..error..". Retry start.")
        dataMod.save(player);
    end
end

dataMod.removeSessionData = function(player)
    local key = player.UserId
    sessionData[key] = nil
end

-- Auto save after interval 

local function autoSave()
    local timeInterval = defineModule.Time.AUTOSAVE_INTERVAL

    while task.wait(timeInterval) do
        print("Auto saving for all users");
        for key, value in pairs(sessionData) do
            local player = playersService:GetPlayerByUserId(key)
            dataMod.save(player)
        end
    end

end

task.spawn(autoSave);

-- Connect to PlayerServices
playersService.PlayerAdded:Connect(function(player)
    local folder = Instance.new("Folder");
    folder.Name = defineModule.LeaderstartsName
    folder.Parent = player

    local coinData = Instance.new("IntValue");
    coinData.Parent = folder
    coinData.Name = defineModule.CoinName
    coinData.Value = defineModule.DefaultPlayerData.CoinsDefault

    local killData = Instance.new("IntValue");
    killData.Parent = folder
    killData.Name = defineModule.KillCounter
    killData.Value = defineModule.DefaultPlayerData.KillCounter

    local winData = Instance.new("IntValue");
    winData.Parent = folder
    winData.Name = defineModule.WinCounter
    winData.Value = defineModule.DefaultPlayerData.WinCounter
    

    dataMod.SetupData(player);
end)

playersService.PlayerRemoving:Connect(function(player)
    dataMod.save(player)
    dataMod.removeSessionData(player)
end)

game:BindToClose(function()
    print("Game Close: Save all player data");
    for key, value in pairs(sessionData) do
        
        local player = playersService:GetPlayerByUserId(key)
        dataMod.save(player)
        player:Kick(defineModule.Annoucement.Shutdown)
    end
end)

-- Added Funtion
dataMod.recursiveCopy = function(dataTable)
    local tableCopy = {}
    for index, value in pairs(dataTable)do
        if type(value) == "table" then
            value = dataMod.recursiveCopy(value);
        end
        tableCopy[index] = value
    end
    return tableCopy
end




return dataMod;