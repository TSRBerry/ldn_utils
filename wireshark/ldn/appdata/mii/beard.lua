if GLOBALS == nil or GLOBALS.modules.mii.beard ~= false then
    return
end
GLOBALS.modules.mii.beard = true

-- Module table
local beard = {}

-- ProtoField definitions
beard.type = ProtoField.uint8("mii.beard.type", "Type", base.DEC)
beard.color = ProtoField.uint8("mii.beard.color", "Color", base.DEC)

-- Return the module
return beard
