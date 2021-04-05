ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
MP.deadPeds = {}

RegisterServerEvent('mp_robbery:pedDead')
AddEventHandler('mp_robbery:pedDead', function(store)
    if not MP.deadPeds[store] then
        MP.deadPeds[store] = 'dead'
        TriggerClientEvent('mp_robbery:onPedDeath', -1, store)
        MP.Config.Locations["24/7"][store].robbing = false
        local cooldown = MP.Config.Locations["24/7"][store].coolDown
        Wait(cooldown)

        for k, v in pairs(MP.deadPeds) do if k == store then table.remove(MP.deadPeds, k) end end
        MP.Config.Locations["24/7"][store].robbed = false
        TriggerClientEvent('mp_robbery:resetStore', -1, store)
    end
end)

ESX.RegisterServerCallback('mp_robbery:isRobbing', function(source, cb, store)
    cb(MP.Config.Locations["24/7"][store].robbing)
end)

RegisterServerEvent('mp_robbery:robbing')
AddEventHandler('mp_robbery:robbing', function(store, bool)
    MP.Config.Locations["24/7"][store].robbing = bool
end)

RegisterServerEvent('mp_robbery:giveMoney')
AddEventHandler('mp_robbery:giveMoney', function(store)
    local xPlayer = ESX.GetPlayerFromId(source)
    local randomAmount = math.random(MP.Config.Locations["24/7"][store].reward[1], MP.Config.Locations["24/7"][store].reward[2])
    xPlayer.addMoney(randomAmount)
    TriggerClientEvent('esx:showNotification', source, MP.Config.Locales['cashrecieved'] .. ' ~g~' .. randomAmount .. ' ' .. MP.Config.Locales['currency'])
end)

RegisterServerEvent('mp_robbery:pickUp')
AddEventHandler('mp_robbery:pickUp', function()
    TriggerClientEvent('mp_robbery:removePickup', -1, store) 
end)

ESX.RegisterServerCallback('mp_robbery:policeEnough', function(source, cb, store)
    local cops = 0
    local xPlayers = ESX.GetPlayers()
    for _, player in ipairs(xPlayers) do
        local xPlayer = ESX.GetPlayerFromId(player)
        if xPlayer.job.name == 'police' then
            cops = cops + 1
        end
    end
    if cops >= MP.Config.Locations["24/7"][store].policeRequired then
        if not MP.Config.Locations["24/7"][store].robbed and not MP.deadPeds[store] and not MP.Config.Locations["24/7"][store].robbing then
            cb(true)
        else
            cb(false)
        end
    else
        cb('no_cops')
    end
end)

RegisterServerEvent('mp_robbery:alertPolice')
AddEventHandler('mp_robbery:alertPolice', function(store, style)
    local src = source
    local xPlayers = ESX.GetPlayers()
    for i = 1, #xPlayers do
        local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
        if xPlayer.job.name == 'police' then
            TriggerClientEvent('mp_robbery:alertPolice', xPlayer.source, store, src, style)
        end
    end
end)

RegisterServerEvent('mp_robbery:startRobbing')
AddEventHandler('mp_robbery:startRobbing', function(store)
    local src = source
    TriggerClientEvent('mp_robbery:startRobbing', -1, store)
    Wait(22500)
    TriggerClientEvent('mp_robbery:giveMoney', src, store)
    TriggerClientEvent('mp_robbery:removePickup', -1, store) 
    Wait(30000)
    TriggerClientEvent('mp_robbery:robberyOver', src, store)
    MP.Config.Locations["24/7"][store].robbed = true

    local cooldown = MP.Config.Locations["24/7"][store].coolDown
    Wait(cooldown)
    if not MP.deadPeds[store] then
        for k, v in pairs(MP.deadPeds) do if k == store then table.remove(MP.deadPeds, k) end end
        MP.Config.Locations["24/7"][store].robbed = false
        TriggerClientEvent('mp_robbery:resetStore', -1, store)
    end
end)