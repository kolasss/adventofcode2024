# frozen_string_literal: true

# пытался решить задачу, но не смог, работает только для тестового инпута

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

# File.readlines('input', chomp: true).each do |line|
#   process_input(line)
# end
# # ckj,dbp,fdv,kdf,rpp,z15,z23,z39

# GATES_PAIRS = 4

input1 = %(x00: 0
x01: 1
x02: 0
x03: 1
x04: 0
x05: 1
y00: 0
y01: 0
y02: 1
y03: 1
y04: 0
y05: 1

x00 AND y00 -> z05
x01 AND y01 -> z02
x02 AND y02 -> z01
x03 AND y03 -> z03
x04 AND y04 -> z04
x05 AND y05 -> z00)
# z00,z01,z02,z05

input1.split("\n").each do |line|
  process_input(line)
end

GATES_PAIRS = 2

OPERATIONS = {
  and: ->(a, b) { a & b },
  or: ->(a, b) { a | b },
  xor: ->(a, b) { a ^ b }
}.freeze

def process_gate_with_dependent(key, key_output)
  # p "key: #{key}, key_output: #{key_output}"
  # if key != key_output
  @dependent[key_output] ||= []
  @dependent[key_output] << key
  # end

  wire = @wires[key]
  return wire if wire

  # cached = @cached[key]
  # return cached if cached

  gate = @gates[key]
  # @cached[key] = OPERATIONS[gate[:operation]].call(
  OPERATIONS[gate[:operation]].call(
    process_gate_with_dependent(gate[:input1], key_output),
    process_gate_with_dependent(gate[:input2], key_output)
  )
end

def process_gate_swapped(key)
  wire = @wires[key]
  return wire if wire

  swapped = @swapped[key]
  if swapped
    return OPERATIONS[swapped[:operation]].call(
      process_gate_swapped(swapped[:input1]),
      process_gate_swapped(swapped[:input2])
    )
  end

  cached = @cached[key]
  return cached if cached

  gate = @gates[key]
  @cached[key] = OPERATIONS[gate[:operation]].call(
    process_gate_swapped(gate[:input1]),
    process_gate_swapped(gate[:input2])
  )
end

def find_expected_output
  input1_keys = @wires.keys.select { _1.start_with?('x') }.sort.reverse
  input2_keys = @wires.keys.select { _1.start_with?('y') }.sort.reverse

  (
    @wires.values_at(*input1_keys).join.to_i(2) &
    @wires.values_at(*input2_keys).join.to_i(2)
  ).to_s(2).chars.map(&:to_i)
end

# p @wires
# p @gates

@output_expected = find_expected_output
p "output_expected: #{@output_expected}"
# p output_expected.to_s(2)

@output_keys = @gates.keys.select { _1.start_with?('z') }.sort.reverse

@cached = {}
@dependent = {}

output = @output_keys.map do |key|
  process_gate_with_dependent(key, key)
end

p "output:--------- #{output}"
# p output.join.to_i(2)

@dependent.each_value(&:uniq!)
# p @dependent.keys.size

def find_swap_candidates
  swap_candidates = @dependent.select do |key, values|
    matched = key.match(/z(\d+)/)
    !values.include?(:"x#{matched[1]}") ||
      !values.include?(:"y#{matched[1]}")
  end

  swap_candidates2 = swap_candidates.values.flatten.uniq.reject do |key|
    key.start_with?('x') || key.start_with?('y')
  end
  p swap_candidates2.size

  swap_candidates3 = swap_candidates2.permutation(2).to_a.map(&:sort).uniq

  swap_candidates4 = []
  swap_candidates3.each_with_index do |candidates, index|
    swap_candidates3[index + 1..].each do |candidates2|
      swap_candidates4 << [candidates, candidates2] if (candidates & candidates2).empty?
    end
  end
  swap_candidates4
end

swap_candidates = find_swap_candidates
p swap_candidates

def find_correct_swap(swap_candidates)
  swap_candidates.each do |candidates|
    return candidates if try_with_swapped(candidates)
  end
  nil
end

def try_with_swapped(candidates)
  @swapped = {}
  candidates.each do |candidate|
    @swapped[candidate[0]] = @gates[candidate[1]]
    @swapped[candidate[1]] = @gates[candidate[0]]
  end

  output = @output_keys.map do |key|
    process_gate_swapped(key)
  end
  output == @output_expected
end

correct = find_correct_swap(swap_candidates)
p correct.flatten.sort.join(',')
