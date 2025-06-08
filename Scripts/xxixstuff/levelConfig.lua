ALLOW_PRE_DELAY = 0
PATTERNS_ENABLED = true

u_execScript("xxixstuff/Common/SupportFunctions.lua")
u_execScript("xxixstuff/Common/BasicPatterns.lua")
u_execScript("xxixstuff/Common/StandartPatterns.lua")
u_execScript("xxixstuff/Common/StandartWrappers.lua")
u_execScript("xxixstuff/Common/AdditionalPatterns.lua")
u_execScript("xxixstuff/Common/AdditionalWrappers.lua")

function calcOneSideDelay() return 1 * getCommonDelayMult() * 1.1 end
function calcTwoSidesDelay() return 1.575 * getCommonDelayMult() * 1.1 end
function calcHalfSidesDelay() return 1.9 * getCommonDelayMult() * 1.1 end

function postDelay() t_wait(l_getSpeedMult() / 1.35) end
function preDelayFull() t_wait(halfSidesMinDelay() * l_getDelayMult() * ALLOW_PRE_DELAY) end
function preDelayX2() t_wait(calcTwoSidesDelay() * ALLOW_PRE_DELAY) end

--

function addPattern(key)
        if key == 0 then preDelayFull() oneOpenSideLLLL(calcOneSideDelay(), math.random(4, 5), THICKNESS)
    elseif key == 1 then preDelayFull() oneOpenSideLLRR(calcOneSideDelay(), math.random(2, 3) * 2 + 1, THICKNESS)
    elseif key == 2 then preDelayFull() oneOpenSideLRLR(calcOneSideDelay(), math.random(4, 5), THICKNESS) 
        
    elseif key == 11 then preDelayFull() oneOpenSideLLLLX2(calcTwoSidesDelay(), math.random(3, 4), THICKNESS)
    elseif key == 12 then preDelayFull() oneOpenSideLLRRX2(calcTwoSidesDelay(), math.random(2, 3) * 2 + 1, THICKNESS)
    elseif key == 13 then preDelayFull() oneOpenSideLRLRX2(calcTwoSidesDelay(), math.random(4, 5), THICKNESS)

    elseif key == 100 then preDelayFull() oneOpenSideInverse(calcHalfSidesDelay(), math.random(3, 5), THICKNESS)
    elseif key == 101 then preDelayFull() oneOpenSideRandomWithSamePos(1, math.random(4, 7), THICKNESS)
    elseif key == 102 then preDelayFull() oneOpenSideRandomWithoutSamePos(1, math.random(4, 7), THICKNESS)

    elseif key == 200 then preDelayX2() vortexLLLL(calcOneSideDelay(), math.random(3, 5), THICKNESS)
    elseif key == 201 then preDelayX2() vortexLLRR(calcOneSideDelay(), math.random(2, 3) * 2 + 1, THICKNESS)
    elseif key == 202 then preDelayX2() vortexLRLR(calcOneSideDelay(), math.random(4, 5), THICKNESS)

    elseif key == 300 then preDelayX2() singleTwoParallelWalls(3.03, math.random(2, 4), THICKNESS * 0.66)
    elseif key == 301 then preDelayFull() singleOneOpenSide(3.03, math.random(2, 4), THICKNESS * 0.66)
    elseif key == 302 then preDelayX2() singleVortex(3.03, math.random(2, 4), THICKNESS * 0.66)
    elseif key == 303 then preDelayX2() singleAlternate(3.03, math.random(2, 4), THICKNESS * 0.66)

    elseif key == 500 then preDelayX2() alternateLLLL(calcOneSideDelay(), math.random(3, 5), THICKNESS)
    elseif key == 501 then preDelayX2() alternateLRLR(calcOneSideDelay(), math.random(3, 5), THICKNESS)

    elseif key == 1000 then preDelayX2() halfSidesAlternation(calcOneSideDelay(), math.random(2, 3), THICKNESS)
    elseif key == 1001 then preDelayX2() twoWallPairs(calcOneSideDelay(), 1, THICKNESS)
    elseif key == 1002 then preDelayX2() twoWallPairs(calcOneSideDelay(), math.random(4, 5), THICKNESS)
    elseif key == 1003 then preDelayX2() twoWallPairs(calcOneSideDelay(), math.random(2, 3), THICKNESS)
    elseif key == 1004 then preDelayFull() viprePatternCapAfter(calcOneSideDelay(), math.random(3, 4), THICKNESS)
    end
end

keys = { 0, 1, 11, 12, 100, 102, 200, 201, 300, 301, 302, 303, 500, 500, 1000, 1001, 1004 }
shuffle(keys)
index = 1

function onStep()
	if PATTERNS_ENABLED then
		addPattern(keys[index])
		index = index + 1

		if index - 1 == #keys then
			index = 1
			shuffle(keys)
		end
	end
end