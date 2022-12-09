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

  def print_everything
    curr_x, curr_y = [0, 0]

    sorted = @knots.sort { |a, b| a.position.y - b.position.y } #.reverse.sort { |a, b| a[0] - b[0] }
    p sorted
    #.each_with_index { |knot, idx| p idx }
  end

  def update_knot(amount, current_knot_index)
    current_knot = @knots[current_knot_index]
    previous_knot = @knots[current_knot_index - 1]
    return if current_knot.nil?
    #p "---------->> current_knot: #{current_knot}"
    #p "|--knot: #{current_knot_index}--x: #{previous_knot.position.x}, y: #{previous_knot.position.y}----------|---------x: #{current_knot.position.x}, y: #{current_knot.position.y}---------|"
    #p "prev knot x: #{previous_knot.position.x} y: #{previous_knot.position.y}"
    x_diff = (previous_knot.position.x - current_knot.position.x).abs
    y_diff = (previous_knot.position.y - current_knot.position.y).abs
    on_different_line =
      (previous_knot.position.x != current_knot.position.x) &&
        (previous_knot.position.y != current_knot.position.y)
    if (x_diff > 1 || y_diff > 1) && on_different_line
      #p "---------1----------"
      x, y = previous_knot.moves.last
      current_knot.position = Position.new(x, y)
    elsif x_diff > 1
      #p "---------2----------"
      current_knot.position.x += amount
    elsif y_diff > 1
      #p "---------3----------"
      current_knot.position.y += amount
    end
    current_knot.moves.push([current_knot.position.x, current_knot.position.y])
    previous_knot.moves.push(
      [previous_knot.position.x, previous_knot.position.y]
    )
    # p "|--knot: #{current_knot_index}--x: #{previous_knot.position.x}, y: #{previous_knot.position.y}----------|---------x: #{current_knot.position.x}, y: #{current_knot.position.y}---------|"
  end

  def move(direction, steps)
    case direction
    when "U"
      steps.times do
        @head.position.y += 1
        @knots.each_with_index { |v, k| update_knot(1, k + 1) }
        # self.update_knot(1)
      end
    when "D"
      steps.times do
        @head.position.y -= 1
        @knots.each_with_index { |v, k| update_knot(-1, k + 1) }
        # self.update_knot(-1)
      end
    when "R"
      steps.times do
        @head.position.x += 1
        @knots.each_with_index { |v, k| update_knot(1, k + 1) }
        #self.update_knot(1)
      end
    when "L"
      steps.times do
        @head.position.x -= 1
        @knots.each_with_index { |v, k| update_knot(-1, k + 1) }
        #self.update_knot(-1)
      end
    end
    self.print_everything
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
  input
    .take(1)
    .each do |line|
      direction, steps = line.split(" ")
      p "|-----------#{direction} #{steps}-----------|"
      rope.move(direction, steps.to_i)
      p ""
      p ""
    end
  rope.tail_moves.length
end

input = File.read("real_input.txt").split("\n")

p "|-----------HEAD-----------|-----------TAIL-----------|"

p "The answer to part 1 is #{part1(input)}" # The answer to part 1 is: 6406
p "The answer to part 2 is #{part2(input)}" # The answer to part 1 is:
