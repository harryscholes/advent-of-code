function load_map(fp)
    xs = Vector{Vector{Int}}()
    for line in eachline(joinpath(@__DIR__, fp))
        push!(xs, map(x->x=='.' ? 0 : 1, collect(line)))
    end
    return permutedims(hcat(xs...))
end

function trees_on_path(M, right, down)
    height, width = size(M)
    n_trees = 0
    i, j = 1, 1
    while i ≤ height
        n_trees += M[i, j]
        i += down
        j += right
        j = j == width ? width : j % width
    end
    return n_trees
end

# (right, down) tuples
const policies = [
    (3, 1),
    (1, 1),
    (5, 1),
    (7, 1),
    (1, 2),
]

M = load_map("input.txt")

# Part one
trees_on_path(M, policies[1]...)

# Part two
prod(map(policy->trees_on_path(M, policy...), policies))