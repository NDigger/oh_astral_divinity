function halfSidesAlternation(delay, iterations, thickness)
    local side = getRandomSide()

    halfSidesAlternationPattern(delay, iterations, thickness, side)
end

function twoWallPairs(delay, iterations, thickness)
    local side = getRandomSide()

    twoWallPairsPattern(delay, iterations, thickness, side)
end

function viprePatternCapAfter(delay, iterations, thickness)
    local side = getRandomSide()

    viprePatternCapAfterPattern(delay, iterations, thickness, side)
end