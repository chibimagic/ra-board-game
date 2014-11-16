require 'minitest/autorun'
require_relative '../app/models/game.rb'

class Test < MiniTest::Test
  def test_game_stage
    g = Game.create_new(['a', 'b'])
    e = assert_raises(RuntimeError) { g.bid(1) }
    assert_equal("Cannot bid when there is no auction", e.message)
  end
end
