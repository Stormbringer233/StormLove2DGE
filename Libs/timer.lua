local Timer = {}
local Timer_mt = { __index = Timer }

local function Flush(self)
	self.currentTime = 0
end

local function FinishTimer(self)
	-- print("timer ended - calling callback function")
	-- print("FinishFunction = ", self.FinishFunction)
	if self.FinishFunction ~= nil then
		self.paused = true  -- stop timer process
		self.FinishFunction()
	end
end

local function AddMicroTime(self, dt)
	self.currentStepTime = self.currentStepTime + dt
	if self.StepFunction ~= nil and self.currentStepTime >= self.stepTime then
		self.currentStepTime = 0
		self.StepFunction()
	end
end

function Timer.new(pMaxTime, pFinishFunction, pStepTime, pStepFunction)
	-- For memory : callback function syntax for customer
	-- function() callback(parameters) end
	-- or : function() class.callback(parameters) end
	local timer = {	}
	timer.currentTime = 0
	timer.maxTime = pMaxTime or 0
	if pStepTime == nil and pMaxTime < 0 then
		timer.stepTime = 1
	else
		timer.stepTime = pStepTime or 0
	end
	timer.initTimer = pMaxTime or 0
	timer.currentStepTime = 0
	timer.savedTime = 0
	timer.paused = false
	timer.ready = false -- if true, then time is finish
	if type(pFinishFunction) == "function" then
		timer.FinishFunction = pFinishFunction
	else
		timer.FinishFunction = nil -- must generate an error
	end
	-- step function event that indicate the step time is reach
	if type(pStepFunction) == "function" then
		timer.StepFunction = pStepFunction
	else
		timer.StepFunction = nil -- must generate an error
	end
	return setmetatable (timer, Timer_mt)
end

function Timer:Reset()
	Flush(self)
	self.maxTime = self.initTimer
end

function Timer:Push()
	-- Save current state of timer
	self.savedTime = self.maxTime
end

function Timer:pop()
	self.maxTime = self.savedTime
	self.savedTime = 0
end

-- function Timer:TimeFinish()
-- 	return self.ready
-- end

function Timer:Pause()
	self.paused = true
end

function Timer.Resume()
	self.paused = false
end

function Timer:Update(dt)
	if not self.paused then
		-- self.ready = false
		if self.maxTime == -1 then
			-- it's a constant timer with a stepTime count
			AddMicroTime(self, dt)
		else
			if self.currentTime >= self.maxTime then
				-- self.ready = true
				Flush(self)
				FinishTimer(self)
			else
				self.currentTime = self.currentTime + dt
				AddMicroTime(self, dt)
			end
		end
	end
end

return Timer