exports('GetPlayerData', function(pid)
    local player = pid
    local identifier = GetPlayerIdentifierByType(player, 'license')
    
    while not MySQL do
        Wait(100)
    end

    local data = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", { ['identifier'] = identifier })

    return data[1]
end)

exports('GetPlayerDataFromUID', function(uid)
    local player = uid

    while not MySQL do
        Wait(100)
    end

    local data = MySQL.Sync.fetchAll("SELECT * FROM users WHERE id = @player", { ['player'] = player })

    return data[1]
end)

exports('SetPlayerMoney', function(pid, type, amount)
    local player = pid
    local identifier = GetPlayerIdentifierByType(player, 'license')

    while not MySQL do
        Wait(100)
    end

    if type == "cash" then
        MySQL.Async.execute('UPDATE users SET cash = @amount WHERE identifier = @identifier', {['amount'] = amount, ['identifier'] = identifier})
    else if type == "bank" then
        MySQL.Async.execute('UPDATE users SET bank = @amount WHERE identifier = @identifier', {['amount'] = amount, ['identifier'] = identifier})
    end
    end
end)

exports('AddPlayerMoney', function(pid, type, amount)
    local player = pid
    local identifier = GetPlayerIdentifierByType(player, 'license')

    while not MySQL do
        Wait(100)
    end

    if type == "cash" then
        MySQL.Async.execute('UPDATE users SET cash = cash + @amount WHERE identifier = @identifier', {['amount'] = amount, ['identifier'] = identifier})
    else if type == "bank" then
        MySQL.Async.execute('UPDATE users SET bank = bank + @amount WHERE identifier = @identifier', {['amount'] = amount, ['identifier'] = identifier})
    end
    end
end)

exports('RemovePlayerMoney', function(pid, type, amount)
    local player = pid
    local identifier = GetPlayerIdentifierByType(player, 'license')

    while not MySQL do
        Wait(100)
    end

    if type == "cash" then
        MySQL.Async.execute('UPDATE users SET cash = cash - @amount WHERE identifier = @identifier', {['amount'] = amount, ['identifier'] = identifier})
    else if type == "bank" then
        MySQL.Async.execute('UPDATE users SET bank = bank - @amount WHERE identifier = @identifier', {['amount'] = amount, ['identifier'] = identifier})
    end
    end
end)