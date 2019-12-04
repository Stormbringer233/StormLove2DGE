local Animation = {}
local Animation_MT = {__index = Animation}
local Timer = require("Libs.timer")

local function BuildQuads(self, pFrameOrder, pImgW, pImgH, pFrameW, pFrameH)
	-- Build the animation with quads
	-- print("BuildQuad - ", pFrameOrder, pImgW, pImgH, pFrameW, pFrameH)
	local q = nil
	for id, fr in pairs(pFrameOrder) do
		q = love.graphics.newQuad((fr-1) * pFrameW, 0, pFrameW, pFrameH, pImgW, pImgH)
		table.insert(self.quads, q)
	end
end

local function EndTimer(self)
	-- print("timer finish")
	if self.loop then
		self.currentFrame = 1
	end
end

local function StepTimerEnded(self)
	if self.currentFrame < #self.frameOrder then
		self.currentFrame = self.currentFrame + 1
	else
		self.currentFrame = 1
	end
end

-- ******************************** PUBLIC **********************************
function Animation.new(pFrameOrder, pFrameRate, pLoop, pImgW, pImgH,
			pFrameW, pFrameH, pFlipV, pFlipH)
	local animation = {}
	animation.quads = {}
	animation.currentQuad = nil
	animation.frameOrder = pFrameOrder or {} -- must be a table
	animation.loop = pLoop or false
	local fr = pFrameRate or 0.2
	if animation.loop == true then
		animation.timer = Timer.new(-1, function() EndTimer(animation) end,
								fr, function() StepTimerEnded(animation) end)
	else
		animation.timer = Timer.new(fr, function() EndTimer(animation) end)
	end
	animation.currentFrame = 1
	animation.quadDim = {}
	animation.quadDim.w = pFrameW
	animation.quadDim.h = pFrameH
	animation.flipV = 1
	if pFlipV == true then animation.flipV = -1 end
	animation.flipH = 1
	if pFlipH == truen then animation.flipH = -1 end
	BuildQuads(animation,  pFrameOrder, pImgW, pImgH, pFrameW, pFrameH)
	animation.currentQuad = animation.quads[animation.currentFrame]

	return setmetatable(animation, Animation_MT)
end

function Animation:QuadCenter()
	return self.quadDim.w / 2, self.quadDim.h / 2
end

function Animation:GetQuad()
	return self.currentQuad
end

function Animation:FlipV()
	return self.flipV
end

function Animation:FlipH()
	return self.flipH
end

function Animation:Update(dt)
	self.timer:Update(dt)
	self.currentQuad = self.quads[self.currentFrame]
end

return Animation