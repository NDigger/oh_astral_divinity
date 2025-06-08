function oneOpenSide(delay, iterations, thickness, side, variation, direction_shift)
	for i = 1, iterations do
		if i > 1 then t_wait(delay) end
		wallOneOpenSide(side, thickness)

		-- 0 => LLLLLL | 1 => LLLRRR | 2 => LRLRLR | 3 => LR random
			if variation == 1 and i == math.ceil(iterations / 2) then direction_shift = direction_shift * -1
		elseif variation == 2 then direction_shift = direction_shift * -1
		elseif variation == 3 then direction_shift = direction_shift * getRandomSegmentDir()
		end

		side = side + direction_shift
	end
end

function vortex(delay, iterations, thickness, side, variation, direction_shift)
	for i = 1, iterations do
		if i > 1 then t_wait(delay) end
		wallHalfVortexSmaller(side, thickness)
		wallHalfVortexBigger(side + math.floor(l_getSides() / 2), thickness)

		-- 0 => LLLLLL | 1 => LLLRRR | 2 => LRLRLR
			if variation == 1 and i == math.ceil(iterations / 2) then direction_shift = direction_shift * -1
		elseif variation == 2 then direction_shift = direction_shift * -1
		end

		side = side + direction_shift
	end
end

function twoParallelWalls(delay, iterations, thickness, side)
	for i = 1, iterations do
		if i > 1 then t_wait(delay) end
		w_wall(side, thickness)
		w_wall(side + math.floor(l_getSides() / 2), thickness)
	end
end

function spiral(delay, iterations, thickness, side, variation, direction_shift)
	for i = 1, iterations do
		if i > 1 then t_wait(delay) end

		-- 0 => single wall | 1 => two parallel walls
			if variation == 0 then
			w_wall(side, thickness)
		elseif variation == 1 then 
			w_wall(side, thickness)
			w_wall(side + math.floor(l_getSides() / 2), thickness)
		end

		side = side + direction_shift
	end
end

function alternate(delay, iterations, thickness, side, variation, direction_shift)
	for i = 1, iterations do
		if i > 1 then t_wait(delay) end
		wallAltBarrage(side, thickness)

		-- 0 => LLLLLL | 2 => LRLRLR
		if variation == 2 then direction_shift = direction_shift * -1 end

		side = side + direction_shift
	end
end

function randomOneOpenSide(delayMult, iterations, thickness, side, variation)

	local function getSegmentDifference(oldSegment, segment)
		-- the difference between the new and old positions
		local segmentDiff = math.abs(segment - oldSegment)

		-- the delay is reduced if the difference is more than half,
		-- as the new pattern approaches the old position on the other side
		if segmentDiff > math.floor(l_getSides() / 2) then segmentDiff = l_getSides() - segmentDiff end

		return segmentDiff
	end

	local initSide = side

	local segment = getRandomSegment()
	local oldSegment = segment
	local delay = 0

	for i = 1, iterations do
		if i > 1 then t_wait(delay) end
		wallOneOpenSide(initSide + segment, thickness)

		segment = getRandomSegment()
		-- 0 => position can be same | 1 => can not
		if variation == 1 then
			while (segment - oldSegment) == 0 do
				segment = getRandomSegment()
			end
		end
		
		-- half of the delay is constant for any position, the other half is relative
		delay = delayMult * (getCommonDelayMult() / 10 * (halfSidesMinDelay() / 2 + halfSidesMinDelay() / l_getSides() * getSegmentDifference(oldSegment, segment)))
		oldSegment = segment
	end
end