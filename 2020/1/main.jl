using DelimitedFiles, Combinatorics

xs = readdlm(joinpath(@__DIR__, "input.txt"), Int)

const target = 2020

# Part one: O(n^2)
# Part two: O(n^3)
function f(xs, n)
    for ys in combinations(xs, n)
        if sum(ys) == target
            return prod(ys)
        end
    end
end

# Part one
f(xs, 2)

# Part two
f(xs, 3)

# Part one: O(n)
function g(xs)
    s = Set(xs)
    for x in xs
        y = target - x
        if y in s
            return x * y
        end
    end
end

# Part one: O(n)
function g(xs)
    s = Set{Int}()
    for x in xs
        y = target - x
        if y in s
            return x * y
        end
        push!(s, x)
    end
end

g(xs)

# Part two: O(n)
function h(xs)
    s = Set(xs)
    for x in xs
        r = target - x
        for y in 1:r÷2
            z = r - y
            if y in s && z in s
                return x * y * z
            end
        end
    end
end

h(xs)

# Part two: O(n)
function h(xs)
    s = Set{Int}()
    for x in xs
        r = target - x
        for y in 1:r÷2
            z = r - y
            if y in s && z in s
                return x * y * z
            end
        end
        push!(s, x)
    end
end

h(xs)