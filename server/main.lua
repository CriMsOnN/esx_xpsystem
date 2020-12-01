ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

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

RegisterServerEvent("xp_system:server:giveItem")
AddEventHandler("xp_system:server:giveItem", function(item)
    local _source = source
    local identifier = GetPlayerIdentifier(_source, 0)
    local xPlayer = ESX.GetPlayerFromId(_source)
    for k,v in pairs(Config.Items) do
        if (v.name == item) then
            if (v.item == "item_standard") then
                    if xPlayer.canCarryItem(v.name, 1) then
                        print("works")
                    end
            elseif (v.item == "item_weapon") then
                if (Player.PlayerData[_source].xp >= v.price) then
                    if not xPlayer.hasWeapon(v.name) then
                        xPlayer.addWeapon(v.name, v.ammo)
                        Player.PlayerData[_source].xp = Player.PlayerData[_source].xp - v.price
                        TriggerClientEvent("xp_system:client:updateHUD", _source, Player.PlayerData[_source])
                        xPlayer.showNotification("You have successfully purchased ~g~" .. v.name .. "~s~", true, false, 140)
                        break
                    else
                        xPlayer.addWeaponAmmo(v.name, v.ammo)
                        Player.PlayerData[_source].xp = Player.PlayerData[_source].xp - v.price
                        xPlayer.showNotification("You successfully purchased ammo for  ~g~" .. v.name .. "~s~", true, false, 140)
                        break
                    end
                else
                    xPlayer.showNotification("You don't have enough XP points", true, false, 140)
                    break
                end
            end
        end
    end
end)

AddEventHandler("playerDropped", function()
    local _source = source
    local identifier = GetPlayerIdentifier(_source, 0)
    MySQL.Async.execute("UPDATE exp_system SET xp = @xp WHERE identifier = @identifier", {
            ['xp'] = Player.PlayerData[_source].xp,
            ['identifier'] = identifier
        }, function(rows)
        if rows then
            return
        end
    end)
end)



RegisterServerEvent("xp_system:server:retrievePlayerXP")
AddEventHandler("xp_system:server:retrievePlayerXP", function()
    local _source = source
    local player = retrievePlayerXP(_source)
    TriggerClientEvent("xp_system:client:retrievePlayerXP", _source, player)
end)

RegisterServerEvent("xp_system:server:getPromo")
AddEventHandler("xp_system:server:getPromo", function(promo)
    local _source = source
    checkPromo(source, promo)
end)

--[[
    Commands
]]

RegisterCommand("createpromo", function(source, args, raw)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    if (group == "admin" or group == "superadmin" or group == "moderator" or group == "user") then
        if args[1] ~= nil then
            if args[2] ~= nil then
                local promo = args[1]
                local xp = args[2]
                createPromo(source, promo, xp)
            else
                TriggerClientEvent("chatMessage", source, "[Promo Code]", {220, 0, 0}, "Invalid Arguments ( createpromo code xp )")
            end
        else
            TriggerClientEvent("chatMessage", source, "[Promo Code]", {220, 0, 0}, "Invalid Arguments ( createpromo code xp )")
        end
    else
        TriggerClientEvent("chatMessage", source, "[Promo Code]", {220, 0, 0}, "You dont have access for this command")
    end

end, false)

AddEventHandler("onResourceStop", function(resource)
    for k,v in pairs(Player.PlayerData) do
        MySQL.Async.execute("UPDATE exp_system SET xp = @xp WHERE identifier = @identifier", {
            ['xp'] = v.xp,
            ['identifier'] = v.identifier
        }, function(rows)
           if rows then
                print("SAVED")
           end
        end)
    end
end)

function printToServer(text)
    print("[^1XP-SYSTEM^7] " ..text .. ": ^2true^7")
end

function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            s = s .. '['..k..'] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end
