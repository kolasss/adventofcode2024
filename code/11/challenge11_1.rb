STONES = File.read('input11').split(' ').map(&:to_i)

# input1 = %{125 17}

# STONES = input1.split(' ').map(&:to_i)

def blink(stones)
  stones_new = []

  stones.each do |stone|
    # if stone == 0
    #   stones_new << 1
    # elsif stone.to_s.length % 2 == 0
    #   string = stone.to_s
    #   length_half = string.length / 2
    #   stones_new << string[0, length_half].to_i
    #   stones_new << string[length_half, length_half].to_i
    # else
    #   stones_new << stone * 2024
    # end

    stones_new.push(*calculate_next_stones(stone))
  end

  stones_new
end

def calculate_next_stones(stone)
  if stone == 0
    [1]
  elsif stone.to_s.length % 2 == 0
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
