RegisterNetEvent("fmw:test")
RegisterNetEvent('framework:sv:exports:server_callbacks:trigger')
RegisterNetEvent('framework:sv:main:wipe')

local server_callbacks = {}

local function isBanned(id)
    
end

local function playerConnecting(name, setKickReason, deferrals)
    local player = source
    local license = GetPlayerIdentifierByType(player, 'license')
    local connected_license

    deferrals.defer()

    Wait(0)

    deferrals.update("License en cours de verification ...")

    for k, v in pairs(GetPlayers()) do
        local player_license = GetPlayerIdentifierByType(v, 'license')

        if (license == player_license) then
            connected_license = player_license
            break
        end
    end

    if (license == connected_license) then
        deferrals.done("Votre license est déja connectée au serveur")
    else if isBanned(player)
        deferrals.done()
    end
end

local function playerDropped()
    local player = source
    local identifier = GetPlayerIdentifierByType(player, 'license')
    local player_ped = GetPlayerPed(player)
    local entity_coords = GetEntityCoords(player_ped)
    local coords = {
        x = entity_coords.x,
        y = entity_coords.y,
        z = entity_coords.z,
    }

    while not MySQL do
        Wait(100)
    end
    
    MySQL.Async.execute('UPDATE users SET coords = @coords, health = @health WHERE identifier = @identifier', {['coords'] = json.encode(coords), ['health'] = GetEntityHealth(player_ped), ['identifier'] = identifier})
end

local function register_server_callback(name, fn)
    server_callbacks[name] = fn
end

register_server_callback("GetPlayerData", function(source, cb, pid)
    local player = pid
    local data = exports['framework']:GetPlayerData(player)
    cb(data)
end)

local function triggerservercallback(name, callbackid, ...)
    local src = source

    if server_callbacks[name] then
        server_callbacks[name](src, function(...)
            TriggerClientEvent('framework:cl:exports:server_callbacks:response', src, callbackid, ...)
        end, ...)
    else
        TriggerClientEvent('framework:cl:exports:server_callbacks:response', src,  callbackid, nil)   
    end
end

local function wipeplayer(uid)
    local player = uid
    while not MySQL do
        Wait(100)
    end

    MySQL.Async.execute('UPDATE users SET prename = ?, name = ?, dob = ?, height = ?, health = ?, coords = ?, appearance = ?, cash = 0, bank = 0, items = ?, admrk = DEFAULT, wipe = 1  WHERE id = @uid', {['uid'] = player})

    local id = exports.framework:GetPlayerIDFromUID(player)
    if id then
        DropPlayer(id, "Vous avez été wipe par un membre du staff")
    else
        print("player not online")    
    end
end

AddEventHandler("playerConnecting", playerConnecting)

AddEventHandler('playerDropped', playerDropped)
AddEventHandler('fmw:test', playerDropped)
AddEventHandler('framework:sv:exports:server_callbacks:trigger', triggerservercallback)
AddEventHandler('framework:sv:main:wipe', wipeplayer)

RegisterCommand("ids", function (source, args, raw)
    for k, v in pairs(GetPlayers()) do
        local player_license = GetPlayerIdentifierByType(v, 'license')
        print(player_license)
    end
end)