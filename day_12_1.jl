function is_in_bounds(map_matrix, idx)
  0 < idx[1] <= size(map_matrix)[1] && 0 < idx[2] <= size(map_matrix)[2]
end

function connected(map_matrix, current_pos, visited)
  if current_pos in visited
    return (0, 0)
  end
  push!(visited, current_pos)

  dirs = map(x -> CartesianIndex(x), [(1, 0), (-1, 0), (0, 1), (0, -1)])

  current_letter = map_matrix[current_pos]

  output_area = 1
  output_perimeter = 4
  for dir in dirs
    new_pos = current_pos + dir
    if ~is_in_bounds(map_matrix, new_pos)
      continue
    end

    if map_matrix[new_pos] != current_letter
      continue
    end

    output_perimeter -= 1

    if new_pos in visited
      continue
    end

    (return_area, return_perimenter) = connected(map_matrix, new_pos, visited)

    output_area += return_area
    output_perimeter += return_perimenter
  end

  (output_area, output_perimeter)
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
      (area, perimeter) = connected(map_matrix, current, visited)
      result += (area * perimeter)
    end
  end

  println(result)
end

main()
