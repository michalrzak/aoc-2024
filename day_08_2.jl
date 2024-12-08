function get_distance(pos1, pos2)
  (pos1[1] - pos2[1], pos1[2] - pos2[2])
end

function flip_distance(distance)
  (-distance[1], -distance[2])
end

function add_distances(distance1, distance2)
  (distance1[1] + distance2[1], distance1[2] + distance2[2])
end

function is_in_bounds(pos, bound_x, bound_y)
  0 < pos[1] <= bound_x && 0 < pos[2] <= bound_y
end

function main()
  raw = read("inputs/day08.txt", String)
  lines = split(raw, "\n")
  pop!(lines)  # remove the last empty entry

  antennas = Dict{Char,Array{Tuple{Int,Int}}}()
  for (y, line) in enumerate(lines)
    for (x, ele) in enumerate(line)
      if ele in ['.', '\n', ' ']
        continue
      end

      if ~haskey(antennas, ele)
        antennas[ele] = []
      end
      push!(antennas[ele], (x, y))
    end
  end

  bound_y = length(lines)
  bound_x = length(lines[1])

  solutions = Set()
  for antenna_locations in values(antennas)
    for antenna1 in antenna_locations
      for antenna2 in antenna_locations
        if antenna1 == antenna2
          continue
        end
        distance = get_distance(antenna1, antenna2)

        resonance1 = antenna1
        while is_in_bounds(resonance1, bound_x, bound_y)
          push!(solutions, resonance1)
          resonance1 = add_distances(distance, resonance1)
        end

        flipped_distance = flip_distance(distance)
        resonance2 = antenna2
        while is_in_bounds(resonance1, bound_x, bound_y)
          push!(solutions, resonance2)
          resonance2 = add_distances(flipped_distance, resonance2)
        end

      end
    end
  end
  println(length(solutions))
end
main()
