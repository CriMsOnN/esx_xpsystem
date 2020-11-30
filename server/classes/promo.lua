createPromo = function(source, promo, xp)
    local identifier = GetPlayerIdentifier(source, 0)
    local player_name = GetPlayerName(source)
    MySQL.Async.execute("INSERT INTO promo_codes(`identifier`, `player_name`, `promo_code`, `xp`) VALUES(@identifier, @player_name, @promo_code, @promo_xp)", {
        ['identifier'] = identifier,
        ['player_name'] = player_name,
        ['promo_code'] = promo,
        ['promo_xp'] = tonumber(xp)
    }, function(result)
        TriggerClientEvent("chatMessage", source, "[PromoCode]", {150, 10, 0}, "Code created: ~r~"..promo.."~s~")
    end)
end


checkPromo = function(source, promo)
    local identifier = GetPlayerIdentifier(source, 0)

    MySQL.Async.fetchAll("SELECT * FROM promo_codes WHERE promo_code = @promo", {
        ['promo'] = promo
    }, function(result)
        if result[1] ~= nil then
            if not result[1].used then
                MySQL.Async.execute("UPDATE promo_codes SET used = @used WHERE promo_code = @promo", {
                    ['used'] = true,
                    ['promo'] = promo
                })
                Player.PlayerData[source].xp = Player.PlayerData[source].xp + result[1].xp
                TriggerClientEvent("chatMessage", source, "[Promo Code]", {200, 20, 0}, "You have successfully redeem the code and got ~g~"..result[1].xp.."~s~")
                TriggerClientEvent("xp_system:client:updateHUD", source, Player.PlayerData[source])
                MySQL.Async.execute("DELETE FROM promo_codes WHERE promo_code = @promo", {
                    ['promo'] = promo
                })
            else
                TriggerClientEvent("chatMessage", source, "[Promo Code]", {220, 20, 0}, "Promo code is already used!")
            end
        else
            TriggerClientEvent("chatMessage", source, "[Promo Code]", {220, 20, 0}, "Promo code doesnt exist")
        end
    end)
end