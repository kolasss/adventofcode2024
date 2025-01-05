# frozen_string_literal: true

# верное решеение, просто скопировал решение
# https://www.bytesizego.com/blog/aoc-day24-golang
# https://www.reddit.com/r/adventofcode/comments/1hla5ql/2024_day_24_part_2_a_guide_on_the_idea_behind_the/

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
# ckj,dbp,fdv,kdf,rpp,z15,z23,z39

# решение не работает для тестового инпута, потому что это не Ripple Carry Adder
# input1 = %(x00: 0
# x01: 1
# x02: 0
# x03: 1
# x04: 0
# x05: 1
# y00: 0
# y01: 0
# y02: 1
# y03: 1
# y04: 0
# y05: 1

# x00 AND y00 -> z05
# x01 AND y01 -> z02
# x02 AND y02 -> z01
# x03 AND y03 -> z03
# x04 AND y04 -> z04
# x05 AND y05 -> z00)
# # z00,z01,z02,z05

# input1.split("\n").each do |line|
#   process_input(line)
# end

def find_swap_candidates
  output_keys = @gates.keys.select { _1.start_with?('z') }.sort.reverse
  @z_max = output_keys.first[1..].to_i
  @xor_gates = @gates.select { _2[:operation] == :xor }
  @or_gates = @gates.select { _2[:operation] == :or }

  selected = @gates.select do |key, gate|
    invalid_gate?(key, gate)
  end

  selected.keys
end

def invalid_gate?(key, gate)
  if key.start_with?('z')
    return true if key[1..].to_i != @z_max && gate[:operation] != :xor
  elsif !inputs_x_y?(gate)
    return true if gate[:operation] == :xor
  end

  if inputs_x_y?(gate) && inputs_not_00?(gate)
    if gate[:operation] == :xor
      return true if @xor_gates.none? do |_, xor_gate|
        xor_gate[:input1] == key || xor_gate[:input2] == key
      end
    elsif gate[:operation] == :and
      return true if @or_gates.none? do |_, xor_gate|
        xor_gate[:input1] == key || xor_gate[:input2] == key
      end
    end
  end

  false
end

def inputs_x_y?(gate)
  (gate[:input1].start_with?('x') && gate[:input2].start_with?('y')) ||
    (gate[:input1].start_with?('y') && gate[:input2].start_with?('x'))
end

def inputs_not_00?(gate)
  gate[:input1] != :x00 && gate[:input2] != :y00 &&
    gate[:input1] != :y00 && gate[:input2] != :x00
end

keys = find_swap_candidates
p "keys: #{keys.sort.join(',')}"
