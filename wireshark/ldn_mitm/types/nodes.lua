-- Proto fields
local f_ip = ProtoField.ipv4("ldn_mitm.node.ip", "IPv4 address")
local f_mac = ProtoField.ether("ldn_mitm.node.mac", "MAC address")
local f_node_id = ProtoField.int8("ldn_mitm.node.id", "Node ID", base.DEC)
local f_connected = ProtoField.bool("ldn_mitm.node.connected", "Is connected")
local f_username = ProtoField.stringz("ldn_mitm.node.username", "Username")
local f_local_communication_version =
    ProtoField.uint16("ldn_mitm.node.version", "Local communication version", base.DEC_HEX)

-- Proto
local p_nodes = Proto("ldn_mitm.nodes", "Nodes")
local p_node = Proto("ldn_mitm.node", "Node")
p_node.fields = {f_ip, f_mac, f_node_id, f_connected, f_username, f_local_communication_version}

-- Dissector
function p_node.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then
        return
    end

    local node_id = Struct.unpack("I1", buffer(10, 1):raw())

    local node = tree:add(p_node, buffer(0, 64), "Node " .. node_id)
    node:add_le(f_ip, buffer(0, 4))
    node:add_le(f_mac, buffer(4, 6))
    node:add_le(f_node_id, buffer(10, 1))
    node:add_le(f_connected, buffer(11, 1))
    node:add_le(f_username, buffer(12, 33))
    -- padding 1
    node:add_le(f_local_communication_version, buffer(46, 2))
    -- padding 16
end

function p_nodes.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then
        return
    end

    local nodes = tree:add(p_nodes, buffer(), "Nodes")
    for i = 1, 8, 1 do
        Dissector.get("ldn_mitm.node"):call(buffer(64 * (i - 1), 64):tvb(), pinfo, nodes)
    end
end
