--module Define

local Define = {

    DataStorageId = "DataStorageV1",

    LeaderstartsName = "Stats",
    CoinName = "LuckyGold",
    StageName = "Trial",
    WinCounter = "Win",
    DefaultPlayerData = {
        CoinName = 0,
        Trial = 1,
        WinCounter = 0
    },

    Time = {
        AUTOSAVE_INTERVAL = 120
    },

    Annoucement = {
        Shutdown = "Shutting Down game. All Data will be saved"
    },

    FolderTags = {
        Coin = "CoinTags"
    },

    Items = {
        ["SpringPotion"] = {
            Name = "Spring Potion",
            CoinPrice =  5,
            JumpPower = 90;
            EffectDuration = 20
        }
    },

    PlayerCharacter = {
        DefaultJumpPower = 50
    }



}

return Define;