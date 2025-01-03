# frozen_string_literal: true

STONES = File.read('input11').split.map(&:to_i)
# 220999

# input1 = %(125 17)
# # 55312

# STONES = input1.split.map(&:to_i)

def blink(stones)
  stones_new = []

  stones.each do |stone|
    stones_new.push(*calculate_next_stones(stone))
  end

  stones_new
end

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

stones = STONES

25.times do
  stones = blink(stones)
end

p stones.size
