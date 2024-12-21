# это первое брут форс решение, слишком медленное, не сработало
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
# 174507651923129 too high
# 164279024971453

# input1 = %(Register A: 2024
# Register B: 0
# Register C: 0

# Program: 0,3,5,4,3,0)
# # 117440

# input1.split("\n").map do |line|
#   load_line(line)
# end

p "a: #{@a}, b: #{@b}, c: #{@c}, instructions: #{@instructions}"

INSTRUCTIONS = [
  # adv 0
  lambda { |operand|
    @a /= 2.pow(combo(operand))
    @instruction_index += 1
  },
  # bxl 1
  lambda { |operand|
    @b ^= operand
    @instruction_index += 1
  },
  # bst 2
  lambda { |operand|
    @b = combo(operand) % 8
    @instruction_index += 1
  },
  # jnz 3
  lambda { |operand|
    if @a.zero?
      @instruction_index += 1
    else
      @instruction_index = operand
    end
  },
  # bxc 4
  lambda { |_operand|
    @b ^= @c
    @instruction_index += 1
  },
  # out 5
  lambda { |operand|
    @output << (combo(operand) % 8)
    @instruction_index += 1
  },
  # bdv 6
  lambda { |operand|
    @b = @a / 2.pow(combo(operand))
    @instruction_index += 1
  },
  # cdv 7
  lambda { |operand|
    @c = @a / 2.pow(combo(operand))
    @instruction_index += 1
  }
]

def combo(operand)
  case operand
  when 0..3 then operand
  when 4 then @a
  when 5 then @b
  when 6 then @c
  when 7 then raise('Invalid operand')
  end
end

def execute_program
  @output = []
  @instruction_index = 0

  operands = @instructions[@instruction_index]

  while operands
    INSTRUCTIONS[operands[0]].call(operands[1])
    operands = @instructions[@instruction_index]
  end
end

@a_finder = 164_279_024_971_450

# i = 0
# j = 0
loop do
  @a = @a_finder
  # @b = 0
  # @c = 0
  # p "a: #{@a}"
  execute_program
  if @a_finder == 164_279_024_971_453
    p "program: #{@program}"
    p "output:  #{@output}"
  end
  break if @output == @program

  # if @output.size < @program.size
  #   @a_finder += 10.pow(i)
  #   i += 1
  #   j = 0
  # elsif @output.size > @program.size
  #   @a_finder -= 10.pow(i)
  #   i = 0
  #   j += 1
  # else
  #   @a_finder += 1_000_000_000
  #   i = 0
  #   j = 0
  # end
  @a_finder += 1
end

p "a_finder: #{@a_finder}"
p "a: #{@a}, b: #{@b}, c: #{@c}"
p "output: #{@output.join(',')}"
