local spawned = true
local MenuIsOpened = false

AddEventHandler("playerSpawned", function()
    spawned = true
    TriggerServerEvent("xp_system:server:getPlayerXP")
end)

RegisterNetEvent("xp_system:client:startInterval")
AddEventHandler("xp_system:client:startInterval", function()
    addXP()
end)


RegisterCommand("showxp", function(source, args, raw)
    TriggerServerEvent("xp_system:server:retrievePlayerXP")
    MenuIsOpened = not MenuIsOpened
end)

RegisterNetEvent("xp_system:client:retrievePlayerXP")
AddEventHandler("xp_system:client:retrievePlayerXP", function(player)
    if MenuIsOpened then
        local items = {}
        for k,v in ipairs(Config.Items) do
            table.insert(items, v)
        end
        SendNUIMessage({
            action = "show",
            xp = player.xp,
            items = items
        })
        SetNuiFocus(true, true)
    end
end)

RegisterNetEvent("xp_system:client:updateHUD")
AddEventHandler("xp_system:client:updateHUD", function(player)
    SendNUIMessage({
        action = "updateHUD",
        xp = player.xp
    })
end)

RegisterNUICallback("giveItem", function(item)
    TriggerServerEvent("xp_system:server:giveItem", item.giveItem)
end)

RegisterNUICallback("givePromo", function(promo)
    TriggerServerEvent("xp_system:server:getPromo", promo.data)
end)

RegisterNUICallback("close", function()
    SendNUIMessage({
        action = "close"
    })
    SetNuiFocus(false, false)
    PlaySoundFrontend(-1, "QUIT", "HUD_FRONTEND_DEFAULT_SOUNDSET")
    MenuIsOpened = false
end)

RegisterNetEvent("xp_system:client:sendNotification")
AddEventHandler("xp_system:client:sendNotification", function()
    SendNUIMessage({
        action = "notify",
        xp = Config.RewardXp
    })
end)

RegisterCommand("test", function()
    TriggerEvent("xp_system:client:sendNotification")
end)

function addXP()
    TriggerServerEvent("xp_system:server:addPlayerXP")
    TriggerEvent("xp_system:client:sendNotification")
    SetTimeout(Config.RewardTime * 10 * 100, addXP)
end


AddEventHandler("onResourceStart", function()
    Citizen.Wait(5000)
    TriggerServerEvent("xp_system:server:getPlayerXP")
end)
