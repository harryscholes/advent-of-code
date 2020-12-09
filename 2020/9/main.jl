using DataStructures

mutable struct LRUCache{T}
    s::Set{T}
    l::MutableLinkedList{T}
    n::Int

    function LRUCache{T}(n::Integer) where T
        new{T}(Set{T}(), MutableLinkedList{T}(), n)
    end
end

function Base.push!(c::LRUCache{T}, item::T) where T
    if length(c.l) == c.n
        evicted = pop!(c.l)
        delete!(c.s, evicted)
    end
    pushfirst!(c.l, item)
    push!(c.s, item)
    return c
end

const fp = "input.txt"
const preamble = 25
const xs = map(x->parse(Int, x), eachline(fp))

# Part one
function f(xs)
    c = LRUCache{Int}(preamble)
    for x in xs
        if length(c.s) == c.n 
            is_sum = false
            for y in c.s
                r = x - y
                if r ∈ c.s
                    is_sum = true
                    break
                end
            end
            !is_sum && return x
        end
        push!(c, x)
    end
end

f(xs)

# Part two
const target = f(xs)

function g(xs)
    n = 2
    l = length(xs)
    while true
        for i in 1:l-n+1
            ys = @views xs[i:i+n-1]
            sum(ys) == target && return sum(extrema(ys))
        end
        n += 1
    end
end

g(xs)