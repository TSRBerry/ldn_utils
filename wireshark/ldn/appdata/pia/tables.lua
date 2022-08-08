if GLOBALS == nil or GLOBALS.modules.pia.tables ~= false then
    return
end
GLOBALS.modules.pia.tables = true

-- Module table
local pia_tables = {}

-- Source: https://github.com/kinnay/NintendoClients/wiki/LDN-Application-Data-(Pia)

-- mapping table: systemCommunicationVersion to PIA version
pia_tables.version_map = {
    [1] = "5.2-5.7",
    [2] = "5.9",
    [3] = "5.10",
    [4] = "5.11-5.17",
    [5] = "5.18",
    [8] = "5.39"
}

-- Return the module
return pia_tables
