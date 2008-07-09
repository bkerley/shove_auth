require 'test_helper'

class NonceTest < ActiveSupport::TestCase
  def setup
    @n = Nonce.new
  end
  
  def test_creation_generators
    assert_not_nil @n.nonce
    assert_not_nil @n.sid
    assert_not_equal @n.nonce, ''
    assert_not_equal @n.sid, ''
  end
end
