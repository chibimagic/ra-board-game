class GameTest < MiniTest::Test
  def setup
    @g = Game.create_new(['a', 'b'])
  end

  def test_player_count
    e = assert_raises(RuntimeError) { Game.create_new(['a']) }
    assert_equal("Can only play Ra with 2-5 players", e.message)
    e = assert_raises(RuntimeError) { Game.create_new(['a', 'b', 'c', 'd', 'e', 'f']) }
    assert_equal("Can only play Ra with 2-5 players", e.message)
  end

  def test_stage
    e = assert_raises(RuntimeError) { @g.bid(1) }
    assert_equal("Cannot bid when there is no auction", e.message)
    e = assert_raises(RuntimeError) { @g.resolve_disaster_tile(FuneralTile, GodTile, GodTile) }
    assert_equal("No disaster to resolve", e.message)
  end

  def test_stage_auction
    @g.invoke_ra
    e = assert_raises(RuntimeError) { @g.invoke_ra }
    assert_equal("Cannot invoke ra when there is an auction", e.message)
    e = assert_raises(RuntimeError) { @g.draw_tile }
    assert_equal("Cannot draw tile when there is an auction", e.message)
    e = assert_raises(RuntimeError) { @g.play_god_tile(CivilizationTile) }
    assert_equal("Cannot play god tile when there is an auction", e.message)
    e = assert_raises(RuntimeError) { @g.resolve_disaster_tile(FuneralTile, GodTile, GodTile) }
    assert_equal("No disaster to resolve", e.message)
  end

  def test_stage_disaster
    @g.draw_tile(FuneralTile)
    sun_value = @g.players[@g.current_player].suns.first.value
    @g.invoke_ra
    @g.bid(nil)
    @g.bid(sun_value)
    e = assert_raises(RuntimeError) { @g.invoke_ra }
    assert_equal("Cannot invoke ra when there are disasters to resolve", e.message)
    e = assert_raises(RuntimeError) { @g.draw_tile }
    assert_equal("Cannot draw tile when there are disasters to resolve", e.message)
    e = assert_raises(RuntimeError) { @g.play_god_tile(CivilizationTile) }
    assert_equal("Cannot play god tile when there are disasters to resolve", e.message)
  end

  def test_auction_creation
    assert_equal(nil, @g.auction)
    @g.draw_tile(RaTile)
    assert_instance_of(Auction, @g.auction)
  end

  def test_bid_nonexistent_sun
    @g.invoke_ra
    e = assert_raises(RuntimeError) { @g.bid(1) }
    assert_equal("Player does not have sun with value 1", e.message)
  end

  def test_bid_used_sun
    @g.invoke_ra
    sun1_value = @g.players[@g.current_player].suns.first.value
    @g.bid(sun1_value)
    sun2_value = @g.players[@g.current_player].suns.first.value
    @g.bid(sun2_value)
    @g.invoke_ra
    e = assert_raises(RuntimeError) { @g.bid(1) }
    assert_equal("Sun with value 1 has already been used", e.message)
  end

  def test_god_tile
    @g.draw_tile(GoldTile)
    tile_class = @g.auction_tiles[0].class
    player_tiles = @g.players[@g.current_player].tiles
    player_tiles.push(GodTile.new)
    @g.play_god_tile(tile_class)
    assert_equal([], @g.auction_tiles)
    assert_equal(1, player_tiles.count)
    assert_instance_of(tile_class, player_tiles[0])
  end

  def test_god_tile_for_god_tile
    @g.draw_tile(GodTile)
    @g.players[@g.current_player].tiles.push(GodTile.new)
    e = assert_raises(RuntimeError) { @g.play_god_tile(GodTile) }
    assert_equal("Cannot use god tile to take god tile", e.message)
  end

  def test_god_tile_no_available_tile
    @g.draw_tile(CivilizationTile)
    @g.players[@g.current_player].tiles.push(GodTile.new)
    e = assert_raises(RuntimeError) { @g.play_god_tile(NileTile) }
    assert_equal("No Nile tile available in the auction track", e.message)
  end

  def test_end_epoch_auctions
    5.times do
      @g.draw_tile(RaTile)
      @g.bid(nil)
      @g.bid(nil)
    end
    @g.draw_tile(RaTile)
    assert_equal(2, @g.epoch)
  end

  def test_end_epoch_suns
    8.times do
      max_unused_sun = @g.players[@g.current_player].suns.map { |sun| sun.used ? nil : sun.value }.compact.max
      @g.invoke_ra
      unless @g.auction.ra_player == @g.current_player
        @g.bid(nil)
      end
      @g.bid(max_unused_sun)
    end
    assert_equal(2, @g.epoch)
  end

  def test_disaster_tile
    assert_equal(0, @g.disasters_to_resolve)
    @g.draw_tile(FuneralTile)
    assert_equal(0, @g.disasters_to_resolve)
    max_sun = @g.players[@g.current_player].max_sun
    @g.invoke_ra
    @g.bid(nil)
    @g.bid(max_sun)
    assert_equal(1, @g.disasters_to_resolve)
    @g.resolve_disaster_tile(FuneralTile, nil, nil)
    assert_equal(0, @g.disasters_to_resolve)
  end

  def test_disaster_tile_class
    @g.draw_tile(FuneralTile)
    @g.invoke_ra
    @g.bid(nil)
    @g.bid(@g.players[@g.current_player].suns[0].value)
    e = assert_raises(RuntimeError) { @g.resolve_disaster_tile(PharaohTile, nil, nil) }
    assert_equal("Pharaoh tile is not a disaster tile", e.message)
  end
end
