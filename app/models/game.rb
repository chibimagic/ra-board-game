class Game
  attr_accessor \
    :players,
    :current_player,
    :auction_count,
    :auction_tiles

  SUN_DISTRIBUTION = {
    3 => [
      [13, 8, 5, 2],
      [12, 9, 6, 3],
      [11, 10, 7, 4]
    ],
    4 => [
      [13, 6, 2],
      [12, 7, 3],
      [11, 8, 4],
      [10, 9, 5]
    ],
    5 => [
      [16, 7, 2],
      [15, 8, 3],
      [14, 9, 4],
      [13, 10, 5],
      [12, 11, 6]
    ]
  }

  def initialize(
    players,
    current_player,
    auction_count,
    auction_tiles
  )
    raise 'Invalid players' unless players.is_a?(Array) && players.all? { |player| player.is_a?(Player) }
    raise 'Invalid current player' unless (1..players.count).include?(current_player)
    raise 'Invalid auction_count' unless (0..10).include?(auction_count)
    raise 'Invalid auction_tiles' unless auction_tiles.is_a?(Array) && auction_tiles.all? { |tile| tile.is_a?(Tile) }

    @player_count = player_count
    @current_player = current_player
    @auction_count = auction_count
    @auction_tiles = auction_tiles
  end

  def self.create_new(player_names)
    unless [3, 4, 5].include?(player_names.length)
      raise 'Can only play Ra with 3-5 players'
    end

    sun_values = SUN_DISTRIBUTION.fetch(player_count).shuffle
    players = player_names.map.with_index do |name, i|
      suns = sun_values[i].map { |value| Sun.create_new(value) }
      Player.new(name, suns, [])
    end

    highest_sun = sun_values.flatten.max
    current_player = players.find_index { |player| player.suns.find { |sun| sun.value == highest_sun } }

    auction_count = 0
    auction_tiles = []

    new(
      players,
      current_player,
      auction_count,
      auction_tiles
    )
  end
end
