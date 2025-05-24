-- Basis for many patterns
function barrage(side)
    for i = 0, l_getSides() - 2 do
        w_wall(side + i, THICKNESS)
    end
end

function altWall(side, THICKNESS)
    local THICKNESS = THICKNESS or 40
    for i = 0, l_getSides() / 2 do
        w_wall(side + i * 2, THICKNESS)
    end
end

function barrageW(side)
	for i = 0, l_getSides() - 4 do
		w_wall(side + i, THICKNESS)
	end
	w_wall(side - l_getSides() - 2, THICKNESS)
end

function wallExB(side)
    local delay = getPerfectDelay(THICKNESS) * 6
    local side = side or math.random(0, l_getSides() - 1)

    if l_getSides() % 2 == 1 then
        w_wall(side - 1, THICKNESS)
    end
    for i = 0, l_getSides() / 2 - 2 do
        w_wall(side + i, THICKNESS)
    end
    for i = 0, l_getSides() / 2 - 2 do
        w_wall(side + i + l_getSides() / 2, THICKNESS)
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- INFO ABOUT VALUES -------------------------------------------------------------------------------------------------------------------------------------------------

-- mTimes: How many times pattern will be generated, required input (Note: All cycles start at 0, so 0 = the pattern will be generated 1 time, 1 = 2 and so on)
-- delay: The distance between obstacles, it is usually set automatically but you can enter your own value
-- delayEndMult: Distance after the generated pattern, the entered number will be multiplied by the delay, usually it is equal to one but you can enter your own value
-- mLength: The number of sides that the walls will occupy
-- mStep: After how many sides the barrage will be generated
-- mExtra: More or less walls
-- thicknessMult: your THICKNESS will be multiplied by thicknessMult, usually it is equal to one but you can enter your own value

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- pAltBarrage: upgraded version of pAltBarrage
function pAltBarrageExtendedPD(mTimes, delay, delayEnd, mStep)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local side = math.random(0, l_getSides() - 1)
    local mStep = mStep or 1
    local loopDir = mStep
    local j = 0

    for i = 0, mTimes do
        altWall(side + j, THICKNESS)
        local loopDir = mStep
        j = j + loopDir
        if i < mTimes then
            t_wait(delay)
        end
    end
    t_wait(delayEnd)
end

function pRandomAltBarrageExtendedPD(mTimes, delay, delayEnd, mStep)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local side = math.random(0, l_getSides() - 1)
    local mStep = mStep or 1
    local loopDir = mStep * getRandomDir()
    local j = 0

    for i = 0, mTimes do
        altWall(side + j)
        local loopDir = mStep * getRandomDir()
        j = j + loopDir
        if i < mTimes then
            t_wait(delay)
        end
    end
    t_wait(delayEnd)
end

function pWallExVortexExtendedPD(mTimes, delay, delayEnd)
    local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
	local mStep = 0

	for i = 0, mTimes - 1 do
		wallExB(side + mStep)
		t_wait(delay)
		mStep = mStep + 1
	end
	for i = 0, mTimes do
		wallExB(side + mStep)
		if i < mTimes then
            t_wait(delay)
        end
		mStep = mStep - 1
	end
	t_wait(delayEnd)
end

-- BarrageSpiralExtendedPD: upgraded version of pNextBarrage
function pBarrageSpiralExtendedPD(mTimes, delay, delayEnd, mStep)
    local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local mStep = mStep or 1

    if math.random(0, 1) == 0 then
        for i = 0, mTimes do
            cBarrage(side + i * mStep)
            if i < mTimes then
                t_wait(delay)
            end
        end
    else
        for i = 0, mTimes do
            cBarrage(side - i * mStep)
            if i < mTimes then
                t_wait(delay)
            end
        end
    end
    t_wait(delayEnd)
end

