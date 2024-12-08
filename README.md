# QBCORE-Carmenu

If the file doesn't work please change the client.lua with the script below:

QBCore = exports['qb-core']:GetCoreObject()

local vehicles = {
    { name = "Lamborghini Aventador", model = "aventador" },
    { name = "Bugatti Chiron", model = "chiron" },
    { name = "Tesla Model S", model = "tesla" },
}

RegisterCommand("carmenu", function()
    local menu = {}
    for _, vehicle in pairs(vehicles) do
        table.insert(menu, {
            header = vehicle.name,
            params = {
                event = "qb-carmenu:spawnVehicle",
                args = { model = vehicle.model }
            }
        })
    end
    TriggerEvent('qb-menu:client:openMenu', menu)
end)

RegisterNetEvent('qb-carmenu:spawnVehicle', function(data)
    local model = GetHashKey(data.model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local vehicle = CreateVehicle(model, pos.x + 5, pos.y, pos.z, heading, true, false)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    SetModelAsNoLongerNeeded(model)
    QBCore.Functions.Notify("Vehicle spawned: " .. data.model, "success")
end)

any problems happen please dm me on discord at johnnydevelopment
