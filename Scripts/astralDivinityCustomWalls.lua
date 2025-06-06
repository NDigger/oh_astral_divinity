-- MAIN COLOR IS COLOR APPLIED TO MOST OF CUSTOM WALLS
function updateCustomWalls(mFrameTime)
    updatePulseLineWall(mFrameTime)
    updateCustomWallColors(mFrameTime)
    updateBasicWall(mFrameTime)
    updateSymbols(mFrameTime)
    updatePlayerWall(mFrameTime)
    updatePlayerArrow(mFrameTime)
    updateLineWall(mFrameTime)
    updateCircles(mFrameTime)
    updatePentagonDecoration(mFrameTime)
    updatePulseWalls(mFrameTime)
    updateParticles(mFrameTime)
    updateFakePlayerArrows(mFrameTime)
    updateOtherPlayerWalls(mFrameTime)
end

mainColor = { r = interpolation:new(), g = interpolation:new(), b = interpolation:new(), a = interpolation:new() }

function setMainColor(r, g, b, a)
    mainColor.r.value = r
    mainColor.g.value = g
    mainColor.b.value = b
    mainColor.a.value = a
end

setMainColor(255, 225, 0, 255) -- Gold color in the beginning.

-- APPLY MAIN COLOR TO CWS IMMEDIATELY
function applyMainColor()
    local r, g, b, a = mainColor.r.value, mainColor.g.value, mainColor.b.value, mainColor.a.value
    for key, wallType in pairs(customWall) do
        function runInterpolation(cw)
            cw.color.r:run(r, r, 0)
            cw.color.g:run(g, g, 0)
            cw.color.b:run(b, b, 0)
            cw.color.a:run(a, a, 0)
        end
        if key == "symbols" then
            for _, symbol in pairs(wallType) do
                for _, block in pairs(symbol) do
                    runInterpolation(block)
                end
            end
        else
            for _, cw in pairs(wallType) do
                runInterpolation(cw)
            end
        end
    end
end

customWallColorVariance = { r = 0, g = 30, b = 0, a = 0 }

function setCustomWallColorVariance(r, g, b, a)
    customWallColorVariance.r = r
    customWallColorVariance.g = g
    customWallColorVariance.b = b
    customWallColorVariance.a = a
end

function getColorWithVariance(color) -- custom walls can get different colors that are close to main color.
    color.r.value = color.r.value + math.random(-customWallColorVariance.r, customWallColorVariance.r)
    color.g.value = color.g.value + math.random(-customWallColorVariance.g, customWallColorVariance.g)
    color.b.value = color.b.value + math.random(-customWallColorVariance.b, customWallColorVariance.b)
    color.a.value = color.a.value + math.random(-customWallColorVariance.a, customWallColorVariance.a)
    return color
end

-- CUSTOM WALL TABLE WITH CUSTOM WALL TABLES (Some custom wall tables in custom wall tables have custom wall tables)
customWall = {
    basic = {},
    pulseLine = {},
    symbols = {},
    player = {},
    playerArrow = {},
    lines = {},
    pentagonDecoration = {},
    rotatingCircle = {},
    pulse = {},
    particle = {},
    fakePlayerArrows = {},
    anotherPlayer = {},
}

-- Used for interpolation color pulses
function updateCustomWallColors(mFrameTime)
    local safeValue = { min = 0, max = 255 }
    function setSafeColor(cw)
        cw_setVertexColor4Same(
            cw.id, 
            math.max(safeValue.min, math.min(safeValue.max, cw.color.r.value)), 
            math.max(safeValue.min, math.min(safeValue.max, cw.color.g.value)), 
            math.max(safeValue.min, math.min(safeValue.max, cw.color.b.value)), 
            math.max(safeValue.min, math.min(safeValue.max, cw.color.a.value))
        )
    end
    for _, symbol in pairs(customWall.symbols) do
        for _, block in pairs(symbol) do
            setSafeColor(block)
            for _, color in pairs(block.color) do
                color:update(mFrameTime)
            end
        end
    end
    for key, wallType in pairs(customWall) do
        if key ~= "symbols" then
            for _, cw in pairs(wallType) do
                setSafeColor(cw)
                for _, color in pairs(cw.color) do
                    color:update(mFrameTime)
                end
            end
        end
    end
end

function getWallSpeed(mFrameTime) return u_getSpeedMultDM() * 5 * mFrameTime end

-- Clones table
function clone(obj)
    if type(obj) ~= 'table' then return obj end
    local copy = {}
    for k, v in pairs(obj) do
        copy[k] = clone(v)
    end
    setmetatable(copy, getmetatable(obj))
    return copy
end

------------------------------------------
-- BASIC WALL (replaces w_wall)
------------------------------------------

