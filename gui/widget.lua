local Datas = require("Libs.Sprite")
-- Objet généric widget. Contient la définition graphique du widget, ainsi que sa
-- position.

-- M. Le Thiec
-- 04/06/2018

local Widget = {}
local Widget_mt = { __index = Widget }

local STATE = {}
STATE.NORMAL = "normal" -- etat par defaut
STATE.CLICKED = "clicked" -- le widget est cliqué-> à le focus et à recu un clic
STATE.DEACTIVATE = "deactivate" -- le widget est désactivé -> n'a plus le focus, mais click enfoncé
STATE.ACTIVATE = "activate" -- le widget est activé -> a le focus et le click passe de pressed -> released
STATE.FOCUS = "focus"
STATE.FREEZE = "freeze" -- quand le widget est indisponible (grisé)

local colors = {} -- debug
colors["normal"] = {1, 1, 1}
colors["clicked"] = {0, 0.8, 0}
colors["deactivate"] = {0.8,0.8,0}
colors["activate"] = {1,0,1}
colors["focus"] = {0.8, 0, 0}
colors["freeze"] = {0.5,0.5,0.5}

local debug = false

-- Normalize two numbers.
function math.normalize(x,y) local l=(x*x+y*y)^.5 if l==0 then return 0,0,0 else return x/l,y/l,l end end

local function GetX1(self)
	return self.drawable:getX1()
end

local function GetY1(self)
	return self.drawable:getY1()
end

local function UpdateOldState(self)
	self.oldState = self.state
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

local function BuildColors(self, pType, imgWidth, imgHeight)
	-- fonction identique à BuildQuads mais adapté pour les widget de type label où
	-- il est nécessaire de récupérer la couleur et non le quad
	local datas = BuildQuadsStructure(THEME[pType][self.name])
	for entitled, data in pairs(datas) do
		local r, g, b, a = unpack(data)
		local stringEntitled = tostring(entitled)
		self.colors[stringEntitled] = {r, g, b, a}
	end
end

local function BuildQuads(self, pType, imgWidth, imgHeight)
	-- stocke les différents quads d'animation de la fenetre
	-- print("BuildQuads :", imgWidth, imgHeight)
	if type(THEME[pType][self.name].normal) == "table" then
		-- récupère les données du bouton depuis le fichier THEME
		local datas = BuildQuadsStructure(THEME[pType][self.name])
		-- Construit le quad du bouton pour chaque etat
		for entitled, data in pairs(datas) do
			local x, y, x1, y1 = unpack(data)
			local stringEntitled = tostring(entitled)
			self.quads[stringEntitled] = love.graphics.newQuad(x, y, x1 - x, y1 - y, imgWidth, imgHeight)
			-- on calcule les coordonées de centrage et de taille de widget par rapport à l'état normal (etat de base)
			if stringEntitled == "normal" then
				-- calcule le centre du widget pour l'affichage
				self.center.x = math.floor((x1 - x) / 2)
				self.center.y = math.floor((y1 - y) / 2)
				-- calcule de la bouding box / quads etat normal
				self.bound.w = x1 - x
				self.bound.h = y1 - y
			end
		end
	else
		-- image entiere - Pas d'animation - ATTENTION, cette construction de quads ne convient pas à tous les widgets
		self.quads["normal"] = love.graphics.newQuad(0, 0, imgWidth, imgHeight, imgWidth, imgHeight)
		self.quads["focus"] = love.graphics.newQuad(0, 0, imgWidth, imgHeight, imgWidth, imgHeight)
		self.quads["clicked"] = love.graphics.newQuad(0, 0, imgWidth, imgHeight, imgWidth, imgHeight)
		self.quads["activate"] = love.graphics.newQuad(0, 0, imgWidth, imgHeight, imgWidth, imgHeight)
		self.quads["deactivate"] = love.graphics.newQuad(0, 0, imgWidth, imgHeight, imgWidth, imgHeight)
		self.quads["freeze"] = love.graphics.newQuad(0, 0, imgWidth, imgHeight, imgWidth, imgHeight)
		-- calcule le centre du widget pour l'affichage
		self.center.x = imgWidth / 2
		self.center.y = imgHeight / 2
		-- calcule de la bouding box - Ici image entière
		self.bound.w = imgWidth
		self.bound.h = imgHeight
	end
end


local function PrintDebug(self)
	love.graphics.setFont(mainGUIFont)
	love.graphics.setColor(1,1,1,1)
	-- love.graphics.line(0,95,200,95)
	-- love.graphics.line(10,0,10,200)
	love.graphics.print("widget position : "..tostring(self:GetX()).." , "..tostring(self:GetY()).." | center : "..
		tostring(self.center.x).." , "..tostring(self.center.y), 10,80)
	love.graphics.print("boundingBox : "..self.bound.x.." , "..self.bound.y.." , "..self.bound.w.." , "..self.bound.h, 10,95)
	love.graphics.print("Etat du widget : "..self.state.." | oldState : "..self.oldState, 10,115)
	if self.hasFocus then
		-- love.graphics.print("widget has focus", 10,80)
	end
end

