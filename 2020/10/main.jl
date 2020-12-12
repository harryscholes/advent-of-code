const JOLT_RANGE = 1:3

const fp = "input.txt"

const vs = map(v->parse(Int, v), eachline(fp))
sort!(vs)
pushfirst!(vs, 0)
push!(vs, last(vs) + last(JOLT_RANGE))

function graph(vs::AbstractVector{T}) where T
    adj = Dict(v => T[] for v in vs)
    for n in vs
        for i in JOLT_RANGE
            m = n + i
            if haskey(adj, m)
                push!(adj[n], m)
            end
        end
    end
    return adj
end

g = graph(vs)

length(vs) # 96 nodes
sum(length.(collect(values(g)))) # 169 edges

# Part one

function longest_path(vs, g)
    d = Dict(i => 0 for i in JOLT_RANGE)
    for n in vs
        for m in g[n]
            r = m - n
            d[r] += 1
            break
        end
    end
    return d[first(JOLT_RANGE)] * d[last(JOLT_RANGE)]
end

longest_path(vs, g)

# Part two

# Khan's topological sort algorithm: O(|V| + |E|)
function topological_sort(vs, g)
    in_degree = Dict(v => 0 for v in vs)
    for n in vs, m in g[n]
        in_degree[m] += 1
    end

    g = deepcopy(g)
    l = Int[]
    s = [v for v in vs if in_degree[v] == 0]
    
    while length(s) > 0
        n = pop!(s)
        push!(l, n)
        while length(g[n]) > 0
            m = pop!(g[n])
            in_degree[m] -= 1
            if in_degree[m] == 0
                push!(s, m)
            end
        end
    end
    return l
end

# Find all paths in a DAG: O(|V| + |E|)
function paths(vs, g)
    paths_from = Dict{Int,Int}(v => 0 for v in vs)
    paths_from[vs[end]] += 1
    for n in reverse(topological_sort(vs, g))
        for m in g[n]
            paths_from[n] += paths_from[m]
        end
    end
    return paths_from[vs[1]]
end

paths(vs, g) # 14_173_478_093_824 paths between the start and end nodes

# Poor time complexity
function dfs(vs)
    s = Set(vs)
    max = vs[end]
    t = 0
    stack = Int[]
    push!(stack, vs[1])

    while length(stack) > 0
        n = pop!(stack)
        for i in JOLT_RANGE
            m = n + i
            if m in s
                push!(stack, m)
                if m == max
                    t += 1
                end
            end
        end
    end
    return t
end

dfs(vs)
