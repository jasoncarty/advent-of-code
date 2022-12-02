require "./input.rb"

input = @real_input

games = input.split("\n").reject(&:empty?).map { |item| item.split(" ") }
scores =
  games.map do |move|
    my_strategy = @strategy_hash[move[1].to_sym]
    my_move_key =
      @scores_hash2
        .select do |k, v|
          if my_strategy == "lose"
            v[:beats] != move[0] && v[:draws] != move[0]
          else
            v[my_strategy.to_sym] == move[0]
          end
        end
        .keys
        .first
    my_move = @scores_hash2[my_move_key]

    case my_strategy
    when "beats"
      my_move[:score] + 6
    when "draws"
      my_move[:score] + 3
    else
      my_move[:score]
    end
  end

puts "The answer is: #{scores.reduce(&:+)}"
