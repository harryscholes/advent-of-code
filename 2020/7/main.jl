using DataStructures

const fp = "input.txt"

const my_bag = "shiny gold"

# Part one
function inner_to_outer_relationships()
    d = DefaultDict{String,Vector{String}}([])
    for policy in eachline(fp)
        occursin("no other bags", policy) && continue
        outer_bag = match(r"(\w+ \w+)", policy).captures[1]
        _, inner_bags = split(policy, "contain")
        for inner_bag in split(inner_bags, ",")
            inner_bag = match(r"(\d+) (\w+ \w+) bag", inner_bag).captures[2]
            push!(d[inner_bag], outer_bag)
        end
    end
    return d
end

function find_bags(d)
    q = Queue{String}()
    enqueue!(q, my_bag)
    bags = Set{String}()
    while length(q) > 0
        inner_bag = dequeue!(q)
        for outer_bag in d[inner_bag]
            if outer_bag ∉ bags
                enqueue!(q, outer_bag)
                push!(bags, outer_bag)
            end
        end
    end
    return bags
end

d = inner_to_outer_relationships()
length(find_bags(d))

# Part two
struct Bag
    amount::Int
    colour::String
end

function outer_to_inner_relationships()
    d = DefaultDict{String,Vector{Bag}}([])
    for policy in eachline(fp)
        occursin("no other bags", policy) && continue
        outer_bag = match(r"(\w+ \w+)", policy).captures[1]
        _, inner_bags = split(policy, "contain")
        for inner_bag in split(inner_bags, ",")
            m = match(r"(\d+) (\w+ \w+) bag", inner_bag)
            push!(
                d[outer_bag],
                Bag(
                    parse(Int, m.captures[1]),
                    m.captures[2],
                )
            )
        end
    end
    return d
end

function find_bags(d)
    q = Queue{Tuple{String,Int}}()
    enqueue!(q, (my_bag, 1))
    bags = Int[]
    while length(q) > 0
        outer_bag, n_outer = dequeue!(q)
        for inner_bag in d[outer_bag]
            n_inner = n_outer * inner_bag.amount
            enqueue!(q, (inner_bag.colour, n_inner))
            push!(bags, n_inner)
        end
    end
    return bags
end

d = outer_to_inner_relationships()
sum(find_bags(d))