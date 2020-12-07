using DataStructures

const fp = "input.txt"

const my_bag = "shiny gold"

# Part one
function graph()
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

g = graph()
length(bfs(g))

function recurse(graph, bag, bags=Set{String}())
    for bag in graph[bag]
        push!(bags, bag)
        recurse(graph, bag, bags)
    end
    return bags
end

g = graph()
length(recurse(g, my_bag))

# Part two
struct Bag
    amount::Int
    colour::String
end

function graph2()
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

function bfs2(graph)
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

g = graph2()
sum(bfs2(g))

function recurse2(graph::AbstractDict, bag_amount::Tuple{Bag,<:Integer}, bags=Int[])
    bag, n_outer = bag_amount
    n_inner = n_outer * bag.amount
    push!(bags, n_inner)
    for bag in graph[bag.colour]
        recurse2(graph, (bag, n_inner), bags)
    end
    return bags
end

function recurse2(graph::AbstractDict, bag::AbstractString)
    bag_amount = (Bag(1, bag), 1)
    bags = recurse2(graph, bag_amount)
    return bags[2:end]
end

g = graph2()
sum(recurse2(g, my_bag))
