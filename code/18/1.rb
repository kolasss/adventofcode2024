@bytes = []

File.readlines('input', chomp: true).each do |line|
  @bytes << line.split(',').map(&:to_i)
end
# 316

BOUNDARIES = 71
BYTES_COUNT = 1024

# input1 = %(5,4
# 4,2
# 4,5
# 3,0
# 2,1
# 6,3
# 2,4
# 1,5
# 0,6
# 3,3
# 2,6
# 5,1
# 1,2
# 5,5
# 2,5
# 6,5
# 1,4
# 0,4
# 6,4
# 1,1
# 6,1
# 1,0
# 0,5
# 1,6
# 2,0)
# # 22

# input1.split("\n").map do |line|
#   @bytes << line.split(',').map(&:to_i)
# end

# BOUNDARIES = 7
# BYTES_COUNT = 12

DIRECTIONS = [
  [0, 1],
  [1, 0],
  [0, -1],
  [-1, 0]
]

@bytes_active = @bytes[0, BYTES_COUNT]

def find_children_nodes(node)
  DIRECTIONS.each do |direction|
    x_new = node[0] + direction[0]
    y_new = node[1] + direction[1]

    next unless coords_in_map?(x_new, y_new)
    next if @bytes_active.include?([x_new, y_new])

    score_direction = @map.dig(node[1], node[0]) + 1

    score_cached = @map.dig(y_new, x_new)
    next if score_cached && score_cached <= score_direction

    @map[y_new][x_new] = score_direction

    @nodes_queue << [x_new, y_new]
  end
end

def coords_in_map?(x, y)
  x >= 0 && x < BOUNDARIES && y >= 0 && y < BOUNDARIES
end

# def draw_map
#   @map.each_with_index do |row, y|
#     puts row.each_with_index.map { |cell, x|
#       next '##' if @bytes_active.include?([x, y])

#       cell ? format('%02d', cell) : '..'
#     }.join('|')
#     puts '-' * (BOUNDARIES * 3)
#   end
# end

@map = Array.new(BOUNDARIES) { Array.new(BOUNDARIES) }

start = [0, 0]
@map[start[1]][start[0]] = 0

@nodes_queue = [start]

while @nodes_queue.any?
  @nodes_queue.sort_by! { |node| @map.dig(node[1], node[0]) }
  node = @nodes_queue.shift
  find_children_nodes(node)
end

# draw_map

p @map.dig(BOUNDARIES - 1, BOUNDARIES - 1)
