const fp = "input.txt"

# Part one
function f()
    s = Set{Char}()
    t = 0
    for line in eachline(fp)
        if isempty(line)
            t += length(s)
            empty!(s)
        else
            push!(s, collect(line)...)
        end
    end
    return t
end

f()

# Part two
function f()
    s = Set{Char}()
    t = 0
    new_group = true
    for line in eachline(fp)
        if isempty(line)
            t += length(s)
            empty!(s)
            new_group = true
        elseif new_group
            push!(s, collect(line)...)
            new_group = false
        else
            intersect!(s, collect(line))
        end
    end
    return t
end

f()