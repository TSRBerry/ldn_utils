if GLOBALS == nil or GLOBALS.modules.mii.tables ~= false then
    return
end
GLOBALS.modules.mii.tables = true

-- Module table
mii_table = {}

mii_table.FontRegion = {
    [0] = "Standard",
    [1] = "China",
    [2] = "Korea",
    [3] = "Taiwan"
}

mii_table.FavoriteColor = {
    [0] = "Red",
    [1] = "Orange",
    [2] = "Yellow",
    [3] = "LightGreen",
    [4] = "DarkGreen",
    [5] = "DarkBlue",
    [6] = "LightBlue",
    [7] = "Pink",
    [8] = "Purple",
    [9] = "Brown",
    [10] = "White",
    [11] = "Black"
}

-- Return the module
return mii_table
