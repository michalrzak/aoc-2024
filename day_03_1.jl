function main()
  raw = read("inputs/day03.txt", String)
  regex = r"mul\((?<number_l>\d+),(?<number_r>\d+)\)"
  
  mul_match = match(regex, raw)

  result = 0
  offset = 1 # index starts from 1 in julia
  while ~isnothing(mul_match)
    number_l = parse(Int64, mul_match[:number_l])
    number_r = parse(Int64, mul_match[:number_r])
    
    result += (number_l * number_r)

    offset += mul_match.offset
    mul_match = match(regex, raw[offset:end])
  end
  println(result)
end

main()

