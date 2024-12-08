local QBCore = exports['qb-core']:GetCoreObject()

-- List of PD vehicles
local pdVehicles = {
    { name = "Police Cruiser", model = "police" },
    { name = "Police SUV", model = "police2" },
    { name = "Unmarked Police Car", model = "police3" },
}

-- Command to open the PD car menu
RegisterCommand("pdmenu", function()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if PlayerData and PlayerData.job and PlayerData.job.name == "police" then
        -- Create the menu
        local menu = {}
        for _, vehicle in pairs(pdVehicles) do
            table.insert(menu, {
                header = vehicle.name,
                params = {
                    event = "qb-pdmenu:spawnVehicle",
                    args = { model = vehicle.model }
                }
            })
        end

        -- Open the menu
        TriggerEvent('qb-menu:client:openMenu', menu)
    else
        QBCore.Functions.Notify("You are not authorized to use this menu!", "error")
    end
end)

-- Event to spawn PD vehicles
RegisterNetEvent('qb-pdmenu:spawnVehicle', function(data)
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
    QBCore.Functions.Notify("PD vehicle spawned: " .. data.model, "success")
end)
