const required_fields = [
    "byr",
    "iyr",
    "eyr",
    "hgt",
    "hcl",
    "ecl",
    "pid",
]

const required_fields_set = Set(required_fields)

const fp = "input.txt"

function valid_passports()
    n = 0
    curr_passport = Dict{String,String}()
    itr = eachline(fp)
    line = iterate(itr)
    while !isnothing(line)
        l, state = line
        if l == ""
            if is_valid_passport(curr_passport)
                n += 1
            end
            empty!(curr_passport)
        end
        for kv in split(l)
            k, v = split(kv, ":")
            curr_passport[k] = v
        end
        line = iterate(itr, state)
    end
    if is_valid_passport(curr_passport)
        n += 1
    end
    return n
end

# Part one
is_valid_passport(d) = length(collect(keys(d)) ∩ required_fields_set) ≥ 7

valid_passports()

# Part two
function is_valid_passport(d)
    length(collect(keys(d)) ∩ required_fields_set) ≥ 7 &&
        is_valid_date(d["byr"], 1920, 2002) &&
        is_valid_date(d["iyr"], 2010, 2020) &&
        is_valid_date(d["eyr"], 2020, 2030) &&
        is_valid_height(d["hgt"]) &&
        is_valid_regex(r"^#[0-9a-f]{6}$", d["hcl"]) &&
        is_valid_regex(r"^amb|blu|brn|gry|grn|hzl|oth$", d["ecl"]) &&
        is_valid_regex(r"^\d{9}$", d["pid"])
end

function is_valid_regex(r, x)
    m = match(r, x)
    m isa RegexMatch && return true
    return false
end

function is_valid_date(x, low, high)
    is_valid_regex(r"^\d{4}$", x) || return false
    return low ≤ parse(Int, x) ≤ high
end

function is_valid_height(x)
    m = match(r"^(\d+)(cm|in)$", x)
    m isa RegexMatch || return false
    return (m.captures[2] == "cm" && 150 ≤ parse(Int, m.captures[1]) ≤ 193) ||
        (m.captures[2] == "in" && 59 ≤ parse(Int, m.captures[1]) ≤ 76)
end

valid_passports()
