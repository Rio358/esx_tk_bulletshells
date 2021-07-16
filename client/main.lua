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
    { hash = GetHashKey('WEAPON_REMOTESNIPER'),  name = 'WEAPON_REMOTESNIPER' },
    { hash = GetHashKey('WEAPON_GRENADELAUNCHER'), name = 'WEAPON_GRENADELAUNCHER' },
    { hash = GetHashKey('WEAPON_RPG'), name = 'WEAPON_RPG' },
    { hash = GetHashKey('WEAPON_STINGER'), name = 'WEAPON_STINGER' },
    { hash = GetHashKey('WEAPON_MINIGUN'), name = 'WEAPON_MINIGUN' },
    { hash = GetHashKey('WEAPON_SNSPISTOL'), name = 'WEAPON_SNSPISTOL' },
    { hash = GetHashKey('WEAPON_GUSENBERG'), name = 'WEAPON_GUSENBERG' },
    { hash = GetHashKey('WEAPON_SPECIALCARBINE'), name = 'WEAPON_SPECIALCARBINE' },
    { hash = GetHashKey('WEAPON_SPECIALCARBINE_MK2'), name = 'WEAPON_SPECIALCARBINE_MK2' },
    { hash = GetHashKey('WEAPON_HEAVYPISTOL'), name = 'WEAPON_HEAVYPISTOL' },
    { hash = GetHashKey('WEAPON_BULLPUPRIFLE'), name = 'WEAPON_BULLPUPRIFLE' },
    { hash = GetHashKey('WEAPON_BULLPUPRIFLE_MK2'), name = 'WEAPON_BULLPUPRIFLE_MK2' },
    { hash = GetHashKey('WEAPON_VINTAGEPISTOL'),  name = 'WEAPON_VINTAGEPISTOL' },
    { hash = GetHashKey('WEAPON_FIREWORK'), name = 'WEAPON_FIREWORK' },
    { hash = GetHashKey('WEAPON_MUSKET'), name = 'WEAPON_MUSKET' },
    { hash = GetHashKey('WEAPON_HEAVYSHOTGUN'),  name = 'WEAPON_HEAVYSHOTGUN' },
    { hash = GetHashKey('WEAPON_MARKSMANRIFLE'), name = 'WEAPON_MARKSMANRIFLE' },
    { hash = GetHashKey('WEAPON_MARKSMANRIFLE_MK2'), name = 'WEAPON_MARKSMANRIFLE_MK2' },
    { hash = GetHashKey('WEAPON_HOMINGLAUNCHER'), name = 'WEAPON_HOMINGLAUNCHER' },
    { hash = GetHashKey('WEAPON_FLAREGUN'), name = 'WEAPON_FLAREGUN' },
    { hash = GetHashKey('WEAPON_COMBATPDW'),  name = 'WEAPON_COMBATPDW' },
    { hash = GetHashKey('WEAPON_MARKSMANPISTOL'), name = 'WEAPON_MARKSMANPISTOL' },
    { hash = GetHashKey('WEAPON_RAILGUN'), name = 'WEAPON_RAILGUN' },
    { hash = GetHashKey('WEAPON_MACHINEPISTOL'), name = 'WEAPON_MACHINEPISTOL' },
    { hash = GetHashKey('WEAPON_REVOLVER'), name = 'WEAPON_REVOLVER' },
    { hash = GetHashKey('WEAPON_DBSHOTGUN'), name = 'WEAPON_DBSHOTGUN' },
    { hash = GetHashKey('WEAPON_COMPACTRIFLE'), name = 'WEAPON_COMPACTRIFLE' },
    { hash = GetHashKey('WEAPON_AUTOSHOTGUN'),  name = 'WEAPON_AUTOSHOTGUN' },
    { hash = GetHashKey('WEAPON_COMPACTLAUNCHER'),  name = 'WEAPON_COMPACTLAUNCHER' },
    { hash = GetHashKey('WEAPON_MINISMG'), name = 'WEAPON_MINISMG' }
}

