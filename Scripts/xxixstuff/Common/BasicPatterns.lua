--

function wallOneOpenSide(side, thickness)
	for i = 1, l_getSides() - 1 do
		w_wall(side + i, thickness)
	end
end

function wallAltBarrage(side, thickness)
	for i = 1, math.ceil(l_getSides() / 2) do
		w_wall(side + i * 2, thickness)
	end
end

function wallHalfVortexSmaller(side, thickness)
	for i = 1, math.floor(l_getSides() / 2) - 1 do
		w_wall(side + i, thickness)
	end
end

function wallHalfVortexBigger(side, thickness)
	for i = 1, math.ceil(l_getSides() / 2) - 1 do
		w_wall(side + i, thickness)
	end
end

--

function wallHalfOpenSidesSmaller(side, thickness)
	for i = 1, math.floor(l_getSides() / 2) do
		w_wall(side + i, thickness)
	end
end

function wallHalfOpenSidesBigger(side, thickness)
	for i = 1, math.ceil(l_getSides() / 2) do
		w_wall(side + i, thickness)
	end
end