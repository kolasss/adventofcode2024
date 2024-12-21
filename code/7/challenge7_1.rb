EQUATIONS = []

File.readlines('input7', chomp: true).each do |line|
  EQUATIONS << line.split(' ').map(&:to_i)
end

# input1 = %{190: 10 19
# 3267: 81 40 27
# 83: 17 5
# 156: 15 6
# 7290: 6 8 6 15
# 161011: 16 10 13
# 192: 17 8 14
# 21037: 9 7 18 13
# 292: 11 6 16 20}

# input1 = %{16028321: 10 437 7 727 385 8 1
# 32764104: 3 7 8 2 5 1 3 263 7 85 2 6
# 66: 3 3 6
# 160299: 5 5 89 3 1 4 1 3 1 5 38 1}

# EQUATIONS = input1.split("\n").map do |line|
#   line.split(' ').map(&:to_i)
# end

OPERATORS = [:add, :multiply]

def possibly_correct?(result, numbers)
  return result == numbers.first if numbers.size == 1

  OPERATORS.any? do |operator|
    number = numbers.last
    new_result = calculate_reverse(result, operator, number)
    # c = possibly_correct?(new_result, numbers[0..-2])
    # @operators << operator if c
    # c
    possibly_correct?(new_result, numbers[0..-2])
  end
end

def calculate_reverse(first, operator, second)
  case operator
  when :add
    first - second
  when :multiply
    first.to_f / second
  end
end

# def calc_result(numbers)
#   result = numbers.first
#   numbers.each_with_index do |number, index|
#     next if index == 0

#     result = calculate(result, @operators[index - 1], number)
#   end
#   result
# end

# def calculate(first, operator, second)
#   case operator
#   when :add
#     first + second
#   when :multiply
#     first * second
#   end
# end

sum = 0

EQUATIONS.each do |equation|
  # @operators = []
  result = equation[0]
  numbers = equation[1..-1]
  if possibly_correct?(result, numbers)
    sum += result
    # p "correct result: #{result} numbers: #{numbers}"
    # p @operators
    # p calc_result(numbers)
  end
end

p sum

# 21154759456505 too high
