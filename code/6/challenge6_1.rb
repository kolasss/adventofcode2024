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

def next_step(x, y, direction, visited, count = 1)
  direction_new = find_new_direction(x, y, direction)

  x_new = x + direction_new[0]
  y_new = y + direction_new[1]

  return count if x_new < 0 || x_new >= MAP[0].size || y_new < 0 || y_new >= MAP.size

  unless visited.dig(x_new, y_new)
    count += 1
    visited[x_new] ||= {}
    visited[x_new][y_new] = true
  end

  next_step(x_new, y_new, direction_new, visited, count)
end

def find_new_direction(x, y, direction)
  x_new = x + direction[0]
  y_new = y + direction[1]

  return direction if x_new < 0 || x_new >= MAP[0].size || y_new < 0 || y_new >= MAP.size
  return direction if MAP.dig(y_new, x_new) != '#'

  direction_new = NEXT_DIRECTION[direction]
  find_new_direction(x, y, direction_new)
end

start_x, start_y = find_start
visited = { start_x => { start_y => true } }

arrow = MAP.dig(start_y, start_x)
direction = DIRECTIONS[arrow]

p next_step(start_x, start_y, direction, visited)
