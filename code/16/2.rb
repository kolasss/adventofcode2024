# алгоритм дейкстры
# проходим от начала
# потом от конца, помечаем все клетки сумма которых, за первый и второй проходы, равна
# найденной минимальной за первый проход
@map = []

File.readlines('input', chomp: true).each do |line|
  @map << line.chars.map(&:to_sym)
end
# 469 too low
# 486

# input1 = %(###############
# #.......#....E#
# #.#.###.#.###.#
# #.....#.#...#.#
# #.###.#####.#.#
# #.#.#.......#.#
# #.#.#####.###.#
# #...........#.#
# ###.#.#####.#.#
# #...#.....#.#.#
# #.#.#.###.#.#.#
# #.....#...#.#.#
# #.###.#.#.#.#.#
# #S..#.....#...#
# ###############)
# # 45

# input1 = %(#####
# #.E.#
# #.#.#
# #S..#
# #####)
# # 2003

# input1 = %(#################
# #...#...#...#..E#
# #.#.#.#.#.#.#.#.#
# #.#.#.#...#...#.#
# #.#.#.#.###.#.#.#
# #...#.#.#.....#.#
# #.#.#.#.#.#####.#
# #.#...#.#.#.....#
# #.#.#####.#.###.#
# #.#.#.......#...#
# #.#.###.#####.###
# #.#.#...#.....#.#
# #.#.#.#####.###.#
# #.#.#.........#.#
# #.#.#.#########.#
# #S#.............#
# #################)
# # 64

# input1.split("\n").map do |line|
#   @map << line.chars.map(&:to_sym)
# end

def find_start
  @map.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      return [x, y] if cell == :S
    end
  end
end

class Node
  attr_accessor :direction, :score, :best
  attr_reader :x, :y

  def initialize(x, y, direction, score)
    @x = x
    @y = y
    @direction = direction
    @score = score
    @best = false
  end
end

DIRECTIONS = {
  top: [0, -1],
  bot: [0, 1],
  left: [-1, 0],
  right: [1, 0]
}

DIRECITONS_NEXT = {
  top: %i[top left right],
  bot: %i[bot left right],
  left: %i[left top bot],
  right: %i[right top bot]
}

DIRECTIONS_OPPOSITE = {
  top: :bot,
  bot: :top,
  left: :right,
  right: :left
}

def find_children_nodes(node)
  DIRECITONS_NEXT[node.direction].each do |direction|
    vector = DIRECTIONS[direction]
    x_new = node.x + vector[0]
    y_new = node.y + vector[1]

    next if @map[y_new][x_new] == :'#'

    score_direction = calculate_next_score(node.score, node.direction, direction)

    node_cached = @map_nodes.dig(x_new, y_new)

    if node_cached
      next if node_cached.score < score_direction

      new_node = node_cached
      new_node.score = score_direction
      new_node.direction = direction
    else
      new_node = Node.new(x_new, y_new, direction, score_direction)
      @map_nodes[x_new] ||= {}
      @map_nodes[x_new][y_new] = new_node
    end

    if @map[y_new][x_new] == :E
      new_node.best = true
      @end_coords = [x_new, y_new]
      @end_directions << direction
    end

    @nodes_queue << new_node
  end
end

def calculate_next_score(score, direction_start, direction_new)
  direction_start == direction_new ? score + 1 : score + 1001
end

def find_children_nodes_reverse(node_hash)
  DIRECITONS_NEXT[node_hash[:direction]].each do |direction|
    vector = DIRECTIONS[direction]
    x_new = node_hash[:node].x + vector[0]
    y_new = node_hash[:node].y + vector[1]

    next if @map[y_new][x_new] == :'#'

    score_direction = calculate_next_score(node_hash[:score], node_hash[:direction], direction)

    node_cached_reversed = @map_nodes_reversed.dig(x_new, y_new)

    if node_cached_reversed
      new_node = node_cached_reversed
      new_node.score = score_direction
      new_node.direction = direction
    else
      new_node = Node.new(x_new, y_new, direction, score_direction)
      @map_nodes_reversed[x_new] ||= {}
      @map_nodes_reversed[x_new][y_new] = new_node
    end

    node_cached = @map_nodes.dig(x_new, y_new)
    direction_opposite = DIRECTIONS_OPPOSITE[direction]
    # если должен быть поворот то добавляем бонус 1000
    bonus = node_cached.direction == direction_opposite ? 0 : 1000
    next if node_cached.score + score_direction + bonus > @min_route_score

    node_cached.best = true if node_cached.score + score_direction + bonus == @min_route_score

    @nodes_queue << {
      node: new_node,
      direction: direction,
      score: score_direction
    }
  end
end

# def draw_map_with_best
#   @map_nodes.each_value do |column|
#     column.each_value do |node|
#       next unless node.best

#       @map[node.y][node.x] = :O
#     end
#   end

#   @map.each do |row|
#     puts row.join
#   end
# end

def best_sum
  sum = 0
  @map_nodes.each_value do |column|
    column.each_value do |node|
      sum += 1 if node.best
    end
  end
  sum
end

@start = find_start
start_direction = :right

start_node = Node.new(@start[0], @start[1], start_direction, 0)
@map_nodes = { start_node.x => { start_node.y => start_node } }

@end_coords = []
@end_directions = []

@nodes_queue = [start_node]

while @nodes_queue.any?
  @nodes_queue.sort_by!(&:score)
  node = @nodes_queue.shift
  find_children_nodes(node)
end

@min_route_score = @map_nodes.dig(@end_coords[0], @end_coords[1]).score
p "min_route_score: #{@min_route_score}"

start_node = @map_nodes.dig(@end_coords[0], @end_coords[1]).dup
start_node.score = 0
@map_nodes_reversed = { start_node.x => { start_node.y => start_node } }

@nodes_queue = []
@end_directions.each do |direction|
  @nodes_queue << {
    node: start_node,
    direction: DIRECTIONS_OPPOSITE[direction],
    score: 0
  }
end

while @nodes_queue.any?
  @nodes_queue.sort_by! { |node_q| node_q[:score] }
  node = @nodes_queue.shift
  find_children_nodes_reverse(node)
end

# draw_map_with_best

p "best_sum: #{best_sum}"
