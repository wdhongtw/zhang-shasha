require 'simpletree'
require 'compare'
require 'test/unit'

class TestApi < Test::Unit::TestCase
  def create_tree
    foo =
      Node.new('f').addkid(
        Node.new('d').addkid(
          Node.new('a')
        ).addkid(
          Node.new('c').addkid(
            Node.new('b')
          )
        )
      ).addkid(
        Node.new('e')
      )

    bar =
      Node.new('f').addkid(
        Node.new('c').addkid(
          Node.new('d').addkid(
            Node.new('a')
          ).addkid(
            Node.new('b')
          )
        )
      ).addkid(
        Node.new('e')
      )

    [foo, bar]
  end

  def test_simple_distance
    foo, bar = create_tree

    dist = simple_distance(
      foo, bar, Node.method(:get_children), Node.method(:get_label),
      Kernel.method(:bool_dist)
    )
    assert_equal(dist, 2)
  end

  def test_distance
    insert_cost = ->(_) { 1 }
    remove_cost = ->(_) { 1 }
    small_update_cost = ->(_, _) { 1 }
    large_update_cost = ->(_, _) { 3 }
    no_insert_cost = ->(_) { 0 }

    tree_a = Node.new('a')
    tree_b = Node.new('b')
    tree_c = Node.new('a', [Node.new('x')])

    assert(
      distance(
        tree_a, tree_b, Node.method(:get_children),
        insert_cost, remove_cost, small_update_cost
      ) == 1
    )
    assert(
      distance(
        tree_a, tree_b, Node.method(:get_children),
        insert_cost, remove_cost, large_update_cost
      ) == 2
    )
    assert(
      distance(
        tree_a, tree_c, Node.method(:get_children),
        insert_cost, remove_cost, small_update_cost
      ) > distance(
        tree_a, tree_c, Node.method(:get_children),
        no_insert_cost, remove_cost, small_update_cost
      )
    )
  end
end