-- pRandomBarrageExtended: upgraded version of pRandomBarrage
function pRandomBarrageExtendedPD(mTimes, delay, delayEnd, bonusDelay, samePositionSpawn)
    local side = math.random(0, l_getSides() - 1)
    local oldSide = 0
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local bonusDelay = bonusDelay or 2
    local samePositionSpawn = samePositionSpawn or false

    for i = 0, mTimes do
        cBarrage(side)
        oldSide = side
        if samePositionSpawn == true then
            side = side + math.random(0, l_getSides() - 1)
        elseif samePositionSpawn == false then
            side = side + math.random(1, l_getSides() - 1)
        end
        if i < mTimes then
            t_wait((bonusDelay + (getSideDistance(side, oldSide) * delay)))
        end
    end
    t_wait(delayEnd)
end

-- pInverseBarrageExtended: upgraded version of pInverseBarrage
function pInverseBarrageExtendedPD(mTimes, delay, delayEnd, removeWall)
	local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local removeWall = removeWall or false

    if removeWall == false then
	for i = 0, mTimes do
		barrage(side)
		t_wait(delay)
		barrage(side + l_getSides()/2)
		if i < mTimes then
            t_wait(delay)
        end
	end
    elseif removeWall == true then
        for i = 0, mTimes do
		    for k = 0, l_getSides() - 3 do
                w_wall(side + l_getSides()/2 + 1 + k, THICKNESS)
            end
		    t_wait(delay)
            barrage(side)
            if i < mTimes then
                t_wait(delay)
            end
        end
    end
	t_wait(delayEnd)
end

-- pSpiralExtended: upgraded version of pSpiral
function pSpiralExtendedPD(mTimes, mExtra, delay, delayEnd, thicknessMult)
    local side = math.random(0, l_getSides() - 1)
    local thicknessMult = thicknessMult or 1
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local oldThickness = THICKNESS
    THICKNESS = getPerfectThickness(THICKNESS) * thicknessMult

    if math.random(0, 1) == 0 then
    for i = 0, mTimes do
        cWallEx(side + i, mExtra)
        if i < mTimes then
            t_wait(delay)
        end
    end
    else
        for i = 0, mTimes do
            cWallEx(side - i, mExtra)
            if i < mTimes then
                t_wait(delay)
            end
        end
    end

    THICKNESS = oldThickness
    t_wait(delayEnd)
end

-- pTunnelEdited: forces you to circle around a very thick wall
function pTunnelExtendedPD(mTimes, delay, delayEnd, myThickness)
    local perfectDelay = perfectDelay or true
    local oldThickness = THICKNESS
    local myThickness = (myThickness or 1) * getPerfectThickness(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local startSide = getRandomSide()
    local loopDir = getRandomDir()
    THICKNESS = myThickness

    for i = 0, mTimes do
        if i < mTimes then
            w_wall(startSide, myThickness + 5 * u_getSpeedMultDM() * delay)
        end

        cBarrage(startSide + loopDir)
        if i < mTimes then
            t_wait(delay)
        end

        loopDir = loopDir * -1
    end
    t_wait(delayEnd)
    THICKNESS = oldThickness
end

-- pLRBarrage: Pattern with l_getSides() - 1 walls and 1 wall after
function pLRBarrage(mTimes, delay, delayEnd, extraBarrage)
    local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local extraBarrage = extraBarrage or false

    for i = 0, mTimes do
        barrage(side)
        t_wait(delay)
        w_wall(side - 1, THICKNESS)
        if i < mTimes or extraBarrage == true then
            t_wait(delay)
        end
    end

    if extraBarrage == true then
        barrage(side)
    end
    t_wait(delayEnd)
end

-- pLRBarrage2: Pattern where you need to go left to right (cool description)
function pLRBarrage2(mTimes, delay, delayEnd)
    local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)

    if math.random(0, 1) == 0 then
        for i = 0, mTimes do
            barrage(side)
            t_wait(delay)
            barrage(side + 1)
            if i < mTimes then
                t_wait(delay)
            end
        end
    else
        for i = 0, mTimes do
            barrage(side + 1)
            t_wait(delay)
            barrage(side)
            if i < mTimes then
                t_wait(delay)
            end
        end
    end
    t_wait(delayEnd)
