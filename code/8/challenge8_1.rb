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

# ..........
# ...#......
# #.........
# ....a.....
# ........a.
# .....a....
# ..#.......
# ......#...
# ..........
# ..........

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

# p "boundaries: #{BOUNDARIES}"

def calculate_antinodes(positions, found_coords)
  # p positions
  sum = 0

  positions.combination(2).count do |(x1, y1), (x2, y2)|
    node_x1, node_y1 = find_left_antinode(x1, y1, x2, y2)
    # p "node_x1: #{node_x1} node_y1: #{node_y1}"
    if coords_in_map(node_x1, node_y1)
      unless found_coords.dig(node_x1, node_y1)
        found_coords[node_x1] ||= {}
        found_coords[node_x1][node_y1] = true
        sum += 1
        # p "node_x1: #{node_x1} node_y1: #{node_y1}"
        # old_cell = MAP[node_y1][node_x1]
        # old1 = MAP[y1][x1]
        # old2 = MAP[y2][x2]
        # MAP[node_y1][node_x1] = '#'
        # MAP[y1][x1] = 'N'
        # MAP[y2][x2] = 'G'
        # MAP.each { |row| p row.join('') }
        # # MAP[node_y1][node_x1] = old_cell
        # MAP[y1][x1] = old1
        # MAP[y2][x2] = old2
      end
    end

    node_x2, node_y2 = find_right_antinode(x1, y1, x2, y2)
    # p "node_x2: #{node_x2} node_y2: #{node_y2}"
    if coords_in_map(node_x2, node_y2)
      unless found_coords.dig(node_x2, node_y2)
        found_coords[node_x2] ||= {}
        found_coords[node_x2][node_y2] = true
        sum += 1
        # p "node_x2: #{node_x2} node_y2: #{node_y2}"
        # old_cell = MAP[node_y2][node_x2]
        # old1 = MAP[y1][x1]
        # old2 = MAP[y2][x2]
        # MAP[node_y2][node_x2] = '#'
        # MAP[y1][x1] = 'N'
        # MAP[y2][x2] = 'G'
        # MAP.each { |row| p row.join('') }
        # # MAP[node_y2][node_x2] = old_cell
        # MAP[y1][x1] = old1
        # MAP[y2][x2] = old2
      end
    end
  end
  sum
end

def find_left_antinode(x1, y1, x2, y2)
  if x1 < x2
    node_x1 = x1 - (x2 - x1)

    if y1 < y2
      node_y1 = y1 - (y2 - y1)
    elsif y1 > y2
      node_y1 = y1 + (y1 - y2)
    else
      node_y1 = y1
    end
  elsif x1 > x2
    node_x1 = x2 - (x1 - x2)

    if y1 < y2
      node_y1 = y2 + (y2 - y1)
    elsif y1 > y2
      node_y1 = y2 - (y1 - y2)
    else
      node_y1 = y1
    end
  else
    node_x1 = x1

    if y1 < y2
      node_y1 = y1 - (y2 - y1)
    elsif y1 > y2
      node_y1 = y2 - (y1 - y2)
    else
      node_y1 = y1
    end
  end

  [node_x1, node_y1]
end

def find_right_antinode(x1, y1, x2, y2)
  if x1 < x2
    node_x1 = x2 + (x2 - x1)

    if y1 < y2
      node_y1 = y2 + (y2 - y1)
    elsif y1 > y2
      node_y1 = y2 - (y1 - y2)
    else
      node_y1 = y1
    end
  elsif x1 > x2
    node_x1 = x1 + (x1 - x2)

    if y1 < y2
      node_y1 = y1 - (y2 - y1)
    elsif y1 > y2
      node_y1 = y1 + (y1 - y2)
    else
      node_y1 = y1
    end
  else
    node_x1 = x1

    if y1 < y2
      node_y1 = y2 + (y2 - y1)
    elsif y1 > y2
      node_y1 = y1 + (y1 - y2)
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
