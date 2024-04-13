local config = require 'config'

function RepairBenchMenu(data)
    local weapons = {}
    local playerInventory = exports.ox_inventory:GetPlayerItems()

    for _, item in pairs(playerInventory) do
        if item.name and string.find(item.name, 'WEAPON_') then
            local isBlacklisted = false
            for _, blacklistedWeapon in pairs(config.BlacklistedWeapons) do
                local itemLowerCase = string.lower(item.name)
                local blacklistedWeaponLowerCase = string.lower(blacklistedWeapon)
                if itemLowerCase == blacklistedWeaponLowerCase then
                    isBlacklisted = true
                    break
                end
            end
            if not isBlacklisted then
                table.insert(weapons, {
                    icon = 'gun',
                    title = item.label,
                    progress = item.metadata.durability or 100, -- Assuming max durability if not provided
                    colorScheme = (item.metadata and item.metadata.durability) and 
                                  (item.metadata.durability >= 80 and "green.6" or
                                  (item.metadata.durability >= 60 and "yellow.6" or
                                  (item.metadata.durability >= 40 and "orange.6" or "red.8"))) or "red.8",
                    serverEvent = "hydro_weaponrepair:weaponbenchrepair",
                    args = {
                        weapon = item,
                        inventory = playerInventory
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
    for _, BenchData in pairs(config.RepairBenches) do
        if BenchData.Blip and BenchData.Blip.enabled then
            local blip = createBlip(BenchData.Blip.coords, BenchData.Blip.sprite, BenchData.Blip.scale, BenchData.Blip.color, BenchData.Blip.label)
            SetBlipCategory(blip, 12)
        end
        startModelLoop(BenchData)
    end
end)