function is_loop(start, orientation, x_to_y_walls, y_to_x_walls)
  guard_position = start
  guard_orientation = orientation
  visited = Set()
  while ~((guard_position, guard_orientation) in visited)
    # display(covered)
    # println(guard_orientation)
    # println(guard_position)

    push!(visited, (guard_position, guard_orientation))
    if guard_orientation == :north
      potential_obstacles = get(x_to_y_walls, guard_position[1], [])

      hittable_walls = filter(ele -> ele < guard_position[2], potential_obstacles)
      if isempty(hittable_walls)
        return false
      end
      hitting = maximum(hittable_walls)

      guard_position = (guard_position[1], hitting + 1)
      guard_orientation = :east

    elseif guard_orientation == :east
      potential_obstacles = get(y_to_x_walls, guard_position[2], [])

      hittable_walls = filter(ele -> ele > guard_position[1], potential_obstacles)
      if isempty(hittable_walls)
        return false
      end
      hitting = minimum(hittable_walls)

      guard_position = (hitting - 1, guard_position[2])
      guard_orientation = :south

    elseif guard_orientation == :south
      potential_obstacles = get(x_to_y_walls, guard_position[1], [])

      hittable_walls = filter(ele -> ele > guard_position[2], potential_obstacles)
      if isempty(hittable_walls)
        return false
      end
      hitting = minimum(hittable_walls)

      guard_position = (guard_position[1], hitting - 1)
      guard_orientation = :west

    elseif guard_orientation == :west
      potential_obstacles = get(y_to_x_walls, guard_position[2], [])

      hittable_walls = filter(ele -> ele < guard_position[1], potential_obstacles)
      if isempty(hittable_walls)
        return false
      end
      hitting = maximum(hittable_walls)

      guard_position = (hitting + 1, guard_position[2])
      guard_orientation = :north
    end
  end

  return true
