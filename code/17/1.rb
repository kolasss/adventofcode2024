@a = 0
@b = 0
@c = 0

def load_line(line)
  case line
  when /Register A: (\d+)/
    @a = Regexp.last_match(1).to_i
  when /Register B: (\d+)/
    @b = Regexp.last_match(1).to_i
  when /Register C: (\d+)/
    @c = Regexp.last_match(1).to_i
  when /Program: (.+)/
    @instructions = Regexp.last_match(1).split(',').map(&:to_i).each_slice(2).to_a
  end
end

File.readlines('input', chomp: true).each do |line|
  load_line(line)
end
# 4,1,7,6,4,1,0,2,7

# input1 = %(Register A: 729
# Register B: 0
# Register C: 0

# Program: 0,1,5,4,3,0)
# # 4,6,3,5,6,3,5,2,1,0

# input1 = %(Register A: 10
# Register B: 0
# Register C: 0

# Program: 5,0,5,1,5,4)
# # 0,1,2

# input1 = %(Register A: 2024
# Register B: 0
# Register C: 0

# Program: 0,1,5,4,3,0)
# # 4,2,5,6,7,7,7,7,3,1,0

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

@output = []
@instruction_index = 0

operands = @instructions[@instruction_index]

while operands
  INSTRUCTIONS[operands[0]].call(operands[1])
  operands = @instructions[@instruction_index]
end

p "a: #{@a}, b: #{@b}, c: #{@c}"
p "output: #{@output.join(',')}"
