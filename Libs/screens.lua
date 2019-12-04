-- Screen ne peut pas être local pour que les différents
-- ecrans puissent y accéder
datas = require("Libs.Sprite")

local Screen = {}
local Screen_mt = {__index = Screen}

function Screen.new(pScreenType, pImg, pX, pY)
  -- screenType = string indiquant le nom du type de menu. Ex : game
  -- img = image de fond
  -- x, y = position de l'image
  local screen = {}
   screen.image = {}
   if pImg ~= nil then
      --screen.image = love.graphics.newImage("images/"..pImg..".png")
      screen.image = datas.new(pImg, pX or 0, pY or 0)
   else
      screen.image = nil
   end
   screen.screenType = pScreenType
   return setmetatable(screen, Screen_mt)
end

function Screen:setImage(newImage)
  -- récupère les données de l'image précédente (s'ils existes)
  local x, y = 0, 0
  if self.image ~= nil then
    x = self.image.getX()
    y = self.image.getY()
  end
   if type(newImage) == "string" then
      self.image = Datas.new(newImage, x, y)
   end
end

function Screen:Draw()
   if self.image then
      --print("screens. Drawing image :", self.image:getImage(), "at :", self.image:getX(), ",",self.image:getY())
      love.graphics.draw(self.image:GetImage(), self.image:GetX(), self.image:GetY())
   end
end

return Screen