end

-- pLRBarrage3: Pattern where you need to go left to right (different cool)
-- Recommended for use only if the number of sides 5 or more
function pLRBarrage3(mTimes, delay, delayEnd)
    local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)

    for i = 0, mTimes do
        if l_getSides() % 2 == 1 then
            w_wall(side - 1, THICKNESS)
        end
        for k = 0, l_getSides()/2 - 1 do
            w_wall(side + k, THICKNESS)
        end
        t_wait(delay)
	    for k = 0, l_getSides()/2 - 1 do
            w_wall(side + k + l_getSides()/2, THICKNESS)
        end
        if i < mTimes then
            t_wait(delay)
        end
    end
    t_wait(delayEnd)
end   

-- pLRBarrage4: Pattern where you need to go left to right, uses barrageW (again)
-- Recommended for use only if the number of sides 6 or more
function pLRBarrage4(mTimes, delay, delayEnd)
	local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)

    if math.random(0, 1) == 0 then
    	for i = 0, mTimes do
		barrageW(side)
		t_wait(delay)
		barrageW(side + 1)
		if i < mTimes then
            t_wait(delay)
        end
        end
    else
        for i = 0, mTimes do
            barrageW(side)
            t_wait(delay)
            barrageW(side - 1)
            if i < mTimes then
                t_wait(delay)
            end
        end
	end
	t_wait(delayEnd)
end

-- pLRBarrage5: Pattern where you need to go left to right, uses barrageW (pretty original)
-- Recommended for use only if the number of sides 6 or more
function pLRBarrage5(mTimes, delay, delayEnd)
	local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)

	for i = 0, mTimes do
        if l_getSides() % 2 == 1 then
		    barrageW(side)
		    t_wait(delay)
		    barrageW(side + l_getSides()/2 + 0.5)
		    if i < mTimes then
                t_wait(delay)
            end
        else
            barrageW(side)
		    t_wait(delay)
		    barrageW(side + l_getSides()/2)
		    if i < mTimes then
                t_wait(delay)
            end
        end
	end
	t_wait(delayEnd)
end

-- pLRBarrage6: Pattern where you need to go left to right, uses wallExB (wewewewe)
-- Recommended for use only if the number of sides 5 or more
function pLRBarrage6(mTimes, delay, delayEnd, extraBarrage)
    local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local extraBarrage = extraBarrage or false

    for i = 0, mTimes do
        if l_getSides() % 2 == 1 then
        wallExB(side)
        t_wait(delay)
        w_wall(side - 2, THICKNESS)
        w_wall(side - 2 - l_getSides()/2 + 0.5, THICKNESS)
        else
            wallExB(side)
            t_wait(delay)
            w_wall(side - 1, THICKNESS)
            w_wall(side - 1 - l_getSides()/2, THICKNESS)
        end
        if i < mTimes or extraBarrage == true then
            t_wait(delay)
        end
    end

    if extraBarrage == true then
        wallExB(side)
    end
    t_wait(delayEnd)
end

-- pLRBarrage7: Pattern where you need to go left to right, uses wallExB (hi)
-- Recommended for use only if the number of sides 5 or more
function pLRBarrage7(mTimes, delay, delayEnd)
    local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)

    if math.random(0, 1) == 0 then
    for i = 0, mTimes do
        wallExB(side)
        t_wait(delay)
        wallExB(side + 1)
        if i < mTimes then
            t_wait(delay)
        end
    end
    else
        for i = 0, mTimes do
            wallExB(side)
            t_wait(delay)
            wallExB(side - 1)
            if i < mTimes then
                t_wait(delay)
            end
        end
    end
    t_wait(delayEnd)
end


