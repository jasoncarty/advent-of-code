require "./input.rb"

input = @real_input
answer =
  input
    .split("\n\n")
    .map { |item| item.strip().split("\n").map(&:to_i) }
    .map { |item| item.reduce(&:+) }
    .max_by { |item| item }

puts "The answer is: #{answer}"
