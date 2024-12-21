input = File.read('input3')

# input = 'xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))'

sum = 0

REGEXP = /mul\((\d{1,3}),(\d{1,3})\)/
input.scan(REGEXP) do |match|
  a, b = match.map(&:to_i)
  sum += a * b
end

p sum
