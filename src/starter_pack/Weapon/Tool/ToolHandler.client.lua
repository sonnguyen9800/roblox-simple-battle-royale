local playersService = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local replicateRemote = replicatedStorage.Events.Replicate;
local hitRemote = replicatedStorage.Events.Hit;

local player = playersService.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local mouse = player:GetMouse();

local tool = script.Parent
local firePoint = tool:WaitForChild("ToolHandler")

local gunSettings = require(tool:WaitForChild("Settings"))
local equipped = false;


tool.Equipped:Connect(function()
    equipped = true;
end)

tool.Unequipped:Connect(function()
    equipped = false;
    
end)
