# frozen_string_literal: true

STONES = File.read('input11').split.map(&:to_i)
# 25 220999
# 75 261936432123724

# input1 = %(125 17)
# # 6 22
# # 25 55312

# STONES = input1.split.map(&:to_i)

def calculate_next_stones(stone)
  if stone.zero?
    [1]
  elsif stone.to_s.length.even?
    string = stone.to_s
    length_half = string.length / 2
    [string[0, length_half].to_i, string[length_half, length_half].to_i]
  else
    [stone * 2024]
  end
end

@cache = {}

def calculate_stones_quantity(stone, blink)
  cached = @cache.dig(stone, blink)
  return cached if cached

  stones_new = calculate_next_stones(stone)

  if blink == @max_blink
    sum = stones_new.size
  else
    sum = 0
    stones_new.each do |stone_new|
      sum += calculate_stones_quantity(stone_new, blink + 1)
    end
  end

  @cache[stone] ||= {}
  @cache[stone][blink] = sum

  sum
end

sum = 0
@max_blink = 75

STONES.each do |stone|
  sum += calculate_stones_quantity(stone, 1)
end

p "sum: #{sum}"
# p "cache size: #{@cache.size}"
