class_name BiomeCell

var id: int
var position: PlanetPoint
var neighbors: Array[BiomeCell] = []
var biome: Biome

var outbreak_point = false
var current_biome_size: int = 0
var desired_biome_size: int = 1
