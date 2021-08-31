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
-- Check flags
function C_BasePlayer:IsOnGround()
    return bit.band(self:GetProp("m_fFlags"), bit.lshift(1,0)) ~= 0
end

function C_BasePlayer:IsInAir()
    return bit.band(self:GetProp("m_fFlags"), bit.lshift(1,0)) == 0
end

function C_BasePlayer:IsDucking()
    return bit.band(self:GetProp("m_fFlags"), bit.lshift(1,1)) ~= 0
end

function C_BasePlayer:IsWaterJump()
    return bit.band(self:GetProp("m_fFlags"), bit.lshift(1,3)) ~= 0
end

function C_BasePlayer:IsOnTrain()
    return bit.band(self:GetProp("m_fFlags"), bit.lshift(1,4)) ~= 0
end

function C_BasePlayer:IsInRain()
    return bit.band(self:GetProp("m_fFlags"), bit.lshift(1,5)) ~= 0
end

function C_BasePlayer:IsFrozen()
    return bit.band(self:GetProp("m_fFlags"), bit.lshift(1,6)) ~= 0
end

function C_BasePlayer:IsAtControls()
    return bit.band(self:GetProp("m_fFlags"), bit.lshift(1,7)) ~= 0
end

function C_BasePlayer:IsClient()
    return bit.band(self:GetProp("m_fFlags"), bit.lshift(1,8)) ~= 0
end

function C_BasePlayer:IsFakeClient()
    return bit.band(self:GetProp("m_fFlags"), bit.lshift(1,9)) ~= 0
end

function C_BasePlayer:IsInWater()
    return bit.band(self:GetProp("m_fFlags"), bit.lshift(1,10)) ~= 0
end
-- getprop
function C_BasePlayer:GetVelocity()
    return self:GetProp("m_vecVelocity")
end

function C_BasePlayer:IsAlive()
    return self:GetProp("m_iHealth") > 0
end

function C_BasePlayer:GetHP()
    return self:GetProp("m_iHealth")
end