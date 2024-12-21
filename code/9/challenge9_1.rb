DISK_MAP = File.read('input9').split('').map(&:to_i)

# input1 = %{2333133121414131402}

# DISK_MAP = input1.split('').map(&:to_i)

def create_disk
  file_id = 0
  disk = []

  DISK_MAP.each_with_index do |number, index|
    if index % 2 == 0
      disk += [file_id] * number
      file_id += 1
    else
      disk += ['.'] * number
    end
  end
  disk
end

def compress_disk!(disk)
  (1..disk.size).each do |index|
    next if disk[-index] == '.'

    left_empty = disk.index('.')
    break if left_empty >= disk.size - index

    disk[left_empty], disk[-index] = disk[-index], disk[left_empty]
  end
end

def calculate_checksum(disk)
  sum = 0
  disk.each_with_index do |file_id, index|
    break if file_id == '.'

    sum += file_id * index
  end
  sum
end

disk = create_disk
compress_disk!(disk)

p calculate_checksum(disk)
