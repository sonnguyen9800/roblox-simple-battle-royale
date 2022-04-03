
local defineModule = require(game.ServerScriptService.Server.Define)

local gunSettings = {
    fireMode = defineModule.WeaponMode.SEMI;
	damage = 25;
	headshotMultiplier = 1.5;
	rateOfFire = 300; --Rounds per minute
	range = 500;
	rayColor = Color3.fromRGB(255, 160, 75);
	raySize = Vector2.new(0.25, 0.25); --Width and height
	debrisTime = 0.05;
}

return gunSettings