require 'minitest/autorun'
require_relative '../app/models/game.rb'

class Test < MiniTest::Test
  def test_game_stage
    g = Game.create_new(['a', 'b'])
    assert_raises(RuntimeError) { g.bid(1) }
  end
end
