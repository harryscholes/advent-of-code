using Combinatorics

const fp = "input.txt"

clear(num, bit) = num & ~(2^(bit-1))

set(num, bit) = num | 2^(bit-1)

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
    for (bit, elem) in enumerate(mask)
        if elem == '0' 
            val = clear(val, bit)
        elseif elem == '1' 
            val = set(val, bit)
        end
    end
    mem[loc] = val
end

function part_two!(mem, loc, mask, val)
    x_bits = Int[]
    for (bit, elem) in enumerate(mask)
        if elem == '1' 
            loc = set(loc, bit)
        elseif elem == 'X' 
            loc = clear(loc, bit)
            push!(x_bits, bit)
        end
    end
    for x_bit_set in powerset(x_bits)
        x_mask = 0
        for bit in x_bit_set
            x_mask = set(x_mask, bit) 
        end
        mem[loc | x_mask] = val
    end
end

run_program(part_one!) # 7477696999511
@assert run_program(part_one!) == 7477696999511

run_program(part_two!) # 3687727854171
@assert run_program(part_two!) == 3687727854171
