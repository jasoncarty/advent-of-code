class Monkey
  attr_reader :number
  attr_accessor :items, :inspections

  def initialize(number)
    @number = number
    @items = []
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
    operator: bloc[2].scan(/(\+|\*)/).flatten.first,
    multiplier: bloc[2].scan(/\d+/),
    tester: bloc[3].scan(/\d+/).first.to_i,
    monkey_true: bloc[4].scan(/\d+/).first.to_i,
    monkey_false: bloc[5].scan(/\d+/).first.to_i
  }
end

def part1(input)
  @monkeys = []

  input.each do |input_turn|
    bloc = input_turn.split("\n").map { _1.scan(/\d+/) }
    items = bloc[1].map(&:to_i)
    monkey = Monkey.new(bloc[0].first.to_i)
    monkey.items = items
    @monkeys << monkey
  end

  worry_level = 0
  rounds = 20
  rounds.times do
    input.each do |input_turn|
      elements = parse_input(input_turn)
      current_monkey = Monkey.find(@monkeys, elements[:number])
      current_monkey.items.each do |item|
        current_monkey.inspections += 1
        multiplier =
          elements[:multiplier].empty? ? item : elements[:multiplier].first.to_i
        item =
          (
            if elements[:operator] == "+"
              (item + multiplier) / 3
            else
              (item * multiplier) / 3
            end
          )
        next_monkey_num =
          (
            if (item % elements[:tester]).zero?
              elements[:monkey_true]
            else
              elements[:monkey_false]
            end
          )
        Monkey.find(@monkeys, next_monkey_num).items << item
      end
      current_monkey.items = []
    end
  end

  @monkeys.map(&:inspections).max(2).reduce(&:*)
end

input = File.read("real_input.txt").split("\n\n")

p "The answer to part 1 is: #{part1(input)}" # The answer to part 1 is 55944
