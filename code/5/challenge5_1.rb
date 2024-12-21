RULES = {}
UPDATES = []
rules_section = true

File.readlines('input5', chomp: true).each do |line|
  if line.empty?
    rules_section = false
  elsif rules_section
    numbers = line.split('|').map(&:to_i)
    RULES[numbers[0]] ||= []
    RULES[numbers[0]] << numbers[1]
  else
    UPDATES << line.split(',').map(&:to_i)
  end
end

# input1 = %{47|53
# 97|13
# 97|61
# 97|47
# 75|29
# 61|13
# 75|53
# 29|13
# 97|29
# 53|29
# 61|53
# 97|53
# 61|29
# 47|13
# 75|47
# 97|75
# 47|61
# 75|61
# 47|29
# 75|13
# 53|13}

# input2 = %{75,47,61,53,29
# 97,61,53,29,13
# 75,29,13
# 75,97,47,61,53
# 61,13,29
# 97,13,75,29,47}

# RULES = {}
# input1.split("\n").each do |line|
#   numbers = line.split('|').map(&:to_i)
#   RULES[numbers[0]] ||= []
#   RULES[numbers[0]] << numbers[1]
# end

# UPDATES = input2.split("\n").map do |line|
#   line.split(',').map(&:to_i)
# end

def middle(update)
  update[update.size / 2]
end

def correct?(update)
  update.each_with_index do |number, index|
    next if index == 0

    return false if RULES[number] && (RULES[number] & update[0...index]).any?
  end
  true
end

sum = 0

UPDATES.each do |update|
  sum += middle(update) if correct?(update)
end

p sum
