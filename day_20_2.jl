using Pipe: @pipe
using DataStructures: Queue

function is_in_bounds(matrix, pos)
  0 < pos[1] <= size(matrix)[1] && 0 < pos[2] <= size(matrix)[2]
end

function wall_length(world, start_pos, end_pos, max_length)
  directions = map(CartesianIndex, [(1, 0), (-1, 0), (0, 1), (0, -1)])

  paths = Queue{Vector{CartesianIndex}}()
  enqueue!(paths, [start_pos])

  visited = Set()
  while !isempty(paths)
    current = dequeue!(paths)

    if length(current) > max_length
      continue
    end

    for dir in directions
      new_pos = current[end] + dir
      if new_pos == end_pos
        return length(current)
      end

      if ~is_in_bounds(world, new_pos)
        continue
      end

      if ~(new_pos in visited)
        push!(visited, new_pos)
        path_copy = copy(current)
        push!(path_copy, new_pos)
        enqueue!(paths, path_copy)
      end
    end
  end

  return nothing
end

function find_holes(world, start_pos, path, max_hole)
  start_idx = findfirst(==(start_pos), path)
  possible_targets = filter(x -> begin
      distance = x - start_pos
      abs(distance[1]) + abs(distance[2]) <= max_hole + 1
    end, path[start_idx+1:end])

  solutions = Set()
  for target in possible_targets
    wl = wall_length(world, start_pos, target, max_hole)
    if ~isnothing(wl)
      push!(solutions, (start_pos, target, wl))
    end
  end

  return solutions
end

function main()
  raw = read("inputs/day20.txt", String)
  lines = split(raw, "\n")
  pop!(lines)  # remove last empty line

  char_lines = map(x -> [c for c in x], lines)
  world = hcat(char_lines...)

  start_pos = findfirst(==('S'), world)
  end_pos = findfirst(==('E'), world)

  world[start_pos] = '.'
  world[end_pos] = '.'

  directions = map(CartesianIndex, [(1, 0), (-1, 0), (0, 1), (0, -1)])
  current_pos = start_pos
  path = []
  while current_pos != end_pos
    push!(path, current_pos)

    for dir in directions
      new_pos = current_pos + dir
      if world[new_pos] == '.' && (length(path) < 2 || path[end-1] != new_pos)
        current_pos = new_pos
        break
      end
    end
  end
  push!(path, end_pos)

  path_order = Dict([pos => i for (i, pos) in enumerate(path)])
  holes = Set()
  for (i, current_pos) in enumerate(path)
    if i % 30 == 0
      println("$i/$(length(path))")
    end
    union!(holes, find_holes(world, current_pos, path, 20))
  end

  hole_costs = map(x -> path_order[x[2]] - path_order[x[1]] - x[3], [c for c in holes])
  result = count(x -> x >= 100, hole_costs)

end

main()

