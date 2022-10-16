-- Proto fields
local f_local_communication_id =
    ProtoField.uint64("ldn_mitm.intent.local_communication_id", "Local communication ID", base.HEX)
local f_scene_id = ProtoField.uint16("ldn_mitm.intent.scene_id", "Scene ID", base.DEC_HEX)

-- Proto
local p_intent_id = Proto("ldn_mitm.intent", "Intent ID")
p_intent_id.fields = {f_local_communication_id, f_scene_id}

-- Dissector
function p_intent_id.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then
        return
    end

    local subtree = tree:add(p_intent_id, buffer(0, 16), "Intent ID")
    subtree:add_le(f_local_communication_id, buffer(0, 8))
    -- padding 2
    subtree:add_le(f_scene_id, buffer(10, 2))
    -- padding 4
end
