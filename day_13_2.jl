function main()
  raw = read("inputs/day13.txt", String)
  inputs = split(raw, "\n\n")
  input_regex = r"^Button A: X\+(?<a1>\d+), Y\+(?<b1>\d+)\nButton B: X\+(?<a2>\d+), Y\+(?<b2>\d+)\nPrize: X\=(?<result1>\d+), Y\=(?<result2>\d+)$"

  parsed = match.(input_regex, inputs)
  variables = [:a1, :a2, :b1, :b2, :result1, :result2]
  parsed_ints = map(x -> Dict(var => parse(Int128, x[var]) for var in variables), parsed)

  presses = map(x ->
      begin
        b = ((10000000000000 + x[:result2]) - ((10000000000000 + x[:result1]) // x[:a1] * x[:b1])) // (-x[:a2] // x[:a1] * x[:b1] + x[:b2])
        a = ((10000000000000 + x[:result1]) // x[:a1] - x[:a2] // x[:a1] * b)
        (a, b)
      end, parsed_ints)

  whole_presses = filter(x -> isinteger(x[1]) && isinteger(x[2]), presses)

  cost = map(x -> 3 * x[1] + x[2], whole_presses)
  result = sum(cost)
  println(result)

end

main()