function basicWall(side, THICKNESS)
    local sides = l_getSides()
    local cw = {
        id = cw_create(),
        distance = l_getWallSpawnDistance(),
        firstAngle = side * math.pi / (sides / 2) + math.pi / sides,
        secondAngle = nil,
        THICKNESS = THICKNESS or 40,
        color = getColorWithVariance(clone(mainColor))
    }
    cw.secondAngle = cw.firstAngle + 0.5 * math.pi / (sides / 2) + math.pi / sides
    cw_setKillingSide(cw.id, 2)
    table.insert(customWall.basic, cw)
end

function updateBasicWall(mFrameTime)
    function setPosition(cw)
        cw_setVertexPos(cw.id, 0, (cw.distance + cw.THICKNESS + wallLeftSkew.value) * math.cos(cw.firstAngle + wallLeftAngle.value), (cw.distance + cw.THICKNESS + wallLeftSkew.value) * math.sin(cw.firstAngle + wallLeftAngle.value))
        cw_setVertexPos(cw.id, 1, (cw.distance + cw.THICKNESS + wallRightSkew.value) * math.cos(cw.secondAngle + wallRightAngle.value), (cw.distance + cw.THICKNESS + wallRightSkew.value) * math.sin(cw.secondAngle + wallRightAngle.value))
        cw_setVertexPos(cw.id, 2, cw.distance * math.cos(cw.secondAngle), cw.distance * math.sin(cw.secondAngle))
        cw_setVertexPos(cw.id, 3, cw.distance * math.cos(cw.firstAngle), cw.distance * math.sin(cw.firstAngle))
    end
    for i = #customWall.basic, 1, -1 do 
        local cw = customWall.basic[i]
        if cw.distance > 0 then
            cw.distance = cw.distance - getWallSpeed(mFrameTime)
        else
            cw.THICKNESS = cw.THICKNESS - getWallSpeed(mFrameTime)
        end
        setPosition(cw)
        if cw.THICKNESS < 0 then 
            cw_destroy(cw.id)
            table.remove(customWall.basic, i)
        end
    end
end

-- Delete all created w_walls
function deleteBasicWalls()
    for i = #customWall.basic, 1, -1 do
        cw_destroy(customWall.basic[i].id)
        table.remove(customWall.basic, i)
    end
end

function w_wall(side, THICKNESS)
    t_eval("basicWall(" .. side .. ", " .. THICKNESS .. ")")
end

--------------------------------------------
-- PULSING LINE WALL
--------------------------------------------

pulsingLineWallProp = {
    width = 10,
    minHeight = 100,
    maxHeight = 400,
    margin = 2,
}

function pulsingLineWalls(amount, y, x, minHeight, maxHeight, width)
    local halfSpace = (amount * ((width or pulsingLineWallProp.width) + pulsingLineWallProp.margin)) / 2
    for i = 1, amount do pulsingLineWall(-halfSpace + (i * ((width or pulsingLineWallProp.width) + pulsingLineWallProp.margin)) + (x or 0), y, minHeight, maxHeight, width) end
end

function pulsingLineWall(x, y, minHeight, maxHeight, width)
    if not minHeight or not maxHeight then
        minHeight = pulsingLineWallProp.minHeight
        maxHeight = pulsingLineWallProp.maxHeight
    end
    local cw = {
        id = cw_createNoCollision(),
        color = getColorWithVariance(clone(mainColor)),
        time = math.pi / 2 * 0.9,
        height = math.random(minHeight, maxHeight),
        width = width or pulsingLineWallProp.width,
        x = x, y = y,
    }
    table.insert(customWall.pulseLine, cw)
end

function updatePulseLineWall(mFrameTime)
    for i = #customWall.pulseLine, 1, -1 do
        local cw = customWall.pulseLine[i]
        cw.time = cw.time + mFrameTime / 10
        cw_setVertexPos(cw.id, 0, getAbsolutePosition(cw.x, cw.y * (s_get3dSkew() + 1) + -cw.height * math.sin(cw.time)))
        cw_setVertexPos(cw.id, 1, getAbsolutePosition(cw.x + cw.width, cw.y * (s_get3dSkew() + 1) + -cw.height * math.sin(cw.time)))
        cw_setVertexPos(cw.id, 2, getAbsolutePosition(cw.x + cw.width, cw.y * (s_get3dSkew() + 1) + cw.height * math.sin(cw.time)))
        cw_setVertexPos(cw.id, 3, getAbsolutePosition(cw.x, cw.y * (s_get3dSkew() + 1) + cw.height * math.sin(cw.time)))
        if cw.time > math.pi then
            cw_destroy(cw.id)
            table.remove(customWall.pulseLine, i)
        end
    end
end

-----------------------------------------
-- SYMBOL WALLS
------------------------------------------

symbolProps = {}
symbolProps.size = 200
symbolProps.rect = symbolProps.size / 3.125
symbolProps.square = symbolProps.size / 8.333

