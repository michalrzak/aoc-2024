raw_file = read("inputs/day1.txt", String)

lines = split(raw_file, "\n")
pop!(lines)

raw_elements = split.(lines, "   ")

left = [parse(Int64, ele[1]) for ele in raw_elements]
right = [parse(Int64, ele[2]) for ele in raw_elements]

left_sorted = sort(left)
right_sorted = sort(right)

diff = Iterators.map(x -> abs(x[1] - x[2]), zip(left_sorted, right_sorted))

result = Iterators.reduce(+, diff)

println(result)

