class Monkey
  attr_reader :number,
              :operator,
              :multiplier,
              :quotient,
              :monkey_true,
              :monkey_false
  attr_accessor :items, :inspections

  def initialize(
    number,
    items,
    operator,
    multiplier,
    quotient,
    monkey_true,
    monkey_false
  )
    @number = number
    @operator = operator
    @items = items
    @multiplier = multiplier
    @quotient = quotient
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
    operator: bloc[2].scan(/(\+|\*)/).flatten.first,
    multiplier: bloc[2].scan(/\d+/),
    quotient: bloc[3].scan(/\d+/).first.to_i,
    monkey_true: bloc[4].scan(/\d+/).first.to_i,
    monkey_false: bloc[5].scan(/\d+/).first.to_i
  }
end

def display_monkeys(monkeys)
  monkeys.lazy.each do |monkey|
    p "Monkey #{monkey.number} inspected #{monkey.inspections} items."
  end
end

def parts(input, rounds, worry_divsor)
  @monkeys = []

  input.each do |input_turn|
    elements = parse_input(input_turn)
    monkey =
      Monkey.new(
        elements[:number].freeze,
        elements[:items],
        elements[:operator].freeze,
        elements[:multiplier].freeze,
        elements[:quotient].freeze,
        elements[:monkey_true].freeze,
        elements[:monkey_false].freeze
      )
    @monkeys << monkey
  end

  break_points = [20, 1000, 2000, 3000, 4000]

  worry_level = 0
  round_count = 1
  rounds.times do
    #p "-------------Round: #{round_count}------------"
    round_count += 1
    @monkeys.lazy.each do |monkey|
      monkey.items.lazy.each do |item|
        monkey.inspections += 1
        multiplier =
          monkey.multiplier.empty? ? item : monkey.multiplier.first.to_i
        item =
          (
            if monkey.operator == "+"
              (item + multiplier) / worry_divsor
            else
              (item * multiplier) / worry_divsor
            end
          )
        next_monkey_num =
          (
            if (item % monkey.quotient).zero?
              monkey.monkey_true
            else
              monkey.monkey_false
            end
          )
        Monkey.find(@monkeys, next_monkey_num).items << item
      end
      monkey.items = []
    end
    display_monkeys(@monkeys) if break_points.include?(round_count)
  end

  @monkeys.lazy.map(&:inspections).max(2).reduce(&:*)
end

input = File.read("practice_input.txt").split("\n\n")

#p "The answer to part 1 is: #{parts(input, 20, 3)}" # The answer to part 1 is 55944

p "The answer to part 2 is: #{parts(input, 10_000, 1)}" # The answer to part 2 is
