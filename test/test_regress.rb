require 'zss'
require 'test/unit'

class TestRegress < Test::Unit::TestCase
  def test_empty_tree_distance
    assert_equal(ZSS.simple_distance(ZSS::Node.new(''), ZSS::Node.new('')), 0)
    assert_equal(ZSS.simple_distance(ZSS::Node.new('a'), ZSS::Node.new('')), 1)
    assert_equal(ZSS.simple_distance(ZSS::Node.new(''), ZSS::Node.new('b')), 1)
  end

  def test_paper_tree
    foo =
      ZSS::Node.new('f').addkid(
        ZSS::Node.new('d').addkid(
          ZSS::Node.new('a')
        ).addkid(
          ZSS::Node.new('c').addkid(
            ZSS::Node.new('b')
          )
        )
      ).addkid(
        ZSS::Node.new('e')
      )

    bar =
      ZSS::Node.new('f').addkid(
        ZSS::Node.new('c').addkid(
          ZSS::Node.new('d').addkid(
            ZSS::Node.new('a')
          ).addkid(
            ZSS::Node.new('b')
          )
        )
      ).addkid(
        ZSS::Node.new('e')
      )

    assert_equal(ZSS.simple_distance(foo, bar), 2)
  end

  def test_simple_label_change
    foo =
      ZSS::Node.new('f').addkid(
        ZSS::Node.new('a').addkid(
          ZSS::Node.new('h')
        ).addkid(
          ZSS::Node.new('c').addkid(
            ZSS::Node.new('l')
          )
        )
      ).addkid(
        ZSS::Node.new('e')
      )

    bar =
      ZSS::Node.new('f').addkid(
        ZSS::Node.new('a').addkid(
          ZSS::Node.new('d')
        ).addkid(
          ZSS::Node.new('r').addkid(
            ZSS::Node.new('b')
          )
        )
      ).addkid(
        ZSS::Node.new('e')
      )

    assert_equal(ZSS.simple_distance(foo, bar), 3)
  end

  def test_incorrect_behavior_regression
    foo =
      ZSS::Node.new('a').addkid(
        ZSS::Node.new('b').addkid(
          ZSS::Node.new('x')
        ).addkid(
          ZSS::Node.new('y')
        )
      )

    bar =
      ZSS::Node.new('a').addkid(
        ZSS::Node.new('x')
      ).addkid(
        ZSS::Node.new('b').addkid(
          ZSS::Node.new('y')
        )
      )

    assert_equal(ZSS.simple_distance(foo, bar), 2)
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

    dist = ZSS.simple_distance(
      foo,
      bar,
      get_children,
      get_label,
      label_dist
    )
    assert_equal(dist, 1)
  end
end
