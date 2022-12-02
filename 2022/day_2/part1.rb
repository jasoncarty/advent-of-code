require "./input.rb"

input = @real_input

games = input.split("\n").reject(&:empty?).map { |item| item.split(" ") }
scores =
  games.map do |move|
    my_move = @scores_hash[move[1].to_sym]
    if my_move[:beats] == move[0]
      my_move[:score] + 6
    elsif my_move[:draws] == move[0]
      my_move[:score] + 3
    else
      my_move[:score]
    end
  end

puts "The answer is: #{scores.reduce(&:+)}"
