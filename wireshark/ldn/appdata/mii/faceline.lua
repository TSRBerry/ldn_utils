if GLOBALS == nil or GLOBALS.modules.mii.facline ~= false then
    return
end
GLOBALS.modules.mii.facline = true

-- Module table
local faceline = {}

-- ProtoField definitions
faceline.type = ProtoField.uint8("mii.faceline.type", "Type", base.DEC)
faceline.color = ProtoField.uint8("mii.faceline.color", "Color", base.DEC)
faceline.wrinkle = ProtoField.uint8("mii.faceline.wrinkle", "Wrinkle", base.DEC)
faceline.make = ProtoField.uint8("mii.faceline.make", "Make", base.DEC)

-- Return the module
return faceline
