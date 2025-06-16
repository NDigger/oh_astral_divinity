-- include useful files
u_execScript("utils.lua")
u_execScript("astralDivinityTimelines.lua")
u_execScript("astralDivinityCustomWalls.lua")

THICKNESS = 60 -- I find this fitting but it can be edited of course. I'd not recommend making it smaller than 40
u_execScript("xxixstuff/levelConfig.lua")
u_execScript("xxixstuff/levelDifficulties.lua")

achievementUnlocked = false
hardAchievementUnlocked = false

levelCompletedMsg = '\n\n\n\n\n           ASTRAL DIVINITY\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n'
levelFailMsg = 'LEVEL FAILED'
overrideScore = 0
percent = 0
levelCompletionTime = 84.2

function onDeath()
    if l_getLevelTime() > 80.09 and l_getLevelTime() < levelCompletionTime - 0.02 then l_overrideScore("levelFailMsg") end
end

-- Here we go
minRadius = interpolation:new(l_setRadiusMin)
rotationSpeed = interpolation:new(l_setRotationSpeed)
bgTileOffset = interpolation:new(s_setBGRotationOffset)
scoreFloatingNumbers = interpolation:new()
skew = interpolation:new(s_set3dSkew)
spacing3d = interpolation:new(s_set3dSpacing)
alpha3d = interpolation:new(s_set3dAlphaMult)
additionalPlayerRadius = interpolation:new()
playerWidthMult = interpolation:new()
playerHeightMult = interpolation:new()
shaderTimeMult = interpolation:new()
wallLeftSkew = interpolation:new()
wallRightSkew = interpolation:new()
wallLeftAngle = interpolation:new()
wallRightAngle = interpolation:new()
shaderBorderPulse = interpolation:new()
shaderGridSize = interpolation:new()
shaderColorVariance = interpolation:new()

