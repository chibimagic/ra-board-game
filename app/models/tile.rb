class Tile
end

class RaTile < Tile
end

class GodTile < Tile
end

class AnubisGodTile < GodTile
end

class BastetGodTile < GodTile
end

class ChnumGodTile < GodTile
end

class HorusGodTile < GodTile
end

class SethGodTile < GodTile
end

class SobekGodTile < GodTile
end

class ThothGodTile < GodTile
end

class UtGodTile < GodTile
end

class PharoahTile < Tile
end

class NileTile < Tile
end

class FloodTile < Tile
end

class CivilizationTile < Tile
end

class ArtCivilizationTile < CivilizationTile
end

class AgricultureCivilizationTile < CivilizationTile
end

class ReligionCivilizationTile < CivilizationTile
end

class AstronomyCivilizationTile < CivilizationTile
end

class WritingCivilizationTile < CivilizationTile
end

class GoldTile < Tile
end

class MonumentTile < Tile
end

class FortressMonumentTile < MonumentTile
end

class ObeliskMonumentTile < MonumentTile
end

class PalaceMonumentTile < MonumentTile
end

class PyramidMonumentTile < MonumentTile
end

class SphinxMonumentTile < MonumentTile
end

class StatuesMonumentTile < MonumentTile
end

class StepPyramidMonumentTile < MonumentTile
end

class TemplateMonumentTile < MonumentTile
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
