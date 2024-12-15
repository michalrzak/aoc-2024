function move!(warehouse, current, delta)
  new_pos = current + delta
  if warehouse[new_pos] == :wall
    return current
  end

  # if there is a box, attempt to move the box
  if warehouse[new_pos] == :box
    move!(warehouse, new_pos, delta)
  end

  # if the new tile is empty (it was empty from the start/the box was moved)
  if warehouse[new_pos] == :empty
    warehouse[new_pos] = warehouse[current]
    warehouse[current] = :empty
    return new_pos
  end

  return current

end

function print_warehouse(warehouse, width, height, translate)
  flipped_translate = Dict(x[2] => x[1] for x in translate)
  for y in 1:height
    for x in 1:width
      print(flipped_translate[warehouse[CartesianIndex(x, y)]])
    end
    println()
  end
end

function main()
  input = read("inputs/day15.txt", String)
  (map_raw, moves) = split(input, "\n\n")
  map_lines = split(map_raw, "\n")

  moves = replace(moves, "\n" => "")
  translate = Dict('#' => :wall, '.' => :empty, 'O' => :box, '@' => :empty)  # also denote  the robot as empty
  robot_position::CartesianIndex = CartesianIndex(0, 0)
  warehouse = Dict{CartesianIndex,Symbol}()
  for (y, line) in enumerate(map_lines)
    for (x, ele) in enumerate(line)
      if ele == '@'
        robot_position = CartesianIndex(x, y)
      end
      warehouse[CartesianIndex(x, y)] = translate[ele]
    end
  end

  moves_translate = Dict('>' => CartesianIndex(1, 0),
    'v' => CartesianIndex(0, 1),
    '<' => CartesianIndex(-1, 0),
    '^' => CartesianIndex(0, -1))
  for dir in moves
    delta = moves_translate[dir]
    robot_position = move!(warehouse, robot_position, delta)
    #print_warehouse(warehouse, 8, 8, translate)
    #println("==============")
  end

  boxes = filter(x -> x[2] == :box, warehouse)
  gps = map(x -> (x[2] - 1) * 100 + (x[1] - 1), collect(keys(boxes)))
  result = sum(gps)
  println(result)
end

main()
