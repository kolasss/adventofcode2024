# верное решение
# сделал по советам chatgpt по реверсу алгоритма
# поиск с конца
def reverse_execute(a, negative_index)
  (0..7).each do |x|
    # Пытаемся найти подходящее значение для @a % 8
    possible_a = (x + (a * 8))

    calculated_result = ((((possible_a % 8) ^ 1) ^ 5) ^ (possible_a / 2.pow((possible_a % 8) ^ 1))) % 8

    next if calculated_result != @target_sequence[negative_index]

    p "possible_a: #{possible_a}, negative_index: #{negative_index}"
    if @target_sequence[negative_index - 1]
      @possible_as << [possible_a, negative_index - 1]
    else
      @results << possible_a
    end
  end
end

# Заданная последовательность
@target_sequence = [2, 4, 1, 1, 7, 5, 1, 5, 4, 0, 5, 5, 0, 3, 3, 0]

@possible_as = [[0, -1]]
@results = []

while @possible_as.any?
  possible_a = @possible_as.shift
  reverse_execute(possible_a[0], possible_a[1])
end

# p @results.sort
p "min result: #{@results.min}"
