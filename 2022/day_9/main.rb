Position = Struct.new(:x, :y)
Knot = Struct.new(:position, :moves)

class Rope
  def initialize(knots = 2)
    @knots = create_knots(knots)
    @head = @knots[0]
    @tail = @knots[knots - 1]
  end

  def create_knots(amount)
    Array.new(amount) { Knot.new(Position.new(0, 0), []) }
  end

  def tail_moves
    @tail.moves.uniq
  end

  def update_knot(current_knot_index)
    current_knot = @knots[current_knot_index]
    previous_knot = @knots[current_knot_index - 1]
    return if current_knot.nil?

    x_diff = (previous_knot.position.x - current_knot.position.x)
    y_diff = (previous_knot.position.y - current_knot.position.y)

    if x_diff.abs > 1 || y_diff.abs > 1
      current_knot.position.x += x_diff > 0 ? 1 : -1 unless x_diff.zero?
      current_knot.position.y += y_diff > 0 ? 1 : -1 unless y_diff.zero?
    end
    current_knot.moves.push([current_knot.position.x, current_knot.position.y])
  end

  def move(direction, steps)
    case direction
    when "U"
      steps.times do
        @head.position.y += 1
        @knots.each_with_index { |v, k| update_knot(k + 1) }
        @head.moves.push([@head.position.x, @head.position.y])
      end
    when "D"
      steps.times do
        @head.position.y -= 1
        @knots.each_with_index { |v, k| update_knot(k + 1) }
        @head.moves.push([@head.position.x, @head.position.y])
      end
    when "R"
      steps.times do
        @head.position.x += 1
        @knots.each_with_index { |v, k| update_knot(k + 1) }
        @head.moves.push([@head.position.x, @head.position.y])
      end
    when "L"
      steps.times do
        @head.position.x -= 1
        @knots.each_with_index { |v, k| update_knot(k + 1) }
        @head.moves.push([@head.position.x, @head.position.y])
      end
    end
  end
end

def part1(input)
  rope = Rope.new(2)
  input.each do |line|
    direction, steps = line.split(" ")
    rope.move(direction, steps.to_i)
  end
  rope.tail_moves.length
end

def part2(input)
  rope = Rope.new(10)
  input.each do |line|
    direction, steps = line.split(" ")
    rope.move(direction, steps.to_i)
  end
  rope.tail_moves.length
end

input = File.read("real_input.txt").split("\n")

p "The answer to part 1 is #{part1(input)}" # The answer to part 1 is: 6406
p "The answer to part 2 is #{part2(input)}" # The answer to part 1 is: 2643
