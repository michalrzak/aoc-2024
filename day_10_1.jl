function posible_paths(start, grid, found=Set())
  dirs = map(x -> CartesianIndex(x), [(1, 0), (0, 1), (-1, 0), (0, -1)])


  current_val = grid[start]
  if current_val == 9
    push!(found, start)
    return 1
  end

  output = 0
  for dir in dirs
    if ~(0 < (start+dir)[1] <= size(grid)[1] && 0 < (start+dir)[2] <= size(grid)[2])
      continue
    end
    if start + dir in found
      continue
    end
    if grid[start+dir] == current_val + 1
      output += posible_paths(start + dir, grid, found)
    end
  end
  output
end

function main()
  raw = read("inputs/day10.txt", String)
  lines = split(raw, "\n")
  pop!(lines)  # remove last empty line

  number_map = hcat(map.(c -> parse(Int64, c), collect.(lines))...)

  starts = findall(==(0), number_map)
  path_counts = map(x -> posible_paths(x, number_map), starts)

  result = sum(path_counts)
  println(result)
end

main()
