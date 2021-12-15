def step(template, pairs_map)
  new_pairs = {}
  template.each do |k, count|
    c1 = k[0] + pairs_map[k]
    c2 = pairs_map[k] + k[1]
    new_pairs[c1] = 0 if new_pairs[c1].nil?
    new_pairs[c1] += count
    new_pairs[c2] = 0 if new_pairs[c2].nil?
    new_pairs[c2] += count
  end
  new_pairs
end

input = File.read("input.txt").split("\n")
MAP = input.map { |pair| pair.split(' -> ') }.to_h
TEMPLATE = "KHSSCSKKCPFKPPBBOKVF"
template = TEMPLATE
tally = {}
tally[TEMPLATE.chars[-1]] = 1
template = template.chars.each_cons(2).to_a.map{|x| "#{x[0]}#{x[1]}"}.tally

40.times do
  template = step(template, MAP)
end

template.each do |k, count|
  char = k[0]
  tally[char] ||= 0
  tally[char] += count
end

puts tally
puts "Diff: #{tally.values.max - tally.values.min}"
