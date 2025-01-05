# frozen_string_literal: true

@wires = {}
@gates = {}
@wires_processed = false

def process_input(line)
  if @wires_processed
    matched = line.match(/(.+) (AND|XOR|OR) (.+) -> (.+)/)
    @gates[matched[4].to_sym] = {
      operation: matched[2].downcase.to_sym,
      input1: matched[1].to_sym,
      input2: matched[3].to_sym
    }
  else
    matched = line.match(/(.+): (\d+)/)
    if matched
      @wires[matched[1].to_sym] = matched[2].to_i
    else
      @wires_processed = true
    end
  end
end

File.readlines('input', chomp: true).each do |line|
  process_input(line)
end
# 57632654722854

# File.readlines('input_test', chomp: true).each do |line|
#   process_input(line)
# end
# # 2024

# input1 = %(x00: 1
# x01: 1
# x02: 1
# y00: 0
# y01: 1
# y02: 0

# x00 AND y00 -> z00
# x01 XOR y01 -> z01
# x02 OR y02 -> z02)
# # 4

# input1.split("\n").each do |line|
#   process_input(line)
# end

OPERATIONS = {
  and: ->(a, b) { a & b },
  or: ->(a, b) { a | b },
  xor: ->(a, b) { a ^ b }
}.freeze

def process_gate(key)
  wire = @wires[key]
  return wire if wire

  gate = @gates[key]
  @wires[key] = OPERATIONS[gate[:operation]].call(
    process_gate(gate[:input1]),
    process_gate(gate[:input2])
  )
end

# p @wires
# p @gates

keys = @gates.keys.select { _1.start_with?('z') }.sort.reverse

output = keys.map do |key|
  process_gate(key)
end

p output.join.to_i(2)