function pLRBarrage8(mTimes, delay, delayEnd, extraBarrage)
	local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local extraBarrage = extraBarrage or false

	for i = 0, mTimes do
		for k = 0, l_getSides() - 4 do
        w_wall(side + k, THICKNESS)
        end
        w_wall(side - 2, THICKNESS)
        t_wait(delay)
        w_wall(side - 1, THICKNESS)
        w_wall(side - 3, THICKNESS)
		if i < mTimes or extraBarrage == true then
            t_wait(delay)
        end
	end

    if extraBarrage == true then
        for k = 0, l_getSides() - 4 do
            w_wall(side + k, THICKNESS)
        end
        w_wall(side - 2, THICKNESS)
        t_wait(delay)
     end
	t_wait(delayEnd)
end

-- pRandomBarrageLR: Random barrage where you have to go left or right
function pRandomBarrageLR(mTimes, delay, delayEnd, mStep)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local side = math.random(0, l_getSides() - 1)
    local mStep = mStep or 1
    local loopDir = mStep * getRandomDir()
    local j = 0

    for i = 0, mTimes do
        barrage(side + j)
        local loopDir = mStep * getRandomDir()
        j = j + loopDir
        if i < mTimes then
            t_wait(delay)
        end
    end
    t_wait(delayEnd)
end

-- pUniqueSpiral: Spiral with many walls
-- Recommended for use only if the number of sides 5 or more
function pUniqueSpiral(mTimes, delay, delayEnd, mExtra)
    local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local mExtra = mExtra or 1
    local mStep = 0

    if math.random(0, 1) == 0 then
        for i = 0, mTimes do
            for k = 0, mExtra do
                w_wall(side + mStep + k * 2, THICKNESS)
            end
            mStep = mStep + 1
            if i < mTimes then
                t_wait(delay)
            end
        end
    else
        for i = 0, mTimes do
            for k = 0, mExtra do
                w_wall(side + mStep + k * 2, THICKNESS)
            end
            mStep = mStep - 1
            if i < mTimes then
                t_wait(delay)
            end
        end
    end
    t_wait(delayEnd)
end

-- pDoubleUniqueSpiral: Spiral with many walls, after some time changes direction
-- Recommended for use only if the number of sides 5 or more
function pDoubleUniqueSpiral(mTimes, delay, delayEnd, mExtra)
    local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local mStep = 0
    local mExtra = mExtra or 1

    if math.random(0, 1) == 0 then
        for i = 0, mTimes do
            for k = 0, mExtra do
                w_wall(side + mStep + k * 2, THICKNESS)
            end
            t_wait(delay)
            mStep = mStep + 1
        end
		for i = 0, mTimes do
            for k = 0, mExtra do
                w_wall(side + mStep + k * 2, THICKNESS)
            end
            if i < mTimes then
                t_wait(delay)
            end
            mStep = mStep - 1
        end
    else
        for i = 0, mTimes do
            for k = 0, mExtra do
                w_wall(side + mStep + k * 2, THICKNESS)
            end
            t_wait(delay)
            mStep = mStep - 1
        end
		for i = 0, mTimes do
            for k = 0, mExtra do
                w_wall(side + mStep + k * 2, THICKNESS)
            end
            if i < mTimes then
                t_wait(delay)
            end
            mStep = mStep + 1
        end
    end
    t_wait(delayEnd)
end

-- pWalls: Walls on both sides
function pWalls(mTimes, delay, delayEnd)
    local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)

    for i = 0, mTimes do
        w_wall(side, THICKNESS)
        w_wall(side - (l_getSides() / 2), THICKNESS)
        if i < mTimes then
            t_wait(delay)
        end
    end
    t_wait(delayEnd)
end

