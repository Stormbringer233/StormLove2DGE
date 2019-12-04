local Vector = {}
local Vector_MT = { __index = Vector}

function Vector.new(points)
    -- points must be {{x0,y0}, {x1, y1}}
    local vector = {}
    vector.startPoint = {}
    vector.startPoint.x = points[1][1]
    vector.startPoint.y = points[1][2]
    vector.endPoint = {}
    vector.endPoint.x = points[2][1]
    vector.endPoint.y = points[2][2]
    vector.Xcomposite = vector.endPoint.x  - vector.startPoint.x
    vector.Ycomposite = vector.endPoint.y  - vector.startPoint.y
    vector.length = math.sqrt( math.pow(vector.Xcomposite, 2) + math.pow(vector.Ycomposite, 2))
    vector.angle = math.atan2(vector.Ycomposite, vector.Xcomposite)
    return setmetatable(vector, Vector_MT)
end

function Vector:Move(pDX, pDY)
    self.startPoint.x = self.startPoint.x + pDX
    self.endPoint.x = self.endPoint.x + pDX
    self.startPoint.y = self.startPoint.y + pDY
    self.endPoint.y = self.endPoint.y + pDY
end

function Vector:Rotate(pAngle)

end

function Vector:IsLeft(pMousePositionX, pMousePositionY)
    local vectorPoint = {}
    vectorPoint.x = pMousePositionX - self.startPoint.x 
    vectorPoint.y = pMousePositionY - self.startPoint.y
    local crossProduct = self.Xcomposite * vectorPoint.y - self.Ycomposite * vectorPoint.x
    return crossProduct <= 0
end

function Vector:GetPosition()
    return self.startPoint.x, self.startPoint.y, self.endPoint.x, self.endPoint.y
end

function Vector:PrintPosition(index)
    io.write("Vecteur "..index.." -> ",self.startPoint.x, self.startPoint.y, self.endPoint.x, self.endPoint.y)
end

function Vector:Update(dt)
end

function Vector:Draw()
    love.graphics.setColor(0,0.8,0)
    love.graphics.line(self.startPoint.x, self.startPoint.y, self.endPoint.x, self.endPoint.y)
    love.graphics.setColor(1,1,1)
end

return Vector