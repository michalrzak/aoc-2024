function is_in_bounds(matrix, pos)
  0 < pos[1] <= size(matrix)[1] && 0 < pos[2] <= size(matrix)[2]
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
  for current_pos in path
    for dir in directions
      new_pos = current_pos + dir
      if world[new_pos] == '#'
        current_hole = [new_pos]

        if ~is_in_bounds(world, new_pos + dir)
          continue
        end

        if world[new_pos+dir] == '#'
          new_pos = new_pos + dir
          push!(current_hole, new_pos)
        end

        if ~is_in_bounds(world, new_pos + dir)
          continue
        end

        if world[new_pos+dir] == '.'
          saving = path_order[new_pos+dir] - path_order[current_pos] - length(current_hole)
          push!(holes, (current_hole, saving))
        end
      end
    end
  end

  result = count(x -> x[2] >= 100, holes)
end

main()
