local spawned = true
local MenuIsOpened = false

AddEventHandler("playerSpawned", function()
    spawned = true
    TriggerServerEvent("xp_system:server:getPlayerXP")
    Citizen.Wait(5000)
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

function addXP()
    TriggerServerEvent("xp_system:server:addPlayerXP")
    SetTimeout(Config.RewardTime * 10 * 1000, addXP)
end


AddEventHandler("onResourceStart", function()
    TriggerServerEvent("xp_system:server:getPlayerXP")
end)
