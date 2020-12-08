const fp = "input.txt"

mutable struct Operation
    op::String
    val::Int
end

const ops = map(eachline(fp)) do line
    op, val = split(line)
    Operation(op, parse(Int, val))
end

function program(ops)
    n = length(ops)
    i = 1
    t = 0
    seen = Set{Int}()
    while true
        op = ops[i]
        if op.op == "acc"
            t += op.val
            i += 1
        elseif op.op == "jmp"
            i += op.val
        elseif op.op == "nop"
            i += 1
        end
        i > n && break
        i in seen && break
        push!(seen, i)
    end
    return i, t
end

function restore(ops)
    n = length(ops)
    switch = op -> op.op = op.op == "jmp" ? "nop" : "jmp"
    for i in 1:n
        op = ops[i]
        op.op == "acc" && continue
        switch(op)
        try
            idx, t = program(ops)
            idx > n && return t
        finally
            switch(op)
        end
    end
end

# Part one
program(ops)[2]


# Part two
restore(ops)