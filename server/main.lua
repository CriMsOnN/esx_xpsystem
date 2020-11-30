RegisterServerEvent("xp_system:server:getPlayerXP")
AddEventHandler("xp_system:server:getPlayerXP", function()
    local _source = source
    local identifier = GetPlayerIdentifier(source, 0)
    getPlayerXP(_source, identifier)
end)

RegisterServerEvent("xp_system:server:addPlayerXP")
AddEventHandler("xp_system:server:addPlayerXP", function()
    local _source = source
    addPlayerXP(_source)
end)

RegisterCommand("test", function(source, args, raw)
    local identifier = GetPlayerIdentifier(source, 0)
    getPlayerXP(source, identifier)
end)


RegisterServerEvent("xp_system:server:retrievePlayerXP")
AddEventHandler("xp_system:server:retrievePlayerXP", function()
    local _source = source
    local player = retrievePlayerXP(_source)
    TriggerClientEvent("xp_system:client:retrievePlayerXP", _source, player)
end)


function printToServer(text)
    print("[^1XP-SYSTEM^7] " ..text .. ": ^2true^7")
end