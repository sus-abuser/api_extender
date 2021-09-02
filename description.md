#

# Render.ResizeText
### Render.ResizeText(string (Required), number (Required), number (Required), font (Not Required))
### Since there is no render clipping, you can use this to resize a string dynamically to fit an area.
```lua
-- Example
Render.ResizeText(text, maxSize, fontSize, font);
```

#

# Vector2:DistTo
### Render.ResizeText(Vector2 (Required))
### Get the distance between two 2D points.
```lua
-- Example
Vector2.new(10, 10):DistTo(Vector2.new(20, 20))
```

#

# Rect:PointInside
### Rect:PointInside(Vector2 (Required))
### Check if a 2D point is inside of a Rectangle.
```lua
-- Example
Rect.new(30, 30, 10, 10):PointInside(Vector2.new(30, 20));
```

#

# C_BasePlayer:GetWeapons
### C_BasePlayer:GetWeapons()
### Get a table of C_BaseCombatWeapon objects from the current entity.
```lua
-- Example
local localPlayer = EntityList.GetLocalPlayer();

if (localPlayer ~= nil) then
    local wepTable = localPlayer:GetWeapons();

    for i = 1, #wepTable do
        print(wepTable[i]:GetClassName());
    end
end
```

# C_BasePlayer flag check
### C_BasePlayer:function
### Functions: IsOnGround(), IsInAir(), IsDucking(), IsWaterJump(), IsOnTrain(), IsInRain(), IsFrozen(), IsAtControls(), IsClient(), IsFakeClient(), IsInWater()
```lua
-- Example
local localPlayer = EntityList.GetLocalPlayer();

if (localPlayer) then
    if (localPlayer:IsInAir()) then
        --todo
    end
end
```

# C_BasePlayer:GetVelocity
### C_BasePlayer:GetVelocity()
### Get player's velocity
```lua
local localPlayer = EntityList.GetLocalPlayer();

if (localPlayer) then
    print(localPlayer:GetVelocity():Length())
    -- local velocity length
end
```

# C_BasePlayer:IsAlive
### C_BasePlayer:IsAlive()
### Get if player is alive
```lua
local localPlayer = EntityList.GetLocalPlayer();

if (localPlayer) then
    if (localPlayer:IsAlive()) then
        -- todo
    end
end
```

# C_BasePlayer:GetHP
### C_BasePlayer:GetHP()
### Get player's health

```lua
local localPlayer = EntityList.GetLocalPlayer();

if (localPlayer) then
    if (localPlayer:GetHP() < 50) then
        -- todo
    end
end
```

#

# VMT Hooking
### PaintTraverse Example
### Reading current panel's name

```lua
ffi.cdef[[
    typedef void(__fastcall* hkPaintTraverse)(void*, void*, uint32_t, bool, bool);
    typedef void(__thiscall* oPaintTraverse)(void*, uint32_t, bool, bool);
    typedef const char*(__thiscall* oGetPanelName)(void*, uint32_t);
]]

-- ^^^ function prototypes

local g_pPanel = Utils.CreateInterface("vgui2.dll", "VGUI_Panel009") -- get interface
local g_pPanelVMT = CreateVMT(g_pPanel) -- 

local oPaintTraverse = GetOriginal(g_pPanelVMT, 41, "oPaintTraverse") -- get original address of painttraverse(actually it is neverlose's)
local oGetPanelName = GetOriginal(g_pPanelVMT, 36, "oGetPanelName") -- same ^^^

function hkPaintTraverse(ecx, edx, vguipanel, b1, b2)
    print(ffi.string(oGetPanelName(ecx, vguipanel))) -- current panel's name

    oPaintTraverse(ecx, vguipanel, b1, b2) -- call original to prevent issues
end
Hook(g_pPanelVMT, 41, hkPaintTraverse, "hkPaintTraverse") -- magic

Cheat.RegisterCallback("destroy", RemoveHooks) -- NOTICE: this line is "must have" to prevent crashes/undefined behavior
```

#