end
function main()
  raw = read("inputs/day06.txt", String)
  lines = split(raw, "\n")
  pop!(lines)  # remove last empty entry

  y_to_x_walls = Dict{Int,Array{Int}}()
  x_to_y_walls = Dict{Int,Array{Int}}()
  start_position = (0, 0)
  guard_orientation = :north

  for (y, line) in enumerate(lines)
    for (x, ele) in enumerate(line)
      if ele == '#'
        if ~haskey(y_to_x_walls, y)
          y_to_x_walls[y] = []
        end
        push!(y_to_x_walls[y], x)

        if ~haskey(x_to_y_walls, x)
          x_to_y_walls[x] = []
        end
        push!(x_to_y_walls[x], y)

      elseif ele == '^'
        start_position = (x, y)
      end
    end
  end

  println(start_position)

  guard_position = start_position
  repeat = true
  result = Set()
  while repeat
    # display(covered)
    # println(guard_orientation)
    # println(guard_position)

    if guard_orientation == :north
      potential_obstacles = get(x_to_y_walls, guard_position[1], [])

      hittable_walls = filter(ele -> ele < guard_position[2], potential_obstacles)
      if isempty(hittable_walls)
        repeat = false
      end
      hitting = repeat ? maximum(hittable_walls) : 1

      for visited_y in guard_position[2]:-1:hitting+1
        potential_new_obstacles = get(y_to_x_walls, visited_y, [])
        hittable_walls = filter(ele -> ele > guard_position[1], potential_new_obstacles)
        if ~isempty(hittable_walls)
          modified_x_to_y_walls = deepcopy(x_to_y_walls)
          if ~haskey(modified_x_to_y_walls, guard_position[1])
            modified_x_to_y_walls[guard_position[1]] = []
          end
          push!(modified_x_to_y_walls[guard_position[1]], visited_y - 1)

          modified_y_to_x_walls = deepcopy(y_to_x_walls)
          if ~haskey(modified_y_to_x_walls, visited_y - 1)
            modified_y_to_x_walls[visited_y-1] = []
          end
          push!(modified_y_to_x_walls[visited_y-1], guard_position[1])
          if is_loop(start_position, :north, modified_x_to_y_walls, modified_y_to_x_walls)
            push!(result, (guard_position[1], visited_y - 1))
          end
        end
      end
      guard_position = (guard_position[1], hitting + 1)
      guard_orientation = :east

    elseif guard_orientation == :east
      potential_obstacles = get(y_to_x_walls, guard_position[2], [])

      hittable_walls = filter(ele -> ele > guard_position[1], potential_obstacles)
      if isempty(hittable_walls)
        repeat = false
      end
      hitting = repeat ? minimum(hittable_walls) : length(lines[1])

      for visited_x in guard_position[1]:1:hitting-1
        potential_new_obstacles = get(x_to_y_walls, visited_x, [])
        hittable_walls = filter(ele -> ele > guard_position[2], potential_new_obstacles)
        if ~isempty(hittable_walls)
          modified_x_to_y_walls = deepcopy(x_to_y_walls)
          if ~haskey(modified_x_to_y_walls, visited_x + 1)
            modified_x_to_y_walls[visited_x+1] = []
          end
          push!(modified_x_to_y_walls[visited_x+1], guard_position[2])

          modified_y_to_x_walls = deepcopy(y_to_x_walls)
          if ~haskey(modified_y_to_x_walls, guard_position[2])
            modified_y_to_x_walls[guard_position[2]] = []
          end
          push!(modified_y_to_x_walls[guard_position[2]], visited_x + 1)
          if is_loop(start_position, :north, modified_x_to_y_walls, modified_y_to_x_walls)
            push!(result, (visited_x + 1, guard_position[2]))
          end
        end
      end
      guard_position = (hitting - 1, guard_position[2])
      guard_orientation = :south

    elseif guard_orientation == :south
      potential_obstacles = get(x_to_y_walls, guard_position[1], [])

      hittable_walls = filter(ele -> ele > guard_position[2], potential_obstacles)
      if isempty(hittable_walls)
        repeat = false
      end
      hitting = repeat ? minimum(hittable_walls) : length(lines)

      for visited_y in guard_position[2]:1:hitting-1
        potential_new_obstacles = get(y_to_x_walls, visited_y, [])
        hittable_walls = filter(ele -> ele < guard_position[1], potential_new_obstacles)
        if ~isempty(hittable_walls)
          modified_x_to_y_walls = deepcopy(x_to_y_walls)
          if ~haskey(modified_x_to_y_walls, guard_position[1])
            modified_x_to_y_walls[guard_position[1]] = []
          end
          push!(modified_x_to_y_walls[guard_position[1]], visited_y + 1)

          modified_y_to_x_walls = deepcopy(y_to_x_walls)
          if ~haskey(modified_y_to_x_walls, visited_y + 1)
            modified_y_to_x_walls[visited_y+1] = []
          end
          push!(modified_y_to_x_walls[visited_y+1], guard_position[1])
          if is_loop(start_position, :north, modified_x_to_y_walls, modified_y_to_x_walls)
            push!(result, (guard_position[1], visited_y + 1))
          end
        end
      end
      guard_position = (guard_position[1], hitting - 1)
      guard_orientation = :west

    elseif guard_orientation == :west
      potential_obstacles = get(y_to_x_walls, guard_position[2], [])

      hittable_walls = filter(ele -> ele < guard_position[1], potential_obstacles)
      if isempty(hittable_walls)
        repeat = false
      end
      hitting = repeat ? maximum(hittable_walls) : 1

      for visited_x in guard_position[1]:-1:hitting+1
        potential_new_obstacles = get(x_to_y_walls, visited_x, [])
        hittable_walls = filter(ele -> ele < guard_position[2], potential_new_obstacles)
        if ~isempty(hittable_walls)
          modified_x_to_y_walls = deepcopy(x_to_y_walls)
          if ~haskey(modified_x_to_y_walls, visited_x - 1)
            modified_x_to_y_walls[visited_x-1] = []
          end
          push!(modified_x_to_y_walls[visited_x-1], guard_position[2])

          modified_y_to_x_walls = deepcopy(y_to_x_walls)
          if ~haskey(modified_y_to_x_walls, guard_position[2])
            modified_y_to_x_walls[guard_position[2]] = []
          end
          push!(modified_y_to_x_walls[guard_position[2]], visited_x - 1)
          if is_loop(start_position, :north, modified_x_to_y_walls, modified_y_to_x_walls)
            push!(result, (visited_x - 1, guard_position[2]))
          end
        end
      end
      guard_position = (hitting + 1, guard_position[2])
      guard_orientation = :north
    end
  end

  println(length(result))
  println(lines[90][75])
  result
end

result = main()

