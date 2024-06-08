class_name ContinentShape extends Resource

enum Type{CAPPED_CONE, TORUS}

@export var continent: Continent
@export var type: Type = Type.CAPPED_CONE
@export var transform: Transform3D = Transform3D.IDENTITY
@export var scale: Vector4 = Vector4()


func get_transform_components() -> Array[Vector3]:
	return Utils.break_transform_into_vectors(transform)


func get_type() -> Type:
	return type


func get_relative_scale() -> Vector4:
	return scale * continent.size


func randomize_scale(settings: GeneratorSettings):
	scale.x = settings.rng.randf_range(settings.min_shape_size,\
				settings.max_shape_size)
	scale.y = settings.rng.randf_range(settings.min_shape_size,\
				settings.max_shape_size)
	scale.z = settings.rng.randf_range(settings.min_shape_size,\
				settings.max_shape_size)
	scale.w = settings.rng.randf_range(settings.min_shape_size,\
				settings.max_shape_size)


# TODO
func setup(settings: GeneratorSettings, p_continent: Continent):
	continent = p_continent
	
	# set scale and type
	randomize_scale(settings)
	type = settings.rng.randi_range(0, Type.size()) as Type
	
	# set rotation and location
	transform = Utils.get_randomly_rotated_transform(settings.rng)
	transform.origin = continent.position.position_3d\
				.rotated(Utils.get_random_vector(settings.rng),
				settings.rng.randf_range(settings.min_continent_spread,
				settings.max_continent_spread))
