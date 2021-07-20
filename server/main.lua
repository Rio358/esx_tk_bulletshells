ESX = nil
TriggerEvent( 'esx:getSharedObject', function(obj) ESX = obj end)

local shells = {}

Citizen.CreateThread(function()
    MySQL.Async.fetchAll("SELECT coords, weapon, weaponType, time FROM bulletshells",{}, 
    function(result)
        for k,v in pairs(result) do
            local coords = json.decode(v.coords)
            table.insert(shells, {coords = coords, weapon = v.weapon, weaponType = v.weaponType, time = v.time})
        end
        MySQL.Async.execute("DELETE FROM bulletshells",{})
    end)
end)

Citizen.CreateThread(function()
	Citizen.Wait(60000)
	UpdateDatabase()
end)

function UpdateDatabase()
    MySQL.Async.execute("DELETE FROM bulletshells",{}, function(rowsChanged)
        if next(shells) ~= nil then
            for k,v in pairs(shells) do
                MySQL.Async.execute('INSERT INTO bulletshells (coords, weapon, weaponType, time) VALUES (@coords, @weapon, @weaponType, @time)', {
                    ['@coords']   = json.encode({x = v.coords.x, y = v.coords.y, z = v.coords.z}),
                    ['@weapon']   = v.weapon,
                    ['@weaponType']   = v.weaponType,
                    ['@time']    = v.time
                })
            end
        end
    end)
    SetTimeout(60000, UpdateDatabase)
end

ESX.RegisterServerCallback('esx_tk_bulletshells:getShells', function(source, cb)
    cb(shells)
end)

RegisterServerEvent('esx_tk_bulletshells:saveShell')
AddEventHandler('esx_tk_bulletshells:saveShell', function(coords, weapon, weaponType)
    table.insert(shells, {coords = coords, weapon = weapon, weaponType = weaponType, time = 0})
end)

RegisterServerEvent('esx_tk_bulletshells:removeShell')
AddEventHandler('esx_tk_bulletshells:removeShell', function(id)
    shells[id] = nil
    TriggerClientEvent('esx_tk_bulletshells:removeDrawShell', -1, id)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(shells) do
            if v.time == nil then
                v.time = 0
            end
            v.time = v.time + 1
            if v.time >= Config.DisappearTime then
                TriggerEvent('esx_tk_bulletshells:removeShell', k)
            end
        end
    end
end)
