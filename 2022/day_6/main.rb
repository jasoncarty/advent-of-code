def get_part(unique_items)
  answer = nil
  input = File.read("real_input.txt")
  split_line = input.strip.split("")
  idx = unique_items - 1

  split_line[(unique_items - 1)..-1].each do |char|
    if !answer
      answer =
        (
          if split_line[idx - (unique_items - 1)..idx].uniq.length ==
               unique_items
            idx + 1
          else
            nil
          end
        )
      break if answer
    end
    idx += 1
  end
  answer
end

p "The answer to part 1 is #{get_part(4)}" # The answer to part 1 is 1480
p "The answer to part 2 is #{get_part(14)}" # The answer to part 2 is 2746
