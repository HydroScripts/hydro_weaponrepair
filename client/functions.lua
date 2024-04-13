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
        local repairBench, repairBenchSpawned
        while true do
            local playerPed = PlayerPedId()
            local sleep = 1500
            local playerCoords = GetEntityCoords(playerPed)
            local distance = #(playerCoords - vector3(data.Bench.Coords.x, data.Bench.Coords.y, data.Bench.Coords.z))
            if distance <= 50 and not repairBenchSpawned then
                repairBench = createModel(data.Bench.Model, vector3(data.Bench.Coords.x, data.Bench.Coords.y, data.Bench.Coords.z), data.Bench.Coords.w)
                repairBenchSpawned = true
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
            elseif distance > 50 and repairBenchSpawned then
                DeleteEntity(repairBench)
                repairBenchSpawned = false
            end
            Wait(sleep)
        end
    end)
end
