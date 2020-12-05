function binary_search(xs, low, high, low_symbol, high_symbol)
    for x in xs
        if x == low_symbol
            high = low + (high - low) ÷ 2
        elseif x == high_symbol
            low = high - (high - low) ÷ 2
        end
    end
    return row[end] == low_symbol ? low : high
end

function decode(bp)
    row = binary_search(bp[1:7], 0, 127, 'F', 'B')
    seat = binary_search(bp[8:end], 0, 7, 'L', 'R')
    return row, seat
end

seat_id(row, seat) = row * 8 + seat 

# Part one
function find_highest_seat_id(fp)
    highest = 0
    for bp in eachline(fp)
        id = seat_id(decode(bp)...)
        if id > highest
            highest = id
        end
    end
    return highest
end

find_highest_seat_id("input.txt")

# Part two
using DataStructures

function find_my_seat(fp)
    d = DefaultDict{Int,Vector{Int}}([])
    for bp in eachline("input.txt")
        row, seat = decode(bp)
        push!(d[row], seat)
    end

    for (row, seats) in d
        if length(seats) != 8
            if length(d[row-1]) == 8 && length(d[row+1]) == 8
                seat = setdiff(0:7, seats)[1]
                return row, seat, seat_id(row, seat)
            end
        end
    end
end

find_my_seat("input.txt")