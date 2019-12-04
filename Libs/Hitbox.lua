local Hitbox = {}
local Hitbox_MT = {__index = Hitbox}
require("Libs.collisions")


local function TopLeft(self, pX, pY, pW, pH)
	self.x = pX
	self.y = pY
	self.w = pW
	self.h = pH
end

local function TopCenter(self, pX, pY, pW, pH)
	print ("BuildTop()",pX, pY, pW, pH)
end

local function TopRight(self, pX, pY, pW, pH)

end

local function LeftCenter(self, pX, pY, pW, pH)

end

local function Center(self, pX, pY, pW, pH)

end

local function RightCenter(self, pX, pY, pW, pH)

end

local function BottomLeft(self, pX, pY, pW, pH)

end

local function BottomCenter(self, pX, pY, pW, pH)
	self.x = pX - pW / 2 * Gscale
	self.y = pY - pH * Gscale
	self.w = pW * Gscale
	self.h = pH * Gscale
	-- print(self.x, self.y, self.w, self.h)
end

local function BottomRight(self, pX, pY, pW, pH)

end

local function BuildHitBox(self,pX, pY, pW, pH)
	local ANCHOR = {
		["TOPLEFT"] = TopLeft,
		["TOPCENTER"] = TopCenter,
		["TOPRIGHT"] = TopRight,
		["LEFTCENTER"] = LeftCenter,
		["CENTER"] = Center,
		["RIGHTCENTER"] = RightCenter,
		["BOTTOMLEFT"] = BottomLeft,
		["BOTTOMCENTER"] = BottomCenter,
		["BOTTOMRIGHT"] = BottomRight
	}
	ANCHOR[self.anchor](self, pX, pY, pW, pH)
	self.HSDistX = math.floor(self.w / self.HSRatio)
	self.HSDistY = math.floor(self.h / self.HSRatio)
end


local function UpdateHotSpots(self)
	local x0, x1, y0, y1 = 0
	-- top hotspots
	x0 = self.x + self.HSDistX
	x1 = self.x + self.w - self.HSDistX
	self.hotSpots.top = {x0, self.y, x1, self.y}
	self.hotSpots.bottom = {x0, self.y + self.h, x1, self.y + self.h}
	-- letf side
	y0 = self.y + self.HSDistY
	y1 = self.y + self.h - self.HSDistY
	self.hotSpots.left = {self.x, y0, self.x, y1}
	self.hotSpots.right = {self.x + self.w, y0, self.x + self.w, y1}
end

function Hitbox.new(pX, pY, pW, pH, pAnchor)
	-- print("HitBox.new - received :", pAnchor, pX, pY, pW, pH)

	local hitbox = {}
	hitbox.anchor = string.upper(pAnchor) or "TOPLEFT"
	hitbox.x = pX
	hitbox.y = pY
	hitbox.w = pW
	hitbox.h = pH
	hitbox.HSRatio = 5
	hitbox.HSDistX = 0
	hitbox.HSDistY = 0
	hitbox.hotSpots = {}
	hitbox.hotSpots.top = {}
	hitbox.hotSpots.right = {}
	hitbox.hotSpots.bottom = {}
	hitbox.hotSpots.left = {}

	hitbox.scale = Gscale
	hitbox.onCollide = false

	BuildHitBox(hitbox, pX, pY, pW, pH)
	UpdateHotSpots(hitbox)
	return setmetatable(hitbox, Hitbox_MT)
end

function Hitbox:RedefineDim(pW, pH)
	self.w = pW
	self.H = pH
end

function Hitbox:Move(pDelta)
	self.x = self.x + pDelta.x
	self.y = self.y + pDelta.y
end

function Hitbox:IsCollide(box)
	local r = AABBbox(self:GetBox(), box:GetBox())
	if r then self.onCollide = true
	else self.onCollide = false end
	return r
end

function Hitbox:GetBox()
	return {self.x, self.y, self.w, self.h}
end

function Hitbox:UpdatePosition(x, y)
	self.x = x
	self.y = y
end

function Hitbox:SetX(x)
	self.x = x - self.w / 2
	UpdateHotSpots(self)
end

function Hitbox:SetY(y)
	self.y = y - self.h
	UpdateHotSpots(self)
end

function Hitbox:GetTopHS()
	return self.hotSpots.top
end

function Hitbox:GetRightHS()
	return self.hotSpots.right
end

function Hitbox:GetBottomHS()
	return self.hotSpots.bottom
end

function Hitbox:GetLeftHS()
	return self.hotSpots.left
end

function Hitbox:Draw()
	if self.onCollide then love.graphics.setColor(1,0,0,0.5)
	else
		love.graphics.setColor(0,1,0,0.5)
	end
	love.graphics.rectangle("fill", self.x, self.y, self.w,self.h)--for test only scale 2
	love.graphics.setColor(1,1,1,1)
end

return Hitbox