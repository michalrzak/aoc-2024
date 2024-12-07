using Pipe: @pipe

function get_operation(number, idx, len)
  flipped_idx = len - idx
  shifted_number = number ÷ (3^flipped_idx)
  shifted_number % 3
end

function main()
  raw = read("inputs/day07.txt", String)
  lines = split(raw, "\n")
  pop!(lines) # remove last empty line

  entries = split.(lines, ": ")

  targets = @pipe entries |>
                  map(x -> x[1], _) |>
                  map(x -> parse(Int64, x), _)

  options = @pipe entries |>
                  map(x -> split(x[2], " "), _) |>
                  map(x -> parse.(Int64, x), _)

  solution::Int128 = 0

  for (target, option) in zip(targets, options)
    for operations in 0:(3^(length(option)-1)-1)
      result = 0

      for (i, num) in enumerate(option)
        # first case
        if result == 0
          result = num
          continue
        end

        op = get_operation(operations, i - 1, length(option) - 1)
        if op == 0
          result *= num
        elseif op == 1
          result += num
        else
          result = result * 10^(floor(Int64, log10(num)) + 1) + num
        end
      end
      if result == target
        solution += target
        break
      end

    end
  end

  println(solution)

end

main()

