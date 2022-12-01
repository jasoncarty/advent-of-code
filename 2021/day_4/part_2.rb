require "colorize"

require "./input.rb"

input = @real_input
all_input = input.split("\n\n")
drawn_numbers = all_input[0].strip().split(",")
all_input.shift()
@winning_cards = []

@bingo_cards =
  all_input.map do |i|
    i
      .split("\n")
      .map do |x|
        x.split(" ").map(&:strip).map { |y| { number: y, drawn: false } }
      end
  end

def print_cards()
  cards = Marshal.load(Marshal.dump(@bingo_cards))
  cards.each_with_index do |card, card_index|
    puts "Card: #{card_index + 1}".colorize(:red)
    card.each do |row|
      should_underline = row.flatten.all? { |item| item[:drawn] }
      # if should_underline
      #   puts "%%%%%%%%%%%%%%%% Found the winner %%%%%%%%%%%%%%%%%"
      #   puts "row: #{row}"
      # end
      text_to_print =
        row
          .map do |col|
            col[:drawn] ? "#{col[:number]}".red : "#{col[:number]}".white
          end
          .join(" ")
      puts "#{text_to_print}\n"
    end
    puts "\n"
  end
  puts "----------------------------------\n"
end

def check_numbers_for_winner(numbers, card)
  if numbers.flatten.all? { |number| number[:drawn] }
    print_cards
    @winning_cards.push(card)
  end
end

def draw_bingo_number(drawn_number_index, drawn_numbers)
  return nil, nil if !drawn_numbers[drawn_number_index]
  drawn_number = drawn_numbers[drawn_number_index]
  # puts "----------drawn_number: #{drawn_number}-------------"

  @bingo_cards.each do |card|
    break if @winning_cards.length == @bingo_cards.length
    card.each do |row|
      break if @winning_cards.length == @bingo_cards.length
      row.each_with_index do |number, col_index|
        break if @winning_cards.length == @bingo_cards.length
        next if number[:drawn] == true
        next unless drawn_number == number[:number]

        number[:drawn] = true
        check_numbers_for_winner(row, card)

        col = card.map { |col_row| col_row[col_index] }
        check_numbers_for_winner(col, card)
      end
    end
  end

  if @winning_cards.length != @bingo_cards.length
    return draw_bingo_number(drawn_number_index + 1, drawn_numbers)
  else
    return @winning_cards.last, drawn_number
  end
end

winning_card, winning_number = draw_bingo_number(0, drawn_numbers)
unmarked_numbers =
  winning_card
    .flatten
    .filter { |item| !item[:drawn] }
    .map { |hash| hash[:number].to_i }
    .reduce(&:+)

the_unmarked_numbers =
  winning_card
    .flatten
    .filter { |item| !item[:drawn] }
    .map { |hash| hash[:number].to_i }

puts "winning number: #{winning_number}"
puts "winning_card: #{winning_card}"
puts "the_unmarked_numbers: #{the_unmarked_numbers}"
puts "The answer is: #{unmarked_numbers * winning_number.to_i}"

=begin
the_unmarked_numbers: [50, 93, 9, 20, 5, 90, 16, 62]

50 57 93 43 9
63 20 15 5 17
35 48 2 52 60
34 33 90 85 16
13 53 47 59 62
=end
