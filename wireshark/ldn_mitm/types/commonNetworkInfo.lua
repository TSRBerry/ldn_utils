-- Proto fields
local f_bssid = ProtoField.ether("ldn_mitm.common.bssid", "BSSID")
local f_ssid = ProtoField.bytes("ldn_mitm.common.ssid", "SSID", base.NONE)
local f_channel = ProtoField.int16("ldn_mitm.common.channel", "Channel", base.DEC)
local f_link_level = ProtoField.int8("ldn_mitm.common.link_level", "Link level", base.DEC)
local f_network_type = ProtoField.uint8("ldn_mitm.common.network_type", "Network type", base.DEC)

-- Proto
local p_common_netinfo = Proto("ldn_mitm.common", "Common network info")
p_common_netinfo.fields = {f_bssid, f_ssid, f_channel, f_link_level, f_network_type}

-- Dissector
function p_common_netinfo.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then
        return
    end

    local subtree = tree:add(p_common_netinfo, buffer(0, 48), "Common network info")
    subtree:add_le(f_bssid, buffer(0, 6))
    -- SSID: length(1) + name(32 + 1)
    subtree:add_le(f_ssid, buffer(6, 34))
    subtree:add_le(f_channel, buffer(40, 2))
    subtree:add_le(f_link_level, buffer(42, 1))
    subtree:add_le(f_network_type, buffer(43, 1))
    -- padding 4
end
