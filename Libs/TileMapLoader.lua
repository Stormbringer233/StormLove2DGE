TileMapLoader = {}
TileMapLoader_MT = {__index = TileMapLoader}
local HitBoxCls = require("Libs.Hitbox")

-- ************************* PRIVATE FUNCTIONS **************************
-- Give easy acces to main fonctionnality of the map
local function BuildTilesetList(self)
	-- scan and inform the tilesetList
	local tilesets = {}

	return tileSets
end

local function BuildLayersList(self)
	-- scan and inform the layer list
	local layers = {}

	return layers
end

local function BuildHitboxList(self)
	-- ATTENTION : layer name is hardcode in the function. So, make
	-- sure the graphist name the layers correctly
	local hitboxes = {}
	for k, layer in ipairs(self.layers) do
		if layer.name == "collisions" then -- Dangerous !
			for k, obj in ipairs(layer.objects) do
				local hb = HitBoxCls.new(obj.x * Gscale + self.offsetX,
										 obj.y * Gscale + self.offsetY,
										 obj.width * Gscale,
										 obj.height * Gscale,
										 "topleft"
										)
				table.insert(hitboxes, hb)
			end
		end
	end
	return hitboxes
end

local function BuildTriggerList(self)
	-- ATTENTION : layer name is hardcode in the function. So, make
	-- sure the graphist name the layers correctly
	local triggers = {}
	for k, layer in ipairs(self.layers) do
		if layer.name == "triggers" then -- dangerous
			for k, obj in ipairs(layer.objects) do
				local hb = HitBoxCls.new(obj.x * Gscale + self.offsetX,
										 obj.y * Gscale + self.offsetY,
										 obj.width * Gscale,
										 obj.height * Gscale,
										 "topleft"
										 )
				triggers[obj.name] = hb
			end
		end
	end
	return triggers
end

local function ControlsQuads(quads)
	for k, quaq in pairs(quads) do
		local q = quads[k]
		local x, y, w, h = q:getViewport()
		print("quad["..k.."] = ",x, y, w, h)
	end
end

local function BuildQuadList(self)
	-- Build the quads list of the tileset and build a table like
	-- quads[id qud N°] = quad.new()
	local quads = {}
	local x = 0
	local y = 0
	local tw = self.tilesets[1].tilewidth
	local th = self.tilesets[1].tileheight
	local imgw = self.tilesets[1].imagewidth
	local imgh = self.tilesets[1].imageheight
	local id = 1
	local lines = imgh / th - 1
	local cols = imgw / tw - 1
	-- print("lines, cols =",lines, cols)
	local id = 1
	local currentCol = 1
	for line = 0, lines do
		for col = 0, cols do
			local q = love.graphics.newQuad(col * tw, line * th, tw, th, imgw, imgh)
			quads[id] = q
			id = id + 1
		end
	end
	return quads
end

local function DrawDebug(self)
	for k, hb in ipairs(self.hitboxList) do
		love.graphics.rectangle("line", hb.x, hb.y, hb.w, hb.h)
	end
	for k, tr in pairs(self.triggerList) do
		local t = self.triggerList[k]
		love.graphics.rectangle("line", t.x, t.y, t.w, t.h)
	end
	-- love.graphics.line(self.offsetX, 0, self.offsetX, SCREEN_HEIGHT)
	-- love.graphics.line(0, self.offsetY, SCREEN_WIDTH, self.offsetY)
end

-- ************************** PUBLIC FUNCTIONS *****************************

function TileMapLoader.load(pTileMapName, pOffsetX, pOffsetY)
	local tilemap = require("levels."..pTileMapName)
	tilemap.wide = tilemap.width * tilemap.height
	tilemap.pixelWidth = tilemap.width * tilemap.tilewidth
	tilemap.pixelHeight = tilemap.height * tilemap.tileheight
	tilemap.offsetX = 0
	tilemap.offsetY = 0
	if type(pOffsetX) == "string" then
		pOffsetX = string.upper(pOffsetX)
		if pOffsetX == "CENTER" then
			-- centralise map in the X axis
			local mapW = tilemap.width * tilemap.tilewidth * Gscale
			pOffsetX = (SCREEN_WIDTH - mapW) / 2
		end
	elseif type(pOffsetX) == "number" then
		pOffsetX = math.abs(pOffsetX) * Gscale
	else
		pOffsetX = 0
	end
	if type(pOffsetY) == "string" then
		pOffsetY = string.upper(pOffsetY)
		if pOffsetY == "CENTER" then
			-- centralise map in the Y axis
			local mapH = tilemap.height * tilemap.tileheight * Gscale
			pOffsetY = (SCREEN_HEIGHT - mapH) / 2
		end
	elseif type(pOffsetY) == "number" then
		pOffsetY = math.abs(pOffsetY) * Gscale
	else
		pOffsetY = 0
	end
	tilemap.offsetX = pOffsetX or 0
	tilemap.offsetY = pOffsetY or 0
	print("offsetX, offsetY :", pOffsetX, pOffsetY)
	tilemap.tileset = ressources:LoadImage(tilemap.tilesets[1].name)

	tilemap.hitboxList = BuildHitboxList(tilemap)
	tilemap.triggerList = BuildTriggerList(tilemap)

	tilemap.layerList = BuildLayersList(tilemap)
	tilemap.tilesetList = BuildTilesetList(tilemap)
	tilemap.quadList = BuildQuadList(tilemap)
	-- ControlsQuads(tilemap.quadList)

	return setmetatable(tilemap, TileMapLoader_MT)
end

function TileMapLoader:GetMapPixelDimensions()
	return self.pixelWidth, self.pixelHeight
end

function TileMapLoader:GetCollideBoxes()
	return self.hitboxList
end

function TileMapLoader:Update(dt)
	-- For updating the tilemap with animated tiles

end

function TileMapLoader:Draw()
	for idPos = 1, self.wide do
		local tileGroundID = self.layers[1].data[idPos]
		local tileWallID = self.layers[2].data[idPos]
			local x = (math.floor((idPos - 1) % self.width)) * self.tilewidth * Gscale + self.offsetX
			local y = (math.floor((idPos - 1) / self.width)) * self.tileheight * Gscale + self.offsetY
		if tileGroundID ~= 0 then
			love.graphics.draw(self.tileset, self.quadList[tileGroundID],
								x, y, 0, Gscale, Gscale)
			-- print("tile "..idPos.." ID["..tileGroundID.."] x, y", x, y)
		end
		if tileWallID ~= 0 then
			love.graphics.draw(self.tileset, self.quadList[tileWallID],
								x, y, 0, Gscale, Gscale)
			
		end
	end
	if Gdebug then
		DrawDebug(self)
	end
	
end


return TileMapLoader