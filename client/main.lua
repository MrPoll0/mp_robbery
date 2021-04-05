ESX = nil
ESXLoaded = false
MP.robbing = false
MP.peds = {}
MP.objects = {}

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    ESXLoaded = true

    for i=1, #MP.Config.Locations["24/7"] do 
        local blip = AddBlipForCoord(MP.Config.Locations["24/7"][i]["coords"])

        SetBlipSprite(blip, 156)
        SetBlipScale(blip, 0.9)
        SetBlipColour(blip, 4)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Robo a tienda")
        EndTextCommandSetBlipName(blip)
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('mp_robbery:onPedDeath')
AddEventHandler('mp_robbery:onPedDeath', function(store)
    SetEntityHealth(MP.peds[store], 0)
    TriggerServerEvent('mp_robbery:alertPolice', store, 2)
end)

RegisterNetEvent('mp_robbery:alertPolice')
AddEventHandler('mp_robbery:alertPolice', function(store, robber, style)
    local mugshot, mugshotStr = ESX.Game.GetPedMugshot(GetPlayerPed(GetPlayerFromServerId(robber)))
    if style == 1 then 
		ESX.ShowAdvancedNotification(MP.Config.Locations["24/7"][store].name, MP.Config.Locales['robbery'], MP.Config.Locales['cop_msg'], mugshotStr, 4)
	elseif style == 2 then 
		ESX.ShowAdvancedNotification(MP.Config.Locations["24/7"][store].name, MP.Config.Locales['kill'], MP.Config.Locales['kill_msg'], mugshotStr, 4)
	end
    UnregisterPedheadshot(mugshot)
    local timer = GetGameTimer()+20000
    while timer >= GetGameTimer() do
        local name = GetCurrentResourceName() .. math.random(999)
        AddTextEntry(name, '~INPUT_CONTEXT~ ' .. MP.Config.Locales['set_waypoint'])
        DisplayHelpTextThisFrame(name, false)
        if IsControlPressed(0, 38) then
            SetNewWaypoint(MP.Config.Locations["24/7"][store].coords.x, MP.Config.Locations["24/7"][store].coords.y)
            return
        end
        Wait(0)
    end
end)

RegisterNetEvent('mp_robbery:removePickup')
AddEventHandler('mp_robbery:removePickup', function(store)
    for i = 1, #MP.objects do 
        if MP.objects[i].store == store and DoesEntityExist(MP.objects[i].object) then 
            DeleteObject(MP.objects[i].object) 
        end 
    end
end)

RegisterNetEvent('mp_robbery:robberyOver')
AddEventHandler('mp_robbery:robberyOver', function(store)
    MP.robbing = false
    TriggerServerEvent('mp_robbery:robbing', store, MP.robbing)
end)

RegisterNetEvent('mp_robbery:msg')
AddEventHandler('mp_robbery:msg', function(store, text, time)
    MP.robbing = false
    TriggerServerEvent('mp_robbery:robbing', store, MP.robbing)
    local endTime = GetGameTimer() + 1000 * time
    while endTime >= GetGameTimer() do
        local x = GetEntityCoords(MP.peds[store])
        DrawText3D(vector3(x.x, x.y, x.z + 1.0), text)
        Wait(0)
    end
end)

RegisterNetEvent('mp_robbery:giveMoney')
AddEventHandler('mp_robbery:giveMoney', function(store)
    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), MP.Config.Locations["24/7"][store].coords, true) <= 7.5 then
        PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
        TriggerServerEvent('mp_robbery:giveMoney', store)
    else
        ESX.ShowNotification(MP.Config.Locales['too_far_bag'])
        MP.robbing = false
        TriggerServerEvent('mp_robbery:robbing', store, MP.robbing)
    end
end)

