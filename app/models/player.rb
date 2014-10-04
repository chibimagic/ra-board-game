class Player
  attr_accessor :name, :suns, :tiles

  def initialize(name, suns, tiles)
    raise 'Invalid name' unless name.is_a?(String)
    raise 'Invalid suns' unless suns.is_a?(Array) && suns.length == 3 && suns.all? { |sun| sun.is_a?(Sun) }
    raise 'Invalid tiles' unless tiles.is_a?(Array) && tiles.all? { |tile| tile.is_a?(Tile) }
  end
end
