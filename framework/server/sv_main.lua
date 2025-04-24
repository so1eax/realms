RegisterNetEvent("fmw:test")

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
    else
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

    MySQL.Async.execute('UPDATE users SET coords = @coords, health = @health WHERE identifier = @identifier', {['coords'] = json.encode(coords), ['health'] = GetEntityHealth(player_ped), ['identifier'] = identifier})

end

AddEventHandler("playerConnecting", playerConnecting)

AddEventHandler('playerDropped', playerDropped)
AddEventHandler('fmw:test', playerDropped)

RegisterCommand("ids", function (source, args, raw)
    for k, v in pairs(GetPlayers()) do
        local player_license = GetPlayerIdentifierByType(v, 'license')
        print(player_license)
    end
end)