function Widget.new(pMaster, pX, pY, pType, pWidgetName)
	-- pType : indique le type de widget (button, label, check, ...)
	-- pDrawable : nom du fichier de la spritesheet des widgets
	local widget = {}
	widget.name = pWidgetName
	widget.type = pType
	-- au cas ou on ne founit pas d'image pour le widget
	widget.master = pMaster -- élément conteneur du widget. Permet de se référencer au conteneur
							-- pX, pY = position par rapport au conteneur
	widget.drawable = Datas.new(THEME.widgetSheet, pX, pY)
	widget.show = true
	widget.hasFocus = false
	widget.center = {} -- reprend le calcul du centre / quad et non à l'image
	widget.center.x = 0
	widget.center.y = 0

	widget.bound = {}-- zone de détection de focus. Peut être != de la taille du quad
	widget.bound.x = 0
	widget.bound.y = 0
	widget.bound.w = 0
	widget.bound.h = 0

	widget.state = STATE.NORMAL -- etat du widget dans la frame courante
	widget.oldState = STATE.NORMAL  -- etat du widget à la frame précédente
	widget.quads = {}
	widget.colors = {}
	-- print("create new widget :",pMaster, pX, pY, pType, pWidgetName)
	if pType == "label" then
		-- Dans le cas dun label, on construit une table de couleur
		BuildColors(widget, pType, widget.drawable.width, widget.drawable.height)
	else
		BuildQuads(widget, pType, widget.drawable.width, widget.drawable.height)
	end
	return setmetatable(widget, Widget_mt)
end

function Widget:GetX()
	return self.drawable:getX()
end

function Widget:GetY()
	return self.drawable:getY()
end

function Widget:SetX(newX)
	-- print("Widget:SetX(newX) :",newX)
	self.drawable:setX(newX)
	-- met à jour la position de la bounding box
	self.bound.x = math.floor(newX - self.bound.w / 2)
end

function Widget:SetY(newY)
	self.drawable:setY(newY)
	self.bound.y = math.floor(newY - self.bound.h / 2)
end

function Widget:GetScaleX()
	return self.drawable:getScaleX()
end

function Widget:GetScaleY()
	return self.drawable:getScaleY()
end

function Widget:GetAngle()
	return self.drawable:getAngle()
end

function Widget:GetColor()
	--renvoie la couleur du lable en fonction de son etat
	if self.type == "label" then
		return self.colors[self.state]
	end
	return nil
end

function Widget:SetInactive()
	self.state = STATE.INACTIVE
end

function Widget:Move(pDX, pDY)
	-- print("Widget:Move(pDX, pDY)", pDX, pDY, self.drawable.x, self.drawable.y)
	self.drawable:setX(self.drawable:getX() + pDX)
	self.drawable:setY(self.drawable:getY() + pDY)
	-- update la bouding box
	self.bound.x = self.bound.x + pDX
	self.bound.y = self.bound.y + pDY
end

function Widget:GetBoundingBox()
	return self.bound.x, self.bound.y, self.bound.w, self.bound.h
end

function Widget:GetOldState()
	return self.oldState
end

function Widget:GetState()
	return self.state
end

function Widget:SetState(newState)
	UpdateOldState(self)
	--- Valeur par defaut si le newState transmis ne fait pas parti des autorisés
	local state = "normal"
	for _, searchState in pairs(STATE) do
		-- print("searchState :", searchState)
		if newState == searchState then
			state = newState
			break;
		end
	end
	-- print("widget is set to",state)
	self.state = state
	
end

function Widget:GetPosition()
	return self.drawable:getX(), self.drawable:getY()
end

function Widget:Show()
	self.show = true
end

function Widget:Hide()
	self.show = false
	self.freeze = true
end

function Widget:Freeze()
	self.freeze = true
end

function Widget:Unfreeze()
	self.freeze = false
end

function Widget:Activate()
	-- active complétement le widget
	self.show = true
	self.freeze = false
end

function Widget:OnReleased()
	-- active le widget si :
		-- le widget a le focus et à été clické à la frame précédente
		-- la souris passe de leftClick == "pressed" and oldClick == "pressed" à LC = "released" and oldC == "pressed"
	if self.state == STATE.ACTIVATE then
		return true
	end
	return false
end

function Widget:OnClick()
	-- active le widget des qu'il est cliqué et qu'il a le focus (peu utilisé)
	-- TODO
	if self.state == STATE.CLICKED then
		return true
	end
	return false
end

function Widget:HasFocus()
	-- vérifie si le curseur de souris est inscrit dans la bouding box du widget
	mx, my = mouse:GetPosition()
	local x, y = self:GetPosition()
	-- print("Widget:HasFocus() :", mx, my, x, y, GetX1(self), GetY1(self))
	if mx >= self.bound.x and mx <= self.bound.x + self.bound.w and 
		my >= self.bound.y and my <= self.bound.y + self.bound.h then
		-- print("widget has focus")
		self.hasFocus = true
	else
		self.hasFocus = false
	end 
	return self.hasFocus
end

function Widget:Update(dt)
	-- on update que si le widget n'est pas gelé
	-- print("updating widget")
	-- UpdateOldState(self)
	if self.show then
		self:HasFocus()
	-- UpdateState(self)
	end
end

function Widget:Draw()
	-- on ne dessine que si le widget est visible
	if self.show then
		-- print("draw widget",self.GetX(), self:GetY())
		PrintDebug(self)
		if self.type ~= "label" then
			love.graphics.draw(self.drawable:getImage(), self.quads[self.state], self:GetX(), self:GetY(),
							   self.drawable:getAngle(), self.drawable:getScaleX(), self.drawable:getScaleY(),
							   self.center.x, self.center.y)
		end
		if debug then
			love.graphics.setColor(1,0,0,0.8)
			local x, y = self:GetX(), self:GetY()
			love.graphics.rectangle("line", self.bound.x, self.bound.y, self.bound.w, self.bound.h)
			love.graphics.setColor(1,0,0,0.2)
			love.graphics.rectangle("fill", self.bound.x, self.bound.y, self.bound.w, self.bound.h)
			love.graphics.setColor(0,1,1,1)
			love.graphics.line(x - 20, y, x + 20, y)
			love.graphics.line(x, y - 20, x, y + 20)
			love.graphics.setColor(1,1,1,1)
		end
	end
end

return Widget