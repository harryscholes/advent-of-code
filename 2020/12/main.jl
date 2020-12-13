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

struct Instruction
    d::Direction
    v::Int
end

function Instruction(d::AbstractString, v::AbstractString)
    Instruction(
        DIRECTION_MAPPER[d],
        mod(parse(Int, v), 360),
    )
end

# Rotate 90° right
rotate(x, y) = (y, -x)

function rotate(x, y, angle)
    # All rotations are a multiple of 90° rotations
    n = angle ÷ 90
    for _ in 1:n
        x, y = rotate(x, y)
    end
    return x, y
end

function move!(x, y, d, v)
    if d == 0
        y += v
    elseif d == 90
        x += v
    elseif d == 180
        y -= v
    elseif d == 270
        x -= v
    end
    return x, y
end

manhattan(x, y) = abs(x) + abs(y)

instructions = map(eachline(fp)) do line
    m = match(INSTRUCTION_REGEX, line)
    Instruction(m.captures...)
end

# Part one

function navigate(instructions; x, y, d)
    for i in instructions
        if i.d == L || i.d == R
            v = i.v
            if i.d == L
                v *= -1
            end
            d = mod(d + v, 360)
            continue
        
        elseif i.d == N || i.d == E || i.d == S || i.d == W
            temporary_d = Int(i.d)
            x, y = move!(x, y, temporary_d, i.v)
        
        elseif i.d == F
            x, y = move!(x, y, d, i.v)
        end
    end

    return x, y
end

manhattan(navigate(instructions; x=0, y=0, d=90)...)

# Part two

function navigate(instructions; x, y, wx, wy)
    for i in instructions
        if i.d == N || i.d == E || i.d == S || i.d == W
            wx, wy = move!(wx, wy, Int(i.d), i.v)
        
        elseif i.d == L || i.d == R
            angle = Int(i.v)
            # L is the inverse of R
            if i.d == L 
                angle = 360 - angle 
            end
            wx, wy = rotate(wx, wy, angle)

        elseif i.d == F
            x += wx * i.v
            y += wy * i.v
        end
    end
    return x, y
end

manhattan(navigate(instructions; x=0, y=0, wx=10, wy=1)...)
