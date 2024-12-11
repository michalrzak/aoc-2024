using Pipe: @pipe

function digit_count(num)
  floor(Int64, log10(num)) + 1
end

function main()
  raw = read("inputs/day11.txt", String)
  numbers = @pipe raw |>
                  strip(_, '\n') |>
                  split(_, " ") |>
                  parse.(Int128, _)

  for _ in 1:25
    new_nums = []
    for num in numbers
      if num == 0
        push!(new_nums, 1)
        continue
      end

      n_digits = digit_count(num)

      if n_digits % 2 == 0
        modifier = 10^(n_digits ÷ 2)
        push!(new_nums, num ÷ modifier)
        push!(new_nums, num % modifier)
      else
        push!(new_nums, num * 2024)
      end
    end
    numbers = new_nums
  end

  println(length(numbers))
end

main()

