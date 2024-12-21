MAP = []

File.readlines('input8', chomp: true).each do |line|
  MAP << line.split('')
end

# input1 = %{............
# ........0...
# .....0......
# .......0....
# ....0.......
# ......A.....
# ............
# ............
# ........A...
# .........A..
# ............
# ............}

# input1 = %{............
# ............
# ............
# ............
# ....0..0....
# ............
# ............
# ............
# ............
# ............
# ............
# ............}

# MAP = input1.split("\n").map do |line|
#   line.split('')
# end

BOUNDARIES = { x: MAP.first.size, y: MAP.size }

def collect_frequencies
  frequencies = {}
  MAP.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      next if cell == '.'

      frequencies[cell] ||= []
      frequencies[cell] << [x, y]
    end
  end
  frequencies
end

def calculate_antinodes(positions, found_coords)
  return 0 if positions.size < 2

  sum = 0

  positions.combination(2).count do |(x1, y1), (x2, y2)|
    unless found_coords.dig(x1, y1)
      found_coords[x1] ||= {}
      found_coords[x1][y1] = true
      sum += 1
    end
    unless found_coords.dig(x2, y2)
      found_coords[x2] ||= {}
      found_coords[x2][y2] = true
      sum += 1
    end

    1000.times do |i|
      node_x1, node_y1 = find_left_antinode(x1, y1, x2, y2, (i + 1))
      if coords_in_map(node_x1, node_y1)
        unless found_coords.dig(node_x1, node_y1)
          found_coords[node_x1] ||= {}
          found_coords[node_x1][node_y1] = true
          sum += 1
          # p "node_x1: #{node_x1} node_y1: #{node_y1}"
          # # old_cell = MAP[node_y1][node_x1]
          # old1 = MAP[y1][x1]
          # old2 = MAP[y2][x2]
          # MAP[node_y1][node_x1] = '#'
          # MAP[y1][x1] = 'X'
          # MAP[y2][x2] = 'Y'
          # MAP.each { |row| p row.join('') }
          # # MAP[node_y1][node_x1] = old_cell
          # MAP[y1][x1] = old1
          # MAP[y2][x2] = old2
        end
      else
        break
      end
    end

    1000.times do |i|
      node_x2, node_y2 = find_right_antinode(x1, y1, x2, y2, (i + 1))
      if coords_in_map(node_x2, node_y2)
        unless found_coords.dig(node_x2, node_y2)
          found_coords[node_x2] ||= {}
          found_coords[node_x2][node_y2] = true
          sum += 1
          # p "node_x2: #{node_x2} node_y2: #{node_y2}"
          # # old_cell = MAP[node_y2][node_x2]
          # old1 = MAP[y1][x1]
          # old2 = MAP[y2][x2]
          # MAP[node_y2][node_x2] = '#'
          # MAP[y1][x1] = 'X'
          # MAP[y2][x2] = 'Y'
          # MAP.each { |row| p row.join('') }
          # # MAP[node_y2][node_x2] = old_cell
          # MAP[y1][x1] = old1
          # MAP[y2][x2] = old2
        end
      else
        break
      end
    end
  end
  sum
end

def find_left_antinode(x1, y1, x2, y2, count)
  if x1 < x2
    node_x1 = x1 - ((x2 - x1) * count)

    if y1 < y2
      node_y1 = y1 - ((y2 - y1) * count)
    elsif y1 > y2
      node_y1 = y1 + ((y1 - y2) * count)
    else
      node_y1 = y1
    end
  elsif x1 > x2
    node_x1 = x2 - ((x1 - x2) * count)

    if y1 < y2
      node_y1 = y2 + ((y2 - y1) * count)
    elsif y1 > y2
      node_y1 = y2 - ((y1 - y2) * count)
    else
      node_y1 = y1
    end
  else
    node_x1 = x1

    if y1 < y2
      node_y1 = y1 - ((y2 - y1) * count)
    elsif y1 > y2
      node_y1 = y2 - ((y1 - y2) * count)
    else
      node_y1 = y1
    end
  end

  [node_x1, node_y1]
end

def find_right_antinode(x1, y1, x2, y2, count)
  if x1 < x2
    node_x1 = x2 + ((x2 - x1) * count)

    if y1 < y2
      node_y1 = y2 + ((y2 - y1) * count)
    elsif y1 > y2
      node_y1 = y2 - ((y1 - y2) * count)
    else
      node_y1 = y1
    end
  elsif x1 > x2
    node_x1 = x1 + ((x1 - x2) * count)

    if y1 < y2
      node_y1 = y1 - ((y2 - y1) * count)
    elsif y1 > y2
      node_y1 = y1 + ((y1 - y2) * count)
    else
      node_y1 = y1
    end
  else
    node_x1 = x1

    if y1 < y2
      node_y1 = y2 + ((y2 - y1) * count)
    elsif y1 > y2
      node_y1 = y1 + ((y1 - y2) * count)
    else
      node_y1 = y1
    end
  end

  [node_x1, node_y1]
end

def coords_in_map(x, y)
  x >= 0 && x < BOUNDARIES[:x] && y >= 0 && y < BOUNDARIES[:y]
end

sum = 0

frequencies = collect_frequencies
found_coords = {}

frequencies.each do |key, positions|
  sum += calculate_antinodes(positions, found_coords)
end

p sum