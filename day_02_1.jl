raw = read("inputs/day02.txt", String)
lines = split(raw, "\n")
pop!(lines)

numbers_strings = split.(lines, " ")
numbers = map.(x -> parse(Int64, x), numbers_strings)

previous = 0
diffs = map.(x -> begin
                                global previous
                                p = previous
                                previous = x
                                p - x
                end, numbers)
popfirst!.(diffs)

descending = reduce.(&, map.(x -> 4 > x > 0, diffs))
ascending = reduce.(&, map.(x -> -4 < x < 0, diffs))

result = count(descending) + count(ascending)
println(result)

