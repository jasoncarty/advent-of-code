require "colorize"

require "./input.rb"

input = @real_input
all_input = input.split("\n\n")
drawn_numbers = all_input[0].strip().split(",")
all_input.shift()

@bingo_cards =
  all_input.map do |i|
    i
      .split("\n")
      .map do |x|
        x.split(" ").map(&:strip).map { |y| { number: y, drawn: false } }
      end
  end

def check_numbers_for_winner(numbers, card)
  return numbers.flatten.all? { |number| number[:drawn] } ? card : false
end

def draw_bingo_number(drawn_number_index, drawn_numbers)
  winning_card = nil
  return nil, nil if !drawn_numbers[drawn_number_index]
  drawn_number = drawn_numbers[drawn_number_index]

  @bingo_cards.each do |card|
    break if winning_card
    card.each do |row|
      break if winning_card
      row.each_with_index do |number, col_index|
        next if number[:drawn] == true
        next unless drawn_number == number[:number]

        number[:drawn] = true
        winning_card = check_numbers_for_winner(row, card)
        break if winning_card

        col = card.map { |col_row| col_row[col_index] }
        winning_card = check_numbers_for_winner(col, card)
        break if winning_card
      end
    end
  end

  if !winning_card
    return draw_bingo_number(drawn_number_index + 1, drawn_numbers)
  end
  return winning_card, drawn_number
end

winning_card, winning_number = draw_bingo_number(0, drawn_numbers)
unmarked_numbers =
  winning_card
    .flatten
    .filter { |item| !item[:drawn] }
    .map { |hash| hash[:number].to_i }
    .reduce(&:+)

puts "The answer is: #{unmarked_numbers * winning_number.to_i}"
