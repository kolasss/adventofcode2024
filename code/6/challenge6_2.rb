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

# input1 = %{.#....
# .....#
# #..#..
# ..#...
# .^...#
# ....#.}

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
  mark_map_direction(x, y, direction, MAP)

  direction_new = find_new_direction(x, y, direction, MAP)

  x_new = x + direction_new[0]
  y_new = y + direction_new[1]

  return count if x_new < 0 || x_new >= MAP[0].size || y_new < 0 || y_new >= MAP.size

  count += 1 if possible_block_position?(x, y, direction_new)

  next_step(x_new, y_new, direction_new, count)
end

def find_new_direction(x, y, direction, map)
  x_new = x + direction[0]
  y_new = y + direction[1]

  return direction if x_new < 0 || x_new >= map[0].size || y_new < 0 || y_new >= map.size
  return direction if map.dig(y_new, x_new) != '#' && map.dig(y_new, x_new) != 'O'

  direction_new = NEXT_DIRECTION[direction]
  find_new_direction(x, y, direction_new, map)
end

DIRECTION_MARK = {
  [0, -1] => 'w',
  [1, 0] => 'd',
  [0, 1] => 's',
  [-1, 0] => 'a'
}

def mark_map_direction(x, y, direction, map)
  mark = DIRECTION_MARK[direction]
  if map.dig(y, x) == '.'
    map[y][x] = mark
  else
    map[y][x] = map[y][x] + mark
  end
end

def possible_block_position?(x, y, direction)
  x_new = x + direction[0]
  y_new = y + direction[1]
  return false if MAP.dig(y_new, x_new) != '.'

  map_new = MAP.map(&:dup)
  map_new[y_new][x_new] = 'O'
  next_step_with_obstruction(x, y, direction, map_new)
end

def next_step_with_obstruction(x, y, direction, map)
  mark_map_direction(x, y, direction, map)

  direction_new = find_new_direction(x, y, direction, map)

  x_new = x + direction_new[0]
  y_new = y + direction_new[1]

  if x_new < 0 || x_new >= map[0].size || y_new < 0 || y_new >= map.size
    # p "out of map"
    return false
  end

  symbol_next = map.dig(y_new, x_new)

  if symbol_next != '.'
    # p "symbol_next: #{symbol_next}"
    mark = DIRECTION_MARK[direction_new]
    # p "mark: #{mark}"
    if symbol_next.include?(mark)
      # map.map{ _1.map{ |char| char[0] }.join('')}.each { |line| p line }
      # p '=' * 30
      return true
    end
  end

  next_step_with_obstruction(x_new, y_new, direction_new, map)
end

start_x, start_y = find_start

arrow = MAP.dig(start_y, start_x)
direction = DIRECTIONS[arrow]

p next_step(start_x, start_y, direction)
# pp MAP.map{ _1.join(' ')}.join("\n")

# 424 too low
# 508 too low
# 2179 too high