-- Various symbols
local abstractSymbols = {
    [0] = { {x=0,y=0,w=symbolProps.rect,h=symbolProps.square}, {x=0,y=symbolProps.square,w=symbolProps.square,h=symbolProps.rect}, {x=symbolProps.rect,y=symbolProps.rect,w=symbolProps.square,h=symbolProps.square} },
    [1] = { {x=0,y=0,w=symbolProps.square,h=symbolProps.rect}, {x=symbolProps.square,y=symbolProps.rect,w=symbolProps.rect,h=symbolProps.square}, {x=symbolProps.rect + symbolProps.square,y=0,w=symbolProps.square,h=symbolProps.rect} },
    [2] = { {x=0,y=0,w=symbolProps.rect,h=symbolProps.square}, {x=symbolProps.rect,y=symbolProps.square,w=symbolProps.square,h=symbolProps.rect}, {x=symbolProps.rect / 2,y=symbolProps.square + symbolProps.rect,w=symbolProps.square,h=symbolProps.square} },
    [3] = { {x=0,y=0,w=symbolProps.square,h=symbolProps.rect}, {x=symbolProps.square,y=symbolProps.rect - symbolProps.square,w=symbolProps.rect,h=symbolProps.square}, {x=symbolProps.rect + symbolProps.square,y=0,w=symbolProps.square,h=symbolProps.rect} },
    [4] = { {x=symbolProps.square,y=0,w=symbolProps.square,h=symbolProps.rect}, {x=0,y=0,w=symbolProps.square,h=symbolProps.square}, {x=symbolProps.square * 2,y=0,w=symbolProps.square,h=symbolProps.square}, {x=symbolProps.square,y=symbolProps.rect,w=symbolProps.square,h=symbolProps.square} },
    [5] = { {x=0,y=0,w=symbolProps.rect,h=symbolProps.square}, {x=0,y=symbolProps.square,w=symbolProps.square,h=symbolProps.rect}, {x=symbolProps.square,y=symbolProps.square + symbolProps.rect,w=symbolProps.square,h=symbolProps.square}, {x=symbolProps.square * 2,y=0,w=symbolProps.square,h=symbolProps.square} },
    [6] = { {x=0,y=0,w=symbolProps.square,h=symbolProps.rect}, {x=symbolProps.square,y=symbolProps.rect - symbolProps.square,w=symbolProps.square,h=symbolProps.square}, {x=symbolProps.square * 2,y=0,w=symbolProps.rect,h=symbolProps.square} },
    [7] = { {x=0,y=0,w=symbolProps.square,h=symbolProps.square}, {x=symbolProps.square,y=0,w=symbolProps.rect,h=symbolProps.square}, {x=symbolProps.square + symbolProps.rect - symbolProps.square,y=symbolProps.square,w=symbolProps.square,h=symbolProps.rect} },
    [8] = { {x=0,y=0,w=symbolProps.square,h=symbolProps.rect}, {x=symbolProps.square,y=symbolProps.rect + symbolProps.square,w=symbolProps.rect,h=symbolProps.square}, {x=symbolProps.square + symbolProps.rect,y=0,w=symbolProps.square,h=symbolProps.rect} },
    [9] = { {x=0,y=0,w=symbolProps.square,h=symbolProps.square}, {x=symbolProps.square,y=0,w=symbolProps.rect,h=symbolProps.square}, {x=0,y=symbolProps.square,w=symbolProps.square,h=symbolProps.rect}, {x=symbolProps.square,y=symbolProps.square + symbolProps.rect,w=symbolProps.square,h=symbolProps.square} },
    [10] = { {x=0,y=0,w=symbolProps.square,h=symbolProps.rect}, {x=symbolProps.square,y=symbolProps.rect,w=symbolProps.rect,h=symbolProps.square}, {x=symbolProps.rect + symbolProps.square,y=0,w=symbolProps.square,h=symbolProps.square}, {x=symbolProps.rect,y=symbolProps.square + symbolProps.rect,w=symbolProps.square,h=symbolProps.square} },
}

-- Creates one block from symbol
function createBlock(x, y, w, h)
    local cw = {
        id = cw_createNoCollision(),
        x = interpolation:new(), y = interpolation:new(), w = w, h = h,
        color = getColorWithVariance(clone(mainColor))
    }
    cw.x.value = x
    cw.y.value = y
    return cw
end

function createSymbol(id, xOffset, yOffset)
    local blocks = abstractSymbols[id]
    local symbolsArrSize = #customWall.symbols
    if not blocks then return end

    local newSymbol = {}
    for _, block in ipairs(blocks) do
        table.insert(newSymbol, createBlock(xOffset + block.x - symbolProps.size/6, yOffset + block.y, block.w, block.h))
    end
    table.insert(customWall.symbols, newSymbol)
end

