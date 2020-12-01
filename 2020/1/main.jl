using DelimitedFiles, Combinatorics

xs = readdlm(joinpath(@__DIR__, "input.txt"), Int)

function f(xs, n)
    for ys in combinations(xs, n)
        if sum(ys) == 2020
            return prod(ys)
        end
    end
end

# Part one
f(xs, 2)

# Part two
f(xs, 3)