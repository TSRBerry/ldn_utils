require("ldn.common.init")
require("ldn.common.utils")
require("ldn.common.tables")
require("ldn.dissectors.advertisementFrame")

-- >>> ProtoFields <<<
local f_packet_type = ProtoField.uint16("ldn.packet_type", "Packet type", base.DEC, GLOBALS.tables.packet_type)
local f_protocol_id = ProtoField.uint8("ldn.protocol_id", "Protocol ID", base.DEC, GLOBALS.tables.protocol_id)

-- >>> Protocol <<<
local p_ldn = Proto("LDN", "Nintendo Switch LDN Protocol")
p_ldn.fields = {f_protocol_id, f_packet_type}

-- >>> Dissector <<<
function p_ldn.dissector(buffer, pinfo, tree)
    if Struct.unpack("I1", buffer(0, 1):raw()) ~= 4 and GLOBALS.tables.packet_type[Struct.unpack("I2", buffer(0, 2):raw())] == nil then
        return
    end

    pinfo.cols.protocol = p_ldn.name
    local subtree = tree:add(p_ldn, buffer(), "LDN Protocol")
    local packet_type = nil
    local packet = nil

    if Struct.unpack("I1", buffer(0, 1):raw()) == 4 then
        subtree:add(f_protocol_id, buffer(0, 1))
        -- padding 1
        packet_type = Struct.unpack("I2", buffer(2, 2):raw())
        subtree:add(f_packet_type, buffer(2, 2))
        -- zero 2 and padding 2
        packet = buffer(8):tvb()
    end

    GLOBALS.LDN_PACKETS:get_dissector(packet_type):call(packet, pinfo, subtree)
end

-- >>> Add protocol to DissectorTable <<<
local wlan_vendor_action = DissectorTable.get("wlan.action.vendor_specific")
wlan_vendor_action:add(GLOBALS.const.NINTENDO_OUI, p_ldn)
