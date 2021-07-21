ESX = nil
local PlayerData = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end) 

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local weapons = {
    { hash = GetHashKey('WEAPON_PISTOL'),  name = 'WEAPON_PISTOL' },
    { hash = GetHashKey('WEAPON_COMBATPISTOL'), name = 'WEAPON_COMBATPISTOL' },
    { hash = GetHashKey('WEAPON_APPISTOL'),  name = 'WEAPON_APPISTOL' },
    { hash = GetHashKey('WEAPON_PISTOL50'), name = 'WEAPON_PISTOL50' },
    { hash = GetHashKey('WEAPON_PISTOL_MK2'),  name = 'WEAPON_PISTOL_MK2' },
    { hash = GetHashKey('WEAPON_REVOLVER_MK2'),  name = 'WEAPON_REVOLVER_MK2' },
    { hash = GetHashKey('WEAPON_SNSPISTOL_MK2'),  name = 'WEAPON_SNSPISTOL_MK2' },
    { hash = GetHashKey('WEAPON_MICROSMG'),  name = 'WEAPON_MICROSMG' },
    { hash = GetHashKey('WEAPON_SMG'),  name = 'WEAPON_SMG' },
    { hash = GetHashKey('WEAPON_SMG_MK2'),  name = 'WEAPON_SMG_MK2' },
    { hash = GetHashKey('WEAPON_ASSAULTSMG'), name = 'WEAPON_ASSAULTSMG' },
    { hash = GetHashKey('WEAPON_ASSAULTRIFLE'), name = 'WEAPON_ASSAULTRIFLE' },
    { hash = GetHashKey('WEAPON_ASSAULTRIFLE_MK2'), name = 'WEAPON_ASSAULTRIFLE_MK2' },
    { hash = GetHashKey('WEAPON_CARBINERIFLE'), name = 'WEAPON_CARBINERIFLE' },
    { hash = GetHashKey('WEAPON_CARBINERIFLE_MK2'), name = 'WEAPON_CARBINERIFLE_MK2' },
    { hash = GetHashKey('WEAPON_ADVANCEDRIFLE'), name = 'WEAPON_ADVANCEDRIFLE' },
    { hash = GetHashKey('WEAPON_MG'), name = 'WEAPON_MG' },
    { hash = GetHashKey('WEAPON_COMBATMG'), name = 'WEAPON_COMBATMG' },
    { hash = GetHashKey('WEAPON_COMBATMG_MK2'), name = 'WEAPON_COMBATMG_MK2' },
    { hash = GetHashKey('WEAPON_PUMPSHOTGUN'),  name = 'WEAPON_PUMPSHOTGUN' },
    { hash = GetHashKey('WEAPON_PUMPSHOTGUN_MK2'),  name = 'WEAPON_PUMPSHOTGUN_MK2' },
    { hash = GetHashKey('WEAPON_SAWNOFFSHOTGUN'), name = 'WEAPON_SAWNOFFSHOTGUN' },
    { hash = GetHashKey('WEAPON_ASSAULTSHOTGUN'), name = 'WEAPON_ASSAULTSHOTGUN' },
    { hash = GetHashKey('WEAPON_BULLPUPSHOTGUN'), name = 'WEAPON_BULLPUPSHOTGUN' },
    { hash = GetHashKey('WEAPON_SNIPERRIFLE'),  name = 'WEAPON_SNIPERRIFLE' },
    { hash = GetHashKey('WEAPON_HEAVYSNIPER'),  name = 'WEAPON_HEAVYSNIPER' },
    { hash = GetHashKey('WEAPON_HEAVYSNIPER_MK2'),  name = 'WEAPON_HEAVYSNIPER_MK2' },
    { hash = GetHashKey('WEAPON_MINIGUN'), name = 'WEAPON_MINIGUN' },
    { hash = GetHashKey('WEAPON_SNSPISTOL'), name = 'WEAPON_SNSPISTOL' },
    { hash = GetHashKey('WEAPON_GUSENBERG'), name = 'WEAPON_GUSENBERG' },
    { hash = GetHashKey('WEAPON_SPECIALCARBINE'), name = 'WEAPON_SPECIALCARBINE' },
    { hash = GetHashKey('WEAPON_SPECIALCARBINE_MK2'), name = 'WEAPON_SPECIALCARBINE_MK2' },
    { hash = GetHashKey('WEAPON_HEAVYPISTOL'), name = 'WEAPON_HEAVYPISTOL' },
    { hash = GetHashKey('WEAPON_BULLPUPRIFLE'), name = 'WEAPON_BULLPUPRIFLE' },
    { hash = GetHashKey('WEAPON_BULLPUPRIFLE_MK2'), name = 'WEAPON_BULLPUPRIFLE_MK2' },
    { hash = GetHashKey('WEAPON_VINTAGEPISTOL'),  name = 'WEAPON_VINTAGEPISTOL' },
    { hash = GetHashKey('WEAPON_MUSKET'), name = 'WEAPON_MUSKET' },
    { hash = GetHashKey('WEAPON_HEAVYSHOTGUN'),  name = 'WEAPON_HEAVYSHOTGUN' },
    { hash = GetHashKey('WEAPON_MARKSMANRIFLE'), name = 'WEAPON_MARKSMANRIFLE' },
    { hash = GetHashKey('WEAPON_MARKSMANRIFLE_MK2'), name = 'WEAPON_MARKSMANRIFLE_MK2' },
    { hash = GetHashKey('WEAPON_COMBATPDW'),  name = 'WEAPON_COMBATPDW' },
    { hash = GetHashKey('WEAPON_MARKSMANPISTOL'), name = 'WEAPON_MARKSMANPISTOL' },
    { hash = GetHashKey('WEAPON_MACHINEPISTOL'), name = 'WEAPON_MACHINEPISTOL' },
    { hash = GetHashKey('WEAPON_REVOLVER'), name = 'WEAPON_REVOLVER' },
    { hash = GetHashKey('WEAPON_DBSHOTGUN'), name = 'WEAPON_DBSHOTGUN' },
    { hash = GetHashKey('WEAPON_COMPACTRIFLE'), name = 'WEAPON_COMPACTRIFLE' },
    { hash = GetHashKey('WEAPON_AUTOSHOTGUN'),  name = 'WEAPON_AUTOSHOTGUN' },
    { hash = GetHashKey('WEAPON_MINISMG'), name = 'WEAPON_MINISMG' }
}

