-- GANG WARS CLIENT
CreateThread(function()
    if Config.Framework ~= "qb" then return end
    local QBCore
 
    while not QBCore do
        QBCore = exports["qb-core"]:GetCoreObject()
        Wait(500)
        TriggerServerEvent('xex_gangwars:getZones')
    end
    local PlayerData = QBCore.Functions.GetPlayerData()

    local mapZoneBlips = {}
    local zones
    local conquering = false
    
    RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
        PlayerData.gang = gang
        loadMarkers()
    end)

    RegisterNetEvent('xex_gangwars:setZones') 
    AddEventHandler('xex_gangwars:setZones', function(zonesData)  
        zones = zonesData
        loadMarkers()
    end)

    function isGangMember()
        for i = 0, #Config.gangJobs do
            if PlayerData.gang and Config.gangJobs[PlayerData.gang.name] ~= nil then
                return true
            end
        end
        return false
    end

    -- Delete blips and recharge from server zones
    function loadMarkers() 
        if Config.blipsEnabled then
            deleteBlips()

            if isGangMember() then
                for k, v in pairs(zones) do
                    if (v.blipActive or v.owner == '') then
                        local blip = AddBlipForArea(v.coords.x, v.coords.y, v.coords.z, v.coords.width, v.coords.height)
                        SetBlipRotation(blip, v.coords.rotation)
                        SetBlipColour(blip, v.color)
                        mapZoneBlips[k] = blip
                    end
                end
            end
        end
    end

    function deleteBlips()
        if Config.blipsEnabled then
            for k,v in pairs(mapZoneBlips) do
                RemoveBlip(v)
                mapZoneBlips[k] = nil
            end
        end
    end

    function tryToConquerZone(k, v)
        local playerPed = PlayerPedId()
        local isDead = IsEntityDead(playerPed)

        if Config.useRpProgress then
            -- Maybe it should be improved
            QBCore.Functions.Progressbar("conquer", L('conquering'), Config.msToGetPoints, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = false,
            }, {}, {}, {}, function() -- Done
               
            end, function() -- Cancel
               
            end)
        else
            QBCore.Functions.Notify(L('conquering'), "success")
        end

        Citizen.Wait(Config.msToGetPoints)
        local playerPed = GetPlayerPed(-1)
        -- Add point if it's inside for X seconds
        if (IsPedInRotatedArea(v) and PlayerData.gang.name ~= nil and not isDead) then
            TriggerServerEvent('xex_gangwars:addZonePoint', PlayerData.gang.name, v.name)
        else
            QBCore.Functions.Notify(L('not_enough_time'), "error")
        end
        conquering = false
    end

    Citizen.CreateThread(function()
        local found = false
        while true do
            Citizen.Wait(2000)
            local playerPed = GetPlayerPed(-1)
            if PlayerData and isGangMember() then
                for k, v in pairs(zones) do
                    if (GetDistanceBetweenCoords( vector3(v.coords.x, v.coords.y, v.coords.z), GetEntityCoords(playerPed)) < 500 ) then
                        found = true
                        if (IsPedInRotatedArea(v)) then
                            -- Inside zone, start conquering
                            if (conquering == false and v.status ~= 3 ) then
                                if (v.pointRecent) then
                                    QBCore.Functions.Notify(L('wait_for_points'), "error")
                                    Citizen.Wait(20000)
                                else
                                    conquering = true
                                    tryToConquerZone(k, v)
                                end
                            end
                        end
                    end
                end

                if not found then 
                    Citizen.Wait(20000)
                end
            else
                Citizen.Wait(20000) 
            end
        end
    end)


    function IsPedInRotatedArea(vdata)
        local origin = vector3(vdata.coords.x, vdata.coords.y, vdata.coords.z) -- Origin of the coordinate system
        local r = vdata.coords.rotation * math.pi / 180 -- Radian to turn the points
        local c1 = vector3(origin.x - vdata.coords.width / 2, origin.y + vdata.coords.height / 2, -100.0)
        local c2 = vector3(origin.x + vdata.coords.width / 2, origin.y - vdata.coords.height / 2, 100.0)
        local v = GetEntityCoords(PlayerPedId())
        v = vector3(
            (v.x - origin.x) * math.cos(r) + (v.y - origin.y) * math.sin(r) + origin.x,
            (v.x - origin.x) * math.sin(r) - (v.y - origin.y) * math.cos(r) + origin.y, 
            v.z
        )
        return ((v.x < c1.x and v.x > c2.x) or (v.x > c1.x and v.x < c2.x)) and ((v.y < c1.y and v.y > c2.y) or (v.y > c1.y and v.y < c2.y)) and ((v.z < c1.z and v.z > c2.z) or (v.z > c1.z and v.z < c2.z))
    end


    -- Flash zones if status is == 2 (Conquerable)
    Citizen.CreateThread(function()
        local found = false
        while true do
            Citizen.Wait(3000)
            if PlayerData and isGangMember() then
                for k, v in pairs(zones) do
                    if (v.status == 2 ) then
                        found = true
                        if (v.blipActive) then
                            v.blipActive = false
                        else
                            v.blipActive = true
                        end
                        loadMarkers()
                    end
                end

                if not found then 
                    Citizen.Wait(20000)
                end
            else
                Citizen.Wait(20000) 
            end
        end
    end)

end)