-- pWallExOneWay: wallEx which is directed to one side
function pWallExOneWay(mTimes, delay, delayEnd, step)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local side = math.random(0, l_getSides() - 1)
    local step = step or 1

    if math.random(0, 1) == 0 then
        for i = 0, mTimes do
            wallExB(side + i * step)
            if i < mTimes then
                t_wait(delay)
            end
        end
    else
        for i = 0, mTimes do
            wallExB(side - i * step)
            if i < mTimes then
                t_wait(delay)
            end
        end
    end
    t_wait(delayEnd)
end

-- pTunnel2: Tunnel where you need to go left to right
-- Recommended for use only if the number of sides 6 or more
-- thicknessMultEnP: If your pTunnel2 is not straight at the end then you can try to pick a number here to make it straight, by default it's 0
function pTunnel2(mTimes, delayMult, delayEnd, thicknessMult, thicknessMultEnP)
    local delay = getPerfectDelay(THICKNESS) * 6
    local delayMult = delayMult or 1
    local delayEndMult = delayEndMult or 1
    local thicknessMult = thicknessMult or delayMult
    local thicknessMultEnP = thicknessMultEnP or 0
    local side = math.random(0, l_getSides() - 1)
    
    for i = 0, mTimes do
        if l_getSides() % 2 == 1 then
            w_wall(side - 1, THICKNESS * 8 * delayMult - (thicknessMult * thicknessMultEnP))
        end
        for k = 0, l_getSides()/2-3 do
        w_wall(side + k, THICKNESS * 8 * delayMult - (thicknessMult * thicknessMultEnP))
        end
        for k = 0, l_getSides()/2-3 do
        w_wall(side + k + l_getSides()/2, THICKNESS * 8 * delayMult - (thicknessMult * thicknessMultEnP))
        end
        altWall(side, THICKNESS * 2 * thicknessMult)
        t_wait(delay * delayMult)
        if l_getSides() % 2 == 1 then
            w_wall(side - 1, THICKNESS * 8 * delayMult - (thicknessMult * thicknessMultEnP))
        end
        for k = 0, l_getSides()/2-3 do
        w_wall(side + k, THICKNESS * 8 * delayMult - (thicknessMult * thicknessMultEnP))
        end
        for k = 0, l_getSides()/2-3 do
        w_wall(side + k + l_getSides()/2, THICKNESS * 8 * delayMult - (thicknessMult * thicknessMultEnP))
        end
        altWall(side + 1, THICKNESS * 2 * thicknessMult)
        t_wait(delay * delayMult)
    end
    altWall(side, THICKNESS * 2 * thicknessMult)

    w_wall(side, THICKNESS)
    t_wait(delayEnd)
end

-- pAltTunnel: Tunnel with alt walls
-- Recommended for use only if the number of sides 4 or more
-- lastWallThicknessMult: If your pAltTunnel is not straight at the end then you can try to pick a number here to make it straight, by default it's 4.45
function pAltTunnel(mTimes, delayMult, delayEnd, wLength, lastWallThicknessMult)
    local delay = 3.5 * getPerfectDelay(THICKNESS)
    local delayMult = delayMult or 1
    local delayEndMult = delayEndMult or 1
    local side = math.random(0, l_getSides() - 1)
    local lastWallThicknessMult = lastWallThicknessMult or 4.45

    for i = 0, mTimes do
        for k = 0, wLength or l_getSides() / 2 - 1 do
        w_wall(side + k, THICKNESS * 7.5 * delayMult)
        end
        t_wait(delay * delayMult)
        altWall(side)
        t_wait(delay * delayMult)

        if i ~= mTimes then
	    for k = 0, wLength or l_getSides() / 2 - 1 do
        w_wall(side + k, THICKNESS * 7.5 * delayMult)
        end
        else
            for k = 0, wLength or l_getSides() / 2 - 1 do
            w_wall(side + k, THICKNESS * lastWallThicknessMult * delayMult)
            end
        end

        t_wait(delay * delayMult)
	    altWall(side + 1)
        t_wait(delay * delayMult)
    end
    t_wait(delayEnd)
end   

