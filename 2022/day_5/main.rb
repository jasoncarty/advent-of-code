def get_stacks(supply_lines)
  stacks = Hash.new { |h, k| h[k] = [] }

  supply_lines.lines(chomp: true).reverse[1..-1].each do |line|
    row = line.chars.each_slice(4).to_a
    row.map! do |slice|
      slice.uniq.reject { |c| ["[", "]", " "].include?(c) }.first
    end

    row.each_with_index do |supply, index|
      stacks[index + 1] << supply if supply
    end
  end
  return stacks
end

def part1(stacks, instruction_lines)
  instruction_lines
    .split("\n")
    .each do |instruction|
      amount, from, to = instruction.scan(/\d+/).map(&:to_i)
      amount.times { stacks[to].append(stacks[from].pop) if stacks[from].any? }
    end
  stacks.values.map(&:last).join("")
end

def part2(stacks, instruction_lines)
  instruction_lines
    .split("\n")
    .each do |instruction|
      amount, from, to = instruction.scan(/\d+/).map(&:to_i)
      stacks[to].append(*stacks[from].pop(amount))
    end
  stacks.values.map(&:last).join("")
end

input = File.read("practice_input.txt")
supply_lines, instruction_lines = input.split("\n\n")

p "The answer to part 1 is #{part1(get_stacks(supply_lines), instruction_lines)}" # The answer to part 1 is TGWSMRBPN
p "The answer to part 2 is #{part2(get_stacks(supply_lines), instruction_lines)}" # The answer to part 2 is TZLTLWRNF
