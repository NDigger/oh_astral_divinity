-- include useful files
u_execScript("utils.lua")
u_execScript("common.lua")
u_execScript("usefulpatterns.lua")
u_execScript("astralDivinityTimelines.lua")
u_execScript("astralDivinityCustomWalls.lua")

THICKNESS = 60 -- I find this fitting but it can be edited of course. I'd not recommend making it smaller than 40
function addPattern(mKey) -- Insert your fun here
    if mKey == 0 then pTunnelExtendedPD(2, 35, 15)
    elseif mKey == 1 then pLRBarrage(math.random(1, 2), 6, 5)
    elseif mKey == 2 then pInverseBarrageExtendedPD(math.random(0, 1), 8, 5)
    elseif mKey == 3 then pRandomBarrageLR(math.random(1, 2), 5, 5)
    end
end

keys = { 0 }
shuffle(keys)
index = 0
achievementUnlocked = false
hardAchievementUnlocked = false

function onLoad()
    -- LOAD EVENTS FROM astralDivinityTimelines.lua
    for _, arr in pairs(globalTimings) do
        for _, fn in pairs(arr) do fn() end
    end

    ---------------------------------------------------------------------
    -- HERE ARE ONLY EVENTS WHICH HAPPEN ONE TIME
    ---------------------------------------------------------------------

    -- First Part
    -- Symbols 1 
    e_waitUntilS(offset + 3.68);e_eval([[
        createSymbol(4, 0, 280)
        l_setSpeedMult(0)
        u_setFlashColor(255, 255, 255)
    ]])
    e_waitUntilS(offset + 3.96);e_eval([[
        createSymbol(0, 200, 280)
        createSymbol(2, -200, 280)
    ]])
    e_waitUntilS(offset + 4.09);e_eval([[
        createSymbol(7, 400, 280)
        createSymbol(7, -400, 280)
        l_setSpeedMult(2)
    ]])
    e_waitUntilS(offset + 8);e_eval('applyToAllSymbols(function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 30, easing.backIn) end)')

    -- Second Part (Drop)
    e_waitUntilS(offset + 8.57);e_eval([[ 
        s_setStyle("astralDivinityDrop")
        shdr_setActiveFragmentShader(0, backgroundShaderDrop)
        setMainColor(225, 170, 245, 255)
        setCustomWallColorVariance(20, 0, 10, 0)
        u_setFlashEffect(255)
        applyMainColor()
        l_setSides(6)
        createPentagonDecoration(42, 620, 340, redColor)
        createPentagonDecoration(40, 540, 342, redColor)
        createPentagonDecoration(38, 460, 344, redColor)
        createPentagonDecoration(36, 380, 346, redColor)
        createPentagonDecoration(34, 305, 348, redColor)
        createPentagonDecoration(32, 230, 350, redColor)
        createPentagonDecoration(30, 155, 352, redColor)
        createPentagonDecoration(28, 82, 354, redColor)
    ]])
    -- Symbols 1
    e_waitUntilS(offset + 12.18);e_eval([[
        deleteSymbols()
        createSymbol(7, 320, -330)
    ]])
    e_waitUntilS(offset + 12.32);e_eval('createSymbol(5, 470, -330)')
    e_waitUntilS(offset + 12.45);e_eval([[
        createSymbol(4, 620, -330)
        applyToSymbol(3, function(cw) cw.x:run(cw.x.value, cw.x.value + 500, 30, easing.backIn) end) 
    ]])
    e_waitUntilS(offset + 12.54);e_eval([[
        applyToSymbol(2, function(cw) cw.x:run(cw.x.value, cw.x.value + 500, 30, easing.backIn) end)
        removePentagonDecorationPart()
    ]])
    e_waitUntilS(offset + 12.63);e_eval([[
        applyToSymbol(1, function(cw) cw.x:run(cw.x.value, cw.x.value + 500, 30, easing.backIn) end)
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
    ]])
    e_waitUntilS(offset + 21.15);e_eval('applyToSymbol(3, function(cw) cw.x:run(cw.x.value, cw.x.value - 500, 30, easing.backIn) end)')
    e_waitUntilS(offset + 21.24);e_eval('applyToSymbol(2, function(cw) cw.x:run(cw.x.value, cw.x.value - 500, 30, easing.backIn) end)')
    e_waitUntilS(offset + 21.33);e_eval('applyToSymbol(1, function(cw) cw.x:run(cw.x.value, cw.x.value - 500, 30, easing.backIn) end)')

    -- Symbols 3
    e_waitUntilS(offset + 25.19);e_eval([[
        deleteSymbols()
        createSymbol(1, -100, 250)
    ]])
    e_waitUntilS(offset + 25.34);e_eval('createSymbol(3, 100, 250)')

    e_waitUntilS(offset + 25.55);e_eval('applyToSymbol(2, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 30, easing.backIn) end)')
    e_waitUntilS(offset + 25.65);e_eval('applyToSymbol(1, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 30, easing.backIn) end)')

    -- Third Part
    e_waitUntilS(offset + 25.93);e_eval([[
        l_setSides(5)
        u_setFlashEffect(255)
        shdr_resetActiveFragmentShader(0)
        setMainColor(195, 210, 245, 255)
        setCustomWallColorVariance(0, 20, 10, 0)
        applyMainColor()
        for i = 0, 30 do
            createPentagonDecoration(math.random(80, 120), i * 150 - 2500 + math.random(-10, 10), 490 + i * 2, whiteColor)
            createPentagonDecoration(math.random(80, 120), i * 150 - 2500 + math.random(-10, 10), -490 - i * 2, whiteColor)
        end
        for i = 0, 10 do
            createPentagonDecoration(20 + i % 2 * 15, -500, i * 78 - 390, whiteColor)
            createPentagonDecoration(20 + i % 2 * 15, 500, i * 78 - 390, whiteColor)

            createPentagonDecoration(50 + i % 2 * 35, -700, i * 78 - 390, whiteColor)
            createPentagonDecoration(50 + i % 2 * 35, 700, i * 78 - 390, whiteColor)
        end
    ]])

    e_waitUntilS(offset + 43.24);e_eval([[
        deleteSymbols()
        removePentagonDecorations()
        createSymbol(1, -470, -250)
        createSymbol(1, -620, -250)
        applyToSymbol(1, function(cw) cw.y:run(cw.y.value + 100, cw.y.value, 30, easing.backOut); cw.x:run(cw.x.value + 130, cw.x.value, 60, easing.backOut) end)
        applyToSymbol(2, function(cw) cw.y:run(cw.y.value - 100, cw.y.value, 30, easing.backOut); cw.x:run(cw.x.value - 160, cw.x.value, 60, easing.backOut) end)
    ]]) 
    e_waitUntilS(offset + 43.51);e_eval([[
        createSymbol(2, -470, 0)
        createSymbol(9, -620, 0)
        applyToSymbol(3, function(cw) cw.y:run(cw.y.value - 20, cw.y.value, 30, easing.backOut); cw.x:run(cw.x.value + 70, cw.x.value, 60, easing.backOut) end)
        applyToSymbol(4, function(cw) cw.y:run(cw.y.value - 140, cw.y.value, 30, easing.backOut); cw.x:run(cw.x.value - 160, cw.x.value, 60, easing.backOut) end)
    ]]) 
    e_waitUntilS(offset + 43.74);e_eval([[
        createSymbol(3, -470, 250)
        createSymbol(6, -620, 250)
        applyToSymbol(5, function(cw) cw.y:run(cw.y.value - 170, cw.y.value, 30, easing.backOut); cw.x:run(cw.x.value + 30, cw.x.value, 60, easing.backOut) end)
        applyToSymbol(6, function(cw) cw.y:run(cw.y.value - 90, cw.y.value, 30, easing.backOut); cw.x:run(cw.x.value - 170, cw.x.value, 60, easing.backOut) end)
    ]]) 
    e_waitUntilS(offset + 43.96);e_eval([[
        createSymbol(4, 470, -250)
        createSymbol(0, 620, -250)
        applyToSymbol(7, function(cw) cw.y:run(cw.y.value + 100, cw.y.value, 30, easing.backOut); cw.x:run(cw.x.value + 30, cw.x.value, 60, easing.backOut) end)
        applyToSymbol(8, function(cw) cw.y:run(cw.y.value - 90, cw.y.value, 30, easing.backOut); cw.x:run(cw.x.value - 250, cw.x.value, 60, easing.backOut) end)
    ]]) 
    e_waitUntilS(offset + 44.28);e_eval([[
        createSymbol(5, 470, 0)
        createSymbol(10, 620, 0)
        applyToSymbol(9, function(cw) cw.y:run(cw.y.value + 120, cw.y.value, 30, easing.backOut); cw.x:run(cw.x.value + 175, cw.x.value, 60, easing.backOut) end)
        applyToSymbol(10, function(cw) cw.y:run(cw.y.value - 10, cw.y.value, 30, easing.backOut); cw.x:run(cw.x.value - 15, cw.x.value, 60, easing.backOut) end)
    ]]) 
    e_waitUntilS(offset + 44.57);e_eval([[
        createSymbol(7, 470, 250)
        createSymbol(8, 620, 250)
        applyToSymbol(11, function(cw) cw.y:run(cw.y.value + 130, cw.y.value, 30, easing.backOut); cw.x:run(cw.x.value - 20, cw.x.value, 60, easing.backOut) end)
        applyToSymbol(12, function(cw) cw.y:run(cw.y.value - 30, cw.y.value, 30, easing.backOut); cw.x:run(cw.x.value + 80, cw.x.value, 60, easing.backOut) end)
    ]]) 
    e_waitUntilS(offset + 44.85);e_eval([[applyToAllSymbols(function(cw) cw.y:run(cw.y.value, cw.y.value + math.random(-2000, 2000), 40, easing.backIn); cw.x:run(cw.x.value, cw.x.value + math.random(-3000, 3000), 70, easing.backIn) end)]])

    -- Fourth Part
    e_waitUntilS(offset + 45.47);e_eval([[
        shdr_setActiveFragmentShader(0, backgroundShaderFourthPart)
        pulsingLineWalls(150, 0)
        deleteSymbols()
        s_setBGRotationOffset(0)
        u_setFlashEffect(255)
        l_setSides(8)
        setMainColor(225, 200, 205, 255)
        setCustomWallColorVariance(30, 10, 10, 0)
        pulse.skew:run(0, 0.2, 100, easing.backOut)
        pulse.rotationSpeed:run(-2, 0, 100, easing.backOut)  
        applyMainColor()
        for i = 1, 50 do createRotatingCircle(4, 700, 300, math.random(0, 314)) end
        for i = 1, 20 do createRotatingCircle(1, 300, 50, i / 10, 3) end
        for i = 1, 20 do createRotatingCircle(1, 300, 50, i / 10 + math.pi, 3) end
    ]])
    e_waitUntilS(offset + 53.30);e_eval('createSymbol(2, -300, -40)')
    e_waitUntilS(offset + 53.84);e_eval('createSymbol(9, 300, -40)')
    e_waitUntilS(offset + 54.25);e_eval([[
        l_setSides(10)
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

    -- Fifth Part
    e_waitUntilS(offset + 62);e_eval([[
        pulse.skew:run(0, 0.3, 60, easing.backIn)
        pulse.alpha3d:run(50, 5, 60, easing.easeOut)
        s_setStyle("astralDivinityFifthPart")
    ]])
    e_waitUntilS(offset + 62.30);e_eval([[
        deleteSymbols()
        createSymbol(1, -80, 250)
    ]])
    e_waitUntilS(offset + 62.50);e_eval([[
        createSymbol(2, 80, 250)
        applyToSymbol(1, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 35, easing.backIn) end)
    ]])
    e_waitUntilS(offset + 62.60);e_eval('applyToSymbol(2, function(cw) cw.y:run(cw.y.value, cw.y.value + 500, 35, easing.backIn) end)')
    e_waitUntilS(offset + 63);e_eval([[
        removePentagonDecorations()
        deleteBasicWalls()
        removeRotatingCircles()
        deleteSymbols()
        shdr_setActiveFragmentShader(0, backgroundShaderLastPart)
        u_setFlashEffect(255)
        setMainColor(245, 245, 245, 255)
        setCustomWallColorVariance(10, 10, 10, 0)
        applyMainColor()
        e_eval('l_setSides(5)')
    ]])
    e_waitUntilS(offset + 63.01);e_eval('l_setSides(4)')

    -- END
    e_waitUntilS(offset + 80.09); e_eval([[
        pulse.shaderTimeMult:run(1, 0, 300)
        pulse.spacing3d:run(s_get3dSpacing(), 0, 260)
        pulse.rotationSpeed:run(1, 0, 100)
        pulse.minRadius:run(l_getRadiusMin(), 300, 260, easing.backIn)
    ]])
    e_waitUntilS(offset + 81.69); e_eval([[
        pulse.rotationSpeed:run(0, 1, 260)
    ]])
    e_waitUntilS(offset + 82.1); e_eval('pulse.speed:run(l_getSpeedMult(), 0 , 180)')
    e_waitUntilS(offset + levelCompletionTime);e_eval([[
        cw_clear()
        shdr_resetActiveFragmentShader(2)
        l_overrideScore('levelCompletedMsg')
        l_setSides(4)
        e_kill()
    ]]) -- why before death I set 4 sides but amount is still 5
end

levelCompletedMsg = 'LEVEL COMPLETED'
levelFailMsg = 'LEVEL FAILED'
overrideScore = 0
percent = 0
levelCompletionTime = 84.2

function onDeath()
    if l_getLevelTime() > 80.09 and l_getLevelTime() < levelCompletionTime - 0.02 then l_overrideScore("levelFailMsg") end
end

function applyValuesFromScript()
    addPlayerRadius = pulse.additionalPlayerRadius.value
    playerWidthMult = pulse.playerWidthMult.value
    playerHeightMult = pulse.playerHeightMult.value
    wallLeftSkew = pulse.wallLeftSkew.value
    wallRightSkew = pulse.wallRightSkew.value
    wallLeftAngle = pulse.wallLeftAngle.value
    wallRightAngle = pulse.wallRightAngle.value
end

addPlayerRadius = -5
playerWidthMult = 0
playerHeightMult = 0
pulseTime = 0
pulseTimePulse = 30

wallLeftSkew = 0
wallRightSkew = 0
wallLeftAngle = 0
wallRightAngle = 0

function onUpdate(mFrameTime)
    for _, fn in pairs(pulse) do fn:update(mFrameTime) end
    overrideScore = simplifyFloat(l_getLevelTime(), simplifyFloat(pulse.scoreFloatingNumbers.value, 0))
    percent = tostring(simplifyFloat(
        l_getLevelTime() / levelCompletionTime * 100,
        simplifyFloat(pulse.scoreFloatingNumbers.value, 0)
    )) .. "%"
    pulseTime = pulseTime - mFrameTime
    if pulseTime > 0 then s_setPulseMin(-2) else s_setPulseMin(1) end
    applyValuesFromScript()
    updateCustomWalls(mFrameTime)
end

playerArrow() -- Creating fake arrow which I will be stretching

function onInit()
    l_setSpeedMult(3)
    l_setSpeedInc(0)
    l_setSpeedMax(4.75)
    l_setDelayMult(1)

    l_setRotationSpeed(0)

    l_setDelayInc(0)
    l_setFastSpin(0)
    l_setSides(3)
    for i = 0, l_getSides() - 1 do playerWall(i) end

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
    l_addTracked('percent', 'percent')

    u_setFlashColor(0, 0, 0)
    u_setFlashEffect(255)

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
    shaderTime = shaderTime + mFrameTime * pulse.shaderTimeMult.value / 1000
    shdr_setUniformFVec2(backgroundShader, "u_resolution", u_getWidth(), u_getHeight())
    shdr_setUniformF(backgroundShader, "u_time", shaderTime)
    shdr_setUniformFVec4(backgroundShader, "color", r, g, b, a) 

    shdr_setUniformFVec2(backgroundShaderDrop, "u_resolution", u_getWidth(), u_getHeight())
    shdr_setUniformF(backgroundShaderDrop, "u_time", shaderTime)
    shdr_setUniformFVec4(backgroundShaderDrop, "color", r, g, b, a) 

    shdr_setUniformFVec2(backgroundShaderLastPart, "u_resolution", u_getWidth(), u_getHeight())
    shdr_setUniformF(backgroundShaderLastPart, "u_time", shaderTime)
    shdr_setUniformF(backgroundShaderLastPart, "borderPulse", pulse.shaderBorderPulse.value)
    shdr_setUniformFVec4(backgroundShaderLastPart, "color", r, g, b, a) 

    shdr_setUniformFVec2(backgroundShaderFourthPart, "u_resolution", u_getWidth(), u_getHeight())
    shdr_setUniformF(backgroundShaderFourthPart, "u_time", shaderTime)
    shdr_setUniformFVec4(backgroundShaderFourthPart, "color", r, g, b, a) 
    shdr_setUniformF(backgroundShaderFourthPart, "gridSize", pulse.shaderGridSize.value) 
    shdr_setUniformF(backgroundShaderFourthPart, "colorVariance", pulse.shaderColorVariance.value)
end

function onStep()
    addPattern(keys[index])
    index = index + 1

    if index - 1 == #keys then
        index = 1
        shuffle(keys)
    end
end