-- pAltTunnel2: Tunnel with alt walls and two partitions
-- Recommended for use if number of side is 7 or more
function pAltTunnel2(mTimes, delay, delayEnd, thicknessMult)
	local delay = (delay or 7) * getPerfectDelay(THICKNESS)
    local delayEndMult = delayEndMult or 1
    local thicknessMult = thicknessMult or 1
    local side = math.random(0, l_getSides() - 1)
    local rDelay = delay / getPerfectDelay(THICKNESS)

    if math.random(0, 1) == 0 then
    for i = 0, mTimes do
    w_wall(side, THICKNESS * 14.95 * (rDelay / 7))
    if l_getSides() > 5 then
	w_wall(side + l_getSides() / 2, THICKNESS * 14.95 * (rDelay / 7))
    end

	altWall(side, THICKNESS * thicknessMult)
	t_wait(delay)
	altWall(side + 1, THICKNESS * thicknessMult)
	t_wait(delay)
	end
	altWall(side, THICKNESS * thicknessMult)
    else
	    for i = 0, mTimes do
			w_wall(side, THICKNESS * 14.95 * (rDelay / 7))
            if l_getSides() > 5 then
			w_wall(side + l_getSides() / 2, THICKNESS * 14.95 * (rDelay / 7))
            end
		
			altWall(side + 1, THICKNESS * thicknessMult)
			t_wait(delay)
			altWall(side, THICKNESS * thicknessMult)
			t_wait(delay)
			end
			altWall(side + 1, THICKNESS * thicknessMult)
	end
	t_wait(delayEnd)
end

-- pWallExSpawn: spawns a lot of wallExB
function pWallExSpam(mTimes, delay, delayEnd)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local side = math.random(0, l_getSides() - 1)
        
	for i = 0, mTimes do
        wallExB(side)
        if i < mTimes then
            t_wait(delay)
        end
    end
    t_wait(delayEnd)
end

-- pLRLbarrage: spawns barrages where you need to go LLLRRRLLL
function pLRLbarrage(delay, delayEnd)
	local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local side = side or math.random(0, l_getSides() - 1)

	if math.random(0, 1) == 0 then
		barrage(side)
		t_wait(delay)
		barrage(side + 1)
		t_wait(delay)
		barrage(side + 2)
		t_wait(delay)
		barrage(side + 1)
		t_wait(delay)
		barrage(side)
		t_wait(delay)
		barrage(side + 1)
		t_wait(delay)
		barrage(side + 2)
	else
		barrage(side)
		t_wait(delay)
		barrage(side - 1)
		t_wait(delay)
		barrage(side - 2)
		t_wait(delay)
		barrage(side - 1)
		t_wait(delay)
		barrage(side)
		t_wait(delay)
		barrage(side - 1)
		t_wait(delay)
		barrage(side - 2)
	end
	t_wait(delayEnd)
end

-- pAltSpam: spawns a lot of altBarrages
function pAltSpam(mTimes, delay, delayEnd)
    local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)

    for i = 0, mTimes do
        altWall(side, THICKNESS)
        if i < mTimes then
            t_wait(delay)
        end
    end
    t_wait(delayEnd)
end

-- pNextBarrageW: spawns a spiral of barrageW
-- Recommended for use only if the number of sides 5 or more
function pNextBarrageW(mTimes, delay, delayEndMult)
	local side = math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)

    if math.random(0, 1) == 0 then
	for i = 0, mTimes do
		barrageW(side + i)
		if i < mTimes then
            t_wait(delay)
        end
	end
    else
	    for i = 0, mTimes do
			barrageW(side - i)
			if i < mTimes then
                t_wait(delay)
            end
		end
	end
	t_wait(delayEnd)
end

