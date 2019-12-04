-- fichier de regroupage des différents outils de la GUI
-- Super require()

-- M. Le Thiec
-- 06/06/18
-- V 0.00
local cwd =(...):gsub('%.GUI$','').."."
GUI = {}

require(cwd.."GUI_Theme")

Frame = require(cwd.."frame")
Widget = require(cwd.."widget")
Button = require(cwd.."button")
ToggleButton = require(cwd.."toggleButton")
-- Window = require("window")
Panel = require(cwd.."panel")
-- Label = require("label")

-- TODO : faire une fonction init avec tous les objects "widgets" du jeux
-- WOption = require("wOption")

function GUI.init()
	-- widgetSheet = ressources:LoadImage(THEME.widgetSheet)
 	mainGUIFont = ressources:LoadFont("COOPBL", 16)
 	labelGUIFont = ressources:LoadFont("LSANS", 22)
 	-- love.graphics.setFont(mainGUIText)
end

return GUI