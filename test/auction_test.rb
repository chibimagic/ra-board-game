class AuctionTest < MiniTest::Test
  def test_winner
    a = Auction.create_new(true, 1, 3)
    a.bid(1, 1)
    a.bid(2, 2)
    a.bid(3, 3)
    assert_equal(3, a.winner)
  end

  def test_incomplete
    a = Auction.create_new(true, 1, 3)
    e = assert_raises(RuntimeError) { a.winner }
    assert_equal("Not everyone has bid yet", e.message)
  end

  def test_lower_bid
    a = Auction.create_new(true, 1, 3)
    a.bid(1, 3)
    e = assert_raises(RuntimeError) { a.bid(2, 2) }
    assert_equal("Bid must be higher than 3", e.message)
  end

  def test_rebid
    a = Auction.create_new(true, 1, 3)
    a.bid(1, 1)
    e = assert_raises(RuntimeError) { a.bid(1, 2) }
    assert_equal("Player 1 has already bid 1", e.message)
  end

  def test_force_bid
    a1 = Auction.create_new(false, 3, 3)
    a1.bid(1, nil)
    a1.bid(2, nil)
    a1.bid(3, nil)
    a2 = Auction.create_new(true, 3, 3)
    a2.bid(1, nil)
    a2.bid(2, nil)
    e = assert_raises(RuntimeError) { a2.bid(3, nil) }
    assert_equal("For voluntarily invoked auctions, the Ra player must bid if all other players pass", e.message)
  end
end
