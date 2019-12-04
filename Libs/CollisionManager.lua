local CollisionManager = {}
local CollisionManager_MT = {__index = CollisionManager}

local function UpdateCollideLeft(self)
	if self.collideLeft then
		self.collideLeft = false
		self.object.sprite:SetVX(0)
	end
end

local function UpdateCollideRight(self)
	if self.collideRight then
		self.collideRight = false
		self.object.sprite:SetVX(0)
	end
end

local function UpdateCollideTop(self)
	if self.collideTop then
		self.collideTop = false
		self.object.sprite:SetVY(0)
	end
end

local function UpdateCollideBottom(self)
	if self.collideBottom then
		self.collideBottom = false
		self.object.sprite:SetVY(0)
	end
end

function CollisionManager.new(pObject)
	local collManager = {}
	collManager.object = pObject
	collManager.collideTop = false
	collManager.collideRight = false
	collManager.colideBottom = false
	collManager.collideLeft = false

	return setmetatable(collManager, CollisionManager_MT)
end

function CollisionManager:SetCollideLeft(pValue)
	self.collideLeft = pValue
end

function CollisionManager:SetCollideRight(pValue)
	self.collideRight = pValue
end

function CollisionManager:SetCollideTop(pValue)
	self.collideTop = pValue
end

function CollisionManager:SetCollideBottom(pValue)
	self.collideBottom = pValue
end

function CollisionManager:Update()
	UpdateCollideLeft(self)
	UpdateCollideRight(self)
	UpdateCollideTop(self)
	UpdateCollideBottom(self)
end

return CollisionManager