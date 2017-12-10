require 'set'

input = File.open("input.txt", &:readline)
buffers = input.split("\t").map { |element| element.to_i }
patterns_seen = Set.new()
patterns_seen_list = []
reallocation_count = 0

def print_buffers(buffers)
  puts buffers.map { |elem| elem.to_s.ljust(3, ' ') }.join(" ")

end

def find_largest_buffer(buffers)
  max_buffer_index = nil
  buffers.each_with_index do |buffer, index|
    if max_buffer_index == nil || buffers[index] > buffers[max_buffer_index]
      max_buffer_index = index
    end
  end
  max_buffer_index
end

def buffers_to_pattern(buffers)
  buffers.join(" ")
end

def run_reallocation(buffers)
  largest_buffer_index = find_largest_buffer(buffers)
  largest_buffer_value = buffers[largest_buffer_index]

  buffers[largest_buffer_index] = 0

  (1..largest_buffer_value).each do |i|
    buffers[(largest_buffer_index + i) % 16] += 1
  end
end

patterns_seen << buffers_to_pattern(buffers)
while true do
  run_reallocation(buffers)
  reallocation_count += 1
  pattern = buffers_to_pattern(buffers)
  if patterns_seen.include?(pattern)
    patterns_seen_list.each_with_index do |previous_pattern, index|
      if previous_pattern == pattern
        puts "Circular reallocation occurred #{reallocation_count - index - 1} allocations appart"
      end
    end

    exit
  else
    patterns_seen << pattern
    patterns_seen_list << pattern
  end
end
