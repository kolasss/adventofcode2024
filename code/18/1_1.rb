# оптимизированный вариант 1 задачи для ускорения решения второй задачи
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

@bytes_active = {}
@bytes[0, BYTES_COUNT].each do |byte|
  @bytes_active[byte[0]] ||= {}
  @bytes_active[byte[0]][byte[1]] = true
end

def find_children_nodes(node_coords)
  # p "node_coords: #{node_coords}"
  direction_score = @map.dig(node_coords[1], node_coords[0]) + 1

  DIRECTIONS.each do |direction|
    x_new = node_coords[0] + direction[0]
    y_new = node_coords[1] + direction[1]

    next unless coords_in_map?(x_new, y_new)
    next if @bytes_active.dig(x_new, y_new)

    score_cached = @map.dig(y_new, x_new)

    if score_cached
      next if score_cached <= direction_score
    else
      @node_routes[y_new][x_new] = {}
    end
    @map[y_new][x_new] = direction_score

    @node_routes[y_new][x_new].merge!(
      @node_routes.dig(node_coords[1], node_coords[0]),
      { x_new => { y_new => true } }
    ) do |_key, old_value, new_value|
      old_value.merge(new_value)
    end

    @nodes_queue << [x_new, y_new]
  end
end

def coords_in_map?(x, y)
  x >= 0 && x < BOUNDARIES && y >= 0 && y < BOUNDARIES
end

# def draw_map
#   @map.each_with_index do |row, y|
#     puts row.each_with_index.map { |node, x|
#       next '##' if @bytes_active.dig(x, y)

#       node&.score ? format('%02d', node.score) : '..'
#     }.join('|')
#     puts '-' * (BOUNDARIES * 3)
#   end
# end

@map = Array.new(BOUNDARIES) { Array.new(BOUNDARIES) }
@node_routes = Array.new(BOUNDARIES) { Array.new(BOUNDARIES) }
# draw_map

start = [0, 0]
@map[0][0] = 0
@node_routes[0][0] = { 0 => { 0 => true } }

@nodes_queue = [start]

while @nodes_queue.any?
  @nodes_queue.sort_by! { |node_coords| @map.dig(node_coords[1], node_coords[0]) }
  node_coords = @nodes_queue.shift
  find_children_nodes(node_coords)
end

# draw_map
# p '*' * 80

node_finish = @map.dig(BOUNDARIES - 1, BOUNDARIES - 1)
# p "routes: #{@node_routes.dig(BOUNDARIES - 1, BOUNDARIES - 1)}"
p "score: #{node_finish}"
