function get_connected_walls(walls, start, visited)
  if start in visited
    return nothing
  end

  push!(visited, start)

  if start[2] == :north || start[2] == :south
    neighbour1 = ((start[1] + CartesianIndex(-1, 0)), start[2])
    neighbour2 = ((start[1] + CartesianIndex(1, 0)), start[2])
    if neighbour1 in walls && ~(neighbour1 in visited)
      get_connected_walls(walls, neighbour1, visited)
    end
    if neighbour2 in walls && ~(neighbour2 in visited)
      get_connected_walls(walls, neighbour2, visited)
    end
  end

  if start[2] == :east || start[2] == :west
    neighbour1 = ((start[1] + CartesianIndex(0, 1)), start[2])
    neighbour2 = ((start[1] + CartesianIndex(0, -1)), start[2])
    if neighbour1 in walls && ~(neighbour1 in visited)
      get_connected_walls(walls, neighbour1, visited)
    end
    if neighbour2 in walls && ~(neighbour2 in visited)
      get_connected_walls(walls, neighbour2, visited)
    end
  end

  1

end

function is_in_bounds(map_matrix, idx)
  0 < idx[1] <= size(map_matrix)[1] && 0 < idx[2] <= size(map_matrix)[2]
end

function connected(map_matrix, current_pos, visited)
  if current_pos in visited
    return (0, Set())
  end
  push!(visited, current_pos)

  dirs = map(x -> CartesianIndex(x), [(1, 0), (-1, 0), (0, 1), (0, -1)])

  current_letter = map_matrix[current_pos]

  output_area = 1
  walls = Set([(current_pos, :north), (current_pos, :south), (current_pos, :east), (current_pos, :west)])
  for (dir, orientation) in zip(dirs, [:west, :east, :south, :north])
    new_pos = current_pos + dir
    if ~is_in_bounds(map_matrix, new_pos)
      continue
    end

    if map_matrix[new_pos] != current_letter
      continue
    end

    delete!(walls, (current_pos, orientation))
    if new_pos in visited
      continue
    end

    (return_area, return_walls) = connected(map_matrix, new_pos, visited)
    walls = union(walls, return_walls)
    output_area += return_area
  end

  (output_area, walls)
end

function main()
  raw = read("inputs/day12.txt", String)
  lines = split(raw, "\n")
  pop!(lines)  # remove last empty entry

  letters = [[c for c in line] for line in lines]

  map_matrix = hcat(letters...)

  result = 0
  visited = Set{CartesianIndex}()
  for y in 1:length(lines)
    for x in 1:length(lines[1])
      current = CartesianIndex(x, y)
      (area, walls) = connected(map_matrix, current, visited)

      visited_walls = Set()
      found_walls = 0
      for wall in walls
        output = get_connected_walls(walls, wall, visited_walls)
        if ~isnothing(output)
          found_walls += 1
        end
      end
      result += (area * found_walls)
    end
  end

  println(result)
end

main()