function updateSymbols(mFrameTime)
    for i = #customWall.symbols, 1, -1 do
        local symbol = customWall.symbols[i]
        for k = #symbol, 1, -1 do
            local cw = symbol[k]
            cw_setVertexPos(cw.id, 0, getAbsolutePosition(cw.x.value, cw.y.value))
            cw_setVertexPos(cw.id, 1, getAbsolutePosition(cw.x.value + cw.w, cw.y.value))
            cw_setVertexPos(cw.id, 2, getAbsolutePosition(cw.x.value + cw.w, cw.y.value + cw.h))
            cw_setVertexPos(cw.id, 3, getAbsolutePosition(cw.x.value, cw.y.value + cw.h))
            cw_setVertexColor4Same(cw.id, cw.color.r.value, cw.color.g.value, cw.color.b.value, cw.color.a.value)
        end
    end
    for _, symbol in pairs(customWall.symbols) do 
        for _, cw in pairs(symbol) do
            cw.y:update(mFrameTime) 
            cw.x:update(mFrameTime)
        end
    end
end

-- Applies a function to symbol, I used it to change x and y pos with interpolation
function applyToSymbol(index, func)
    for _, cw in pairs(customWall.symbols[index]) do func(cw) end
end

-- The same but applies to each symbol
function applyToAllSymbols(func)
    for _, symbol in pairs(customWall.symbols) do
        for _, cw in pairs(symbol) do
            func(cw)
        end
    end
end

function deleteSymbols()
    for i = #customWall.symbols, 1, -1 do
        local symbols = customWall.symbols[i]
        for k = #symbols, 1, -1 do
            local cw = symbols[k]
            cw_destroy(cw.id)
        end
        table.remove(customWall.symbols, i)
    end
end

--------------------------------------
-- PLAYER WALLS
--------------------------------------

playerWallsDistance = interpolation:new()
playerWallsDistance.value = 0
function playerWall(side)
    local sides = l_getSides()
    local cw = {
        id = cw_createNoCollision(),
        firstAngle = side * math.pi / (sides / 2) + math.pi / sides,
        secondAngle = nil,
        sides = sides,
        rotation = interpolation:new(),
        THICKNESS = l_getRadiusMin(),
        color = getColorWithVariance(clone(mainColor)),

        side = side,
        sides = sides
    }
    cw.secondAngle = cw.firstAngle + 0.5 * math.pi / (sides / 2) + math.pi / sides
    table.insert(customWall.player, cw)
end

function updatePlayerWall(mFrameTime)
    function setPosition(cw)
        cw_setVertexPos(cw.id, 0, cw.THICKNESS * math.cos(cw.firstAngle), cw.THICKNESS * math.sin(cw.firstAngle))
        cw_setVertexPos(cw.id, 1, cw.THICKNESS * math.cos(cw.secondAngle), cw.THICKNESS * math.sin(cw.secondAngle))
        cw_setVertexPos(cw.id, 2, playerWallsDistance.value * math.cos(cw.secondAngle), playerWallsDistance.value * math.sin(cw.secondAngle))
        cw_setVertexPos(cw.id, 3, playerWallsDistance.value * math.cos(cw.firstAngle), playerWallsDistance.value * math.sin(cw.firstAngle))
    end
    for i = #customWall.player, 1, -1 do 
        local cw = customWall.player[i]
        cw.firstAngle = cw.side * math.pi / (cw.sides / 2) + math.pi / cw.sides + cw.rotation.value
        cw.secondAngle = cw.firstAngle + 0.5 * math.pi / (cw.sides / 2) + math.pi / cw.sides
        cw.THICKNESS = l_getRadiusMin() + additionalPlayerRadius.value
        setPosition(customWall.player[i]) 
        cw_setVertexColor4Same(cw.id, cw.color.r.value, cw.color.g.value, cw.color.b.value, cw.color.a.value)
    end
    if customWall.player[1] and l_getSides() ~= customWall.player[1].sides then
        for i = #customWall.player, 1, -1 do
            local cw = customWall.player[i]
            cw_destroy(cw.id)
            table.remove(customWall.player, i)
        end
        for i = 0, l_getSides() - 1 do playerWall(i) end
    end
end

function rotatePlayerWalls(rotation, time, easing)
    for i = #customWall.player, 1, -1 do 
        local cw = customWall.player[i]
        cw.rotation:run(cw.rotation.value, cw.rotation.value + rotation, time, easing)
    end
end

----------------------------------------------------------
-- FAKE PLAYER ARROW
----------------------------------------------------------

function playerArrow()
    local cw = {
        id = cw_createNoCollision(),
        distance = l_getRadiusMin(),
        angle = u_getPlayerAngle(),
        color = clone(mainColor),
        width = 0.2,
        height = 9,
    }
    table.insert(customWall.playerArrow, cw) -- Even though it's single it requires color pulse and change support.
end

function updatePlayerArrow(mFrameTime)
    local cw = customWall.playerArrow[1]
    cw.width = 15 / l_getRadiusMin() * playerWidthMult.value
    cw.distance = l_getRadiusMin() * 1.15
    local height = cw.height * playerHeightMult.value
    cw.angle = u_getPlayerAngle()
    cw_setVertexPos(cw.id, 0, cw.distance * math.cos(cw.angle), (cw.distance) * math.sin(cw.angle))
    cw_setVertexPos(cw.id, 1, (cw.distance - height) * math.cos(cw.angle + cw.width), (cw.distance - height) * math.sin(cw.angle + cw.width))
    cw_setVertexPos(cw.id, 2, (cw.distance - height) * math.cos(cw.angle - cw.width), (cw.distance - height) * math.sin(cw.angle - cw.width))
    cw_setVertexPos(cw.id, 3, cw.distance * math.cos(cw.angle), (cw.distance) * math.sin(cw.angle))
    cw_setVertexColor4Same(cw.id, cw.color.r.value, cw.color.g.value, cw.color.b.value, cw.color.a.value)
