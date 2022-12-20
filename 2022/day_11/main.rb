class Monkey
  attr_reader :number,
              :operation,
              :multiplier,
              :tester,
              :monkey_true,
              :monkey_false
  attr_accessor :items, :inspections

  def initialize(number, items, operation, tester, monkey_true, monkey_false)
    @number = number
    @operation = operation
    @items = items
    @tester = tester
    @monkey_true = monkey_true
    @monkey_false = monkey_false
    @inspections = 0
  end

  def self.find(monkeys, monkey_number)
    monkeys.select { |monkey| monkey.number == monkey_number }.first
  end
end

def parse_input(input)
  bloc = input.split("\n")
  {
    number: bloc[0].scan(/\d+/).first.to_i,
    items: bloc[1].scan(/\d+/).map(&:to_i),
    operation: bloc[2].scan(/old .+/).first,
    tester: bloc[3].scan(/\d+/).first.to_i,
    monkey_true: bloc[4].scan(/\d+/).first.to_i,
    monkey_false: bloc[5].scan(/\d+/).first.to_i
  }
end

def operation(item, monkey)
  eval monkey.operation.gsub("old", item.to_s)
end

def find_next_monkey(item, monkey)
  next_monkey_num =
    (item % monkey.tester).zero? ? monkey.monkey_true : monkey.monkey_false
  Monkey.find(@monkeys, next_monkey_num)
end

def apply_relief(item, relief, lcm)
  item /= relief if relief > 1
  item %= lcm
end

def parts(input, rounds, relief)
  @monkeys = []

  input.each do |input_turn|
    elements = parse_input(input_turn)
    monkey =
      Monkey.new(
        elements[:number].freeze,
        elements[:items],
        elements[:operation].freeze,
        elements[:tester].freeze,
        elements[:monkey_true].freeze,
        elements[:monkey_false].freeze
      )
    @monkeys << monkey
  end
  lcm = @monkeys.map(&:tester).inject(:*)
  break_points = [20, 1000, 2000, 3000, 4000]

  worry_level = 0
  round_count = 1
  rounds.times do
    round_count += 1
    @monkeys.lazy.each do |monkey|
      monkey.items.lazy.each do |item|
        monkey.inspections += 1
        item = operation(item, monkey)
        item = apply_relief(item, relief, lcm)
        next_monkey = find_next_monkey(item, monkey)
        next_monkey.items << item
      end
      monkey.items = []
    end
  end
  @monkeys.lazy.map(&:inspections).max(2).reduce(&:*)
end

input = File.read("real_input.txt").split("\n\n")

p "The answer to part 1 is: #{parts(input, 20, 3)}" # The answer to part 1 is 55944
p "The answer to part 2 is: #{parts(input, 10_000, 1)}" # The answer to part 2 is 15117269860
