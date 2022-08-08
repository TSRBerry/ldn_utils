if GLOBALS == nil or GLOBALS.modules.mii.mustache ~= false then
    return
end
GLOBALS.modules.mii.mustache = true

-- Module table
local mustache = {}

-- ProtoField definitions
mustache.type = ProtoField.uint8("mii.mustache.type", "Type", base.DEC)
mustache.scale = ProtoField.uint8("mii.mustache.scale", "Scale", base.DEC)
mustache.y = ProtoField.uint8("mii.mustache.y", "Pos y", base.DEC)

-- Return the module
return mustache
