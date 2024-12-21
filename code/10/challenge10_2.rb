MAP = []

File.readlines('input10', chomp: true).each do |line|
  MAP << line.split('').map(&:to_i)
end

# input1 = %{89010123
# 78121874
# 87430965
# 96549874
# 45678903
# 32019012
# 01329801
# 10456732}

# MAP = input1.split("\n").map do |line|
#   line.split('').map(&:to_i)
# end

BOUNDARIES = { x: MAP.first.size, y: MAP.size }

DIRECTIONS = [
  [0, 1],
  [1, 0],
  [0, -1],
  [-1, 0]
]

def calculate_score(x, y)
  height = MAP[y][x]
  return 1 if height == 9

  score = 0

  DIRECTIONS.each do |(dx, dy)|
    x1 = x + dx
    y1 = y + dy

    next unless coords_in_map(x1, y1)

    if MAP[y1][x1] == height + 1
      score += calculate_score(x1, y1)
    end
  end

  score
end

def coords_in_map(x, y)
  x >= 0 && x < BOUNDARIES[:x] && y >= 0 && y < BOUNDARIES[:y]
end

sum = 0

MAP.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    next if cell != 0

    sum += calculate_score(x, y)
  end
end

p sum
