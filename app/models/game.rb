class Game
  attr_accessor \
    :player_count,
    :current_player,
    :auction_count,
    :auction_tiles

  def initialize(
    player_count,
    current_player,
    auction_count,
    auction_tiles
  )
    raise 'Invalid player count' unless [3, 4, 5].include?(player_count)
    raise 'Invalid current player' unless (1..player_count).include?(current_player)
    raise 'Invalid auction_count' unless (0..10).include?(auction_count)
    raise 'Invalid auction_tiles' unless auction_tiles.is_a?(Array) && auction_tiles.all? { |tile| tile.is_a?(Tile) }

    @player_count = player_count
    @current_player = current_player
    @auction_count = auction_count
    @auction_tiles = auction_tiles
  end

  def self.create_new(player_count)
    current_player = 1
    auction_count = 0
    auction_tiles = []

    new(
      player_count,
      current_player,
      auction_count,
      auction_tiles
    )
  end
end
