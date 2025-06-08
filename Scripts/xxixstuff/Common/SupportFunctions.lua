function getCommonDelayMult() return l_getDelayMult() * 10 end

function getRandomSide() return math.random(1, l_getSides()) end

function getRandomSegment() return math.random(1, l_getSides()) end

function getRandomSegmentDir()
	local number = math.random(1, 2)
	return (number - 2 / number)
end

function getSign(value) 
	local result = 1
	if value < 0 then result = -1 end
	return result
end

-- multiplier for one side (minimum delay limit), tested with 40 thickness
function oneSideMinDelay()
	local mult = 1
		if l_getSides() == 3 then mult = 12.54
	elseif l_getSides() == 4 then mult = 9.54
	elseif l_getSides() == 5 then mult = 7.56
	elseif l_getSides() == 6 then mult = 6.06
	elseif l_getSides() == 7 then mult = 5.10
	elseif l_getSides() == 8 then mult = 4.56
	elseif l_getSides() == 9 then mult = 4.02
	elseif l_getSides() == 10 then mult = 3.6
	elseif l_getSides() >= 11 then mult = 3.06
	end
	return mult * 1.04 -- I dunno why, but this delay doesn't work properly without the multiplier now.
end

-- multiplier for half sides (minimum delay limit), tested with 40 thickness
-- invert spiral doesn't work on 60 sides more than 20s, excessive delay (also, too much delay for 100 sides)
function halfSidesMinDelay()
	local mult = 1
		if l_getSides() == 3 then mult = 12.6
	elseif l_getSides() >= 4 and l_getSides() <= 10 then mult = 19.1
	elseif l_getSides() >= 13 and l_getSides() <= 20 then mult = 19.6
	elseif l_getSides() >= 21 and l_getSides() <= 30 then mult = 20.6
	elseif l_getSides() >= 31 and l_getSides() <= 60 then mult = 21.6
	end
	return mult * 1.04 -- I dunno why, but this delay doesn't work properly without the multiplier now.
end

function shuffle(x)
	for i = #x, 2, -1 do
		local j = u_rndIntUpper(i)
		x[i], x[j] = x[j], x[i]
	end
end

function shuffle2D(x)
	for k = 1, #x do
		for i = #x[k], 2, -1 do
			local j = u_rndIntUpper(i)
			x[k][i], x[k][j] = x[k][j], x[k][i]
		end
	end
end

function theWorldIsEnding()
	a_setMusic("emptyness")
	e_kill()
end

function setStylePulse(value) s_setPulseMin(value) s_setPulseMax(value) end

function setStylePulseDiff(value, diff) 
	if diff >= 0 then s_setPulseMin(value) s_setPulseMax(value+diff)
	else s_setPulseMin(value+diff) s_setPulseMax(value) end
end

function setStylePulse3D(value) s_set3dPulseMin(value) s_set3dPulseMax(value) end

function setHue(value) s_setHueMin(value) s_setHueMax(value) end

function setRotation(value) l_setRotationSpeed(value) end

function getRoundedDifficulty() return math.ceil(u_getDifficultyMult() * 1000) / 1000 end

function getBpmPulses(difference, bpm, ratio)
    local x = (ratio + 1) * difference * bpm / 3600.0 / ratio
    return x * ratio, x
end

function message(text, duration)
	local duration = duration or 100
	e_messageAddImportantSilent(text, duration)
end

function time() return l_getLevelTime() end

function track(x) l_addTracked(x, x) end

function coreLevelSettings()
	l_setSwapEnabled(false)
	l_set3dRequired(true)
	a_syncMusicToDM(false)
	l_setRotationSpeedMax(999999)
end