RegisterNetEvent('mp_robbery:startRobbing')
AddEventHandler('mp_robbery:startRobbing', function(i)
    if not IsPedDeadOrDying(MP.peds[i]) then
        SetEntityCoords(MP.peds[i], MP.Config.Locations["24/7"][i].coords)
        loadDict('mp_am_hold_up')
        TaskPlayAnim(MP.peds[i], "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, -1, 2, 0, false, false, false)
        while not IsEntityPlayingAnim(MP.peds[i], "mp_am_hold_up", "holdup_victim_20s", 3) do Wait(0) end
        local timer = GetGameTimer() + 10800
        while timer >= GetGameTimer() do
            if IsPedDeadOrDying(MP.peds[i]) then
                break
            end
            Wait(0)
        end

        if not IsPedDeadOrDying(MP.peds[i]) then
            local cashRegister = GetClosestObjectOfType(GetEntityCoords(MP.peds[i]), 5.0, GetHashKey('prop_till_01'))
            if DoesEntityExist(cashRegister) then
                CreateModelSwap(GetEntityCoords(cashRegister), 0.5, GetHashKey('prop_till_01'), GetHashKey('prop_till_01_dam'), false)
            end

            timer = GetGameTimer() + 200 
            while timer >= GetGameTimer() do
                if IsPedDeadOrDying(MP.peds[i]) then
                    break
                end
                Wait(0)
            end

            local model = GetHashKey('prop_poly_bag_01')
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end
            local bag = CreateObject(model, GetEntityCoords(MP.peds[i]), false, false)
                        
            AttachEntityToEntity(bag, MP.peds[i], GetPedBoneIndex(MP.peds[i], 60309), 0.1, -0.11, 0.08, 0.0, -75.0, -75.0, 1, 1, 0, 0, 2, 1)
            timer = GetGameTimer() + 10000
            while timer >= GetGameTimer() do
                if IsPedDeadOrDying(MP.peds[i]) then
                    break
                end
                Wait(0)
            end
            if not IsPedDeadOrDying(MP.peds[i]) then
                DetachEntity(bag, true, false)
                timer = GetGameTimer() + 75
                while timer >= GetGameTimer() do
                    if IsPedDeadOrDying(MP.peds[i]) then
                        break
                    end
                    Wait(0)
                end
                SetEntityHeading(bag, MP.Config.Locations["24/7"][i].heading)
                ApplyForceToEntity(bag, 3, vector3(0.0, 50.0, 0.0), 0.0, 0.0, 0.0, 0, true, true, false, false, true)
                table.insert(MP.objects, {store = i, object = bag})
                --[[ 
                Citizen.CreateThread(function()
                    while true do
                        Wait(5)
                        if DoesEntityExist(bag) then
                            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(bag), true) <= 1.5 then
                                PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
                                TriggerServerEvent('mp_robbery:pickUp', i)
                                break
                            end
                        else
                            break
                        end
                    end
                end)
                --]]
            else
                DeleteObject(bag)
            end
        end
        loadDict('mp_am_hold_up')
        TaskPlayAnim(MP.peds[i], "mp_am_hold_up", "cower_intro", 8.0, -8.0, -1, 0, 0, false, false, false)
        timer = GetGameTimer() + 2500
        while timer >= GetGameTimer() do Wait(0) end
        TaskPlayAnim(MP.peds[i], "mp_am_hold_up", "cower_loop", 8.0, -8.0, -1, 1, 0, false, false, false)
        local stop = GetGameTimer() + 120000
        while stop >= GetGameTimer() do
            Wait(50)
        end
        if IsEntityPlayingAnim(MP.peds[i], "mp_am_hold_up", "cower_loop", 3) then
            ClearPedTasks(MP.peds[i])
        end
    end
end)

RegisterNetEvent('mp_robbery:resetStore')
AddEventHandler('mp_robbery:resetStore', function(i)
    while not ESXLoaded do Wait(0) end
    if DoesEntityExist(MP.peds[i]) then
        DeletePed(MP.peds[i])
    end
    Wait(250)
    MP.peds[i] = _CreatePed(416176080, MP.Config.Locations["24/7"][i].coords, MP.Config.Locations["24/7"][i].heading)
    local brokenCashRegister = GetClosestObjectOfType(GetEntityCoords(MP.peds[i]), 5.0, GetHashKey('prop_till_01_dam'))
    if DoesEntityExist(brokenCashRegister) then
        CreateModelSwap(GetEntityCoords(brokenCashRegister), 0.5, GetHashKey('prop_till_01_dam'), GetHashKey('prop_till_01'), false)
    end
end)

function _CreatePed(hash, coords, heading)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(5)
    end

    local ped = CreatePed(4, hash, coords, false, false)
    SetEntityHeading(ped, heading)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    FreezeEntityPosition(ped, true)
    return ped
end

