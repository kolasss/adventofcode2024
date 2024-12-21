@map = []

File.readlines('input', chomp: true).each do |line|
  @map << line.chars.map(&:to_sym)
end
# 93436

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
# # 7036

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
# # 11048

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
  attr_accessor :direction, :score
  attr_reader :x, :y

  def initialize(x, y, direction, score)
    @x = x
    @y = y
    @direction = direction
    @score = score
  end
end

DIRECTIONS = {
  top: [0, -1],
  bot: [0, 1],
  left: [-1, 0],
  right: [1, 0]
}

def find_children_nodes(node)
  DIRECTIONS.each do |direction, vector|
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
      @end_coords = [x_new, y_new]
      break
    end

    find_children_nodes(new_node)
  end
end

def calculate_next_score(score, direction_start, direction_new)
  direction_start == direction_new ? score + 1 : score + 1001
end

start = find_start
start_direction = :right

start_node = Node.new(start[0], start[1], start_direction, 0)
@map_nodes = { start_node.x => { start_node.y => start_node } }
@end_coords = []

find_children_nodes(start_node)

p @map_nodes.dig(@end_coords[0], @end_coords[1]).score
