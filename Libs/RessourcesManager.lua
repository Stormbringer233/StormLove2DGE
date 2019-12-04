local Ressources = {}
local Ressources_mt = { __index = Ressources}

local availableImagesExt = {".PNG", ".JPG"}
local availableSoundsExt = {".WAV", ".MP3"}
local availableFontsExt = {".TTF"}
local ressourceTypes = {}
ressourceTypes["SOUNDS"] = {"SOUNDS", "SOUND", "SON", "SONS"}
ressourceTypes["IMAGES"] = {"IMAGES", "IMAGE"}
ressourceTypes["FONTS"] = {"FONT", "FONTS"}

local function scanAllDirectories(self)
	-- scanne les répertoire de chaque ressource et charge le nom de tous les fichiers qui
	-- s'y trouvent
	-- purge les tables pour ne pas avoir de redondance
	self.images.files = {}
	self.sounds.files = {}
	self.fonts.files = {}

	local images_files = love.filesystem.getDirectoryItems(self.images.path)
	for _, file in pairs(images_files) do
		local fullName = file
	    file = string.upper(file)
	    local extPos = string.find(file, "%.")
	    file = string.sub(file, 0, extPos -1)
	    local ext = string.sub(fullName, extPos):upper()
	    for _, extension in ipairs(availableImagesExt) do
	    	-- on ajoute au dictionnaire que les types autorisés
	    	if extension == ext then
				self.images.files[file] = fullName
	    	end
	    end
	end

	local sounds_files = love.filesystem.getDirectoryItems(self.sounds.path)
	for _, file in pairs(sounds_files) do
		local fullName = file
	    file = string.upper(file)
	    local extPos = string.find(file, "%.")
	    file = string.sub(file, 0, extPos -1)
	    local ext = string.sub(fullName, extPos):upper()
	    for _, extension in ipairs(availableSoundsExt) do
	    	-- on ajoute au dictionnaire que les types autorisés
	    	if extension == ext then
				self.sounds.files[file] = fullName
	    	end
	    end
	end
	local fonts_files = love.filesystem.getDirectoryItems(self.fonts.path)
	for _, file in pairs(fonts_files) do
		local fullName = file
	    file = string.upper(file)
	    local extPos = string.find(file, "%.")
	    file = string.sub(file, 0, extPos -1)
	    local ext = string.sub(fullName, extPos):upper()
	    for _, extension in ipairs(availableFontsExt) do
	    	-- on ajoute au dictionnaire que les types autorisés
	    	if extension == ext then
				self.fonts.files[file] = fullName
	    	end
	    end
	end
	return self
end

local function checkTypes(pType)
	-- vérifie si le type fourni fait parti des types possibles
	-- retourne le type "officiel" si pType est dans les "acceptables"
	for keyType, types in pairs(ressourceTypes) do
		for _, allowedType in ipairs(types) do
			if pType == allowedType then
				return keyType
			end
		end 
	end
	return nil
end

local function printRessources(self)
	print ("printing informations ...")
	for _, resType in pairs(self) do
		for k, files in pairs(resType) do
			print(k, files)
			for _, val in ipairs(files) do
				print (k, val)
			end
		end
	end
end

function Ressources.new()

	local ressource = {}
	-- Chaque table est sous la forme d'un dictionnaire de type [ressourceName] = ressource (image, sound, font)
	ressource.fonts = {}
	ressource.fonts.path = "fonts/"
	ressource.fonts.files = {}
	ressource.images = {}
	ressource.images.path = "images/"
	ressource.images.files = {}
	ressource.images.width = 0
	ressource.images.height = 0
	ressource.sounds = {}
	ressource.sounds.path = "sounds/"
	ressource.sounds.files = {}

	ressource = scanAllDirectories(ressource)
	--printRessources(ressource)

	return setmetatable(ressource, Ressources_mt)
end


function Ressources:changePath(ressourceType, newPath)
	print("change path ...")
end

local function isExist(self, pRessource, pType, pSize)
	-- recherche dans le dictionnaire si la ressource existe
	-- pSize : pour le controle des fonts uniquement
	if pType == "IMAGES" then
		for keyName, ressourceName in pairs(self.images) do
			if keyName == pRessource then
				return self.images[pRessource]
			end
		end
	elseif pType == "SOUNDS" then
		for keyName, ressourceName in pairs(self.sounds) do
			if keyName == pRessource then
				return self.sounds[pRessource]
			end
		end
	elseif pType == "FONTS" then
		for keyName, ressourceName in pairs(self.fonts) do
			-- Pour avoir correspondance, il faut avoir la même font ET la même taille
			local font = ressourceName[1]
			local size = ressourceName[2]
			if keyName == pRessource  and psize == size then
				return font
			end
		end
	else
		return nil
	end
end

local function getFullName(self, pRessource, pType)
	-- recherche un nom de ressource dans la base des fichiers disponibles par type
	local fullName = ""
	if pType == "IMAGES" then
		for key, val in pairs(self.images.files) do
			if pRessource == key then
				fullName = val
				break
			end
		end
	elseif pType == "SOUNDS" then
		for key, val in pairs(self.sounds.files) do
			if pRessource == key then
				fullName = val
				break
			end
		end
	elseif pType == "FONTS" then
		for key, val in pairs(self.fonts.files) do
			if pRessource == key then
				fullName = val
				break
			end
		end
	else
		print("aucune correspondance trouvée pour ",pRessource)
	end
	return fullName
