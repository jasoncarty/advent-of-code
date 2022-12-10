def increase_cycle(
  amount,
  cycle_count,
  x_register,
  signal_strengths,
  break_points
)
  amount.times do
    cycle_count += 1
    if cycle_count == break_points[0]
      break_points.shift
      signal_strengths.push(cycle_count * x_register)
    end
  end
  return cycle_count, x_register, signal_strengths, break_points
end

def get_part_1(input)
  cycle_count = 0
  x_register = 1
  signal_strengths = []
  break_points = [20, 60, 100, 140, 180, 220]

  input.each do |item|
    case item
    when "noop"
      cycle_count, x_register, signal_strengths, break_points =
        increase_cycle(
          1,
          cycle_count,
          x_register,
          signal_strengths,
          break_points
        )
    when /addx/
      amount = item.split(" ")[1].to_i
      cycle_count, x_register, signal_strengths, break_points =
        increase_cycle(
          2,
          cycle_count,
          x_register,
          signal_strengths,
          break_points
        )
      x_register += amount
    end
  end
  signal_strengths.sum
end

def print_rows(rows)
  rows.each { |row| p row.join("") }
end

def increase_cycle_for_2(amount, cycle_count, x_register, rows, row)
  amount.times do
    cycle_count += 1
    sprite_positions = (x_register..x_register + 2).to_a
    item = sprite_positions.include?(cycle_count) ? "#" : "."
    row.push(item)
    if cycle_count == 40
      rows.push(row)
      row = []
      cycle_count = 0
    end
  end
  return cycle_count, x_register, rows, row
end

def get_part_2(input)
  cycle_count = 0
  x_register = 1
  rows = []
  row = []

  input.each do |item|
    case item
    when "noop"
      cycle_count, x_register, rows, row =
        increase_cycle_for_2(1, cycle_count, x_register, rows, row)
    when /addx/
      amount = item.split(" ")[1].to_i
      cycle_count, x_register, rows, row =
        increase_cycle_for_2(2, cycle_count, x_register, rows, row)
      x_register += amount
    end
  end
  rows
end

input = File.read("real_input.txt").split("\n")

p "The answer to part 1 is #{get_part_1(input)}" # The answer to part 1 is 17840
p "The answer to part 2 is #{print_rows(get_part_2(input))}" # The answer to part 2 is EALGULPG
