# frozen_string_literal: true

@available_patterns = []
@designs = []
@patterns_loaded = false

def load_line(line)
  if @patterns_loaded
    @designs << line.chars
  elsif line != ''
    @available_patterns = line.split(', ').map(&:chars)
  else
    @patterns_loaded = true
  end
end

File.readlines('input', chomp: true).each do |line|
  load_line(line)
end
# 723524534506343

# input1 = %(r, wr, b, g, bwu, rb, gb, br

# brwrr
# bggr
# gbbr
# rrbgbr
# ubwu
# bwurrg
# brgr
# bbrgwb)
# # 16

# input1.split("\n").map do |line|
#   load_line(line)
# end

def find_possible_variants(design, index)
  @available_patterns.each do |pattern|
    next if pattern != design[index, pattern.length]

    if index + pattern.length == design.length
      @count += @index_count[index]
      next
    end

    new_index = index + pattern.length
    @possible_queue << new_index
    @index_count[new_index] ||= 0
    @index_count[new_index] += @index_count[index]
  end
end

@count = 0

@designs.each do |design|
  @possible_queue = [0]
  @index_count = { 0 => 1 }

  while @possible_queue.any?
    @possible_queue.uniq!
    @possible_queue.sort!
    index = @possible_queue.shift
    find_possible_variants(design, index)
  end
end

p @count
