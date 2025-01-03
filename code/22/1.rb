# frozen_string_literal: true

@numbers = []

File.readlines('input', chomp: true).each do |line|
  @numbers << line.to_i
end
# 20215960478

# input1 = %(1
# 10
# 100
# 2024)
# # 37327623

# # input1 = %(123)

# @numbers = input1.split("\n").map(&:to_i)

def calculate_next_secret_number(number)
  number = ((number * 64) ^ number) % 16_777_216

  number = ((number / 32) ^ number) % 16_777_216

  ((number * 2048) ^ number) % 16_777_216
end

sum = 0

@numbers.each do |number|
  2000.times do
    number = calculate_next_secret_number(number)
  end
  sum += number
end

p "sum: #{sum}"
