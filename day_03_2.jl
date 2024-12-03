function main()
  raw = read("inputs/day03.txt", String)
  regex = r"mul\((?<number_l>\d+),(?<number_r>\d+)\)|do\(\)|don't\(\)"
  
  mul_match = match(regex, raw)

  result = 0
  offset = 1 # index starts from 1 in julia
  do_instruction = true
  while ~isnothing(mul_match)
    if mul_match.match == "do()"
      do_instruction= true
    elseif mul_match.match == "don't()"
      do_instruction = false
    elseif do_instruction
      number_l = parse(Int64, mul_match[:number_l])
      number_r = parse(Int64, mul_match[:number_r])
      
      result += (number_l * number_r)
    end
    offset += mul_match.offset
    mul_match = match(regex, raw[offset:end])
  end
  println(result)
end

main()

