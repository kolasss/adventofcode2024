ARR = []
File.readlines('input4', chomp: true).each do |line|
  ARR << line.split('')
end

# input = %{MMMSXXMASM
# MSAMXMSMSA
# AMXSXMAAMM
# MSAMASMSMX
# XMASAMXAMM
# XXAMMXXAMA
# SMSMSASXSS
# SAXAMASAAA
# MAMMMXMMMM
# MXMXAXMASX
# }

# ARR = input.split("\n").map do |line|
#   line.split('')
# end

ROWS = ARR.size
COLS = ARR[0].size
DIRECTIONS = [
  [1, 0],
  [1, -1],
  [0, -1],
  [-1, -1],
  [-1, 0],
  [-1, 1],
  [0, 1],
  [1, 1]
]

# XMAS
def find_xmas(x, y, symbol, direction = 0)
  return 0 if x < 0 || x >= ROWS || y < 0 || y >= COLS
  return 0 if ARR[x][y] != symbol
  return 1 if symbol == 'S'

  if symbol == 'X'
    count = 0
    DIRECTIONS.each_with_index do |dir, dir_index|
      count += find_xmas(x + dir[0], y + dir[1], 'M', dir_index)
    end

    return count
  elsif symbol == 'M'
    find_xmas(x + DIRECTIONS[direction][0], y + DIRECTIONS[direction][1], 'A', direction)
  elsif symbol == 'A'
    find_xmas(x + DIRECTIONS[direction][0], y + DIRECTIONS[direction][1], 'S', direction)
  end
end

count = 0

ROWS.times do |x|
  COLS.times do |y|
    count += find_xmas(x, y, 'X')
  end
end

p count
