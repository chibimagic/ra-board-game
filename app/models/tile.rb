class Tile
end

class RaTile < Tile
end

class GodTile < Tile
  TYPES = [
    "Anubis",
    "Bastet",
    "Chnum",
    "Horus",
    "Seth",
    "Sobek",
    "Thoth",
    "Ut"
  ]
end

class PharoahTile < Tile
end

class NileTile < Tile
end

class FloodTile < Tile
end

class CivilizationTile < Tile
  TYPES = [
    "Art",
    "Agriculture",
    "Religion",
    "Astronomy",
    "Writing"
  ]
end

class GoldTile < Tile
end

class MonumentTile < Tile
  TYPES = [
    "Fortress",
    "Obelisk",
    "Palace",
    "Pyramid",
    "Sphinx",
    "Statues",
    "Step pyramid",
    "Temple"
  ]
end

class DisasterTile < Tile
  DESTROYS = []
end

class FuneralTile < DisasterTile
  DESTROYS = [PharoahTile]
end

class DroughtTile < DisasterTile
  DESTROYS = [FloodTile, NileTile]
end

class UnrestTile < DisasterTile
  DESTROYS = [CivilizationTile]
end

class EarthquakeTile < DisasterTile
  DESTROYS = [MonumentTile]
end
