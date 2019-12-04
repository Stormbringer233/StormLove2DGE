-- Objet de gestion de la boucle de jeux

math.randomseed(love.timer.getTime())
-- package.path = package.path .. ";../?.lua"

local Game = {}
local Game_mt = { __index = Game }
-- require("rules") -- donnée générales du jeu
local GUI = require("GUI")
require("Libs.collisions")

local TMCls = require("Libs.TileMapLoader")
local PlayerCls = require("Player")
local TimerCls = require("Libs.timer")
local camera -- require into inits.lua

local function CollideLeft(pMap, pCharacter)
  local x0, y0, x1, y1 = unpack(pCharacter:GetLeftHS())
  local boxes = pMap:GetCollideBoxes()
  for k, box in ipairs(boxes) do
    local b = {box.x, box.y, box.w, box.h}
    if PointBox(x0, y0, b) or PointBox(x1, y1, b) then
      pCharacter:StopLeft()
    end
  end
end

local function CollideRight(pMap, pCharacter)
  local x0, y0, x1, y1 = unpack(pCharacter:GetRightHS())
  local boxes = pMap:GetCollideBoxes()
  for k, box in ipairs(boxes) do
    local b = {box.x, box.y, box.w, box.h}
    if PointBox(x0, y0, b) or PointBox(x1, y1, b) then
      pCharacter:StopRight()
    end
  end
end

local function CollideTop(pMap, pCharacter)
  local x0, y0, x1, y1 = unpack(pCharacter:GetTopHS())
  local boxes = pMap:GetCollideBoxes()
  for k, box in ipairs(boxes) do
    local b = {box.x, box.y, box.w, box.h}
    if PointBox(x0, y0, b) or PointBox(x1, y1, b) then
      pCharacter:StopTop()
    end
  end
end

local function CollideBottom(pMap, pCharacter)
  local x0, y0, x1, y1 = unpack(pCharacter:GetBottomHS())
  local boxes = pMap:GetCollideBoxes()
  for k, box in ipairs(boxes) do
    local b = {box.x, box.y, box.w, box.h}
    if PointBox(x0, y0, b) or PointBox(x1, y1, b) then
      pCharacter:StopBottom()
    end
  end
end

local function ManageMapCollisions(pMap, pCharacter)
  CollideLeft(pMap, pCharacter)
  CollideRight(pMap, pCharacter)
  CollideTop(pMap, pCharacter)
  CollideBottom(pMap, pCharacter)
end

local function InitGame(self)
  self.debugFont = ressources:LoadFont("COOPBL", 14)
  player = PlayerCls.new("personnage-Sheet", 200,300)
  
  
  player:Play("IDLE")
  map = TMCls.load("sol", 50, 50)

  print("map width =",map.width)
  print("map height =", map.height)
  print("tileset imagewidth :", map.tilesets[1].imagewidth)
  -- SpriteSheet des objects du jeux
  local x, y = player:GetPosition()
  camera = CameraCls.new(x, y, player)
  camera:SetWindow(0,0,1024,840)
  local ww, wh = map:GetMapPixelDimensions()
  camera:SetPixelWorldDimension(ww, wh)
end

function Game.new()
  local game = {}
  
  InitGame(game)

  print("game.new() ended")
  return setmetatable(game, Game_mt)
end

function Game:Update(dt)
  mouse:Update(dt)

  if not love.keyboard.isDown("up","right", "down", "left") then
    player:Play("IDLE")
  end
    if love.keyboard.isDown("up") then
    player:Play("RUN_UP")
    player:Move("up")
  end
  if love.keyboard.isDown("right") then
    player:Play("RUN_RIGHT")
    player:Move("right")
  end
  if love.keyboard.isDown("down") then
    player:Play("RUN_DOWN")
    player:Move("down")
  end
  if love.keyboard.isDown("left") then
    player:Play("RUN_LEFT")
    player:Move("left")
  end
  player:Update(dt)
  ManageMapCollisions(map, player)
  camera:Update(dt)
end

function Game:Draw()
   -- sauvegarde les données d'affiche d'origine
  camera:Draw()
  map:Draw()
  player:Draw()
  -- pnj:Draw()
  if Gdebug then
    printDebug(self)
  end
end

function Game:Keypressed(key)
  if key == "escape" then
    sceneManager:SwitchTo("menu")
  end
end

function printDebug(self)
  love.graphics.setFont(self.debugFont)
  love.graphics.print("You are into Game screen", 50, SCREEN_HEIGHT - 20)
  

  love.graphics.print("Mouse screen position : "..string.format("%d %d",mouse:GetPosition()), 10,10)
  -- love.graphics.print("Mouse world position : "..string.format("%d %d",mouse:GetWorldPosition()), 10,25)
 
end

return Game
