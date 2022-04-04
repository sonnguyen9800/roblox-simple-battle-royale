local replicatedStorage =game:GetService("ReplicatedStorage")
local playerService = game:GetService("Players")
local player = playerService.LocalPlayer
local cam = workspace.CurrentCamera


local spectateModule = {}
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


-- Client

local getCompetitorsRemoteFunction = replicatedStorage.Events.GetCompetitors
local updateCompetitorsRemoteFunction = replicatedStorage.Events.UpdateCompetitors


spectateModule.getCompetitorsRemoteFunction = function()
    competitors = getCompetitorsRemoteFunction:InvokeServer()
end

updateCompetitorsRemoteFunction.OnClientEvent:Connect(function(list)
    competitors = list
    for _, competitor in pairs(competitors) do
        if competitor == player then
            toggle.Visible = false

            if spectating then
                spectateModule.toggleSpectate()
            end
            return
        end
    end

    if spectating then
        spectateModule.focusCamera(player)
    end
end)

spectateModule.toggleSpectate = function()
	if not spectating then
		spectating = true
		spectateModule.getCompetitors()
		spectateFrame.Visible = true
		local targetPlayer = competitors[1]
		spectateModule.focusCamera(targetPlayer)
	else
		spectating = false
		spectateFrame.Visible = false
		spectateModule.focusCamera(player)
	end
end

spectateModule.focusCamera = function(targetPlayer)
	if #competitors == 0 and spectating then
		spectateModule.toggleSpectate()
	else
		if targetPlayer then
			cam.CameraSubject = targetPlayer.Character
			nameLabel.Text = targetPlayer.Name
		else
			spectateModule.getCompetitorsRemoteFunction()
			local newTargetPlayer = competitors[1]
			spectateModule.focusCamera(newTargetPlayer)
		end
	end
end

-- Mouse

toggle.MouseButton1Click:Connect(function()
    spectateModule.toggleSpectate()
end)

nextPlayer.MouseButton1Click:Connect(function()
    spectateModule.getCompetitors()
    curIndex = curIndex + 1

    if curIndex > #competitors then
        curIndex = 1
    end

    local targetPlayer = competitors[curIndex]
    spectateModule.focusCamera(targetPlayer)
end)

lastPlayer.MouseButton1Click:Connect(function()
    spectateModule.getCompetitors()
    curIndex = curIndex - 1

    if curIndex < 1 then
        curIndex = #competitors
    end

    local targetPlayer = competitors[curIndex]
    spectateModule.focusCamera(targetPlayer)
end)

return spectateModule
