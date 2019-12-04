function easeLinear(t, b, c, d)
  return c*t/d + b
end

function easeSinIn(t, b, c, d)
  return -c * math.cos(t/d * (math.pi/2)) + c + b
end

function easeSinOut(t, b, c, d)
   print("tween function sinOut",t, b, c, d)
  t = t / d
  return -c * t*(t-2) + b
end

function easeOutQuad (t, b, c, d)
   t = t / d
   return -c * t*(t-2) + b
end

function easeOutGelatine(t, b, c, d, a, f)
	-- a = amplitude
	-- f = frequence
	-- c = attenuation. + c est élevé, + l'attenuation est forte
	return a * math.exp(-c*t) * math.sin((2*3.141592 * t * f))
end

function easeInGelatineSin(t, b, c, d, a, f)
	-- c = attenuation
	-- b = decalage
	if c<=0 then c = 1 end
	return  a * math.exp(-c*t) * math.sin((2*3.141592 * t * f)) + b
end

function easeInGelatineCos(t, b, c, d, a, f)
	if c<=0 then c = 1 end
	return  a * math.exp(-c*t) * math.cos((2*3.141592 * t * f)) + b
end

function easeTest(t, b, c, d, a, f)
if c<=0 then c = 1 end
	return  a * math.sin(-c*t) * math.sin((2*3.141592 * t * f)) + b
end
