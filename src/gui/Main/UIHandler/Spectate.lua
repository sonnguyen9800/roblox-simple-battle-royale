local replicatedStorage =game:GetService("ReplicatedStorage")
local playerService = game:GetService("Players")
local player = playerService.LocalPlayer
local cam = workspace.CurrentCamera


local spectate = {}
local gui = script.Parent.Parent
local spectateFrame = gui:WaitForChild("Spectate")
local toggle = gui:WaitForChild("Toggle")
local nameLabel = spectateFrame:WaitForChild("NameLabel")
local nextPlayer = spectateFrame:WaitForChild("NextPlayer")
local lastPlayer = spectateFrame:WaitForChild("LastPlayer")


local competitors = {}
local curIndex = 1
local spectating = false
spectateFrame.Visible = false



return spectate