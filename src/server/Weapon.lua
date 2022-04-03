local playerServices = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")


local hitRemote = replicatedStorage.Events.Hit
local replicateRemote = replicatedStorage.Events.Replicate

local dataModule = require(script.Parent.Data)
local defineModule = require(script.Parent.Define)

local weaponsModule = {}

-- Public

---- Verify player be hit
weaponsModule.playerFromHit = function(hit)
    local char = hit:FindFirstAncestorOfClass("Model")
    local player = playerServices:GetPlayerFromCharacter(char)

    return player, char
end

-- Verify hit
local function verifyHit(hit, direction, origin, relCframe, gunSettings)
    local target = (hit.CFrame).p
    
    
end







return weaponsModule