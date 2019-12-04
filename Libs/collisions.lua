-- utilitaire de tests de collisions

function AABBbox(box1, box2)
	-- box1 et box2 doivent être des tables de la forme {posX, posY, width, height}
	local x1, y1, w1, h1 = unpack(box1)
	local x2, y2, w2, h2 = unpack(box2)
	if x1 + w1 < x2 or -- trop à gauche
		x1 > x2 + w2 or -- trop à droite
		y1 + h1 < y2 or -- trop au dessus
		y1 > y2 + h2 then -- trop en dessous

		return false

	end
	return true
end

function ContainsBox(box1, box2)
	-- check if box1 is under box2
	local x1, y1, w1, h1 = unpack(box1)
	local x2, y2, w2, h2 = unpack(box2)
	if x1 > X2 and
		y1 > y2 and
		x1 + w1 < x2 + w2 and
		y1 + h1 < y2 + h2 then

		return true
		
	end
	return false
end

function PointBox(x, y, box)
	-- détecte si un point est à l'intérieur de la boite
	local x1, y1, w1, h1 = unpack(box)
	if x <= x1 or 
		x >= x1 + w1 or 
		y <= y1 or 
		y >= y1 + h1 then
		return false
	end
	return true
end

function CircleBox(pX, pY, pCircle)
	-- test si un point est à l'intérieur d'un cercle
	-- pCircle est un objet de type cercle défini par un point de centre et un rayon
	local cx, cy, r = pCircle:GetProperties()
	local d2 = ((pX - cx) * (pX - cx)) + ((pY - cy) * (pY - cy))
	if d2 > (r * r) then
		return false
	end
	return true
end