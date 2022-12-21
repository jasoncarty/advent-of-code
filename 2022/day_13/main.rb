require "json"

def both_integers(left, right)
  [left, right].all? { |side| side.is_a? Integer }
end

def compare(left, right)
  left_is_int = left.is_a? Integer
  right_is_int = right.is_a? Integer
  return left <=> right if both_integers(left, right)

  return compare([left], right) if left_is_int
  return compare(left, [right]) if right_is_int

  [left.length, right.length].min.times do |idx|
    diff = compare(left[idx], right[idx])
    return diff if diff != 0
  end
  return left.length <=> right.length
end

def part1(input)
  correct_order_indices = []
  input
    .split("\n\n")
    .each_with_index do |line, index|
      left_string, right_string = line.split("\n")
      left, right = [JSON.parse(left_string), JSON.parse(right_string)]
      result = compare(left, right)
      correct_order_indices.push(index + 1) if result < 0
    end
  return correct_order_indices.sum()
end

def part2(input)
  dividers = ["[[2]]", "[[6]]"]
  lines =
    input
      .split("\n")
      .reject(&:empty?)
      .push(*dividers)
      .sort do |a, b|
        left, right = [JSON.parse(a), JSON.parse(b)]
        compare(left, right)
      end
  dividers
    .map { |divider| lines.find_index(divider) }
    .map { |index| index + 1 }
    .reduce(&:*)
end

input = File.read("real_input.txt")

p "The answer to part 1 is: #{part1(input)}" # The answer to part 1 is: 5196
p "The answer to part 2 is: #{part2(input)}" # The answer to part 2 is: 22134
