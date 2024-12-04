function is_mas(lines, x, y, dir)
  # offset x, y by one dir step to start at M
  x -= dir[1]
  y -= dir[2]

  for c in "MAS"
    if x <= 0 || x > length(lines) || y <= 0 || y > length(lines[1])
      return false
    end

    if c != lines[y][x]
      return false
    end
    x += dir[1]
    y += dir[2]
  end
  true
end


function main()
  raw = read("inputs/day04.txt", String)
  lines = split(raw, "\n")
  pop!(lines) # remove last empty entry

  directions = [(-1, -1), (-1, 1), (1, -1), (1, 1)]
  result = 0
  for (y, line) in enumerate(lines)
    for (x, c) in enumerate(line)
      if c == 'A'
        cross_count = count(map(dir -> is_mas(lines, x, y, dir), directions))
        
        # can only be 2 or 1
        if cross_count == 2
          result += 1
        end
       end
    end
  end

  println(result)

end

main()
