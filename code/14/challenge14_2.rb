@robots = []

File.readlines('input14', chomp: true).each do |line|
  matched = line.match(/p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)/)
  @robots << {
    coords: [matched[1].to_i, matched[2].to_i],
    velocity: [matched[3].to_i, matched[4].to_i]
  }
end
# 7857 too low
# 7858

BOUNDARIES = { x: 101, y: 103 }

def move_robot(robot)
  robot[:coords][0] = move_x(robot[:coords][0], robot[:velocity][0])
  robot[:coords][1] = move_y(robot[:coords][1], robot[:velocity][1])
end

def move_x(x, velocity)
  x_new = x + velocity

  if x_new < 0
    return BOUNDARIES[:x] + x_new
  elsif x_new >= BOUNDARIES[:x]
    return x_new - BOUNDARIES[:x]
  end

  x_new
end

def move_y(y, velocity)
  y_new = y + velocity

  if y_new < 0
    return BOUNDARIES[:y] + y_new
  elsif y_new >= BOUNDARIES[:y]
    return y_new - BOUNDARIES[:y]
  end

  y_new
end

# 29
# 132
# 235
#
# + 103

@frame = 29

def draw_map(file, j, i)
  n = j * 1000 + i
  return if n != @frame

  @frame += 103

  file << "i: #{n + 1} #{'-' * 100}\n"
  map = Array.new(BOUNDARIES[:y]) { Array.new(BOUNDARIES[:x], '.') }

  @robots.each do |robot|
    map[robot[:coords][1]][robot[:coords][0]] = '#'
  end

  map.each do |line|
    file << line.join('') + "\n"
  end
end

10.times do |j|
  File.open("output14_#{j}", 'w') do |file|
    1000.times do |i|
      @robots.each do |robot|
        move_robot(robot)
      end

      draw_map(file, j, i)
    end
  end
end
