-- implémentation de l'écran de transition scaleIn - Out
-- M. Le Thiec
-- 08/03/2018
-- V : 1.00

local TransScene = {}
local TransScene_mt = { __index = TransScene }
local loop
local TILESNBR = 30 -- nombre de tuile générée en ligne et en colonne (nbr d'après tests sur ecran 800x600)
local FULLTILESCREEN = 20 -- nombre de tuile maxi pour couvrir l'écran (ici 800 / 40) + 1
-- etat possible de l'écran de transition
local ESTATES = {}
ESTATES.IN = "in"
ESTATES.OUT = "out"
ESTATES.FINISH = "finish"

function TransScene.new(pTileName)
	local transScene = {}
	transScene.tiles = love.graphics.newImage("images/"..pTileName..".png")
	transScene.width = transScene.tiles:getWidth()
	transScene.tileScaleX = 0 -- on commence avec 0 de scale en x et en y
	transScene.tileScaleY = 0
	transScene.tileCenter = transScene.width / 2 -- ici la tile doit etre carrée
	transScene.effect = nil -- temps d'attente entre les 2 transitions
	transScene.currentWait = 0 -- temps actuel d'attente
	transScene.finish = false
	transScene.effectSpeed = 0.02 -- secondes
	transScene.timer = 0
	transScene.effectValues = {}
	transScene.state = nil
	-- Initialise les tuiles
	TransScene.init(transScene)
	return setmetatable(transScene, TransScene_mt)
end

function TransScene:init(pEffect)
	-- pReference est un objet de menu pour pouvoir l'appeller lor du draw
	self.effectValues = {}
	self.effect = pEffect
	self.finish = false
	self.timer = 0
	self.angle = 0
	loop = 1

	local value
	if self.effect == "in" then
		self.state = ESTATES.IN
		value = 0
	elseif self.effect == "out" then
		self.state = ESTATES.OUT
		value = 1
	end
	-- initialise le tableau de valeurs
	for i = 1, TILESNBR do
		table.insert(self.effectValues, value)
	end
end

function TransScene:getState()
	return self.state
end

function TransScene:isFinish()
	return self.finish
end

function TransScene:scaleLRIn(loop)
	-- définie les taille croissantes des tuiles de la gauche vers la droite
	if self.effectValues[TILESNBR-1] > 0 then
		self.finish = true
	else
		for i = 1, #self.effectValues do
	  		if i <= loop then
	  			-- plus on avance dans la loop, plus le scale est puissant !
				self.effectValues[i] = self.effectValues[i] + 0.1
				if self.effectValues[i] > 1 then self.effectValues[i] = 1 end
			end
			
		end
	end
end

function TransScene:scaleLROut(loop)
	-- définie les taille croissantes des tuiles de la la droite vers la gauche
	if self.effectValues[FULLTILESCREEN] == 0 then
		self.finish = true
	else
		for i = 1, #self.effectValues do
	  		if i <= loop then
	  			-- plus on avance dans la loop, moins le scale est puissant !
				self.effectValues[i] = self.effectValues[i] - 0.1
				if self.effectValues[i] < 0.2 then self.effectValues[i] = 0 end
			end
		end
	end
end

function TransScene:Update(dt)
	if self.timer > self.effectSpeed then
		self.timer = 0
		if self.state == ESTATES.IN then
			self:scaleLRIn(loop)		
			loop = loop + 1

		elseif self.state == ESTATES.OUT then
			self:scaleLROut(loop)
			loop = loop + 1
		end
	else
		self.timer = self.timer + dt
	end
	--print("état en fin de Update ", self.state, "loop =", loop)
end

function TransScene:Draw()
	-- on ne déssine que les tuiles visibles à l'écran
	for col = 1, FULLTILESCREEN do
		self.tileScaleX = 1 --self.effectValues[col]
		self.tileScaleY = self.effectValues[col]
		for line = 1, TILESNBR do
		  	love.graphics.draw(self.tiles, col * self.width - self.tileCenter,
		  								   line * self.width - self.tileCenter,
		  								   math.rad(self.angle),
		  								   self.tileScaleX, self.tileScaleY,
		  								   self.tileCenter, self.tileCenter)
		  
		end
	end
end

return TransScene