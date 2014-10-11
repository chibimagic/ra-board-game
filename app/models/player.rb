class Player
  attr_accessor :name, :suns, :tiles, :victory_points

  def initialize(name, suns, tiles, victory_points)
    raise 'Invalid name' unless name.is_a?(String)
    raise 'Invalid suns' unless suns.is_a?(Array) && suns.length == 3 && suns.all? { |sun| sun.is_a?(Sun) }
    raise 'Invalid tiles' unless tiles.is_a?(Array) && tiles.all? { |tile| tile.is_a?(Tile) }
    raise 'Invalid victory points' unless victory_points.is_a?(Integer)
  end

  def self.create_new(name, suns)
    tiles = []
    victory_points = 5

    new(name, suns, tiles, victory_points)
  end
end
