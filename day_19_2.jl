function count_possible(pattern, available, memoization)
  if haskey(memoization, (pattern, available))
    return memoization[(pattern, available)]
  end

  if pattern == ""
    return 1
  end

  count = 0
  for ele in available
    if startswith(pattern, ele)
      count += count_possible(pattern[length(ele)+1:end], available, memoization)
    end
  end

  memoization[(pattern, available)] = count
  return count
end

function main()
  raw = read("inputs/day19.txt", String)
  lines = split(raw, "\n")

  available_str = lines[1]
  desired = lines[3:end-1]  # skip the final one as it is an empty line

  available = split(available_str, ", ")

  possible = map(x -> count_possible(x, available, Dict()), desired)
  result = sum(possible)
  println(result)
end

main()
