require 'rgl/adjacency'
require 'rgl/dijkstra'
require 'rgl/dot'
require 'benchmark'

# internal counter for id-labels of the cells (I don't like using arrays as mapping values in hashes)
$id = 0

class Point
  attr_accessor :x, :y, :risk, :id
  def initialize(x,y,risk)
    @x =x
    @y = y
    @risk = risk.to_i
    @id = $id
    $id += 1
  end
end

def create_graph(data)
  graph = RGL::AdjacencyGraph.new
  edge_weights = {}
  data.each_with_index do |row, y|
    row.each_with_index do |col, x|
      neighbours = get_neighbours(data, col)
      neighbours.each do |neighbour|
        graph.add_edge(col.id, neighbour.id)
        edge_weights[[col.id, neighbour.id]] = neighbour.risk.to_i
      end
    end
  end
  [graph, edge_weights]
end

def get_neighbours(data, point)
  x = point.x
  y = point.y
  neighbours = []
  neighbours << data[y][x-1] if x > 0
  neighbours << data[y][x+1] if x < data.first.size() -1
  neighbours << data[y-1][x] if y > 0
  neighbours << data[y+1][x] if y < data.size() -1
  neighbours
end

# read input file
INPUT = File.read("input.txt")
data = []
INPUT.split("\n").each_with_index do |line, y|
  data << line.chomp.chars.each_with_index.map{|col,x| Point.new(x, y, col) }
end

time = Benchmark.measure {
  # part 1

  # set the first cell risk to zero
  data.first.first.risk = 0
  graph, edge_weights = create_graph(data)
  values =  graph.dijkstra_shortest_path(edge_weights, data.first.first.id, data.last.last.id)
  puts values.map{|v| data.flatten.find{|p| p.id == v }.risk }.sum
}
puts time.real

time = Benchmark.measure {
  #part 2
  data2 = Array.new(data.length*5) do |y|
    Array.new(data[0].length*5) do |x|
      risk = data[y % data.length][x % data[0].length].risk + y/data.length + x/data[0].length
      Point.new(x, y, (risk % 10 + risk/10))
    end
  end

  # again, first cell risk is zero
  data2.first.first.risk = 0

  graph, edge_weights = create_graph(data2)
  values =  graph.dijkstra_shortest_path(edge_weights, data2.first.first.id, data2.last.last.id)
  puts values.map{|v| data2.flatten.find{|p| p.id == v }.risk }.sum
}
puts time.real
