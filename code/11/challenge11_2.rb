# STONES = File.read('input11').split(' ').map(&:to_i)

# input1 = %{125 17}
# 6 22
# 25 55312

input1 = %{125}
# # 6 7
# # 25 19025

# input1 = %{17}
# # 6 15
# # 25 36287

STONES = input1.split(' ').map(&:to_i)

@cache = {
  0 => { 1 => [1]},
  1 => { 1 => [2024] },
  2024 => { 1 => [20, 24] },
}

def stone_in_blinks(stone, steps, previous_steps = [])
# def stone_in_blinks(stone, steps)
  # p "stone: #{stone}, steps: #{steps}"
  cached = @cache.dig(stone, steps)
  return cached if cached

  @cache[stone] ||= {}

  if steps == 1
    stones_new = calculate_next_stones(stone)
    # update_cache(previous_steps, stones_new, steps)
  else
    # cached_key_max = @cache[stone].keys.max
    cached_key_max = @cache[stone].keys.select { _1 < steps }.max

    if cached_key_max
      stones_mid = @cache.dig(stone, cached_key_max)
      steps_next = steps - cached_key_max
      # p "stone: #{stone} - cached_key_max: #{cached_key_max}"
    else
      stones_mid = stone_in_blinks(stone, 1)
      steps_next = steps - 1
    end

    stones_new = []

    stones_mid.each do |stone_mid|
      # stones_new.push(*stone_in_blinks(
      #   stone_mid, steps_next, previous_steps + [{ stone: stone, steps: steps }]
      # ))
      stones_new.push(*stone_in_blinks(
        stone_mid, steps_next, [stone] + previous_steps
      ))
      # stones_new.push(*stone_in_blinks(stone_mid, steps_next))
    end

    # update_cache(previous_steps, stones_new, steps_next)
  end


  # update_cache(previous_steps, stones_new, steps)
  @cache[stone][steps] = stones_new
  # p @cache
  # p "stone: #{stone} steps: #{steps} stones_new: #{stones_new}"
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

def update_cache(previous_steps, stones_new, step_current)
  # p "previous_steps: #{previous_steps}"
  # p "step_current: #{step_current} - stones_new: #{stones_new}"

  previous_steps.each_with_index do |stone_prev, index|
    step = step_current + 1 + index
    # p "stone_prev: #{stone_prev} - step: #{step}"
    @cache[stone_prev][step] ||= []
    @cache[stone_prev][step].push(*stones_new)
  end
end

size = 0
steps = 6

STONES.each do |stone|
  size += stone_in_blinks(stone, steps).size
end

p @cache[125]&.keys
pp @cache
# binding.irb
p "steps: #{steps} - size: #{size}"

# size = 0
# steps = 25

# STONES.each do |stone|
#   size += stone_in_blinks(stone, steps).size
# end

# p @cache[125]&.keys
# p "steps: #{steps} - size: #{size}"

# size = 0
# steps = 75

# STONES.each do |stone|
#   size += stone_in_blinks(stone, steps).size
# end

# p "steps: #{steps} - size: #{size}"