-- pWallSpiral: Spawns walls in a spiral
function pWallSpiral(mTimes, delay, delayEnd, wLength, step, thicknessMult)
    local side = side or math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local wLength = wLength or 0
    local step = step or 1
    local thicknessMult = thicknessMult or 1

    if math.random(0, 1) == 0 then
        for i = 0, mTimes do
            for k = 0, wLength do
                w_wall(side + k + i * step, THICKNESS * thicknessMult)
            end
            if i < mTimes then
                t_wait(delay)
            end
        end
    else
        for i = 0, mTimes do
            for k = 0, wLength do
                w_wall(side + k - i * step, THICKNESS * thicknessMult)
            end
            if i < mTimes then
                t_wait(delay)
            end
        end
    end
    t_wait(delayEnd)
end

-- pMirrorWallSpiral: Spawns walls in a spiral on both sides
function pMirrorWallSpiral(mTimes, delay, delayEnd, wLength, step, thicknessMult)
    local side = side or math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local wLength = wLength or 0
    local step = step or 1
    local thicknessMult = thicknessMult or 1

    if math.random(0, 1) == 0 then
        for i = 0, mTimes do
            for k = 0, wLength do
            w_wall(side + k + i * step, THICKNESS * thicknessMult)
            end
            for k = 0, wLength do
                w_wall(side + k + i * step + l_getSides() / 2, THICKNESS * thicknessMult)
                end
            if i < mTimes then
                t_wait(delay)
            end
        end
    else
        for i = 0, mTimes do
            for k = 0, wLength do
                w_wall(side + k - i * step, THICKNESS * thicknessMult)
            end
            for k = 0, wLength do
                w_wall(side + k - i * step + l_getSides() / 2, THICKNESS * thicknessMult)
            end
            if i < mTimes then
                t_wait(delay)
            end
        end
    end
    t_wait(delayEnd)
end

-- pDoubleWallSpiral: Spawns walls in a spiral, after they turn the other way
-- Recommended for use only if the number of sides 6 or more
function pDoubleWallSpiral(mTimes, delay, delayEnd, wLength, step, thicknessMult)
    local side = side or math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local wLength = wLength or 0
    local step = step or 1
    local mStep = 0
    local thicknessMult = thicknessMult or 1

    if math.random(0, 1) == 0 then
        for i = 0, mTimes do
            for k = 0, wLength do
                w_wall(side + k + mStep, THICKNESS * thicknessMult)
            end
            mStep = mStep + step
            t_wait(delay)
        end
        for i = 0, mTimes do
            for k = 0, wLength do
                w_wall(side + k + mStep, THICKNESS * thicknessMult)
            end
            mStep = mStep - step
            if i < mTimes then
                t_wait(delay)
            end
        end
    else
        for i = 0, mTimes do
            for k = 0, wLength do
                w_wall(side + k + mStep, THICKNESS * thicknessMult)
            end
            mStep = mStep - step
            t_wait(delay)
        end
        for i = 0, mTimes do
            for k = 0, wLength do
                w_wall(side + k + mStep, THICKNESS * thicknessMult)
            end
            mStep = mStep + step
            if i < mTimes then
                t_wait(delay)
            end
        end
    end
    t_wait(delayEnd)
end

