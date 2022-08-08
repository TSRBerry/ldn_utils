if GLOBALS == nil or GLOBALS.modules.mii.eye ~= false then
    return
end
GLOBALS.modules.mii.eye = true

-- Module table
local eye = {}

-- ProtoField definitions
eye.type = ProtoField.uint8("mii.eye.type", "Type", base.DEC)
eye.color = ProtoField.uint8("mii.eye.color", "Color", base.DEC)
eye.scale = ProtoField.uint8("mii.eye.scale", "Scale", base.DEC)
eye.aspect = ProtoField.uint8("mii.eye.aspect", "Aspect", base.DEC)
eye.rotate = ProtoField.uint8("mii.eye.rotate", "Rotate", base.DEC)
eye.x = ProtoField.uint8("mii.eye.x", "Pos x", base.DEC)
eye.y = ProtoField.uint8("mii.eye.y", "Pos y", base.DEC)

-- Return the module
return eye
