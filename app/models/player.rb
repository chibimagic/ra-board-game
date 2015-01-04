class Player
  attr_accessor :name, :suns, :tiles, :victory_points

  def initialize(name, suns, tiles, victory_points)
    raise 'Invalid name' unless name.is_a?(String)
    raise 'Invalid suns' unless suns.is_a?(Array) && suns.all? { |sun| sun.is_a?(Sun) }
    raise 'Invalid tiles' unless tiles.is_a?(Array) && tiles.all? { |tile| tile.is_a?(Tile) }
    raise 'Invalid victory points' unless victory_points.is_a?(Integer)

    @name = name
    @suns = suns
    @tiles = tiles
    @victory_points = victory_points
  end

  def self.create_new(name, suns)
    tiles = []
    victory_points = 5

    new(name, suns, tiles, victory_points)
  end

  def has_unused_suns?
    @suns.any? { |sun| !sun.used }
  end

  def max_sun
    @suns.map { |sun| sun.value }.max
  end

  def sun_total
    @suns.inject { |sum, sun| sum + sun.value }
  end

  def replace_sun(winning_value, center_sun)
    @suns.push(center_sun)
    winning_index = @suns.find_index { |sun| sun.value == winning_value }
    @suns.delete_at(winning_index)
  end

  def count_tiles(tile_class)
    @tiles.count { |tile| tile.is_a?(tile_class) }
  end

  def discard_tiles(tile_class)
    @tiles.delete_if { |tile| tile.is_a?(tile_class) }
  end

  def use_god_tile
    tile_index = @tiles.find_index { |tile| tile.is_a?(GodTile) }
    if tile_index.nil?
      raise 'Player does not have a god tile'
    end

    @tiles.delete_at(tile_index)
  end

  def resolve_disaster_tile(disaster_tile_class, discard_tile_1_class, discard_tile_2_class)
    disaster_tile_index = @tiles.find_index { |tile| tile.is_a?(disaster_tile_class) }
    @tiles.delete_at(diaster_tile_index)

    [discard_tile_1_class, discard_tile_2_class].each do |tile_class|
      unless tile_class.nil?
        tile_index = @tiles.find_index { |tile| tile.is_a?(tile_class) }
        @tiles.delete_at(tile_index)
      end
    end
  end
end
