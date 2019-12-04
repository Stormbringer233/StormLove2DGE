local SceneManager = {}
local SceneManager_mt = {__index = SceneManager}


local function Contains(self, pSceneName, pScene)
	-- Check if the scene is already in table
	for scene in pairs(self.Scenes) do
		if scene == pSceneName or self.Scenes[scene] == pScene then
			return true
		end
	end
	return false
end

function SceneManager.new()
	local sceneManager = {}
	sceneManager.Scenes = {}
	sceneManager.CurrentScene = nil
	return setmetatable(sceneManager, SceneManager_mt)
end

function SceneManager:Add(pSceneName, pScene)
	-- Add a new scene to the scene manager
	-- The sceneName will be convert to upper case
	if not Contains(self, pSceneName, pScene) then
		self.Scenes[pSceneName:upper()] = pScene
		if (self.CurrentScene == nil) then
			self.CurrentScene = pScene
		end
	else
		print("Scene "..pSceneName.." is already register")
	end
end

function SceneManager:GetCurrentSceneName()
	-- Return the current active scene name
	for scene in pairs(self.Scenes) do
		if (self.CurrentScene == self.Scenes[scene]) then
			return scene
		end
	end
	return ""
end

function SceneManager:SwitchTo(pNewSceneName)
	-- Switch from current scene to another
	if (Contains(self, pNewSceneName:upper())) then
		self.CurrentScene = self.Scenes[pNewSceneName:upper()]
	end

end

function SceneManager:Keypressed(key)
	self.CurrentScene:Keypressed(key)
end

function SceneManager:Update(dt)
	self.CurrentScene:Update(dt)
end

function SceneManager:Draw()
	self.CurrentScene:Draw()
end

return SceneManager