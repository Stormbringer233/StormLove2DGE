-- frame est un conteneur de widget pur, il ne fait rien en soit, sinon collectionner
-- les widgets que l'on place dedans et détecter des collisions

-- M. Le Thiec
-- 04/06/2018

local Datas = require("Libs.Sprite")
local Frame = {}
local Frame_mt = { __index = Frame }

local function UpdateWidgetPosition(self, pDX, pDY)
	-- print("UpdateWidgetPosition(self, pDX, pDY)", pDX, pDY)
	for _, item in pairs(self.widgetList) do
		item:Move(pDX, pDY)
	end
end


function Frame.new(pX, pY, pWidth, pHeight, pPadTop, pPadRight, pPadBottom, pPadLeft, pSpaceH, pSpaceV)
	-- pDarawable est une image pour le fond du canvas
	-- si pas de drawable, on remplace par un rectangle
	-- print("Frame.new() - received :", pX, pY, pWidth, pHeight)
	local frame = {}
	-- le canvas sert ici de compsant de stockage pour les widgets
	frame.x = pX
	frame.y = pY
	frame.width = pWidth
	frame.height = pHeight
	-- facilité de controle de collisions
	frame.x1 = pX + pWidth
	frame.y1 = pY + pHeight
	
	frame.center = {}
	frame.center.x = pWidth / 2
	frame.center.y = pHeight / 2

	-- definit le padding. les dimensions laissées entre les objets et les bords de la frame
	frame.padding = {}
	frame.padding.top = pPadTop or 0
	frame.padding.right = pPadRight or 0
	frame.padding.bottom = pPadBottom or 0
	frame.padding.left = pPadLeft or 0

	-- spacing. espace mini entre les objets dans la frame
	frame.spacing = {}
	frame.spacing.horizontal = pSpaceH or 0
	frame.spacing.vertical = pSpaceV or 0

	frame.hasFocus = false
	frame.show = true

	frame.widgetList = {}
	return setmetatable(frame, Frame_mt)
end

-- function Frame:Attach(pDrawable)
-- 	-- attache un objet dessinable au frame
-- 	--if pDrawable:type() == "Image" then
-- 		self.drawable = pDrawable
-- 	--end
-- end

function Frame:AddWidget(pWidget)
	-- le widget à ajouter DOIT être de la forme 
	table.insert(self.widgetList, pWidget)
	-- recalcule la position du widget / position du conteneur
	-- print(" Frame:AddWidget ",pWidget.type, self.x, pWidget:GetX(), self.x + pWidget:GetX())
	pWidget:SetX(self.x + pWidget:GetX())
	pWidget:SetY(self.y + pWidget:GetY())
end

function Frame:SetPosition(pX, pY)
	-- positionne la frame et le contenu relativement à pX et pY
	-- calcule la position relative -> position demandée - position actuelle
	local dx = pX - self.x
	local dy = pY - self.y
	self.x = pX
	self.y = pY
	UpdateWidgetPosition(self, dx, dy)
end

function Frame:GetX()
	return self.x
end

function Frame:GetY()
	return self.y
end

function Frame:GetWidth()
	return self.width
end

function Frame:GetHeight()
	return self.height
end

function Frame:SetWidth(newWidth)
	self.width = newWidth
end

function Frame:SetHeight(newHeight)
	self.height = newHeight
end

function Frame:Show()
	self.show = true
end

function Frame:Hide()
	self.show = false
end

function Frame:IsShown()
	return self.show
end

function Frame:HasFocus()
	mx, my = mouse:GetPosition()
	if mx >= self.x and mx <= self.x + self.width and my >= self.y and my <= self.y + self.height then
		self.hasFocus = true
	else
		self.hasFocus = false
	end 
	return self.hasFocus
end

function Frame:Move(pDX, pDY)
	--deplace la frame de dx, dy
	self.x = self.x + pDX
	self.y = self.y + pDY
	UpdateWidgetPosition(self, pDX, pDY)
	-- print("Frame:Move(pDX, pDY)")
end

function Frame:IsWidgetHasFocus()
	-- vérifie si un widget a le focus
	local hasFocus = false
	for _, widget in ipairs(self.widgetList) do
		hasFocus = widget:HasFocus()
	end
	return hasFocus
end

function Frame:GetWidgetsStates()
	local states = {}
	for _, widget in ipairs(self.widgetList) do
		table.insert(states, widget:GetState())
	end
	return states
end

function Frame:Update(dt)	
	if self.show then
		self:HasFocus()
		for _, widget in ipairs(self.widgetList) do
			widget:Update(dt)
		end
	end
end

function Frame:Draw()
	if self.show then
		-- love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
		-- if self.hasFocus then
		-- 	love.graphics.print("frame has focus - frame position : "..self.x.." , "..self.y, 10,35)
		-- end
		-- dessine les widgets
		for _, widget in ipairs(self.widgetList) do
			widget:Draw()
		end
	end
end

return Frame