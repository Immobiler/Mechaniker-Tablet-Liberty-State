--Client.Lua

local isOpen      = false
local isTokenOpen = false
local myToken     = nil
local myName      = nil
local RES         = GetCurrentResourceName()



RegisterCommand('coastnet', function()
    if isOpen or isTokenOpen then return end
    isOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({ action = 'open' })

    -- Identifier senden → Auto-Login falls Lizenz stimmt
    local ident = GetPlayerIdentifier(PlayerId(), 0) or ''
    for i = 0, GetNumPlayerIdentifiers(PlayerId()) - 1 do
        local id = GetPlayerIdentifier(PlayerId(), i)
        if id and string.sub(id, 1, 8) == 'license:' then
            ident = id
            break
        end
    end
    Citizen.SetTimeout(300, function()
        SendNUIMessage({ action = 'setIdentifier', identifier = ident })
    end)

    if myToken then
        Citizen.SetTimeout(500, function()
            SendNUIMessage({ action = 'receiveToken', token = myToken, playerName = myName or '' })
        end)
    end
end, false)

RegisterKeyMapping('coastnet', 'COAST.NET Tablet oeffnen', 'keyboard', 'F5')



RegisterNUICallback('close', function(_, cb)
    cb('ok')
    isOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
end)


RegisterCommand('cn_token', function()
    TriggerServerEvent('coastnet:server:requestToken')
end, false)



RegisterNetEvent('coastnet:client:receiveToken')
AddEventHandler('coastnet:client:receiveToken', function(token, playerName)
    myToken = token
    myName  = playerName or ''

    
    TriggerEvent('chat:addMessage', {
        color = { 255, 200, 0 },
        args  = { '[COAST.NET]', 'Dein Token: ^3' .. tostring(token) .. '^7' }
    })

    if isOpen then
        
        Citizen.SetTimeout(100, function()
            SendNUIMessage({ action = 'receiveToken', token = token, playerName = myName })
        end)
    elseif not isTokenOpen then
        
        isTokenOpen = true
       
        Citizen.CreateThread(function()
            SetNuiFocus(true, true)
            Citizen.Wait(800) 
            SendNUIMessage({ action = 'showTokenDisplay', token = token })
        end)
    end
end)



RegisterNUICallback('closeTokenDisplay', function(_, cb)
    cb('ok')
    isTokenOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'hideTokenDisplay' })
end)



RegisterNUICallback('setFullscreen', function(_, cb)
    cb('ok')
end)

RegisterNUICallback('validateToken', function(data, cb)
    cb('ok')
    TriggerServerEvent('coastnet:server:validateToken', data.token, data.username)
end)

RegisterNUICallback('loadTokensFromDB', function(_, cb)
    cb('ok')
    TriggerServerEvent('coastnet:server:loadTokens')
end)

RegisterNUICallback('setCitizenJob', function(data, cb)
    cb('ok')
    TriggerServerEvent('coastnet:server:setCitizenJob',
        data.citizenId, data.job, data.jobRank, data.secondJob, data.secondRank)
end)

RegisterNUICallback('loadCitizensFromDB', function(_, cb)
    cb('ok')
    TriggerServerEvent('coastnet:server:loadCitizens')
end)

RegisterNUICallback('loadVehiclesFromDB', function(_, cb)
    cb('ok')
    TriggerServerEvent('coastnet:server:loadVehicles')
end)

RegisterNUICallback('getPlayerIdentifier', function(_, cb)
    cb('ok')
    TriggerServerEvent('coastnet:server:getPlayerIdentifier')
end)

RegisterNUICallback('saveCitizen', function(data, cb)
    cb('ok')
    TriggerServerEvent('coastnet:server:saveCitizen', data.citizen)
end)

RegisterNUICallback('saveVehicle', function(data, cb)
    cb('ok')
    TriggerServerEvent('coastnet:server:saveVehicle', data.vehicle)
end)



RegisterNetEvent('coastnet:client:tokenResult')
AddEventHandler('coastnet:client:tokenResult', function(success, dataOrMsg, identifier, username)
    if success then
        myToken = nil
        TriggerEvent('chat:addMessage', {
            color = { 0, 255, 0 },
            args  = { '[COAST.NET]', 'Registriert als ^2' .. tostring(username) .. '^7!' }
        })
        SendNUIMessage({
            action     = 'tokenValidated',
            success    = true,
            citizen    = dataOrMsg,
            identifier = identifier,
            username   = username
        })
    else
        SendNUIMessage({ action = 'tokenValidated', success = false, message = dataOrMsg })
    end
end)

RegisterNetEvent('coastnet:client:receiveTokens')
AddEventHandler('coastnet:client:receiveTokens', function(tokens)
    SendNUIMessage({ action = 'loadTokens', tokens = tokens or {} })
end)

RegisterNetEvent('coastnet:client:receiveCitizens')
AddEventHandler('coastnet:client:receiveCitizens', function(citizens)
    SendNUIMessage({ action = 'loadCitizens', citizens = citizens or {} })
end)

RegisterNetEvent('coastnet:client:receiveVehicles')
AddEventHandler('coastnet:client:receiveVehicles', function(vehicles)
    SendNUIMessage({ action = 'loadVehicles', vehicles = vehicles or {} })
end)

RegisterNetEvent('coastnet:client:receiveIdentifier')
AddEventHandler('coastnet:client:receiveIdentifier', function(identifier)
    SendNUIMessage({ action = 'setIdentifier', identifier = identifier })
end)



RegisterNetEvent('coastnet:client:refreshRequired')
AddEventHandler('coastnet:client:refreshRequired', function()

    if isOpen then
        Citizen.SetTimeout(300, function()
            TriggerServerEvent('coastnet:server:loadCitizens')
            TriggerServerEvent('coastnet:server:loadVehicles')
        end)
        SendNUIMessage({ action = 'refreshRequired' })
    end
end)



RegisterCommand('fix', function()
    isOpen      = false
    isTokenOpen = false
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    SendNUIMessage({ action = 'hideTokenDisplay' })
    print('^2[COAST] /fix - Cursor reset^7')
end, false)



AddEventHandler('onResourceStop', function(res)
    if res == RES and (isOpen or isTokenOpen) then
        SetNuiFocus(false, false)
    end
end)

print('^2[COAST] ' .. RES .. ' geladen^7')


local positionTimer = 0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(2000) 
        if isOpen then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = GetEntityHeading(ped)
            local serverId = GetPlayerServerId(PlayerId())
            local playerName = GetPlayerName(PlayerId())

            
            TriggerServerEvent('coastnet:server:updatePosition', {
                serverId = serverId,
                name     = playerName,
                x        = coords.x,
                y        = coords.y,
                z        = coords.z,
                heading  = heading
            })
        end
        Citizen.Wait(0)
    end
end)



RegisterNetEvent('coastnet:client:receivePositions')
AddEventHandler('coastnet:client:receivePositions', function(playerList)
    if isOpen then
        SendNUIMessage({ action = 'liveMapPlayers', players = playerList or {} })
    end
end)


RegisterNetEvent('coastnet:client:playerLeft')
AddEventHandler('coastnet:client:playerLeft', function(serverId)
    if isOpen then
        SendNUIMessage({ action = 'liveMapRemove', serverId = serverId })
    end
end)
