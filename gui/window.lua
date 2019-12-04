local Datas = require("Libs.Sprite")

-- objet de création de fenetre
-- Fonctionnement global :
--		les fenetres sont chargées entières comme image de fond
--		puis les widgets sont ajoutés ensuite en fonction du besoin

-- M. Le Thiec
-- 06/06/18
-- V 0.00

local Window = {}
local Window_mt = { __index = Window }

local STATE = {}
STATE.NORMAL = "normal" -- etat par defaut
STATE.CLICKED = "clicked" -- la fenetre est cliqué-> à le focus et à recu un clic
STATE.FOCUS = "focus"

local function FocusBar(self)
	-- teste l'état de la barre supérieure
	 local topBarFocus = self.topBar:HasFocus()

	if topBarFocus and mouse.leftClick == "released" and self.state == STATE.NORMAL then
		-- prise de focus de la barre de déplacement
		self.state = STATE.FOCUS
	elseif topBarFocus and mouse.leftClick == "pressed" and self.state == STATE.FOCUS then
		-- activation de la barre -- La fenètre se déplace relativement à la souris
		self.state = STATE.CLICKED
	elseif topBarFocus and mouse.leftClick == "released" and self.state == STATE.CLICKED then
		-- on relache le click, mais on garde le focus
		self.state = STATE.NORMAL
	elseif not topBarFocus and mouse.leftClick == "released" then
		-- interdit tout autre comportement
		self.state = STATE.NORMAL
	end
end

local function Move(self)
	-- déplace la fenètre en fonction du déplacement de la souris
	FocusBar(self)
	if self.state == STATE.CLICKED then
		-- on verifie egalement qu'aucun widget n'a le focus
		local toMove = false
		for _, state in ipairs(self.topBar:GetWidgetsStates()) do
			-- Il est possible de déplacer la fenetre que si on à pas activer le bouton exit
			-- ou s'il n'est pas actif
			if state == "normal" or state == "freeze" then toMove = true end
		end
		if toMove then
			-- récupère le déplacement relatif de la souris
			local dx, dy = mouse:GetDelta()
			-- on met à jour toutes les frames et leur contenu
			self.topBar:Move(dx, dy)
			self.frame:Move(dx, dy)
			self.drawable:setX(self.drawable:getX() + dx)
			self.drawable:setY(self.drawable:getY() + dy)
		end
	end
end

local function InitializePosition(self)
	-- remet la fenètre à sa position initiale
	self.drawable:setX(self.initialPos.x)
	self.drawable:setY(self.initialPos.y)
	-- remet à jour les frames
	-- pour la topBar on part de 0,0
	self.topBar:SetPosition(self.initialPos.x, self.initialPos.y)
	-- pour la frame centrale, on ajoute la hauteur de la topBar
	self.frame:SetPosition(self.initialPos.x, self.initialPos.y + self.bound.h)
end

local function BuildQuadsStructure(pStructure)
	-- construit une table des identifiants du widget à créer référencé dans
	-- la table THEME_GUI pour s'adapter au contexte du widget à traiter
	-- pStructure : table provenant de THEME_GUI sous la forme THEME[typeWidget][nom]
	-- ex : THEME["button"]["default"]
	-- retour : liste des intitulés de comportement du widget + contenu de la table de l'intitulé
	local datas = {}
	for entitled, data in pairs(pStructure) do
		datas[entitled] = data
	end
	-- print("------------ DEBUG ----------")
	-- for e, i in pairs(datas) do
	-- 	print("entitled :",e,i)
	-- end
	return datas
end

local function BuildQuads(self, pType, imgWidth, imgHeight)
	-- stocke les différents quads d'animation de la fenetre
	-- print("BuildQuads :", imgWidth, imgHeight)
	if type(THEME["windows"][pType]) == "table" then
		-- récupère les données du bouton depuis le fichier THEME
		local datas = BuildQuadsStructure(THEME["windows"][pType])
		-- Construit le quad du bouton pour chaque etat
		for entitled, data in pairs(datas) do
			if entitled ~= "name" and entitled ~= "bound" then
				local x, y, x1, y1 = unpack(data)
				-- print("buildQuads Window :", entitled, x, y, x1, y1, imgWidth, imgHeight)
				self.quads[entitled] = love.graphics.newQuad(x, y, x1 - x, y1 - y, imgWidth, imgHeight)
				if entitled == "focus" then
					-- quand la fenetre est clicked, le quad est le même que l'état focus
					self.quads["clicked"] = love.graphics.newQuad(x, y, x1 - x, y1 - y, imgWidth, imgHeight)
				end
			end
			-- on calcule les coordonées de centrage et de taille de widget par rapport à l'état normal (etat de base)
		end
	end
end

function Window.new(pX, pY, pWinName)
	-- pDrawable = image de fond de fenètre
	local window = {}
	
	-- mappage de fond de la fenetre
	window.name = pWinName
	window.drawable = Datas.new(THEME["windows"][pWinName].name, pX, pY)
	-- construit une table des quads de fenêtres (cas d'animations)
	window.quads = {}
	-- conserve la position initiale de la fenètre pour la repositionner lors d'un show()
	window.initialPos = {}
	window.initialPos.x = pX
	window.initialPos.y = pY
	local x, y, w, h = unpack(THEME["windows"][pWinName].bound)
	window.bound = {}
	window.bound.x = x
	window.bound.y = y
	window.bound.w = w
	window.bound.h = h
	-- frame conteneur du haut de la fenetre
	window.topBar = Frame.new(pX + x, pY + y, w, h)
	-- conteneur de tous les widgets de l'espace  principal
	-- +1 pour ne pas chevaucher la topBar bound
	window.frame = Frame.new(pX + x, pY + y + h + 1, w, window.drawable.height - h - 1)

	window.state = STATE.NONE
	window.show = true

	BuildQuads(window, pWinName, window.drawable.width, window.drawable.height)
	-- print("create new Window at :", pX, pY, pWinName)
	return setmetatable(window, Window_mt)
end

function Window:AddWidget(pWidget)
	-- ajoute un widget à la liste des widgets
	-- print("Window.AddWidget(pWidget)",pWidget)
	if pWidget:GetMaster() == "topBar" then
		self.topBar:AddWidget(pWidget)
	elseif pWidget:GetMaster() == "frame" then
		self.frame:AddWidget(pWidget)
	end
end

function Window:Show()
	self.show = true
	InitializePosition(self)
end

function Window:Hide()
	self.show = false
end

function Window:Update(dt)
	if self.show then
		Move(self)
		self.topBar:Update(dt)
		self.frame:Update(dt)
	end
end

function Window:Draw()
	if self.show then
		love.graphics.print("window state : "..self.state, 10,200)
		love.graphics.draw(self.drawable:getImage(), self.quads[self.state], self.drawable:getX(), self.drawable:getY())  --, 0, 1, 1, self.drawable.centerX, self.drawable.centerY)
		-- infos de debug
		-- love.graphics.setColor(1,0,0)
		self.topBar:Draw()
		-- love.graphics.setColor(0,1,0)
		self.frame:Draw()
		-- love.graphics.setColor(1,1,1)
		-- love.graphics.print("zone de détection de topBar : "..self.topBar:GetX()..", "..self.topBar:GetY()..", "
		-- 	..self.topBar:GetWidth()..", "..self.topBar:GetHeight(), 10, 50)
		-- love.graphics.print("Etat de la fenetre : "..self.state, 10,65)

	end
end

return Window