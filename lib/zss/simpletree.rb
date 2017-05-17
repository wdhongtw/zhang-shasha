# Namespace for this gem
module ZSS
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

    # @param label [String] label of this node
    # @param children [Array] list of children nodes
    def initialize(label, children = nil)
      @label = label
      @children = children || []
    end

    # Add a child node to this node
    # @param child [Node] child node to be added
    def addkid(child, before = false)
      if before
        @children.unshift child
      else
        @children.push child
      end
      self
    end

    # Get a node with label in this subtree
    # This function is not used in tree edit distance algorithm
    # @param label [String] label to be search in this subtree
    # @return [Node, nil] Node with specified label
    def get(label)
      return self if @label == label
      @children.each do |child|
        return child.get(label) if child.get(label)
      end
      nil
    end
  end
end
