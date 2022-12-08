def is_visible?(this_tree, other_trees)
  other_trees.all? { |tree| this_tree > tree }
end

def set_visible(this_tree, all_trees, visibles)
  is_visible = false
  all_trees.each do |trees|
    break if is_visible
    is_visible = is_visible?(this_tree, trees)
    visibles += 1 if is_visible
  end
  visibles
end

def set_scenic_score(this_tree, all_trees, scenic_score)
  above, below, right, left = all_trees
  scenic_score.push(
    [above.reverse, below, right, left.reverse].map do |trees|
        count = 0
        trees.each do |tree|
          if tree < this_tree
            count += 1
          elsif tree == this_tree or tree > this_tree
            count += 1
            break
          end
        end
        count
      end
      .reduce(&:*)
  )
  return scenic_score
end

def get_surrounding_trees(col, row, col_idx, row_idx)
  above = col[0..row_idx - 1]
  below = col[row_idx + 1..-1]
  right = row[col_idx + 1..-1]
  left = row[0..col_idx - 1]
  return above, below, right, left
end

def get_column(grid, col_idx)
  grid.map do |temp_row|
    temp_row
      .filter_map
      .each_with_index { |col, col_index| col if col_index == col_idx }
      .first
  end
end

def parts_fn(grid, return_value, callback)
  grid.each_with_index do |row, row_idx|
    next if row_idx == 0 or row_idx == grid.length - 1
    row.each_with_index do |item, col_idx|
      next if col_idx == 0 or col_idx == row.length - 1
      this_column = get_column(grid, col_idx)
      return_value =
        method(callback).call(
          item,
          get_surrounding_trees(this_column, row, col_idx, row_idx),
          return_value
        )
    end
  end
  return_value
end

input = File.read("practice_input.txt")

grid = input.split("\n").map { |item| item.split("").map(&:to_i) }
grid_length = grid[0].length
grid_height = grid.length - 2
visibles = (grid_length * 2) + (grid_height * 2)
scenic_scores = []

p "The answer to part 1 is #{parts_fn(grid, visibles, :set_visible)}" # The answer to part 1 is 1870
p "The answer to part 2 is #{parts_fn(grid, scenic_scores, :set_scenic_score).sort().last}" # The answer to part 2 is 517440
