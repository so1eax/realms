-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

closeMenu = function()
    RenderScriptCams(false, false, 0, true, true)
    DestroyAllCams(true)
    DisplayRadar(true)
    SetNuiFocus(false, false)
    SetEntityInvincible(PlayerPedId(), false)

    SetNuiFocus(false, false)
    SendNUIMessage{
        type = 'appearance_hide',
        payload = {}
    }
end

addCommas = function(n)
	return tostring(math.floor(n)):reverse():gsub("(%d%d%d)","%1,")
								  :gsub(",(%-?)$","%1"):reverse()
end

createBlip = function(coords, sprite, color, text, scale)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)
end

consolidateShops = function()
    local shops = {}
    for _,v in ipairs(Config.ClothingShops) do
        shops[#shops + 1] = {coords = v.coords, distance = v.distance, price = v.price, store = 'clothing'}
    end
    for _,v in ipairs(Config.BarberShops) do
        shops[#shops + 1] = {coords = v.coords, distance = v.distance, price = v.price, store = 'barber'}
    end
    for _,v in ipairs(Config.TattooShops) do
        shops[#shops + 1] = {coords = v.coords, distance = v.distance, price = v.price, store = 'tattoo'}
    end
    return shops
end

showTextUI = function(store)
    if store == 'clothing' then
        store = Strings.clothing_menu
    elseif store == 'barber' then
        store = Strings.barber_menu
    else
        store = Strings.tattoo_menu
    end
    return store
end

openShop = function(store, price)
    local ped = cache.ped
    local currentAppearance = exports['fivem-appearance']:getPedAppearance(ped)
    local tetovaze = exports['fivem-appearance']:getPedTattoos(ped)
    currentAppearance.tattoos = tetovaze
    local config = {}
    InMenu = true
    if store == 'clothing' then
        TriggerEvent('fivem-appearance:clothingShop', price)
    else
        if store == 'clothing_menu' then 
            config = {
                ped = false,
                headBlend = false,
                faceFeatures = false,
                headOverlays = false,
                components = true,
                props = true,
                tattoos = false
            }
        elseif store == 'barber' then
            config = {
                ped = false,
                headBlend = true,
                faceFeatures = true,
                headOverlays = true,
                components = false,
                props = false,
                tattoos = false
            }
        elseif store == 'tattoo' then 
            config = {
                ped = false,
                headBlend = false,
                faceFeatures = false,
                headOverlays = false,
                components = false,
                props = false,
                tattoos = true
            }
        end
        exports['fivem-appearance']:startPlayerCustomization(function (appearance)
            if (appearance) then
		if json.encode(appearance.tattoos) == '[]' then
                    appearance.tattoos = tetovaze
                end
                if price then
                    local paid = lib.callback.await('fivem-appearance:payFunds', 100, price)                    
                    if paid then
                        lib.notify({
                            title = Strings.success,
                            description = (Strings.success_desc):format(addCommas(price)),
                            duration = 3500,
                            icon = 'basket-shopping',
                            type = 'success'
                        })
                        TriggerServerEvent('fivem-appearance:save', appearance)
                        InMenu = false
                    else
                        lib.notify({
                            title = Strings.no_funds,
                            description = Strings.no_funds_desc,
                            duration = 3500,
                            icon = 'ban',
                            type = 'error'
                        })                           
                        exports['fivem-appearance']:setPlayerAppearance(currentAppearance)
                        InMenu = false
                        TriggerServerEvent('fivem-appearance:save',currentAppearance)
                    end
                else
                    TriggerServerEvent('fivem-appearance:save', appearance)
                    InMenu = false
                end
            else
                inMenu = false
            end
        end, config)
    end
end

openWardrobe = function()
    local outfits = lib.callback.await('fivem-appearance:getOutfits', 100)
    local Options = {}
    if outfits then
        Options = {}
        for i=1, #outfits do
            Options[#Options + 1] = {
                title = outfits[i].name,
                event = 'fivem-appearance:setOutfit',
                args = {
                    ped = outfits[i].ped,
                    components = outfits[i].components,
                    props = outfits[i].props
                }
            }
        end
    else
        Options = {
            {
                title = Strings.go_back_desc,
                event = ''
            }
        }
    end
    lib.registerContext({
        id = 'wardrobe_menu',
        title = Strings.wardrobe_title,
        options = Options
    })
    lib.showContext('wardrobe_menu')
end

exports('openWardrobe', openWardrobe)