require './lib/simpletree'

# Tree wrapper for tree edit distance algorithm
class AnnotatedTree
  attr_accessor :nodes

  attr_accessor :ids

  attr_accessor :lmds

  attr_accessor :keyroots

  def initialize(root, get_children)
    @root = root
    @get_children = get_children

    # Post-order enumeration of the nodes in the tree
    @nodes = []
    # Matching list of ids
    @ids = []
    # Left most descendents
    @lmds = []
    @keyroots = nil

    stack = []
    pstack = []
    stack.push([root, []])
    j = 0
    until stack.empty?
      n, anc = stack.pop
      nid = j
      @get_children.call(n).each do |c|
        a = Array.new(anc)
        a.unshift(nid)
        stack.push([c, a])
      end
      pstack.push([n, nid, anc])
      j += 1
    end

    lmds = {}
    keyroots = {}
    i = 0
    until pstack.empty?
      n, nid, anc = pstack.pop
      @nodes.push(n)
      @ids.push(nid)
      if @get_children.call(n).empty?
        lmd = i
        anc.each do |a|
          break if lmds.key? a
          lmds[a] = i
        end
      else
        lmd = lmds[nid]
      end

      @lmds.push(lmd)
      keyroots[lmd] = i
      i += 1
    end

    @keyroots = keyroots.values.sort
  end
end

def bool_dist(foo, bar)
  foo == bar ? 0 : 1
end

# Compute tree edit distance between tree foo and tree bar
def simple_distance(
  foo,
  bar,
  get_children = Node.method(:get_children),
  get_label = Node.method(:get_label),
  label_dist = Kernel.method(:bool_dist)
)
  insert = ->(node_bar) { label_dist.call('', get_label.call(node_bar)) }
  remove = ->(node_foo) { label_dist.call(get_label.call(node_foo), '') }
  update = lambda do |node_foo, node_bar|
    label_dist.call(get_label.call(node_foo), get_label.call(node_bar))
  end

  distance(
    foo,
    bar,
    get_children,
    insert,
    remove,
    update
  )
end

def distance(foo, bar, get_children, insert_cost, remove_cost, update_cost)
  foo = AnnotatedTree.new(foo, get_children)
  bar = AnnotatedTree.new(bar, get_children)
  treedists = Array.new(foo.nodes.size) { Array.new(bar.nodes.size) { 0 } }

  treedist = lambda do |i, j|
    fool = foo.lmds
    barl = bar.lmds
    foon = foo.nodes
    barn = bar.nodes

    m = i - fool[i] + 2
    n = j - barl[j] + 2
    fd = Array.new(m) { Array.new(n) { 0 } }

    ioff = fool[i] - 1
    joff = barl[j] - 1

    (1...m).each do |x|
      fd[x][0] = fd[x - 1][0] + remove_cost.call(foon[x + ioff])
    end
    (1...n).each do |y|
      fd[0][y] = fd[0][y - 1] + insert_cost.call(barn[y + joff])
    end
    (1...m).each do |x|
      (1...n).each do |y|
        if fool[i] == fool[x + ioff] && barl[j] == barl[y + joff]
          fd[x][y] = [
            fd[x - 1][y] + remove_cost.call(foon[x + ioff]),
            fd[x][y - 1] + insert_cost.call(barn[y + joff]),
            fd[x - 1][y - 1] + update_cost.call(foon[x + ioff], barn[y + joff])
          ].min
          treedists[x + ioff][y + joff] = fd[x][y]
        else
          pi = fool[x + ioff] - 1 - ioff
          qi = barl[y + joff] - 1 - joff
          fd[x][y] = [
            fd[x - 1][y] + remove_cost.call(foon[x + ioff]),
            fd[x][y - 1] + insert_cost.call(barn[y + joff]),
            fd[pi][qi] + treedists[x + ioff][y + joff]
          ].min
        end
      end
    end
  end # end lambda treedist

  foo.keyroots.each do |i|
    bar.keyroots.each do |j|
      treedist.call(i, j)
    end
  end
  treedists[-1][-1]
end
