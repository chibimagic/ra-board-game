class Auction
  attr_reader :voluntary, :ra_player, :participating_player_count, :bids

  def initialize(voluntary, ra_player, participating_player_count, bids)
    raise 'Invalid voluntary' unless [true, false].include?(voluntary)
    raise 'Invalid ra player' unless ra_player.is_a?(Integer)
    raise 'Invalid participating player count' unless participating_player_count.is_a?(Integer)
    raise 'Invalid bids' unless bids.is_a?(Hash) and bids.keys.all? { |bidder| bidder.is_a?(Integer) } and bids.values.all? { |value| value.is_a?(Integer) || value.nil? }

    @voluntary = voluntary
    @ra_player = ra_player
    @participating_player_count = participating_player_count
    @bids = bids
  end

  def self.create_new(voluntary, ra_player, participating_player_count)
    bids = {}

    new(voluntary, ra_player, participating_player_count, bids)
  end

  def max_bid
    @bids.values.compact.max
  end

  def all_bids_in?
    bids.count == @participating_player_count
  end

  def winner
    unless all_bids_in?
      raise 'Not everyone has bid yet'
    end

    max_bid.nil? ? nil : @bids.key(max_bid)
  end

  def bid(player_index, bid)
    if !bid.nil? && !max_bid.nil? && bid < max_bid
      raise 'Bid must be higher than ' + max_bid.to_s
    end

    if @bids.has_key?(player_index)
      raise 'Player ' + player_index.to_s + ' has already bid ' + @bids.fetch(player_index).to_s
    end

    if bid.nil? && player_index == ra_player && @voluntary && @bids.values.all? { |value| value.nil? }
      raise 'For voluntarily invoked auctions, the Ra player must bid if all other players pass'
    end

    @bids[player_index] = bid
  end
end
