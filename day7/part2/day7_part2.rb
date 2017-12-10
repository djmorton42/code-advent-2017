require 'byebug'
require 'set'

LINE_PATTERN = %r(([a-z]+)\s\(([0-9]+)\)(\s\->\s([a-z, ]+))?)
$root_candidate_nodes = {}
$root_candidate_names = Set.new
$nodes = {}

class Node
  attr_reader :name, :weight, :children, :children_names

  def initialize(name, weight, children_names)
    @name = name
    @weight = weight
    @children_names = children_names.nil? ? nil : children_names.split(",").map { |name| name.strip }
    @children = []
  end

  def node_weight
    if children.size == 0
      @weight
    else
      sum = @weight
      children.each do |child|
        sum += child.node_weight
      end

      sum
    end
  end

  def is_balanced
    return true if children.size == 0

    child_node_weight = nil

    children.each do |child|
      if child_node_weight.nil?
        child_node_weight = child.node_weight
      else
        return false if child_node_weight != child.node_weight
      end
    end

    return true
  end

  def unbalanced_node
    return nil if children.size == 0

    child_node_weights = []
    child_node_weight_frequency = Hash.new(0)
    child_node_weight_map = {}

    children.each do |child|
      child_node_weight = child.node_weight

      child_node_weight_map[child] = child_node_weight

      child_node_weights << child_node_weight

      child_node_weight_frequency[child_node_weight] += 1
    end

    unbalanced_node_weight = nil
    child_node_weight_frequency.each do |weight, frequency|
      unbalanced_node_weight = weight if frequency == 1
    end

    unbalanced_node = nil

    child_node_weight_map.each do |node, weight|
      unbalanced_node = node if weight == unbalanced_node_weight
    end

    return unbalanced_node
  end

  def get_correct_weight
    return nil if @children.size == 0

    weights = Set.new()

    @children.each do |child|
      child_node_weight = child.node_weight
      if weights.include?(child_node_weight)
        return child_node_weight
      else
        weights << child_node_weight
      end
    end
  end
end

def parse_line(line)
  match_data = LINE_PATTERN.match(line)

  node = Node.new(match_data[1], match_data[2].to_i, match_data[4])

  $nodes[node.name] = node
  unless match_data[3].nil?
    $root_candidate_names << match_data[1]
    $root_candidate_nodes[match_data[1]] = node
  end
end

def get_root_node
  $nodes.values.each do |node|
    unless node.children_names.nil?
      node.children_names.each do |child_node_name|
        $root_candidate_names.delete(child_node_name)
      end
    end
  end

  if $root_candidate_names.size == 1
    return $root_candidate_nodes[$root_candidate_names.first]
  else
    puts "Could not find a single root node!"
    exit
  end
end

def build_tree(node)
  return if node.children_names.nil?
  node.children_names.each do |child_name|
    child_node = $nodes[child_name]
    node.children << child_node
    build_tree(child_node)
  end
end

File.open('input.txt') do |file|
  file.each_line do |line|
    parse_line(line)
  end
end

root_node = get_root_node
build_tree(root_node)

node = root_node
parent_node = nil

while true do
  if node.is_balanced
    correct_weight = parent_node.get_correct_weight
    actual_weight = parent_node.unbalanced_node.node_weight

    weight_delta = correct_weight - actual_weight

    puts "Correct Node Weight: #{node.weight + weight_delta}"

    exit
  else

    parent_node = node
    node = node.unbalanced_node
  end
end



