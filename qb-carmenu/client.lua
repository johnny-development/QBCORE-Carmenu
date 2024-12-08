local QBCore = nil

-- Initialize QBCore Framework
CreateThread(function()
    while QBCore == nil do
        TriggerEvent('QBCore:GetObject', function(obj) QBCore = obj end)
        Wait(200)
    end
end)

-- List of custom/addon vehicles
local vehicles = {
    { name = "Police viper", model = "08viperscpd" },
    { name = "Bugatti Chiron", model = "chiron" },
    { name = "Tesla Model S", model = "tesla" },
}

-- Register the command for opening the car menu
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

    -- Trigger the QBCore menu to open
    TriggerEvent('qb-menu:client:openMenu', menu)
end)

-- Event for spawning a vehicle
RegisterNetEvent('qb-carmenu:spawnVehicle', function(data)
    local model = GetHashKey(data.model)

    -- Request and load the model
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(0)
    end

    -- Get player position and spawn the vehicle
    local playerPed = PlayerPedId()
    local pos = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)

    local vehicle = CreateVehicle(model, pos.x + 5, pos.y, pos.z, heading, true, false)
    TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
    SetModelAsNoLongerNeeded(model)

    -- Notify the player
    QBCore.Functions.Notify("Vehicle spawned: " .. data.model, "success")
end)
