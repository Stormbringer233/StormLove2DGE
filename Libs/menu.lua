local screen = require("Libs.screens")

local Menu = {}
local Menu_mt = { __index = Menu}

local alphaFull = 1
local alphaSoft = 0.5
local oldKeyState = nil;

function next(self)
	if self.state == "Play" then
		self.state = "Quit"
	elseif self.state == "Quit" then
		self.state = "Play"
	end
end

function Menu.new()
	local menu ={}
	menu.screen = screen.new("menu", "img_menu", 0,0)
	menu.menuFont = ressources:LoadFont("COOPBL", 80)
	--menu.menuFont = love.graphics.newFont("fonts/COOPBL.TTF", 80)
	menu.state = "Play"

	print("menu.new() ended")
	return setmetatable(menu, Menu_mt)
end

function Menu:setState(newState)
	self.state = newState
end

function Menu:getState()
	return self.state
end

function Menu:Keypressed(key)	
	if key == "up" then
		next(self)
	elseif key == "down" then
		next(self)
	end
	if key == "escape" then
		love.event.quit()
	end
	if key == "return" and self.state == "Quit" then
		love.event.quit()
	elseif key == "return" and self.state == "Play" then
		sceneManager:SwitchTo("game")
	end
end

function Menu:Update(dt)
	mouse:Update(dt)
end

function Menu:Draw()
	-- Dessine l'objet "base" Screens
	self.screen:Draw()
	-- affiche les textes par dessus l'image
	love.graphics.setFont(self.menuFont)
	--love.graphics.push()
	if self.state == "Play" then
		love.graphics.setColor(0.2,0.5,1, alphaFull)
		love.graphics.print("Play", 500, 300)
		love.graphics.setColor(0.2,0.2,0.2, alphaSoft)
		love.graphics.print("Quit", 500, 400)
	else
		love.graphics.setColor(0.2,0.2,0.2, alphaSoft)
		love.graphics.print("Play", 500, 300)
		love.graphics.setColor(0.2,0.5,1, alphaFull)
		love.graphics.print("Quit", 500, 400)
	end
	love.graphics.setColor(1,1,1,1)

end

return Menu
