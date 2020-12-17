struct PasswordPolicy
    low::Int
    high::Int
    letter::Char
    password::String
end

const re = r"(\d+)\-(\d+)\s([a-z]):\s([a-z]+)"

function parse_passwords()
    map(eachline("input.txt")) do line
        m = match(re, line)
        p = PasswordPolicy(
            parse(Int, string(m.captures[1])),
            parse(Int, string(m.captures[2])),
            first(m.captures[3]),
            m.captures[4],
        )
    end
end

passwords = parse_passwords()

# Part one
filter(passwords) do p
    p.low ≤ count(c->c == p.letter, p.password) ≤ p.high
end

# Part two
filter(passwords) do p
    (p.password[p.low] == p.letter) ⊻ (p.password[p.high] == p.letter)
end
