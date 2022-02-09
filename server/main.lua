local shells = {}

CreateThread(function()
    MySQL.query("SELECT coords, weapon, weaponType, time FROM bulletshells",{}, 
    function(result)
        for k,v in pairs(result) do
            local coords = json.decode(v.coords)
            table.insert(shells, {coords = coords, weapon = v.weapon, weaponType = v.weaponType, time = v.time})
        end
        MySQL.query("DELETE FROM bulletshells",{})
    end)
end)

CreateThread(function()
	Wait(60000)
	UpdateDatabase()
end)

function UpdateDatabase()
    MySQL.query("DELETE FROM bulletshells",{}, function(rowsChanged)
        if next(shells) ~= nil then
            for k,v in pairs(shells) do
                MySQL.query('INSERT INTO bulletshells (coords, weapon, weaponType, time) VALUES (?, ?, ?, ?)', { json.encode({x = v.coords.x, y = v.coords.y, z = v.coords.z}), v.weapon, v.weaponType, v.time })
            end
        end
    end)
    SetTimeout(60000, UpdateDatabase)
end

ESX.RegisterServerCallback('bulletshells:getShells', function(source, cb)
    cb(shells)
end)

RegisterServerEvent('bulletshells:saveShell')
AddEventHandler('bulletshells:saveShell', function(coords, weapon, weaponType)
    table.insert(shells, {coords = coords, weapon = weapon, weaponType = weaponType, time = 0})
end)

RegisterServerEvent('bulletshell:GiveEvidence')
AddEventHandler('bulletshell:GiveEvidence', function(data)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local metadata = data
    xPlayer.addInventoryItem('shellcasing',1,{description=metadata})
end)

RegisterServerEvent('bulletshells:removeShell')
AddEventHandler('bulletshells:removeShell', function(id)
    shells[id] = nil
    TriggerClientEvent('bulletshells:removeDrawShell', -1, id)
end)

CreateThread(function()
    while true do
        Wait(1000)
        for k,v in pairs(shells) do
            if v.time == nil then
                v.time = 0
            end
            v.time = v.time + 1
            if v.time >= Config.DisappearTime then
                TriggerEvent('bulletshells:removeShell', k)
            end
        end
    end
end)
