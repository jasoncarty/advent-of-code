Monkey =
  Struct.new(
    :items_to_remove,
    :items,
    :name,
    :worry_fn_number,
    :worry_fn_operation,
    :divisible_by_test_condition,
    :throw_to_monkey_if_test_true,
    :throw_to_monkey_if_test_false,
    :amount_inspected
  )

input = File.read("practice_input.txt")
monkeys =
  input
    .split("\n\n")
    .map do |section|
      monkey = Monkey.new()
      section
        .split("\n")
        .map(&:strip)
        .map do |item|
          numbers_in_item = item.scan(/[0-9]/).join("").to_i
          case item
          when /Monkey/
            monkey.name = numbers_in_item
          when /Starting items: /
            items = item.split(/Starting items: /)[1].split(",").map(&:to_i)
            monkey.items = [*items]
          when /Operation/
            monkey.worry_fn_operation = item.scan(%r{(\+|-|\*|/)}).flatten.first
            monkey.worry_fn_number = numbers_in_item
          when /Test/
            monkey.divisible_by_test_condition = numbers_in_item
          when /If true:/
            monkey.throw_to_monkey_if_test_true = numbers_in_item
          when /If false:/
            monkey.throw_to_monkey_if_test_false = numbers_in_item
          end
          monkey.items_to_remove = []
          monkey.amount_inspected = 0
        end
      monkey
    end

def part1(monkeys)
  worry_level = 0
  rounds = 20
  rounds.times do
    monkeys.each do |monkey|
      monkey.items.each do |item|
        if monkey.worry_fn_number == 0
          worry_level = item.method(monkey.worry_fn_operation).(item)
        else
          worry_level =
            item.method(monkey.worry_fn_operation).(monkey.worry_fn_number)
        end

        worry_level = (worry_level / 3).round
        if worry_level % monkey.divisible_by_test_condition == 0
          monkeys[monkey.throw_to_monkey_if_test_true].items.push(worry_level)
        else
          monkeys[monkey.throw_to_monkey_if_test_false].items.push(worry_level)
        end
        monkey.items_to_remove.push(item)
        monkey.amount_inspected += 1
      end
    end
    monkeys.each do |monkey|
      monkey.items = monkey.items - monkey.items_to_remove
      monkey.items_to_remove = []
    end
  end

  monkeys.sort_by { |monkey| -monkey.amount_inspected }
end

one, two = part1(monkeys)
p "The answer to part 1 is: #{one.amount_inspected * two.amount_inspected}"
