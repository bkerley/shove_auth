require 'test_helper'

class NonceTest < ActiveSupport::TestCase
  def setup
    @n = Nonce.new
    @n.save
  end
  
  def test_creation_generators
    assert_not_nil @n.nonce
    assert_not_nil @n.sid
    assert_in_delta @n.nonce.length, 40, 2
    assert_in_delta @n.sid.length, 40, 2
  end
end
