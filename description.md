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
