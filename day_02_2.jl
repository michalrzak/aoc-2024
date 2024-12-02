function is_valid(row)
        diffs = diff(row)
        ascending_diffs = map(x -> -4 < x < 0, diffs)
        descending_diffs = map(x -> 4 > x > 0, diffs)
        all(ascending_diffs) || all(descending_diffs)
end

function main()
        raw = read("inputs/day02.txt", String)
        lines = split(raw, "\n")
        pop!(lines)

        numbers_strings = split.(lines, " ")
        numbers = map.(x -> parse(Int64, x), numbers_strings)

        result = 0
        for row in numbers
                if is_valid(row)
                        result += 1
                        continue
                end

                for i in 1:length(row)
                        row_copy = copy(row)
                        popat!(row_copy, i)
                        if is_valid(row_copy)
                                result += 1
                                break
                        end
                end
        end

        println(result)
end
main()
