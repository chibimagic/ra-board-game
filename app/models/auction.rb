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
end
