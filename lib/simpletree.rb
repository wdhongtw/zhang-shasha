# A simple node class that can be used to construct trees
class Node
  def self.get_children(node)
    node.children
  end

  def self.get_label(node)
    node.label
  end

  attr_accessor :label

  attr_accessor :children

  def initialize(label, children = nil)
    @label = label
    @children = children || []
  end

  def addkid(child, before = false)
    if before
      @children.unshift child
    else
      @children.push child
    end
    self
  end

  def get(label)
    return self if @label == label
    @children.each do |child|
      return child.get(label) if child.get(label)
    end
    nil
  end
end
