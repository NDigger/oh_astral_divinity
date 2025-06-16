if u_getDifficultyMult() == 1 then
    function makeTriangle()
        l_setSides(3)

        keys = { 0, 1, 102, 301, 1004 }
        shuffle(keys)
        index = 1
    end

    function makeSquare()
        l_setSides(4)
        l_setDelayMult(1.5)

        keys = { 102, 102, 300, 301 }
        shuffle(keys)
        index = 1

        t_clear()
    end

    function makePentagon()
        l_setSides(5)

        keys = { 0, 1, 11, 12, 100, 102, 200, 201, 300, 301, 302, 303, 1004 }
        shuffle(keys)
        index = 1

        t_clear()
        t_wait(calcHalfSidesDelay())
    end

    function makeHexagon()
        l_setSides(6)

        keys = { 0, 1, 11, 12, 100, 102, 200, 201, 300, 301, 302, 303, 1004 }
        shuffle(keys)
        index = 1

        t_clear()
        t_wait(calcHalfSidesDelay())
    end

    function makeOctagon()
        l_setSides(8)
        l_setDelayMult(1.6)

        keys = { 0, 1, 11, 12, 100, 102, 301, 1004 }
        shuffle(keys)
        index = 1

        t_clear()
    end

    function makeDecagon()
        l_setSides(10)
        l_setDelayMult(1.75)

        keys = { 0, 1, 102, 102, 301 }
        shuffle(keys)
        index = 1

        t_clear()
    end
end