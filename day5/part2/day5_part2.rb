$instructions = []

$current_instruction = 0
$instruction_count = 0
$step_counter = 0

File.open("input.txt") do |file|
  file.each_line do |line|
    $instructions << line.to_i
    $instruction_count += 1
  end
end

def current_instruction_outside_bounds?
  $current_instruction < 0 || $current_instruction >= $instruction_count
end

def execute_instruction
  current_jump = $instructions[$current_instruction]
  if current_jump >= 3
    $instructions[$current_instruction] -= 1
  else
    $instructions[$current_instruction] += 1
  end

  $current_instruction += current_jump
  $step_counter += 1
  return current_instruction_outside_bounds?
end

while !execute_instruction do end

puts "#{$step_counter} steps taken"
