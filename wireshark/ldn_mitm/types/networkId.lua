-- Proto fields
local f_session_id = ProtoField.bytes("ldn_mitm.network.session_id", "Session ID", base.NONE)

-- Proto
local p_network_id = Proto("ldn_mitm.network", "Network ID")
p_network_id.fields = {f_session_id}

-- Dissector
function p_network_id.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then
        return
    end

    local subtree = tree:add(p_network_id, buffer(0, 32), "Network ID")
    Dissector.get("ldn_mitm.intent"):call(buffer, pinfo, subtree)
    subtree:add_le(f_session_id, buffer(16, 16))
end
