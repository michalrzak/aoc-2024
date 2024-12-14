function main()
  raw = read("inputs/day14.txt", String)
  lines = split(raw, "\n")
  pop!(lines)  # remove last empty entry

  robots = map(x ->
      begin
        (pos_str, vel_str) = split(x, " ")
        (x, y) = split(pos_str[3:end], ",")
        (v_x, v_y) = split(vel_str[3:end], ",")
        Dict(:x => parse(Int64, x),
          :y => parse(Int64, y),
          :v_x => parse(Int64, v_x),
          :v_y => parse(Int64, v_y))
      end, lines)

  field_size = (101, 103)

  seconds = 10000
  for i in 1:seconds
    for robot in robots
      robot[:x] = (robot[:x] + robot[:v_x]) % field_size[1]
      if robot[:x] < 0
        robot[:x] = field_size[1] + robot[:x]
      end
      robot[:y] = (robot[:y] + robot[:v_y]) % field_size[2]
      if robot[:y] < 0
        robot[:y] = field_size[2] + robot[:y]
      end
    end

    println(i)
    robot_pos = Set((robot[:x], robot[:y]) for robot in robots)

    if ~isnothing(findfirst(y -> length(filter(x -> x[2] == y, robot_pos)) >= field_size[1] ÷ 4, 1:field_size[2]))

      for y in 1:field_size[2]
        for x in 1:field_size[1]
          if (x, y) in robot_pos
            print("#")
          else
            print(".")
          end
        end
        println()
      end

      println("\n")
    end

  end

end

main()
