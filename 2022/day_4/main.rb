def get_ranges(elf1, elf2)
  [elf1, elf2].map do |elf|
    part1, part2 = elf.split("-").map(&:to_i)
    (part1..part2).to_a
  end
end

def contains_the_other?((first, second))
  a, b = get_ranges(first, second).sort_by(&:length)
  (a - b).empty?
end

def overlaps?((first, second))
  first_range, second_range = get_ranges(first, second)
  !(first_range & second_range).empty?
end

def parts(func)
  File
    .read("real_input.txt")
    .split("\n")
    .filter { |pairs| method(func).call(pairs.split(",")) }
    .length
end

p "The answer to part 1 is: #{parts(:contains_the_other?)}" # The answer to part 1 is: 556
p "The answer to part 2 is: #{parts(:overlaps?)}" # The answer to part 2 is:
