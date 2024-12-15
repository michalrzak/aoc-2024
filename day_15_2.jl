function move!(warehouse, robot_pos, delta)
  new_pos = robot_pos + delta
  if warehouse[new_pos] == :empty
    return new_pos
  end

  if warehouse[new_pos] == :wall
    return robot_pos
  end

  if delta[1] == 0
    move_boxes_y!(warehouse, new_pos, delta)
  else
    move_boxes_x!(warehouse, new_pos, delta)
  end

  if warehouse[new_pos] == :empty
    return new_pos
  end

  return robot_pos
end

function move_boxes_x!(warehouse, current, delta)
  new_pos = current + delta
  if warehouse[new_pos] == :wall
    return
  end

  # if there is a box, attempt to move the box
  if warehouse[new_pos] == :boxl || warehouse[new_pos] == :boxr
    move_boxes_x!(warehouse, new_pos, delta)
  end

  # if the new tile is empty (it was empty from the start/the box was moved)
  if warehouse[new_pos] == :empty
    warehouse[new_pos] = warehouse[current]
    warehouse[current] = :empty
  end
end

function move_boxes_y!(warehouse, current, delta)
  right_offset = CartesianIndex(1, 0)

  if warehouse[current] == :boxr
    current -= right_offset
  end

  new_posl = current + delta
  new_posr = current + delta + right_offset

  if warehouse[new_posl] == :wall || warehouse[new_posr] == :wall
    return
  end

  warehouse_copy = copy(warehouse)
  if warehouse[new_posl] != :empty
    move_boxes_y!(warehouse_copy, new_posl, delta)
  end
  if warehouse[new_posr] != :empty
    move_boxes_y!(warehouse_copy, new_posr, delta)
  end

  if (warehouse[new_posl] != :empty || warehouse[new_posr] != :empty) &&
     (warehouse_copy[new_posl] == :empty && warehouse_copy[new_posr] == :empty)

    if warehouse[new_posl] != :empty
      move_boxes_y!(warehouse, new_posl, delta)
    end
    if warehouse[new_posr] != :empty
      move_boxes_y!(warehouse, new_posr, delta)
    end
  end

  if warehouse[new_posl] == :empty && warehouse[new_posr] == :empty
    warehouse[new_posl] = :boxl
    warehouse[new_posr] = :boxr
    warehouse[current] = :empty
    warehouse[current+right_offset] = :empty
  end
end

function print_warehouse(warehouse, width, height, robot)
  for y in 1:height
    for x in 1:width
      ele = warehouse[CartesianIndex(x, y)]
      if CartesianIndex(x, y) == robot
        print('@')
        continue
      end
      if ele == :wall
        print('#')
      elseif ele == :empty
        print('.')
      elseif ele == :boxl
        print('[')
      elseif ele == :boxr
        print(']')
      end
    end
    println()
  end
end

function main()
  input = read("inputs/day15.txt", String)
  (map_raw, moves) = split(input, "\n\n")
  map_lines = split(map_raw, "\n")

  moves = replace(moves, "\n" => "")
  translate = Dict('#' => :wall, '.' => :empty, '@' => :empty)  # also denote  the robot as empty
  right_offset = CartesianIndex(1, 0)
  robot_position::CartesianIndex = CartesianIndex(0, 0)
  warehouse = Dict{CartesianIndex,Symbol}()
  for (y, line) in enumerate(map_lines)
    for (x, ele) in enumerate(line)
      new_position = CartesianIndex(2 * x - 1, y)
      if ele == '@'
        robot_position = new_position
      end
      if ele == 'O'
        warehouse[new_position] = :boxl
        warehouse[new_position+right_offset] = :boxr
        continue
      end
      warehouse[new_position] = translate[ele]
      warehouse[new_position+right_offset] = translate[ele]
    end
  end

  moves_translate = Dict('>' => CartesianIndex(1, 0),
    'v' => CartesianIndex(0, 1),
    '<' => CartesianIndex(-1, 0),
    '^' => CartesianIndex(0, -1))
  for dir in moves
    println(dir)
    delta = moves_translate[dir]
    robot_position = move!(warehouse, robot_position, delta)
    #println(robot_position)
    #println(delta)
    #print_warehouse(warehouse, 20, 10, robot_position)
    #println("==============")
  end

  boxes = filter(x -> x[2] == :boxl, warehouse)
  gps = map(x -> (x[2] - 1) * 100 + (x[1] - 1), collect(keys(boxes)))
  result = sum(gps)
  println(result)
end

main()
