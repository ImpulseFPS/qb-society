society = {}

function GetSociety(name)
    local result = exports['ghmattimysql']:executeSync('SELECT * FROM society WHERE name=@name', {['@name'] = name}) --exports['ghmattimysql']:execute("SELECT * FROM `society` WHERE `name` ='"..name.."' ")
    local data = result[1]

    return data
end


RegisterServerEvent('society:server:GetSociety')
AddEventHandler('society:server:GetSociety', function(name, cb)
    cb(GetSociety(name))
end)

QBCore.Functions.CreateCallback('society:server:getSocietyMoney', function(source, cb, n)
    local s = GetSociety(n)

    cb(s.money)
end)

RegisterNetEvent('society:server:WithdrawMoney')
AddEventHandler('society:server:WithdrawMoney', function(pSource, a, n)
    local src = pSource
    if not src then return end

    local player = QBCore.Functions.GetPlayer(src)
    local s = GetSociety(n)
    local sMoney = tonumber(s.money)
    local amount = tonumber(a)
    local withdraw = sMoney - amount

    if not player then return end

    if sMoney >= amount then
        exports.ghmattimysql:execute("UPDATE society SET money = '"..withdraw.."' WHERE name = '"..n.."'")
    end
end)

RegisterServerEvent('society:server:DepositMoney')
AddEventHandler('society:server:DepositMoney', function(pSource, a, n)
    local src = pSource
    if not src then return end
    local player = QBCore.Functions.GetPlayer(src)
    local s = GetSociety(n)
    local sMoney = tonumber(s.money)
    local amount = tonumber(a)
    local deposit = sMoney + amount

    if not player then return end

    if player.PlayerData.money["cash"] >= amount then

        exports.ghmattimysql:execute("UPDATE society SET money = '"..deposit.."' WHERE name = '"..n.."'")
    end
end)

RegisterServerEvent('society:server:createSociety')
AddEventHandler('society:server:createSociety', function(name)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local Society = GetSociety(name)
    if Society == nil then

        exports['ghmattimysql']:execute('INSERT INTO society (name, money) VALUES (@name, @money)', {
            ['@name'] = name,
            ['@money'] = 0
        }, function(rowsChanged) end)
    elseif Society.name == name then
        TriggerClientEvent('QBCore:Notify', src, "This society already exist")
    end
end)

RegisterServerEvent('society:server:sendBill')
AddEventHandler('society:server:sendBill', function(target, amount)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    local target = QBCore.Functions.GetPlayer(target)
    QBCore.Functions.ExecuteSql(false, "INSERT INTO `phone_invoices` (`citizenid`, `amount`, `sender`, `type`) VALUES ('"..target.PlayerData.citizenid.."', '"..tonumber(amount).."', '"..player.PlayerData.citizenid.."', 'bill')")
end)
