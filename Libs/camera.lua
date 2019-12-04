local Camera = {}
local Camera_mt = {__index = Camera}


function math.clamp(low, n, high) return math.min(math.max(low, n), high) end
function math.clamp(low, n, high) return math.min(math.max(low, n), high) end

local function UpdateVisibleArea(cam)
   cam.visibleArea.x0 = cam.x
   cam.visibleArea.y0 = cam.y
   cam.visibleArea.x1 = cam.x + (cam.width / cam.scale)
   cam.visibleArea.y1 = cam.y + (cam.height / cam.scale)
end

local function UpdateMapVisibleArea(self)
   self.visibleArea.colX0 = math.floor(self.visibleArea.x0 / Inits.tileWidth) -- colonnes visibles (x)
   self.visibleArea.lineY0 = math.floor(self.visibleArea.y0 / Inits.tileWidth) -- lignes visibles (y)
   self.visibleArea.colX1 = math.floor(self.visibleArea.x1 / Inits.tileWidth) + 1 -- +1 pour couvrir une tuile supplémentaire au cas ou
   self.visibleArea.lineY1 = math.floor(self.visibleArea.y1 / Inits.tileWidth) + 1 -- la camera est à cheval sur une tuile
end

local function PrintDebug(self)
   love.graphics.print("camera x, y, width, height : "..string.format("%d",self.x)..", "..string.format("%d",self.y)..", "..self.width..", "..self.height, 10,380)
   love.graphics.print("offestX, offsetY : "..self.offsetX..", "..self.offsetY, 10,400)
   love.graphics.print("bounding Area : "..self.bound.x0..", "..self.bound.y0..", "..self.bound.x1..", "..self.bound.y1, 10,420)
   love.graphics.print("camera scale : "..string.format("%.2f",self.scale), 10,440)
   love.graphics.print("camera world dimensions : "..self.worldWidth..", "..self.worldHeight, 10,460)
end

local function normalize(self, rx, ry)
   local ratioX = rx / (self.width - self.center.x)
   local ratioY = ry / (self.height - self.center.y)
   return ratioX, ratioY
end

local function centerize(camera)
   -- calcule le centre de la camera en fonction des coordonnées de la camera
   -- càd que le centre est celui de l'espace de la camera
   camera.center.x = camera.width / 2
   camera.center.y = camera.height / 2
   --print("center of camera :", camera.center.x, camera.center.y)
end

local function defineMinScale(self)
   if self.worldWidth ~= nil and self.worldHeight ~= nil then
      local widthRatio = self.width / self.worldWidth
      local heightRatio = self.height / self.worldHeight
      if widthRatio >= heightRatio then
         self.minScale = widthRatio
      else
         self.minScale = heightRatio
      end
   else
      self.minScale = 1
   end
   -- recontrole que l'echelle mini est au moins egale au réglage défini
   local minScale = math.max(self.minScale, Inits.camera.minScale)
   self.minScale = minScale
   self.scale = 1
end

local function UpdateVelocity(self, rx, ry)
   -- Met à jour la vitesse de défilement de la caméra / position de la souris dans la fenêtre
   local baseX, baseY = 0, 0
   local delta = 1 - self.scrollRatioLimit
   -- On ne calcule le % vitesse à appliquer que si on est dans la zone de limite de scroll
   if math.abs(rx) >= self.scrollRatioLimit then
      if rx > 0 then
         baseX = (rx - self.scrollRatioLimit) / delta
      elseif rx < 0 then
         baseX = (rx + self.scrollRatioLimit) / delta 
      end
   end
   if math.abs(ry) >= self.scrollRatioLimit then
      if ry > 0 then
         baseY = (ry - self.scrollRatioLimit) / delta
      elseif ry < 0 then
         baseY = (ry + self.scrollRatioLimit) / delta 
      end
   end

   -- calcule la vélocité en fonction de l'echelle en cours pour garder la même vitesse de défilement quelque soit le scale
   local vx = math.clamp(-self.maxVelocity, baseX*self.maxVelocity, self.maxVelocity) / self.scale
   local vy = math.clamp(-self.maxVelocity, baseY*self.maxVelocity, self.maxVelocity) / self.scale
   -- SetVelocity(self, vx, vy)
   return vx, vy
