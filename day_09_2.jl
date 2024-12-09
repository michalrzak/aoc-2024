using Pipe: @pipe

function main()
  raw = read("inputs/day09.txt", String)
  line = strip(raw, '\n')

  mem_map = @pipe collect(line) |>
                  map(x -> parse(Int64, x), _) |>
                  map(x -> x, enumerate(_)) |>
                  map(x -> x[1] % 2 == 1 ? fill(x[1] ÷ 2, x[2]) : fill(missing, x[2]), _) |>
                  reduce(vcat, _)

  spaces = []
  files = []
  occupied = 1
  for (i, c) in enumerate(collect(line))
    if i % 2 == 0
      push!(spaces, [occupied, parse(Int64, c)])
    else
      push!(files, [occupied, parse(Int64, c)])
    end

    occupied += parse(Int64, c)
  end

  mem_map_result = copy(mem_map)
  for file in reverse(files)
    target_space_i = findfirst(x -> x[1] < file[1] && x[2] >= file[2], spaces)
    if isnothing(target_space_i)
      continue
    end
    target_space = spaces[target_space_i]

    mem_map_result[target_space[1]:target_space[1]+file[2]-1] = mem_map[file[1]:file[1]+file[2]-1]
    mem_map_result[file[1]:file[1]+file[2]-1] .= missing
    target_space[1] += file[2]
    target_space[2] -= file[2]
  end

  result = @pipe mem_map_result |>
                 map(x -> ismissing(x) ? 0 : x, _) |>
                 map(x -> (x[1] - 1) * x[2], enumerate(_)) |>
                 sum(_)
  println(result)
end

@time begin
  main()
end

