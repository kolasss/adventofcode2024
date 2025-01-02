# frozen_string_literal: true

# +---+---+---+
# | 7 | 8 | 9 |
# +---+---+---+
# | 4 | 5 | 6 |
# +---+---+---+
# | 1 | 2 | 3 |
# +---+---+---+
#     | 0 | A |
#     +---+---+

# +---+---+---+
# |   | ^ | A |
# +---+---+---+
# | < | v | > |
# +---+---+---+

@codes = []

File.readlines('input', chomp: true).each do |line|
  @codes << line.chars.map(&:to_sym)
end
# 214633893742472 too high
# 188000493837892

# input1 = %(029A
# 980A
# 179A
# 456A
# 379A)
# # 126384

# # input1 = %(029A)
# # # 1972

# @codes = input1.split("\n").map do |line|
#   line.chars.map(&:to_sym)
# end

PAD_DIGITS = [
  %i[7 8 9],
  %i[4 5 6],
  %i[1 2 3],
  %i[x 0 A]
].freeze

BOUNDARIES_DIGITS = { x: PAD_DIGITS.first.size, y: PAD_DIGITS.size }.freeze

DIRECTIONS = {
  :v => [0, 1],
  :> => [1, 0],
  :^ => [0, -1],
  :< => [-1, 0]
}.freeze

def find_sequences_digits(buttons)
  current_coords = [2, 3]

  buttons_sequences = []

  buttons.each do |button|
    result = find_next_button_routes_digits(current_coords, button)
    current_coords = result[:next_coords]
    buttons_sequences << if result[:routes]&.any?
                           result[:routes].uniq.map { _1 + [:A] }
                         else
                           [[:A]]
                         end
  end

  buttons_sequences
end

def find_next_button_routes_digits(current_coords, next_button)
  @buttons_routes = {}
  @buttons_scores = { current_coords[0] => { current_coords[1] => 0 } }
  @buttons_queue = [current_coords]
  @next_button_coords = nil

  while @buttons_queue.any?
    @buttons_queue.sort_by! { |coords| @buttons_scores.dig(*coords) }
    @buttons_queue.uniq!
    button_coords = @buttons_queue.shift
    find_buttons_score(button_coords)

    @next_button_coords = button_coords if PAD_DIGITS.dig(button_coords[1], button_coords[0]) == next_button
  end

  {
    next_coords: @next_button_coords,
    routes: @buttons_routes.dig(*@next_button_coords)
  }
end

def find_buttons_score(current_coords)
  direction_score = @buttons_scores.dig(*current_coords) + 1
  current_routes = @buttons_routes.dig(*current_coords)

  DIRECTIONS.each do |direction, direction_coords|
    x_new = current_coords[0] + direction_coords[0]
    y_new = current_coords[1] + direction_coords[1]

    next unless coords_in_map_digits?(x_new, y_new)

    score_cached = @buttons_scores.dig(x_new, y_new)

    next if score_cached && score_cached < direction_score

    @buttons_scores[x_new] ||= {}
    @buttons_scores[x_new][y_new] = direction_score

    @buttons_routes[x_new] ||= {}
    @buttons_routes[x_new][y_new] ||= []

    new_routes = if current_routes&.any?
                   current_routes.map { _1 + [direction] }
                 else
                   [[direction]]
                 end

    @buttons_routes[x_new][y_new].push(*new_routes)

    @buttons_queue << [x_new, y_new]
  end
end

def coords_in_map_digits?(x, y)
  return false if x.zero? && y == 3

  x >= 0 && x < BOUNDARIES_DIGITS[:x] && y >= 0 && y < BOUNDARIES_DIGITS[:y]
end

def permutate_sequences(sequences)
  final_sequences = sequences.first

  sequences[1..].each do |button_sequences|
    final_sequences = button_sequences.map do |sequence|
      final_sequences.map { _1 + sequence }
    end.flatten(1)
  end

  final_sequences
end

def find_sequences_directions(buttons)
  current_button = :A
  buttons_sequences = []

  buttons.each do |button|
    sequence = find_next_button_routes_directions(current_button, button)
    current_button = button
    buttons_sequences.push(*sequence)
  end

  buttons_sequences
end

# PAD_DIRECTIONS = [
#   %i[x ^ A],
#   %i[< v >]
# ].freeze
PAD_DIRECTIONS_ROUTES = {
  :A => {
    :^ => %i[< A],
    :A => %i[A],
    :< => %i[v < < A],
    :v => %i[< v A],
    :> => %i[v A]
  },
  :^ => {
    :^ => %i[A],
    :A => %i[> A],
    :< => %i[v < A],
    :v => %i[v A],
    :> => %i[v > A]
  },
  :< => {
    :^ => %i[> ^ A],
    :A => %i[> > ^ A],
    :< => %i[A],
    :v => %i[> A],
    :> => %i[> > A]
  },
  :v => {
    :^ => %i[^ A],
    :A => %i[^ > A],
    :< => %i[< A],
    :v => %i[A],
    :> => %i[> A]
  },
  :> => {
    :^ => %i[< ^ A],
    :A => %i[^ A],
    :< => %i[< < A],
    :v => %i[< A],
    :> => %i[A]
  }
}.freeze

def find_next_button_routes_directions(current_button, next_button)
  PAD_DIRECTIONS_ROUTES.dig(current_button, next_button)
end

# def find_by_min_size(sequences)
#   min_size = sequences.map(&:size).min
#   sequences.select { _1.size == min_size }
# end

@cache_presses = {}

def number_of_presses(current_button, next_button, level)
  # p "#{current_button} -> #{next_button} (#{level})"
  cached = @cache_presses.dig(current_button, next_button, level)
  return cached if cached

  sequence = find_next_button_routes_directions(current_button, next_button)
  return sequence.size if level == @max_level

  sum = 0
  button_current = :A
  sequence.each do |button|
    sum += number_of_presses(button_current, button, level + 1)
    button_current = button
  end

  @cache_presses[current_button] ||= {}
  @cache_presses[current_button][next_button] ||= {}
  @cache_presses[current_button][next_button][level] = sum

  sum
end

def find_sequence_presses(sequence)
  min_presses = 0
  button_current = :A

  sequence.each do |button|
    min_presses += number_of_presses(button_current, button, 1)
    button_current = button
  end

  min_presses
end

# p @codes

sum = 0

@max_level = 25

@codes.each do |code|
  buttons_sequences = find_sequences_digits(code)
  sequences1 = permutate_sequences(buttons_sequences)

  presses = sequences1.map { find_sequence_presses(_1) }
  min_presses = presses.min

  number = code[..-2].join.to_i

  p "#{min_presses} * #{number} = #{min_presses * number}"
  sum += min_presses * number
end

p "sum: #{sum}"
