arr1 = []
File.readlines('input2', chomp: true).each do |line|
  digits = line.split(' ').map(&:to_i)
  arr1 << digits
end

# arr = [
#   %w[7 6 4 2 1],
#   %w[1 2 7 8 9],
#   %w[9 7 6 2 1],
#   %w[1 3 2 4 5],
#   %w[8 6 4 4 1],
#   %w[1 3 6 7 9]
# ]

SAFE_INC = (1..3)

def safe_report?(report)
  prev = report[0]
  order = nil

  report[1..-1].each do |level|
    return false if !SAFE_INC.include?((prev - level).abs)

    new_order = prev < level ? :asc : :desc

    if order
      return false if order != new_order
    else
      order = new_order
    end

    prev = level
  end

  true
end

count = 0

arr1.each do |report|
  report.map!(&:to_i)
  count += 1 if safe_report?(report)
end

p count
