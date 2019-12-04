-- gestionnaire de souris pour le pilotage des application
-- Gère : les clicks (pressed et released), la roulette
-- mémorise les état antérieurs


local Mouse = {}
local Mouse_mt = { __index = Mouse }

local wheelY = 0
local wheelX = 0
local wheelMaxSpeed = 0

function math.clamp(low, n, high) return math.min(math.max(low, n), high) end

local function UpdateOldClicks(self)
	-- met à jour les infos des clicks de l'update précédent
	self.oldLeftClick = self.leftClick
	self.oldMiddleClick = self.middleClick
	self.oldRightClick = self.rightClick
end

function Mouse.new()
	mouse = {}
	mouse.leftClick = "released"
	mouse.rightClick = "released"
	mouse.middleClick = "released"
	mouse.wheel = 0
	wheelMaxSpeed = 2
	mouse.x = nil
	mouse.y = nil
	mouse.dx = 0
	mouse.dy = 0
	mouse.oldX = 0
	mouse.oldY = 0
	mouse.oldLeftClick = "released"
	mouse.oldRightClik = "released"
	mouse.oldMiddleClick = "released"
	mouse.camera = nil

	return setmetatable (mouse, Mouse_mt)
end


function Mouse:setWheelSpeed(pNewSpeed)
	wheelMaxSpeed = math.abs(pNewSpeed)
end

function Mouse:Pressed()
	if love.mouse.isDown(1) then 
		self.leftClick = "pressed"
	end
	if love.mouse.isDown(2) then
		self.rightClick = "pressed"
	end
	if love.mouse.isDown(3) then
		self.middleClick = "pressed"
	end
end

function Mouse:Released()
	if not love.mouse.isDown(1) then 
		self.leftClick = "released"
	end
	if not love.mouse.isDown(2) then
		self.rightClick = "released"
	end
	if not love.mouse.isDown(3) then
		self.middleClick = "released"
	end
end

function Mouse:AttachCamera(pCamera)
	self.camera = pCamera
end

function Mouse:GetWorldPosition()
	-- retourne la position du surseur dans l'espace monde sous la forme x, y
	if self.camera then
		return self.camera:MouseWorldPosition(self:GetPosition())
	end
	return nil
end

function Mouse:GetTileWorldPosition()
	if self.camera then
		return self.camera:GetWorldTilePosition(self:GetPosition())
	end
	return nil
end

function Mouse:GetRelativePosition()
	if self.camera then
		return self.camera:MouseRelativePosition(self:GetPosition())
	end
	return nil
end

function Mouse:GetOldsClicks()
	return self.oldLeftClick, self.oldMiddleClick ,self.oldRightClick
end

function love.wheelmoved(x, y)
	if y then
		wheelY = math.clamp(-wheelMaxSpeed, y, wheelMaxSpeed)
	else
		wheelY = 0
	end
end

function Mouse:WheelMoved(dt)
	wheelY = wheelY - wheelY * math.min(dt * 10, 1)
	self.wheel = wheelY
end

function Mouse:UpdateDelta()
	-- retourne la valeur delta entre 2 mouvements de souris
	self.dx = self.x - self.oldX
	self.dy = self.y - self.oldY
	self.oldX = self.x
	self.oldY = self.y
end

function Mouse:GetDelta()
	return self.dx, self.dy
end

function Mouse:GetX()
	return self.x
end

function Mouse:GetY()
	return self.y
end

function Mouse:GetPosition()
	return love.mouse.getPosition()
end

function Mouse:Update(dt)
	UpdateOldClicks(self)
	self.wheel = 0
	self.x = love.mouse.getX()
	self.y = love.mouse.getY()
	self:UpdateDelta()
	self:Pressed()
	self:Released()
	self:WheelMoved(dt)
end

return Mouse