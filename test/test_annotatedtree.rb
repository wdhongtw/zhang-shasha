require 'zss'
require 'test/unit'

class TestAnnotatedTree < Test::Unit::TestCase
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

  def test_constructor
    foo, = create_tree
    ZSS::AnnotatedTree.new(foo, ZSS::Node.method(:get_children))
  end

  def test_nodes
    foo, bar = create_tree.map do |tree|
      ZSS::AnnotatedTree.new(tree, ZSS::Node.method(:get_children))
    end

    foo.ids.reverse.each_with_index do |i, nid|
      assert_equal(nid, i)
    end
    bar.ids.reverse.each_with_index do |i, nid|
      assert_equal(nid, i)
    end
  end

  def test_left_most_descendent
    foo, bar = create_tree.map do |tree|
      ZSS::AnnotatedTree.new(tree, ZSS::Node.method(:get_children))
    end

    assert_equal(foo.lmds[0], 0)
    assert_equal(foo.lmds[1], 1)
    assert_equal(foo.lmds[2], 1)
    assert_equal(foo.lmds[3], 0)
    assert_equal(foo.lmds[4], 4)
    assert_equal(foo.lmds[5], 0)
    assert_equal(bar.lmds[0], 0)
    assert_equal(bar.lmds[1], 1)
    assert_equal(bar.lmds[2], 0)
    assert_equal(bar.lmds[3], 0)
    assert_equal(bar.lmds[4], 4)
    assert_equal(bar.lmds[5], 0)
  end

  def test_keyroots
    foo, bar = create_tree.map do |tree|
      ZSS::AnnotatedTree.new(tree, ZSS::Node.method(:get_children))
    end
    assert_equal(foo.keyroots, [2, 4, 5])
    assert_equal(bar.keyroots, [1, 4, 5])
  end
end