local shells = {}
local drawShells = {}
local time = 0
local shouldUpdate = true
local isPolice, isFlashlight, isAiming, isArmed = false
local closestShell

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(10)
    end
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.name == Config.DBPoliceName then
        isPolice = true
    end
end)

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
                    local playerCoords = GetEntityCoords(playerPed)
                    if Config.DuplicateDistance == 0 then
                        TriggerServerEvent("esx_bulletshells:saveShell", playerCoords, weaponName)
                    else
                        ESX.TriggerServerCallback("esx_bulletshells:getShells", function(cbShells)
                            if has_value(cbShells, playerCoords, weaponName) == false then
                                TriggerServerEvent("esx_bulletshells:saveShell", playerCoords, weaponName)
                            end
                        end)
                    end
                end
            end
        end
    end
end)

function has_value (shells2, coords, weapon)
    if next(shells2) ~= nil then
        for k,v in pairs(shells2) do
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
    if isPolice then
        while true do
            Citizen.Wait(500)
            if next(shells) ~= nil then
                local playerPed = GetPlayerPed(-1)
                local playerCoords = GetEntityCoords(playerPed)
                for k,v in pairs(shells) do
                    local dist = Vdist(playerCoords, v.coords.x, v.coords.y, v.coords.z)
                    if closestShell ~= k then
                        if closestShell == nil then
                            closestShell = k
                        end
                        local distToOld = Vdist(playerCoords, shells[closestShell].coords.x, shells[closestShell].coords.y, shells[closestShell].coords.z)
                        if distToOld > dist then
                            closestShell = k
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
        end
    end
end)

Citizen.CreateThread(function()
    if isPolice then
        while true do
            Citizen.Wait(0)
            if isFlashlight and isAiming then
                shouldUpdate = true
                if next(drawShells) ~= nil then
                    for k,v in pairs(drawShells) do
                        Draw3DText(v.coords.x, v.coords.y, v.coords.z - 0.7, _U('examine_shell'))
                        if IsControlJustReleased(0, 47) then
                            local playerPed = GetPlayerPed(-1)
                            SetCurrentPedWeapon(playerPed, 0xA2719263, true)
                            Citizen.Wait(1500)
                            TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_GARDENER_PLANT', -1, true)
                            Citizen.Wait(Config.SearchTime)
                            ClearPedTasks(playerPed)
                            local time = shells[closestShell].time / 60
                            local realTime = round(time, 1)
                            local weaponLabel = ESX.GetWeaponLabel(shells[closestShell].weapon)
                            --ESX.ShowNotification(_U('shell_from', weaponLabel))
                            exports['mythic_notify']:DoCustomHudText('inform', _U('shell_from', weaponLabel), 20000)
                            TriggerServerEvent("esx_bulletshells:removeShell", closestShell)
                            shells[closestShell] = nil
                            drawShells[closestShell] = nil
                            closestShell = nil
                            shouldUpdate = true
                            Citizen.Wait(5000)
                            --ESX.ShowNotification(_U('was_shot', realTime))
                            exports['mythic_notify']:DoCustomHudText('inform', _U('was_shot', realTime), 20000)
                        end
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    if isPolice then
        while true do
            Citizen.Wait(0)
            if isFlashlight and isAiming then
                if next(drawShells) ~= nil and closestShell ~= nil then
                    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
                    local dist = Vdist(playerCoords, shells[closestShell].coords.x, shells[closestShell].coords.y, shells[closestShell].coords.z)
                    if dist <= Config.SeeDistance then
                        DrawMarker(2, drawShells[closestShell].coords.x, drawShells[closestShell].coords.y, drawShells[closestShell].coords.z - 0.5, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.15, 0.15, 0.15, 39, 132, 194, 150, true, true)
                    else
                        Citizen.Wait(100)
                    end
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    if isPolice then
        while true do
            Citizen.Wait(500)
            if shouldUpdate then
                shouldUpdate = false
                ESX.TriggerServerCallback("esx_bulletshells:getShells", function(cbShells)
                    shells = cbShells
                end)
            end
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
    if isPolice then
        while true do
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

