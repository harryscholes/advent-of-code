fp = "test.txt"
fp = "input.txt"

@enum Seat begin
    Occupied
    Empty
    Floor
end

SEAT_MAPPER = Dict(
    'L' => Empty,
    '#' => Occupied,
    '.' => Floor,
)

function load()
    grid = map(eachline(fp)) do line
        map(collect(line)) do x
            SEAT_MAPPER[x]
        end
    end
    permutedims(hcat(grid...))
end

function recurse(grid)
    new_grid = apply_rules(grid)
    if new_grid == grid
        return new_grid
    end
    recurse(new_grid)
end

# Part one

function apply_rules(grid)
    new_grid = deepcopy(grid)
    n, m = size(grid)
    for i in 1:n, j in 1:m
        seat = grid[i, j]
        if seat == Empty
            if count(s->s==Occupied, adjacent(grid, i, j)) == 0
                seat = Occupied
            end
        elseif seat == Occupied
            if count(s->s==Occupied, adjacent(grid, i, j)) ≥ 5 # includes current seat
                seat = Empty
            end
        end
        new_grid[i, j] = seat
    end
    return new_grid
end

function adjacent(grid, i, j)
    n, m = size(grid)
    return @views grid[
        clamp(i-1, 1, n):clamp(i+1, 1, n),
        clamp(j-1, 1, m):clamp(j+1, 1, m),
    ]
end

grid = load()
stable_grid = recurse(grid)
count(==(Occupied), stable_grid)

# Part two

function apply_rules(grid)
    new_grid = deepcopy(grid)
    n, m = size(grid)
    for i in 1:n, j in 1:m
        seat = grid[i, j]
        if seat == Empty
            seat = empty_policy(grid, i, j)
        elseif seat == Occupied
            seat = occupied_policy(grid, i, j)
        end
        new_grid[i, j] = seat
    end
    return new_grid
end

function empty_policy(grid, i, j)
    for slice in slices(grid, i, j)
        for seat in slice
            if seat == Occupied
                return Empty
            elseif seat == Empty
                break
            end
        end
    end
    return Occupied
end

function occupied_policy(grid, i, j)
    c = 0
    for slice in slices(grid, i, j)
        for seat in slice
            if seat == Occupied
                c += 1
            end
            if seat != Floor
                break
            end
        end
    end
    if c ≥ 5
        return Empty
    end
    return Occupied
end

function slice(grid, i_range, j_range)
    if i_range isa Integer
        i_range = Iterators.repeated(i_range)
    end
    if j_range isa Integer
        j_range = Iterators.repeated(j_range)
    end
    return [grid[i,j] for (i,j) in zip(i_range, j_range)]
end

function slices(grid, i, j)
    n, m = size(grid)
    return [
        # vertical
        slice(grid, i+1:n, j), # up
        slice(grid, i-1:-1:1, j), # down
        
        # horizontal
        slice(grid, i, j+1:m), # right
        slice(grid, i, j-1:-1:1), # left

        # diagonal
        slice(grid, i+1:n, j+1:m), # down right
        slice(grid, i-1:-1:1, j-1:-1:1), # up left
        slice(grid, i+1:n, j-1:-1:1), # down left
        slice(grid, i-1:-1:1, j+1:m), # up right
    ]
end

fp = "input.txt"
grid = load()
stable_grid = recurse(grid)
count(==(Occupied), stable_grid)