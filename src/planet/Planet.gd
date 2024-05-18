class_name Planet extends Resource

enum MapType {SEA, HEIGHT, HUMIDITY, SEA_DIST, BIOME}

@export var sea_map: Image
@export var height_map: Image
@export var humidity_map: Image
@export var sea_dist_map: Image
@export var biome_map: Image
# in radians
@export var axial_tilt: float


func _get_pixel_value_from_map(map: Image, uv: Vector2) -> Color:
	var pos := Vector2i(uv * Vector2(map.get_size()))
	pos = pos % Vector2i(map.get_size())
	return map.get_pixelv(pos)


func _is_sea(uv: Vector2) -> bool:
	if _get_pixel_value_from_map(sea_map, uv).r > 0.5:
		return true
	return false


func get_point(pos: Vector3) -> PlanetPoint:
	var point = PlanetPoint.new(pos, self)
	point.down_tilt.relative_sun_tilt = -axial_tilt
	point.up_tilt.relative_sun_tilt = axial_tilt
	point.is_sea = _is_sea(point.position_uv)
	point.height = _get_pixel_value_from_map(height_map, point.position_uv).r
	
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
