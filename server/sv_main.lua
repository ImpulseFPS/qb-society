PSCore = nil

TriggerEvent('PSCore:GetObject', function(obj) PSCore = obj end)

society = {}

function GetSociety(name)
    local result = PSCore.Functions.ExecuteSql(true, "SELECT * FROM society WHERE name = '"..name.."' ")

    return result[1]
end

PSCore.Functions.CreateCallback('society:server:getSocietyMoney', function(source, cb, n)
    local s = GetSociety(n)

    cb(s.money)
end)

RegisterServerEvent('society:server:GetSociety')
AddEventHandler('society:server:GetSociety', function(name, cb)
    cb(GetSociety(name))
end)


RegisterNetEvent('society:server:WithdrawMoney')
AddEventHandler('society:server:WithdrawMoney', function(a, n)
    local src = source
    local player = PSCore.Functions.GetPlayer(src)
    local s = GetSociety(n)
    local sMoney = tonumber(s.money)
    local amount = tonumber(a)
    if amount < sMoney then
        PSCore.Functions.ExecuteSql(false, "UPDATE society SET money = '"..sMoney - amount.."' WHERE name = '"..n.."'")
        player.Functions.AddMoney('cash', amount, "Society Withdraw")
    else
        TriggerClientEvent('PSCore:Notify', src, "You don\'t have enough money in society")
    end
end)

RegisterNetEvent('society:server:DepositMoney')
AddEventHandler('society:server:DepositMoney', function(a, n)
    local src = source
    local player = PSCore.Functions.GetPlayer(src)
    local s = GetSociety(n)
    local sMoney = tonumber(s.money)
    local amount = tonumber(a)
    if amount < player.PlayerData.money.cash then
        PSCore.Functions.ExecuteSql(false, "UPDATE society SET money = '"..sMoney + amount.."' WHERE name = '"..n.."'")
        player.Functions.RemoveMoney('cash', amount)
    else
        TriggerClientEvent('PSCore:Notify', src, "You don\'t have enough money")
    end
end)

RegisterServerEvent('ps-society:server:DepositSQL') -- FOR JOB EVENTS WHEN DEPOSITING MONEY INTO THE JOB SAFE
AddEventHandler('ps-society:server:DepositSQL', function(amount, name) -- DONT TUCH THIS..
    local safe = GetSociety(name)
    local safeMoney = tonumber(safe.money)
    local amount = tonumber(amount)
    local deposit = safeMoney + amount
    -- EXAMPLE OF TRIGGERING THIS ON SERVER SIDE TriggerEvent('ps-socirty:server:DepositSQL', <amount of money>, <job name>)
    -- NOTE THAT JOB NEEDS TO HAVE SOCIETY FOR IT TO WORK
    PSCore.Functions.ExecuteSql(false, "UPDATE society SET money = '"..deposit.."' WHERE name = '"..name.."'")
end)




RegisterServerEvent('society:server:createSociety')
AddEventHandler('society:server:createSociety', function(name)
    local src = source
    local player = PSCore.Functions.GetPlayer(src)
    local Society = GetSociety(name)
    if Society == nil then

        exports['ghmattimysql']:execute('INSERT INTO society (name, money) VALUES (@name, @money)', {
            ['@name'] = name,
            ['@money'] = 0
        }, function(rowsChanged) end)
    elseif Society.name == name then
        TriggerClientEvent('PSCore:Notify', src, "This society already exist")
    end
end)

RegisterServerEvent('society:server:sendBill')
AddEventHandler('society:server:sendBill', function(target, amount)
    local src = source
    local player = PSCore.Functions.GetPlayer(src)
    local target = PSCore.Functions.GetPlayer(target)
    PSCore.Functions.ExecuteSql(false, "INSERT INTO `phone_invoices` (`citizenid`, `amount`, `sender`, `type`) VALUES ('"..target.PlayerData.citizenid.."', '"..tonumber(amount).."', '"..player.PlayerData.citizenid.."', 'bill')")
end)