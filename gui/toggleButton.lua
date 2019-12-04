-- local Widget = require("widget")

-- toggleButton_mt.lua est une sorte de widget, il ne contient que les spécifiecités du bouton et ses comportements

-- M. Le Thiec
-- 04/06/2018

local ToggleButton = {}
local ToggleButton_mt = { __index = ToggleButton }

local function UpdateState(self)
	-- met à jour l'etat du bouton
		-- le widget est activé ou non
	-- On détecte 2 états // -> widget a le focus, widget activé
	-- print("UpdateState(self) - ",self.hasFocus, mouse.leftClick, mouse.oldLeftClick)
	-- on test le focus seulement si le widget n'est pas inactif
	local state = self.widget:GetState()
	local oldState = self.widget:GetOldState()
	local hasFocus = self.widget:HasFocus()
	-- if state ~= oldState then
	-- 	print("entering toggleButton UpdateState | state : "..state.." | oldState : "..oldState)
	-- end
	if state ~= "freeze" then
		if hasFocus and mouse.leftClick == "released" and mouse.oldLeftClick == "pressed" then
			-- VALIDATION de L'ACTION  ON / OFF --
			if self.currentState == "normal" then
				state = "activate"
			elseif self.currentState == "activate" then
				state = "normal"
			end
			self.currentState = state
			self.callback()
		elseif hasFocus == false and mouse.leftClick == "released" then
			-- retour à l'état de base
			state = self.currentState or "normal"
		end
	end
	-- print("State is set to",state)
	self.widget:SetState(state)
end


function ToggleButton.new(pMaster, pX, pY, pCallback, pButtonName)
	-- pButtonName = nom de la zone à dessiner dans la spriteSheet (GUI_Theme.lua)

	local toggleButton = {}
	toggleButton.widget = Widget.new(pMaster, pX, pY, "toggleButton", pButtonName)
	if type(pCallback) == "function" then
		toggleButton.callback = pCallback -- callback pour l'appel de la fonction lors d'un click - released
	else
		toggleButton.callback = nil -- génèrera une erreur
	end
	toggleButton.currentState = "normal"
	
	-- print("create new toggleButton_mt", toggleButton_mt, pMaster, pX, pY, pCallback, pButtonName)

	return setmetatable(toggleButton, ToggleButton_mt)
end

function ToggleButton:GetMaster()
	-- print("ToggleButton:GetMaster()", self.widget.master)
	return self.widget.master
end

function ToggleButton:GetState()
	return self.widget:GetState()
end

function ToggleButton:SetState(newState)
	self.widget:SetState(newState)
	self.currentState = newState
end

function ToggleButton:GetX()
	return self.widget:GetX()
end

function ToggleButton:GetY()
	return self.widget:GetY()
end

function ToggleButton:SetX(newX)
	-- print("new toggleButton_mt X position :", newX)
	self.widget:SetX(newX)
end

function ToggleButton:SetY(newY)
	-- print("new toggleButton_mt Y position :", newY)
	self.widget:SetY(newY)
end

function ToggleButton:Move(pDX, pDY)
	self.widget:Move(pDX, pDY)
end

function ToggleButton:HasFocus()
	return self.widget:HasFocus()
end

function ToggleButton:UpdatePosition(x, y)
	self:SetX(x)
	self:SetY(y)
end

function ToggleButton:Update(dt)
	-- self.widget:Update(dt)
	UpdateState(self)
end

function ToggleButton:Draw()
	self.widget:Draw()
	-- love.graphics.print("currentState : "..self.currentState, 10,115)
end

return ToggleButton