if GLOBALS == nil or GLOBALS.modules.sessionInfo ~= false then
    return
end
GLOBALS.modules.sessionInfo = true

-- Module table
local mod = {
    tid = nil
}

-- ProtoField definitions
local f_local_communication_id =
    ProtoField.uint64("ldn.session.local_communication_id", "Local communication ID", base.HEX)
local f_game_mode = ProtoField.uint16("ldn.session.game_mode", "Game mode", base.DEC)
local f_ssid = ProtoField.bytes("ldn.session.ssid", "SSID", base.NONE)

-- Proto definition
local p_ldn_sessionInfo = Proto("ldn.session_info", "LDN Session Info")
p_ldn_sessionInfo.fields = {f_local_communication_id, f_game_mode, f_ssid}

-- Dissector
function p_ldn_sessionInfo.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then
        return
    end

    local sessionInfo = tree:add(p_ldn_sessionInfo, buffer(), "Session Info")
    mod.tid = buffer(0, 8):uint64():tohex()
    sessionInfo:add(f_local_communication_id, buffer(0, 8))
    -- padding 2
    sessionInfo:add(f_game_mode, buffer(10, 2))
    -- padding 4
    sessionInfo:add(f_ssid, buffer(16, 16))
end

-- Init function
function p_ldn_sessionInfo.init()
    mod.tid = nil
end

-- Add dissector to globals
GLOBALS.dissectors.SessionInfo = Dissector.get("ldn.session_info")

-- Return the module
return mod
