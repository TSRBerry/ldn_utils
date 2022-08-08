-- Source: https://github.com/kinnay/NintendoClients/wiki/LDN-Application-Data-(Pia)
if GLOBALS == nil or GLOBALS.modules.mii == nil then
    return
end
GLOBALS.modules.mii = {}
local tables = require("ldn.appdata.mii.tables")
local faceline = require("ldn.appdata.mii.faceline")
local hair = require("ldn.appdata.mii.hair")
local eye = require("ldn.appdata.mii.eye")
local eyebrow = require("ldn.appdata.mii.eyebrow")
local nose = require("ldn.appdata.mii.nose")
local mouth = require("ldn.appdata.mii.mouth")
local beard = require("ldn.appdata.mii.beard")
local mustache = require("ldn.appdata.mii.mustache")
local glass = require("ldn.appdata.mii.glass")
local mole = require("ldn.appdata.mii.mole")

-- Functions
local function merge_tables(table1, table2)
    for k, v in pairs(table2) do
        table1[k] = v
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
local createId = ProtoField.bytes("ldn.appdata.mii.createId", "Create ID", base.NONE)
-- wide strings are not supported
local name = ProtoField.string("ldn.appdata.mii.name", "Name")
local fontRegion = ProtoField.uint8("ldn.appdata.mii.fontRegion", "Font region", base.DEC, tables.FontRegion)
local favoriteColor =
    ProtoField.uint8("ldn.appdata.mii.favortiteColor", "Favorite color", base.DEC, tables.FavoriteColor)
local gender = ProtoField.uint8("ldn.appdata.mii.gender", "Gender", base.DEC)
local height = ProtoField.uint8("ldn.appdata.mii.height", "Height", base.DEC)
local build = ProtoField.uint8("ldn.appdata.mii.build", "Build", base.DEC)
local isSpecial = ProtoField.bool("ldn.appdata.mii.isSpecial", "Is special")
local regionMove = ProtoField.uint8("ldn.appdata.mii.regionMove", "Region move", base.DEC)

-- Proto definition
local p_mii = Proto("ldn.appdata.mii", "Mii Info")
p_mii.fields = {createId, name, fontRegion, favoriteColor, gender, height, build, isSpecial, regionMove}
p_mii.fields = merge_tables(p_mii.fields, faceline)
p_mii.fields = merge_tables(p_mii.fields, hair)
p_mii.fields = merge_tables(p_mii.fields, eye)
p_mii.fields = merge_tables(p_mii.fields, eyebrow)
p_mii.fields = merge_tables(p_mii.fields, nose)
p_mii.fields = merge_tables(p_mii.fields, mouth)
p_mii.fields = merge_tables(p_mii.fields, beard)
p_mii.fields = merge_tables(p_mii.fields, mustache)
p_mii.fields = merge_tables(p_mii.fields, glass)
p_mii.fields = merge_tables(p_mii.fields, mole)

-- Dissector
function p_mii.dissector(buffer, pinfo, tree)
    local length = buffer:len()
    if length == 0 then
        return
    end

    local offset

    local subtree = tree:add(p_mii, buffer(), "Mii")
    subtree:add(createId, buffer(0, 16))
    -- wide strings are not supported
    subtree:add(name, buffer(16, 11 * 2))
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

-- Add dissector to table
DissectorTable:add("ldn.appdata.mii", p_mii)
