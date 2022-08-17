-- Source: https://github.com/kinnay/NintendoClients/wiki/LDN-Application-Data-(Pia)
if GLOBALS == nil then
    return
end

GLOBALS.modules.mii = {
    tables = false,
    faceline = false,
    hair = false,
    eye = false,
    eyebrow = false,
    nose = false,
    mouth = false,
    beard = false,
    mustache = false,
    glass = false,
    mole = false
}

local tables = require("mii.tables")
local faceline = require("mii.faceline")
local hair = require("mii.hair")
local eye = require("mii.eye")
local eyebrow = require("mii.eyebrow")
local nose = require("mii.nose")
local mouth = require("mii.mouth")
local beard = require("mii.beard")
local mustache = require("mii.mustache")
local glass = require("mii.glass")
local mole = require("mii.mole")

-- Functions
local function merge_tables(table1, table2)
    for _, v in pairs(table2) do
        table1[#table1 + 1] = v
    end
    return table1
end

local function count_table(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

-- ProtoField definitions
local createId = ProtoField.bytes("ldn.appdata.common.mii.createId", "Create ID", base.NONE)
-- wide strings are not supported
local name = ProtoField.string("ldn.appdata.common.mii.name", "Name")
local fontRegion = ProtoField.uint8("ldn.appdata.common.mii.fontRegion", "Font region", base.DEC, tables.FontRegion)
local favoriteColor =
    ProtoField.uint8("ldn.appdata.common.mii.favortiteColor", "Favorite color", base.DEC, tables.FavoriteColor)
local gender = ProtoField.uint8("ldn.appdata.common.mii.gender", "Gender", base.DEC)
local height = ProtoField.uint8("ldn.appdata.common.mii.height", "Height", base.DEC)
local build = ProtoField.uint8("ldn.appdata.common.mii.build", "Build", base.DEC)
local isSpecial = ProtoField.bool("ldn.appdata.common.mii.isSpecial", "Is special")
local regionMove = ProtoField.uint8("ldn.appdata.common.mii.regionMove", "Region move", base.DEC)

-- Proto definition
local p_mii = Proto("ldn.appdata.common.mii", "Mii Info")
-- I know this is dumb, but otherwise wireshark will freeze
local mii_fields = {createId, name, fontRegion, favoriteColor, gender, height, build, isSpecial, regionMove}
local faceline_fields = merge_tables(mii_fields, faceline)
local hair_fields = merge_tables(faceline_fields, hair)
local eye_fields = merge_tables(hair_fields, eye)
local eyebrow_fields = merge_tables(eye_fields, eyebrow)
local nose_fields = merge_tables(eyebrow_fields, nose)
local mouth_fields = merge_tables(nose_fields, mouth)
local beard_fields = merge_tables(mouth_fields, beard)
local mustache_fields = merge_tables(beard_fields, mustache)
local glass_fields = merge_tables(mustache_fields, glass)
p_mii.fields = merge_tables(glass_fields, mole)

-- Dissector
function p_mii.dissector(buffer, pinfo, tree)
    local length = buffer:len()
    if length == 0 then
        return
    end

    local offset

    local subtree = tree:add(p_mii, buffer(), "Mii")
    subtree:add(createId, buffer(0, 16))
    subtree:add(name, buffer(16, 11 * 2):le_ustring())
    subtree:add(fontRegion, buffer(38, 1))
    subtree:add(favoriteColor, buffer(39, 1))
    subtree:add(gender, buffer(40, 1))
    subtree:add(height, buffer(41, 1))
    subtree:add(build, buffer(42, 1))
    subtree:add(isSpecial, buffer(43, 1))
    subtree:add(regionMove, buffer(44, 1))
    -- faceline
    offset = 45
    local t_faceline = subtree:add(p_mii, buffer(offset, count_table(faceline)), "Faceline")
    for _, v in pairs(faceline) do
        t_faceline:add(v, buffer(offset, 1))
        offset = offset + 1
    end
    -- hair
    local t_hair = subtree:add(p_mii, buffer(offset, count_table(hair)), "Hair")
    for _, v in pairs(hair) do
        t_hair:add(v, buffer(offset, 1))
        offset = offset + 1
    end
    -- eye
    local t_eye = subtree:add(p_mii, buffer(offset, count_table(eye)), "Eye")
    for _, v in pairs(eye) do
        t_eye:add(v, buffer(offset, 1))
        offset = offset + 1
    end
    -- eyebrow
    local t_eyebrow = subtree:add(p_mii, buffer(offset, count_table(eyebrow)), "Eyebrow")
    for _, v in pairs(eyebrow) do
        subtree:add(v, buffer(offset, 1))
        offset = offset + 1
    end
    -- nose
    local t_nose = subtree:add(p_mii, buffer(offset, count_table(nose)), "Nose")
    for _, v in pairs(nose) do
        t_nose:add(v, buffer(offset, 1))
        offset = offset + 1
    end
    -- mouth
    local t_mouth = subtree:add(p_mii, buffer(offset, count_table(mouth)), "Mouth")
    for _, v in pairs(mouth) do
        t_mouth:add(v, buffer(offset, 1))
        offset = offset + 1
    end
    -- beard
    local t_beard = subtree:add(p_mii, buffer(offset, count_table(beard)), "Beard")
    for _, v in pairs(beard) do
        t_beard:add(v, buffer(offset, 1))
        offset = offset + 1
    end
    -- mustache
    local t_mustache = subtree:add(p_mii, buffer(offset, count_table(mustache)), "Mustache")
    for _, v in pairs(mustache) do
        t_mustache:add(v, buffer(offset, 1))
        offset = offset + 1
    end
    -- glass
    local t_glass = subtree:add(p_mii, buffer(offset, count_table(glass)), "Glass")
    for _, v in pairs(glass) do
        t_glass:add(v, buffer(offset, 1))
        offset = offset + 1
    end
    -- mole
    local t_mole = subtree:add(p_mii, buffer(offset, count_table(mole)), "Mole")
    for _, v in pairs(mole) do
        t_mole:add(v, buffer(offset, 1))
        offset = offset + 1
    end
    -- padding 1
end

-- Add dissector to common appdata table
GLOBALS.LDN_COMMON_DATA_TABLE:add("mii", p_mii)
