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

  number_dict = Dict{Int128,Int64}(num => count(==(num), numbers) for num in Set(numbers))

  for _ in 1:75
    new_nums_dict = Dict{Int128,Int64}()
    for num in keys(number_dict)
      if num == 0
        new_nums_dict[1] = get(new_nums_dict, 1, 0) + number_dict[num]
        continue
      end

      n_digits = digit_count(num)

      if n_digits % 2 == 0
        modifier = 10^(n_digits ÷ 2)
        new_nums_dict[num÷modifier] = get(new_nums_dict, num ÷ modifier, 0) + number_dict[num]
        new_nums_dict[num%modifier] = get(new_nums_dict, num % modifier, 0) + number_dict[num]
      else
        new_nums_dict[num*2024] = get(new_nums_dict, num * 2024, 0) + number_dict[num]
      end
    end
    number_dict = new_nums_dict
  end

  result = sum(values(number_dict))
  println(result)
end

main()

