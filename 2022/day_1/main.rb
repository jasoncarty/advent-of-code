require "./input.rb"

input = @real_input
elves =
  input
    .split("\n\n")
    .map { |item| item.strip().split("\n").map(&:to_i) }
    .map(&:sum)

part1_answer = elves.max
part2_answer = elves.sort.reverse.take(3).sum

puts "The answer to part 1 is: #{part1_answer}" # The answer is: 71506
puts "The answer to part 2 is: #{part2_answer}" # The answer is: 209603
