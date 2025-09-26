-- Shared streams (inline)
local streams = {
    {name = "Rock FM", path = "mods/radio/sounds/rock.ogg", song = "Guitar Riff - Band X"},
    {name = "Pop Hits", path = "mods/radio/sounds/pop.ogg", song = "Catchy Tune - Artist Y"},
    {name = "Chill Vibes", path = "mods/radio/sounds/chill.ogg", song = "Relaxing Beat - DJ Z"}
}

-- Vehicle radio data: {vehID = {station=0, volume=50}}
local vehicleRadios = {}

-- Change station
function changeStation(player_id, station)
    if station < 0 or station > #streams then return end
    local vehID = MP.GetPlayerVehicleID(player_id)  -- BeamMP helper
    if not vehID then return end
    vehicleRadios[vehID] = vehicleRadios[vehID] or {}
    vehicleRadios[vehID].station = station
    MP.TriggerClientEvent(-1, "radio:syncStation", tostring(vehID), station)  -- Broadcast to all
end
MP.RegisterEvent("radio:changeStation", changeStation)

-- Change volume
function changeVolume(player_id, vol)
    vol = math.max(0, math.min(100, vol))
    local vehID = MP.GetPlayerVehicleID(player_id)
    if not vehID then return end
    vehicleRadios[vehID] = vehicleRadios[vehID] or {}
    vehicleRadios[vehID].volume = vol
    veh = be:getObjectByID(vehID)  -- Set field for client access
    if veh then veh:setField("radio:volume", vol) end
    MP.TriggerClientEvent(-1, "radio:syncVolume", tostring(vehID), vol)
    MP.SendChatMessage(-1, MP.GetPlayerName(player_id) .. " adjusts the radio volume.")
end
MP.RegisterEvent("radio:changeVolume", changeVolume)

-- Admin mute command (/srd via client trigger)
function srdCommand(player_id)
    if not MP.IsPlayerAdmin(player_id) then return end  -- Assume admin check
    local player = be:getPlayerByID(player_id)
    local x, y, z = player:getPosition()
    local muted = 0
    for vehID, data in pairs(vehicleRadios) do
        local veh = be:getObjectByID(vehID)
        if veh then
            local vx, vy, vz = veh:getPosition()
            local dist = math.sqrt((x-vx)^2 + (y-vy)^2 + (z-vz)^2)
            if dist < 200 then
                changeVolume(-1, 0)  -- Mute via event (broadcast)
                muted = muted + 1
            end
        end
    end
    local admins = {}
    for _, pid in ipairs(MP.GetPlayers()) do
        if MP.IsPlayerAdmin(pid) then
            table.insert(admins, pid)
        end
    end
    for _, pid in ipairs(admins) do
        MP.SendChatMessage(pid, "AdmWrn: " .. MP.GetPlayerName(player_id) .. " muted " .. muted .. " radios nearby.")
    end
end
MP.RegisterEvent("admin:srd", srdCommand)  -- Trigger from client console

-- On vehicle spawn, init radio
MP.RegisterEvent("onVehicleSpawned", function(player_id, vehID)
    vehicleRadios[vehID] = {station=0, volume=50}
end)

-- Cleanup on leave
MP.RegisterEvent("onPlayerLeft", function(player_id)
    local vehID = MP.GetPlayerVehicleID(player_id)
    if vehID then
        vehicleRadios[vehID] = nil
        MP.TriggerClientEvent(-1, "radio:syncStation", tostring(vehID), 0)
    end
end)
