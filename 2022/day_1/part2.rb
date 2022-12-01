require "./input.rb"

input = @real_input
answer =
  input
    .split("\n\n")
    .map { |item| item.strip().split("\n").map(&:to_i) }
    .map { |item| item.reduce(&:+) }
    .sort { |a, b| b - a }
    .take(3)
    .reduce(&:+)

puts "The answer is: #{answer}"
