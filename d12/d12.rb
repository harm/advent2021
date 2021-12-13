INPUT = <<-DATA
CV-mk
gm-IK
sk-gm
ca-sk
sx-mk
gm-start
sx-ca
kt-sk
ca-VS
kt-ml
kt-ca
mk-IK
end-sx
end-sk
gy-sx
end-ca
ca-ml
gm-CV
sx-kt
start-CV
IK-start
CV-kt
ml-mk
ml-CV
ml-gm
ml-IK
DATA

class String
  def capitalized?
    chars.first == chars.first.upcase
  end
end

class Node
  attr_accessor :small_cave
  attr_accessor :name
  attr_accessor :connections
  attr_accessor :visited

  def initialize(name)
    @name = name
    @small_cave = !name.capitalized?
    @connections = []
    @visited = false
  end

  def add_edge(neighbour)
    @connections << neighbour
  end

  def to_s
    "#{@name}[#{@connections.size}]"
  end

  def big_cave?
    !@small_cave
  end

end

class Graph

  attr_accessor :nodes

  def initialize
    @nodes = []
  end

  def find_or_create_node(name)
    node = @nodes.find{|n| n.name == name}
    if node.nil?
      node = Node.new(name)
      @nodes << node
    end
    node
  end

  def to_s
    @nodes.inspect
  end

  def start_node
    @nodes.find{|n| n.name == "start"}
  end

  def end_node
    @nodes.find{|n| n.name == "end"}
  end

  def paths_count(node, visited_prev = [])
    return 1 if node == end_node
    visited = visited_prev + [node]
    to_traverse = node.connections.reject {|c| c.small_cave && visited.include?(c) }
    to_traverse.sum{ |c| paths_count(c, visited) }
  end

  def paths_count2(node, visited_prev = [])
    return 1 if node == end_node
    visited = visited_prev + [node]

    tallied = visited.tally

    to_traverse = node.connections.reject{|c| c == start_node}

    to_traverse = to_traverse.select do |c|

      small_caves = visited.reject{|c| c.big_cave? }
      small_caves_tallied = small_caves.tally
      no_small_caves_were_visited_twice = small_caves_tallied.all?{|small_cave, value| value < 2 }
      c.big_cave? || (!visited.include?(c) || no_small_caves_were_visited_twice)
    end
    to_traverse.sum{ |c| paths_count2(c, visited) }
  end

end


graph = Graph.new
INPUT.split("\n").each do |line|
  node1_name = line.chomp.split("-")[0]
  node2_name = line.chomp.split("-")[1]

  node1 = graph.find_or_create_node(node1_name)
  node2 = graph.find_or_create_node(node2_name)

  node1.add_edge(node2)
  node2.add_edge(node1)
end

puts graph.paths_count(graph.start_node, [])
puts graph.paths_count2(graph.start_node, [])
