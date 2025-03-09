local Config = require 'config'

function RepairBenchMenu(data)
    local weapons = {}
    local playerInventory = GetPlayerInventory()

    for _, item in pairs(playerInventory) do
        if item.name and string.find(string.upper(item.name), 'WEAPON_') then
            local isBlacklisted = false
            for _, blacklistedWeapon in pairs(Config.BlacklistedWeapons) do
                local itemLowerCase = string.lower(item.name)
                local blacklistedWeaponLowerCase = string.lower(blacklistedWeapon)
                if itemLowerCase == blacklistedWeaponLowerCase then
                    isBlacklisted = true
                    break
                end
            end
            if not isBlacklisted then
                GetLabels()
                local descr = ""
                local partsList = {}
                local durability = item.metadata and item.metadata.durability or 100

                for _, part in ipairs(data.RepairParts) do
                    local label = labels[string.lower(part.ItemName)] or part.ItemName
                    table.insert(partsList, { label = label, amount = part.Amount })
                end

                table.sort(partsList, function(a, b)
                    return #a.label < #b.label
                end)
                
                for _, part in ipairs(partsList) do
                    descr = descr .. string.format("%s (x%d) | ", part.label, part.amount)
                end
                
                descr = descr:sub(1, -3)

                table.insert(weapons, {
                    icon = 'gun',
                    title = item.label,
                    description = descr,
                    progress = durability,
                    colorScheme = ColorScheme(durability),
                    serverEvent = "hydro_weaponrepair:weaponbenchrepair",
                    args = {
                        weapon = item,
                        inventory = playerInventory,
                        dat = data
                    }
                })
            end
        end
    end

    lib.registerContext({
        id = 'RepairMenu',
        title = 'Weapon Repair Bench',
        options = weapons
    })
    lib.showContext('RepairMenu')
end

CreateThread(function()
    for _, BenchData in pairs(Config.RepairBenches) do
        if BenchData.Blip and BenchData.Blip.enabled then
            local blip = createBlip(BenchData.Bench.Coords.xyz, BenchData.Blip.sprite, BenchData.Blip.scale, BenchData.Blip.color, BenchData.Blip.label)
            SetBlipCategory(blip, 12)
        end
        startModelLoop(BenchData)
    end
end)