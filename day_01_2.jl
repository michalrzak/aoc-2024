raw_file = read("inputs/day1.txt", String)

lines = split(raw_file, "\n")
pop!(lines)

raw_elements = split.(lines, "   ")

left = [parse(Int64, ele[1]) for ele in raw_elements]
right = [parse(Int64, ele[2]) for ele in raw_elements]

left_sorted = sort(left)

right_unique = Set(right)
right_counts = Dict(ele => count(i -> i == ele, right) for ele in right_unique)

multiplied = Iterators.map(x -> x * get(right_counts, x, 0), left_sorted)
result = Iterators.reduce(+, multiplied)
println(result)

