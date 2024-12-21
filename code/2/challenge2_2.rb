arr1 = []
File.readlines('input2', chomp: true).each do |line|
  digits = line.split(' ').map(&:to_i)
  arr1 << digits
end

# arr1 = [
#   %w[7 6 4 2 1].map(&:to_i),
#   %w[1 2 7 8 9].map(&:to_i),
#   %w[9 7 6 2 1].map(&:to_i),
#   %w[1 3 2 4 5].map(&:to_i),
#   %w[8 6 4 4 1].map(&:to_i),
#   %w[1 3 6 7 9].map(&:to_i)
# ]

SAFE_INC = (1..3)

def safe_report?(report)
  prev = report[0]
  order = prev < report[-1] ? :asc : :desc

  report[1..-1].each_with_index do |level, index|
    return [false, index] if !SAFE_INC.include?((prev - level).abs)

    new_order = prev < level ? :asc : :desc
    return [false, index] if order != new_order

    prev = level
  end

  [true, nil]
end

def safe_report_wrapper?(report)
  result, index = safe_report?(report)
  return true if result

  # index is index of prev element
  safe_report?(arra_wo_element(report, index))[0] ||
    safe_report?(arra_wo_element(report, index + 1))[0]
end

def arra_wo_element(arr, index)
  arr[0...index] + arr[(index + 1)..-1]
end

count = 0

arr1.each do |report|
  if safe_report_wrapper?(report)
    count += 1
  end
end

p count
