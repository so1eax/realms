local cam = nil

g_gamertags = false
g_invincible = false
g_noclip = false
_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Admin")
_menuPool:Add(mainMenu)
_menuPool:MouseControlsEnabled (false);
_menuPool:MouseEdgeEnabled (false);
_menuPool:ControlDisablingEnabled(false);


function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function adminmenu(menu)
    local pped = PlayerPedId()

    local gamertags = NativeUI.CreateCheckboxItem("Gamertags", g_gamertags)
    local invincible = NativeUI.CreateCheckboxItem("Invincible", g_invincible)
    local noclip = NativeUI.CreateCheckboxItem("NoCip", g_noclip)
    menu:AddItem(gamertags)
    menu:AddItem(invincible)
    menu:AddItem(noclip)
    menu.OnCheckboxChange = function(sender, item, checked_)
        if item == gamertags then
            g_gamertags = checked_
            SetEntityInvincible(pped, g_gamertags)
        end

        if item == invincible then
            g_invincible = checked_
        end
        
        if item == noclip then
            g_noclip = checked_
            SetEntityVisible(pped, not g_noclip)
            FreezeEntityPosition(pped, g_noclip)
    
            if not g_noclip then
                RenderScriptCams(false, false, 0, true, false)
                DestroyCam(cam, false)
                cam = nil
            else
                cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
            end
        end
    end
end

function RotationToDirection(rotation)
    local z = math.rad(rotation.z)
    local x = math.rad(rotation.x)
    local num = math.abs(math.cos(x))
    return vector3(-math.sin(z) * num, math.cos(z) * num, math.sin(x))
end

Citizen.CreateThread(function()
    local speed = 1.0

    while true do
        Citizen.Wait(1)
        local player = PlayerPedId()
        if g_gamertags then
            for k, v in pairs(GetActivePlayers()) do
                local p_ped = GetPlayerPed(v)
                local p_svid = GetPlayerServerId(v)
                print(GetPlayerName(p_svid))
            end
        end
        if g_noclip then
            local camRot = GetGameplayCamRot(2)
            local camForward = RotationToDirection(camRot)
            local coords = GetEntityCoords(player)
            local newX = coords.x
            local newY = coords.y
            local newZ = coords.z

            SetCamCoord(cam, coords.x, coords.y, coords.z)
            SetCamActive(cam, true)
            SetCamRot(cam, camRot.x, camRot.y, camRot.z, 2)
            RenderScriptCams(true, false, 0, true, true)

            ClearPedTasksImmediately(player)
            SetEntityRotation(player, camRot.x, camRot.y, camRot.z, 2)

            if IsControlPressed(0, 32) then -- W
                newX = newX + camForward.x * speed
                newY = newY + camForward.y * speed
                newZ = newZ + camForward.z * speed
            end

            if IsControlPressed(0, 33) then -- S
                newX = newX - camForward.x * speed
                newY = newY - camForward.y * speed
                newZ = newZ - camForward.z * speed
            end

            local camRight = vector3(-camForward.y, camForward.x, 0.0)
            if IsControlPressed(0, 34) then -- A
                newX = newX + camRight.x * speed
                newY = newY + camRight.y * speed
            end

            if IsControlPressed(0, 35) then -- D
                newX = newX - camRight.x * speed
                newY = newY - camRight.y * speed
            end

            SetEntityCoordsNoOffset(player, newX, newY, newZ, true, true, true)
        end
    end
end)

adminmenu(mainMenu)
_menuPool:RefreshIndex()

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        _menuPool:ProcessMenus()
        if IsControlJustPressed(1, 57) then
            mainMenu:Visible(not mainMenu:Visible())
        end
    end
end)