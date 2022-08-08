if GLOBALS == nil or GLOBALS.modules.mii.glass ~= false then
    return
end
GLOBALS.modules.mii.glass = true

-- Module table
local glass = {}

-- ProtoField definitions
glass.type = ProtoField.uint8("mii.glass.type", "Type", base.DEC)
glass.color = ProtoField.uint8("mii.glass.color", "Color", base.DEC)
glass.scale = ProtoField.uint8("mii.glass.scale", "Scale", base.DEC)
glass.y = ProtoField.uint8("mii.glass.y", "Pos y", base.DEC)

-- Return the module
return glass
