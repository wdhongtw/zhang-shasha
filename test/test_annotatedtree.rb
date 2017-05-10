require 'simpletree'
require 'compare'
require 'test/unit'

class TestAnnotatedTree < Test::Unit::TestCase
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

  def test_constructor
    foo, = create_tree
    AnnotatedTree.new(foo, Node.method(:get_children))
  end

  def test_nodes
    foo, bar = create_tree.map do |tree|
      AnnotatedTree.new(tree, Node.method(:get_children))
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
      AnnotatedTree.new(tree, Node.method(:get_children))
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
      AnnotatedTree.new(tree, Node.method(:get_children))
    end
    assert_equal(foo.keyroots, [2, 4, 5])
    assert_equal(bar.keyroots, [1, 4, 5])
  end
end