-- pDoubleMirrorWallSpiral: Spawns walls in a spiral on both sides, after they turn the other way
-- Recommended for use only if the number of sides 6 or more
function pDoubleMirrorWallSpiral(mTimes, delay, delayEnd, wLength, step, thicknessMult)
    local side = side or math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local wLength = wLength or 0
    local step = step or 1
    local mStep = 0
    local thicknessMult = thicknessMult or 1

    if math.random(0, 1) == 0 then
        for i = 0, mTimes do
            for k = 0, wLength do
                w_wall(side + k + mStep, THICKNESS * thicknessMult)
            end
            for k = 0, wLength do
                w_wall(side + k + mStep + l_getSides() / 2, THICKNESS * thicknessMult)
            end
            mStep = mStep + step
            t_wait(delay)
        end
        for i = 0, mTimes do
            for k = 0, wLength do
                w_wall(side + k + mStep, THICKNESS * thicknessMult)
            end
            for k = 0, wLength do
                w_wall(side + k + mStep + l_getSides() / 2, THICKNESS * thicknessMult)
            end
            mStep = mStep - step
            if i < mTimes then
                t_wait(delay)
            end
        end
    else
        for i = 0, mTimes do
            for k = 0, wLength do
                w_wall(side + k + mStep, THICKNESS * thicknessMult)
            end
            for k = 0, wLength do
                w_wall(side + k + mStep + l_getSides() / 2, THICKNESS * thicknessMult)
            end
            mStep = mStep - step
            t_wait(delay)
        end
        for i = 0, mTimes do
            for k = 0, wLength do
                w_wall(side + k + mStep, THICKNESS * thicknessMult)
            end
            for k = 0, wLength do
                w_wall(side + k + mStep + l_getSides() / 2, THICKNESS * thicknessMult)
            end
            mStep = mStep + step
            if i < mTimes then
                t_wait(delay)
            end
        end
    end
    t_wait(delayEnd)
end

-- pSwapTunnel2: Spawns a swap tunnel where you need to hit swap multiple times
-- Recommended for use only if the number of sides 4 or more
function pSwapTunnel2(mTimes, delay, delayEnd, thicknessMult, wallThicknessMult, mExtra)
    local side = side or math.random(0, l_getSides() - 1)
    local delay = (delay or 1) * getPerfectDelay(THICKNESS)
    local delayEnd = (delayEnd or 1) * getPerfectDelay(THICKNESS)
    local mExtra = mExtra or 0
    local thicknessMult = thicknessMult or 1
    local wallThicknessMult = wallThicknessMult or 1

    for i = 0, mTimes do
    for k = 0, mExtra do
        if i ~= mTimes then
        w_wall(side + k, THICKNESS * 6.25 * thicknessMult)
        w_wall(side + k + l_getSides()/2, THICKNESS * 6.25 * thicknessMult)
        else
            w_wall(side + k, THICKNESS)
            w_wall(side + k + l_getSides()/2, THICKNESS)
        end
    end
    for k = 0, l_getSides()/2 do
        w_wall(side + k + (i * l_getSides()/2), THICKNESS * wallThicknessMult)
    end
    if i < mTimes then
        t_wait(delay)
    end
    end
    t_wait(delayEnd)
end

-- pSwapRandomTunnel: Spawns a random swap tunnel where walls for swap are randomly generated
-- Recommended to change thicknessMult only if you are changing delay or wallThicknessMult
-- Recommended for use only if the number of sides 4 or more
function pSwapRandomTunnel(mTimes, delay, delayEnd, thicknessMult, wallThicknessMult, mLength)
    local delay = (delay or 10) * getPerfectDelay(THICKNESS)
    local side = side or math.random(0, l_getSides() - 1)
    local delayEndMult = delayEndMult or 1
    local mLength = mLength or l_getSides()/2 - 2
    local thicknessMult = thicknessMult or 1
    local wallThicknessMult = wallThicknessMult or 1

    for i = 0, mTimes do
        for k = 0, mLength do
            if i ~= mTimes then
            w_wall(side + k, THICKNESS * 10.5 * thicknessMult)
            w_wall(side + k + l_getSides()/2, THICKNESS * 10.5 * thicknessMult)
            else
                w_wall(side + k, THICKNESS)
                w_wall(side + k + l_getSides()/2, THICKNESS)
            end
        end
        if math.random(0, 1) == 0 then
        for k = 0, l_getSides()/2 do
            w_wall(side + k + l_getSides()/2, THICKNESS * wallThicknessMult)
        end
        else
            for k = 0, l_getSides()/2 do
                w_wall(side + k, THICKNESS * wallThicknessMult)
            end
        end
        if i < mTimes then
            t_wait(delay)
        end
        end
    t_wait(delayEnd)
end
