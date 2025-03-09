labels, Framework, Inventory = {}, nil, nil

if GetResourceState('es_extended') == 'started' then
    ESX = exports['es_extended']:getSharedObject()
    Framework = 'esx'
elseif GetResourceState('qbx_core') == 'started' then
    Framework = 'qbx'
elseif GetResourceState('qb-core') == 'started' then
    QBCore = exports['qb-core']:GetCoreObject()
    Framework = 'qb'
elseif GetResourceState('ox_core') == 'started' then
    Ox = require '@ox_core.lib.init'
    Framework = 'ox'
else
    -- Add custom framework here
end


if GetResourceState('ox_inventory') == 'started' then
    Inventory = 'ox_inventory'
elseif GetResourceState('qb-inventory') == 'started' then
    Inventory = 'qb-inventory'
else
    -- Add custom inventory here
end

function GetLabels()
    if GetResourceState('ox_inventory') == 'started' then
        for k, v in pairs(exports.ox_inventory:Items()) do
            labels[string.lower(k)] = v.label
        end
    end

    if Framework == "qb" then
        for k, v in pairs(QBCore.Shared.Items) do
            labels[k] = v.label
        end
    end
end


function GetPlayerData()
    if Framework == 'esx' then
        return ESX.GetPlayerData()
    elseif Framework == 'qb' then
        return QBCore.Functions.GetPlayerData()
    elseif Framework == 'qbx' then
        return exports.qbx_core:GetPlayerData()
    elseif Framework == 'ox' then
        return Ox.GetPlayer()
    else
        -- Add custom framework here
    end
end


function GetPlayerInventory()
    if Inventory and Inventory == 'ox_inventory' then
        return exports[Inventory]:GetPlayerItems()
    else
        if Framework == 'esx' then
            return GetPlayerData().inventory
        elseif Framework == 'qb' then
            return GetPlayerData().items
        end
    end
end


function HasItem(item, amount)
    if not item or not amount then return false end
    if Inventory then
        if Inventory == 'ox_inventory' then
            return exports[Inventory]:Search('count', item) >= amount
        else
            return exports[Inventory]:HasItem(item, amount)
        end
    else
        local playerData = GetPlayerData()
        if not playerData then return false end
        local inventory = Framework == 'esx' and playerData.inventory or playerData.items
        if not inventory then return false end
        for _, itemData in pairs(inventory) do
            if itemData and itemData.name == item then
                local count = itemData.amount or itemData.count or 0
                if count >= amount then
                    return true
                end
            end
        end
        return false
    end
end