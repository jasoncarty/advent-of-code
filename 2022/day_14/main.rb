@sand_entry_point = 0
@count = 0
@x_pos = 0
@y_pos = 0

def convert_x_point_idx(point, mininmum)
  return point - mininmum
end

def get_rock_points(items, mininmum)
  rock_points = []
  items.each do |item|
    item.each_cons(2) do |first, second|
      first_x, first_y = first.to_s.split(".").map(&:to_i)
      second_x, second_y = second.to_s.split(".").map(&:to_i)

      first_x_sorted, second_x_sorted =
        [first_x, second_x].sort_by { |item| item }
      first_y_sorted, second_y_sorted =
        [first_y, second_y].sort_by { |item| item }

      x_points = (first_x_sorted..second_x_sorted).to_a
      y_points = (first_y_sorted..second_y_sorted).to_a

      is_on_x_axis = x_points.length > 1
      is_on_y_axis = y_points.length > 1

      if is_on_x_axis
        x_points.each do |x_point|
          rock_points.push(
            [convert_x_point_idx(x_point, mininmum), y_points.last]
          )
        end
      else
        y_points.each do |y_point|
          rock_points.push(
            [convert_x_point_idx(x_points.last, mininmum), y_point]
          )
        end
      end
    end
  end
  rock_points
end

def print_matrix(matrix)
  matrix.each { |row| p row.join("") }
end

def drop_sand(matrix)
  return if !matrix[@y_pos + 1]
  can_go_down = matrix[@y_pos + 1][@x_pos] == "."
  can_go_down_left = matrix[@y_pos + 1][@x_pos - 1] == "."
  can_go_down_right = matrix[@y_pos + 1][@x_pos + 1]

  if can_go_down
    p "going down"
    @y_pos += 1
    return drop_sand(matrix)
  elsif can_go_down_left
    p "going down and left"
    @x_pos -= 1
    @y_pos += 1
    return drop_sand(matrix)
  elsif can_go_down_right
    p "going down and right"
    @x_pos += 1
    @y_pos += 1
    return drop_sand(matrix)
  elsif (matrix[@y_pos + 1][@x_pos] == "#" && matrix[@y_pos][@x_pos] == ".") ||
        (matrix[@y_pos + 1][@x_pos] == "o" && matrix[@y_pos][@x_pos] == ".")
    matrix[@y_pos][@x_pos] = "o"
    @count += 1
    print_matrix(matrix)
  end
  @x_pos = @sand_entry_point
  @y_pos = 0
  p "Made it past the conditions"
end

def part1(input)
  lines = input.split("\n")
  cols =
    lines.map do |item|
      item.split(" -> ").map { |item| item.split(",")[0].to_i }
    end
  rows =
    lines.map do |item|
      item.split(" -> ").map { |item| item.split(",")[1].to_i }
    end
  items =
    lines.map do |item|
      item.split(" -> ").map { |item| item.gsub(",", ".").to_f }
    end
  min_cols = cols.flatten.min.to_i
  max_cols = cols.flatten.max.to_i
  min_rows = rows.flatten.min.to_i
  max_rows = rows.flatten.max.to_i
  cols = (0..max_cols - min_cols).to_a
  rows = (0..max_rows).to_a
  rock_points = get_rock_points(items, min_cols)
  @sand_entry_point = convert_x_point_idx(500, min_cols)

  matrix =
    cols.map.each_with_index do |col, y|
      rows.map.each_with_index do |row, x|
        rock_points.include?([x, y]) ? "#" : "."
      end
    end

  print_matrix(matrix)
  @x_pos = @sand_entry_point
  @y_pos = 0
  while (
          matrix[@y_pos] && matrix[@y_pos][@x_pos] && matrix[@y_pos + 1] &&
            matrix[@y_pos + 1][@x_pos]
        )
    drop_sand(matrix)
  end

  p "The answer to part 1 is: #{@count}"
end

path = File.join(File.dirname(__FILE__), "real_input.txt")
input = File.read(path)

part1_answer = part1(input)
