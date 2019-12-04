local Player = {}
local Player_MT = {__index = Player}
local SpriteCls = require("Libs.Sprite")
local HBCls = require("Libs.Hitbox")
local CollisionManagerCls = require "Libs.CollisionManager"

local DIRECTION = {}
DIRECTION.NONE = "none"
DIRECTION.UP = "up"
DIRECTION.RIGHT = "right"
DIRECTION.DOWN = "down"
DIRECTION.LEFT = "left"


local function InitializeAnimation(self, pName, pFrameOrder, pFrameRate, pLoop, pFlipV, pFlipH )
	self.sprite:AddAnimation(pName, pFrameOrder, pFrameRate, pLoop,
							pFlipV or false, pFlipH or false)
end

function Player.new(pName, pX, pY)
	local player = {}
	player.sprite = SpriteCls.new(pName, pX, pY, 0.5, 3, 0.2, true, 32, 32)
	player.direction = DIRECTION.NONE
	player.collManager = CollisionManagerCls.new(player)
	player.sprite:SetOrigin(16, 26)
	player.sprite:SetHitbox("bottomcenter", 8,13)
  

  	local bbox = player.sprite:GetHitbox()
  	print("boundingbox = ",unpack(bbox))
  	local x0, y0, x1, y1 = unpack(player.sprite:GetRightHS())
  	print("topHotSpots : ", x0, y0, x1, y1)

  	InitializeAnimation(player, "IDLE", {1}, 0.1, false)
 	InitializeAnimation(player,"RUN_UP", {4,5,6,5}, 0.1, true)
  	InitializeAnimation(player,"RUN_DOWN", {1,2,3, 2}, 0.1, true)
  	InitializeAnimation(player,"RUN_RIGHT", {7,8,9,8}, 0.1, true)
  	InitializeAnimation(player,"RUN_LEFT", {7,8,9,8}, 0.1, true, true, false)
	return setmetatable(player, Player_MT)
end

function Player:AddAnimation(pName, pFrameOrder, pFrameRate, pLoop, pFlipV, pFlipH )
	-- Only for external animation initialization
	self.sprite:AddAnimation(pName, pFrameOrder, pFrameRate, pLoop,
							pFlipV or false, pFlipH or false)
end

function Player:GetPosition()
	return self.sprite:GetX(), self.sprite:GetY()
end

function Player:Play(pAnimationName)
	self.sprite:Play(pAnimationName)
end

function Player:MoveAt(x, y)
	self.sprite:SetX(x)
	self.sprite:SetY(y)
end

function Player:StopTop()
	self.collManager:SetCollideTop(true)
end

function Player:StopRight()
	self.collManager:SetCollideRight(true)
end

function Player:StopBottom()
	self.collManager:SetCollideBottom(true)
end

function Player:StopLeft()
	self.collManager:SetCollideLeft(true)
end

function Player:Move(pDir)
	pDir = string.upper(pDir)
	if pDir == "UP" then
		self.direction = DIRECTION.UP
		self.collManager:SetCollideBottom(false)
		self.sprite:IncreaseVY(-1)
	elseif pDir == "RIGHT" then
		self.direction = DIRECTION.RIGHT
		self.collManager:SetCollideLeft(false)
		self.sprite:IncreaseVX(1)
	elseif pDir == "DOWN" then
		self.direction = DIRECTION.DOWN
		self.collManager:SetCollideTop(false)
		self.sprite:IncreaseVY(1)
	elseif pDir == "LEFT" then
		self.direction = DIRECTION.LEFT
		self.collManager:SetCollideRight(false)
		self.sprite:IncreaseVX(-1)
	end
end

function Player:GetTopHS()
	return self.sprite:GetTopHS()
end

function Player:GetRightHS()
   return self.sprite:GetRightHS()
end

function Player:GetBottomHS()
   return self.sprite:GetBottomHS()
end

function Player:GetLeftHS()
   return self.sprite:GetLeftHS()
end

function Player:Collide(pSprite)
	return self.sprite:Collide(pSprite)
end

function Player:GetHitbox()
	return self.sprite:GetHitbox()
end

function Player:Update(dt)
	self.sprite:Update(dt)

	self.collManager:Update()
	local x = player.sprite:GetX()
	local y = player.sprite:GetY()
	player.sprite:SetX(x + player.sprite:GetVX())
	player.sprite:SetY(y + player.sprite:GetVY())


	-- self.direction = DIRECTION.NONE
end

function  Player:Draw()
	self.sprite:Draw()
end

return Player