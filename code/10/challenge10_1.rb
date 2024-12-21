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

def find_nines(x, y)
  height = MAP[y][x]
  return Set.new([[x, y]]) if height == 9

  coords = Set.new

  DIRECTIONS.each do |(dx, dy)|
    x1 = x + dx
    y1 = y + dy

    next unless coords_in_map(x1, y1)

    if MAP[y1][x1] == height + 1
      coords += find_nines(x1, y1)
    end
  end

  coords
end

def coords_in_map(x, y)
  x >= 0 && x < BOUNDARIES[:x] && y >= 0 && y < BOUNDARIES[:y]
end

sum = 0

MAP.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    next if cell != 0

    coords = find_nines(x, y)
    sum += coords.size
  end
end

p sum
