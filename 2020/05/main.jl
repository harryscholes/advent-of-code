const n_rows = 128
const row_width = 8

function binary_search(xs, low, high, low_symbol, high_symbol)
    for x in xs
        diff = (high - low) ÷ 2
        if x == low_symbol
            high = low + diff
        elseif x == high_symbol
            low = high - diff
        end
    end
    return xs[end] == low_symbol ? low : high
end

function decode(bp)
    row = binary_search(bp[1:7], 0, n_rows - 1, 'F', 'B')
    seat = binary_search(bp[8:end], 0, row_width - 1, 'L', 'R')
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
function find_my_seat(fp)
    d = Dict{Int,Vector{Bool}}()
    for bp in eachline(fp)
        row, seat = decode(bp)
        if !haskey(d, row)
            d[row] = falses(8)
        end
        d[row][seat+1] = true
    end

    checked_rows = Set{Int}()
    for (row, seats) in d
        if row ∉ checked_rows &&
            !all(d[row]) &&
            haskey(d, row-1) && all(d[row-1]) &&
            haskey(d, row+1) && all(d[row+1])
                seat = findfirst(x->!x, seats) - 1
                return row, seat, seat_id(row, seat)
        end
        push!(checked_rows, row)
    end
end

find_my_seat("input.txt")
