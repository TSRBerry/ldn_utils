if GLOBALS == nil or GLOBALS.modules.mii.hair ~= false then
    return
end
GLOBALS.modules.mii.hair = true

-- Module table
local hair = {}

-- ProtoField definitions
hair.type = ProtoField.uint8("mii.hair.type", "Type", base.DEC)
hair.color = ProtoField.uint8("mii.hair.color", "Color", base.DEC)
hair.wrinkle = ProtoField.uint8("mii.hair.wrinkle", "Wrinkle", base.DEC)
hair.isFlipped = ProtoField.bool("mii.hair.isFlipped", "Is flipped")

-- Return the module
return hair
