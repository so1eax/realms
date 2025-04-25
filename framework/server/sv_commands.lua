RegisterNetEvent('framework:sv:commands:bring')
RegisterNetEvent('framework:sv:commands:bringback')

local players = {}

local function bring(id)
    local s_pid = GetPlayerPed(source)
    local s_coords = GetEntityCoords(s_pid)
    local pid = GetPlayerPed(id)
    local coords = GetEntityCoords(pid)

    players[id] = {
        coords = coords
    }
    
    SetEntityCoords(pid, coords.x, coords.y, coords.z)
end

local function bringback(id)
    if players[id] then
        local pid = GetPlayerPed(id)
        local coords = players[id].coords
    
        players[id] = {
            coords = coords
        }
        
        SetEntityCoords(pid, coords.x, coords.y, coords.z)
    end

    players[id] = nil
end

AddEventHandler('framework:sv:commands:bring', bring)
AddEventHandler('framework:sv:commands:bringback', bringback)