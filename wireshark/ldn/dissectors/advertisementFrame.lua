if GLOBALS == nil or GLOBALS.modules.advertisementFrame ~= false then
    return
end
GLOBALS.modules.advertisementFrame = true

require("ldn.dissectors.advertisementData")

-- ProtoField definitions
local f_ldn_version = ProtoField.uint8("ldn.advertisement.version", "LDN version", base.DEC)
local f_encryption_type =
    ProtoField.uint8("ldn.advertisement.encryption", "Encryption type", base.DEC, GLOBALS.tables.encryption_type)
local f_adData_size = ProtoField.uint16("ldn.advertisement.data.size", "Advertisement data size", base.DEC_HEX)
local f_nonce = ProtoField.uint32("ldn.advertisement.nonce", "Nonce", base.HEX)
local f_hash_enc = ProtoField.bytes("ldn.advertisement.hash_enc", "SHA-256 hash (Encrypted)", base.NONE)
local f_hash = ProtoField.bytes("ldn.advertisement.hash", "SHA-256 hash", base.NONE)
local f_adData = ProtoField.bytes("ldn.advertisement.rawdata", "Advertisement data (raw)", base.NONE)

-- Proto definition
local p_ldn_advertisement = Proto("ldn.advertisement", "LDN Advertisement Frame")
p_ldn_advertisement.fields = {f_ldn_version, f_encryption_type, f_adData_size, f_nonce, f_hash_enc, f_adData, f_hash}

-- Dissector
function p_ldn_advertisement.dissector(buffer, pinfo, tree)
    length = buffer:len()
    if length == 0 then
        return
    end

    local adFrame = tree:add(p_ldn_advertisement, buffer(), "Advertisement Frame")
    GLOBALS.dissectors.SessionInfo:call(buffer(0, 32):tvb(), pinfo, adFrame)
    adFrame:add(f_ldn_version, buffer(32, 1))
    adFrame:add(f_encryption_type, buffer(33, 1))
    local adDataSize = buffer(34, 2):uint()
    -- print("AdvertisementDataSize: " .. adDataSize)
    adFrame:add(f_adData_size, buffer(34, 2))
    adFrame:add(f_nonce, buffer(36, 4))

    local decryptedData =
        DecryptAdvertisementData(buffer:bytes(40, 32 + adDataSize), buffer:bytes(0, 32), buffer:bytes(36, 4))

    local decryptedHash = decryptedData:subset(0, 32):tvb("Hash")
    decryptedData = decryptedData:subset(32, decryptedData:len() - 32):tvb("AdvertisementData")

    -- encrypted hash
    adFrame:add(f_hash_enc, buffer(40, 32)).hidden = true
    -- decrypted hash
    adFrame:add(f_hash, decryptedHash()).generated = true
    -- encrypted advertisement data
    adFrame:add(f_adData, buffer(72, adDataSize)).hidden = true
    -- decrypted advertisement data
    GLOBALS.dissectors.AdvertisementData:call(decryptedData, pinfo, adFrame)
end

-- Add packet type to DissectorTable
GLOBALS.LDN_PACKETS:add(257, p_ldn_advertisement)
