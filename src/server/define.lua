--module Define

local Define = {

    DataStorageId = "DataStorageV1",

    LeaderstartsName = "Stats",
    CoinName = "LuckyGold",
    KillCounter = "Kills",
    WinCounter = "Win",
    DefaultPlayerData = {
        CoinName = 0,
        KillCounter = 1,
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
    },

    GameRunner = {
        MIN_PLAYERS = 2,
        INTERMISSION_LENGTH = 15,
        ROUND_LENGTH = 300,
        PRIZE_AMOUNG = 100,

        NUM_SPAWN_POINT = 4
    },


    WeaponName = {
        M1911 = "M1911"
    },

    WeaponMode = {
        AUTO = "AUTO",
        SEMI = "SEMI"
    }

    Message = {
        WARN_NOT_ENOUGH_PLAYER = "Number of player required to start the game is:",
        WARN_GAME_GET_READY = "Get ready for the game",
        WARN_TIME_REMANING = "Time Remaning: ",
        
        INFO_PEOPLE_REMAINING = " remaining",
        INFO_NO_VICTORS = "There is no winner in this game",
        INFO_ANNOUCE_VICTORS = "The winner is:"


    }

}

return Define;