require "./input.rb"

move_hash = {
  A: {
    name: :rock,
    score: 1,
    beats: :scissors,
    draws: :rock,
    loses: :paper,
    equals: "X"
  },
  B: {
    name: :paper,
    score: 2,
    beats: :rock,
    draws: :paper,
    loses: :scissors,
    equals: "Y"
  },
  C: {
    name: :scissors,
    score: 3,
    beats: :paper,
    draws: :scissors,
    loses: :rock,
    equals: "Z"
  }
}

strategy_hash = { X: "loses", Y: "draws", Z: "beats" }

input = @real_input
games = input.split("\n").reject(&:empty?).map { |item| item.split(" ") }

def calculate_score(my_move, opponents_move)
  if my_move == opponents_move
    my_move[:score] + 3
  elsif my_move[:beats] == opponents_move[:name]
    my_move[:score] + 6
  else
    my_move[:score]
  end
end

part1 =
  games.map do |(them, me)|
    opponents_move = move_hash[them.to_sym]
    my_move =
      move_hash.select { |key, value| value[:equals] == me }.values.first
    calculate_score(my_move, opponents_move)
  end

part2 =
  games.map do |(them, me)|
    opponents_move = move_hash[them.to_sym]
    my_strategy = strategy_hash[me.to_sym]
    my_move =
      move_hash
        .select do |key, value|
          value[my_strategy.to_sym] == opponents_move[:name]
        end
        .values
        .first

    calculate_score(my_move, opponents_move)
  end

puts "The answer to part 1 is: #{part1.sum}" # The answer to part 1 is: 14531
puts "The answer to part 2 is: #{part2.sum}" # The answer to part 2 is: 11258
