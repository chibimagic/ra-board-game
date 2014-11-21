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
    e = assert_raises(RuntimeError) { g.resolve_disaster_tile(FuneralTile, GodTile, GodTile) }
    assert_equal("No disaster to resolve", e.message)
  end

  def test_game_stage_auction
    g = Game.create_new(['a', 'b'])
    g.invoke_ra
    e = assert_raises(RuntimeError) { g.invoke_ra }
    assert_equal("Cannot invoke ra when there is an auction", e.message)
    e = assert_raises(RuntimeError) { g.draw_tile }
    assert_equal("Cannot draw tile when there is an auction", e.message)
    e = assert_raises(RuntimeError) { g.play_god_tile(CivilizationTile) }
    assert_equal("Cannot play god tile when there is an auction", e.message)
    e = assert_raises(RuntimeError) { g.resolve_disaster_tile(FuneralTile, GodTile, GodTile) }
    assert_equal("No disaster to resolve", e.message)
  end
end
