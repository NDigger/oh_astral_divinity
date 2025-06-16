function halfSidesAlternationPattern(delay, iterations, thickness, side)
	for i = 1, iterations do
		if i > 1 then t_wait(delay) end
		wallHalfOpenSidesSmaller(side, thickness)
        t_wait(delay)
		wallHalfOpenSidesBigger(side + math.floor(l_getSides() / 2), thickness)
	end
end

function twoWallPairsPattern(delay, iterations, thickness, side)
    w_wall(side, thickness)
    w_wall(side + math.floor(l_getSides() / 2), thickness)

	for i = 1, iterations do
		t_wait(delay)
		side = side + 1
		w_wall(side, thickness)
		w_wall(side + math.floor(l_getSides() / 2), thickness)
	end
end

function viprePatternCapAfterPattern(delay, iterations, thickness, side)
	for i = 1, iterations do
		if i > 1 then t_wait(delay) end
		wallOneOpenSide(side, thickness)
		t_wait(delay)
		w_wall(side, thickness)
	end
end