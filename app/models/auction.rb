class Auction
  attr_reader :voluntary, :ra_player, :player_count, :bids

  def initialize(voluntary, ra_player, player_count, bids)
    raise 'Invalid voluntary' unless [true, false].include?(voluntary)
    raise 'Invalid ra player' unless ra_player.is_a?(Integer)
    raise 'Invalid player count' unless player_count.is_a?(Integer)
    raise 'Invalid bids' unless bids.is_a?(Hash) and bids.keys.all? { |bidder| bidder.is_a?(Integer) } and bids.values.all? { |value| value.is_a?(Integer) || value.nil? }

    @voluntary = voluntary
    @ra_player = ra_player
    @player_count = player_count
    @bids = bids
  end

  def self.create_new(voluntary, ra_player, player_count)
    bids = {}

    new(voluntary, ra_player, player_count, bids)
  end

  def max_bid
    @bids.values.max
  end

  def winner
    unless bids.count == player_count
      raise 'Not everyone has bid yet'
    end

    @bids.key(max_bid)
  end

  def bid(player_index, bid)
    if !bid.nil? && bid < max_bid
      raise 'Bid must be higher than ' + max_bid.to_s
    end

    if @bids.has_key?(player_index)
      raise 'Player ' + player_index.to_s + ' has already bid ' + @bids.fetch(player_index).to_s
    end

    if bid.nil? && player_index == ra_player && @voluntary && @bids.values.all? { |value| value.nil? }
      raise 'For voluntarily invoked auctions, the ra player must bid if all other players pass'
    end

    @bids[player_index] = bid
  end
end
