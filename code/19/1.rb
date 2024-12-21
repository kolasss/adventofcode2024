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
# 263

# input1 = %(r, wr, b, g, bwu, rb, gb, br

# brwrr
# bggr
# gbbr
# rrbgbr
# ubwu
# bwurrg
# brgr
# bbrgwb)
# # 6

# input1.split("\n").map do |line|
#   load_line(line)
# end

# p @available_patterns
# p @designs

def possible?(design, index)
  @available_patterns.each do |pattern|
    # puts "pattern: #{pattern}"
    # puts "design[index, pattern.length]: #{design[index, pattern.length]}"
    if pattern == design[index, pattern.length]
      return true if index + pattern.length == design.length
      return true if possible?(design, index + pattern.length)
    end
  end
  false
end

count = 0

@designs.each do |design|
  count += 1 if possible?(design, 0)
end

p count
