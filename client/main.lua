local PlayerData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onplayerLogout')
AddEventHandler('esx:onplayerLogout', function(xPlayer)
    ESX.PlayerLoaded = false
    ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local weapons = {
    { hash = `WEAPON_PISTOL`,               name = 'WEAPON_PISTOL' },
    { hash = `WEAPON_COMBATPISTOL`,         name = 'WEAPON_COMBATPISTOL' },
    { hash = `WEAPON_APPISTOL`,             name = 'WEAPON_APPISTOL' },
    { hash = `WEAPON_PISTOL50`,             name = 'WEAPON_PISTOL50' },
    { hash = `WEAPON_PISTOL_MK2`,           name = 'WEAPON_PISTOL_MK2' },
    { hash = `WEAPON_REVOLVER_MK2`,         name = 'WEAPON_REVOLVER_MK2' },
    { hash = `WEAPON_SNSPISTOL`,            name = 'WEAPON_SNSPISTOL' },
    { hash = `WEAPON_SNSPISTOL_MK2`,        name = 'WEAPON_SNSPISTOL_MK2' },
    { hash = `WEAPON_HEAVYPISTOL`,          name = 'WEAPON_HEAVYPISTOL' },
    { hash = `WEAPON_MARKSMANPISTOL`,       name = 'WEAPON_MARKSMANPISTOL' },
    { hash = `WEAPON_REVOLVER`,             name = 'WEAPON_REVOLVER' },
    { hash = `WEAPON_VINTAGEPISTOL`,        name = 'WEAPON_VINTAGEPISTOL' },
    { hash = `WEAPON_MACHINEPISTOL`,        name = 'WEAPON_MACHINEPISTOL' },
    { hash = `WEAPON_MINISMG`,              name = 'WEAPON_MINISMG' },
    { hash = `WEAPON_MICROSMG`,             name = 'WEAPON_MICROSMG' },
    { hash = `WEAPON_COMBATPDW`,            name = 'WEAPON_COMBATPDW' },
    { hash = `WEAPON_SMG`,                  name = 'WEAPON_SMG' },
    { hash = `WEAPON_SMG_MK2`,              name = 'WEAPON_SMG_MK2' },
    { hash = `WEAPON_ASSAULTSMG`,           name = 'WEAPON_ASSAULTSMG' },
    { hash = `WEAPON_PUMPSHOTGUN`,          name = 'WEAPON_PUMPSHOTGUN' },
    { hash = `WEAPON_PUMPSHOTGUN_MK2`,      name = 'WEAPON_PUMPSHOTGUN_MK2' },
    { hash = `WEAPON_SAWNOFFSHOTGUN`,       name = 'WEAPON_SAWNOFFSHOTGUN' },
    { hash = `WEAPON_ASSAULTSHOTGUN`,       name = 'WEAPON_ASSAULTSHOTGUN' },
    { hash = `WEAPON_BULLPUPSHOTGUN`,       name = 'WEAPON_BULLPUPSHOTGUN' },
    { hash = `WEAPON_HEAVYSHOTGUN`,         name = 'WEAPON_HEAVYSHOTGUN' },
    { hash = `WEAPON_DBSHOTGUN`,            name = 'WEAPON_DBSHOTGUN' },
    { hash = `WEAPON_AUTOSHOTGUN`,          name = 'WEAPON_AUTOSHOTGUN' },
    { hash = `WEAPON_ASSAULTRIFLE`,         name = 'WEAPON_ASSAULTRIFLE' },
    { hash = `WEAPON_ASSAULTRIFLE_MK2`,     name = 'WEAPON_ASSAULTRIFLE_MK2' },
    { hash = `WEAPON_CARBINERIFLE`,         name = 'WEAPON_CARBINERIFLE' },
    { hash = `WEAPON_CARBINERIFLE_MK2`,     name = 'WEAPON_CARBINERIFLE_MK2' },
    { hash = `WEAPON_COMPACTRIFLE`,         name = 'WEAPON_COMPACTRIFLE' },
    { hash = `WEAPON_COMBATRIFLE`,          name = 'WEAPON_COMBATRIFLE' },
    { hash = `WEAPON_ADVANCEDRIFLE`,        name = 'WEAPON_ADVANCEDRIFLE' },
    { hash = `WEAPON_SPECIALCARBINE`,       name = 'WEAPON_SPECIALCARBINE' },
    { hash = `WEAPON_SPECIALCARBINE_MK2`,   name = 'WEAPON_SPECIALCARBINE_MK2' },
    { hash = `WEAPON_TACTICALRIFLE`,        name = 'WEAPON_TACTICALRIFLE' },
    { hash = `WEAPON_BULLPUPRIFLE`,         name = 'WEAPON_BULLPUPRIFLE' },
    { hash = `WEAPON_BULLPUPRIFLE_MK2`,     name = 'WEAPON_BULLPUPRIFLE_MK2' },
    { hash = `WEAPON_MG`,                   name = 'WEAPON_MG' },
    { hash = `WEAPON_COMBATMG`,             name = 'WEAPON_COMBATMG' },
    { hash = `WEAPON_COMBATMG_MK2`,         name = 'WEAPON_COMBATMG_MK2' },
    { hash = `WEAPON_SNIPERRIFLE`,          name = 'WEAPON_SNIPERRIFLE' },
    { hash = `WEAPON_HEAVYSNIPER`,          name = 'WEAPON_HEAVYSNIPER' },
    { hash = `WEAPON_HEAVYSNIPER_MK2`,      name = 'WEAPON_HEAVYSNIPER_MK2' },
    { hash = `WEAPON_MARKSMANRIFLE`,        name = 'WEAPON_MARKSMANRIFLE' },
    { hash = `WEAPON_MARKSMANRIFLE_MK2`,    name = 'WEAPON_MARKSMANRIFLE_MK2' },
    { hash = `WEAPON_MINIGUN`,              name = 'WEAPON_MINIGUN' },
    { hash = `WEAPON_GUSENBERG`,            name = 'WEAPON_GUSENBERG' },
    { hash = `WEAPON_MUSKET`,               name = 'WEAPON_MUSKET' },
}

local shells = {}
local drawShells = {}
local closestShell, closestInspectShell
local isFlashlight, isAiming, isArmed = false
local shouldUpdate = true

CreateThread(function()
    local sleep = 500
    while true do
        if isArmed then
            sleep = 50
            local playerPed = PlayerPedId()
            if IsPedShooting(playerPed) then
                sleep = 1
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
                        TriggerServerEvent("bulletshells:saveShell", playerCoords, weaponName, weaponType)
                    else
                        ESX.TriggerServerCallback("bulletshells:getShells", function(cbShells)
                            if has_value(cbShells, playerCoords, weaponName) == false then
                                TriggerServerEvent("bulletshells:saveShell", playerCoords, weaponName, weaponType)
                            end
                        end)
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

function WeaponType(weaponName)
	local pistols = {'WEAPON_VINTAGEPISTOL', 'WEAPON_SNSPISTOL', 'WEAPON_SNSPISTOL_MK2', 'WEAPON_PISTOL', 'WEAPON_PISTOL_MK2', 'WEAPON_COMBATPISTOL', 'WEAPON_APPISTOL', 'WEAPON_HEAVYPISTOL', 'WEAPON_PISTOL50', 'WEAPON_REVOLVER', 'WEAPON_REVOLVER_MK2', 'WEAPON_MARKSMANPISTOL', 'WEAPON_DOUBLEACTION'}
	local smgs = {'WEAPON_MICROSMG', 'WEAPON_SMG', 'WEAPON_SMG_MK2', 'WEAPON_ASSAULTSMG', 'WEAPON_COMBATPDW', 'WEAPON_MACHINEPISTOL', 'WEAPON_MINISMG'}
	local shotguns = {'WEAPON_PUMPSHOTGUN', 'WEAPON_PUMPSHOTGUN_MK2', 'WEAPON_ASSAULTSHOTGUN', 'WEAPON_BULLPUPSHOTGUN', 'WEAPON_SAWNOFFSHOTGUN', 'WEAPON_DBSHOTGUN', 'WEAPON_HEAVYSHOTGUN', 'WEAPON_MUSKET', 'WEAPON_AUTOSHOTGUN', 'WEAPON_COMBATSHOTGUN'}
	local rifles = {'WEAPON_ASSAULTRIFLE', 'WEAPON_ASSAULTRIFLE_MK2', 'WEAPON_CARBINERIFLE', 'WEAPON_CARBINERIFLE_MK2','WEAPON_COMBATRIFLE', 'WEAPON_ADVANCEDRIFLE', 'WEAPON_SPECIALCARBINE', 'WEAPON_SPECIALCARBINE_MK2', 'WEAPON_BULLPUPRIFLE', 'WEAPON_BULLPUPRIFLE_MK2', 'WEAPON_COMPACTRIFLE', 'WEAPON_MILITARYRIFLE'}
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

CreateThread(function()
    while true do
        if NetworkIsPlayerActive(PlayerId()) then
            Wait(300)
            if next(shells) ~= nil then
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                for k,v in pairs(shells) do
                    local dist = #(playerCoords - vector3(v.coords.x, v.coords.y, v.coords.z))
                    if closestShell ~= k then
                        if closestShell == nil then
                            closestShell = k
                        end
                        if shells[closestShell] ~= nil then
                            local distToOld = #(playerCoords - vector3(shells[closestShell].coords.x, shells[closestShell].coords.y, shells[closestShell].coords.z))
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
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        if NetworkIsPlayerActive(PlayerId()) then
            Wait(0)
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
            else
                Wait(250)
            end
        end
    end
end)

CreateThread(function()
    local sleep = 500
    while true do
        if NetworkIsPlayerActive(PlayerId()) then
            if isFlashlight and isAiming then
                sleep = 0
                if next(drawShells) ~= nil and closestShell ~= nil then
                    if closestInspectShell == closestShell then
                        if IsControlJustReleased(0, 38) then
                            local playerPed = PlayerPedId()
                            local dict, anim = "weapons@first_person@aim_rng@generic@projectile@sticky_bomb@", "plant_floor"
                            ESX.Streaming.RequestAnimDict(dict)
                            TaskPlayAnim(playerPed,dict,anim,8.0,1.0,1000,16,0.0,false,false,false)
                            Wait(Config.SearchTime)
                            local time = round(shells[closestShell].time / 60, 1)
                            local weaponLabel = ESX.GetWeaponLabel(shells[closestShell].weapon)
                            exports.mythic_notify:DoLongHudText('inform', _U('shell_from', weaponLabel), 10000)
                            TriggerServerEvent("bulletshells:removeShell", closestShell)
                            local id = " a-".. math.random(999,5000) .. "-" ..math.random(9999,150000)
                            local playerCoords = GetEntityCoords(PlayerPedId())
                            local coords = GetStreetNameFromHashKey(GetStreetNameAtCoord(playerCoords.x, playerCoords.y, playerCoords.z))
                            local data = "Shell fired from a " .. weaponLabel .. "  \nCasing number:  " .. id .. "  \nFound near : " .. coords
                            TriggerServerEvent('bulletshell:GiveEvidence', data)
                            shells[closestShell] = nil
                            drawShells[closestShell] = nil
                            closestShell = nil
                            shouldUpdate = true
                            Wait(3000)
                            exports.mythic_notify:DoLongHudText('inform', _U('was_shot', time), 5000)
                        end
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

CreateThread(function()
    while true do
         if NetworkIsPlayerActive(PlayerId()) then
            Wait(0)
            if isFlashlight and isAiming then
                if next(drawShells) ~= nil and closestShell ~= nil then
                    if shells[closestShell] ~= nil then
                        local playerCoords = GetEntityCoords(PlayerPedId())
                        local distToClosest = #(playerCoords - vector3(shells[closestShell].coords.x, shells[closestShell].coords.y, shells[closestShell].coords.z))
                        if distToClosest <= Config.InspectDistance then
                            closestInspectShell = closestShell
                        else
                            closestInspectShell = nil
                        end
                    end
                end
            else
                Wait(500)
            end
        end
    end
end)

CreateThread(function()
    while true do
        if NetworkIsPlayerActive(PlayerId()) then
            Wait(1000)
            if shouldUpdate then
                shouldUpdate = false
                ESX.TriggerServerCallback("bulletshells:getShells", function(cbShells)
                    shells = cbShells
                end)
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(250)
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        if IsPedArmed(playerPed, 4) then
            isArmed = true
        else
            isArmed = false
        end
    end
end)

CreateThread(function()
    while true do
        if NetworkIsPlayerActive(PlayerId()) then
            Wait(200)
            local playerPed = PlayerPedId()
            if GetSelectedPedWeapon(playerPed) == `WEAPON_FLASHLIGHT` then
                isFlashlight = true
                if GetPedConfigFlag(playerPed,78,true) then
                    isAiming = true
                else
                    isAiming = false
                    Wait(50)
                end
            else
                isFlashlight = false
                Wait(500)
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
--    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

RegisterNetEvent('bulletshells:removeDrawShell')
AddEventHandler('bulletshells:removeDrawShell', function(id)
    if NetworkIsPlayerActive(PlayerId()) then
        ESX.TriggerServerCallback("bulletshells:getShells", function(cbShells)
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