-- Values preset (for objects that don't use setters)
shaderGridSize.value = 20
shaderColorVariance.value = 0.1
playerWidthMult.value = 1
playerHeightMult.value = 1
additionalPlayerRadius.value = -5
shaderTimeMult.value = 1

pulseTime = 0
pulseTimePulse = 30

totalTime = 0

function onUpdate(mFrameTime)
    for _, instance in pairs(interpolation.instances) do instance:update(mFrameTime) end
    overrideScore = simplifyFloat(l_getLevelTime(), simplifyFloat(scoreFloatingNumbers.value, 0))
    percent = tostring(simplifyFloat(
        l_getLevelTime() / levelCompletionTime * 100, 
        simplifyFloat(scoreFloatingNumbers.value, 0)
    )) .. "%"
    pulseTime = pulseTime - mFrameTime
    totalTime = totalTime + mFrameTime
    accuracy = tostring(simplifyFloat(
        (totalTime - deathFrames) / totalTime * 100, 
        simplifyFloat(scoreFloatingNumbers.value, 0)
    )) .. "%"
    if pulseTime > 0 then s_setPulseMin(-2) else s_setPulseMin(1) end
    updateCustomWalls(mFrameTime)
end

deathFrames = 0
function onPreDeath()
    if deathFrames > 1 then l_addTracked("accuracy", "accuracy") end
    deathFrames = deathFrames + 1
end


playerArrow() -- Creating fake arrow which I will be stretching

difficulty = ""
speed = 0
rotSpeed = 0
rotSpeedTimeMult = 1
shaderTimeIncMult = 1
timerPulseMult = 1
pentagonDecorationsRotationMult = 1
pulseLineWallsHeightMult = 1
playerDeformationMult = 1
pulseSkewMult = 1
speedOnPart = {}

speedMult = interpolation:new(l_setSpeedMult)
function onInit()
    local diff = simplifyFloat(u_getDifficultyMult(), 2)
    if diff == 0.99 then 
        speed = 2
        rotSpeed = 0.8
        rotSpeedTimeMult = 0.9
        --
        shaderTimeIncMult = 0.5
        timerPulseMult = 0.7
        pentagonDecorationsRotationMult = 0.6
        pulseLineWallsHeightMult = 0.8
        playerDeformationMult = 0.8
        pulseSkewMult = 0.8
        difficulty = "friendly"
    elseif diff == 1 then 
        speed = 2.5
        rotSpeed = 1.1
        rotSpeedTimeMult = 1
        --
        shaderTimeIncMult = 0.9
        timerPulseMult = 0.9
        pentagonDecorationsRotationMult = 1
        pulseLineWallsHeightMult = 1
        playerDeformationMult = 1
        pulseSkewMult = 1
        difficulty = "sane"
    elseif diff == 1.01 then 
        speed = 2.9
        rotSpeed = 1.4
        rotSpeedTimeMult = 1.15
        --
        shaderTimeIncMult = 1.3
        timerPulseMult = 1.1
        pentagonDecorationsRotationMult = 1.5
        pulseLineWallsHeightMult = 1.1
        playerDeformationMult = 1.2
        pulseSkewMult = 1.15
        difficulty = "insane"
    elseif diff == 1.02 then 
        speed = 3.4
        rotSpeed = 1.6
        rotSpeedTimeMult = 1.25
        --
        shaderTimeIncMult = 1.6
        timerPulseMult = 1.25
        pentagonDecorationsRotationMult = 2.25
        pulseLineWallsHeightMult = 1.2
        playerDeformationMult = 1.4
        pulseSkewMult = 1.3
        difficulty = "elite"
    elseif diff == 1.03 then 
        speed = 3.95
        rotSpeed = 1.9
        rotSpeedTimeMult = 1.35
        --
        shaderTimeIncMult = 2
        timerPulseMult = 1.5
        pentagonDecorationsRotationMult = 3.25
        pulseLineWallsHeightMult = 1.3
        playerDeformationMult = 1.6
        difficulty = "divine"
    end
    speedOnPart = {
        speed,
        speed * 0.9,
        speed * 0.77,
        speed * 0.71,
        speed,
    }
    l_setSpeedMult(speedOnPart[1])
    l_setSpeedInc(0)
    l_setSpeedMax(4.75)
    l_setDelayMult(1.4)

    l_setRotationSpeed(0)

    l_setDelayInc(0)
    l_setFastSpin(0)
    makeTriangle()
    for i = 0, l_getSides() - 1 do playerWall(i) end
    createOtherPlayerWalls()

    l_setSidesMax(6)
    l_setIncTime(999999)
    l_setDarkenUnevenBackgroundChunk(false)
    l_setIncEnabled(false)
    l_setShowPlayerTrail(false)

    l_setPulseMin(70)
    l_setPulseMax(90)
    l_setPulseSpeed(0)
    l_setPulseSpeedR(0)
    l_setPulseDelayMax(0)

    l_setBeatPulseMax(0)
    l_setBeatPulseDelayMax(0)
    l_setBeatPulseSpeedMult(0)
    l_overrideScore("overrideScore")
    l_addTracked('difficulty', 'difficulty')
    l_addTracked('percent', 'percent')

    u_setFlashColor(0, 0, 0)
    u_setFlashEffect(255)

    l_setSwapEnabled(false)
	l_set3dRequired(true)
	a_syncMusicToDM(false)

    backgroundShader = shdr_getShaderId("divinityBackground.frag")
    backgroundShaderDrop = shdr_getShaderId("divinityBackgroundDrop.frag")
    transparentShader = shdr_getShaderId("transparent.frag")
    backgroundShaderLastPart = shdr_getShaderId("divinityBackgroundLastPart.frag")
    backgroundShaderFourthPart = shdr_getShaderId("divinityBackgroundFourthPart.frag")
    shdr_setActiveFragmentShader(0, backgroundShader)
    shdr_setActiveFragmentShader(2, transparentShader)
    shdr_setActiveFragmentShader(5, transparentShader)
    shdr_setActiveFragmentShader(6, transparentShader)
    shdr_setActiveFragmentShader(7, transparentShader)
    shdr_setActiveFragmentShader(3, transparentShader)
end

shaderTime = 0 -- It pulses when I ask it to do so. Quite useful.
function onRenderStage(mFrameTime)
    local r, g, b, a = mainColor.r.value / 255, mainColor.g.value / 255, mainColor.b.value / 255, mainColor.a.value / 255
    shaderTime = shaderTime + mFrameTime * shaderTimeMult.value / 1000 * shaderTimeIncMult
    shdr_setUniformFVec2(backgroundShader, "u_resolution", u_getWidth(), u_getHeight())
    shdr_setUniformF(backgroundShader, "u_time", shaderTime)
    shdr_setUniformFVec4(backgroundShader, "color", r, g, b, a) 

    shdr_setUniformFVec2(backgroundShaderDrop, "u_resolution", u_getWidth(), u_getHeight())
    shdr_setUniformF(backgroundShaderDrop, "u_time", shaderTime)
    shdr_setUniformFVec4(backgroundShaderDrop, "color", r, g, b, a) 

    shdr_setUniformFVec2(backgroundShaderLastPart, "u_resolution", u_getWidth(), u_getHeight())
    shdr_setUniformF(backgroundShaderLastPart, "u_time", shaderTime)
    shdr_setUniformF(backgroundShaderLastPart, "borderPulse", shaderBorderPulse.value)
    shdr_setUniformFVec4(backgroundShaderLastPart, "color", r, g, b, a) 

    shdr_setUniformFVec2(backgroundShaderFourthPart, "u_resolution", u_getWidth(), u_getHeight())
    shdr_setUniformF(backgroundShaderFourthPart, "u_time", shaderTime)
    shdr_setUniformFVec4(backgroundShaderFourthPart, "color", r, g, b, a) 
    shdr_setUniformF(backgroundShaderFourthPart, "gridSize", shaderGridSize.value) 
    shdr_setUniformF(backgroundShaderFourthPart, "colorVariance", shaderColorVariance.value)
end

function onLoad()
    -- LOAD EVENTS FROM astralDivinityTimelines.lua
    for _, arr in pairs(globalTimings) do
        for _, fn in pairs(arr) do fn() end
    end

    ---------------------------------------------------------------------
    -- HERE ARE ONLY EVENTS WHICH HAPPEN ONE TIME
    ---------------------------------------------------------------------

    --------------------------------------------------------------------------
    -- First Part
    --------------------------------------------------------------------------
    -- Symbols 1 
    e_waitUntilS(offset + 3.68);e_eval([[
        createSymbol(4, 0, 280)
        l_setSpeedMult(0)
        t_clear()
        t_wait(calcHalfSidesDelay() * 1.75)
        u_setFlashColor(255, 255, 255)
    ]])
    e_waitUntilS(offset + 3.96);e_eval([[
        createSymbol(0, 200, 280)
        createSymbol(2, -200, 280)
        applyToSymbol(2, function(cw) cw.x:run(cw.x.value - 100, cw.x.value, 25, easing.easeOut) end)
        applyToSymbol(3, function(cw) cw.x:run(cw.x.value + 100, cw.x.value, 25, easing.easeOut) end)
    ]])
    e_waitUntilS(offset + 4.09);e_eval([[
        createSymbol(7, 400, 280)
        createSymbol(7, -400, 280)
        applyToSymbol(4, function(cw) cw.x:run(cw.x.value - 200, cw.x.value, 25, easing.easeOut) end)
        applyToSymbol(5, function(cw) cw.x:run(cw.x.value + 200, cw.x.value, 25, easing.easeOut) end)
        l_setSpeedMult(speedOnPart[1])
    ]])
    e_waitUntilS(offset + 4.23);e_eval([[
        rotatePlayerWalls(math.ceil(customWall.player[1].rotation.value / math.pi / l_getSides()) * math.pi / l_getSides() - math.pi, 30, easing.easeOut)
    ]])
    e_waitUntilS(offset + 7.9);e_eval('applyToSymbol(4, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 50, easing.backIn) end)')
    e_waitUntilS(offset + 7.96);e_eval('applyToSymbol(2, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 50, easing.backIn) end)')
    e_waitUntilS(offset + 8.02);e_eval('applyToSymbol(1, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 50, easing.backIn) end)')
    e_waitUntilS(offset + 8.08);e_eval('applyToSymbol(3, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 50, easing.backIn) end)')
    e_waitUntilS(offset + 8.14);e_eval('applyToSymbol(5, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 50, easing.backIn) end)')

    --------------------------------------------------------------------------
    -- Second Part (Drop)
    --------------------------------------------------------------------------
    e_waitUntilS(offset + 8.45);e_eval([[
        speedMult:run(l_getSpeedMult(), speedOnPart[2], 60, easing.linear)
        s_setStyle("astralDivinityDrop")
        shdr_setActiveFragmentShader(0, backgroundShaderDrop)
        setMainColor(225, 170, 245, 255)
        setCustomWallColorVariance(20, 0, 10, 0)
        u_setFlashEffect(255)
        applyMainColor()
        makeHexagon()
        createPentagonDecoration(42, 620, 340, redColor)
        createPentagonDecoration(40, 540, 342, redColor)
        createPentagonDecoration(38, 460, 344, redColor)
        createPentagonDecoration(36, 380, 346, redColor)
        createPentagonDecoration(34, 305, 348, redColor)
        createPentagonDecoration(32, 230, 350, redColor)
        createPentagonDecoration(30, 155, 352, redColor)
        createPentagonDecoration(28, 82, 354, redColor)
        createPentagonDecoration(26, 16, 356, redColor)
        createPentagonDecoration(24, -53, 358, redColor)
    ]])
    -- Symbols 1
    e_waitUntilS(offset + 12.18);e_eval([[
        deleteSymbols()
        createSymbol(7, 320, -330)
    ]])
    e_waitUntilS(offset + 12.32);e_eval('createSymbol(5, 470, -330)')
    e_waitUntilS(offset + 12.45);e_eval([[
        createSymbol(4, 620, -330)
        applyToSymbol(3, function(cw) cw.x:run(cw.x.value, cw.x.value + 500, 60, easing.backIn) end) 
    ]])
    e_waitUntilS(offset + 12.54);e_eval([[
        applyToSymbol(2, function(cw) cw.x:run(cw.x.value, cw.x.value + 500, 60, easing.backIn) end)
        removePentagonDecorationPart()
    ]])
    e_waitUntilS(offset + 12.63);e_eval([[
        applyToSymbol(1, function(cw) cw.x:run(cw.x.value, cw.x.value + 500, 60, easing.backIn) end)
        removePentagonDecorationPart()
    ]])
    -- Symbols 2
    e_waitUntilS(offset + 20.89);e_eval([[
        deleteSymbols()
        createSymbol(4, -620, 250)
    ]])
    e_waitUntilS(offset + 20.98);e_eval('createSymbol(1, -470, 250)')
    e_waitUntilS(offset + 21.1);e_eval([[
        createSymbol(9, -320, 250)
        removePentagonDecorationPart()
    ]])
    e_waitUntilS(offset + 21.15);e_eval('applyToSymbol(3, function(cw) cw.x:run(cw.x.value, cw.x.value - 500, 60, easing.backIn) end)')
    e_waitUntilS(offset + 21.24);e_eval('applyToSymbol(2, function(cw) cw.x:run(cw.x.value, cw.x.value - 500, 60, easing.backIn) end)')
    e_waitUntilS(offset + 21.33);e_eval('applyToSymbol(1, function(cw) cw.x:run(cw.x.value, cw.x.value - 500, 60, easing.backIn) end)')

    -- Symbols 3
    e_waitUntilS(offset + 25.19);e_eval([[
        deleteSymbols()
        createSymbol(1, -100, 250)
    ]])
    e_waitUntilS(offset + 25.34);e_eval('createSymbol(3, 100, 250)')

    e_waitUntilS(offset + 25.55);e_eval('applyToSymbol(2, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 60, easing.backIn) end)')
    e_waitUntilS(offset + 25.65);e_eval('applyToSymbol(1, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 60, easing.backIn) end)')

    --------------------------------------------------------------------------
    -- Third Part
    --------------------------------------------------------------------------
    e_waitUntilS(offset + 25.93);e_eval([[
        speedMult:run(l_getSpeedMult(), speedOnPart[3], 60, easing.linear)
        s_setStyle("astralDivinityThirdPart")
        makePentagon()
        u_setFlashEffect(255)
        shdr_resetActiveFragmentShader(0)
        setMainColor(195, 195, 240, 255)
        setCustomWallColorVariance(20, 10, 0, 0)
        applyMainColor()
        for i = 0, 34 do
            createPentagonDecoration(170 + i % 2 * 55, math.sin(i/4) * 920, math.cos(i/4) * 660, mainColor, math.random(50, 150)/100) 
        end
    ]])

    e_waitUntilS(offset + 43.24);e_eval([[
        deleteSymbols()
        createSymbol(1, -370, -250)
        createSymbol(1, -520, -250)
        applyToSymbol(1, function(cw) cw.y:run(cw.y.value + 100, cw.y.value, 60, easing.backOut); cw.x:run(cw.x.value + 130, cw.x.value, 130, easing.backOut) end)
        applyToSymbol(2, function(cw) cw.y:run(cw.y.value - 100, cw.y.value, 60, easing.backOut); cw.x:run(cw.x.value - 160, cw.x.value, 130, easing.backOut) end)
    ]]) 
    e_waitUntilS(offset + 43.51);e_eval([[
        createSymbol(2, -370, 0)
        createSymbol(9, -520, 0)
        applyToSymbol(3, function(cw) cw.y:run(cw.y.value - 20, cw.y.value, 60, easing.backOut); cw.x:run(cw.x.value + 70, cw.x.value, 130, easing.backOut) end)
        applyToSymbol(4, function(cw) cw.y:run(cw.y.value - 140, cw.y.value, 60, easing.backOut); cw.x:run(cw.x.value - 160, cw.x.value, 130, easing.backOut) end)
    ]]) 
    e_waitUntilS(offset + 43.74);e_eval([[
        createSymbol(3, -370, 250)
        createSymbol(6, -520, 250)
        applyToSymbol(5, function(cw) cw.y:run(cw.y.value - 170, cw.y.value, 60, easing.backOut); cw.x:run(cw.x.value + 30, cw.x.value, 130, easing.backOut) end)
        applyToSymbol(6, function(cw) cw.y:run(cw.y.value - 130, cw.y.value, 60, easing.backOut); cw.x:run(cw.x.value - 170, cw.x.value, 130, easing.backOut) end)
    ]]) 
    e_waitUntilS(offset + 43.96);e_eval([[
        createSymbol(4, 370, -250)
        createSymbol(0, 520, -250)
        applyToSymbol(7, function(cw) cw.y:run(cw.y.value + 100, cw.y.value, 60, easing.backOut); cw.x:run(cw.x.value + 60, cw.x.value, 130, easing.backOut) end)
        applyToSymbol(8, function(cw) cw.y:run(cw.y.value - 130, cw.y.value, 60, easing.backOut); cw.x:run(cw.x.value - 250, cw.x.value, 130, easing.backOut) end)
    ]]) 
    e_waitUntilS(offset + 44.28);e_eval([[
        createSymbol(5, 370, 0)
        createSymbol(10, 520, 0)
        applyToSymbol(9, function(cw) cw.y:run(cw.y.value + 120, cw.y.value, 60, easing.backOut); cw.x:run(cw.x.value + 175, cw.x.value, 130, easing.backOut) end)
        applyToSymbol(10, function(cw) cw.y:run(cw.y.value - 10, cw.y.value, 60, easing.backOut); cw.x:run(cw.x.value - 15, cw.x.value, 130, easing.backOut) end)
    ]]) 
    e_waitUntilS(offset + 44.57);e_eval([[
        createSymbol(7, 370, 250)
        createSymbol(8, 520, 250)
        applyToSymbol(11, function(cw) cw.y:run(cw.y.value + 130, cw.y.value, 60, easing.backOut); cw.x:run(cw.x.value - 20, cw.x.value, 130, easing.backOut) end)
        applyToSymbol(12, function(cw) cw.y:run(cw.y.value - 60, cw.y.value, 60, easing.backOut); cw.x:run(cw.x.value + 80, cw.x.value, 130, easing.backOut) end)
    ]]) 
    e_waitUntilS(offset + 44.85);e_eval([[applyToAllSymbols(function(cw) cw.y:run(cw.y.value, cw.y.value + math.random(-2000, 2000), 150, easing.backIn); cw.x:run(cw.x.value, cw.x.value + math.random(-3000, 3000), 100, easing.backIn) end)]])

    --------------------------------------------------------------------------
    -- Fourth Part
    --------------------------------------------------------------------------
    e_waitUntilS(offset + 45.47);e_eval([[
        s_setStyle("astralDivinityFourthPart")
        speedMult:run(l_getSpeedMult(), speedOnPart[4], 60, easing.linear)
        removePentagonDecorations()
        removeRotatingCircles()
        shdr_setActiveFragmentShader(0, backgroundShaderFourthPart)
        pulsingLineWalls(150, 0)
        deleteSymbols()
        s_setBGRotationOffset(0)
        u_setFlashEffect(255)
        makeOctagon()
        setMainColor(225, 200, 205, 255)
        setCustomWallColorVariance(30, 10, 10, 0)
        skew:run(0, 0.2, 100, easing.backOut)
        rotationSpeed:run(-2, 0, 100, easing.backOut)  
        applyMainColor()
        for i = 1, 50 do createRotatingCircle(4, 700, 300, math.random(0, 314)) end
        for i = 1, 20 do createRotatingCircle(1, 300, 50, i / 10, 3) end
        for i = 1, 20 do createRotatingCircle(1, 300, 50, i / 10 + math.pi, 3) end
    ]]) -- for i = 1, 3 do createRotatingCircle(2, i * 66, i * 200, i, i, 60) end
    e_waitUntilS(offset + 47.87);e_eval([[
        createRotatingCircle(0.5, 0, 230, 0, 0, 40)
        pulsingLineWalls(1, 0, -730, 1000, 1000, 40)
        pulsingLineWalls(1, 0, 650, 1000, 1000, 40)
    ]])
    e_waitUntilS(offset + 48.03);e_eval([[
        createRotatingCircle(0.7, 0, 240, 0, 0, 40)
        pulsingLineWalls(1, 0, -680, 1000, 1000, 40)
        pulsingLineWalls(1, 0, 600, 1000, 1000, 40)
    ]]) 
    e_waitUntilS(offset + 48.19);e_eval([[
        createRotatingCircle(1, 0, 250, 0, 0, 40)
        pulsingLineWalls(1, 0, -630, 1000, 1000, 40)
        pulsingLineWalls(1, 0, 550, 1000, 1000, 40)
    ]])
    e_waitUntilS(offset + 52.24);e_eval([[
        createRotatingCircle(5, 0, 450, 0, 0, 40)
        pulsingLineWalls(1, 0, -730, 1000, 1000, 40)
        pulsingLineWalls(1, 0, 650, 1000, 1000, 40)
    ]])
    e_waitUntilS(offset + 52.39);e_eval([[
        createRotatingCircle(5, 0, 470, 0, 0, 40)
        pulsingLineWalls(1, 0, -680, 1000, 1000, 40)
        pulsingLineWalls(1, 0, 600, 1000, 1000, 40)
    ]])
    e_waitUntilS(offset + 52.53);e_eval([[
        createRotatingCircle(5, 0, 490, 0, 0, 40)
        pulsingLineWalls(1, 0, -630, 1000, 1000, 40)
        pulsingLineWalls(1, 0, 550, 1000, 1000, 40)
    ]])
    e_waitUntilS(offset + 53.30);e_eval([[
        createSymbol(2, -300, -40)
        applyToSymbol(1, function(cw) cw.y:run(cw.y.value + 30, cw.y.value, 60, easing.easeOut) end)
        pulsingLineWalls(1, 120, -2200, 15, 15, 2500)
]])
    e_waitUntilS(offset + 53.84);e_eval([[
        createSymbol(9, 300, -40)
        applyToSymbol(2, function(cw) cw.y:run(cw.y.value + 30, cw.y.value, 60, easing.easeOut) end)
        pulsingLineWalls(1, -120, -2200, 15, 15, 2500)
    ]])
    e_waitUntilS(offset + 54.25);e_eval([[
        makeDecagon()
        u_setFlashEffect(255)
        deleteSymbols()
        createPentagonDecoration(11, -270, -270)
        createPentagonDecoration(11, -270, 270)
        createPentagonDecoration(11, 270, -270)
        createPentagonDecoration(11, 270, 270)
        for i = 1, 10 do 
            createPentagonDecoration(100, -750, i * 140 - 500) 
            createPentagonDecoration(100, 750, i * 140 - 500, mainColor, math.pi)
        end
    ]])
    e_waitUntilS(offset + 56.6);e_eval([[
        createRotatingCircle(1.3, 0, 350, 0, 0, 40)
        pulsingLineWalls(1, 0, -680, 1000, 1000, 40)
        pulsingLineWalls(1, 0, 600, 1000, 1000, 40)
    ]])
    e_waitUntilS(offset + 56.73);e_eval([[
        createRotatingCircle(0.9, 0, 360, 0, 0, 40)
        pulsingLineWalls(1, 0, -630, 1000, 1000, 40)
        pulsingLineWalls(1, 0, 550, 1000, 1000, 40)
    ]])
    e_waitUntilS(offset + 56.85);e_eval([[
        createRotatingCircle(0.7, 0, 370, 0, 0, 40)
        pulsingLineWalls(1, 0, -580, 1000, 1000, 40)
        pulsingLineWalls(1, 0, 500, 1000, 1000, 40)
    ]])
    e_waitUntilS(offset + 60.98);e_eval([[
        createRotatingCircle(3, 0, 510, 0, 0, 40)
        pulsingLineWalls(1, 0, -680, 1000, 1000, 40)
        pulsingLineWalls(1, 0, 600, 1000, 1000, 40)
    ]])
    e_waitUntilS(offset + 61.11);e_eval([[
        createRotatingCircle(3, 0, 515, 0, 0, 40)
        pulsingLineWalls(1, 0, -630, 1000, 1000, 40)
        pulsingLineWalls(1, 0, 550, 1000, 1000, 40)
    ]])
    e_waitUntilS(offset + 61.26);e_eval([[
        createRotatingCircle(3, 0, 520, 0, 0, 40)
        pulsingLineWalls(1, 0, -580, 1000, 1000, 40)
        pulsingLineWalls(1, 0, 500, 1000, 1000, 40)
    ]])
    e_waitUntilS(offset + 62.05);e_eval([[
        createRotatingCircle(0.5, 0, 200, 0, 0, 40)
        pulsingLineWalls(1, 0, -650, 400, 400, 100)
        pulsingLineWalls(1, 0, 510, 400, 400, 100)
    ]])
    e_waitUntilS(offset + 62.19);e_eval([[
        createRotatingCircle(0.8, 0, 190, 0, 0, 40)
        pulsingLineWalls(1, 0, -570, 400, 400, 100)
        pulsingLineWalls(1, 0, 400, 400, 400, 100)
    ]])
    e_waitUntilS(offset + 62.35);e_eval([[
        createRotatingCircle(1.2, 0, 180, 0, 0, 40)
        pulsingLineWalls(1, 0, -460, 400, 400, 100)
        pulsingLineWalls(1, 0, 290, 400, 400, 100)
    ]])
    e_waitUntilS(offset + 62);e_eval([[
        skew:run(0, 0.3, 60, easing.backIn)
        alpha3d:run(50, 5, 60, easing.easeOut)
    ]])
    e_waitUntilS(offset + 62.30);e_eval([[
        deleteSymbols()
        createSymbol(1, -80, 250)
    ]])
    e_waitUntilS(offset + 62.50);e_eval([[
        createSymbol(2, 80, 250)
        applyToSymbol(1, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 75, easing.backIn) end)
    ]])
    e_waitUntilS(offset + 62.60);e_eval('applyToSymbol(2, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 75, easing.backIn) end)')
    
    --------------------------------------------------------------------------
    -- Fifth Part
    --------------------------------------------------------------------------
    e_waitUntilS(offset + 63);e_eval([[
        s_setStyle("astralDivinityFifthPart")
        removePentagonDecorations()
        deleteBasicWalls()
        removeRotatingCircles()
        deleteSymbols()
        speedMult:run(l_getSpeedMult(), speedOnPart[5], 60, easing.linear)
        shdr_setActiveFragmentShader(0, backgroundShaderLastPart)
        u_setFlashEffect(255)
        setMainColor(245, 245, 245, 255)
        setCustomWallColorVariance(10, 10, 10, 0)
        applyMainColor()
        makePentagon()
        for i = 1, 6 do 
            createRotatingCircle(5, 250, 50, i/6*math.pi*2, 4, math.random(3, 10))
            fakePlayerArrow(250, i/6*math.pi*2, 4, 70, 0.2, 9)
        end
        for i = 1, 9 do 
            createRotatingCircle(3, 450, 40, i/9*math.pi*2, 3, math.random(3, 10)) 
            fakePlayerArrow(450, i/9*math.pi*2, 3, 60, 0.16, 7.5)
        end
        for i = 1, 12 do 
            createRotatingCircle(1, 600, 30, i/12*math.pi*2, 2, math.random(3, 10)) 
            fakePlayerArrow(600, i/12*math.pi*2, 2, 50, 0.12, 6)
        end
        for i = 1, 15 do 
            createRotatingCircle(1, 730, 20, i/15*math.pi*2, 1, math.random(3, 10))
            fakePlayerArrow(730, i/15*math.pi*2, 1, 40, 0.08, 4.5) 
        end
        for i = 1, 18 do 
            createRotatingCircle(2, 800, 20, i/18*math.pi*2, 0, math.random(3, 10)) 
            fakePlayerArrow(800, i/18*math.pi*2, 0, 30, 0.08, 4.5)
        end
        for i = 1, 21 do 
            createRotatingCircle(3, 850, 20, i/21*math.pi*2, -0.5, math.random(3, 10))
            fakePlayerArrow(850, i/21*math.pi*2, -0.5, 30, 0.12, 6) 
        end
    ]])
    e_waitUntilS(offset + 63.01);e_eval('makeSquare()')

    -- END
    e_waitUntilS(offset + 80.09); e_eval([[
        shaderTimeMult:run(1, 0, 300)
        spacing3d:run(s_get3dSpacing(), 0, 260)
        rotationSpeed:run(1, 0, 220)
    ]])
    e_waitUntilS(offset + 81.69); e_eval([[
    ]])
    e_waitUntilS(offset + 82.1); e_eval('speedMult:run(l_getSpeedMult(), 0 , 180)')
    e_waitUntilS(offset + levelCompletionTime);e_eval([[
        cw_clear()
        shdr_resetActiveFragmentShader(2)
        shdr_setActiveFragmentShader(1, transparentShader)
        shdr_setActiveFragmentShader(2, transparentShader)
        shdr_setActiveFragmentShader(3, transparentShader)
        shdr_setActiveFragmentShader(4, transparentShader)
        shdr_setActiveFragmentShader(5, transparentShader)
        shdr_setActiveFragmentShader(6, transparentShader)
        local accuracy = tostring(simplifyFloat(
            (totalTime - deathFrames) / totalTime * 100, 
            simplifyFloat(3, 0)
        )) .. "%"
        if deathFrames > 0 then
            s_setStyle("astralDivinityEndBlack")
        else
            s_setStyle("astralDivinityEndWhite")
        end
        l_overrideScore('levelCompletedMsg')
        local str = "\n\n\n\n\n\n\n\nDIFFICULTY: "..difficulty
        if deathFrames > 0 then
            str = str .. "\nACCURACY: " .. tostring(accuracy)
        end
        e_messageAddImportant(str, 999999)
        e_kill()
    ]])
end