end

----------------------------------------------------------
-- STICKS /-\_
----------------------------------------------------------

function lineWall(sides, changeDir)
    local sides = sides or 100
    if changeDir == nil then changeDir = false end
    local cw = {
        changeDir = changeDir,
        id = cw_createNoCollision(),
        distance = changeDir and 700 or -50,
        firstAngle = math.random(1, sides) * math.pi / (sides / 2) + math.pi / sides,
        secondAngle = nil,
        THICKNESS = math.random(20, 110),
        speedMult = math.random(50, 150) / 50,
        color = getColorWithVariance(clone(mainColor))
    }
    cw.secondAngle = cw.firstAngle + 0.5 * math.pi / (sides / 2) + math.pi / sides
    table.insert(customWall.lines, cw)
end

function updateLineWall(mFrameTime)
    local function setPosition(cw)
        cw_setVertexPos(cw.id, 0, getAbsolutePosition((cw.distance + cw.THICKNESS) * math.cos(cw.firstAngle), (cw.distance + cw.THICKNESS) * math.sin(cw.firstAngle)))
        cw_setVertexPos(cw.id, 1, getAbsolutePosition((cw.distance + cw.THICKNESS) * math.cos(cw.secondAngle), (cw.distance + cw.THICKNESS) * math.sin(cw.secondAngle)))
        cw_setVertexPos(cw.id, 2, getAbsolutePosition(cw.distance * math.cos(cw.secondAngle), cw.distance * math.sin(cw.secondAngle)))
        cw_setVertexPos(cw.id, 3, getAbsolutePosition(cw.distance * math.cos(cw.firstAngle), cw.distance * math.sin(cw.firstAngle)))
    end
    for i = #customWall.lines, 1, -1 do 
        local cw = customWall.lines[i]
        if cw.changeDir == false then cw.distance = cw.distance + getWallSpeed(mFrameTime) * cw.speedMult
        else cw.distance = cw.distance - getWallSpeed(mFrameTime) * cw.speedMult * 2
        end
        setPosition(cw)
        if (cw.distance > 2200 and cw.changeDir == false) or (cw.distance < 0 and cw.changeDir == true) then 
            cw_destroy(cw.id)
            table.remove(customWall.lines, i)
        end
    end
end

function createLineWalls(amount, sides, changeDir) for i = 1, amount do lineWall(sides, changeDir) end end

-------------------------------------------------
-- PENTAGON DECORATION 
-------------------------------------------------

-- I saved red color for pentagons, it's not too red but I still think it's red.
redColor = clone(mainColor)
redColor.r.value = 225
redColor.g.value = 125
redColor.b.value = 180

-- Pure white, for pentagons too.
whiteColor = clone(mainColor)
whiteColor.r.value = 255
whiteColor.g.value = 255
whiteColor.b.value = 255

-- Creates one part of pentagon decoration.
function pentagonDecorationPart(side, THICKNESS, xOffset, yOffset, color, angle)
    local sides = 5
    local cw = {
        id = cw_createNoCollision(),
        distance = 0,
        firstAngle = side * math.pi / (sides / 2) + math.pi / sides + (angle or 0),
        secondAngle = nil,
        THICKNESS = interpolation:new(),
        rotation = interpolation:new(),
        isThicknessInterpolationRunning = false,
        xOffset = xOffset, yOffset = yOffset,
        color = getColorWithVariance(clone(color or mainColor)),
        sides = sides,
        side = side,
        angle = angle or 0
    }
    cw.THICKNESS:run(0, THICKNESS, 60, easing.backOut)
    cw.secondAngle = cw.firstAngle + 0.5 * math.pi / (sides / 2) + math.pi / sides
    table.insert(customWall.pentagonDecoration, cw)
end

