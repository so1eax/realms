-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

MySQL.ready(function()
	MySQL.Sync.execute(
		"CREATE TABLE IF NOT EXISTS `outfits` (" ..
			"`id` int NOT NULL AUTO_INCREMENT, " ..
			"`identifier` varchar(60) NOT NULL, " ..
			"`name` longtext, " ..
			"`ped` longtext, " ..
			"`components` longtext, " ..
			"`props` longtext, " ..
			"PRIMARY KEY (`id`), " ..
			"UNIQUE KEY `id_UNIQUE` (`id`) " ..
		") ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8; "
	)
end)

-- Events

RegisterServerEvent('fivem-appearance:save')
AddEventHandler('fivem-appearance:save', function(appearance)
	local identifier = GetPlayerIdentifierByType(source, 'license')
	MySQL.update('UPDATE users SET skin = ? WHERE identifier = ?', {json.encode(appearance), identifier})
end)

RegisterServerEvent("fivem-appearance:saveOutfit")
AddEventHandler("fivem-appearance:saveOutfit", function(name, pedModel, pedComponents, pedProps)
	local source = source
	local identifier = GetPlayerIdentifierByType(source, 'license')
	MySQL.insert.await('INSERT INTO outfits (identifier, name, ped, components, props) VALUES (?, ?, ?, ?, ?)', {identifier, name, json.encode(pedModel), json.encode(pedComponents), json.encode(pedProps)})
end)

RegisterServerEvent("fivem-appearance:deleteOutfit")
AddEventHandler("fivem-appearance:deleteOutfit", function(id)
	MySQL.Async.execute('DELETE FROM `outfits` WHERE `id` = @id', {
		['@id'] = id
	})
end)

-- Callbacks

lib.callback.register('fivem-appearance:getPlayerSkin', function(source)
	local identifier = GetPlayerIdentifierByType(source, 'license')
	local users = MySQL.query.await('SELECT skin FROM outfits users identifier = ?', {identifier})
	if users then
		local user, appearance = users[1]
		if user.skin then
			appearance = json.decode(user.skin)
		end
	end
	return appearance
end)

lib.callback.register('fivem-appearance:payFunds', function(source, price)
	return true
end)

lib.callback.register('fivem-appearance:getOutfits', function(source)
	local identifier = GetPlayerIdentifierByType(source, 'license')
    local outfits = {}
    local result = MySQL.query.await('SELECT * FROM outfits WHERE identifier = ?', {identifier})
	if result then
		for i=1, #result, 1 do
			outfits[#outfits + 1] = {
				id = result[i].id,
				name = result[i].name,
				ped = json.decode(result[i].ped),
				components = json.decode(result[i].components),
				props = json.decode(result[i].props)
			}
		end
		return outfits
	else
		return false
	end
end)