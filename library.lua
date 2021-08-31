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
