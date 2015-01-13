require_relative 'auction.rb'
require_relative 'player.rb'
require_relative 'tile.rb'
require_relative 'sun.rb'

class Game
  attr_accessor \
    :players,
    :current_player,
    :epoch,
    :center_sun,
    :auction,
    :auction_count,
    :auction_tiles,
    :draw_tiles,
    :disasters_to_resolve,
    :winner

  MAX_AUCTIONS = {
    2 => 6,
    3 => 8,
    4 => 9,
    5 => 10
  }

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

    PharaohTile => 25,
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
    TempleMonumentTile => 5,

    FuneralTile => 2,
    DroughtTile => 2,
    UnrestTile => 4,
    EarthquakeTile => 2
  }

  CIVILIZATION_POINTS = {
    3 => 5,
    4 => 10,
    5 => 15
  }

  MONUMENT_DIFFERENT_POINTS = {
    1 => 1,
    2 => 2,
    3 => 3,
    4 => 4,
    5 => 5,
    6 => 6,
    7 => 10,
    8 => 15
  }

  MONUMENT_IDENTICAL_POINTS = {
    3 => 5,
    4 => 10,
    5 => 15
  }

  def initialize(
    players,
    current_player,
    epoch,
    center_sun,
    auction,
    auction_count,
    auction_tiles,
    draw_tiles,
    disasters_to_resolve,
    winner
  )
    raise 'Invalid players' unless players.is_a?(Array) && players.all? { |player| player.is_a?(Player) }
    raise 'Invalid current player' unless (0..players.count - 1).include?(current_player)
    raise 'Invalid epoch' unless (1..3).include?(epoch)
    raise 'Invalid center sun' unless center_sun.is_a?(Sun)
    raise 'Invalid auction' unless auction.is_a?(Auction) || auction.nil?
    raise 'Invalid auction count' unless (0..10).include?(auction_count)
    raise 'Invalid auction tiles' unless auction_tiles.is_a?(Array) && auction_tiles.all? { |tile| tile.is_a?(Tile) }
    raise 'Invalid draw tiles' unless draw_tiles.is_a?(Array) && draw_tiles.all? { |tile| tile.is_a?(Tile) }
    raise 'Invalid disasters to resolve' unless disasters_to_resolve.is_a?(Integer)
    raise 'Invalid winner' unless winner.nil? || (1..players.count).include?(winner)

    @players = players
    @current_player = current_player
    @epoch = epoch
    @center_sun = center_sun
    @auction = auction
    @auction_count = auction_count
    @auction_tiles = auction_tiles
    @draw_tiles = draw_tiles
    @disasters_to_resolve = disasters_to_resolve
    @winner = winner
  end

  def self.create_new(player_names)
    unless (2..5).include?(player_names.length)
      raise 'Can only play Ra with 2-5 players'
    end

    sun_values = SUN_DISTRIBUTION.fetch(player_names.length).shuffle
    players = player_names.map.with_index do |name, i|
      suns = sun_values[i].map { |value| Sun.create_new(value) }
      Player.create_new(name, suns)
    end

    highest_sun = sun_values.flatten.max
    current_player = players.find_index { |player| player.suns.find { |sun| sun.value == highest_sun } }

    epoch = 1
    center_sun = Sun.create_new(1)
    auction = nil
    auction_count = 0
    auction_tiles = []
    draw_tiles = TILE_TYPES.map { |tile_class, number| Array.new(number) { tile_class.new } }.flatten.shuffle
    disasters_to_resolve = 0
    winner = nil

    new(
      players,
      current_player,
      epoch,
      center_sun,
      auction,
      auction_count,
      auction_tiles,
      draw_tiles,
      disasters_to_resolve,
      winner
    )
  end

  def max_auctions
    MAX_AUCTIONS.fetch(@players.count)
  end

  def next_players_turn
    @players.rotate(current_player + 1).each do |potential_player|
      if potential_player.has_unused_suns?
        @current_player = @players.find_index { |player| player == potential_player }
        return
      end
    end
    end_epoch
  end
  private :next_players_turn

  def end_epoch
    @auction_tiles = []
    calculate_score

    @players.map do |player|
      player.suns.each { |sun| sun.reset }
    end

    if @epoch < 3
      @epoch += 1
      highest_sun = @players.map { |player| player.max_sun }
      @current_player = @players.find_index { |player| player.max_sun == highest_sun }
    else
      determine_winner
    end
  end
  private :end_epoch

  def calculate_score
    # Unless everyone is tied, +5 points for most pharaohs, -2 points for least pharaohs
    # Pharaohs are kept
    pharaoh_counts = @players.map { |player| player.count_tiles(PharaohTile) }
    if pharaoh_counts.max != pharaoh_counts.min
      @players.find_all { |player| player.count_tiles(PharaohTile) == pharaoh_counts.max }.each { |player| player.victory_points += 5 }
      @players.find_all { |player| player.count_tiles(PharaohTile) == pharaoh_counts.min }.each { |player| player.victory_points -= 2 }
    end

    @players.each do |player|
      # +2 points per god
      # Gods are discarded
      player.victory_points += 2 * player.count_tiles(GodTile)
        player.discard_tiles(GodTile)

      # If there's at least 1 flood, +1 point per Nile/flood
      # Floods are discarded, Niles are kept
      if player.count_tiles(FloodTile) > 0
        player.victory_points += player.count_tiles(NileTile)
        player.victory_points += player.count_tiles(FloodTile)
        player.discard_tiles(FloodTile)
      end

      # -5 points if no civilizations
      # +5 for 3 types, +10 for 4 types, +15 for 5 types
      # Civilizations are discarded
      if player.count_tiles(CivilizationTile) == 0
        player.victory_points -= 5
      else
        civilization_types = player.tiles.find_all { |tile| tile.is_a?(CivilizationTile) }.group_by { |tile| tile.class }.count
        player.victory_points += CIVILIZATION_POINTS.fetch(civilization_types, 0)
        player.discard_tiles(CivilizationTile)
      end

      # +3 points per gold
      # Golds are discarded
      player.victory_points += 3 * player.count_tiles(GoldTile)
      player.discard_tiles(GoldTile)

      # Monuments are only scored in the third epoch
      if @epoch == 3
        # +1 point/monument type up to 6, +10 for 7 types, +15 for 8 types
        # +5 points per group of 3, +10 per 4, +15 per 5
        # Monuments are kept
        monument_counts = player.tiles.find_all { |tile| tile.is_a?(MonumentTile) }.group_by { |tile| tile.class }
        player.victory_points += MONUMENT_DIFFERENT_POINTS.fetch(monument_counts.count, 0)
        monument_counts.each do |monument_class, count|
          player.victory_points += MONUMENT_IDENTICAL_POINTS.fetch(count, 0)
        end
      end
    end

    # Suns are only scored in the third epoch
    if @epoch == 3
      # Unless everyone is tied, +5 for highest suns, -5 for lowest suns
      sun_counts = @players.map { |player| player.sun_total }
      if sun_counts.max != sun_counts.min
        @players.find_all { |player| player.sun_total == sun_counts.max }.each { |player| player.victory_points += 5 }
        @players.find_all { |player| player.sun_total == sun_counts.min }.each { |player| player.victory_points -= 5 }
      end
    end
  end
  private :calculate_score

  def determine_winner
    max_points = @players.map { |player| player.victory_points }.max
    potential_winners = @players.find_all { |player| player.victory_points == max_points }
    if potential_winners.count == 1
      @winner = potential_winners[0]
    else
      max_sun = potential_winners.map { |player| player.max_sun }.max
      @winner = potential_winners.find { |player| player.max_sun == max_sun }
    end
  end
  private :determine_winner

  # Specify tile_class for testing only
  def draw_tile(tile_class = nil)
    if tile_class.nil?
      drawn_tile = @draw_tiles.pop
    else
      tile_index = @draw_tiles.find_index { |tile| tile.is_a?(tile_class) }
      drawn_tile = @draw_tiles.delete_at(tile_index)
    end

    unless @auction.nil?
      raise 'Cannot draw tile when there is an auction'
    end

    if @disasters_to_resolve > 0
      raise 'Cannot draw tile when there are disasters to resolve'
    end

    if drawn_tile.is_a?(RaTile)
      @auction_count += 1
      if (@auction_count == max_auctions)
        end_epoch
      else
        @auction = Auction.create_new(false, current_player, @players.count { |player| player.has_unused_suns? })
      end
    else
      @auction_tiles.push(drawn_tile)
      next_players_turn
    end
  end

  def play_god_tile(desired_tile_class)
    unless @auction.nil?
      raise 'Cannot play god tile when there is an auction'
    end

    if @disasters_to_resolve > 0
      raise 'Cannot play god tile when there are disasters to resolve'
    end

    if desired_tile_class == GodTile || desired_tile_class < GodTile
      raise 'Cannot use god tile to take god tile'
    end

    @players[current_player].use_god_tile
    desired_tile_index = @auction_tiles.find_index { |tile| tile.is_a?(desired_tile_class) }
    if desired_tile_index.nil?
      raise 'No ' + desired_tile_class.to_s + ' available in the auction track'
    end

    desired_tile = @auction_tiles.delete_at(desired_tile_index)
    @players[current_player].tiles.push(desired_tile)

    next_players_turn
  end

  def invoke_ra
    unless @auction.nil?
      raise 'Cannot invoke ra when there is an auction'
    end

    if @disasters_to_resolve > 0
      raise 'Cannot invoke ra when there are disasters to resolve'
    end

    @auction = Auction.create_new(true, current_player, @players.count { |player| player.has_unused_suns? })
    next_players_turn
  end

  def bid(sun_value)
    if @auction.nil?
      raise 'Cannot bid when there is no auction'
    end

    unless sun_value.nil?
      sun = @players[current_player].suns.find { |sun| sun.value == sun_value }
      if sun.nil?
        raise 'Player does not have sun with value ' + sun_value.to_s
      end

      if sun.used
        raise 'Sun with value ' + sun_value.to_s + ' has already been used'
      end
    end

    @auction.bid(current_player, sun_value)

    if @auction.all_bids_in?
      resolve_auction
    else
      next_players_turn
    end
  end

  def resolve_auction
    unless @auction.winner.nil?
      winner = @players[@auction.winner]
      @auction_tiles.each { |tile| winner.tiles.push(tile) }
      @disasters_to_resolve = @auction_tiles.count { |tile| tile.is_a?(DisasterTile) }
      @auction_tiles = []
      @center_sun.use
      winning_sun = winner.replace_sun(@auction.max_bid, @center_sun)
      @center_sun = winning_sun
    end

    @auction = nil

    if @disasters_to_resolve == 0
      next_players_turn
    end
  end
  private :resolve_auction

  def resolve_disaster_tile(disaster_tile_class, discard_tile_1_class, discard_tile_2_class)
    unless @disasters_to_resolve > 0
      raise 'No disaster to resolve'
    end

    unless disaster_tile_class < DisasterTile
      raise disaster_tile_class.to_s + ' is not a disaster tile'
    end

    [discard_tile_1_class, discard_tile_2_class].each do |discard_class|
      unless disaster_tile_class::DESTROYS.include?(discard_class) || discard_class.nil?
        raise diaster_tile_class.to_s + ' destroys ' + disaster_tile_class::DESTROYS.to_s + ', not ' + discard_class.to_s
      end
    end

    destroyable_tiles = disaster_tile_class::DESTROYS.inject(0) { |sum, tile_class| @players[current_player].count_tiles(tile_class) + sum }
    if discard_tile_1_class.nil? && destroyable_tiles > 0 ||
      discard_tile_2_class.nil? && destroyable_tiles > 1
      raise 'Must destroy ' + [destroyable_tiles, 2].min.to_s + ' tiles'
    end

    if disaster_tile_class == DroughtTile
      existing_floods = @players[current_player].count_tiles(FloodTile)
      discarding_floods = [discard_tile_1_class, discard_tile_2_class].count { |tile_class| tile_class == FloodTile }
      if discarding_floods < 2 && discarding_floods < existing_floods
        raise 'Must discard floods first for droughts'
      end
    end

    @players[current_player].resolve_disaster_tile(disaster_tile_class, discard_tile_1_class, discard_tile_2_class)

    @disasters_to_resolve -= 1
    if @disasters_to_resolve == 0
      next_players_turn
    end
  end
end
