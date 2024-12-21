MAP = []

File.readlines('input12', chomp: true).each do |line|
  MAP << line.split('')
end
# 1467094

# input1 = %{AAAA
# BBCD
# BBCC
# EEEC}
# # 140

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
# # 1930

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
  subregion[:coord] << [x, y]

  region = MAP[y][x]

  DIRECTIONS.each do |(dx, dy)|
    x1 = x + dx
    y1 = y + dy

    if coords_in_map(x1, y1)
      region_neighbor = MAP[y1][x1]
      subregion[:fences] += 1 if region_neighbor != region
    else
      subregion[:fences] += 1
    end
  end
end

def find_or_create_subregion(x, y)
  region = MAP[y][x]
  @info[region] ||= []

  subregion = find_subregion(x, y, @info[region])

  unless subregion
    subregion = { coord: [], size: 0, fences: 0 }
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
  (coords_neighbors(x, y) & subregion[:coord]).any?
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
    subregion_first[:coord].push(*subregion2[:coord])
    subregion_first[:size] += subregion2[:size]
    subregion_first[:fences] += subregion2[:fences]
    info_region.delete(subregion2)
  end
  subregion_first
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
    sum += subregion[:size] * subregion[:fences]
  end
end

p "sum: #{sum}"
