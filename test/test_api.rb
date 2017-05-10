require 'zss'
require 'test/unit'

class TestApi < Test::Unit::TestCase
  def create_tree
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

    [foo, bar]
  end

  def test_simple_distance
    foo, bar = create_tree

    dist = ZSS.simple_distance(
      foo, bar, ZSS::Node.method(:get_children), ZSS::Node.method(:get_label),
      ZSS.method(:bool_dist)
    )
    assert_equal(dist, 2)
  end

  def test_distance
    insert_cost = ->(_) { 1 }
    remove_cost = ->(_) { 1 }
    small_update_cost = ->(_, _) { 1 }
    large_update_cost = ->(_, _) { 3 }
    no_insert_cost = ->(_) { 0 }

    tree_a = ZSS::Node.new('a')
    tree_b = ZSS::Node.new('b')
    tree_c = ZSS::Node.new('a', [ZSS::Node.new('x')])

    assert(
      ZSS.distance(
        tree_a, tree_b, ZSS::Node.method(:get_children),
        insert_cost, remove_cost, small_update_cost
      ) == 1
    )
    assert(
      ZSS.distance(
        tree_a, tree_b, ZSS::Node.method(:get_children),
        insert_cost, remove_cost, large_update_cost
      ) == 2
    )
    assert(
      ZSS.distance(
        tree_a, tree_c, ZSS::Node.method(:get_children),
        insert_cost, remove_cost, small_update_cost
      ) > ZSS.distance(
        tree_a, tree_c, ZSS::Node.method(:get_children),
        no_insert_cost, remove_cost, small_update_cost
      )
    )
  end
end
