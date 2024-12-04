function is_xmas(lines, x, y, dir)
  for c in "XMAS"
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

  directions = [(-1, 0), (-1, -1), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]
  result = 0
  for (y, line) in enumerate(lines)
    for (x, c) in enumerate(line)
      if c == 'X'
        result += count(map(dir -> is_xmas(lines, x, y, dir), directions))
       end
    end
  end

  println(result)

end

main()
