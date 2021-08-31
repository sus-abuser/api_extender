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
