# Geology Generator
extends Generator


# HACK: You will have to create much better ones.
var landmass_generator_shader: Shader = \
preload("res://planet_generator/shaders/landmass_generator.gdshader")
var sea_dist_shader: Shader = \
preload("res://planet_generator/shaders/sea_dist_shader.gdshader")

enum MAP{COLOR, SEA, HEIGHT}

var continents_transform_data: PackedVector3Array
var continents_shape_data: PackedVector2Array

func _generate_continent_shape_data() -> Vector2:
	var shape_id = settings.rng.randi_range(0, 1)
	var shape_scale = settings.rng\
			.randf_range(settings.min_shape_size, settings.max_shape_size)
	
	return Vector2(shape_id, shape_scale)


func _get_continents_shape_data() -> PackedVector2Array:
	var shape_data = []
	
	for i in settings.number_of_continents * settings.shapes_per_continent:
		shape_data.append(_generate_continent_shape_data())
	
	return PackedVector2Array(shape_data)


func _generate_continent_transforms(pos := Vector3.ZERO) -> Array:
	var continent_transforms = []
	
	# main shape rotation and position
	var main_trans = Utils.get_randomly_rotated_transform(settings.rng)
	if pos == Vector3.ZERO:
		main_trans.origin = Utils.get_random_vector(settings.rng)
	else:
		main_trans.origin = pos
	continent_transforms.append(main_trans)
	
	for i in settings.shapes_per_continent:
		if i == 0: continue
		var trans = Utils.get_randomly_rotated_transform(settings.rng)
		
		# Copy origin from last shape and move it random 
		# amount on the surface of a globe.
		trans.origin = continent_transforms[i-1].origin\
				.rotated(Utils.get_random_vector(settings.rng),
				 settings.rng.randf_range(settings.min_continent_spread,
				 settings.max_continent_spread))
		
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
	
	if settings.polar_capes:
		trans_components.append_array(\
				_break_transforms_into_vectors(\
						_generate_continent_transforms(Vector3.UP)))
		trans_components.append_array(\
				_break_transforms_into_vectors(\
						_generate_continent_transforms(Vector3.DOWN)))
	
	for i in settings.number_of_continents:
		var transforms = _generate_continent_transforms()
		trans_components\
				.append_array(_break_transforms_into_vectors(transforms))
	
	return PackedVector3Array(trans_components)


func regenerate_data():
	continents_transform_data = _get_continents_transform_data()
	continents_shape_data = _get_continents_shape_data()


func send_data_to_multi_shape_lib(material: ShaderMaterial) -> void:
	material.set_shader_parameter("SHAPES_PER_CONTINENT", settings.shapes_per_continent)
	material.set_shader_parameter("CONTINENTS_NUMBER", settings.number_of_continents)
	material.set_shader_parameter("TRANSFORM_COMPONENTS", continents_transform_data)
	material.set_shader_parameter("SHAPE_DATA", continents_shape_data)
	material.set_shader_parameter("SEA_LEVEL", settings.sea_level)


func send_data_to_landmass_generator_shader(material: ShaderMaterial, mode: MAP) -> void:
	send_data_to_multi_shape_lib(material)
	material.set_shader_parameter("MODE", mode)
	material.set_shader_parameter("NOISE_SHIFT", settings.noise_shift)


func generate_sea_map():
	var material = ShaderMaterial.new()
	material.shader = landmass_generator_shader
	send_data_to_landmass_generator_shader(material, MAP.SEA)
	
	planet.sea_map = await texture_baker.get_image(material)


func generate_height_map():
	var material = ShaderMaterial.new()
	material.shader = landmass_generator_shader
	send_data_to_landmass_generator_shader(material, MAP.HEIGHT)
	
	planet.height_map = await texture_baker.get_image(material)


func generate_sea_dist_map():
	var material = ShaderMaterial.new()
	material.shader = sea_dist_shader
	send_data_to_multi_shape_lib(material)
	
	material.set_shader_parameter("SEA_MAP", ImageTexture.create_from_image(planet.sea_map))
	planet.sea_dist_map = await texture_baker.get_image(material)


func _generate():
	await regenerate_data()
	await generate_sea_map()
	await generate_sea_dist_map()
	await generate_height_map()
