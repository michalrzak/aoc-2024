function main()
  raw = read("inputs/day16.txt", String)
  lines = split(raw, "\n")
  pop!(lines)  # remove last empty line

  field = hcat([[c for c in line] for line in lines]...)

  start_pos = findfirst(==('S'), field)
  end_pos = findfirst(==('E'), field)

  directions = map(x -> CartesianIndex(x), [(1, 0), (-1, 0), (0, 1), (0, -1)])
  current_dir = CartesianIndex(1, 0)
  current_pos = start_pos

  node_costs = Dict()
  visited1 = Set()
  visited2 = Set()
  visited3 = Set()
  current_cost = 0
  while current_pos != end_pos
    if current_pos in visited2
      push!(visited3, current_pos)
    elseif current_pos in visited1
      push!(visited2, current_pos)
    else
      push!(visited1, current_pos)
    end
    for dir in directions
      new_pos = current_pos + dir
      if field[new_pos] == '.' || field[new_pos] == 'E'
        cost = current_cost + 1
        if dir != current_dir
          cost += 1000
        end

        if ~haskey(node_costs, new_pos) || node_costs[new_pos][1] > cost
          node_costs[new_pos] = (cost, dir)
        end

      end
    end
    unvisited = filter(x -> ~(x[1] in visited3), node_costs)
    (_, current_pos) = findmin(x -> x[1], unvisited)
    current_cost = node_costs[current_pos][1]
    current_dir = node_costs[current_pos][2]
    delete!(node_costs, current_pos)
  end
  println(current_cost)

end

main()

