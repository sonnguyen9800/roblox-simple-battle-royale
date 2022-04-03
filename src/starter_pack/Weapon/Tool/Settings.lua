
local defineModule = require(game.ServerScriptService.Server.Define)

local gunSettings = {
    fireMode = defineModule.WeaponMode.SEMI;
    damage = 5;
    headshotMultiplier = 1.5;
    rateOfFire = 300;
    range = 500;
    rayColor = Color3.fromRGB(255, 160, 75);
    raySize = Vector2.new(0.25, 0.25);
    debrisTime = 0.05;
}


return gunSettings;