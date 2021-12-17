def find_x(x)
  total = 0
  while true do
    total = total + x
    x = x - 1 if x > 0
    x = x + 1 if x < 0
    break if x == 0
  end
  total
end

x_target_range = 240..292
y_target_range = -90..-57

start_x = 1
possible_x = 0
while true do
  possible_x = find_x(start_x)
  start_x += 1
  next if possible_x < x_target_range.first
  break if x_target_range.cover?(possible_x)
end

lowest_y = y_target_range.first.abs - 1
height = lowest_y * (lowest_y + 1) / 2
puts "Problem 1 solution: (#{possible_x},#{lowest_y}) h: #{height}"
