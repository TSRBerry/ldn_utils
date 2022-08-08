if GLOBALS == nil or GLOBALS.modules.mii.mole ~= false then
    return
end
GLOBALS.modules.mii.mole = true

-- Module table
local mole = {}

-- ProtoField definitions
mole.hasMole = ProtoField.bool("mii.mole.hasMole", "Has mole")
mole.scale = ProtoField.uint8("mii.mole.scale", "Scale", base.DEC)
mole.x = ProtoField.uint8("mii.mole.x", "Pos x", base.DEC)
mole.y = ProtoField.uint8("mii.mole.y", "Pos y", base.DEC)

-- Return the module
return mole
