# frozen_string_literal: true

@locks = []
@keys = []

@lock_sequence_open = false
@key_sequence_open = false

def process_input(line)
  if @lock_sequence_open
    process_lock_sequence(line)
  elsif @key_sequence_open
    process_key_sequence(line)
  elsif line == '#####'
    @lock_sequence_open = true
    @lock_sequence = [0] * 5
    @line_number = 0
  elsif line == '.....'
    @key_sequence_open = true
    @key_sequence = [5] * 5
    @line_number = 0
  end
end

def process_lock_sequence(line)
  if @line_number == 5
    @lock_sequence_open = false
    @locks << @lock_sequence
    return
  end

  line.chars.each_with_index do |char, index|
    @lock_sequence[index] += 1 if char == '#'
  end
  @line_number += 1
end

def process_key_sequence(line)
  if @line_number == 5
    @key_sequence_open = false
    @keys << @key_sequence
    return
  end

  line.chars.each_with_index do |char, index|
    @key_sequence[index] -= 1 if char == '.'
  end
  @line_number += 1
end

File.readlines('input', chomp: true).each do |line|
  process_input(line)
end
# 3320

# File.readlines('input_test', chomp: true).each do |line|
#   process_input(line)
# end
# # 3

def count_fit_pairs
  count = 0
  @locks.each do |lock|
    max_key = lock.map { 5 - _1 }

    @keys.each do |key|
      count += 1 if key.zip(max_key).all? { |pin, pin_max| pin <= pin_max }
    end
  end
  count
end

# p @locks
# p @keys

p count_fit_pairs