end


function Ressources:LoadImage(pRessourceName)
	-- charge une ressource image dans le dictionnaire et la renvoi à l'appelant.
	-- Si la ressource est déja existante dans le dictionnaire, renvoie la référence
	-- pRessourceName : string -> nom de la ressource à charger sans extension
	-- pType : string -> type de la ressource à charger entre "images", "sounds", "fonts"
	-- pSize : int -> n'est pris en compte que pour le chargement des fonts
	-- print("Ressource:LoadImage() received imageName :", pRessourceName)
	if (type(pRessourceName) == nil) then
		print("Aucun nom de fichier n'a été transmis à LoadImage ...")
		return nil
	end
	local tableType = "IMAGES"
	--local tableType = checkTypes(pType)
	local ressourceName = pRessourceName -- on garde une copie avec la syntaxe directe dans le répertoire
	pRessourceName = string.upper(pRessourceName) -- clé de dictionnaire
	
	local ressource = isExist(self, pRessourceName, tableType)
	-- la ressource existe, on la renvoie directement
	if ressource ~= nil then
		return ressource
	else
		-- la ressource n'existe pas dans le dictionnaire
		-- on l'ajoute.
		if tableType == "IMAGES" then
			-- recherche dans la base des fichiers existants
			local fullName = getFullName(self, pRessourceName, tableType)
			if fullName ~= "" then
				local fullpath = self.images.path..fullName
				local image = love.graphics.newImage(fullpath)
				self.images[pRessourceName] = image
				self.images.width = image:getWidth()
				self.images.height = image:getHeight()
				return image
			else
				print("Impossible de charger la ressource ["..ressourceName.."] . Elle ne semble pas être dans le répertoire défini")
			end
		end
	end
end

function Ressources:GetImageWidth(pImageName)
	local ressource = isExist(self, pImageName, "IMAGES")
	return ressource.width
end

function Ressources:GetImageHeight(pImageName)
	local ressource = isExist(self, pImageName, "IMAGES")
	return ressource.height
end

function Ressources:GetImageDims(pImageName)
	local ressource = isExist(self, pImageName, "IMAGES")
	return ressource.width, ressource.height
end

function Ressources:LoadSound(pRessourceName, pOption)
	-- idem que LoadImage, mais pour les sons
	-- pOption est soi "stream" soi "static"
	local option = ""
	if pOption == "static" or pOption == "stream" then
		option = pOption
	end

	local tableType = "SOUNDS"
	local ressourceName = pRessourceName -- on garde une copie avec la syntaxe directe dans le répertoire
	pRessourceName = string.upper(pRessourceName) -- clé de dictionnaire
	
	local ressource = isExist(self, pRessourceName, tableType)
	-- la ressource existe, on la renvoie directement
	if ressource ~= nil then
		return ressource
	else

		if tableType == "SOUNDS" then
			-- recherche dans la base des fichiers existants
			local fullName = getFullName(self, pRessourceName, tableType)
			if fullName ~= "" then
				local fullpath = self.sounds.path..fullName
				if option == "static" then
					local sound = love.audio.newSource(fullpath, option)
					self.sounds[pRessourceName] = sound
					return sound
				else
					-- si le sons est en streaming, on ne le stocke pas en mémoire
					return love.audio.newSource(fullpath, option)
				end
			else
				print("impossible de charger la ressource ["..ressourceName.."] . Elle ne semble pas être dans le répertoire défini")
			end
		end
	end
end

function Ressources:LoadFont(pRessourceName, pSize)
	local size = pSize or 14 -- 14 taille par defaut
	local tableType = "FONTS"
	local ressourceName = pRessourceName -- on garde une copie avec la syntaxe directe dans le répertoire
	pRessourceName = string.upper(pRessourceName) -- clé de dictionnaire
	
	local ressource = isExist(self, pRessourceName, tableType, pSize)
	-- la ressource existe, on la renvoie directement
	if ressource ~= nil then
		return ressource
	else

		if tableType == "FONTS" then
			-- recherche dans la base des fichiers existants
			local fullName = getFullName(self, pRessourceName, tableType)
			if fullName ~= "" then
				local fullpath = self.fonts.path..fullName
				local font = love.graphics.newFont(fullpath, size)
				self.fonts[pRessourceName] = {}
				table.insert(self.fonts[pRessourceName], font)
				table.insert(self.fonts[pRessourceName], pSize)
				return font
			else
				print("impossible de charger la ressource ["..pRessourceName.."] . Elle ne semble pas être dans le répertoire défini")
			end
		end
	end

end

function Ressources:Unload(pRessourceName, pType)
	-- Recherche une ressource dans le dictionnaire et si elle existe, la supprime
	pType = string.upper(pType)
	pRessourceName = string.upper(pRessourceName) -- clé de dictionnaire

end

return Ressources