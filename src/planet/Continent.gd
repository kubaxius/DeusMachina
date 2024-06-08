class_name Continent extends Resource

@export var planet: Planet
@export var shapes: Array[ContinentShape] = []
@export var position: PlanetPoint
@export var shapes_number: int
@export var size: float

func get_broken_up_shape_transforms() -> Array[Vector3]:
	var transform_vectors: Array[Vector3] = []
	
	for shape in shapes:
		transform_vectors += shape.get_transform_components()
	
	return transform_vectors


func get_shape_types() -> Array[ContinentShape.Type]:
	var types: Array[ContinentShape.Type] = []
	
	for shape in shapes:
		types.append(shape.get_type())
	
	return types


func get_shape_scales() -> Array[Vector4]:
	var scales: Array[Vector4] = []
	
	for shape in shapes:
		scales.append(shape.get_relative_scale())
	
	return scales

# TODO
func setup(p_planet: Planet, settings: GeneratorSettings, pos: PlanetPoint = null):
	planet = p_planet
	if pos is PlanetPoint:
		position = pos
	else:
		var r_vector = Utils.get_random_vector(settings.rng)
		position = planet.get_point(r_vector, true)

	size = settings.rng.randf_range(settings.min_continent_size,\
				settings.max_continent_size)
	
	shapes_number = settings.shapes_per_continent
	
	for i in shapes_number:
		var new_shape := ContinentShape.new()
		new_shape.setup(settings, self)
		shapes.append(new_shape)

