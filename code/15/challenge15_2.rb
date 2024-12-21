@map = []
@moves = []
@map_loaded = false

MAP_WIDE = {
  '@': %i[@ .],
  '#': %i[# #],
  '.': %i[. .],
  O: [:'[', :']']
}

def load_line(line)
  if @map_loaded
    @moves.push(*line.chars.map(&:to_sym))
  else
    arr = line.chars.map(&:to_sym)
    if arr.empty?
      @map_loaded = true
    else
      @map << arr.map do |cell|
        MAP_WIDE[cell]
      end.flatten
    end
  end
end

File.readlines('input15', chomp: true).each do |line|
  load_line(line)
end
# 1481392

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
# # 9021

# input1 = %(#######
# #...#.#
# #.....#
# #..OO@#
# #..O..#
# #.....#
# #######

# <vv<<^^<<^^)

# input1.split("\n").map do |line|
#   load_line(line)
# end

# input1 = %(####################
# ##[]..[]......[][]##
# ##[]...........[].##
# ##...........@[][]##
# ##..........[].[].##
# ##..##[]..[].[]...##
# ##...[]...[]..[]..##
# ##.....[]..[].[][]##
# ##........[]......##
# ####################)

# input2 = %(vv)

# input1.split("\n").map do |line|
#   @map << line.split('').map(&:to_sym)
# end

# @moves = input2.split('').map(&:to_sym)

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
  when :'[', :']'
    move_boxes(x_new, y_new, direction)
    # draw_map
  end
end

def move_robot_to(x, y)
  @map[y][x] = :'@'
  @map[@robot[1]][@robot[0]] = :'.'
  @robot = [x, y]
end

def move_boxes(x, y, direction)
  case direction
  when [-1, 0], [1, 0]
    move_boxes_horizontally(x, y, direction)
  else
    move_boxes_vertically(x, y, direction)
  end
end

def move_boxes_horizontally(x, y, direction)
  boxes = [box_coords(x, y)]

  x_next = x + direction[0]
  y_next = y + direction[1]
  loop do
    case @map[y_next][x_next]
    when :'.'
      boxes.uniq!
      boxes.reverse!
      boxes.each do |box|
        move_box(box, direction)
      end
      move_robot_to(x, y)
      return
    when :'#'
      return
    else # :'[', :']'
      boxes << box_coords(x_next, y_next)
      x_next += direction[0]
      y_next += direction[1]
    end
  end
end

def move_boxes_vertically(x, y, direction)
  boxes = [box_coords(x, y)]
  y_next = y + direction[1]
  new_boxes = boxes

  loop do
    x_range = new_boxes.map do |box|
      [box.first.first, box.last.first]
    end.flatten
    cells = x_range.map do |x_next|
      @map[y_next][x_next]
    end
    if cells.any?(:'#')
      return
    elsif cells.all?(:'.')
      boxes.uniq!
      boxes.reverse!
      boxes.each do |box|
        move_box(box, direction)
      end
      move_robot_to(x, y)
      return
    else # :'[', :']'
      new_boxes = []
      x_range.each do |x_next|
        case @map[y_next][x_next]
        when :'[', :']'
          new_boxes << box_coords(x_next, y_next)
        end
      end
      new_boxes.uniq!
      boxes.push(*new_boxes)
      y_next += direction[1]
    end
  end
end

def box_coords(x, y)
  case @map[y][x]
  when :'['
    [[x, y], [x + 1, y]]
  when :']'
    [[x - 1, y], [x, y]]
  end
end

def move_box(box, direction)
  case direction
  when [-1, 0]
    y = box.first.last
    @map[y][box.first.first - 1] = :'['
    @map[y][box.first.first] = :']'
    @map[y][box.last.first] = :'.'
  when [1, 0]
    y = box.first.last
    @map[y][box.last.first + 1] = :']'
    @map[y][box.last.first] = :'['
    @map[y][box.first.first] = :'.'
  when [0, -1]
    @map[box.first.last - 1][box.first.first] = :'['
    @map[box.first.last][box.first.first] = :'.'
    @map[box.last.last - 1][box.last.first] = :']'
    @map[box.last.last][box.last.first] = :'.'
  when [0, 1]
    @map[box.first.last + 1][box.first.first] = :'['
    @map[box.first.last][box.first.first] = :'.'
    @map[box.last.last + 1][box.last.first] = :']'
    @map[box.last.last][box.last.first] = :'.'
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
@moves.each_with_index do |move, i|
  # p "Move: #{move} - #{i}"
  process(move)
  # draw_map
end

sum = 0

@map.each_with_index do |row, y|
  row.each_with_index do |cell, x|
    sum += calculate_gps(x, y) if cell == :'['
  end
end

p "Sum: #{sum}"
