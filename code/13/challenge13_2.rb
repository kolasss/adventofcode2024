require 'bigdecimal'

input1 = File.read('input13')
# 75200131617108

# input1 = %(Button A: X+94, Y+34
# Button B: X+22, Y+67
# Prize: X=8400, Y=5400

# Button A: X+26, Y+66
# Button B: X+67, Y+21
# Prize: X=12748, Y=12176

# Button A: X+17, Y+86
# Button B: X+84, Y+37
# Prize: X=7870, Y=6450

# Button A: X+69, Y+23
# Button B: X+27, Y+71
# Prize: X=18641, Y=10279)
# # 875318608908

@machines = []

machine = {}

input1.split("\n").map do |line|
  case line
  when /Button A: X\+(\d+), Y\+(\d+)/
    machine[:a] = {
      x: BigDecimal(Regexp.last_match(1)), y: BigDecimal(Regexp.last_match(2))
    }
  when /Button B: X\+(\d+), Y\+(\d+)/
    machine[:b] = {
      x: BigDecimal(Regexp.last_match(1)), y: BigDecimal(Regexp.last_match(2))
    }
  when /Prize: X=(\d+), Y=(\d+)/
    machine[:prize] = {
      x: BigDecimal(Regexp.last_match(1)) + 10000000000000,
      y: BigDecimal(Regexp.last_match(2)) + 10000000000000
    }
    @machines << machine
    machine = {}
  end
end

# a * xa + b * xb = xp
# a * ya + b * yb = yp

# a = (xp - (b * xb)) / xa
# a = (yp - (b * yb)) / ya

# xp - (b * xb) = ((yp - (b * yb)) * xa) / ya
# b * xb = xp - ((yp - (b * yb)) * xa) / ya
# b * xb = xp - ((yp * xa) / ya) + ((b * yb * xa) / ya)
# b = xp / xb - ((yp * xa) / (ya * xb)) + ((b * yb * xa) / (ya * xb))
# b - ((b * yb * xa) / (ya * xb)) = xp / xb - (yp * xa) / (ya * xb)
# b - ((yb * xa) / (ya * xb)) * b = xp / xb - (yp * xa) / (ya * xb)
# b * (1 - ((yb * xa) / (ya * xb))) = xp / xb - (yp * xa) / (ya * xb)
# b = (xp / xb - (yp * xa) / (ya * xb)) / (1 - ((yb * xa) / (ya * xb)))

# b = (xp - (a * xa)) / xb
# b = (yp - (a * ya)) / yb

# xp - (a * xa) = ((yp - (a * ya)) * xb) / yb
# a * xa = xp - ((yp - (a * ya)) * xb) / yb
# a * xa = xp - ((yp * xb) / yb) + ((a * ya * xb) / yb)
# a = xp / xa - ((yp * xb) / (yb * xa)) + ((a * ya * xb) / (yb * xa))
# a - ((a * ya * xb) / (yb * xa)) = xp / xa - (yp * xb) / (yb * xa)
# a * (1 - ((ya * xb) / (yb * xa))) = xp / xa - (yp * xb) / (yb * xa)
# a = (xp / xa - (yp * xb) / (yb * xa)) / (1 - ((ya * xb) / (yb * xa)))

def calculate_prize(machine)
  # p "machine: #{machine}"
  press_a = calculate_a(machine)
  return unless press_a

  press_b = calculate_b(machine)
  return unless press_b

  # p "press_a: #{press_a}, press_b: #{press_b}"
  3 * press_a + press_b
end

def calculate_a(machine)
  press_a = (machine[:prize][:x] / machine[:a][:x] - (machine[:prize][:y] * machine[:b][:x]) / (machine[:b][:y] * machine[:a][:x])) / (1 - ((machine[:a][:y] * machine[:b][:x]) / (machine[:b][:y] * machine[:a][:x])))
  return if press_a < 0 || press_a.round != press_a.to_f

  press_a.round
end

def calculate_b(machine)
  press_b = (machine[:prize][:x] / machine[:b][:x] - (machine[:prize][:y] * machine[:a][:x]) / (machine[:a][:y] * machine[:b][:x])) / (1 - ((machine[:b][:y] * machine[:a][:x]) / (machine[:a][:y] * machine[:b][:x])))

  return if press_b < 0 || press_b.round != press_b.to_f

  press_b.round
end

sum = 0

@machines.each do |machine|
  prize = calculate_prize(machine)
  sum += prize if prize
end

p "sum: #{sum}"
