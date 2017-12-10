require 'byebug'
require 'set'

LINE_PATTERN = %r(([a-z]+)\s\(([0-9]+)\)(\s\->\s([a-z, ]+))?)
$root_candidate_nodes = {}
$root_candidate_names = Set.new
$nodes = []

class Node
  attr_reader :name, :weight, :children, :children_names

  def initialize(name, weight, children_names)
    @name = name
    @weight = weight
    @children_names = children_names.nil? ? nil : children_names.split(",").map { |name| name.strip }
    @children = []
  end
end

def parse_line(line)
  match_data = LINE_PATTERN.match(line)

  node = Node.new(match_data[1], match_data[2].to_i, match_data[4])

  $nodes << node
  unless match_data[3].nil?
    $root_candidate_names << match_data[1]
    $root_candidate_nodes[match_data[1]] = node
  end

end

File.open('input.txt') do |file|
  file.each_line do |line|
    parse_line(line)
  end
end

$nodes.each do |node|
  unless node.children_names.nil?
    node.children_names.each do |child_node_name|
      $root_candidate_names.delete(child_node_name)
    end
  end
end

$root_candidate_names.each do |name|
  puts "Root Node: #{name}"
end
