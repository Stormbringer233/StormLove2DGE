local CollideShape = {}
local CollideShape_MT = { __index = CollideShape}
local VectorCls = require("objects.Vector")


local function CheckIntegrity(pPointList)
    -- Chaeck if a shape has a multiple of 2 of points
    -- if not, reject shape
    local list = {}
    for _, shape in ipairs(pPointList) do
        if #shape % 2 == 0 then
            table.insert(list, shape)
        end
    end
    -- return final list of valids shapes
    return list
end

local function BuildShapes(pPointList, pOffsetX, pOffsetY)
    pPointList = CheckIntegrity(pPointList)
    local shapes = {}
    local vectors = {}
    for _, points in ipairs(pPointList) do
        local vStart = {}
        local vEnd = {}
        local vFirst = {}
        local vPolygon = {}
        local shape = {}
        for position, data in ipairs(points) do
            local offset = 0
            if position%2 then
                offset = pOffsetX
            else
                offset = pOffsetY
            end
            table.insert(shape, data + offset)
            if position < 3 then
                table.insert(vFirst, data + offset)
                table.insert(vStart, data + offset)
            else
                table.insert(vEnd, data + offset)
            end
            if #vStart == 2 and #vEnd == 2 then
                local v =  VectorCls.new({vStart, vEnd})
                table.insert(vPolygon,v)
                vStart = vEnd
                vEnd = {}
                if position == #points then
                    local lastV = VectorCls.new({vStart, vFirst})
                    table.insert(vPolygon,lastV)
                    table.insert(vectors, vPolygon)
                end
            end
        end
        table.insert(shapes, shape)
    end
    return shapes, vectors
end

local function PrintPosition(self)
    for i, shape in ipairs(self.shape) do
        print("\tshape "..i.." position")
        for _, point in ipairs(shape) do
            io.write(point..", ")
        end
        print()
    end
    print()
end

local function PrintVectorPosition(self)
    for i, vector in ipairs(self.vectors) do
        print("\tVector "..i.." Position")
        for _, point in ipairs(vector) do
            io.write(point:GetPosition()..", ")
        end
    end
end

function CollideShape.new(pPointList, pOffsetX, pOffsetY)
    -- pPointList must be a table like {{x0, y0, x1, y1, ..., xn, yn}, {other polygon}}
    local collideShape = {}
    collideShape.vectors = {}
    collideShape.collide = false
    collideShape.inside = true
    collideShape.rotatePoint = {}
    collideShape.rotatePoint.x = 0
    collideShape.rotatePoint.y = 0
    collideShape.offset = {}
    collideShape.offset.x = pOffsetX or 0
    collideShape.offset.y = pOffsetY or 0
    collideShape.shape, collideShape.vectors = BuildShapes(pPointList, collideShape.offset.x, collideShape.offset.y)

    return setmetatable(collideShape, CollideShape_MT)
end

function CollideShape:IsCollide(pPointX, pPointY)
    -- Return if the point is inside the shape or not
    self.inside = false
    for _, vectors in ipairs(self.vectors) do
        local inside = true
        for _, vector in ipairs(vectors) do
            if not vector:IsLeft(pPointX, pPointY) then
                inside = false
            end
        end
        if inside then
            self.inside = true
            return inside
        end
    end
    return false
end

function CollideShape:Move(pDX, pDY)
    for _, shape in ipairs(self.shape) do
        for i=1, #shape do
            if i%2 == 0 then
                shape[i] = shape[i] + pDY
            else
                shape[i] = shape[i] + pDX
            end
        end
    end
    for _, vectorShape in ipairs(self.vectors) do
        for i = 1, #vectorShape do
            vectorShape[i]:Move(pDX, pDY)
        end
    end
end

function CollideShape:Draw()
    if self.inside then
        love.graphics.setColor(1,0,0,0.4)
    else
        love.graphics.setColor(0,1,0,0.4)

    end
    for _,shape in ipairs(self.shape) do
        love.graphics.polygon("fill", shape)
    end
    love.graphics.setColor(1,1,1)
    for _,vectors in ipairs(self.vectors) do
        for _, vector in ipairs(vectors) do
            vector:Draw()
        end
    end

end

return CollideShape