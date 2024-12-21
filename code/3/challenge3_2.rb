input = File.read('input3')

# input = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

sum = 0
enabled = true
REGEXP = /mul\((?<first>\d{1,3}),(?<second>\d{1,3})\)|(?<do>do\(\))|(?<dont>don't\(\))/

input.scan(REGEXP) do |match|
  if enabled && match[0] && match[1]
    sum += match[0].to_i * match[1].to_i
  elsif match[2]
    enabled = true
  elsif match[3]
    enabled = false
  end
end

p sum
