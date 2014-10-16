class Auction
  attr_reader :voluntary, :ra_player, :bids

  def initialize(voluntary, ra_player, bids)
    raise 'Invalid voluntary' unless [true, false].include?(voluntary)
    raise 'Invalid ra player' unless ra_player.is_a?(Integer)
    raise 'Invalid bids' unless bids.is_a?(Array) and bids.all? { |bid| bid.is_a?(Integer) || bid.nil? }

    @voluntary = voluntary
    @ra_player = ra_player
    @bids = bids
  end

  def self.create_new(voluntary, ra_player, player_count)
    bids = Array.new(player_count)

    new(voluntary, ra_player, bids)
  end
end
