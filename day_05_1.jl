function main()
  raw = read("inputs/day05.txt", String)
  (rules_raw, orders_raw) = split(raw, "\n\n")
  rules_lines = split(rules_raw, "\n")

  rules_pairs = map.(ele -> parse(Int64, ele), split.(rules_lines, "|"))

  rules = Dict{Int,Set}()
  for (before, after) in rules_pairs
    if ~haskey(rules, before)
      rules[before] = Set{Int}()
    end

    push!(rules[before], after)
  end

  orders_lines = split(orders_raw, "\n")
  pop!(orders_lines)

  orders = map.(x -> parse(Int64, x), split.(orders_lines, ","))

  result = 0
  for line in orders
    seen = Set()
    is_invalid = false
    for ele in line
      if haskey(rules, ele)
        if ~isempty(intersect(seen, rules[ele]))
          is_invalid = true
          break
        end
      end
      push!(seen, ele)
    end

    if ~is_invalid
      result += line[(length(line)÷2)+1]
    end
  end

  println(result)
end

main()

