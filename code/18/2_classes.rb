# рабочее решение на классах, чуть-чуть медленне решения на хэшах
# классы 0.89s - хэши 0.83s
@bytes = []

File.readlines('input', chomp: true).each do |line|
  @bytes << line.split(',').map(&:to_i)
end
# 45,18

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
# # 6,1

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

class Node
  attr_accessor :score, :routes

  def initialize
    @routes = {}
    # @routes = []
  end
end

def find_children_nodes(node_coords)
  node = @map.dig(node_coords[1], node_coords[0])

  DIRECTIONS.each do |direction|
    x_new = node_coords[0] + direction[0]
    y_new = node_coords[1] + direction[1]

    next unless coords_in_map?(x_new, y_new)
    next if @bytes_active.dig(x_new, y_new)

    score_direction = node.score + 1

    node_direction = @map.dig(y_new, x_new)
    next if node_direction.score && node_direction.score <= score_direction

    node_direction.score = score_direction

    node_direction.routes.merge!(
      node.routes, { x_new => { y_new => true } }
    ) do |_key, old_value, new_value|
      old_value.merge(new_value)
    end
    # node_direction.routes.push(*node.routes, [x_new, y_new])

    @nodes_queue << [x_new, y_new]
  end
end

def coords_in_map?(x, y)
  x >= 0 && x < BOUNDARIES && y >= 0 && y < BOUNDARIES
end

def draw_map
  @map.each_with_index do |row, y|
    puts row.each_with_index.map { |node, x|
      next '##' if @bytes_active.dig(x, y)

      node&.score ? format('%02d', node.score) : '..'
    }.join('|')
    puts '-' * (BOUNDARIES * 3)
  end
end

@map = Array.new(BOUNDARIES) { Array.new(BOUNDARIES) { Node.new } }
start = [0, 0]

(BYTES_COUNT...@bytes.size).each do |index|
  byte_new = @bytes[index]
  @bytes_active[byte_new[0]] ||= {}
  @bytes_active[byte_new[0]][byte_new[1]] = true

  node_finish = @map.dig(BOUNDARIES - 1, BOUNDARIES - 1)
  # if node_finish.score && !node_finish.routes.include?([byte_new[0], byte_new[1]])
  if node_finish.score && !node_finish.routes.dig(byte_new[0], byte_new[1])
    # p "skip: #{index}"
    next
  end

  # p "work: #{index}"

  @map = Array.new(BOUNDARIES) { Array.new(BOUNDARIES) { Node.new } }

  node = @map[0][0]
  node.score = 0
  node.routes[0] ||= {}
  node.routes[0][0] = true
  # node.routes << start

  @nodes_queue = [start]

  while @nodes_queue.any?
    @nodes_queue.sort_by! { |node_coords| @map.dig(node_coords[1], node_coords[0]).score }
    node_coords = @nodes_queue.shift
    find_children_nodes(node_coords)
  end

  # draw_map
  # p '*' * 80

  node_finish = @map.dig(BOUNDARIES - 1, BOUNDARIES - 1)
  # p "routes: #{node_finish.routes}"
  next if node_finish.score

  p "index: #{index} byte: #{@bytes[index]}"
  break
end
