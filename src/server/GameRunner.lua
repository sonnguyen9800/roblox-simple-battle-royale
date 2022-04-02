local players = game:GetService("Players")
local replicatedStorage = game:GetService("ReplicatedStorage")

local dataModule = require(script.Parent.Data)
local defineModule = require(script.Parent.Define)

local random = Random.new()
local message = replicatedStorage.Message;
local remaining = replicatedStorage.Remaining;

local gameRunner = {}
local competitors = {}





return gameRunner