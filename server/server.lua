local config = require 'config'

RegisterNetEvent('hydro_weaponrepair:finishbenchrepair', function(data)
    local s = source
    local plyrcrds = GetEntityCoords(GetPlayerPed(s))
    for _, BenchData in pairs(config.RepairBenches) do
        local distance = #(plyrcrds - vector3(BenchData.Bench.Coords.x, BenchData.Bench.Coords.y, BenchData.Bench.Coords.z))
            
        if distance > 8.0 then
            DropPlayer(s, "Exploiting Weapon Repair Bench")
            print('Exploit Protection', 'Player attempted to repair a weapon while too far away', "PlayerID: " .. s)
            return
        end
        exports.ox_inventory:SetDurability(s, data.weapon.slot, 100)
    end
end)

RegisterNetEvent('hydro_weaponrepair:weaponbenchrepair', function(data)
    local s = source
    local plyrcrds = GetEntityCoords(GetPlayerPed(s))

    if data.weapon.metadata.durability >= 100 then
        TriggerClientEvent('hydro_weaponrepair:notify', s, 'Weapon Repair Bench', 'Weapon durability is already at maximum', false, false, 'error')
        return
    end
    
    for _, BenchData in pairs(config.RepairBenches) do
        local distance = #(plyrcrds - vector3(BenchData.Bench.Coords.x, BenchData.Bench.Coords.y, BenchData.Bench.Coords.z))
        
        if distance > 8.0 then
            DropPlayer(s, "Exploiting Weapon Repair Bench")
            print('Exploit Protection', 'Player attempted to repair a weapon while too far away', "PlayerID: " .. s)
            return
        end

        if distance <= 2.5 then
            if data.inventory then
                local missingParts = {}
                for _, repairParts in ipairs(BenchData.RepairParts) do
                    local hasItem = false
                    for _, item in pairs(data.inventory) do
                        if item and item.name == repairParts.itemName and item.count >= repairParts.amount then
                            exports.ox_inventory:RemoveItem(s, repairParts.itemName, repairParts.amount)
                            hasItem = true
                            break
                        end
                    end
                    if not hasItem then
                        table.insert(missingParts, repairParts.amount .. "x " .. repairParts.itemName)
                    end
                end
                if #missingParts > 0 then
                    local partsNeeded = table.concat(missingParts, ". ")
                    TriggerClientEvent('hydro_weaponrepair:notify', s, 'Weapon Repair Bench', 'Not enough required items to repair this weapon. ' .. partsNeeded, false, false, 'error')
                    return
                end
                TriggerClientEvent('hydro_weaponrepair:benchrepair', s, data)
            end
        end
    end
end)