function updatePentagonDecoration(mFrameTime)
    local function setPosition(cw)
        cw_setVertexPos(cw.id, 0, getAbsolutePosition((cw.distance + cw.THICKNESS.value) * math.cos(cw.firstAngle) + cw.xOffset, (cw.distance + cw.THICKNESS.value) * math.sin(cw.firstAngle) + cw.yOffset))
        cw_setVertexPos(cw.id, 1, getAbsolutePosition((cw.distance + cw.THICKNESS.value) * math.cos(cw.secondAngle) + cw.xOffset, (cw.distance + cw.THICKNESS.value) * math.sin(cw.secondAngle) + cw.yOffset))
        cw_setVertexPos(cw.id, 2, getAbsolutePosition(cw.distance * math.cos(cw.secondAngle) + cw.xOffset, cw.distance * math.sin(cw.secondAngle) + cw.yOffset))
        cw_setVertexPos(cw.id, 3, getAbsolutePosition(cw.distance * math.cos(cw.firstAngle) + cw.xOffset, cw.distance * math.sin(cw.firstAngle) + cw.yOffset))
    end
    for i = #customWall.pentagonDecoration, 1, -1 do 
        local cw = customWall.pentagonDecoration[i]
        cw.firstAngle = cw.side * math.pi / (cw.sides / 2) + math.pi / cw.sides + cw.angle + cw.rotation.value
        cw.secondAngle = cw.firstAngle + 0.5 * math.pi / (cw.sides / 2) + math.pi / cw.sides
        setPosition(cw)
        if cw.THICKNESS.value <= 0.01 then
            cw.THICKNESS:destroy()
            cw_destroy(cw.id)
            table.remove(customWall.pentagonDecoration, i)
        end
    end
end

function createPentagonDecoration(THICKNESS, xOffset, yOffset, color, angle) for i = 1, 5 do pentagonDecorationPart(i, THICKNESS, xOffset, yOffset, color, angle) end end

-- Removes one part of pentagon decoration
function removePentagonDecorationPart(ease)
    for i = #customWall.pentagonDecoration, 1, -1 do
        local cw = customWall.pentagonDecoration[i]
        if cw == nil then return end
        if not cw.isThicknessInterpolationRunning then
            cw.THICKNESS:run(cw.THICKNESS.value + 20, 0, 25, ease or easing.backIn)
            cw.isThicknessInterpolationRunning = true
            break
        end
    end
end

function rotatePentagonDecorations(rotation, time, easing)
    for i = #customWall.pentagonDecoration, 1, -1 do 
        local cw = customWall.pentagonDecoration[i]
        cw.rotation:run(cw.rotation.value, cw.rotation.value + rotation, time, easing)
    end
end

function removePentagonDecorations()
    for i = #customWall.pentagonDecoration, 1, -1 do
        local cw = customWall.pentagonDecoration[i]
        cw_destroy(cw.id)
        table.remove(customWall.pentagonDecoration, i)
    end
end

---------------------------------------------------------
-- ROTATING CIRCLE
---------------------------------------------------------

function circleDecorationPart(side, THICKNESS, offsetDistance, distance, angle, timeIncMult, sides)
    local sides = sides or 6
    local cw = {
        id = cw_createNoCollision(),
        distance = distance or 0,
        offsetDistance = offsetDistance,
        firstAngle = side * math.pi / (sides / 2) + math.pi / sides,
        secondAngle = nil,
        THICKNESS = THICKNESS,
        xOffset = xOffset, yOffset = yOffset,
        time = 0,
        angleOffset = angle,
        timeIncMult = timeIncMult or 1,
        color = getColorWithVariance(clone(mainColor)),
    }
    cw.secondAngle = cw.firstAngle + 0.5 * math.pi / (sides / 2) + math.pi / sides
    table.insert(customWall.rotatingCircle, cw)
end

function updateCircles(mFrameTime)
    local function setPosition(cw)
        cw_setVertexPos(cw.id, 0, getAbsolutePosition(
            (cw.distance + cw.THICKNESS) * math.cos(cw.firstAngle + cw.time + cw.angleOffset) + cw.offsetDistance * math.cos(cw.time + cw.angleOffset),
            (cw.distance + cw.THICKNESS) * math.sin(cw.firstAngle + cw.time + cw.angleOffset) + cw.offsetDistance * math.sin(cw.time + cw.angleOffset)))
        cw_setVertexPos(cw.id, 1, getAbsolutePosition(
            (cw.distance + cw.THICKNESS) * math.cos(cw.secondAngle + cw.time + cw.angleOffset) + cw.offsetDistance * math.cos(cw.time + cw.angleOffset),
            (cw.distance + cw.THICKNESS) * math.sin(cw.secondAngle + cw.time + cw.angleOffset) + cw.offsetDistance * math.sin(cw.time + cw.angleOffset)))
        cw_setVertexPos(cw.id, 2, getAbsolutePosition(
            cw.distance * math.cos(cw.secondAngle + cw.time + cw.angleOffset) + cw.offsetDistance * math.cos(cw.time + cw.angleOffset),
            cw.distance * math.sin(cw.secondAngle + cw.time + cw.angleOffset) + cw.offsetDistance * math.sin(cw.time + cw.angleOffset)))
        cw_setVertexPos(cw.id, 3, getAbsolutePosition(
            cw.distance * math.cos(cw.firstAngle + cw.time + cw.angleOffset) + cw.offsetDistance * math.cos(cw.time + cw.angleOffset),
            cw.distance * math.sin(cw.firstAngle + cw.time + cw.angleOffset) + cw.offsetDistance * math.sin(cw.time + cw.angleOffset)))
    end
    for i = #customWall.rotatingCircle, 1, -1 do 
        local cw = customWall.rotatingCircle[i]
        cw.time = cw.time + mFrameTime / 140 * cw.timeIncMult * shaderTimeMult.value
        setPosition(cw)
    end
