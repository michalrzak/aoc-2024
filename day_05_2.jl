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
  for (i, line) in enumerate(orders)
    seen = Set()
    is_correct = true

    current_line = copy(line)
    for (i, ele) in enumerate(line)
      if haskey(rules, ele)
        breaking_items = intersect(seen, rules[ele])
        if ~isempty(breaking_items)
          insert_idx = findfirst(map(x -> x in breaking_items, current_line))
          popat!(current_line, i)
          insert!(current_line, insert_idx, ele)
          is_correct = false
        end
      end
      push!(seen, ele)
    end

    if ~is_correct
      result += current_line[(length(current_line)÷2)+1]
    end
  end

  println(result)

end

main()

