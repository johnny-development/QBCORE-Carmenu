QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qb-vehiclemenu:canSpawn', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    if Player and Player.PlayerData.job.name == "mechanic" then
        cb(true)
    else
        cb(false)
    end
end)