end

function createRotatingCircle(THICKNESS, offsetDistance, distance, angle, timeIncM, sides) 
    local timeIncMult = math.random(-60, 60) / 100
    for i = 1, sides or 6 do circleDecorationPart(i, THICKNESS, offsetDistance, distance, angle, timeIncM or timeIncMult, sides) end 
end

function removeRotatingCircles(time, easing, rotationMult)
    for i = #customWall.rotatingCircle, 1, -1 do
        cw = customWall.rotatingCircle[i]
        cw_destroy(cw.id)
        table.remove(customWall.rotatingCircle, i)
    end
end

------------------------------------------
-- PULSE WALL
------------------------------------------

function pulseWall(side, THICKNESS, speedMult, distance, xOffset, yOffset)
    local sides = l_getSides()
    local cw = {
        id = cw_createNoCollision(),
        distance = distance or 0,
        firstAngle = side * math.pi / (sides / 2) + math.pi / sides,
        secondAngle = nil,
        THICKNESS = THICKNESS,
        xOffset = xOffset or 0, 
        yOffset = yOffset or 0,
        speedMult = speedMult or 1,
        color = getColorWithVariance(clone(mainColor))
    }
    cw.secondAngle = cw.firstAngle + 0.5 * math.pi / (sides / 2) + math.pi / sides
    table.insert(customWall.pulse, cw)
end

function updatePulseWalls(mFrameTime)
    function setPosition(cw)
        cw_setVertexPos(cw.id, 0, (cw.distance + cw.THICKNESS) * math.cos(cw.firstAngle) + cw.xOffset, (cw.distance + cw.THICKNESS) * math.sin(cw.firstAngle) + cw.yOffset)
        cw_setVertexPos(cw.id, 1, (cw.distance + cw.THICKNESS) * math.cos(cw.secondAngle) + cw.xOffset, (cw.distance + cw.THICKNESS) * math.sin(cw.secondAngle) + cw.yOffset)
        cw_setVertexPos(cw.id, 2, cw.distance * math.cos(cw.secondAngle) + cw.xOffset, cw.distance * math.sin(cw.secondAngle) + cw.yOffset)
        cw_setVertexPos(cw.id, 3, cw.distance * math.cos(cw.firstAngle) + cw.xOffset, cw.distance * math.sin(cw.firstAngle) + cw.yOffset)
    end
    for i = #customWall.pulse, 1, -1 do 
        local cw = customWall.pulse[i]
        cw.distance = cw.distance + getWallSpeed(mFrameTime) * cw.speedMult
        setPosition(cw)
        if cw.distance > l_getWallSpawnDistance() * 2.5 then 
            cw_destroy(cw.id)
            table.remove(customWall.pulse, i)
        end
    end
end

function createPulseWalls(THICKNESS, speedMult, distance, xOffset, yOffset) for i = 1, l_getSides() do pulseWall(i, THICKNESS, speedMult, distance, xOffset, yOffset) end end

----------------------------------------------------
-- PARTICLES!
----------------------------------------------------

-- Creates one particle
function particle(size, xOffset, yOffset)
    local sides = l_getSides()
    local angle = math.atan2(yOffset, xOffset)
    local cw = {
        id = cw_createNoCollision(),
        size = size,
        THICKNESS = THICKNESS,
        xOffset = xOffset or 0, 
        yOffset = yOffset or 0,
        shrinkSpeed = math.random(985, 1016) / 1000,
        color = getColorWithVariance(clone(redColor))
    }
    table.insert(customWall.particle, cw)
end

function updateParticles(mFrameTime)
    function setPosition(cw)
        cw_setVertexPos(cw.id, 0, cw.size + cw.xOffset, cw.size + cw.yOffset)
        cw_setVertexPos(cw.id, 1, cw.size + cw.xOffset, cw.yOffset)
        cw_setVertexPos(cw.id, 2, cw.xOffset, cw.yOffset)
        cw_setVertexPos(cw.id, 3, cw.xOffset, cw.size + cw.yOffset)
    end
    for i = #customWall.particle, 1, -1 do 
        local cw = customWall.particle[i]
        cw.size = cw.size * 0.99
        cw.xOffset = cw.xOffset * cw.shrinkSpeed
        cw.yOffset = cw.yOffset * cw.shrinkSpeed
        setPosition(cw)
        if cw.size < 0.001 then 
            cw_destroy(cw.id)
            table.remove(customWall.particle, i)
        end
    end
end

function createParticles(amount, size) for i = 1, amount do particle(size, math.random(-800, 800), math.random(-800, 800)) end end


----------------------------------------------------------
-- FAKE FAKE PLAYER ARROW (used in fifth part)
----------------------------------------------------------

