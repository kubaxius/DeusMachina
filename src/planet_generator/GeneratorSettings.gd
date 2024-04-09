class_name GeneratorSettings extends Resource

@export var rng_seed: int = 2137 : 
	set(val):
		rng_seed = val
		rng.seed = val

@export var polar_capes := true

@export var number_of_continents: int = 3 : 
	get:
		if polar_capes:
			return number_of_continents
		else:
			return number_of_continents + 2

@export var shapes_per_continent: int = 5
@export_range(0.1, 2.0, 0.1) var min_shape_size: float = 0.5
@export_range(0.1, 2.0, 0.1) var max_shape_size: float = 1.0
@export_range(0.1, 1.0, 0.1) var min_continent_spread: float = 0.1
@export_range(0.1, 1.0, 0.1) var max_continent_spread: float = 0.1

var rng := RandomNumberGenerator.new()

var continents_transform_data
var continents_shape_data

func _init():
	rng.seed = rng_seed
	regenerate_data()


func _generate_continent_shape_data() -> Vector2:
	var shape_id = rng.randi_range(0, 1)
	var shape_scale = rng.randf_range(min_shape_size, max_shape_size)
	
	return Vector2(shape_id, shape_scale)


func _get_continents_shape_data() -> Array:
	var shape_data = []
	
	for i in number_of_continents * shapes_per_continent:
		shape_data.append(_generate_continent_shape_data())
	
	return shape_data


func _generate_continent_transforms(pos := Vector3.ZERO) -> Array:
	var continent_transforms = []
	
	# main shape rotation and position
	var main_trans = Utils.get_randomly_rotated_transform(rng)
	if pos == Vector3.ZERO:
		main_trans.origin = Utils.get_random_vector(rng)
	else:
		main_trans.origin = pos
	continent_transforms.append(main_trans)
	
	for i in shapes_per_continent:
		if i == 0: continue
		var trans = Utils.get_randomly_rotated_transform(rng)
		
		# Copy origin from last shape and move it random 
		# amount on the surface of a globe.
		trans.origin = continent_transforms[i-1].origin\
				.rotated(Utils.get_random_vector(rng),
				 rng.randf_range(min_continent_spread, max_continent_spread))
		
		continent_transforms.append(trans)
	
	return continent_transforms


## Gets an array of Transforms3D and return array of Vectors3 that made them up.
## We do this because you can't pass an array of Transforms3D to Shader, but you
## can pass an array of Vectors3.
func _break_transforms_into_vectors(transforms: Array) -> Array:
	var trans_components = []
	for trans in transforms:
		var trans_array = Utils.break_transform_into_vectors(trans)
		trans_components.append_array(trans_array)
	
	return trans_components


func _get_continents_transform_data() -> PackedVector3Array:
	var trans_components = []
	
	if polar_capes:
		trans_components.append_array(\
				_break_transforms_into_vectors(\
						_generate_continent_transforms(Vector3.UP)))
		trans_components.append_array(\
				_break_transforms_into_vectors(\
						_generate_continent_transforms(Vector3.DOWN)))
	
	for i in number_of_continents:
		var transforms = _generate_continent_transforms()
		trans_components\
				.append_array(_break_transforms_into_vectors(transforms))
	
	return PackedVector3Array(trans_components)


func regenerate_data():
	continents_transform_data = _get_continents_transform_data()
	continents_shape_data = _get_continents_shape_data()

