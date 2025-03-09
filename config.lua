return {
    SpawnDistance = 15,  -- Distance at which repair benches become visible

    VersionUpdates = true,  -- Receive notifications when new versions are released

    RepairBenches = {
        {
            Blip = {
                label = "Repair Bench",  -- Blip label
                color = 1,  -- Blip color
                scale = 0.7,  -- Blip scale
                sprite = 110,  -- Blip sprite
                enabled = true,  -- Enable the blip on the map: true or false
            },
            Bench = {
                Model = "gr_prop_gr_bench_04b",  -- Model of the bench
                Coords = vector4(706.0529, -1139.9736, 23.4674 - 1.0, 181.3103),  -- Bench coordinates and rotation
            },
            RepairParts = {  -- Components required to repair a weapon at this bench
                {
                    Amount = 10,  -- Quantity needed
                    ItemName = "iron"  -- Name of the item
                },
                {
                    Amount = 10,  -- Quantity needed
                    ItemName = "steel"  -- Name of the item
                },
                {
                    Amount = 10,  -- Quantity needed
                    ItemName = "plastic"  -- Name of the item
                },
            }            
        },
        -- Add more repair benches as required
    },

    BlacklistedWeapons = {  -- Weapons that are not eligible for repair
        'weapon_ball',
        'weapon_bzgas',
        'weapon_bottle',
        'weapon_petrolcan'
    }
}
