-- Tables
local tables = {
    StationAcceptPolicy = {
        [0] = "Open",
        [1] = "Closed",
        [2] = "Blacklist",
        [3] = "Whitelist"
    }
}

-- Proto fields
local f_security_param = ProtoField.bytes("ldn_mitm.ldn_network.security_param", "Security parameter", base.NONE)
local f_security_mode = ProtoField.uint16("ldn_mitm.ldn_network.security_mode", "Security mode")
local f_station_accept_policy =
    ProtoField.uint8(
    "ldn_mitm.ldn_network.station_accept_policy",
    "Station accept policy",
    base.DEC,
    tables.StationAcceptPolicy
)
local f_unknown1 = ProtoField.uint8("ldn_mitm.ldn_network.unknown1", "Unknown 1", base.DEC_HEX)
local f_max_nodes = ProtoField.uint8("ldn_mitm.ldn_network.max_nodes", "Max nodes", base.DEC)
local f_node_count = ProtoField.uint8("ldn_mitm.ldn_network.node_count", "Node count", base.DEC)
local f_advertise_data_size =
    ProtoField.uint16("ldn_mitm.ldn_network.advertise_data_size", "Advertisement data size", base.DEC_HEX)
local f_advertise_data = ProtoField.bytes("ldn_mitm.ldn_network.advertise_data", "Advertisement data", base.NONE)
local f_authentication_id =
    ProtoField.uint64("ldn_mitm.ldn_network.authentication_id", "Authentication ID", base.HEX_DEC)

-- Proto
local p_ldn_network = Proto("ldn_mitm.ldn_network", "Ldn network info")
p_ldn_network.fields = {
    f_security_param,
    f_security_mode,
    f_station_accept_policy,
    f_unknown1,
    f_max_nodes,
    f_node_count,
    f_advertise_data_size,
    f_advertise_data,
    f_authentication_id
}

-- Dissector
function p_ldn_network.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then
        return
    end

    local subtree = tree:add(p_ldn_network, buffer(0, 1072), "Ldn network info")
    subtree:add_le(f_security_param, buffer(0, 16))
    subtree:add_le(f_security_mode, buffer(16, 2))
    subtree:add_le(f_station_accept_policy, buffer(18, 1))
    subtree:add_le(f_unknown1, buffer(19, 1))
    -- padding 2
    subtree:add_le(f_max_nodes, buffer(22, 1))
    subtree:add_le(f_node_count, buffer(23, 1))
    -- 8 nodes
    Dissector.get("ldn_mitm.nodes"):call(buffer(24, 64 * 8):tvb(), pinfo, subtree)
    -- padding 2
    subtree:add_le(f_advertise_data_size, buffer(538, 2))
    subtree:add_le(f_advertise_data, buffer(540, 384))
    -- padding 140 (0x8C)
    subtree:add_le(f_authentication_id, buffer(1064, 8))
end
