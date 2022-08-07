if GLOBALS == nil or GLOBALS.modules.participants ~= false then
    return
end
GLOBALS.modules.participants = true

-- ProtoField definitions
local f_participant_ip = ProtoField.ipv4("ldn.participant.ip", "IP address")
local f_participant_mac = ProtoField.ether("ldn.participant.mac", "MAC address")
local f_participant_connected = ProtoField.bool("ldn.participant.connected", "Is connected")
local f_participant_username = ProtoField.string("ldn.participant.username", "Username")
local f_participant_app_version = ProtoField.uint16("ldn.participant.version", "Application communication version")

-- Proto definitions
local p_ldn_participants = Proto("ldn.participants", "LDN Participants")
local p_ldn_participant = Proto("ldn.participant", "LDN Participant")
p_ldn_participant.fields = {
    f_participant_ip,
    f_participant_mac,
    f_participant_connected,
    f_participant_username,
    f_participant_app_version
}

-- Dissectors
function p_ldn_participant.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then
        return
    end

    tree:add(f_participant_ip, buffer(0, 4))
    tree:add(f_participant_mac, buffer(4, 6))
    tree:add(f_participant_connected, buffer(10, 1))
    -- padding 1
    tree:add(f_participant_username, buffer(12, 32))
    tree:add(f_participant_app_version, buffer(44, 2))
    -- padding 10
end

function p_ldn_participants.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then
        return
    end

    local participants = tree:add(p_ldn_participants, buffer(), "Participants")
    for i = 1, 8, 1 do
        local participant = participants:add(p_ldn_participant, buffer(56 * (i - 1), 56), "Participant " .. i)
        Dissector.get("ldn.participant"):call(buffer(56 * (i - 1), 56):tvb(), pinfo, participant)
    end
end

-- Add dissector to globals
GLOBALS.dissectors.Participants = Dissector.get("ldn.participants")