Citizen.CreateThread(function()
    while not ESXLoaded do Wait(0) end
    for i = 1, #MP.Config.Locations["24/7"] do 
        MP.peds[i] = _CreatePed(416176080, MP.Config.Locations["24/7"][i].coords, MP.Config.Locations["24/7"][i].heading)

        local brokenCashRegister = GetClosestObjectOfType(GetEntityCoords(MP.peds[i]), 5.0, GetHashKey('prop_till_01_dam'))
        if DoesEntityExist(brokenCashRegister) then
            CreateModelSwap(GetEntityCoords(brokenCashRegister), 0.5, GetHashKey('prop_till_01_dam'), GetHashKey('prop_till_01'), false)
        end
    end

    Citizen.CreateThread(function()
        while true do
            for i = 1, #MP.peds do
                if IsPedDeadOrDying(MP.peds[i]) then
                    TriggerServerEvent('mp_robbery:pedDead', i)
                end
            end
            Wait(5000)
        end
    end)

    while true do
        Wait(5)
        if IsPedArmed(PlayerPedId(), 7) then
            if IsPlayerFreeAiming(PlayerId()) then
                for i = 1, #MP.peds do
                    if HasEntityClearLosToEntityInFront(PlayerPedId(), MP.peds[i], 19) and not IsPedDeadOrDying(MP.peds[i]) and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(MP.peds[i]), true) <= 5.0 then
                    	local alreadyRobbing = nil
                    	ESX.TriggerServerCallback('mp_robbery:isRobbing', function(robbing)
                    		alreadyRobbing = robbing
                    	end, i)
                    	while alreadyRobbing == nil do Wait(0) end
                        if not MP.robbing and not alreadyRobbing then
                        	local policeEnough = nil
                            ESX.TriggerServerCallback('mp_robbery:policeEnough', function(police)
                            	policeEnough = police
                            end, i)
                            while policeEnough == nil do Wait(0) end
	                        if policeEnough == true then
	                            MP.robbing = true
	                            TriggerServerEvent('mp_robbery:alertPolice', i, 1)
	                            TriggerServerEvent('mp_robbery:robbing', i, MP.robbing)
	                            Citizen.CreateThread(function()
	                                while MP.robbing do Wait(0) if IsPedDeadOrDying(MP.peds[i]) then MP.robbing = false TriggerServerEvent('mp_robbery:robbing', i, MP.robbing) TriggerServerEvent('mp_robbery:alertPolice', i, 1) end end
	                            end)
	                            loadDict('missheist_agency2ahands_up')
	                            TaskPlayAnim(MP.peds[i], "missheist_agency2ahands_up", "handsup_anxious", 8.0, -8.0, -1, 1, 0, false, false, false)

	                            local fear = 0
	                            while fear < 100 and not IsPedDeadOrDying(MP.peds[i]) and GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(MP.peds[i]), true) <= 7.5 do
	                                local sleep = 600
	                                SetEntityAnimSpeed(MP.peds[i], "missheist_agency2ahands_up", "handsup_anxious", 1.0)
	                                if HasEntityClearLosToEntityInFront(PlayerPedId(), MP.peds[i], 19) then 
		                                if IsPlayerFreeAiming(PlayerId()) then
		                                    sleep = 250
		                                    SetEntityAnimSpeed(MP.peds[i], "missheist_agency2ahands_up", "handsup_anxious", 1.3)

		                                    if IsPedArmed(PlayerPedId(), 4) and GetAmmoInPedWeapon(PlayerPedId(), GetSelectedPedWeapon(PlayerPedId())) > 0 and IsControlPressed(0, 24) then
		                                    sleep = 50
		                                    SetEntityAnimSpeed(MP.peds[i], "missheist_agency2ahands_up", "handsup_anxious", 1.7)
		                                	end

		                                	fear = fear + 1
		                                end
		                            end
	                                sleep = GetGameTimer() + sleep
	                                while sleep >= GetGameTimer() and not IsPedDeadOrDying(MP.peds[i]) do
	                                    Wait(0)
	                                    DrawRect(0.67, 0.97, 0.2, 0.03, 75, 75, 75, 200)
	                                    local draw = fear/500
	                                    DrawRect(0.67, 0.97, draw, 0.03, 255, 0, 0, 0.2)
	                                end
	                            end
	                            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(MP.peds[i]), true) <= 7.5 then
	                                if not IsPedDeadOrDying(MP.peds[i]) then
	                                    TriggerServerEvent('mp_robbery:startRobbing', i)
	                                    while MP.robbing do Wait(0) if IsPedDeadOrDying(MP.peds[i]) then MP.robbing = false TriggerServerEvent('mp_robbery:robbing', i, MP.robbing) TriggerServerEvent('mp_robbery:alertPolice', i, 1) end end
	                                end
	                            else
	                                ClearPedTasks(MP.peds[i])
	                                ESX.ShowNotification(MP.Config.Locales['walked_too_far'])
	                                MP.robbing = false
	                                TriggerServerEvent('mp_robbery:robbing', i, MP.robbing)
	                            end
	                        elseif policeEnough == 'no_cops' then
	                            local wait = GetGameTimer()+5000
	                            while wait >= GetGameTimer() do
	                                Wait(0)
	                                DrawText3D(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 1.5, 0.4), MP.Config.Locales['no_cops'])
	                            end
	                        else
	                            TriggerEvent('mp_robbery:msg', i, MP.Config.Locales['alreadyRobbed'], 5)
	                            Wait(2500)
	                        end
                        end
                    end
                end
            end
        end
    end
end)

loadDict = function(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())
  
    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()
  
    AddTextComponentString(text)
    DrawText(_x, _y)
end
