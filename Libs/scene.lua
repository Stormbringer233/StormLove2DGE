-- M. Le Thiec
-- le 18 février 2018
-- V 1.00
-- Object générique de création de scéne de jeu
-- une scène est un objet emportant les élements d'un niveau de jeu
-- Map Tiled
-- image de fond
-- objects de décord, gameplay
local Scene = {}
local Scene_mt = {__index = Scene}

function Scene.new()
	-- pBackground : table des différents décors avec leur position (0 = premier plan, 1 = 2nd plan, etc)
	-- pMap : reférence à une map type tiled
	local scene = {}

	return setmetatable(scene, Scene_mt)
end

local function reset(self)
	-- remet à zero toutes les données de la table scene
	self.decor = {}
	self.lenght = 0
	self.map = nil
	self.gameObjects = {}
	self.ennemiSpawn = nil
end

function clone(datas)
	return {unpack(datas)}
end

function Scene:init(pDatas)
	-- pDatas : table de données des infos pour la construction du niveau
	reset(self)
	local pBackground = pDatas[1] -- données concernant les images de fond
	local pLenght = pDatas[2]
	for id, img in ipairs(pBackground) do
		local backGrd = nil
		backGrd = love.graphics.newImage("images/"..img..".png")
		self.imageLenght = backGrd:getWidth()
		-- initialise le canvas à la taille de la fenetre de jeu
		local canvas = love.graphics.newCanvas(SCREEN_WIDTH, SCREEN_HEIGHT)

		self.decor[id] = {backGrd, canvas}
	end
	self.lenght = pLenght or self.decor[1][1]:getWidth()
	self.ennemiSpawn = clone(pDatas[3]) -- recoit la liste de tous les ennemis à créer

	self.map = pMap or nil
	self.gameObjects = {}

end

function Scene:getLenght()
	return self.lenght
end

function Scene:addGameObject(object)
	table.insert(self.gameObjects, object)
end

function Scene:createEnnemis(XCam)
	local ennemys = {}
	for i =  #self.ennemiSpawn, 1, -1 do
		local spawnPos = self.ennemiSpawn[i][1]
		local data = self.ennemiSpawn[i][2]
		--print(XCam, spawnPos)
		if XCam >= spawnPos then -- le spawn est effectif à position -> position + 10 pixels
			table.insert(ennemys, data)
			table.remove(self.ennemiSpawn, i)
		end 
	end
	return ennemys
end

function Scene:Update(camX, camY, dt)
	-- met à jour le fond
	for id = 1, #self.decor do
		-- chaque canvas est mis à jour
		self.decor[id][2]:renderTo(function()
			love.graphics.clear()
			local numImg = math.floor(self.lenght / self.imageLenght)
			for i = 1, numImg do
				love.graphics.draw(self.decor[id][1], ((i-1) * self.imageLenght)-camX, camY)
			end
		end)
	end
end


function Scene:Draw(id)
	love.graphics.draw(self.decor[id][2], 0, 0)
	if self.map then
		love.graphics.draw(self.map,0,0)
	end
	for i = 1, #self.gameObjects do
		local obj = self.gameObjects[i]
		love.graphics.draw(obj.image, obj.getX(), obj.getY())
	end
end

return Scene