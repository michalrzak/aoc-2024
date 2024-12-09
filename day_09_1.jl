using Pipe: @pipe

function main()
  raw = read("inputs/day09.txt", String)
  line = strip(raw, '\n')

  mem_map = @pipe collect(line) |>
                  map(x -> parse(Int64, x), _) |>
                  map(x -> x, enumerate(_)) |>
                  map(x -> x[1] % 2 == 1 ? fill(x[1] ÷ 2, x[2]) : fill(missing, x[2]), _) |>
                  reduce(vcat, _)

  forward_i = 1
  backward_i = length(mem_map)
  mem_map_result = copy(mem_map)
  while forward_i < backward_i
    while ~ismissing(mem_map_result[forward_i])
      forward_i += 1
    end
    while ismissing(mem_map_result[backward_i])
      backward_i -= 1
    end

    if forward_i >= backward_i
      break
    end

    mem_map_result[forward_i] = mem_map[backward_i]
    mem_map_result[backward_i] = mem_map[forward_i]
    forward_i += 1
    backward_i -= 1
  end

  result = @pipe mem_map_result |>
                 filter(x -> ~ismissing(x), _) |>
                 map(x -> floor(Int128, x), _) |>
                 map(x -> (x[1] - 1) * x[2], enumerate(_)) |>
                 sum(_)
  println(result)
end

@time begin
  main()
end

