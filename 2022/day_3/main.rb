input = File.read("real_input.txt").split("\n")

@priorities_hash = {}
lowercase = ("a".."z").to_a
uppercase = ("A".."Z").to_a
lowercase
  .push(*uppercase)
  .each_with_index { |char, index| @priorities_hash[char] = index + 1 }

def get_part(array)
  array.flatten.map { |item| @priorities_hash[item] }.sum
end

part1 =
  input.map do |rucksack|
    half = rucksack.length / 2
    first = rucksack[0..(half - 1)]
    second = rucksack[half..(rucksack.length - 1)]
    first.split("") & second.split("")
  end

part2 =
  input
    .each_slice(3)
    .to_a
    .map do |group|
      group[0].split("") & group[1].split("") & group[2].split("")
    end

p "The answer to part 1 is: #{get_part(part1)}" # The answer to part 1 is: 8493
p "The answer to part 2 is: #{get_part(part2)}" # The answer to part 1 is: 2552
