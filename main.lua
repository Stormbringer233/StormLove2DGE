-- Fichier de base de projet love 2D

-- permet d'imprimer en console les informations avec la fenêtre love overte
io.stdout:setvbuf('no')

-- permet le debuggage avec Zerobrane Studio
if arg[#arg] == "-debug" then require("mobdebug").start() end

-- Empèche le lissage de sprite pour garder le pixel art
love.graphics.setDefaultFilter("nearest")

-- Début du jeu --------------------------------------------------------------
-- local cwd =(...):gsub('%.Libs$','').."."

require "inits"

local Ver = "0.00"

local GameScreen = require("Scenes.game")
local MenuScreen = require("Libs.menu")

SCREEN_WIDTH, SCREEN_HEIGHT = 0, 0

function love.load()
  --print ("love version :",love.getVersion())
  -- Initialize statics functions for all games
  -- init.Initialize()

  love.window.setMode(1024, 840)
  love.window.setTitle(" - by Stormbringer - v : "..Ver)
  SCREEN_WIDTH = love.graphics.getWidth()
  SCREEN_HEIGHT = love.graphics.getHeight()

  sceneManager:Add("menu", MenuScreen.new())
  sceneManager:Add("game", GameScreen.new())
  sceneManager:SwitchTo("game") -- only during debug process
  
end

function love.update(dt)
  sceneManager:Update(dt)
end

function love.draw()
   sceneManager:Draw()
end

function love.keypressed(key)
  sceneManager:Keypressed(key)
end
