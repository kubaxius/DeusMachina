## PixelCollider ##
extends Node3D

@onready var uv256 = []#_load_uv_map("256uv3d.tres")
@onready var uv512 = []#_load_uv_map("512uv3d.tres")
@onready var uv1k = []#_load_uv_map("1kuv3d.tres")
#@onready var uv2k:Uv3DMap = _load_uv_map("2kuv3d.tres")
#@onready var uv4k:Uv3DMap = _load_uv_map("4kuv3d.tres")

enum {UV256, UV512, UV1K, UV2K, UV4K}
var scales = [1, 2, 4, 8, 16]

func _ready():
	pass


func _load_uv_map(file_name: String):
	var map = load("res://planet/uv3d/" + file_name)
	return map


func _is_point_inside_collider(point:Vector3, collider):
	var space_state := get_world_3d().direct_space_state
	
	var query_params = PhysicsPointQueryParameters3D.new()
	query_params.position = point
	query_params.collide_with_bodies = false
	query_params.collide_with_areas = true
	
	var results:Array = space_state.intersect_point(query_params)
	if results.size() != 0:
		for result in results:
			if result.collider == collider:
				return true
	return false


func _get_starting_pixel(collider):
	var pixels = uv256.map
	for x in pixels.size():
		for y in pixels[x].size():
			if not pixels[x][y] is Vector3:
				continue
			if _is_point_inside_collider(pixels[x][y], collider):
				return Vector2i(x, y)
	
	return null


func _get_neighbors(map, pixel:Vector2i, excluded:Array):
	var dirs = [map.TOP, map.BOTTOM, map.RIGHT, map.LEFT]
	var neighbors = []
	
	for dir in dirs:
		var neighbor = map.get_neighbor(pixel, dir)
		if neighbor == null or excluded.has(neighbor):
			continue
		neighbors.append(neighbor)
	
	return neighbors


func get_pixels_inside_area(area, map_enum):
	var maps_array = [uv256, uv512, uv1k]
	var starting_pixel = _get_starting_pixel(area) * scales[map_enum]
	var pixels_inside = [starting_pixel]
	print("dupa")
	var i = 0
	while true:
		var neighbors = _get_neighbors(maps_array[map_enum], pixels_inside[i], pixels_inside)
		print(i)
		for neighbor in neighbors:
			var neighbor_loc = maps_array[map_enum].get_pixel_3d_location_v(neighbor)
			if _is_point_inside_collider(neighbor_loc, area):
				pixels_inside.append(neighbor)
		
		i += 1
		if i == pixels_inside.size():
			break
	
	return pixels_inside
