Player = {}
Player.PlayerData = {}

getPlayerXP = function(source, identifier)
    MySQL.Async.fetchAll('SELECT * FROM exp_system WHERE identifier = @identifier', {['identifier'] = identifier }, function(result)
        if (result[1] ~= nil) then
            Player.PlayerData[source] = {identifier = identifier, xp = result[1].xp}
            printToServer("Player Found")
        else
            createPlayerXP(source, identifier)
        end
    end)
end

retrievePlayerXP = function(source)
    return Player.PlayerData[source]
end

addPlayerXP = function(source)
    local identifier = GetPlayerIdentifier(source, 0)
    local localXP = Player.PlayerData[source].xp
    local newXP = (localXP + Config.RewardXP)

    MySQL.Async.execute("UPDATE exp_system SET xp = @xp WHERE identifier = @identifier", {
        ['xp'] = newXP,
        ['identifier'] = identifier
    }, function(rows)
        if rows then
            printToServer(GetPlayerName(source) .. " Player xp updated")
            Player.PlayerData[source].xp = newXP
        end
    end)
end

createPlayerXP = function(source, identifier)
    Player.PlayerData[source] = {identifier = identifier, xp = 0}
    MySQL.Async.execute("INSERT INTO exp_system(`identifier`, `xp`) VALUES(@identifier, @xp)", {
        ['identifier'] = identifier,
        ['xp'] = 0
    })
    printToServer("Creating New Player")
end