for _, module in pairs(script:GetChildren()) do
    local loadModule = coroutine.create(function()
        require(module)
    end)

    coroutine.resume(loadModule);
end