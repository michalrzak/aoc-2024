using Pipe: @pipe

function main()
  raw = read("inputs/day18.txt", String)
  lines = split(raw, "\n")
  pop!(lines)  # remove last empty line

  falling = @pipe lines |>
                  split.(_, ",") |>
                  map.(x -> parse(Int64, x), _) |>
                  map(x -> tuple(x...), _) |>
                  map(CartesianIndex, _)

  mem_size = 70
  memory_map = Dict([CartesianIndex(x, y) => '.' for x in 0:mem_size for y in 0:mem_size])
  for coord in falling[1:1024]
    memory_map[coord] = '#'
  end

  start_pos = CartesianIndex(0, 0)
  end_pos = CartesianIndex(mem_size, mem_size)

  current_pos = start_pos
  current_cost = 0
  visited = Set()
  directions = map(CartesianIndex, [(1, 0), (-1, 0), (0, 1), (0, -1)])
  next_to_visit = Set()
  while current_pos != end_pos
    push!(visited, current_pos)

    for dir in directions
      new_pos = current_pos + dir
      if new_pos in visited
        continue
      end
      if ~haskey(memory_map, new_pos)
        continue
      end
      if memory_map[new_pos] == '#'
        continue
      end

      push!(next_to_visit, (new_pos, current_cost + 1))
    end

    (current_pos, current_cost) = argmin(x -> x[2], next_to_visit)
    delete!(next_to_visit, (current_pos, current_cost))
  end

  println(current_cost)
end

main()

