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

# M.S
# .A.
# M.S
def find_xmas(x, y)
  return if x < 1 || x >= ROWS-1 || y < 1 || y >= COLS-1
  return if ARR[x][y] != 'A'

  lines = 0
  if (ARR[x-1][y-1] == 'M' && ARR[x+1][y+1] == 'S') ||
    (ARR[x-1][y-1] == 'S' && ARR[x+1][y+1] == 'M')
    lines += 1
  end
  if (ARR[x-1][y+1] == 'M' && ARR[x+1][y-1] == 'S') ||
    (ARR[x-1][y+1] == 'S' && ARR[x+1][y-1] == 'M')
    lines += 1
  end

  lines == 2
end

count = 0

ROWS.times do |x|
  COLS.times do |y|
    count += 1 if find_xmas(x, y)
  end
end

p count
