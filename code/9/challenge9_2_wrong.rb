DISK_MAP = File.read('input9').split('').map(&:to_i)

# input1 = %{2333133121414131402}

# DISK_MAP = input1.split('').map(&:to_i)

EMPTY = :e

def create_disk
  file_id = 0
  disk = []

  DISK_MAP.each_with_index do |number, index|
    if index % 2 == 0
      disk += [file_id] * number
      file_id += 1
    else
      disk += [EMPTY] * number
    end
  end
  disk
end

def compress_disk!(disk)
  index = -1
  index_right = nil
  file_id = nil
  moved_file_id_min = nil

  while index >= -disk.size do
    # p "index: #{index} element: #{disk[index]}"
    if disk[index] == EMPTY || (moved_file_id_min && disk[index] >= moved_file_id_min)
      index -= 1
      next
    end

    unless index_right
      index_right = disk.size + index
      file_id = disk[index]
    end

    if disk[index - 1] == file_id
      index -= 1
      next
    else
      index_left = disk.size + index
      file_size = index_right - index_left + 1

      # p "index_left: #{index_left} index_right: #{index_right} file_size: #{file_size}"

      index_empty = find_empty_space(disk, index_left, file_size)
      # p "index_empty: #{index_empty}"

      if index_empty
        move_file!(disk, index_left, file_size, index_empty)
      end
      moved_file_id_min = file_id
      index_right = nil
    end

    index -= 1
  end
end

def find_empty_space(disk, file_index, file_size)
  # p "index_left: #{file_index} file_size: #{file_size}"
  index_left = nil
  found_size = 0
  disk.each_with_index do |file_id, index|
    return if index >= file_index

    unless index_left
      if file_id == EMPTY
        index_left = index
        found_size = 1
      end
    else
      if file_id == EMPTY
        found_size += 1
      else
        if found_size >= file_size
          return index_left
        else
          index_left = nil
        end
      end
    end
  end
end

def move_file!(disk, file_index, file_size, index_empty)
  disk[index_empty, file_size] = disk[file_index, file_size]
  disk[file_index, file_size] = [EMPTY] * file_size
  # p disk
end

def calculate_checksum(disk)
  sum = 0
  disk.each_with_index do |file_id, index|
    sum += file_id * index if file_id != EMPTY
  end
  sum
end

disk = create_disk
# p disk
p disk.size
compress_disk!(disk)

p calculate_checksum(disk)

# 6359491896845 too high
