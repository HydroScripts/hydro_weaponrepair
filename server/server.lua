local Config = require 'config'

RegisterNetEvent('hydro_weaponrepair:finishbenchrepair', function(data)
    local s = source
    local plyrcrds = GetEntityCoords(GetPlayerPed(s))

    local distance = #(plyrcrds - data.dat.Bench.Coords.xyz)
        
    if distance > 8.0 then
        DropPlayer(s, "Exploiting Weapon Repair Bench")
        print('Exploit Protection', 'Player attempted to repair a weapon while too far away', "PlayerID: " .. s)
        return
    end

    SetDurability(s, data.weapon.slot, 100)
    TriggerClientEvent('hydro_weaponrepair:notify', s, 'Weapon Repair Bench', "The weapon has been successfully restored to optimal condition.", false, false, 'success')
end)

RegisterNetEvent('hydro_weaponrepair:weaponbenchrepair', function(data)
    local s = source
    local plyrcrds = GetEntityCoords(GetPlayerPed(s))

    if Inventory == "ox_inventory" then
        dura = data.weapon.metadata.durability
    else
        dura = data.weapon.info.quality
    end

    if dura >= 100 then
        TriggerClientEvent('hydro_weaponrepair:notify', s, 'Weapon Repair Bench', "Weapon durability is already at maximum...", false, false, 'error')
        return
    end
    
    local distance = #(plyrcrds - data.dat.Bench.Coords.xyz)
    
    if distance > 8.0 then
        DropPlayer(s, "Exploiting Weapon Repair Bench")
        print('Exploit Protection', 'Player attempted to repair a weapon while too far away', "PlayerID: " .. s)
        return
    end

    if distance <= 2.5 then
        if data.inventory then
            local missingParts = {}
            for _, repairParts in ipairs(data.dat.RepairParts) do
                local hasItem = false
                for _, item in pairs(data.inventory) do
                    local amt = Inventory == "ox_inventory" and item.count or item.amount
                    if item and item.name == repairParts.ItemName and amt >= repairParts.Amount then
                        RemoveItem(s, repairParts.ItemName, repairParts.Amount)
                        hasItem = true
                        break
                    end
                end
                if not hasItem then
                    table.insert(missingParts, repairParts.Amount .. "x " .. repairParts.ItemName)
                end
            end
            if #missingParts > 0 then
                local partsNeeded = table.concat(missingParts, ". ")
                TriggerClientEvent('hydro_weaponrepair:notify', s, 'Weapon Repair Bench', "Not enough required items to repair this weapon... " .. partsNeeded, false, false, 'error')
                return
            end
            TriggerClientEvent('hydro_weaponrepair:benchrepair', s, data)
        end
    end
end)