--require("sprite12a1")
local Sprite = {}
local Sprite_mt = {__index = Sprite}
local AnimationCls = require "Libs.Animation"
local HitboxCls = require "Libs.Hitbox"
local drawDebug = false


local function ExistName(self, pName)
   for k,name in pairs(self.animations) do
      if k == pName then
         return true
      end
   end
   return false
end

local function UpdateFriction(self)
   if self. vx ~= 0 then
      if self.vx > 0 then
         self.vx = self.vx - self.friction
      else
         self.vx = self.vx + self.friction
      end
   end
   if self.vy ~= 0 then
      if self.vy > 0 then
         self.vy = self.vy - self.friction
      else
         self.vy = self.vy + self.friction
      end
   end
   if math.abs(self.vx) < 0.01 then self.vx = 0 end
   if math.abs(self.vy) < 0.1 then self.vy = 0 end
end

local function BottomCenter(self)
   self.centerY = self.height
end

local function DrawDebug(self)
   -- draw center with a cross
   local lenght = 50
   local cx = self.x - self.currentAnimation.quadDim.w / 2 * Gscale
   local cy = self.y - self.currentAnimation.quadDim.h / 2 * Gscale
   local lw = self.currentAnimation.quadDim.w * Gscale
   local lh = self.currentAnimation.quadDim.h * Gscale
   love.graphics.setColor(1,0,0,1)
   love.graphics.rectangle("line", cx, cy, lw , lh)
   self.hb:Draw()
   love.graphics.setColor(1,1,1,1)

end

-- ***************************************** PUBLIC *****************************
function Sprite.new(pImage, pX, pY, pAcceleration, pMaxVeloc, pFriction,
   pAnimated, pFrameWidth, pFrameHeight)
   local sprite = {}
   -- print("Create new Datas sprite at :",pImage,pX, pY)

      -- En attente d'implémentation des sprites
   sprite.image = ressources:LoadImage(pImage)
   sprite.width = sprite.image:getWidth()
   sprite.height = sprite.image:getHeight()
   -- by default centerd origin of sprite to center of image
   sprite.originX = sprite.width / 2
   sprite.originY = sprite.height / 2

   sprite.x = pX or 0
   sprite.y = pY or 0
   sprite.delta = {}
   sprite.delta.x = 0
   sprite.delta.y = 0
   sprite.frameW = sprite.width
   sprite.frameH = sprite.height
   sprite.animations = {}
   sprite.toUpdate = false
   if pAnimated == true then
      sprite.frameW = pFrameWidth
      sprite.frameH = pFrameHeight
      sprite.originX = pFrameWidth / 2
      sprite.originY = pFrameHeight / 2
   end
   sprite.currentAnimation = nil
   sprite.angle = 0
   sprite.vx = 0
   sprite.vy = 0
   sprite.angle = 0
   sprite.hb = nil
   sprite.friction = pFriction
   sprite.maxVelocity = pMaxVeloc
   sprite.acceleration = pAcceleration
   sprite.onAccelerateX = false
   sprite.onAccelerateY = false

   return setmetatable(sprite, Sprite_mt)
end

function Sprite:AddAnimation(pName, pFrameOrder, pFrameRate, pLoop, pFlipV, pFlipH)
   if self.toUpdate == false then self.toUpdate = true end
   local name = string.upper(pName)
   self.animations[name] = AnimationCls.new(pFrameOrder, pFrameRate, pLoop,
      self.width, self.height, self.frameW, self.frameH, pFlipV, pFlipH)
   if self.currentAnimation == nil then
      self.currentAnimation = self.animations[name]
   end
end

function Sprite:Play(pName)
   local name = string.upper(pName)
   if ExistName(self, name) then
      self.currentAnimation = self.animations[name]
   end
end

function Sprite:SetHitbox(pAnchor, pWidth, pHeight)
   self.hb = HitboxCls.new(self.x , 
                           self.y ,
                           pWidth,
                           pHeight,
                           string.upper(pAnchor)
                           )
