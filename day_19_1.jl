function is_possible(pattern, available)
  options = [""]
  tested = Set()

  while ~isempty(options)
    current = pop!(options)
    if current in tested
      continue
    end
    push!(tested, current)

    if current == pattern
      return true
    end

    if length(current) > length(pattern)
      continue
    end

    for ele in available
      new = current * ele
      if startswith(pattern, new)
        push!(options, new)
      end
    end
  end

  return false
end

function main()
  raw = read("inputs/day19.txt", String)
  lines = split(raw, "\n")

  available_str = lines[1]
  desired = lines[3:end-1]  # skip the final one as it is an empty line

  available = split(available_str, ", ")

  possible = map(x -> is_possible(x, available), desired)
  result = count(possible)
  println(result)
end

main()
