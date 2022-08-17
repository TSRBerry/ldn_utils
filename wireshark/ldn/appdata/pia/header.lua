if GLOBALS == nil then
    return
end

GLOBALS.modules.pia = {
    tables = false
}

local tables = require("pia.tables")

-- ProtoField definitions
local sessionId = ProtoField.uint32("ldn.appdata.common.pia.sessionId", "Session ID", base.DEC)
local crc32 = ProtoField.uint32("ldn.appdata.common.pia.crc32", "CRC-32", base.DEC_HEX)
local systemCommunicationVersion =
    ProtoField.uint8("ldn.appdata.common.pia.systemCommsVersion", "System communication version", base.DEC)
local piaVersion = ProtoField.uint8("ldn.appdata.common.pia.version", "PIA version", base.DEC, tables.version_map)
-- Version dependent ProtoField definitions
local headerSize = ProtoField.uint8("ldn.appdata.common.pia.headerSize", "Header size", base.HEX_DEC)
local sessionParam = ProtoField.uint32("ldn.appdata.common.pia.sessionParam", "Session parameter", base.HEX)

-- Proto definition
local p_pia_header = Proto("ldn.appdata.common.pia", "PIA Protocol")
p_pia_header.fields = {sessionId, crc32, systemCommunicationVersion, piaVersion, headerSize, sessionParam}

-- Dissector
function p_pia_header.dissector(buffer, pinfo, tree)
    local length = buffer:len()
    if length == 0 then
        return
    end

    local subtree = tree:add(p_pia_header, buffer(), "PIA Header")
    subtree:add(sessionId, buffer(0, 4))
    subtree:add(crc32, buffer(4, 4))
    subtree:add(systemCommunicationVersion, buffer(8, 1))
    local version = Struct.unpack("I1", buffer(8, 1):raw())
    subtree:add(piaVersion, buffer(8, 1)).generated = true

    -- if piaVersion == 1 then
    --     -- padding 3 + 8
    if version == 2 then
        -- padding 2 + 8
        subtree:add(headerSize, buffer(9, 1))
    elseif version >= 3 and version <= 5 then
        -- padding 8
        subtree:add(headerSize, buffer(9, 1))
        -- padding 2
        subtree:add(sessionParam, buffer(12, 4))
    elseif version == 8 then
        subtree:add(headerSize, buffer(9, 1))
        -- padding 2
        subtree:add(sessionParam, buffer(12, 4))
    else
        return
    end
end

-- Add dissector to common appdata table
GLOBALS.LDN_COMMON_DATA_TABLE:add("pia.header", p_pia_header)
