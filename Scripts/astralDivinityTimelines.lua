-- COOL STUFF
offset = -0 -- Events offset

---------------------------------------------------------------
-- INTERPOLATION (it handles entire level)
---------------------------------------------------------------

interpolation = {}
interpolation.__index = interpolation
function interpolation:new(setter_)
    local obj = {
        start = 0,
        end_ = 0,
        elapsed = 0,
        time = 9999,

        value = 0, -- used only for variables that need interpolation

        setter = setter_,
        easing = nil, 

        isStartBigger = true,
        updateEnabled = false
    }
    setmetatable(obj, self)
    return obj
end

function interpolation:run(start, end_, time, easing)
    self.start = start
    self.end_ = end_
    self.time = time
    self.easing = easing
    self.isStartBigger = self.end_ - self.start > 0
    self.elapsed = 0
    if (self.updateEnabled == false) then self.updateEnabled = true end
end

-- Various easings for interpolation
easingPow = 3
easing = {
    easeOut = function(t)
        local p = t - 1
        return math.pow(p, easingPow) + 1
    end,
    backOut = function(t)
        local c1 = 1.70158
        local c3 = c1 + 1
        return 1 + c3 * (t - 1)^3 + c1 * (t - 1)^2
    end,
    backIn = function(t)
        local s = 1.70158
        return t * t * ((s + 1) * t - s)
    end,
    easeIn = function(t)
        return t * t
    end
}

-- Interpolation will not work until you call update method of value that must be interpolated
function interpolation:update(mFrameTime)
    if (self.updateEnabled == false or self.elapsed > self.time) then return end
    self.elapsed = self.elapsed + mFrameTime
    local t = math.min(self.elapsed / self.time, 1)
    local easedT = self.easing and self.easing(t) or t
    local newValue = self.start + (self.end_ - self.start) * easedT
    if self.setter ~= nil then self.setter(newValue) else self.value = newValue end
    if self.elapsed >= self.time then self.updateEnabled = false end
end

-- Here we go
pulse = {
    minRadius = interpolation:new(l_setRadiusMin),
    rotationSpeed = interpolation:new(l_setRotationSpeed),
    bgTileOffset = interpolation:new(s_setBGRotationOffset),
    scoreFloatingNumbers = interpolation:new(),
    skew = interpolation:new(s_set3dSkew),
    spacing3d = interpolation:new(s_set3dSpacing),
    alpha3d = interpolation:new(s_set3dAlphaMult),
    speed = interpolation:new(l_setSpeedMult),
    additionalPlayerRadius = interpolation:new(),
    playerWidthMult = interpolation:new(),
    playerHeightMult = interpolation:new(),
    shaderTimeMult = interpolation:new(),
    wallLeftSkew = interpolation:new(),
    wallRightSkew = interpolation:new(),
    wallLeftAngle = interpolation:new(),
    wallRightAngle = interpolation:new(),
    shaderBorderPulse = interpolation:new(),
    shaderGridSize = interpolation:new(),
    shaderColorVariance = interpolation:new(),
}

