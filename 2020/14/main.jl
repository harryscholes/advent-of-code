using Combinatorics

const fp = "input.txt"

clear_bit(num, pos) = num & ~(2^(pos-1))

set_bit(num, pos) = num | 2^(pos-1)

function run_program(f!)
    mem = Dict{Int, Int}()
    local mask
    for line in eachline(fp)
        if (m = match(r"^mask = (\w+)$", line)) isa RegexMatch
            mask = reverse(m.captures[1])
        elseif (m = match(r"^mem\[(\d+)] = (\d+)$", line)) isa RegexMatch
            loc = parse(Int, m.captures[1])
            val = parse(Int, m.captures[2])
            f!(mem, loc, mask, val)
        end
    end
    return Int(sum(collect(values(mem))))
end

function part_one!(mem, loc, mask, val)
    for (pos, elem) in enumerate(mask)
        if elem == '0' 
            val = clear_bit(val, pos)
        elseif elem == '1' 
            val = set_bit(val, pos)
        end
    end
    mem[loc] = val
end

function part_two!(mem, loc, mask, val)
    x_pos = Int[]
    for (pos, elem) in enumerate(mask)
        if elem == '1' 
            loc = set_bit(loc, pos)
        elseif elem == 'X' 
            loc = clear_bit(loc, pos)
            push!(x_pos, pos)
        end
    end
    for x_pos in powerset(x_pos)
        x_mask = 0
        for pos in x_pos
            x_mask = set_bit(x_mask, pos) 
        end
        mem[loc | x_mask] = val
    end
end

run_program(part_one!) # 7477696999511
@assert run_program(part_one!) == 7477696999511

run_program(part_two!) # 3687727854171
@assert run_program(part_two!) == 3687727854171
