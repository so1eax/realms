exports('GetPlayerData', function()
    local player = source
    local identifier = GetPlayerIdentifierByType(player, 'license')
    local data = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", { ['identifier'] = identifier })

    return data[1]
end)