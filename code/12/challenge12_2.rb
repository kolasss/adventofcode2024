MAP = []

File.readlines('input12', chomp: true).each do |line|
  MAP << line.split('')
end
# 881182

# input1 = %{AAAA
# BBCD
# BBCC
# EEEC}
# # 80

# input1 = %{OOOOO
# OXOXO
# OOOOO
# OXOXO
# OOOOO}
# # 436

# input1 = %{EEEEE
# EXXXX
# EEEEE
# EXXXX
# EEEEE}
# # 236

# input1 = %{AAAAAA
# AAABBA
# AAABBA
# ABBAAA
# ABBAAA
# AAAAAA}
# # 368

# input1 = %{RRRRIICCFF
# RRRRIICCCF
# VVRRRCCFFF
# VVRCCCJFFF
# VVVVCJJCFE
# VVIVCCJJEE
# VVIIICJJEE
# MIIIIIJJEE
# MIIISIJEEE
# MMMISSJEEE}
# # 1206

# MAP = input1.split("\n").map do |line|
#   line.split('')
# end

BOUNDARIES = { x: MAP.first.size, y: MAP.size }

DIRECTIONS = [
  [0, 1],
  [1, 0],
  [0, -1],
  [-1, 0]
]

def collect_info(x, y)
  subregion = find_or_create_subregion(x, y)
  subregion[:size] += 1
  subregion[:coords] << [x, y]

  # region = MAP[y][x]

  # DIRECTIONS.each do |(dx, dy)|
  #   x1 = x + dx
  #   y1 = y + dy

  #   if coords_in_map(x1, y1)
  #     region_neighbor = MAP[y1][x1]
  #     subregion[:fences] += 1 if region_neighbor != region
  #   else
  #     subregion[:fences] += 1
  #   end
  # end
end

def find_or_create_subregion(x, y)
  region = MAP[y][x]
  @info[region] ||= []

  subregion = find_subregion(x, y, @info[region])

  unless subregion
    subregion = { coords: [], size: 0, fences: 0 }
    @info[region] << subregion
  end

  subregion
end

def find_subregion(x, y, info_region)
  subregions_near = []

  info_region.each do |subregion|
    subregions_near << subregion if subregion_near?(x, y, subregion)
  end

  return nil if subregions_near.empty?
  return subregions_near.first if subregions_near.size == 1

  unite_subregions(info_region, subregions_near)
end

def subregion_near?(x, y, subregion)
  (coords_neighbors(x, y) & subregion[:coords]).any?
end

def coords_neighbors(x, y)
  neighbors = []

  DIRECTIONS.each do |(dx, dy)|
    x1 = x + dx
    y1 = y + dy

    neighbors << [x1, y1] if coords_in_map(x1, y1)
  end

  neighbors
end

def coords_in_map(x, y)
  x >= 0 && x < BOUNDARIES[:x] && y >= 0 && y < BOUNDARIES[:y]
end

def unite_subregions(info_region, subregions_near)
  subregion_first = subregions_near.shift
  subregions_near.each do |subregion2|
    subregion_first[:coords].push(*subregion2[:coords])
    subregion_first[:size] += subregion2[:size]
    # subregion_first[:fences] += subregion2[:fences]
    info_region.delete(subregion2)
  end
  subregion_first
end

def count_sides(subregion)
  counted = {}

  sides = 0

  subregion[:coords].each do |(x, y)|
    sides += 1 if count_top(x, y, subregion[:coords], counted)
    sides += 1 if count_bottom(x, y, subregion[:coords], counted)
    sides += 1 if count_right(x, y, subregion[:coords], counted)
    sides += 1 if count_left(x, y, subregion[:coords], counted)
  end

  sides
end

def count_top(x, y, coords, counted)
  return if counted.dig([x, y], :top)

  y_border = y - 1
  return if coords.include?([x, y_border])

  counted[[x, y]] ||= {}
  counted[[x, y]][:top] = true

  # count to left side
  x1 = x - 1
  while coords.include?([x1, y]) && !coords.include?([x1, y_border])
    counted[[x1, y]] ||= {}
    counted[[x1, y]][:top] = true
    x1 -= 1
  end

  # continue to right side
  x1 = x + 1
  while coords.include?([x1, y]) && !coords.include?([x1, y_border])
    counted[[x1, y]] ||= {}
    counted[[x1, y]][:top] = true
    x1 += 1
  end

  true
end

def count_bottom(x, y, coords, counted)
  return if counted.dig([x, y], :bottom)

  y_border = y + 1
  return if coords.include?([x, y_border])

  counted[[x, y]] ||= {}
  counted[[x, y]][:bottom] = true

  # count to left side
  x1 = x - 1
  while coords.include?([x1, y]) && !coords.include?([x1, y_border])
    counted[[x1, y]] ||= {}
    counted[[x1, y]][:bottom] = true
    x1 -= 1
  end

  # continue to right side
  x1 = x + 1
  while coords.include?([x1, y]) && !coords.include?([x1, y_border])
    counted[[x1, y]] ||= {}
    counted[[x1, y]][:bottom] = true
    x1 += 1
  end

  true
end

def count_right(x, y, coords, counted)
  return if counted.dig([x, y], :right)

  x_border = x + 1
  return if coords.include?([x_border, y])

  counted[[x, y]] ||= {}
  counted[[x, y]][:right] = true

  # count to up side
  y1 = y - 1
  while coords.include?([x, y1]) && !coords.include?([x_border, y1])
    counted[[x, y1]] ||= {}
    counted[[x, y1]][:right] = true
    y1 -= 1
  end

  # continue to bottom side
  y1 = y + 1
  while coords.include?([x, y1]) && !coords.include?([x_border, y1])
    counted[[x, y1]] ||= {}
    counted[[x, y1]][:right] = true
    y1 += 1
  end

  true
end

def count_left(x, y, coords, counted)
  return if counted.dig([x, y], :left)

  x_border = x - 1
  return if coords.include?([x_border, y])

  counted[[x, y]] ||= {}
  counted[[x, y]][:left] = true

  # count to up side
  y1 = y - 1
  while coords.include?([x, y1]) && !coords.include?([x_border, y1])
    counted[[x, y1]] ||= {}
    counted[[x, y1]][:left] = true
    y1 -= 1
  end

  # continue to bottom side
  y1 = y + 1
  while coords.include?([x, y1]) && !coords.include?([x_border, y1])
    counted[[x, y1]] ||= {}
    counted[[x, y1]][:left] = true
    y1 += 1
  end

  true
end

@info = {}

MAP.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    collect_info(x, y)
  end
end

# pp @info

sum = 0

@info.values.each do |info_region|
  info_region.each do |subregion|
    sum += subregion[:size] * count_sides(subregion)
  end
end

p "sum: #{sum}"
