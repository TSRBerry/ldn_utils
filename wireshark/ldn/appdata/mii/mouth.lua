if GLOBALS == nil or GLOBALS.modules.mii.mouth ~= false then
    return
end
GLOBALS.modules.mii.mouth = true

-- Module table
local mouth = {}

-- ProtoField definitions
mouth.type = ProtoField.uint8("mii.mouth.type", "Type", base.DEC)
mouth.color = ProtoField.uint8("mii.mouth.color", "Color", base.DEC)
mouth.scale = ProtoField.uint8("mii.mouth.scale", "Scale", base.DEC)
mouth.aspect = ProtoField.uint8("mii.mouth.aspect", "Aspect", base.DEC)
mouth.y = ProtoField.uint8("mii.mouth.y", "Pos y", base.DEC)

-- Return the module
return mouth
