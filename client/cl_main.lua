
PlayerJob = {}
PlayerData = {}

isLoggedin = false


RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
    onDuty = PlayerJob.onduty
end)


RegisterNetEvent('QBCore:Client:OnJobUpdate')
AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerData.job = JobInfo
    isLoggedin = false
end)



RegisterCommand('create', function(source)
    if PlayerJob.isboss == true then
        TriggerServerEvent('society:server:createSociety', PlayerJob.name)
    else
        QBCore.Functions.Notify("You are not the owner of your business", "error")
    end
end)

