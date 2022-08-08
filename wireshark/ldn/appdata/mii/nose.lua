if GLOBALS == nil or GLOBALS.modules.mii.nose ~= false then
    return
end
GLOBALS.modules.mii.nose = true

-- Module table
local nose = {}

-- ProtoField definitions
nose.type = ProtoField.uint8("mii.nose.type", "Type", base.DEC)
nose.scale = ProtoField.uint8("mii.nose.scale", "Scale", base.DEC)
nose.y = ProtoField.uint8("mii.nose.y", "Pos y", base.DEC)

-- Return the module
return nose
