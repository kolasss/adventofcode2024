# Start as
# RUBY_THREAD_VM_STACK_SIZE=5000000 ruby challenge6_2.rb

MAP = []

File.readlines('input6', chomp: true).each do |line|
  MAP << line.split('')
end

# input1 = %{....#.....
# .........#
# ..........
# ..#.......
# .......#..
# ..........
# .#..^.....
# ........#.
# #.........
# ......#...}

# MAP = input1.split("\n").map do |line|
#   line.split('')
# end

DIRECTIONS = {
  '^' => [0, -1],
  '>' => [1, 0],
  'v' => [0, 1],
  '<' => [-1, 0]
}

def find_start
  arrows = DIRECTIONS.keys

  MAP.each_with_index do |line, y|
    line.each_with_index do |char, x|
      return [x, y] if arrows.include?(char)
    end
  end
end

NEXT_DIRECTION = {
  [0, -1] => [1, 0],
  [1, 0] => [0, 1],
  [0, 1] => [-1, 0],
  [-1, 0] => [0, -1]
}

def next_step(x, y, direction, count = 0)
  direction_new = find_new_direction(x, y, direction)

  if direction_new == direction
    mark_map_direction(x, y, direction_new)
  else
    mark_map_turn(x, y)
  end

  x_new = x + direction_new[0]
  y_new = y + direction_new[1]

  return count if x_new < 0 || x_new >= MAP[0].size || y_new < 0 || y_new >= MAP.size

  symbol_next = MAP.dig(y_new, x_new)

  if symbol_next != '.'
    possible_block_symbol = DIRECTION_MARK[NEXT_DIRECTION[direction_new]]
    if symbol_next.include?(possible_block_symbol)
      # if can place a block on empty space
      x_new2 = x_new + direction_new[0]
      y_new2 = y_new + direction_new[1]
      if MAP.dig(y_new2, x_new2) == '.'
        count += 1
      end
    end
  end

  next_step(x_new, y_new, direction_new, count)
end

def find_new_direction(x, y, direction)
  x_new = x + direction[0]
  y_new = y + direction[1]

  return direction if MAP.dig(y_new, x_new) != '#'

  direction_new = NEXT_DIRECTION[direction]
  find_new_direction(x, y, direction_new)
end

DIRECTION_MARK = {
  [0, -1] => 'w',
  [1, 0] => 'd',
  [0, 1] => 's',
  [-1, 0] => 'a'
}

def mark_map_direction(x, y, direction)
  mark = DIRECTION_MARK[direction]
  if MAP.dig(y, x) == '.'
    MAP[y][x] = mark
  else
    MAP[y][x] = MAP[y][x] + mark
  end

  direction_opposite = NEXT_DIRECTION[NEXT_DIRECTION[direction]]
  mark_map_opposite(x, y, direction_opposite, mark)
end

def mark_map_opposite(x, y, direction, mark)
  x_opposite = x + direction[0]
  y_opposite = y + direction[1]

  return if x_opposite < 0 || x_opposite >= MAP[0].size || y_opposite < 0 || y_opposite >= MAP.size

  step_symbol = MAP.dig(y_opposite, x_opposite)
  return if step_symbol == '#'

  # p x_opposite
  # p y_opposite
  # p step_symbol
  if step_symbol == '.'
    MAP[y_opposite][x_opposite] = mark
  elsif step_symbol.include?(mark)
    return
  else
    MAP[y_opposite][x_opposite] = MAP[y_opposite][x_opposite] + mark
  end
  # p MAP[y_opposite][x_opposite]
  mark_map_opposite(x_opposite, y_opposite, direction, mark)
end

def mark_map_turn(x, y)
  mark = 't'
  if MAP.dig(y, x) == '.'
    MAP[y][x] = mark
  else
    MAP[y][x] = MAP[y][x] + mark
  end
end

start_x, start_y = find_start

arrow = MAP.dig(start_y, start_x)
direction = DIRECTIONS[arrow]

p next_step(start_x, start_y, direction)
# pp MAP.map{ _1.join(' ')}.join("\n")


# 424 too low
# 508 too low
