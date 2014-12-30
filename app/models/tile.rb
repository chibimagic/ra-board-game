class Tile
  def self.to_s
    self::TITLE + ' tile'
  end
end

class RaTile < Tile
  TITLE = 'Ra'
end

class GodTile < Tile
  TITLE = 'Ra'
end

class AnubisGodTile < GodTile
  TITLE = 'Anubus'
end

class BastetGodTile < GodTile
  TITLE = 'Bastet'
end

class ChnumGodTile < GodTile
  TITLE = 'Chnum'
end

class HorusGodTile < GodTile
  TITLE = 'Horus'
end

class SethGodTile < GodTile
  TITLE = 'Seth'
end

class SobekGodTile < GodTile
  TITLE = 'Sobek'
end

class ThothGodTile < GodTile
  TITLE = 'Thoth'
end

class UtGodTile < GodTile
  TITLE = 'Ut'
end

class PharaohTile < Tile
  TITLE = 'Pharaoh'
end

class NileTile < Tile
  TITLE = 'Nile'
end

class FloodTile < Tile
  TITLE = 'Flood'
end

class CivilizationTile < Tile
  TITLE = 'Civilization'
end

class ArtCivilizationTile < CivilizationTile
  TITLE = 'Art'
end

class AgricultureCivilizationTile < CivilizationTile
  TITLE = 'Agriculture'
end

class ReligionCivilizationTile < CivilizationTile
  TITLE = 'Religion'
end

class AstronomyCivilizationTile < CivilizationTile
  TITLE = 'Astronomy'
end

class WritingCivilizationTile < CivilizationTile
  TITLE = 'Writing'
end

class GoldTile < Tile
  TITLE = 'Gold'
end

class MonumentTile < Tile
  TITLE = 'Monument'
end

class FortressMonumentTile < MonumentTile
  TITLE = 'Fortress'
end

class ObeliskMonumentTile < MonumentTile
  TITLE = 'Obelisk'
end

class PalaceMonumentTile < MonumentTile
  TITLE = 'Palace'
end

class PyramidMonumentTile < MonumentTile
  TITLE = 'Pyramid'
end

class SphinxMonumentTile < MonumentTile
  TITLE = 'Sphinx'
end

class StatuesMonumentTile < MonumentTile
end

class StepPyramidMonumentTile < MonumentTile
end

class TempleMonumentTile < MonumentTile
end

class DisasterTile < Tile
  DESTROYS = []
end

class FuneralTile < DisasterTile
  TITLE = 'Funeral'
  DESTROYS = [PharaohTile]
end

class DroughtTile < DisasterTile
  TITLE = 'Drought'
  DESTROYS = [FloodTile, NileTile]
end

class UnrestTile < DisasterTile
  TITLE = 'Unrest'
  DESTROYS = [CivilizationTile]
end

class EarthquakeTile < DisasterTile
  TITLE = 'Earthquake'
  DESTROYS = [MonumentTile]
end
