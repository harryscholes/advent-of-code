const fp = "input.txt"

@enum Direction begin
    N = 0
    E = 90
    S = 180
    W = 270
    L
    R
    F
end

struct Instruction
    d::Direction
    v::Int
end

const DIRECTION_MAPPER = Dict(
    "N" => N,
    "S" => S,
    "E" => E,
    "W" => W,
    "L" => L,
    "R" => R,
    "F" => F,
)

const INSTRUCTION_REGEX = r"^([A-Z])(\d+)$"

instructions = map(eachline(fp)) do line
    m = match(INSTRUCTION_REGEX, line)
    Instruction(
        DIRECTION_MAPPER[m.captures[1]],
        mod(parse(Int, m.captures[2]), 360),
    )
end

manhattan(x, y) = abs(x) + abs(y)

# Rotate 90° right
rotate(x, y) = (y, -x)

# Part one

function navigate(instructions; x, y, d)
    prev_d = d

    for i in instructions
        if i.d == R
            d = mod(d + i.v, 360)
            continue
        elseif i.d == L
            d = mod(d - i.v, 360)
            continue
        end

        prev_d = d

        if i.d == N || i.d == E || i.d == S || i.d == W
            d = Int(i.d)
            restore_d = true
        end

        if d == 0
            y += i.v
        elseif d == 90
            x += i.v
        elseif d == 180
            y -= i.v
        elseif d == 270
            x -= i.v
        else 
            error("d = $d")
        end
        
        if i.d == N || i.d == E || i.d == S || i.d == W
            d = prev_d
        end
    end

    return x, y
end

manhattan(navigate(instructions; x=0, y=0, d=90)...)

# Part two

function navigate(instructions; x, y, wx, wy)
    for i in instructions
        if i.d == N || i.d == E || i.d == S || i.d == W
            d = Int(i.d)
            if d == 0
                wy += i.v
            elseif d == 90
                wx += i.v
            elseif d == 180
                wy -= i.v
            elseif d == 270
                wx -= i.v
            end
        elseif i.d == L || i.d == R
            angle = Int(i.v)
            # L is the inverse of R
            if i.d == L 
                angle = 360 - angle 
            end
            # All rotations are a multiple of 90° rotations
            n = angle ÷ 90
            for _ in 1:n
                wx, wy = rotate(wx, wy)
            end
        elseif i.d == F
            x += wx * i.v
            y += wy * i.v
        end
    end
    return x, y
end

manhattan(navigate(instructions; x=0, y=0, wx=10, wy=1)...)
