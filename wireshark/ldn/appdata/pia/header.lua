if GLOBALS == nil or GLOBALS.modules.pia.header ~= false then
    return
end
GLOBALS.modules.pia.header = true

local tables = require("ldn.appdata.pia.tables")

-- ProtoField definitions
local sessionId = ProtoField.uint32("ldn.appdata.pia.sessionId", "Session ID", base.DEC)
local crc32 = ProtoField.uint32("ldn.appdata.pia.crc32", "CRC-32", base.DEC_HEX)
local systemCommunicationVersion =
    ProtoField.uint8("ldn.appdata.pia.systemCommsVersion", "System communication version", base.DEC)
local piaVersion = ProtoField.uint8("ldn.appdata.pia.version", "PIA version", base.DEC, tables.version_map)
-- Version dependent ProtoField definitions
local headerSize = ProtoField.uint8("ldn.appdata.pia.headerSize", "Header size", base.HEX_DEC)
local sessionParam = ProtoField.uint32("ldn.appdata.pia.sessionParam", "Session parameter", base.HEX)

-- Proto definition
local p_pia_header = Proto("ldn.appdata.pia", "PIA Protocol")
p_pia_header.fields = {sessionId, crc32, systemCommunicationVersion, piaVersion, headerSize, sessionParam}

-- Dissector
function p_pia_header.dissector(buffer, pinfo, tree)
    local length = buffer:len()
    if length == 0 then
        return
    end

    local subtree = tree:add(p_pia_header, buffer(), "PIA Header")
    subtree:add(sessionId, buffer(0, 4))
    subtree:add(crc32, buffer(4, 8))
    subtree:add(systemCommunicationVersion, buffer(12, 1))
    local piaVersion = tables.version_map
    subtree:add(piaVersion, buffer(12, 1)).generated = true

    -- if piaVersion == 1 then
    --     -- padding 3 + 8
    if piaVersion == 2 then
        subtree:add(headerSize, buffer(13, 1))
        -- padding 2 + 8
    elseif piaVersion >= 3 and piaVersion <= 5 then
        subtree:add(headerSize, buffer(13, 1))
        -- padding 2
        subtree:add(sessionParam, buffer(16, 4))
        -- padding 8
    elseif piaVersion == 8 then
        subtree:add(headerSize, buffer(13, 1))
        -- padding 2
        subtree:add(sessionParam, buffer(16, 4))
    else
        return
    end
end

-- Add dissector to table
DissectorTable:add("ldn.appdata.pia", p_pia_header)
