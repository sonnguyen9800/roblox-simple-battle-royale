for _, module in pairs(script:GetAllChildren()) do
    
    local loadModule = coroutine.create(function()
        require(module)
    end)

    coroutine.resume(loadModule)

end