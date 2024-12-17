function get_combo(value, a, b, c)
  if 0 <= value <= 3
    return value
  end
  if value == 4
    return a
  end
  if value == 5
    return b
  end
  if value == 6
    return c
  end

  return nothing
end

function main()
  raw = read("inputs/day17.txt", String)
  (registers_raw, program_raw) = split(raw, "\n\n")

  register_lines = split(registers_raw, "\n")
  register_values = split.(register_lines, ": ")
  a = parse(Int128, register_values[1][2])
  b = parse(Int128, register_values[2][2])
  c = parse(Int128, register_values[3][2])

  (_, program_str) = split(program_raw, ": ")
  program = map(x -> parse(Int8, x), split(program_str, ","))

  starting_points = Set([0])
  tested_a = 0
  possible_solutions = Set()
  for (pos, num) in enumerate(program)
    println((starting_points))
    println(pos)
    new_starting_points = Set()
    for starting_point in starting_points
      for n in 0:2^13-1
        tested_a = starting_point + (n << (3 * (pos - 1)))
        a = tested_a
        b = 0
        c = 0
        result = ""
        result_count = 0
        i = 1
        while i <= length(program)
          instruction = program[i]
          operand = program[i+1]
          combo = get_combo(operand, a, b, c)

          if isnothing(combo)
            break
          end

          if instruction == 0
            a = a ÷ 2^combo
          elseif instruction == 1
            b = b ⊻ operand
          elseif instruction == 2
            b = combo % 8
          elseif instruction == 3
            if a != 0
              i = operand + 1  # +1 due to julia starting at 1
              continue  # skip adding 2
            end
          elseif instruction == 4
            b = b ⊻ c
          elseif instruction == 5
            if result != ""
              result *= ","
            end
            result *= string(combo % 8)
            result_count += 1
            if ~startswith(program_str, result)
              break
            end
            if result_count == pos
              push!(new_starting_points, tested_a % (2^(pos * 3)))
              break
            end
          elseif instruction == 6
            b = a ÷ 2^combo
          elseif instruction == 7
            c = a ÷ 2^combo
          end

          i += 2
        end
        if result == strip(program_str, '\n')
          push!(possible_solutions, tested_a)
        end
      end
    end
    starting_points = new_starting_points
  end
  minumum_found_solution = minimum(possible_solutions)
  println(minumum_found_solution)
end

main()

