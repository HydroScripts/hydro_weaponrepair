return {
    RepairBenches = {
        {
            Blip = {
                enabled = false, -- Enable? true or false
                color = 1, -- Blip color
                scale = 0.7, -- Blip scale
                sprite = 110, -- Blip sprite
                label = "Repair Bench", -- Blip label
                coords = vector3(417.9745, 347.4716, 102.4208), -- Blip coords
            },
            Bench = {
                Model = "gr_prop_gr_bench_04b", -- Bench Model
                Coords = vector4(417.9745, 347.4716, 102.4208-0.9, 127.8265), -- Bench spawn coords
            },
            RepairParts = { -- Parts required to repair a weapon at this bench
                {
                    amount = 1, -- Part amount
                    itemName = "gun_metal" -- Part spawn name
                },
            }            
        },
        -- Add more benches as needed
    },

    BlacklistedWeapons = { -- Weapons that cannot be repaired
        'weapon_ball',
        'weapon_bzgas',
        'weapon_bottle',
        'weapon_petrolcan'
    }
}