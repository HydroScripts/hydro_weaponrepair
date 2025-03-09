RegisterNetEvent('hydro_weaponrepair:benchrepair', function(data)
    if lib.progressCircle({
        duration = 13500,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            move = true,
            car = true,
        },
        anim = {
            dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
            clip = 'machinic_loop_mechandplayer'
        }
    }) then 
        TriggerServerEvent('hydro_weaponrepair:finishbenchrepair', data)
    end
end)

RegisterNetEvent('hydro_weaponrepair:notify', function(title, desc, pos, dur, style)
    if GetResourceState("wasabi_notify") == "started" then
        exports.wasabi_notify:advancedNotify({
            title = title or false,
            message = desc or false,
            position = pos or 'right',
            time = dur or 5000,
            type = style or 'inform',
            sound = true
        })
    elseif GetResourceState("ox_lib") == "started" then
        lib.notify({
            title = title or false,
            description = desc or false,
            position = pos or 'center-right',
            duration = dur or 5000,
            type = style or 'inform'
        })
    end
end)