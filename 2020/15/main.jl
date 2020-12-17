input = [9,3,1,0,8,4]

mutable struct Spoken{T<:Integer}
    last::T
    penultimate::T
end

function nᵗʰ_number(input, n)
    last_spoken = Dict{Int, Spoken}()

    for (i, num) in enumerate(input)
        last_spoken[num] = Spoken(i, -1)
    end

    prev = input[end]

    for i in length(input)+1:n
        s = last_spoken[prev]
        if s.penultimate == -1
            num = 0
        else
            num = s.last - s.penultimate
        end

        if haskey(last_spoken, num)
            s = last_spoken[num]
            s.penultimate = s.last
            s.last = i
        else
            last_spoken[num] = Spoken(i, -1)
        end

        prev = num
    end
    return prev
end

# Part one
nᵗʰ_number(input, 20)

# Part one
nᵗʰ_number(input, 30_000_000)