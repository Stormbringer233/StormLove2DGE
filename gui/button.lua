-- local Widget = require("widget")

-- button.lua est une sorte de widget, il ne contient que les spécifiecités du bouton et ses comportements

-- M. Le Thiec
-- 04/06/2018

local Button = {}
local Button_mt = { __index = Button }

local function UpdateState(self)
	-- met à jour l'etat du bouton
		-- le widget est activé ou non
	-- On détecte 2 états // -> widget a le focus, widget activé
	-- print("UpdateState(self) - ",self.hasFocus, mouse.leftClick, mouse.oldLeftClick)
	-- on test le focus seulement si le widget n'est pas inactif
	local state = self.widget:GetState()
	local hasFocus = self.widget:HasFocus()

	if state ~= "freeze" then
		if hasFocus and mouse.leftClick == "released" and state == "normal" then
			-- cas de la prise de focus sur le widget
			state = "focus"
		elseif hasFocus and mouse.leftClick == "pressed" and state == "focus" then
			-- cas du 1er click de souris sur le widget
			state= "clicked"
		elseif hasFocus and mouse.leftClick == "pressed" and state == "deactivate" then
			-- cas ou la souris revient sur le widget après avoir quitter le focus et avec le click enfoncé
			state = "focus"
		elseif hasFocus == false and mouse.leftClick == "pressed" and mouse.oldLeftClick == "pressed" and state == "clicked" then
			-- cas ou le click est enfoncé, mais ou le focus vient d'être perdu
			state = "deactivate"
		elseif hasFocus and mouse.leftClick == "released" and mouse.oldLeftClick == "pressed" and state == "clicked" then
			-- VALIDATION de L'ACTION --
			state = "activate"
		elseif hasFocus == false and mouse.leftClick == "released" then
			-- retour à l'état de base
			state = "normal"
		end
	end
	self.widget:SetState(state)
end

local function OnClick(self)
	if self.widget:GetState()== "activate" then
		-- repositionne le state à "normal"*=
		self.widget:SetState("normal")
		self.callback()
	end
end

function Button.new(pMaster, pX, pY, pCallback, pButtonName)
	-- pButtonName = nom de la zone à dessiner dans la spriteSheet (GUI_Theme.lua)

	local button = {}
	button.widget = Widget.new(pMaster, pX, pY, "button", pButtonName)
	if type(pCallback) == "function" then
		button.callback = pCallback -- callback pour l'appel de la fonction lors d'un click - released
	else
		button.callback = nil -- génèrera une erreur
	end
	
	-- print("create new button", button, pMaster, pX, pY, pCallback, pButtonName)

	return setmetatable(button, Button_mt)
end

function Button:GetMaster()
	-- print("Button:GetMaster()", self.widget.master)
	return self.widget.master
end

function Button:GetState()
	return self.widget:GetState()
end

function Button:SetState(newState)
	self.widget:SetState(newState)
end

function Button:GetX()
	return self.widget:GetX()
end

function Button:GetY()
	return self.widget:GetY()
end

function Button:SetX(newX)
	-- print("new button X position :", newX)
	self.widget:SetX(newX)
end

function Button:SetY(newY)
	-- print("new button Y position :", newY)
	self.widget:SetY(newY)
end

function Button:Move(pDX, pDY)
	self.widget:Move(pDX, pDY)
end

function Button:HasFocus()
	return self.widget:HasFocus()
end

function Button:UpdatePosition(x, y)
	self:SetX(x)
	self:SetY(y)
end

function Button:Update(dt)
	-- print("Updating button")
	-- self.widget:Update(dt)
	UpdateState(self)
	OnClick(self)
end

function Button:Draw()
	self.widget:Draw()
end

return Button