local repairBenchesSpawned = {}
local Config = require 'config'

function ColorScheme(value)
    if value >= 80 then
        return "green.6"
    elseif value >= 60 then
        return "yellow.6"
    elseif value >= 40 then
        return "orange.6"
    else
        return "red.8"
    end
end

function requestModel(model)
    if type(model) == 'number' then
        model = model
    elseif type(model) == 'string' then
        model = GetHashKey(model)
    end
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(0) end
    return model
end

function createBlip(coords, sprite, scale, color, label)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, scale)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(label)
    EndTextCommandSetBlipName(blip)
    return blip
end

function createModel(model, coords, heading)
    local model = lib.requestModel(model)
    local repairBench = CreateObject(model, coords.x, coords.y, coords.z, false, false, false)
    SetEntityHeading(repairBench, heading + 178.0)
    FreezeEntityPosition(repairBench, true)
    SetModelAsNoLongerNeeded(model)
    return repairBench
end

function startModelLoop(data)
    CreateThread(function()
        while true do
            local sleep = 1500
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - data.Bench.Coords.xyz)

            if distance <= Config.SpawnDistance then
                if not repairBenchesSpawned[data.Bench.Coords.xyz] then
                    local repairBench = createModel(data.Bench.Model, data.Bench.Coords.xyz, data.Bench.Coords.w)
                    repairBenchesSpawned[data.Bench.Coords.xyz] = repairBench

                    exports.ox_target:addLocalEntity(repairBench, {
                        {
                            icon = 'fa-solid fa-wrench',
                            label = 'Open Repair Bench',
                            distance = 2.0,
                            onSelect = function()
                                RepairBenchMenu(data)
                            end
                        }
                    })
                end
            elseif distance > Config.SpawnDistance and repairBenchesSpawned[data.Bench.Coords.xyz] then
                DeleteEntity(repairBenchesSpawned[data.Bench.Model])
                repairBenchesSpawned[data.Bench.Coords.xyz] = nil
            end
            Wait(sleep)
        end
    end)
end

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if repairBenchSpawned then
            DeleteEntity(repairBench)
            exports.ox_target:removeLocalEntity(repairBench)
            repairBenchSpawned = false
        end
    end
end)