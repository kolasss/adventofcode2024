# frozen_string_literal: true

@numbers = []

File.readlines('input', chomp: true).each do |line|
  @numbers << line.to_i
end
# key: [0, -2, 2, 0], value: 2221

# input1 = %(1
# 2
# 3
# 2024)
# # -2,1,-1,3
# # 23

# # input1 = %(123)

# @numbers = input1.split("\n").map(&:to_i)

def calculate_next_secret_number(number)
  # number = ((number << 6) ^ number) & 0xFFFFFF

  # number = ((number >> 5) ^ number) & 0xFFFFFF

  # ((number << 11) ^ number) & 0xFFFFFF

  number = ((number * 64) ^ number) % 16_777_216

  number = ((number / 32) ^ number) % 16_777_216

  ((number * 2048) ^ number) % 16_777_216
end

def find_max
  max_value = @sequences_sum.values.max

  @sequences_sum.each do |key, value|
    return [key, value] if value == max_value
  end
end

@sequences_sum = {}

@numbers.each do |number|
  @sequences_processed = {}

  change1 = nil
  change2 = nil
  change3 = nil
  change4 = nil

  2000.times do
    old_number = number
    number = calculate_next_secret_number(old_number)

    change1 = change2
    change2 = change3
    change3 = change4
    change4 = (number % 10) - (old_number % 10)

    arr = [change1, change2, change3, change4]
    # p "#{number % 10} - #{change}"

    next if @sequences_processed[arr]

    @sequences_processed[arr] = true

    @sequences_sum[arr] ||= 0
    @sequences_sum[arr] += number % 10
  end
end

key, value = find_max

p "key: #{key}, value: #{value}"
