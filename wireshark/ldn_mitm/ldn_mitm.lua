require("ldn_mitm.decompress")

-- >>> Tables <<<
local tables = {
    Port = 11452,
    LanMagic = 0x11451400,
    LanPacketType = {
        [0] = "Scan",
        [1] = "ScanResponse",
        [2] = "Connect",
        [3] = "SyncNetwork"
    }
}

-- >>> ProtoFields <<<
local f_magic = ProtoField.uint32("ldn_mitm.magic", "Magic", base.HEX)
local f_packet_type = ProtoField.uint8("ldn_mitm.packet_type", "Packet type", base.DEC, tables.LanPacketType)
local f_compressed = ProtoField.bool("ldn_mitm.compressed", "Is compressed")
local f_length = ProtoField.uint16("ldn_mitm.length", "Length", base.HEX_DEC)
local f_decompressed_length = ProtoField.uint16("ldn_mitm.decompressed_length", "Decompressed length", base.HEX_DEC)

-- >>> Protocol <<<
local p_ldn_mitm = Proto("ldn_mitm", "Spacemeowx2's ldn_mitm Protocol")
p_ldn_mitm.fields = {f_magic, f_packet_type, f_compressed, f_length, f_decompressed_length}

-- >>> Dissector <<<
function p_ldn_mitm.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 or Struct.unpack("I4", buffer(0, 4):raw()) ~= tables.LanMagic then
        return
    end

    pinfo.cols.protocol = p_ldn_mitm.name

    local subtree = tree:add(p_ldn_mitm, buffer())

    local header = subtree:add(p_ldn_mitm, buffer(0, 12), "Header")
    -- header
    header:add_le(f_magic, buffer(0, 4))
    header:add_le(f_packet_type, buffer(4, 1))
    header:add_le(f_compressed, buffer(5, 1))
    header:add_le(f_length, buffer(6, 2))
    header:add_le(f_decompressed_length, buffer(8, 2))
    -- padding 2
    -- header end

    local data = nil
    if Struct.unpack("I1", buffer(5, 1):raw()) ~= 0 then
        data = DecompressData(buffer:bytes(12), buffer(8, 2):le_int()):tvb("ldn_mitm: Decompressed data")
    else
        data = buffer(12):tvb()
    end

    local packet_type = Struct.unpack("I1", buffer(4, 1):raw())
    -- ScanResponse or SyncNetwork
    if packet_type == 1 or packet_type == 3 then
        Dissector.get("ldn_mitm.network_info"):call(data, pinfo, subtree)
    elseif packet_type == 2 then
        -- Connect
        Dissector.get("ldn_mitm.node"):call(data, pinfo, subtree)
    end
end

-- >>> Add protocol to DissectorTable <<<
local tcp_port_table = DissectorTable.get("tcp.port")
local udp_port_table = DissectorTable.get("udp.port")
tcp_port_table:add(tables.Port, p_ldn_mitm)
udp_port_table:add(tables.Port, p_ldn_mitm)
