using Pipe: @pipe

function is_bit_on(number, idx, len)
  flipped_idx = len - idx
  shifted_number = number >> flipped_idx

  shifted_number % 2 == 1
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
    for operations in 0:(2^(length(option)-1)-1)
      result = 0

      for (i, num) in enumerate(option)
        # first case
        if result == 0
          result = num
          continue
        end

        if is_bit_on(operations, i - 1, length(option) - 1)
          result *= num
        else
          result += num
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

