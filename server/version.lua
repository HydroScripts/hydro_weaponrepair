local Config = require 'config'
local resourceName = "hydro_weaponrepair"
local curVersion = GetResourceMetadata(GetCurrentResourceName(), "version")

if Config.VersionUpdates then
    CreateThread(function()
        if GetCurrentResourceName() ~= "hydro_weaponrepair" then
            resourceName = "hydro_weaponrepair (" .. GetCurrentResourceName() .. ")"
        end
    end)

    CreateThread(function()
        while true do
            PerformHttpRequest("https://api.github.com/repos/HydroScripts/hydro_weaponrepair/releases/latest", CheckVersion, "GET")
            Wait(3600000)
        end
    end)

    CheckVersion = function(err, responseText, headers)
        local repoVersion, repoURL, _ = GetRepoInformations()

        CreateThread(function()
            if curVersion ~= repoVersion then
                Wait(4000)
                print("^0[^6ALERT^0] " .. resourceName .. "' is ^5outdated^0.")
                print("^0[^6ALERT^0] Installed Version: ^5" .. curVersion .. "^0")
                print("^0[^6ALERT^0] New Version Available: ^5" .. repoVersion .. "^0")
                print("^0[^6ALERT^0] Download the latest version here: ^5" .. repoURL .. "^0")
            else
                Wait(4000)
                print("^0[^5STATUS^0] " .. resourceName .. " is up to date. Current Version: ^5" .. curVersion .. "^0")
            end
        end)
    end

    GetRepoInformations = function()
        local repoVersion, repoURL = nil, nil

        PerformHttpRequest("https://api.github.com/repos/HydroScripts/hydro_weaponrepair/releases/latest", function(err, response, headers)
            if err == 200 then
                local data = json.decode(response)

                repoVersion = data.tag_name
                repoURL = data.html_url
            else
                repoVersion = curVersion
                repoURL = "https://github.com/HydroScripts/hydro_weaponrepair"
            end
        end, "GET")

        repeat
            Wait(50)
        until (repoVersion and repoURL)

        return repoVersion, repoURL
    end
end