-- GANG WARS GUIDE

-- STATUS:
-- Unconquered - Grey - 1
-- Conquerable - Color with flash - 2
-- Conquered - Color - 3

Config = {}
function L(cd, ...) if Locales[Config.Language][cd] then return string.format(Locales[Config.Language][cd], ...) else print('Locale is nil ('..cd..')') end end

Config.Language = 'es'
Config.Framework = 'esx' -- 'qb' or 'esx'
Config.CheckForUpdates = true -- false to disable
Config.defaultZoneColor = 0xCCCCCC80 -- grey
Config.defaultStatus = 1 -- Unconquered on each reset
Config.msToGetPoints = 20000 -- 20s default
Config.timeBetweenPoints = 60 -- 1min default Time between point captures
Config.timeBetweenConquers = 12000 -- 20min default - Time between conquers
Config.pointsToCapture = 3
Config.useRpProgress = false -- Download: https://github.com/Mobius1/rprogress
Config.blipsEnabled = true
Config.maxZonesAtSameTime = 4

Config.gangJobs = {
    --ESX
    ['gang'] = { color = 0xFF00FF80 },
    ['gang2'] = { color = 0x0080BF80 },
    ['gang3'] = { color = 0x9FDF809F }, 
    ['gang4'] = { color = 0xa0e31180 },
    ['gang5'] = { color = 0xBDAC1980 },
    ['gang6'] = { color = 0xB4700E80 },
    ['gang7'] = { color = 0x600EB480 },
    ['gang8'] = { color = 0x538B7380 },
    ['gang9'] = { color = 0x16009d80 },
    ['gang10'] = { color = 0xff000080 },
    ['gang11'] = { color = 0x84ff0080 },
    ['gang12'] = { color = 0x44bb3080 },

    -- QB
    ['lostmc'] = { color = 0xFF00FF80 },
    ['ballas'] = { color = 0x0080BF80 },
    ['vagos'] = { color = 0x9FDF809F }, 
    ['cartel'] = { color = 0xa0e31180 },
    ['families'] = { color = 0xFF00FF80 },
    ['triads'] = { color = 0x0080BF80 },
}

Config.initialZones = {
    { 
        name = 'zoneA', 
        coords = {
            x = 2197.58, 
            y = 5036.79, 
            z = 0.0, 
            width = 220.0, 
            height = 135.0, 
            rotation = 45
        },
        color = Config.defaultZoneColor, 
        status = Config.defaultStatus,
        points = {},
        capturePrice = 35000,
    },
    -- { -- City middle
    --     name = 'zoneB', 
    --     coords = {
    --         x = -1033.00, 
    --         y = -1070.0, 
    --         z = 0.0,
    --         width = 195.0, 
    --         height = 199.0, 
    --         rotation = 30
    --     },
    --     color = Config.defaultZoneColor, 
    --     status = Config.defaultStatus,
    --     points = {},
    --     capturePrice = 7500,
    -- },
    { -- South-east
        name = 'zoneC', 
        coords = {
            x = 980.09, 
            y = -2330.13,
            z = 0.0, 
            width = 145.0, 
            height = 270.0, 
            rotation = -5
        },
        color = Config.defaultZoneColor, 
        status = Config.defaultStatus,
        points = {},
        capturePrice = 30000,
    },
    { -- Paleto
        name = 'zoneD', 
        coords = {
            x = 156.09, 
            y = 6386.71, 
            z = 0.0, 
            width = 120.0, 
            height = 120.0, 
            rotation = 35
        },
        color = Config.defaultZoneColor, 
        status = Config.defaultStatus,
        points = {},
        capturePrice = 15000,
    },
    { -- Middle map
        name = 'zoneE',
        coords = {
            x = 1732.691, 
            y = 3700.9, 
            z = 0.0, 
            width = 90.0, 
            height = 90.0, 
            rotation = 30
        },
        color = Config.defaultZoneColor, 
        status = Config.defaultStatus,
        points = {},
        capturePrice = 15000,
    },

    -- { -- City north
    --     name = 'zoneF',
    --     coords = {
    --         x = 108.58, 
    --         y = 193.51, 
    --         z = 105.0, 
    --         width = 48.0, 
    --         height = 168.0, 
    --         rotation = 70
    --     },
    --     color = Config.defaultZoneColor, 
    --     status = Config.defaultStatus,
    --     points = {},
    --     capturePrice = 35000,
    -- },

    { -- Este nave
        name = 'zoneG',
        coords = {
            x = 2753.915, 
            y = 1671.721, 
            z = 0.0, 
            width = 50.0, 
            height = 122.0, 
            rotation = 90
        },
        color = Config.defaultZoneColor, 
        status = Config.defaultStatus,
        points = {},
        capturePrice = 19000,
    },

    { -- Ciudad en canales
        name = 'zoneH',
        coords = {
            x = -1056.07, 
            y = -1566.87, 
            z = 0.0, 
            width = 55.0, 
            height = 65.0, 
            rotation = 35
        },
        color = Config.defaultZoneColor, 
        status = Config.defaultStatus,
        points = {},
        capturePrice = 19000,
    },
}