using DataStructures

const fp = "input.txt"

const my_bag = "shiny gold"

# Part one
function inner_to_outer_directed_graph()
    graph = DefaultDict{String,Vector{String}}([])
    for policy in eachline(fp)
        occursin("no other bags", policy) && continue
        outer_bag = match(r"(\w+ \w+)", policy).captures[1]
        _, inner_bags = split(policy, "contain")
        for inner_bag in split(inner_bags, ",")
            inner_bag = match(r"(\d+) (\w+ \w+) bag", inner_bag).captures[2]
            push!(graph[inner_bag], outer_bag)
        end
    end
    return graph
end

function bfs(graph)
    q = Queue{String}()
    enqueue!(q, my_bag)
    bags = Set{String}()
    while length(q) > 0
        inner_bag = dequeue!(q)
        for outer_bag in graph[inner_bag]
            if outer_bag ∉ bags
                enqueue!(q, outer_bag)
                push!(bags, outer_bag)
            end
        end
    end
    return bags
end

g = inner_to_outer_directed_graph()
length(bfs(g))

function recurse(graph, bag, bags=Set{String}())
    for bag in graph[bag]
        if bag ∉ bags
            push!(bags, bag)
            recurse(graph, bag, bags)
        end
    end
    return bags
end

g = inner_to_outer_directed_graph()
length(recurse(g, my_bag))

# Part two
struct Bag
    amount::Int
    colour::String
end

function outer_to_inner_directed_graph()
    graph = DefaultDict{String,Vector{Bag}}([])
    for policy in eachline(fp)
        occursin("no other bags", policy) && continue
        outer_bag = match(r"(\w+ \w+)", policy).captures[1]
        _, inner_bags = split(policy, "contain")
        for inner_bag in split(inner_bags, ",")
            m = match(r"(\d+) (\w+ \w+) bag", inner_bag)
            push!(
                graph[outer_bag],
                Bag(
                    parse(Int, m.captures[1]),
                    m.captures[2],
                )
            )
        end
    end
    return graph
end

function bfs(graph)
    q = Queue{Tuple{String,Int}}()
    enqueue!(q, (my_bag, 1))
    bags = Int[]
    while length(q) > 0
        outer_bag, n_outer = dequeue!(q)
        for inner_bag in graph[outer_bag]
            n_inner = n_outer * inner_bag.amount
            enqueue!(q, (inner_bag.colour, n_inner))
            push!(bags, n_inner)
        end
    end
    return bags
end

g = outer_to_inner_directed_graph()
sum(bfs(g))

function recurse(graph, bag, n_outer, bags=Int[])
    for bag in graph[bag.colour]
        n_inner = n_outer * bag.amount
        push!(bags, n_inner)
        recurse(graph, bag, n_inner, bags)
    end
    return bags
end

recurse(graph, bag) = recurse(graph, Bag(1, bag), 1)

g = outer_to_inner_directed_graph()
sum(recurse(g, my_bag))
