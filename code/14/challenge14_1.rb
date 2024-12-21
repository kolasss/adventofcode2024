@robots = []

File.readlines('input14', chomp: true).each do |line|
  matched = line.match(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/)
  @robots << {
    coords: [matched[1].to_i, matched[2].to_i],
    velocity: [matched[3].to_i, matched[4].to_i]
  }
end
# 221655456

BOUNDARIES = { x: 101, y: 103 }

# input1 = %(p=0,4 v=3,-3
# p=6,3 v=-1,-3
# p=10,3 v=-1,2
# p=2,0 v=2,-1
# p=0,0 v=1,3
# p=3,0 v=-2,-2
# p=7,6 v=-1,-3
# p=3,0 v=-1,-2
# p=9,3 v=2,3
# p=7,3 v=-1,2
# p=2,4 v=2,-3
# p=9,5 v=-3,-3)
# # 12

# @robots = input1.split("\n").map do |line|
#   matched = line.match(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/)
#   {
#     coords: [matched[1].to_i, matched[2].to_i],
#     velocity: [matched[3].to_i, matched[4].to_i]
#   }
# end

# BOUNDARIES = { x: 11, y: 7 }

def move_robot(robot)
  robot[:coords][0] = move_x(robot[:coords][0], robot[:velocity][0])
  robot[:coords][1] = move_y(robot[:coords][1], robot[:velocity][1])
end

def move_x(x, velocity)
  x_new = (x + (100 * velocity)) % BOUNDARIES[:x]

  if x_new < 0
    x_new = BOUNDARIES[:x] + x_new
  end

  x_new
end

def move_y(y, velocity)
  y_new = (y + (100 * velocity)) % BOUNDARIES[:y]

  if y_new < 0
    y_new = BOUNDARIES[:y] + y_new
  end

  y_new
end

# def move_x(x, velocity)
#   x_new = x + velocity

#   if x_new < 0
#     return BOUNDARIES[:x] + x_new
#   elsif x_new >= BOUNDARIES[:x]
#     return x_new - BOUNDARIES[:x]
#   end
#   x_new
# end

# def move_y(y, velocity)
#   y_new = y + velocity

#   if y_new < 0
#     return BOUNDARIES[:y] + y_new
#   elsif y_new >= BOUNDARIES[:y]
#     return y_new - BOUNDARIES[:y]
#   end
#   y_new
# end

@robots.each do |robot|
  move_robot(robot)
end

# p @robots[0]

# 100.times do
#   @robots.each do |robot|
#     move_robot(robot)
#   end
#   # move_robot(@robots[0])
#   # p @robots[0][:coords]
# end

QUADRANTS = {
  1 => {
    x: (0...(BOUNDARIES[:x] / 2)),
    y: (0...(BOUNDARIES[:y] / 2)) },
  2 => {
    x: (((BOUNDARIES[:x] / 2) + 1)...BOUNDARIES[:x]),
    y: (0...(BOUNDARIES[:y] / 2))
  },
  3 => {
    x: (0...(BOUNDARIES[:x] / 2)),
    y: (((BOUNDARIES[:y] / 2) + 1)...BOUNDARIES[:y])
  },
  4 => {
    x: (((BOUNDARIES[:x] / 2) + 1)...BOUNDARIES[:x]),
    y: (((BOUNDARIES[:y] / 2) + 1)...BOUNDARIES[:y])
  }
}

quadrant_count = QUADRANTS.each_value.map do |quadrant|
  @robots.count do |robot|
    quadrant[:x].include?(robot[:coords][0]) && quadrant[:y].include?(robot[:coords][1])
  end
end

p "factor: #{quadrant_count.reduce(:*)}"
