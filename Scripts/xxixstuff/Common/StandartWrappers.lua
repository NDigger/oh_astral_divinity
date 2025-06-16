-------------------
-- ONE OPEN SIDE --
-------------------

-- +1 side

function oneOpenSideLLLL(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 0
    local direction_shift = getRandomSegmentDir()

    oneOpenSide(delay, iterations, thickness, side, variation, direction_shift)
end

function oneOpenSideLLRR(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 1
    local direction_shift = getRandomSegmentDir()

    oneOpenSide(delay, iterations, thickness, side, variation, direction_shift)
end

function oneOpenSideLRLR(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 2
    local direction_shift = getRandomSegmentDir()
    
    oneOpenSide(delay, iterations, thickness, side, variation, direction_shift)
end

function oneOpenSideLRRandom(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 3
    local direction_shift = getRandomSegmentDir()
    
    oneOpenSide(delay, iterations, thickness, side, variation, direction_shift)
end

-- +2 sides

function oneOpenSideLLLLX2(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 0
    local direction_shift = getRandomSegmentDir() * 2

    oneOpenSide(delay, iterations, thickness, side, variation, direction_shift)
end

function oneOpenSideLLRRX2(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 1
    local direction_shift = getRandomSegmentDir() * 2
    
    oneOpenSide(delay, iterations, thickness, side, variation, direction_shift)
end

function oneOpenSideLRLRX2(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 2
    local direction_shift = getRandomSegmentDir() * 2
    
    oneOpenSide(delay, iterations, thickness, side, variation, direction_shift)
end

-- other

function oneOpenSideInverse(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 2
    local direction_shift = math.floor(l_getSides() / 2)

    oneOpenSide(delay, iterations, thickness, side, variation, direction_shift)
end

function oneOpenSideRandomWithSamePos(delayMult, iterations, thickness)
    local side = getRandomSide()
    local variation = 0

    randomOneOpenSide(delayMult, iterations, thickness, side, variation)
end

function oneOpenSideRandomWithoutSamePos(delayMult, iterations, thickness)
    local side = getRandomSide()
    local variation = 1

    randomOneOpenSide(delayMult, iterations, thickness, side, variation)
end

--------------
-- VORTEXES --
--------------

function vortexLLLL(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 0
    local direction_shift = getRandomSegmentDir()

    vortex(delay, iterations, thickness, side, variation, direction_shift)
end

function vortexLLRR(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 1
    local direction_shift = getRandomSegmentDir()
    
    vortex(delay, iterations, thickness, side, variation, direction_shift)
end

function vortexLRLR(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 2
    local direction_shift = getRandomSegmentDir()
    
    vortex(delay, iterations, thickness, side, variation, direction_shift)
end

-------------
-- SINGLES --
-------------

function singleTwoParallelWalls(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 0
    local direction_shift = 0

    twoParallelWalls(delay, iterations, thickness, side)
end

function singleOneOpenSide(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 0
    local direction_shift = 0

    oneOpenSide(delay, iterations, thickness, side, variation, direction_shift)
end

function singleVortex(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 0
    local direction_shift = 0

    vortex(delay, iterations, thickness, side, variation, direction_shift)
end

function singleAlternate(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 0
    local direction_shift = 0

    alternate(delay, iterations, thickness, side, variation, direction_shift)
end

-------------
-- SPIRALS -- (broken for now)
-------------

function spiralSingleWall(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 0
    local direction_shift = getRandomSegmentDir()

    spiral(delay, iterations, thickness, side, variation, direction_shift)
end

function spiralDoubleWalls(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 1
    local direction_shift = getRandomSegmentDir()

    spiral(delay, iterations, thickness, side, variation, direction_shift)
end

function spiralThin(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 0
    local direction_shift = getRandomSegmentDir()

    oneOpenSide(delay, iterations, thickness, side, variation, direction_shift)
end

-----------
-- OTHER --
-----------

function alternateLLLL(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 0
    local direction_shift = getRandomSegmentDir()

    alternate(delay, iterations, thickness, side, variation, direction_shift)
end

function alternateLRLR(delay, iterations, thickness)
    local side = getRandomSide()
    local variation = 2
    local direction_shift = getRandomSegmentDir()

    alternate(delay, iterations, thickness, side, variation, direction_shift)
end