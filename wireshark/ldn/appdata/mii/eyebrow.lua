if GLOBALS == nil or GLOBALS.modules.mii.eyebrow ~= false then
    return
end
GLOBALS.modules.mii.eyebrow = true

-- Module table
local eyebrow = {}

-- ProtoField definitions
eyebrow.type = ProtoField.uint8("mii.eyebrow.type", "Type", base.DEC)
eyebrow.color = ProtoField.uint8("mii.eyebrow.color", "Color", base.DEC)
eyebrow.scale = ProtoField.uint8("mii.eyebrow.scale", "Scale", base.DEC)
eyebrow.aspect = ProtoField.uint8("mii.eyebrow.aspect", "Aspect", base.DEC)
eyebrow.rotate = ProtoField.uint8("mii.eyebrow.rotate", "Rotate", base.DEC)
eyebrow.x = ProtoField.uint8("mii.eyebrow.x", "Pos x", base.DEC)
eyebrow.y = ProtoField.uint8("mii.eyebrow.y", "Pos y", base.DEC)

-- Return the module
return eyebrow