end

local function ApplyTransform(self)
   love.graphics.translate(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
   love.graphics.rotate(math.rad(-self.angle))
   love.graphics.scale(self.scale)
   love.graphics.translate(-self.x, -self.y)
end

-- *****************************************************************************
-- *************** CONSTRUCTEUR CAMERA *****************************************
-- *****************************************************************************
function Camera.new( pX, pY, pTarget)

   local camera = {}
   camera.target = pTarget or nil -- cible un sprite (player)
   camera.x = pX or 0
   camera.y = pY or 0
   camera.width = SCREEN_WIDTH
   camera.height = SCREEN_HEIGHT
   camera.worldWidth = SCREEN_WIDTH
   camera.worldHeight = SCREEN_HEIGHT
   camera.scale = 1
   camera.minScale = Inits.camera.MinScale
   camera.maxScale = Inits.camera.MaxScale
   camera.angle = 0
   camera.offsetX = 0
   camera.offsetY = 0
   camera.center = {}
   camera.center.x = (camera.x + camera.width) / 2
   camera.center.y = (camera.y + camera.height) / 2

   -- fenetre d'affichage de la camera
   camera.bound = {}
   camera.bound.x0 = camera.x -- left side
   camera.bound.y0 = camera.y -- top side
   camera.bound.x1 = camera.x + camera.width --right side
   camera.bound.y1 = camera.y + camera.height -- bottom side

   -- zone visible de l'affichage de la camera
   camera.visibleArea = {}
   camera.visibleArea.x0 = camera.x
   camera.visibleArea.y0 = camera.y
   camera.visibleArea.x1 = (camera.x + camera.width) / camera.scale
   camera.visibleArea.y1 = (camera.y + camera.height) / camera.scale
   -- s
   camera.visibleArea.colX0 = 0
   camera.visibleArea.lineX0 = 0
   camera.visibleArea.colX01 = 0
   camera.visibleArea.lineX1 = 0

   camera.velocity = {}
   camera.velocity.x = 0
   camera.velocity.y = 0
   camera.maxVelocity = Inits.camera.speed
   camera.scrollRatioLimit = Inits.camera.scrollRatioLimit -- ratio de la position de la souris / bord de la camera qui déclenche le scroll
   camera.border = true
   camera.scroll = true -- permet à la caméra de scroller
   camera.drawables = {} -- stocke tous les éléments affichable par la camera (exemple : layers)
   camera.hasFocus = false
   camera.show = true

   return setmetatable(camera, Camera_mt)
end

function Camera:AddDrawable(pDrawable)
   -- Ajoute des éléments qui devront être dessinés en relation avec la camera (Type layer)
   table.insert(self.drawables, pDrawable)
end

function Camera:SetWorldDimensions(pWidth, pHeight)
   -- pWidth et pHeight sont ici donnés en valeur tuile. Cas d'un gameplay basé sur des tuiles
   --print ("dims :", pWidth, pHeight)
   self.worldWidth = pWidth * Inits.tileWidth
   self.worldHeight = pHeight * Inits.tileWidth
   defineMinScale(self)
   --print("world limits set to ",self.worldWidth, self.worldHeight)
end

function Camera:SetPixelWorldDimension(pWidth, pHeight)
   -- Redimensionne le monde avec des dimensions en pixel au lieu de dimensions en tuiles
   self.worldWidth = pWidth
   self.worldHeight = pHeight
   defineMinScale(self)
end

function Camera:SetCenter(pCenterX, pCenterY)
   self.center.x = pCenterX
   self.center.y = pCenterY
end


function Camera:SetWindow(x0, y0, pWidth, pHeight)
   -- Définie le rectangle de visibilité de la caméra
    -- recalcule la taille de la camera
   self.width = pWidth
   self.height = pHeight

   self.bound.x0 = x0 -- left side
   self.bound.y0 = y0 -- top side
   self.bound.x1 = x0 + pWidth -- right side
   self.bound.y1 = y0 + pHeight  -- bottom side
  
   centerize(self)
   defineMinScale(self)
   --print("bound update :", self.bound.x0, self.bound.y0, self.bound.x1, self.bound.y1)
end

function Camera:GetBoundingBox()
   return self.bound.x0, self.bound.y0, self.bound.x1, self.bound.y1
end

function Camera:HasFocus()
   mx, my = mouse:GetPosition()
   if mx >= self.bound.x0 and mx <= self.bound.x1 and my >= self.bound.y0 and my <= self.bound.y1 then
      self.hasFocus = true
   else
      self.hasFocus = false
   end 
   return self.hasFocus
end

function Camera:Show()
   self.show = true
end

function Camera:Hide()
   self.show = false
end

function Camera:GetVisibleArea()
   return self.visibleArea
end

function Camera:SetScrollLimit(pRatio)
   if pRatio > 0 and pRatio <= 1 then
      self.scrollRatioLimit = pRatio or 0.8 -- 0.8 est la valeur par defaut
   end
end

function Camera:SetScrollSpeed(pSpeed)
   if pSpeed > 0 and pSpeed < 10 then
      self.maxVelocity = pSpeed or 3 -- 3 est la vitesse max par defaut
   end
end

local function SetVelocity(self, pVx, pVy)
   self.velocity.x = pVx
   self.velocity.y = pVy
end

function Camera:GetVelocity()
   return self.velocity.x, self.velocity.y
end

function Camera:GetWindowCenter()

   local globalCenterX = self.center.x + self.bound.x0
   local globalCenterY = self.center.y + self.bound.y0
   return globalCenterX, globalCenterY
end

function Camera:MouseWorldPosition(mx, my)
   -- calcule la position de la souris dans l'espace monde en coordonnée pixel
   -- recoit les donnée depuis l'objet mouse. Permet à mouse de donner les coordonées
   -- du monde à l'ensemble des acteurs

   if (mx >= self.bound.x0 and mx <= self.bound.x0 + self.width and my >= self.bound.y0 and my <= self.bound.y0 + self.height) then
      -- retourne les coordonnées monde en x, y
      return (mx - self.bound.x0) / self.scale + self.x,
            (my - self.bound.y0) / self.scale + self.y
   end
   return 0,0
end

function Camera:GetWorldTilePosition(mx, my)
   -- calcule et retourne les coordonnées de la tuile sous le curseur de souris dans le monde
   local wx, wy = self:MouseWorldPosition(mx, my)
   return math.floor((wx / Inits.tileWidth)+1), math.floor((wy / Inits.tileWidth)+1)
end

function Camera:GetMouseWindowPosition(mx, my)
   -- calcule la position de la souris dans l'espace de la fenetre de la camera
   winX = mx - self.bound.x0
   winY = my - self.bound.y0
   return winX, winY
end

function Camera:MouseRelativePosition(mx, my)
   -- calcule la position de la souris / au centre de la fenetre de scroll
   local globalCenterX, globalCenterY = self:GetWindowCenter()
   -- local globalCenterX = self.center.x + self.bound.x0
   -- local globalCenterY = self.center.y + self.bound.y0
   --print("global center :", globalCenterX, globalCenterY)
   -- calcule la position du curseur de souris / centre de la fenetre de camera
   local relativeX = mx - globalCenterX
   local relativeY = my - globalCenterY
   local ratioX, ratioY = normalize(self, relativeX, relativeY)
   return ratioX, ratioY
end

function Camera:SetMaxVelocity(newMaxVelocity)
   if newMaxVelocity>=1 then
      self.maxVelocity = newMaxVelocity
   end
end

function Camera:GetScale()
   return self.scale
end

function Camera:ResetScale()
   self.scale = 1
end

function Camera:SetMinScale(newScale)
   if newScale >= self.minScale then
      self.scale = newScale

      self.minScale = newScale
   end
end

function Camera:Scaling(incScale, dt)
   --print("incscale :", incScale, self.scale)
   if incScale ~= 0 then
      self.scale = math.clamp(self.minScale, self.scale + incScale * dt, self.maxScale)
   end
end

function Camera:Focus(x,y)
   return (x > self.bound.x0 and x < self.bound.x1 and y > self.bound.y0 and y < self.bound.y1)
end

function Camera:SetAngle(angle)
   -- angle en degre
   self.angle = angle
end

function Camera:Rotate(incAngle)
   self.angle = self.angle + incAngle
end

function Camera:Reset()
   self.x = 0
   self.y = 0
   self.scale = 1
   self.rotation = 0
   self:set()
   self:unset()
end

function Camera:Move(dt)
   -- scroll autorisé
   if self.scroll then
      local rx, ry = self:MouseRelativePosition(mouse:GetPosition())
      -- on bouge si le curseur de souris et dans la zone de déclenchement du scroll ET que
      -- le curseur de souris est dans la fenetre
      if (math.abs(rx) >= self.scrollRatioLimit or math.abs(ry) >= self.scrollRatioLimit) and 
         (math.abs(rx) <= 1 and math.abs(ry) <= 1) then
         local vx, vy = UpdateVelocity(self, rx, ry)
         SetVelocity(self, vx, vy)
      else
         -- sinon, on ne scroll pas
         SetVelocity(self, 0,0)
      end
      self.x = self.x + self.velocity.x
      self.y = self.y + self.velocity.y
   end
end

function Camera:GetMapVisibleArea()
   -- Calcule les coordonées en ligne et colonne des tuiles visible / fenetre d'affichage
   -- de la camera
   
   return self.visibleArea.colX0, self.visibleArea.lineY0, self.visibleArea.colX1, self.visibleArea.lineY1
end

function Camera:Update(dt)
   if self.show then
      for _, drawable in ipairs(self.drawables) do
         drawable:Update(dt)
      end;
      self:Move()
      
      -- calcule le décalage d'affichage / fenetre d'affichage de la camera
      -- utile pour dessiner correctement les map / fenetre d'affichage
      self.offsetX = math.floor(self.bound.x0 / self.scale)
      self.offsetY = math.floor(self.bound.y0 / self.scale)

      -- calcule des limites d'affichage des tuiles des maps
     UpdateMapVisibleArea(self)

     -- calcul les limites du monde
      if self.x < 0 then
         self.x = 0
      end
      if self.y < 0 then
         self.y = 0
      end
      if self.x > self.worldWidth - (self.width / self.scale) then
         self.x = self.worldWidth - (self.width / self.scale)
      end
      if self.y > self.worldHeight - (self.height / self.scale) then
         self.y = self.worldHeight - (self.height / self.scale)
      end
      UpdateVisibleArea(self)
   end
end

function Camera:Set()
   -- dessine un rectangle de visualisation de la fenetre d'affichage
   -- TODO : faire en sorte que le scale soit centré sur la camera
   love.graphics.push()

   if self.border then
      love.graphics.setColor(1,0,0)
      love.graphics.setLineWidth(2)
      love.graphics.rectangle("line", self.bound.x0-2, self.bound.y0-2, self.width+3, self.height+3)
      --love.graphics.setColor(1,1,1)
   end
   -- defini la fenetre de dessin de la camera
   love.graphics.setScissor(self.bound.x0, self.bound.y0, self.width, self.height)
   -- Set the transformation of the camera (translate, rotate and scale)
   ApplyTransform(self)

end

function Camera:UnSet()
   love.graphics.setColor(1,1,1)
   love.graphics.pop()
   love.graphics.setScissor()
end

function Camera:Draw()
   if self.show then
      self:Set()
      for _, drawable in ipairs(self.drawables) do
         drawable:Draw(self)
      end
      self:UnSet()
      if Gdebug then
         PrintDebug(self)
      end
   end
end

return Camera
