class_name Biome extends Resource


@export var name: String
@export_range(0, 2, 0.05) var base_weight: float = 1
@export_color_no_alpha var color: Color

@export_subgroup("Biome Size", "biome_size")
@export_range(1, 100, 1) var biome_size_min: int = 1
@export_range(1, 100, 1) var biome_size_max: int = 1

@export_category("Generation Requirements")

@export_group("Main")
@export var shore_proximity := false

@export_subgroup("Height", "height")
@export_range(0, 1, 0.05) var height_min: float = 0
@export_range(0, 1, 0.05) var height_max: float = 1


@export_group("Summer")
@export_subgroup("Humidity", "summer_humidity")
@export_range(0, 1, 0.05) var summer_humidity_min: float = 0
@export_range(0, 1, 0.05) var summer_humidity_max: float = 1

@export_subgroup("Average Sun", "summer_avg_sun")
@export_range(0, 1, 0.05) var summer_avg_sun_min: float = 0
@export_range(0, 1, 0.05) var summer_avg_sun_max: float = 1


@export_group("Spring and Autumn")
@export_subgroup("Humidity", "spring_humidity")
@export_range(0, 1, 0.05) var spring_humidity_min: float = 0
@export_range(0, 1, 0.05) var spring_humidity_max: float = 1

@export_subgroup("Average Sun", "spring_avg_sun")
@export_range(0, 1, 0.05) var spring_avg_sun_min: float = 0
@export_range(0, 1, 0.05) var spring_avg_sun_max: float = 1


@export_group("Winter")
@export_subgroup("Humidity", "winter_humidity")
@export_range(0, 1, 0.05) var winter_humidity_min: float = 0
@export_range(0, 1, 0.05) var winter_humidity_max: float = 1

@export_subgroup("Average Sun", "winter_avg_sun")
@export_range(0, 1, 0.05) var winter_avg_sun_min: float = 0
@export_range(0, 1, 0.05) var winter_avg_sun_max: float = 1

var id: Color
var used := false

# TODO: make this more responsive in the editor using _get_property_list()

# TODO: none of the settings do anything yet
func calculate_weight(pos: BiomeCell, rng: RandomNumberGenerator):
	return base_weight


func get_desired_size(rng: RandomNumberGenerator):
	return rng.randi_range(biome_size_min, biome_size_max)
