RegisterServerEvent("identity:sv:check_license")
RegisterServerEvent("identity:sv:register")
RegisterServerEvent("identity:sv:save_appearance")

local function check_license()
    print(source)
    local player = source
    local identifier = GetPlayerIdentifierByType(player, 'license')

    while not MySQL do
        Wait(100)
    end

    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", { ['identifier'] = identifier }, function(result)
        if (not result[1]) then
            TriggerClientEvent("identity:cl:register", player)
        else if result[1].wipe then
            TriggerClientEvent("identity:cl:register", player)
        else
            SetPlayerRoutingBucket(player, 0)
            TriggerClientEvent("identity:cl:login", player, result[1])
        end
        end
    end)
end

local function register(data)
    local player = source
    local identifier = GetPlayerIdentifierByType(player, 'license')

    while not MySQL do
        Wait(100)
    end

    local registered = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", { ['identifier'] = identifier })

    SetPlayerRoutingBucket(player, player)

    if (not registered[1]) then
        local executed = MySQL.Sync.execute('INSERT INTO users (identifier, prename, name, dob, height, wipe) VALUES (@identifier, @prename, @name, @dob, @height, 0)',
            {['identifier'] = identifier, ['prename'] = data.prename, ['name'] = data.name, ['dob'] = data.dob, ['height'] = data.height}
        )

        if executed then
            TriggerClientEvent("identity:cl:finish_register", player)
        end
    else if registered[1].wipe then
        local executed = MySQL.Sync.execute('UPDATE users SET prename = ?, name = ?, dob = ?, height = ?, health = ?, coords = ?, appearance = ?, cash = 0, bank = 0, items = ?, admrk = DEFAULT, wipe = 1  WHERE id = @uid', {['uid'] = player})

        if executed then
            TriggerClientEvent("identity:cl:finish_register", player)
        end
    end
    end
end

local function save_appearance(appearance)
    local player = source
    local identifier = GetPlayerIdentifierByType(player, 'license')

    while not MySQL do
        Wait(100)
    end

    MySQL.Async.execute('UPDATE users SET appearance = @appearance WHERE identifier = @identifier', {['appearance'] = json.encode(appearance), ['identifier'] = identifier})
end

AddEventHandler("identity:sv:register", register)
AddEventHandler("identity:sv:check_license", check_license)
AddEventHandler("identity:sv:save_appearance", save_appearance)