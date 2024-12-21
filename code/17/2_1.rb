# второе брут форс решение, оптимизровал операции в один шаг, тоже слишком медленно
@a = 0
@b = 0
@c = 0
@program = nil

def load_line(line)
  case line
  when /Register A: (\d+)/
    @a = Regexp.last_match(1).to_i
  when /Register B: (\d+)/
    @b = Regexp.last_match(1).to_i
  when /Register C: (\d+)/
    @c = Regexp.last_match(1).to_i
  when /Program: (.+)/
    @program = Regexp.last_match(1).split(',').map(&:to_i)
    @instructions = @program.each_slice(2).to_a
  end
end

File.readlines('input', chomp: true).each do |line|
  load_line(line)
end
# 164279024971453

p "a: #{@a}, b: #{@b}, c: #{@c}, instructions: #{@instructions}"

def execute_program
  # @b = @a % 8
  # @b ^= 1
  @b = (@a % 8) ^ 1
  @c = @a / 2.pow(@b)
  # @b ^= 5
  # @b ^= @c
  @b = (@b ^ 5) ^ @c
  # @output << (@b % 8)
  @a /= 8
  @b % 8
end

def execute_program2
  result = ((((@a % 8) ^ 1) ^ 5) ^ (@a / 2.pow((@a % 8) ^ 1))) % 8
  @a /= 8
  result
end

# @a_finder = 1
# @a_finder = 527_265_725
# @a_finder = 281_474_976_710_656
# @a_finder = 281_477_013_925_821
#
# @a_finder = 12
@a_finder = 281_474_976_710_668
# @a_finder = 174_507_651_923_129

size = @program.size

loop do
  @a = @a_finder

  result = []
  size.times do |i|
    result << execute_program2
    break if result[i] != @program[i]

    p "a_finder: #{@a_finder} result right: #{result}" if i > 6
  end
  # if [15].include? @a_finder
  #   p "program: #{@program}"
  #   p "output:  #{result}"
  # end
  break if result == @program

  # break if @a_finder > 1_000_000

  # @a_finder += 8
  @a_finder -= 8
  # @a_finder += 1
end

p "a_finder: #{@a_finder}"
p "a: #{@a}, b: #{@b}, c: #{@c}"
# p "output: #{@output.join(',')}"