function fakePlayerArrow(distanceFromCenter, angleOffset, timeIncMult, distance, width, height)
    local cw = {
        id = cw_createNoCollision(),
        distance = distance,
        angle = u_getPlayerAngle(),
        additionalAngle = math.random(0, 314) / 100,
        color = clone(mainColor),
        width = width or 0.2,
        height = height or 9,
        time = 0,
        distanceFromCenter = distanceFromCenter or 0,
        angleOffset = angleOffset or 0,
        timeIncMult = timeIncMult or 1,
    }
    table.insert(customWall.fakePlayerArrows, cw) -- Even though it's single it requires color pulse and change support.
end

function updateFakePlayerArrows(mFrameTime)
    for i = #customWall.fakePlayerArrows, 1, -1 do
        local cw = customWall.fakePlayerArrows[i]
        cw.angle = u_getPlayerAngle()
        cw.time = cw.time + mFrameTime / 140 * cw.timeIncMult * (shaderTimeMult.value)
        cw_setVertexPos(cw.id, 0, getAbsolutePosition(
            cw.distance * math.cos(cw.angle + cw.additionalAngle) + cw.distanceFromCenter * math.cos(cw.time + cw.angleOffset),
             (cw.distance) * math.sin(cw.angle + cw.additionalAngle) + cw.distanceFromCenter * math.sin(cw.time + cw.angleOffset)
        ))
        cw_setVertexPos(cw.id, 1, getAbsolutePosition(
            (cw.distance - cw.height) * math.cos(cw.angle + cw.additionalAngle + cw.width) + cw.distanceFromCenter * math.cos(cw.time + cw.angleOffset), 
            (cw.distance - cw.height) * math.sin(cw.angle + cw.additionalAngle + cw.width) + cw.distanceFromCenter * math.sin(cw.time + cw.angleOffset)
        ))
        cw_setVertexPos(cw.id, 2, getAbsolutePosition(
            (cw.distance - cw.height) * math.cos(cw.angle + cw.additionalAngle - cw.width) + cw.distanceFromCenter * math.cos(cw.time + cw.angleOffset), 
            (cw.distance - cw.height) * math.sin(cw.angle + cw.additionalAngle - cw.width) + cw.distanceFromCenter * math.sin(cw.time + cw.angleOffset)
        ))
        cw_setVertexPos(cw.id, 3,  getAbsolutePosition(
            cw.distance * math.cos(cw.angle + cw.additionalAngle) + cw.distanceFromCenter * math.cos(cw.time + cw.angleOffset), 
            (cw.distance) * math.sin(cw.angle + cw.additionalAngle) + cw.distanceFromCenter * math.sin(cw.time + cw.angleOffset)
        ))
        cw_setVertexColor4Same(cw.id, cw.color.r.value, cw.color.g.value, cw.color.b.value, cw.color.a.value)
    end
end

----------------------------------------------------------
-- ANOTHER PLAYER WALL (used on the 3rd part)
----------------------------------------------------------

function anotherPlayerWall(side)
    local sides = l_getSides()
    local cw = {
        id = cw_createNoCollision(),
        firstAngle = side * math.pi / (sides / 2) + math.pi / sides,
        secondAngle = nil,
        sides = sides,
        rotation = interpolation:new(),
        THICKNESS = 0,
        color = getColorWithVariance(clone(mainColor)),

        side = side,
        sides = sides
    }
    cw.secondAngle = cw.firstAngle + 0.5 * math.pi / (sides / 2) + math.pi / sides
    table.insert(customWall.anotherPlayer, cw)
end

function updateOtherPlayerWalls(mFrameTime)
    function setPosition(cw)
        cw_setVertexPos(cw.id, 0, cw.THICKNESS * math.cos(cw.firstAngle), cw.THICKNESS * math.sin(cw.firstAngle))
        cw_setVertexPos(cw.id, 1, cw.THICKNESS * math.cos(cw.secondAngle), cw.THICKNESS * math.sin(cw.secondAngle))
        cw_setVertexPos(cw.id, 2, 0, 0)
        cw_setVertexPos(cw.id, 3, 0, 0)
    end
    for i = #customWall.anotherPlayer, 1, -1 do 
        local cw = customWall.anotherPlayer[i]

        cw.THICKNESS = playerWallsDistance.value - 30
        if cw.THICKNESS < 0 then cw.THICKNESS = 0 end
        setPosition(customWall.anotherPlayer[i]) 
        cw_setVertexColor4Same(cw.id, cw.color.r.value, cw.color.g.value, cw.color.b.value, cw.color.a.value)
    end
    if customWall.anotherPlayer[1] and l_getSides() ~= customWall.anotherPlayer[1].sides then
        removeOtherPlayerWalls()
        createOtherPlayerWalls()
    end
end

function createOtherPlayerWalls() for i = 1, l_getSides() do anotherPlayerWall(i) end end

function removeOtherPlayerWalls()
    for i = #customWall.anotherPlayer, 1, -1 do
        local cw = customWall.anotherPlayer[i]
        cw_destroy(cw.id)
        table.remove(customWall.anotherPlayer, i)
    end
end