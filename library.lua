-- Make pull requests!
function Render.ResizeText(text, maxSize, fontSize, font)
    if (type(text) ~= "string" or type(maxSize) ~= "number" or type(fontSize) ~= "number") then return ""; end
    local textSize = 0;
    
    ::resizeGoto::

    if (font ~= nil) then
        local ran = pcall(function() textSize = Render.CalcTextSize(text, fontSize, font); end);
        if (not ran) then font = nil; goto resizeGoto; end
    else
        textSize = Render.CalcTextSize(text, fontSize)
    end

    if (textSize.x > maxSize) then text = string.sub(text, 0, #text - 1); goto resizeGoto; end

    return text;
end

function Vector2:DistTo(vec2)
    if (vec2 ~= nil and type(vec2.x) == "number" and type(vec2.y) == "number") then
        return (self - vec2):Length();
    end

    return 0;
end

function Rect:PointInside(vec2)
    if (vec2 ~= nil and type(vec2.x) == "number" and type(vec2.y) == "number") then
        local x, y, x2, y2;
        if (self.x >= self.z) then x, x2 = self.z, self.x; else x, x2 = self.x, self.z; end
        if (self.y >= self.w) then y, y2 = self.w, self.y; else y, y2 = self.y, self.w; end
        -- if the second rect point is before the first rect point ^

        if (vec2.x >= x and vec2.x <= x2) then
            if (vec2.y >= y and vec2.y <= y2) then
                return true;
            end
        end
    end

    return false;
end

function C_BasePlayer:GetWeapons()
    local plyWeapons = self:GetProp("m_hMyWeapons");
    local returnTable = {};

    if (type(plyWeapons) == "table" and #plyWeapons > 0) then 
        for i = 1, #plyWeapons do
            local wep = EntityList.GetWeaponFromHandle(plyWeapons[i]);
            if (wep ~= nil) then
                table.insert(returnTable, wep);
            end
        end
    end

    return returnTable;
end

local flags = {
    OnGround = 0, IsDucking = 1,
    WaterJump = 3, OnTrain = 4,
    InRain = 5, IsFrozen = 6,
    AtControls = 7, IsClient = 8,
    IsFakeClient = 9, InWater = 10
};

local flags = {
    OnGround = 0, InAir = {0},
    IsDucking = 1, WaterJump = 3,
    OnTrain = 4, InRain = 5,
    IsFrozen = 6, AtControls = 7,
    IsClient = 8, IsFakeClient = 9,
    InWater = 10
};

function C_BasePlayer:CheckFlag(...)
    local flagList = {...};
    local flagValues = true;

    if (type(flagList) == "table" and #flagList > 0) then
        for i = 1, #flagList do
            if (type(flagList[i]) == "table") then
                if (bit.band(self:GetProp("m_fFlags"), bit.lshift(1, flagList[i][1])) ~= 0) then flagValues = false; end
            else
                if (bit.band(self:GetProp("m_fFlags"), bit.lshift(1, flagList[i])) == 0) then flagValues = false; end
            end
        end
    end

    return flagValues;
end

function C_BasePlayer:GetVelocity()
    return self:GetProp("m_vecVelocity");
end

function C_BasePlayer:GetHealth()
    return self:GetProp("m_iHealth");
end

function C_BasePlayer:IsAlive()
    return self:GetHP() > 0;
end

vmthooks = {}
function CreateVMT(target)
    target = ffi.cast("uintptr_t**", target) -- cast void* to uintptr_t** to get virtual table

    local pOriginalTable = target[0] -- get virtual table base
    local iVMTSize = 0 -- init virtual table size variable

    while(pOriginalTable[iVMTSize] ~= 0x0) do
        iVMTSize = iVMTSize + 1 -- increase until we hit NULL to find virtual table size
    end

    local pNewVTable = ffi.new("uintptr_t[".. iVMTSize .."]") -- allocate memory for the replacement of original virtual table
    ffi.copy(pNewVTable, pOriginalTable, iVMTSize * ffi.sizeof("uintptr_t")) -- copy original virtual table's methods addresses to our virtual table

    target[0] = pNewVTable -- overriding vtable base address

    table.insert(vmthooks, {base = target, original = pOriginalTable, size = iVMTSize, new = pNewVTable}) -- save some variables for further usage

    return vmthooks[#vmthooks] --
end

function DeleteVMT(vmt)
    vmt.base[0] = vmt.original -- restore original vtable base address
end

function GetOriginal(vmt, idx, cast)
    return ffi.cast(cast, vmt.original[idx]) -- get original method address
end

function Hook(vmt, idx, to, cast)
    vmt.new[idx] = ffi.cast("uintptr_t", ffi.cast(cast, to)) -- override method address
end

function UnHook(vmt, idx)
    vmt.new[idx] = vmt.original[idx] -- resotre method address
end

function RemoveHooks()
    for _, vmt in pairs(vmthooks) do
        DeleteVMT(vmt) -- restore all vmt hooks that we have created
    end
end
