if GLOBALS == nil or GLOBALS.modules.utils ~= false then
    return
end
GLOBALS.modules.utils = true

local Lockbox = require("lockbox")
Lockbox.ALLOW_INSECURE = true
local Array = require("lockbox.util.array")
local Stream = require("lockbox.util.stream")
local ZeroPadding = require("lockbox.padding.zero")
local AES128Cipher = require("lockbox.cipher.aes128")
local ECBMode = require("lockbox.cipher.mode.ecb")
local CTRMode = require("lockbox.cipher.mode.ctr")
local SHA256 = require("lockbox.digest.sha2_256")

-- Keyfile format:
-- MASTER_KEY
-- AES_KEY_GEN_SOURCE1
-- AES_KEY_GEN_SOURCE2
-- ADVERTISEMENT_KEY_SOURCE

-- >>> File helper functions <<<
local function file_exists(path)
    local f = io.open(path, "r")
    if f then
        f:close()
    end
    return f ~= nil
end

local function file_readlines(path)
    if not file_exists(path) then
        return {}
    end
    local lines = {}
    local linenum = 0
    for line in io.lines(path) do
        lines[linenum] = line
        linenum = linenum + 1
    end
    return lines
end

local keys = file_readlines(os.getenv("HOME") .. "/.switch/wireshark-ldn.keys")

-- >>> Decryption helper functions <<<

local function decrypt_key(input, key)
    local cipher
    cipher = ECBMode.Decipher().setKey(key).setBlockCipher(AES128Cipher).setPadding(ZeroPadding)
    return Array.fromHex(cipher.init().update(Stream.fromArray(input)).finish().asHex())
end

local function derive_key(input, source)
    MASTER_KEY = Array.fromHex(keys[0])
    AES_KEY_GEN_SOURCE1 = Array.fromHex(keys[1])
    AES_KEY_GEN_SOURCE2 = Array.fromHex(keys[2])

    local key, hash
    key = decrypt_key(AES_KEY_GEN_SOURCE1, MASTER_KEY)
    -- print("Derive: Key1> " .. Array.toHex(key))
    key = decrypt_key(source, key)
    -- print("Derive: Key2> " .. Array.toHex(key))
    key = decrypt_key(AES_KEY_GEN_SOURCE2, key)
    -- print("Derive: Key3> " .. Array.toHex(key))
    hash = ByteArray.new(SHA256().update(Stream.fromArray(input)).finish().asHex())
    -- print("Derive: Hash> " .. hash:tohex())
    return decrypt_key(Array.fromHex(hash:subset(0, 16):tohex()), key)
end

-- >>> Module functions <<<

function DecryptAdvertisementData(buffer, sessionInfo, nonce)
    KEY_SOURCE = Array.fromHex(keys[3])
    local cipher, key
    -- print("Decrypt: Buffer> " .. buffer:tohex())
    key = derive_key(Array.fromHex(sessionInfo:tohex()), KEY_SOURCE)
    cipher = CTRMode.Decipher().setKey(key).setBlockCipher(AES128Cipher).setPadding(ZeroPadding)
    -- print("Decrypt: Key> " .. Array.toHex(key))
    -- print("Decrypt: Nonce> " .. nonce:tohex())
    nonce:set_size(16)
    return ByteArray.new(
        cipher.init().update(Stream.fromArray(Array.fromHex(nonce:tohex()))).update(
            Stream.fromArray(Array.fromHex(buffer:tohex()))
        ).finish().asHex()
    )
end
