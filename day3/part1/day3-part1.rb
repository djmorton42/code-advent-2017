require 'byebug'

TARGET_VALUE = 361527

def calc_required_squares
  (Math.sqrt(TARGET_VALUE).ceil / 2).floor + 1
end

required_squares = calc_required_squares
CENTER_INDEX_X = required_squares - 1
CENTER_INDEX_Y = required_squares - 1

current_index_x = CENTER_INDEX_X
current_index_y = CENTER_INDEX_Y

def cells_per_side(square_number)
  2 + (square_number - 2) * 2
end

def set_value(grid, x, y, value)
  grid[y][x] = value

  if value == TARGET_VALUE
    puts "Target Value #{TARGET_VALUE} found at (#{x}, #{y})"

    x_distance = (CENTER_INDEX_X - x).abs
    y_distance = (CENTER_INDEX_Y - y).abs

    puts "Manhattan Distance: #{x_distance + y_distance}"
    exit
  end
end

def print_grid(grid, padding)
  grid.each do |row|
    row_string = ""
    row.each do |cell|
      row_string += " #{cell.to_s.ljust(padding, ' ')}"
    end
    puts row_string
  end
end

SQUARE_SIDE_SIZE = 1 + ((required_squares - 1) * 2)

grid = Array.new(SQUARE_SIDE_SIZE) { |index| Array.new(SQUARE_SIDE_SIZE) { |inner_index| 0 } }

value = 1
square_index = 2

set_value(grid, current_index_y, current_index_x, value)

value += 1

while value <= TARGET_VALUE do
  cells_to_add = cells_per_side(square_index)

  current_index_x += 1
  set_value(grid, current_index_x, current_index_y, value)
  value += 1

  (1...cells_to_add).each do |i|
    current_index_y -= 1
    set_value(grid, current_index_x, current_index_y, value)
    value += 1
  end

  current_index_x -= 1
  set_value(grid, current_index_x, current_index_y, value)
  value += 1

  (1...cells_to_add).each do |i|
    current_index_x -= 1
    set_value(grid, current_index_x, current_index_y, value)
    value += 1
  end

  current_index_y += 1
  set_value(grid, current_index_x, current_index_y, value)
  value += 1

  (1...cells_to_add).each do |i|
    current_index_y += 1
    set_value(grid, current_index_x, current_index_y, value)
    value += 1
  end

  current_index_x += 1
  set_value(grid, current_index_x, current_index_y, value)
  value += 1

  (1...cells_to_add).each do |i|
    current_index_x += 1
    set_value(grid, current_index_x, current_index_y, value)
    value += 1
  end

  square_index += 1
end
