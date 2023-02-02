-- GANG WARS SERVER

CreateThread(function()
    if Config.Framework ~= "qb" then
        return
    end

    local QBCore = exports["qb-core"]:GetCoreObject()

    -- Setup
    local zones = Config.initialZones
    for k, v in pairs(zones) do
        v.owner = ''
        v.conqueredTime = ''
        v.latestPointTime = ''
        v.pointRecent = false
        v.blipActive = false
    end

    local numberToRemove = #Config.initialZones - Config.maxZonesAtSameTime
    if Config.maxZonesAtSameTime <= #Config.initialZones then
        for i = 1, #Config.initialZones - Config.maxZonesAtSameTime do
            local randomToDelete = math.random(1, #zones)
            table.remove(zones, randomToDelete)
        end
    end
    

    RegisterNetEvent('QBCore:Server:PlayerLoaded')
    AddEventHandler('QBCore:Server:PlayerLoaded', function(Player)
        local _source = source
        TriggerClientEvent('xex_gangwars:setZones', _source, zones)
    end)

    RegisterNetEvent('xex_gangwars:getZones')
    AddEventHandler('xex_gangwars:getZones', function()
        local _source = source
        TriggerClientEvent('xex_gangwars:setZones', _source, zones)
    end)

    RegisterNetEvent('xex_gangwars:addZonePoint')
    AddEventHandler('xex_gangwars:addZonePoint', function(gang, zoneName)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        for k, v in pairs(zones) do
            if (v.name ==  zoneName) then
                if (v.latestPointTime == '' or os.time() > v.latestPointTime + Config.timeBetweenPoints) then
                    local zonePoints = v.points
                    if zonePoints[gang] then
                    zonePoints[gang] = zonePoints[gang] + 1
                    else
                    zonePoints[gang] = 1
                    end
        
                    -- Add point to gang
                    zones[k].points = zonePoints
                    v.latestPointTime = os.time()
                    v.pointRecent = true

                    TriggerClientEvent('QBCore:Notify', src, L('captured_points', zonePoints[gang]), 'success')
                    TriggerClientEvent('xex_gangwars:setZones', -1, zones)
                
                    if (zones[k].points[gang] >= Config.pointsToCapture) then
                        -- Zone conquered
                        v.conqueredTime = os.time()
                        v.owner = gang
                        v.status = 3
                        v.color = Config.gangJobs[gang].color
                        v.blipActive = true
                        v.points = {}
                        exports['qb-management']:AddMoney('society_' .. gang, v.capturePrice)
                        TriggerClientEvent('QBCore:Notify', src,L('captured_zone',v.capturePrice), 'success')
                        TriggerClientEvent('xex_gangwars:setZones', -1, zones)
                    end
                else
                    TriggerClientEvent('QBCore:Notify', src,L('recently_taken'), 'success')
                end
            
            end
        end

    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(30000)
            for k, v in pairs(zones) do
                if (v.owner ~= '' and os.time() > v.conqueredTime + Config.timeBetweenConquers and v.latestPointTime ~= '' ) then
                    v.status = 2
                    v.latestPointTime = ''
                    TriggerClientEvent('xex_gangwars:setZones', -1, zones)
                end
            end
        end
    end)

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(5000)
            for k, v in pairs(zones) do
                if (v.pointRecent and v.latestPointTime ~= '' and os.time() > v.latestPointTime + Config.timeBetweenPoints) then
                    v.pointRecent = false
                    TriggerClientEvent('xex_gangwars:setZones', -1, zones)
                end
            end
        end
    end)

    	-- UPDATE CHECK
	if Config.CheckForUpdates then
		local function VersionLog(_type, log)
			local color = _type == 'success' and '^2' or '^1'
			print(('^8['..GetCurrentResourceName()..']%s %s^7'):format(color, log))
		end

		local function CheckVersion()
			PerformHttpRequest('https://raw.githubusercontent.com/JGCdev/public-version-checks/master/licenseGangwars.txt', function(err, text, headers)
				local currentVersion = GetResourceMetadata(GetCurrentResourceName(), 'version')
				if not text then 
					VersionLog('error', L('cant_run_versioncheck'))
					return 
				end
			
				if text:gsub("%s+", "") == currentVersion:gsub("%s+", "") then
					VersionLog('success', L('latest_version_ok'))
				else
					VersionLog('error', L('current_version', currentVersion))
					VersionLog('error', L('latest_version', text))
					VersionLog('error', L('outdated', text))
				end
			end)
		end
		
		CheckVersion()
	end

end)
