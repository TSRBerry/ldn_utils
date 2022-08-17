if GLOBALS == nil or GLOBALS.LDN_APP_DATA_TABLE == nil then
    return
end

-- ProtoField definitions
local unk1 = ProtoField.uint8("ldn.appdata.mk8.unk1", "Unknown value 1", base.DEC_HEX)
local playerName = ProtoField.string("ldn.appdata.mk8.playerName", "Player name")
local unk2 = ProtoField.uint32("ldn.appdata.mk8.unk2", "Unknown value 2", base.DEC_HEX)

-- Proto definition
local p_mk8 = Proto("ldn.appdata.mk8", "Mario Kart 8: Deluxe")
p_mk8.fields = {unk1, playerName, unk2}

-- Get required dissectors
local pia_header = GLOBALS.LDN_COMMON_DATA_TABLE:get_dissector("pia.header")
local mii = GLOBALS.LDN_COMMON_DATA_TABLE:get_dissector("mii")

-- Dissector
function p_mk8.dissector(buffer, pinfo, tree)
    local length = buffer:len()
    if length == 0 then
        return
    end

    local subtree = tree:add(p_mk8, buffer(), "Mario Kart 8: Deluxe")
    pia_header:call(buffer(0, 20):tvb(), pinfo, subtree)
    subtree:add(unk1, buffer(20, 1))
    subtree:add(playerName, buffer(21, 33))
    -- padding 2
    mii:call(buffer(56, 88):tvb(), pinfo, subtree)
    subtree:add(unk2, buffer(144, 4))
end

-- Add dissector to appdata table
GLOBALS.LDN_APP_DATA_TABLE:add("0100152000022000", p_mk8)
