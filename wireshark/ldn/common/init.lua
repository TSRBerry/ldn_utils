if GLOBALS ~= nil then
    return
end

GLOBALS = {
    modules = {
        utils = false,
        sessionInfo = false,
        participants = false,
        advertisementData = false,
        advertisementFrame = false,
        tables = false,
        mii = {},
        pia = {}
    },
    dissectors = {
        SessionInfo = nil,
        AdvertisementData = nil,
        Participants = nil
    },
    tables = nil
}

-- >>> DissectorTables <<<

GLOBALS.LDN_APP_DATA_TABLE = DissectorTable.get("ldn.appdata")
if GLOBALS.LDN_APP_DATA_TABLE == nil then
    GLOBALS.LDN_APP_DATA_TABLE = DissectorTable.new("ldn.appdata", "LDN application data", ftypes.STRING, base.HEX)
end

GLOBALS.LDN_PACKETS = DissectorTable.get("ldn.packets")
if GLOBALS.LDN_PACKETS == nil then
    GLOBALS.LDN_PACKETS = DissectorTable.new("ldn.packets", "LDN packets", ftypes.UINT16)
end

-- >>> Constants <<<

GLOBALS.const = {
    NINTENDO_OUI = 0x0022AA
}
