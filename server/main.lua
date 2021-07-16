ESX = nil
TriggerEvent( 'esx:getSharedObject', function(obj) ESX = obj end)

local shells = {}

ESX.RegisterServerCallback('esx_bulletshells:getShells', function(source, cb)
    cb(shells)
end)

RegisterServerEvent('esx_bulletshells:saveShell')
AddEventHandler('esx_bulletshells:saveShell', function(coords, weapon)
    table.insert(shells, {coords = coords, weapon = weapon, time = 0})
end)

RegisterServerEvent('esx_bulletshells:removeShell')
AddEventHandler('esx_bulletshells:removeShell', function(id)
    shells[id] = nil
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
                TriggerServerEvent('esx_bulletshells:removeShell', k)
            end
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    for k,v in pairs(shells) do
        MySQL.Async.execute('INSERT INTO bulletshells (coords, weapon, time) VALUES (@coords, @weapon, @time)', {
            ['@coords']   = json.encode({x = v.coords.x, y = v.coords.y, z = v.coords.z}),
            ['@weapon']   = v.weapon,
            ['@time']    = v.time
        })
    end
end)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    MySQL.Async.fetchAll("SELECT coords, weapon, time FROM bulletshells",{}, 
    function(result)
        for k,v in pairs(result) do
            local coords = json.decode(v.coords)
            table.insert(shells, {coords = coords, weapon = v.weapon, time = v.time})
        end
        MySQL.Async.execute("DELETE FROM bulletshells",{})
	end)
end)