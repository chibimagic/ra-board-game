require 'minitest/autorun'
require_relative '../app/models/game.rb'

class Test < MiniTest::Test
  def test_player_count
    e = assert_raises(RuntimeError) { Game.create_new(['a']) }
    assert_equal("Can only play Ra with 2-5 players", e.message)
    e = assert_raises(RuntimeError) { Game.create_new(['a', 'b', 'c', 'd', 'e', 'f']) }
    assert_equal("Can only play Ra with 2-5 players", e.message)
  end

  def test_game_stage
    g = Game.create_new(['a', 'b'])
    e = assert_raises(RuntimeError) { g.bid(1) }
    assert_equal("Cannot bid when there is no auction", e.message)
  end
end
