if GLOBALS == nil or GLOBALS.modules.advertisementData ~= false then
    return
end
GLOBALS.modules.advertisementData = true

local sessionInfo = require("ldn.dissectors.sessionInfo")
require("ldn.dissectors.participants")

-- ProtoField definitions
local f_adData_netkey = ProtoField.bytes("ldn.advertisement.data.netkey", "Network key", base.NONE)
local f_adData_security =
    ProtoField.uint16("ldn.advertisement.data.security", "Security level", base.DEC, GLOBALS.tables.security_level)
local f_adData_policy =
    ProtoField.uint8(
    "ldn.advertisement.data.policy",
    "Station accept policy",
    base.DEC,
    GLOBALS.tables.station_accept_policy
)
local f_adData_max_participants =
    ProtoField.uint8("ldn.advertisement.data.participants.max", "Maximum number of participants")
local f_adData_current_participants =
    ProtoField.uint8("ldn.advertisement.data.participants.current", "Current number of participants")
local f_adData_appData_size = ProtoField.uint16("ldn.advertisement.data.appdata.size", "Application data size")
local f_adData_authtoken = ProtoField.uint64("ldn.advertisement.data.auth", "Authentication token")

-- Proto definition
local p_ldn_advertisement_data = Proto("ldn.advertisement.data", "LDN Advertisement Data")
p_ldn_advertisement_data.fields = {
    f_adData_netkey,
    f_adData_security,
    f_adData_policy,
    f_adData_max_participants,
    f_adData_current_participants,
    f_adData_appData_size,
    f_adData_authtoken
}

-- Dissector
function p_ldn_advertisement_data.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then
        return
    end

    buffer = buffer(32)

    local appData_dissector = GLOBALS.LDN_APP_DATA_TABLE:get_dissector(sessionInfo.tid)
    if appData_dissector == nil then
        appData_dissector = Dissector.get("data")
    end

    local adData = tree:add(p_ldn_advertisement_data, buffer(), "Decrypted Advertisement Data")
    adData.generated = true
    adData:add(f_adData_netkey, buffer(0, 16))
    adData:add(f_adData_security, buffer(16, 2))
    adData:add(f_adData_policy, buffer(18, 1))
    -- padding 3
    adData:add(f_adData_max_participants, buffer(22, 1))
    adData:add(f_adData_current_participants, buffer(23, 1))
    -- start: 24 -> length: 448
    -- 472
    GLOBALS.dissectors.Participants:call(buffer(24, 56 * 8):tvb(), pinfo, adData)
    -- padding 2
    local appDataSize = Struct.unpack(">I2", buffer(474, 2):raw())
    -- print("AppDataSize: " .. appDataSize)
    adData:add(f_adData_appData_size, buffer(474, 2))
    appData_dissector:call(buffer(476, 384):tvb(), pinfo, adData)
    -- padding 412
    adData:add(f_adData_authtoken, buffer(476 + 384 + 412, 8))
end

-- Add dissector to globals
GLOBALS.dissectors.AdvertisementData = Dissector.get("ldn.advertisement.data")