-- Values preset (for objects that don't use setters)
pulse.shaderGridSize.value = 20
pulse.shaderColorVariance.value = 0.1
pulse.playerWidthMult.value = 1
pulse.playerHeightMult.value = 1
pulse.additionalPlayerRadius.value = -5
pulse.shaderTimeMult.value = 1

function pulseCustomWallsColor(rInc, gInc, bInc, aInc, time) 
    local function runInterpolation(color)
        safeValue = {min = 0, max = 255}
        color.r:run(math.max(safeValue.min, math.min(safeValue.max, color.r.value + rInc)), color.r.value, time, easeOut)
        color.g:run(math.max(safeValue.min, math.min(safeValue.max, color.g.value + gInc)), color.g.value, time, easeOut)
        color.b:run(math.max(safeValue.min, math.min(safeValue.max, color.b.value + bInc)), color.b.value, time, easeOut)
        color.a:run(math.max(safeValue.min, math.min(safeValue.max, color.a.value + aInc)), color.a.value, time, easeOut)
    end

    -- APPLY PULSE FOR ALL CUSTOM WALLS IN customWall OBJECT
    for key, wallType in pairs(customWall) do
        if key == 'symbols' then -- For symbols we enter into each symbol array
            for _, symbol in pairs(wallType) do
                for _, block in pairs(symbol) do
                    runInterpolation(block.color)
                end
            end
        else
            for _, cw in pairs(wallType) do
                runInterpolation(cw.color)
            end
        end
    end
end

function getRndDir() return math.random(0, 1) == 0 and 1 or -1 end

----------------------------------------------------------
-- REPETITIVE EVENTS
----------------------------------------------------------

globalTimings = {
    firstPart = {
        [0] = function()
            local timings = {0.13, 0.68, 1.22, 2.31, 2.86, 4.52, 5.05, 5.61, 6.68, 7.24} 
            createEvents(timings, [[ 
            s_setBGRotationOffset(s_getBGRotationOffset() + 360 / l_getSides()) 
        ]])
        end,
        [1] = function()
            local timings = {0.4, 1, 2.05, 2.59, 3.14, 4.23, 4.76, 5.31, 6.41, 6.94, 7.5}
            createEvents(timings, [[
            pulse.minRadius:run(100, 60, 20, easing.easeOut)
            pulse.scoreFloatingNumbers:run(10, 0, 60, easing.easeOut)
            pulse.rotationSpeed:run(-1, 0, 50, easing.easeOut)
            pulse.skew:run(0.2, 0, 30, easing.backOut)
            pulse.shaderTimeMult:run(5, 1, 60, easing.easeOut)
        ]])
        end,
        [2] = function()
            local timings = {1.46, 5.85, 8.04}
            createEvents(timings, [[
            l_setSides(l_getSides() + 1)
            ]])
            local delayedTimings = {1.47, 5.86, 8.05} -- fixes player pulse
            createEvents(delayedTimings, [[
            pulse.rotationSpeed:run(2, 0, 100, easing.easeOut)
            pulsingLineWalls(150, 0)
            pulseCustomWallsColor(0, 0, 255, 0, 200)
            pulse.shaderTimeMult:run(5, 1, 60, easing.easeOut)
            ]])
        end,
        [3] = function()
            local timings = {3.68, 3.96, 4.09}
            createEvents(timings, [[
            l_setRotation(l_getRotation() + 180)
            pulse.scoreFloatingNumbers:run(5, 0, 60, easing.easeOut)
            pulse.additionalPlayerRadius:run(5, -5, 20, easing.easeOut)
            pulse.playerWidthMult:run(2, 1, 20, easing.easeOut)
            pulse.shaderTimeMult:run(3, 1, 60, easing.easeOut)
            createLineWalls(5)
        ]])
        end
    },
    secondPart = { -- drop
        [0] = function()
            local timings = {8.57, 9.17, 9.72, 10.26, 12.96, 13.54, 14.07, 14.55, 17.32, 17.89, 18.42, 18.95, 21.67, 22.26, 22.77, 23.33}
            createEvents(timings, [[
            pulse.rotationSpeed:run(1, 0, 200, easing.backOut)
            pulse.minRadius:run(90, 60, 30, easing.easeOut)
            pulse.scoreFloatingNumbers:run(10, 0, 60, easing.easeOut)
            pulse.playerHeightMult:run(2, 1, 60, easing.easeOut)
            pulseTime = pulseTimePulse
            removePentagonDecorationPart()
            createParticles(30, 20)
        ]])
        end,
        [1] = function()
            local timings = {10.77, 11.4, 11.65, 11.85, 15.13, 15.42, 15.7, 16, 16.79, 19.50, 20, 20.58, 24.04, 24.21, 24.45, 24.94}
            createEvents(timings, [[
            pulse.minRadius:run(110, 70, 20, easing.easeOut)
            pulse.rotationSpeed:run(-1, 0, 200, easing.backOut)
            pulse.scoreFloatingNumbers:run(8, 0, 60, easing.easeOut)
            pulse.playerWidthMult:run(2, 1, 60, easing.easeOut)
            pulseTime = pulseTimePulse
            removePentagonDecorationPart()
            createParticles(10, 30)
            ]])
        end,
        [2] = function()
            local timings = {12.18, 12.32, 12.45, 20.89, 20.98, 21.1, 25.39}
            createEvents(timings, [[
            pulse.playerHeightMult:run(2, 1, 60, easing.easeOut)
            pulse.skew:run(0.2, 0.01, 30, easing.easeOut)
            pulse.scoreFloatingNumbers:run(5, 0, 60, easing.easeOut)
            pulse.minRadius:run(80, 60, 10, easing.easeOut)
            l_setRotation(l_getRotation() + l_getRotationSpeed() * 90)
            removePentagonDecorationPart()
            createParticles(10, 10)
        ]])
        end,
        [3] = function()
            local timings = {12.58, 16.37, 16.52, 16.66, 21.23}
            createEvents(timings, [[
            pulse.minRadius:run(80, 60, 30, easing.easeOut)
        ]])
        end,
        [4] = function()
            local timings = {14.78, 14.89, 15.05, 20.05, 20.23, 20.36, 23.53, 23.65, 23.75}
            createEvents(timings, [[
            pulse.minRadius:run(80, 60, 30, easing.easeOut)
            l_setRotation(l_getRotation() - l_getRotationSpeed() * 90)
        ]])
        end
    },
    thirdPart = {
        [0] = function()
            local timings = {26.03, 26.62, 27.17, 27.73, 30.39, 30.99, 31.50, 32.1, 34.78, 35.35, 35.87, 36.5, 38.58, 39.12, 39.70, 40.18, 40.8}
            createEvents(timings, [[
            createLineWalls(5)
            pulse.bgTileOffset:run(s_getBGRotationOffset(), s_getBGRotationOffset() + 360, 50, easing.backOut)
            pulse.minRadius:run(80, 60, 50, easing.easeOut)
            pulse.scoreFloatingNumbers:run(11, 0, 60, easing.easeOut)
            pulse.skew:run(0.4, 0, 60, easing.easeOut)
            pulse.rotationSpeed:run(1.7, 0, 150, easing.backOut)
            pulseCustomWallsColor(math.random(20, 60), 0, math.random(20, 60), 0, 20)
            pulse.alpha3d:run(50, 3, 40, easing.easeOut)
            pulseTime = pulseTimePulse
            pulse.wallRightSkew:run(0, 0, 30, easing.backIn)
            pulse.wallRightAngle:run(-0.4, 0, 30, easing.backIn)
            pulse.wallLeftAngle:run(0.4, 0, 30, easing.backIn)
        ]])
        end,
        [1] = function()
            local timings = {28.24, 28.82, 29.35, 29.89, 32.62, 33.18, 33.71, 34.27, 36.98, 37.55, 38.08, 41.31, 41.88, 42.45, 42.96}
            createEvents(timings, [[
            createLineWalls(5)
            pulse.bgTileOffset:run(s_getBGRotationOffset(), s_getBGRotationOffset() - 360, 50, easing.backOut)
            pulse.scoreFloatingNumbers:run(8, 0, 60, easing.easeOut)
            pulse.minRadius:run(90, 50, 20, easing.easeOut)
            pulse.skew:run(-0.1, 0.2, 80, easing.backOut)
            pulse.rotationSpeed:run(-2, 0, 50, easing.backOut)
            pulseCustomWallsColor(0, math.random(10, 90), math.random(20, 60), -255, 20)
            pulse.alpha3d:run(50, 3, 40, easing.easeOut)
            pulse.additionalPlayerRadius:run(-15, 0, 100, easing.easeOut)
            pulse.playerWidthMult:run(0, 1, 120, easing.easeOut)
            pulseTime = pulseTimePulse
            pulse.wallLeftSkew:run(30, 0, 30, easing.backIn)
            pulse.wallLeftAngle:run(0.3, 0, 30, easing.backIn)
        ]])
        end,
        [2] = function()
            local timings = {43.24, 43.51, 43.74, 43.96, 44.28, 44.57, 44.85}
            createEvents(timings, [[
            createLineWalls(4, 50)
            pulse.bgTileOffset:run(s_getBGRotationOffset(), s_getBGRotationOffset() - 120 * getRndDir(), 50, easing.backOut)
            l_setRotation(l_getRotation() + 360 / l_getSides())
            pulse.rotationSpeed:run(-2, 0, 50, easing.backOut)
            pulse.scoreFloatingNumbers:run(4, 0, 60, easing.easeOut)
            pulse.alpha3d:run(100, 0, 40, easing.easeOut)
            pulse.skew:run(-0.3, 0, 50, easing.backOut)
            pulseCustomWallsColor(0, 0, 0, -255, 10)
            pulse.wallRightAngle:run(0.15, 0, 30, easing.backIn)
            pulse.wallLeftAngle:run(0.15, 0, 30, easing.backIn)
        ]])
        end
    },
    fourthPart = {
        [0] = function()
            local timings = {45.67, 46.75, 48.94, 50, 51.12, 53.30, 53.84, 55.5, 57.66, 58.45, 59.84}
            createEvents(timings, [[
            pulse.additionalPlayerRadius:run(-10, -8, 100, easing.easeOut)
            pulse.minRadius:run(130, 90, 30, easing.backOut)
            pulseCustomWallsColor(math.random(-30, 0), math.random(-30, 0), 0, 0, 20)
            pulse.alpha3d:run(5, 20, 40, easing.easeIn)
            pulse.spacing3d:run(15, 5, 40, easing.easeOut)
            pulse.scoreFloatingNumbers:run(11, 0, 60, easing.easeOut)
            pulse.playerHeightMult:run(2, 1, 60, easing.easeOut)
            pulseTime = pulseTimePulse
            pulse.shaderTimeMult:run(5, 1, 60, easing.easeOut)
            pulse.shaderColorVariance:run(0.3, 0.1, 60, easing.easeOut)
            createPulseWalls(40, 1.5, l_getRadiusMin(), 0, 0)
        ]])
        end,
        [1] = function()
            local timings = {46.22, 47.31, 48.39, 50.57, 51.7, 52.77, 54.95, 56.04, 57.12, 59.32, 60, 61.5}
            createEvents(timings, [[
            pulse.additionalPlayerRadius:run(0, -5, 50, easing.easeOut)
            pulse.minRadius:run(110, 80, 40, easing.backOut)
            pulse.rotationSpeed:run(getRndDir() * 1.5, 0, 100, easing.easeOut)
            pulseCustomWallsColor(-20, 0, 0, 0, 20)
            pulse.scoreFloatingNumbers:run(8, 0, 60, easing.easeOut)
            pulse.playerWidthMult:run(2, 1, 60, easing.easeOut)
            pulseTime = pulseTimePulse
            pulse.shaderTimeMult:run(4, 1, 60, easing.easeOut)
            pulse.shaderGridSize:run(10, 30, 180, easing.easeOut)
            pulse.alpha3d:run(5, 100, 40, easing.easeOut)
            pulse.spacing3d:run(6, 2, 40, easing.easeOut)
            pulse.shaderColorVariance:run(0, 0.2, 60, easing.easeOut)
        ]])
        end,
        [2] = function()
            local timings = {45.96, 48.04, 50.33, 53.06, 54.59, 57.02, 59.07}
            createEvents(timings, [[
            pulse.minRadius:run(130, 70, 40, easing.easeOut)
            pulse.scoreFloatingNumbers:run(15, 0, 60, easing.easeOut)
            pulse.shaderTimeMult:run(3, 1, 60, easing.easeOut)
        ]])
        end,
        [3] = function()
            local timings = {47.87, 48.03, 48.19, 52.24, 52.39, 52.53, 56.6, 56.73, 56.85, 60.98, 61.11, 61.26, 62.05, 62.19, 62.35}
            createEvents(timings, [[
            pulse.scoreFloatingNumbers:run(4, 0, 60, easing.easeOut)
            pulse.minRadius:run(100, 80, 30, easing.easeOut)
            pulseCustomWallsColor(0, 0, -20, 0, 20)
            l_setRotation(l_getRotation() + 360 / l_getSides())
            pulse.shaderTimeMult:run(2, 1, 60, easing.easeOut)
            pulse.shaderGridSize:run(20, 30, 30, easing.easeOut)
            pulse.alpha3d:run(10, 50, 40, easing.easeIn)
            pulse.spacing3d:run(-5, 5, 30, easing.easeOut)
            pulse.skew:run(-0.1, 0.1, 30, easing.easeOut)
        ]])
        end,
        [4] = function()
            local timings = {60.98, 61.11, 61.26, 62.05, 62.19, 62.35}
            createEvents(timings, [[
            pulse.scoreFloatingNumbers:run(3, 0, 60, easing.easeOut)
            l_setSides(l_getSides() - 1)
            pulse.shaderTimeMult:run(2, 1, 60, easing.easeOut)
        ]])
        end
    },
    fifthPart = {
        [0] = function()
            local timings = {63.15, 63.71, 64.79, 66.95, 67.45, 67.95, 68.6, 69.17, 71.86, 72.45, 72.96, 73.49, 73.99, 74.49, 74.99, 78.43, 79, 79.45, 80.08}
            createEvents(timings, [[
            pulse.additionalPlayerRadius:run(-5, -7, 50, easing.easeOut)
            pulse.playerHeightMult:run(2.5, 1, 60, easing.easeOut)
            pulse.scoreFloatingNumbers:run(16, 0, 60, easing.easeOut)
            pulseCustomWallsColor(-200, -200, -200, 0, 20)
            pulse.minRadius:run(90, 60, 40, easing.easeOut)  
            pulse.rotationSpeed:run(1.5, 0, 100, easing.easeOut) 
            pulse.alpha3d:run(20, 5, 30, easing.easeOut)
            pulse.spacing3d:run(10, 1, 20, easing.backIn)
            pulse.skew:run(0, 0.4, 90, easing.backOut)
            createPulseWalls(40, 3.5, 0, math.random(-1000, 1000), math.random(-1000, 1000))
            createPulseWalls(40, 3.5, 0, 0, 0)
            createLineWalls(4)
            pulse.shaderTimeMult:run(5, 1, 60, easing.easeOut)
            pulse.shaderBorderPulse:run(0.5, 3, 60, easing.easeOut)
            pulsingLineWalls(150, 500)
            pulsingLineWalls(150, -500)
            pulseTime = pulseTimePulse
        ]])
        end,
        [1] = function()
            local timings = {65.35, 65.89, 66.40, 69.7, 70.25, 70.77, 71.35, 75.66, 76.21, 76.76, 77.33}
            createEvents(timings, [[
            pulse.additionalPlayerRadius:run(-8, -5, 50, easing.easeOut)
            pulse.playerWidthMult:run(2.5, 1, 60, easing.easeOut)
            pulse.scoreFloatingNumbers:run(10, 0, 60, easing.easeOut)
            pulseCustomWallsColor(-200, -200, -200, 0, 20)
            pulse.minRadius:run(90, 60, 30, easing.backIn)
            pulse.rotationSpeed:run(-1.5, 0, 100, easing.easeOut)
            pulse.alpha3d:run(20, 5, 30, easing.easeOut)
            pulse.spacing3d:run(-10, -1, 20, easing.backIn)
            pulse.skew:run(0.65, 0.35, 60, easing.backOut)   
            createPulseWalls(40, 3.5, 0, math.random(-500, 500), math.random(-500, 500))
            pulse.shaderTimeMult:run(5, 1, 60, easing.easeOut)
            pulse.shaderBorderPulse:run(0.5, 3, 60, easing.easeOut)
            pulseTime = pulseTimePulse
        ]])
        end,
        [2] = function()
            local timings = {66.71, 70.77, 73.76, 75.45}
            createEvents(timings, [[
            pulse.scoreFloatingNumbers:run(10, 0, 60, easing.easeOut)
            pulse.minRadius:run(90, 50, 25, easing.backOut)  
            createPulseWalls(40, 4, 0, math.random(-1000, 1000), math.random(-1000, 1000))
            pulse.shaderTimeMult:run(10, 1, 60, easing.easeOut)
            pulse.shaderBorderPulse:run(0.2, 3, 60, easing.easeOut)
            pulse.playerWidthMult:run(0.2, 1, 30, easing.easeOut)
            pulseTime = pulseTimePulse
        ]])
        end,
        [3] = function()
            local timings = {64.25, 64.43, 64.51, 64.58, 64.72, 69.05, 69.15, 69.25, 73.04, 73.19, 73.34, 77.51, 77.65, 77.80}
            createEvents(timings, [[
            pulse.scoreFloatingNumbers:run(4, 0, 60, easing.easeOut)
            l_setRotation(l_getRotation() + 360 / l_getSides())
            pulse.minRadius:run(85, 60, 30, easing.easeOut)    
            createPulseWalls(40, 3, 0, math.random(-1000, 1000), math.random(-1000, 1000))
            createPulseWalls(10, 2, 0, math.random(-1000, 1000), math.random(-1000, 1000))
            pulse.shaderTimeMult:run(3, 1, 60, easing.easeOut)
            pulse.shaderBorderPulse:run(1., 3, 60, easing.easeOut)
            pulseTime = pulseTimePulse
        ]])
        end
    }
}

function createEvents(timings, action)
    local timeline = ct_create()
    for _, i in ipairs(timings) do
		ct_waitUntilS(timeline, offset + i)
		ct_eval(timeline, action)
	end
end

-- Returns coordinates (x, y) adjusted with the level rotation using polar coordinate math.
function getAbsolutePosition(x, y)
    local r, a = (x ^ 2 + y ^ 2) ^ 0.5, math.atan2(y, x)
    a = a + math.rad(l_getRotation())
    return r * math.cos(a), r * math.sin(a)
end