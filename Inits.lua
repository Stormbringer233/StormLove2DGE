Inits = {}
-- "classe statique" de gestion des ressources
local RessourcesCls = require"Libs.ressourcesManager"
local MouseCls = require "Libs.MouseManager"
local SceneManagerCls = require "Libs.SceneManager"
CameraCls = require "Libs.camera" -- global
require "rules"


ressources = RessourcesCls.new()
mouse = MouseCls.new()
sceneManager = SceneManagerCls.new()
Gscale = 2 -- Global scale for all of graphics
Gdebug = true

Inits.camera = {}
Inits.camera.speed = 0
Inits.camera.minScale = 1
Inits.camera.maxScale = 1
Inits.camera.scrollRatioLimit = 0
Inits.tileWidth = 32 -- must be change. Multiple definition is dangerous (> DRY)

return Inits