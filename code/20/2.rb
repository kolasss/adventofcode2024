# frozen_string_literal: true

@map = []

File.readlines('input', chomp: true).each do |line|
  @map << line.chars.map(&:to_sym)
end
# 987695

DIFF_MIN = 100

# input1 = %(###############
# #...#...#.....#
# #.#.#.#.#.###.#
# #S#...#.#.#...#
# #######.#.#.###
# #######.#.#...#
# #######.#.###.#
# ###..E#...#...#
# ###.#######.###
# #...###...#...#
# #.#####.#.###.#
# #.#...#.#.#...#
# #.#.#.#.#.#.###
# #...#...#...###
# ###############)
# # 285

# input1.split("\n").map do |line|
#   @map << line.chars.map(&:to_sym)
# end

# DIFF_MIN = 50

BOUNDARIES_CHEAT = { x: @map.first.size - 1, y: @map.size - 1 }.freeze

DIRECTIONS = [
  [0, 1],
  [1, 0],
  [0, -1],
  [-1, 0]
].freeze

def find_start
  @map.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      return [x, y] if cell == :S
    end
  end
end

def find_children_nodes(node_coords)
  direction_score = @map_nodes.dig(*node_coords) + 1

  DIRECTIONS.each do |direction|
    x_new = node_coords[0] + direction[0]
    y_new = node_coords[1] + direction[1]

    next if @map[y_new][x_new] == :'#'

    score_cached = @map_nodes.dig(x_new, y_new)

    next if score_cached && score_cached <= direction_score

    @map_nodes[x_new] ||= {}
    @map_nodes[x_new][y_new] = direction_score

    @end_coords = [x_new, y_new] if @map[y_new][x_new] == :E
    @nodes_queue << [x_new, y_new]
    break
  end
end

DIRECTIONS_CHEAT = (0..20).map do |i|
  (0..(20 - i)).map do |j|
    [[i, j], [-i, j], [i, -j], [-i, -j]]
  end
end.flatten(2).select { (_1[0].abs + _1[1].abs) > 1 }.uniq

def find_shortcuts(node_coords, node_score)
  DIRECTIONS_CHEAT.each do |direction|
    x_new = node_coords[0] + direction[0]
    y_new = node_coords[1] + direction[1]

    next unless coords_in_map?(x_new, y_new)

    score_cached = @map_nodes.dig(x_new, y_new)
    next unless score_cached

    diff = score_cached - node_score - direction[0].abs - direction[1].abs
    next if diff < DIFF_MIN

    @shortcuts[diff] ||= 0
    @shortcuts[diff] += 1
  end
end

def coords_in_map?(x, y)
  x.positive? && x < BOUNDARIES_CHEAT[:x] && y.positive? && y < BOUNDARIES_CHEAT[:y]
end

start_coords = find_start
@map_nodes = { start_coords[0] => { start_coords[1] => 0 } }
@end_coords = nil

@nodes_queue = [start_coords]

while @nodes_queue.any?
  @nodes_queue.sort_by! { |coords| @map.dig(*coords) }
  node = @nodes_queue.shift
  find_children_nodes(node)
end

# p "end_coords: #{@end_coords} score: #{@map_nodes.dig(*@end_coords)}"

@shortcuts = {}

@map_nodes.each do |x, column|
  column.each do |y, score|
    find_shortcuts([x, y], score)
  end
end

# @shortcuts.keys.sort.each { |key| p "#{key}: #{@shortcuts[key]}" }

p @shortcuts.values.sum
