sum = 0
arr1 = []
arr2 = []
File.readlines('input1', chomp: true).each do |line|
  digits = line.split('   ')
  arr1 << digits[0].to_i
  arr2 << digits[1].to_i
end

arr1.sort!
arr2.sort!
arr1.each_with_index do |id1, index|
  sum += (id1 - arr2[index]).abs
end

p sum
