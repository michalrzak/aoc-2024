function main()
  raw = read("inputs/day06.txt", String)
  lines = split(raw, "\n")
  pop!(lines)  # remove last empty entry

  y_to_x_walls = Dict{Int,Array{Int}}()
  x_to_y_walls = Dict{Int,Array{Int}}()
  guard_position = (0, 0)
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
        guard_position = (x, y)
      end
    end
  end

  covered = falses(length(lines[1]), length(lines))
  repeat = true
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
      hitting = repeat ? maximum(hittable_walls) : 0

      for visited_y in guard_position[2]:-1:hitting+1
        covered[guard_position[1], visited_y] = true
      end
      guard_position = (guard_position[1], hitting + 1)
      guard_orientation = :east

    elseif guard_orientation == :east
      potential_obstacles = get(y_to_x_walls, guard_position[2], [])

      hittable_walls = filter(ele -> ele > guard_position[1], potential_obstacles)
      if isempty(hittable_walls)
        repeat = false
      end
      hitting = repeat ? minimum(hittable_walls) : size(covered)[1] + 1

      for visited_x in guard_position[1]:1:hitting-1
        covered[visited_x, guard_position[2]] = true
      end
      guard_position = (hitting - 1, guard_position[2])
      guard_orientation = :south

    elseif guard_orientation == :south
      potential_obstacles = get(x_to_y_walls, guard_position[1], [])

      hittable_walls = filter(ele -> ele > guard_position[2], potential_obstacles)
      if isempty(hittable_walls)
        repeat = false
      end
      hitting = repeat ? minimum(hittable_walls) : size(covered)[2] + 1

      for visited_y in guard_position[2]:1:hitting-1
        covered[guard_position[1], visited_y] = true
      end
      guard_position = (guard_position[1], hitting - 1)
      guard_orientation = :west

    elseif guard_orientation == :west
      potential_obstacles = get(y_to_x_walls, guard_position[2], [])

      hittable_walls = filter(ele -> ele < guard_position[1], potential_obstacles)
      if isempty(hittable_walls)
        repeat = false
      end
      hitting = repeat ? maximum(hittable_walls) : 0

      for visited_x in guard_position[1]:-1:hitting+1
        covered[visited_x, guard_position[2]] = true
      end
      guard_position = (hitting + 1, guard_position[2])
      guard_orientation = :north
    end
  end

  println(count(covered))

end

main()

