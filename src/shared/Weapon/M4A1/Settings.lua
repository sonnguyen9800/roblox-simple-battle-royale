
local defineModule = require(game.ServerScriptService.Server.Define)


local gunSettings = {
	fireMode = defineModule.WeaponMode.AUTO; --SEMI or AUTO
	damage = 25;
	headshotMultiplier = 1.5;
	rateOfFire = 600; --Rounds per minute
	range = 500;
	rayColor = Color3.fromRGB(255, 160, 75);
	raySize = Vector2.new(0.25, 0.25); --Width and height
	debrisTime = 0.075;
}

return gunSettings