local shells = {}
local drawShells = {}
local closestShell, closestInspectShell
local isFlashlight, isAiming, isArmed = false
local shouldUpdate = true

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isArmed then
            local playerPed = GetPlayerPed(-1)
            if IsPedShooting(playerPed) then
                local weaponHash = GetSelectedPedWeapon(playerPed)
                local weaponName
                for k,v in pairs(weapons) do
                    if weaponHash == v.hash then
                        weaponName = v.name
                        break
                    end
                end
                if weaponName ~= nil then
                    local weaponType = WeaponType(weaponName)
                    local playerCoords = GetEntityCoords(playerPed)
                    if Config.DuplicateDistance == 0 then
                        TriggerServerEvent("esx_tk_bulletshells:saveShell", playerCoords, weaponName, weaponType)
                    else
                        ESX.TriggerServerCallback("esx_tk_bulletshells:getShells", function(cbShells)
                            if has_value(cbShells, playerCoords, weaponName) == false then
                                TriggerServerEvent("esx_tk_bulletshells:saveShell", playerCoords, weaponName, weaponType)
                            end
                        end)
                    end
                end
            end
        end
    end
end)

function WeaponType(weaponName)
	local pistols = {'WEAPON_VINTAGEPISTOL', 'WEAPON_SNSPISTOL', 'WEAPON_SNSPISTOL_MK2', 'WEAPON_PISTOL', 'WEAPON_PISTOL_MK2', 'WEAPON_COMBATPISTOL', 'WEAPON_APPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_PISTOL50', 'WEAPON_REVOLVER', 'WEAPON_REVOLVER_MK2', 'WEAPON_MARKSMANPISTOL', 'WEAPON_DOUBLEACTION'}
	local smgs = {'WEAPON_MICROSMG', 'WEAPON_SMG', 'WEAPON_SMG_MK2', 'WEAPON_ASSAULTSMG', 'WEAPON_COMBATPDW', 'WEAPON_MACHINEPISTOL', 'WEAPON_MINISMG'}
	local shotguns = {'WEAPON_PUMPSHOTGUN', 'WEAPON_PUMPSHOTGUN_MK2', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_BULLPUPSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_MUSKET', 'WEAPON_AUTOSHOTGUN', 'WEAPON_COMBATSHOTGUN'}
	local rifles = {'WEAPON_ASSAULTRIFLE', 'WEAPON_ASSAULTRIFLE_MK2', 'WEAPON_CARBINERIFLE', 'WEAPON_CARBINERIFLE_MK2', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_SPECIALCARBINE_MK2', 'WEAPON_BULLPUPRIFLE', 'WEAPON_BULLPUPRIFLE_MK2', 'WEAPON_COMPACTRIFLE', 'WEAPON_MILITARYRIFLE'}
	local lmgs = {'WEAPON_MG', 'WEAPON_COMBATMG', 'WEAPON_COMBATMG_MK2', 'WEAPON_GUSENBERG'}
	local snipers = {'WEAPON_SNIPERRIFLE', 'WEAPON_HEAVYSNIPER', 'WEAPON_HEAVYSNIPER_MK2', 'WEAPON_MARKSMANRIFLE', 'WEAPON_MARKSMANRIFLE_MK2'}
    for k,v in pairs(pistols) do
        if weaponName == v then
            return 'pistol'
        end
    end
    for k,v in pairs(smgs) do
        if weaponName == v then
            return 'smg'
        end
    end
    for k,v in pairs(shotguns) do
        if weaponName == v then
            return 'shotgun'
        end
    end
    for k,v in pairs(rifles) do
        if weaponName == v then
            return 'rifle'
        end
    end
    for k,v in pairs(lmgs) do
        if weaponName == v then
            return 'lmg'
        end
    end
    for k,v in pairs(snipers) do
        if weaponName == v then
            return 'sniper'
        end
    end
end

function has_value (array, coords, weapon)
    if next(array) ~= nil then
        for k,v in pairs(array) do
            if v.weapon == weapon then
                local dist = Vdist(coords, v.coords[1], v.coords[2], v.coords[3])
                if dist <= Config.DuplicateDistance then
                    return true
                end
            end
        end
    end
    return false
end

Citizen.CreateThread(function()
    while ESX.PlayerData.job.name == nil do
        Citizen.Wait(10)
    end
    while true do
        if ESX.PlayerData.job.name == Config.DBPoliceName then
            Citizen.Wait(300)
            if next(shells) ~= nil then
                local playerPed = GetPlayerPed(-1)
                local playerCoords = GetEntityCoords(playerPed)
                for k,v in pairs(shells) do
                    local dist = Vdist(playerCoords, v.coords.x, v.coords.y, v.coords.z)
                    if closestShell ~= k then
                        if closestShell == nil then
                            closestShell = k
                        end
                        if shells[closestShell] ~= nil then
                            local distToOld = Vdist(playerCoords, shells[closestShell].coords.x, shells[closestShell].coords.y, shells[closestShell].coords.z)
                            if distToOld > dist then
                                closestShell = k
                            end
                        end
                    end
                    
                    if dist <= Config.SeeDistance then
                        if drawShells[k] == nil then
                            drawShells[k] = shells[k]
                        end
                    else
                        drawShells[k] = nil
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while ESX.PlayerData.job.name == nil do
        Citizen.Wait(10)
    end
    while true do
        if ESX.PlayerData.job.name == Config.DBPoliceName then
            Citizen.Wait(0)
            if isFlashlight and isAiming then
                shouldUpdate = true
                if next(drawShells) ~= nil then
                    for k,v in pairs(drawShells) do
                        if closestInspectShell ~= k then
                            Draw3DText(v.coords.x, v.coords.y, v.coords.z - 0.7, _U('shell', _U(v.weaponType)))
                        else
                            Draw3DText(v.coords.x, v.coords.y, v.coords.z - 0.7, _U('shell', _U(v.weaponType)) .. _U('inspect_shell'))
                        end
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while ESX.PlayerData.job.name == nil do
        Citizen.Wait(10)
    end
    while true do
        if ESX.PlayerData.job.name == Config.DBPoliceName then
            Citizen.Wait(0)
            if isFlashlight and isAiming then
                if next(drawShells) ~= nil and closestShell ~= nil then
                    if closestInspectShell == closestShell then
                        if IsControlJustReleased(0, 38) then
                            local playerPed = GetPlayerPed(-1)
                            SetCurrentPedWeapon(playerPed, 0xA2719263, true)
                            while IsPedArmed(playerPed, 7) do
                                Citizen.Wait(100)
                            end
                            TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_GARDENER_PLANT', -1, true)
                            Citizen.Wait(Config.SearchTime)
                            ClearPedTasks(playerPed)
                            local time = round(shells[closestShell].time / 60, 1)
                            local weaponLabel = ESX.GetWeaponLabel(shells[closestShell].weapon)
                            --ESX.ShowNotification(_U('shell_from', weaponLabel))
                            exports['mythic_notify']:DoCustomHudText('inform', _U('shell_from', weaponLabel), 20000)
                            TriggerServerEvent("esx_tk_bulletshells:removeShell", closestShell)
                            shells[closestShell] = nil
                            drawShells[closestShell] = nil
                            closestShell = nil
                            shouldUpdate = true
                            Citizen.Wait(3000)
                            --ESX.ShowNotification(_U('was_shot', time))
                            exports['mythic_notify']:DoCustomHudText('inform', _U('was_shot', time), 20000)
                        end
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while ESX.PlayerData.job.name == nil do
        Citizen.Wait(10)
    end
    while true do
        if ESX.PlayerData.job.name == Config.DBPoliceName then
            Citizen.Wait(0)
            if isFlashlight and isAiming then
                if next(drawShells) ~= nil and closestShell ~= nil then
                    if shells[closestShell] ~= nil then
                        local playerCoords = GetEntityCoords(GetPlayerPed(-1))
                        local distToClosest = Vdist(playerCoords, shells[closestShell].coords.x, shells[closestShell].coords.y, shells[closestShell].coords.z)
                        if distToClosest <= Config.InspectDistance then
                            closestInspectShell = closestShell
                        else
                            closestInspectShell = nil
                        end
                    end
                end
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while ESX.PlayerData.job.name == nil do
        Citizen.Wait(10)
    end
    while true do
        if ESX.PlayerData.job.name == Config.DBPoliceName then
            Citizen.Wait(500)
            if shouldUpdate then
                shouldUpdate = false
                ESX.TriggerServerCallback("esx_tk_bulletshells:getShells", function(cbShells)
                    shells = cbShells
                end)
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(250)
        local playerPed = GetPlayerPed(-1)
        local playerCoords = GetEntityCoords(playerPed)
        if IsPedArmed(playerPed, 4) then
            isArmed = true
        else
            isArmed = false
        end
    end
end)

Citizen.CreateThread(function()
    while ESX.PlayerData.job.name == nil do
        Citizen.Wait(10)
    end
    while true do
        if ESX.PlayerData.job.name == Config.DBPoliceName then
            Citizen.Wait(200)
            local playerPed = GetPlayerPed(-1)
            if GetSelectedPedWeapon(playerPed) == GetHashKey(Config.WeaponToSearch) then
                isFlashlight = true
                local playerId = PlayerId()
                if IsPlayerFreeAiming(playerId) then
                    isAiming = true
                else
                    isAiming = false
                end
            else
                isFlashlight = false
            end
        else
            Citizen.Wait(1000)
        end
    end
end)

function round(x, decimals)
    local n = 10^(decimals or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end

function Draw3DText(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x, y, z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('esx_tk_bulletshells:removeDrawShell')
AddEventHandler('esx_tk_bulletshells:removeDrawShell', function(id)
    if ESX.PlayerData.job.name == Config.DBPoliceName then
        ESX.TriggerServerCallback("esx_tk_bulletshells:getShells", function(cbShells)
            shells = cbShells
            if drawShells[id] ~= nil then
                drawShells[id] = nil
            end
            if id == closestShell then
                closestShell = nil
            end
            if id == closestInspectShell then
                closestInspectShell = nil
            end
        end)
    end
end)

