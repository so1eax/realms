-- client
RegisterCommand("id", function(source)
    local psid = GetPlayerServerId(PlayerId())
    local uid = exports.framework:GetPlayerData(psid).id
    print("SID: " .. psid .. " | UID: " .. uid)
end)

RegisterCommand("coords", function()
    local ppped = PlayerPedId()
    local coords = GetEntityCoords(pped)
    print(coords)
end, false)

RegisterCommand("bring", function(source, args)
    if(args[1]) then
        local pid = GetPlayerFromServerId(args[1])
        if pid ~= -1 then
            local pped = GetPlayerPed(pid)
            if IsEntityAPed(pped) then
                TriggerServerEvent('framework:sv:commands:bring', args[1])
            else
                print("invalid entity")
            end
        else
            print("invalid player")
        end
    else
        print("no args found")
    end
end, false)

RegisterCommand("bringback", function(source, args)
    if(args[1]) then
        local pid = GetPlayerFromServerId(args[1])
        if pid ~= -1 then
            local pped = GetPlayerPed(pid)
            if IsEntityAPed(pped) then
                TriggerServerEvent('framework:sv:commands:bringback', args[1])
            else
                print("invalid entity")
            end
        else
            print("invalid player")
        end
    else
        print("no args found")
    end
end, false)

RegisterCommand("wipe", function(source, args)
    if(args[1]) then
        TriggerServerEvent('framework:sv:main:wipe', args[1])
    else
        print("no args found")
    end
end, false)

-- admin
RegisterCommand("coords", function()
end, false)

RegisterCommand("coords", function()
end, false)

RegisterCommand("coords", function()
end, false)