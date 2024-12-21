DISK_MAP = File.read('input9').split('').map(&:to_i)

# input1 = %{2333133121414131402}

# DISK_MAP = input1.split('').map(&:to_i)

EMPTY = :e

def create_better_disk_map
  file_id = -1

  DISK_MAP.map.each_with_index do |number, index|
    if index % 2 == 0
      file_id += 1
      { file_id: file_id, size: number }
    else
      { file_id: EMPTY, size: number }
    end
  end
end

def compress_disk!(disk)
  index = -1
  moved_file_id_min = nil

  while index >= -disk.size do
    element = disk[index]

    if element[:file_id] == EMPTY ||
        (moved_file_id_min && element[:file_id] >= moved_file_id_min)
      index -= 1
      next
    end

    file_index = disk.size + index
    index_empty = find_empty_space(disk, file_index, element[:size])

    move_file!(disk, file_index, index_empty) if index_empty

    moved_file_id_min = element[:file_id]

    index -= 1
  end
end

@empty_index_min = 0

def find_empty_space(disk, file_index, file_size)
  empty_found = false

  (@empty_index_min...file_index).each do |index|
    element = disk[index]
    next if element[:file_id] != EMPTY

    unless empty_found
      @empty_index_min = index
      empty_found = true
    end

    return index if element[:size] >= file_size
  end
  nil
end

def move_file!(disk, file_index, index_empty)
  element_file = disk[file_index]
  element_empty = disk[index_empty]

  disk[file_index] = { file_id: EMPTY, size: element_file[:size] }

  if element_empty[:size] > element_file[:size]
    element_empty[:size] -= element_file[:size]
    disk[index_empty, 0] = element_file
  else
    disk[index_empty] = element_file
  end
end

def calculate_checksum(disk)
  sum = 0
  index = 0

  disk.each do |element|
    if element[:file_id] != EMPTY
      element[:size].times do |i|
        sum += element[:file_id] * (index + i)
      end
    end
    index += element[:size]
  end
  sum
end

disk = create_better_disk_map
compress_disk!(disk)

p calculate_checksum(disk)

# 6359491896845 too high
# 6359491814941 right
