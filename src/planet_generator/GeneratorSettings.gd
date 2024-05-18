class_name GeneratorSettings extends Resource

@export var rng_seed: int = 2137 : 
	set(val):
		rng_seed = val
		rng.seed = val

@export var polar_capes := true
@export var number_of_continents: int = 3 : 
	get:
		if polar_capes:
			return number_of_continents + 2
		else:
			return number_of_continents
@export var shapes_per_continent: int = 5
@export_range(0.1, 2.0, 0.1) var min_shape_size: float = 0.5
@export_range(0.1, 2.0, 0.1) var max_shape_size: float = 1.0
@export_range(0.1, 1.0, 0.1) var min_continent_spread: float = 0.1
@export_range(0.1, 1.0, 0.1) var max_continent_spread: float = 0.1

@export_range(0.1, 1.0, 0.1) var sea_level: float = 0.2

@export_range(0, 90, 0.5, "radians_as_degrees") var axial_tilt: float = 0.41

var rng := RandomNumberGenerator.new()

# used in generative shaders to make noise different for every seed
var noise_shift: Vector3


func _init():
	reset_rng()
	generate_noise_shift()


func reset_rng():
	rng.seed = rng_seed


func generate_noise_shift():
	noise_shift = Utils.get_random_vector(rng) * rng.randf_range(0, 1000)