end

function Sprite:GetHitbox()
   return self.hb:GetBox()
end

function Sprite:SetOrigin(pX, pY)
   -- set anchor position reference by x and y position
   self.originX = pX
   self.originY = pY
end

function Sprite:SetFriction(pFriction)
   self.friction = math.abs(pFriction)
end

function Sprite:SetMaxVelocity(pMaxVelocity)
   self.maxVelocity = math.abs(pMaxVelocity)
end

function Sprite:SetAcceleration(pAcceleration)
   self.acceleration = math.abs(pAcceleration)
end

function Sprite:GetAcceleration()
   return self.acceleration
end

function Sprite:GetX()
   return self.x
end

function Sprite:GetY()
   return self.y
end

function Sprite:GetX1()
   -- pour les controles de collisions
   return self.x + self.width
end

function Sprite:GetY1()
   -- pour les controles de collisions
   return self.y + self.heiGht
end

function Sprite:SetX(newX)
   self.delta.x = newX - self.x
   self.x = newX
   self.hb:SetX(newX)
end

function Sprite:SetY(newY)
   self.delta.y = newY - self.y
   self.y = newY
   self.hb:SetY(newY)
end

function Sprite:MoveAt(pX, pY)
   SetX(pX)
   SetY(pY)
end

function Sprite:GetOriginX()
   return self.originX
end

function Sprite:GetOriginY()
   return self.originY
end

function Sprite:GetAngle()
   return self.angle
end

function Sprite:GetVX()
   return self.vx
end

function Sprite:GetVY()
   return self.vy
end

function Sprite:SetVX(pVX)
   self.vx = pVX or 0
end

function Sprite:SetVY(pVY)
   self.vy = pVY or 0
end

function Sprite:GetTopHS()
   return self.hb:GetTopHS()
end

function Sprite:GetRightHS()
   return self.hb:GetRightHS()
end

function Sprite:GetBottomHS()
   return self.hb:GetBottomHS()
end

function Sprite:GetLeftHS()
   return self.hb:GetLeftHS()
end

function Sprite:IncreaseVX(pFactor)
   self.vx = math.abs(self.vx) + self.acceleration
   if self.vx > self.maxVelocity then
      self.vx = self.maxVelocity
   end
   self.vx = self.vx * pFactor
   self.onAccelerateX = true
end

function Sprite:IncreaseVY(pFactor)
   self.vy = math.abs(self.vy) + self.acceleration
   if self.vy > self.maxVelocity then
      self.vy = self.maxVelocity
   end
   self.vy = self.vy * pFactor
   self.onAccelerateY = true
end

function Sprite:GetImage()
   return self.image
end

function Sprite:GetHitbox()
   return self.hb:GetBox()
end

function Sprite:Collide(pSprite)
   return self.hb:IsCollide(pSprite.hb)
end

function Sprite:Update(dt)
   if self.friction > 0 and 
      (self.onAccelerateX == false or self.onAccelerateY == false) then
      -- update friction
      UpdateFriction(self)
   end
   if self.hb ~= nil then
      -- print("self.delta = ", self.delta.x, self.delta.y)
      self.hb:Move(self.delta)
   end

   self.onAccelerateX = false
   self.onAccelerateY = false
   if self.toUpdate then
      self.currentAnimation:Update(dt)
   end
end

function Sprite:Draw()
   if self.currentAnimation == nil then
      love.graphics.draw(self.image, self.x, self.y,
         self.angle, Gscale, Gscale, self.originX, self.originY)
   else
      love.graphics.draw(self.image, self.currentAnimation:GetQuad(),
         self.x, self.y,
         self.angle, Gscale * self.currentAnimation:FlipV(),
         Gscale * self.currentAnimation:FlipH(),
         self.originX, self.originY)
   end
   if Gdebug then
      DrawDebug(self)
   end
end

return Sprite
