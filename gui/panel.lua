local Datas = require("Libs.Sprite")

-- objet de création d'un panel
-- Fonctionnement global :
--		les panels sont chargés entièrs comme image de fond
--		puis les widgets sont ajoutés ensuite en fonction du besoin

-- M. Le Thiec
-- 06/06/18
-- V 0.00

local Panel = {}
local Panel_mt = { __index = Panel }

local STATE = {}
STATE.NORMAL = "normal" -- etat par defaut
STATE.CLICKED = "clicked" -- la fenetre est cliqué-> à le focus et à recu un clic
STATE.FOCUS = "focus"

local function UpdateState(self)
	if self.frame:HasFocus() then
		-- print("now Panel has focus")
		self.state = STATE.FOCUS
	else
		-- print("panel lost focus")
		self.state = STATE.NORMAL
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
	if type(THEME["panels"][pType]) == "table" then
		-- récupère les données du bouton depuis le fichier THEME
		local datas = BuildQuadsStructure(THEME["panels"][pType])
		-- Construit le quad du bouton pour chaque etat
		for entitled, data in pairs(datas) do
			if entitled ~= "name" and entitled ~= "bound" then
				local x, y, x1, y1 = unpack(data)
				-- print("buildQuads Panel :", entitled, x, y, x1, y1, imgWidth, imgHeight)
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

function Panel.new(pX, pY, pPanelName)
	-- pDrawable = image de fond de fenètre
	local panel = {}
	
	-- mappage de fond de la fenetre
	panel.name = pWinName
	panel.drawable = Datas.new(THEME["panels"][pPanelName].name, pX, pY)
	-- construit une table des quads de fenêtres (cas d'animations)
	panel.quads = {}
	-- conserve la position initiale de la fenètre pour la repositionner lors d'un show()
	panel.initialPos = {}
	panel.initialPos.x = pX
	panel.initialPos.y = pY
	local x, y, w, h = unpack(THEME["panels"][pPanelName].bound)
	panel.bound = {}
	panel.bound.x = x
	panel.bound.y = y
	panel.bound.w = w
	panel.bound.h = h

	panel.frame = Frame.new(pX, pY, panel.drawable.width, panel.drawable.height)

	panel.state = STATE.NORMAL
	panel.show = true

	BuildQuads(panel, pPanelName, panel.drawable.width, panel.drawable.height)
	-- print("create new Panel at :", pX, pY, pPanelName)
	return setmetatable(panel, Panel_mt)
end

function Panel:AddWidget(pWidget)
	-- ajoute un widget à la liste des widgets
	-- print("Panel.AddWidget(pWidget)",pWidget)
	self.frame:AddWidget(pWidget)

end

function Panel:GetPosition()
	return self.initialPos.x, self.initialPos.y
end

function Panel:GetBound()
	return self.initialPos.x, self.initialPos.y, self.bound.w, self.bound.h
end

function Panel:Show()
	self.show = true
	InitializePosition(self)
end

function Panel:Hide()
	self.show = false
end

function Panel:Update(dt)
	if self.show then
		self.frame:Update(dt)
		UpdateState(self)
	end
end

function Panel:Draw()
	if self.show then
		-- love.graphics.print("panel state : "..self.state, 10,200)
		love.graphics.draw(self.drawable:getImage(), self.quads[self.state], self.drawable:getX(), self.drawable:getY())  --, 0, 1, 1, self.drawable.centerX, self.drawable.centerY)
		-- infos de debug
		-- love.graphics.setColor(1,0,0)
		-- love.graphics.setColor(0,1,0)
		self.frame:Draw()
		-- love.graphics.setColor(1,1,1)
		-- love.graphics.print("zone de détection de topBar : "..self.topBar:GetX()..", "..self.topBar:GetY()..", "
		-- 	..self.topBar:GetWidth()..", "..self.topBar:GetHeight(), 10, 50)
		-- love.graphics.print("Etat de la fenetre : "..self.state, 10,65)

	end
end

return Panel