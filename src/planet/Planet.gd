class_name Planet extends Resource

enum MapType {SEA, HEIGHT, HUMIDITY, SEA_DIST, BIOME}

@export var sea_map: Image
@export var height_map: Image
@export var humidity_map: Image
@export var sea_dist_map: Image
@export var biome_map: Image
# in radians
@export var axial_tilt: float
@export var sea_level: float

@export var biome_list: Array[Biome]
@export var continents: Array[Continent]

func _get_pixel_value_from_map(map: Image, uv: Vector2) -> Color:
	var pos := Vector2i(uv * Vector2(map.get_size()))
	pos = pos % Vector2i(map.get_size())
	return map.get_pixelv(pos)


func _is_sea(uv: Vector2) -> bool:
	if _get_pixel_value_from_map(sea_map, uv).r > 0.5:
		return true
	return false


func _set_point_biome(point: PlanetPoint):
	var color = _get_pixel_value_from_map(biome_map, point.position_uv)
	
	var color_id = color.to_rgba32()
	var smallest_color_dist = 9223372036854775807
	var closest_biome
	
	for biome: Biome in biome_list:
		var color_dist = abs(biome.id.to_rgba32() - color_id)
		if color_dist < smallest_color_dist:
			smallest_color_dist = color_dist
			closest_biome = biome
	
	point.biome = closest_biome


func get_point(pos: Vector3, simple := false) -> PlanetPoint:
	var point = PlanetPoint.new(pos, self)
	if sea_map == null:
		simple = true
	if not simple:
		point.down_tilt.relative_sun_tilt = -axial_tilt
		point.up_tilt.relative_sun_tilt = axial_tilt
		point.is_sea = _is_sea(point.position_uv)
		point.height = _get_pixel_value_from_map(height_map, point.position_uv).r
	if biome_map != null:
		_set_point_biome(point)
	
	return point


func get_map(type: MapType) -> Image:
	match type:
		MapType.SEA:
			return sea_map
		MapType.HEIGHT:
			return height_map
		MapType.HUMIDITY:
			return humidity_map
		MapType.SEA_DIST:
			return sea_dist_map
		MapType.BIOME:
			return biome_map
	return height_map


func get_continents_shape_data() -> Dictionary:
	var csd = {
		"transforms": [],
		"types": [],
		"scales": [],
	}
	
	for continent: Continent in continents:
		csd.transforms += continent.get_broken_up_shape_transforms()
		csd.types += continent.get_shape_types()
		csd.scales += continent.get_shape_scales()
	
	return csd
