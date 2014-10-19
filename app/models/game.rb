class Game
  attr_accessor \
    :players,
    :current_player,
    :epoch,
    :auction,
    :auction_count,
    :auction_tiles,
    :draw_tiles

  SUN_DISTRIBUTION = {
    2 => [
      [9, 6, 5, 2],
      [8, 7, 4, 3]
    ],
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

  TILE_TYPES = {
    RaTile => 30,

    AnubisGodTile => 1,
    BastetGodTile => 1,
    ChnumGodTile => 1,
    HorusGodTile => 1,
    SethGodTile => 1,
    SobekGodTile => 1,
    ThothGodTile => 1,
    UtGodTile => 1,

    PharoahTile => 25,
    NileTile => 25,
    FloodTile => 12,

    ArtCivilizationTile => 5,
    AgricultureCivilizationTile => 5,
    ReligionCivilizationTile => 5,
    AstronomyCivilizationTile => 5,
    WritingCivilizationTile => 5,

    GoldTile => 5,

    FortressMonumentTile => 5,
    ObeliskMonumentTile => 5,
    PalaceMonumentTile => 5,
    PyramidMonumentTile => 5,
    SphinxMonumentTile => 5,
    StatuesMonumentTile => 5,
    StepPyramidMonumentTile => 5,
    TemplateMonumentTile => 5,

    FuneralTile => 2,
    DroughtTile => 2,
    UnrestTile => 4,
    EarthquakeTile => 2
  }

  def initialize(
    players,
    current_player,
    epoch,
    auction,
    auction_count,
    auction_tiles,
    draw_tiles
  )
    raise 'Invalid players' unless players.is_a?(Array) && players.all? { |player| player.is_a?(Player) }
    raise 'Invalid current player' unless (1..players.count).include?(current_player)
    raise 'Invalid epoch' unless (1..3).include?(epoch)
    raise 'Invalid auction' unless auction.is_a?(Auction) || auction.nil?
    raise 'Invalid auction count' unless (0..10).include?(auction_count)
    raise 'Invalid auction tiles' unless auction_tiles.is_a?(Array) && auction_tiles.all? { |tile| tile.is_a?(Tile) }
    raise 'Invalid draw tiles' unless draw_tiles.is_a?(Array) && draw_tiles.all? { |tile| tile.is_a?(Tile) }

    @player_count = player_count
    @current_player = current_player
    @epoch = epoch
    @auction = auction
    @auction_count = auction_count
    @auction_tiles = auction_tiles
    @draw_tiles = draw_tiles
  end

  def self.create_new(player_names)
    unless (2..5).include?(player_names.length)
      raise 'Can only play Ra with 2-5 players'
    end

    sun_values = SUN_DISTRIBUTION.fetch(player_count).shuffle
    players = player_names.map.with_index do |name, i|
      suns = sun_values[i].map { |value| Sun.create_new(value) }
      Player.new(name, suns, [])
    end

    highest_sun = sun_values.flatten.max
    current_player = players.find_index { |player| player.suns.find { |sun| sun.value == highest_sun } }

    epoch = 1
    auction = nil
    auction_count = 0
    auction_tiles = []
    draw_tiles = TILE_TYPES.map { |tile_class, number| Array.new(number) { tile_class.new } }.flatten.shuffle

    new(
      players,
      current_player,
      epoch,
      auction,
      auction_count,
      auction_tiles,
      draw_tiles
    )
  end

  def next_players_turn
    @players.rotate(current_player + 1).each do |potential_player|
      if potential_player.has_unused_suns
        @current_player = @players.find_index { |player| player == potential_player }
        return
      end
    end
    end_epoch
  end

  def end_epoch
  end

  def draw_tile
    tile = @draw_tiles.pop
    if tile < RaTile
      @auction_count++
      @auction = Auction.create_new(false, current_player, Array.new(@players.count, nil))
    else
      @auction_tiles.push(tile)
    end
  end
end
