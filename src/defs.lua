-- Uno Card Game for LOVE2D
--
-- Lua port of "UnoCard" by Hikari Toyama (Apache License 2.0).
-- Original: https://github.com/shiawasenahikari/UnoCard
--
-- Shared enumerations. Numeric values are identical to the original C++
-- enums, because card ids, the legality table and replay files depend on them.

local D = {}

-- Uno color enumeration
D.NONE, D.RED, D.BLUE, D.GREEN, D.YELLOW = 0, 1, 2, 3, 4

-- Uno content enumeration
D.NUM0, D.NUM1, D.NUM2, D.NUM3, D.NUM4 = 0, 1, 2, 3, 4
D.NUM5, D.NUM6, D.NUM7, D.NUM8, D.NUM9 = 5, 6, 7, 8, 9
D.DRAW2, D.REV, D.SKIP, D.WILD, D.WILD_DRAW4 = 10, 11, 12, 13, 14

-- Player ids
D.YOU, D.COM1, D.COM2, D.COM3 = 0, 1, 2, 3

return D
