require 'simpletree'
require 'compare'
require 'test/unit'

class TestRegress < Test::Unit::TestCase
  def test_empty_tree_distance
    assert_equal(simple_distance(Node.new(''), Node.new('')), 0)
    assert_equal(simple_distance(Node.new('a'), Node.new('')), 1)
    assert_equal(simple_distance(Node.new(''), Node.new('b')), 1)
  end

  def test_paper_tree
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

    assert_equal(simple_distance(foo, bar), 2)
  end

  def test_simple_label_change
    foo =
      Node.new('f').addkid(
        Node.new('a').addkid(
          Node.new('h')
        ).addkid(
          Node.new('c').addkid(
            Node.new('l')
          )
        )
      ).addkid(
        Node.new('e')
      )

    bar =
      Node.new('f').addkid(
        Node.new('a').addkid(
          Node.new('d')
        ).addkid(
          Node.new('r').addkid(
            Node.new('b')
          )
        )
      ).addkid(
        Node.new('e')
      )

    assert_equal(simple_distance(foo, bar), 3)
  end

  def test_incorrect_behavior_regression
    foo =
      Node.new('a').addkid(
        Node.new('b').addkid(
          Node.new('x')
        ).addkid(
          Node.new('y')
        )
      )

    bar =
      Node.new('a').addkid(
        Node.new('x')
      ).addkid(
        Node.new('b').addkid(
          Node.new('y')
        )
      )

    assert_equal(simple_distance(foo, bar), 2)
  end

  def test_hash
    foo = {
      'name' => 'tree',
      'children' => [
        { 'name' => 'child 1' },
        { 'name' => 'child 2' }
      ]
    }
    bar = {
      'name' => 'tree',
      'children' => [
        { 'name' => 'child 1' },
        { 'name' => 'child Z' }
      ]
    }

    get_children = lambda do |node|
      if node.key? 'children'
        node['children']
      else
        []
      end
    end
    get_label = ->(node) { node['name'] }
    label_dist = ->(label_a, label_b) { label_a == label_b ? 0 : 1 }

    dist = simple_distance(
      foo,
      bar,
      get_children,
      get_label,
      label_dist
    )
    assert_equal(dist, 1)
  end
end
