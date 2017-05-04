require './lib/simpletree'
require 'test/unit'

class TestSimpleTree < Test::Unit::TestCase
  def test_node_construct
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

    assert_not_nil(foo.get('a'))
    assert_not_nil(foo.get('b'))
    assert_not_nil(foo.get('c'))
    assert_not_nil(foo.get('d'))
    assert_not_nil(foo.get('e'))
    assert_not_nil(foo.get('f'))
    assert_equal(foo.get('a').label, 'a')
    assert_equal(foo.get('b').label, 'b')
    assert_equal(foo.get('c').label, 'c')
    assert_equal(foo.get('d').label, 'd')
    assert_equal(foo.get('e').label, 'e')
    assert_equal(foo.get('f').label, 'f')
    assert_equal(foo.get('d').children[0].label, 'a')
    assert_equal(foo.get('d').children[1].label, 'c')
    assert_equal(bar.children[0].label, 'c')
    assert_equal(foo.children[1].label, 'e')
    assert_equal(foo.get('sometag'), nil)
    assert_equal(foo.get(:somesymbol), nil)
  end
end
