@map = []
@moves = []
map_loaded = false

File.readlines('input15', chomp: true).each do |line|
  if map_loaded
    @moves.push(*line.chars.map(&:to_sym))
  else
    arr = line.chars.map(&:to_sym)
    if arr.empty?
      map_loaded = true
    else
      @map << arr
    end
  end
end
# 1463715

# input1 = %(##########
# #..O..O.O#
# #......O.#
# #.OO..O.O#
# #..O@..O.#
# #O#..O...#
# #O..O..O.#
# #.OO.O.OO#
# #....O...#
# ##########

# <vv>^<v^>v>^vv^v>v<>v^v<v<^vv<<<^><<><>>v<vvv<>^v^>^<<<><<v<<<v^vv^v>^
# vvv<<^>^v^^><<>>><>^<<><^vv^^<>vvv<>><^^v>^>vv<>v<<<<v<^v>^<^^>>>^<v<v
# ><>vv>v^v^<>><>>>><^^>vv>v<^^^>>v^v^<^^>v^^>v^<^v>v<>>v^v^<v>v^^<^^vv<
# <<v<^>>^^^^>>>v^<>vvv^><v<<<>^^^vv^<vvv>^>v<^^^^v<>^>vvvv><>>v^<<^^^^^
# ^><^><>>><>^^<<^^v>>><^<v>^<vv>>v>>>^v><>^v><<<<v>>v<v<v>vvv>^<><<>^><
# ^>><>^v<><^vvv<^^<><v<<<<<><^v<<<><<<^^<v<^^^><^>>^<v^><<<^>>^v<v^v<v^
# >^>>^v>vv>^<<^v<>><<><<v<<v><>v<^vv<<<>^^v^>^^>>><<^v>>v^v><^^>>^<>vv^
# <><^^>^^^<><vvvvv^v<v<<>^v<v>v<<^><<><<><<<^^<<<^<<>><<><^^^>^^<>^>v<>
# ^^>vv<^v^v<vv>^<><v<^v>^^^>>>^^vvv^>vvv<>>>^<^>>>>>^<<^v>^vvv<>^<><<v>
# v^^>>><<^^<>>^v^<v^vv<>v^<<>^<^v^v><^<<<><<^<v><v<>vv>>v><v^<vv<>v^<<^)
# # 10092

# input1 = %(########
# #..O.O.#
# ##@.O..#
# #...O..#
# #.#.O..#
# #...O..#
# #......#
# ########

# <^^>>>vv<v>>v<<)
# # 2028

# input1.split("\n").map do |line|
#   if map_loaded
#     @moves.push(*line.split('').map(&:to_sym))
#   else
#     arr = line.split('').map(&:to_sym)
#     if arr.empty?
#       map_loaded = true
#     else
#       @map << arr
#     end
#   end
# end

def find_robot
  @map.each_with_index do |row, y|
    row.each_with_index do |cell, x|
      return [x, y] if cell == :'@'
    end
  end
end

DIRECTIONS = {
  '^': [0, -1],
  v: [0, 1],
  '<': [-1, 0],
  '>': [1, 0]
}

def process(move)
  direction = DIRECTIONS[move]
  x_new = @robot[0] + direction[0]
  y_new = @robot[1] + direction[1]

  case @map[y_new][x_new]
  when :'.'
    move_robot_to(x_new, y_new)
  when :O
    move_boxes(x_new, y_new, direction)
  end
end

def move_robot_to(x, y)
  @map[y][x] = :'@'
  @map[@robot[1]][@robot[0]] = :'.'
  @robot = [x, y]
end

def move_boxes(x, y, direction)
  x_next = x + direction[0]
  y_next = y + direction[1]

  loop do
    # p "x_next: #{x_next}, y_next: #{y_next}"
    # p @map[y_next][x_next]
    case @map[y_next][x_next]
    when :'.'
      @map[y_next][x_next] = :O
      move_robot_to(x, y)
      return
    when :'#'
      return
    when :O
      x_next += direction[0]
      y_next += direction[1]
    end
  end
end

def calculate_gps(x, y)
  (100 * y) + x
end

# def draw_map
#   @map.each do |row|
#     puts row.join('')
#   end
# end

@robot = find_robot

# draw_map
@moves.each do |move|
  # p "Move: #{move}"
  process(move)
  # draw_map
end

# p @robot

sum = 0

@map.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    sum += calculate_gps(x, y) if cell == :O
  end
end

p "Sum: #{sum}"
