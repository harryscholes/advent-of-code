fp = "test.txt"
fp = "input.txt"

struct Bus
    id::Int128
    offset::Int
end

function load()
    lines = collect(eachline(fp))
    time = parse(Int, lines[1])
    buses = Bus[]
    for (i, b) in enumerate(split(lines[2], ","))
        if b == "x"
            continue
        end
        push!(buses, Bus(parse(Int128, b), i - 1))
    end
    return time, buses
end

function until(t, b)
    t_since = t % b
    return b - t_since
end

# Part one

function part_one(t, bs)
    wait = typemax(Int)
    bus = 0
    for b in bs
        w = until(t, b.id)
        if w < wait
            wait = w
            bus = b
        end
    end
    return b.id * w
end

t, bs = load()
part_one(t, bs)

# Part two

function chinese_remainder(n, a)
    Π = prod(n)
    return mod(sum(ai * invmod(Π ÷ ni, ni) * Π ÷ ni for (ni, ai) in zip(n, a)), Π)
end

function part_two(bs)
    modulos = map(b->b.id, bs)
    remainders = map(b->b.id - b.offset, bs)
    return chinese_remainder(modulos, remainders)
end

_, bs = load()
part_two(bs)

# Brute force approach works, but is way too slow on the full input
function earliest_timestamp(bs)
    t = 100_020_000_000_000
    t_stop = 2t
    n = length(bs)
    ts = collect(t:t+n-1)
    found = true
    while true
        for i in 1:n
            tᵢ = ts[i]
            bᵢ = bs[i]
            bᵢ == -1 && continue
            if until(tᵢ, bᵢ) != 0
                found = false
                break
            end
        end
        found && return t
        t += 1
        t > t_stop && break
        ts .+= 1
        found = true
    end
end
function until(t, b)
    t_since = t % b
    if t_since == 0
        return t_since
    end
    return b - t_since
end