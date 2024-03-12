class_name Uv3DMap extends Resource

@export var map = [[]]
@export var size = Vector2i.ZERO

enum {LEFT, RIGHT, TOP, BOTTOM}


func get_pixel_3d_location_v(pixel: Vector2i):
	if pixel.x < map.size() and pixel.x >= 0:
		if pixel.y < map[0].size() and pixel.y >= 0:
			return map[pixel.x][pixel.y]
	return null


func get_pixel_3d_location(x, y):
	if x < map.size() and x >= 0:
		if y < map[0].size() and y >= 0:
			return map[x][y]
	return null


func get_neighbor(pixel: Vector2i, dir: int):
	var neighbor
	
	if dir == LEFT:
		neighbor = _get_left_neighbor(pixel)
	elif dir == RIGHT:
		neighbor = _get_right_neighbor(pixel)
	elif dir == TOP:
		neighbor = _get_top_neighbor(pixel)
	elif dir == BOTTOM:
		neighbor = _get_bottom_neighbor(pixel)
	
	return neighbor



func _get_left_neighbor(pixel: Vector2i):
	while true:
		if pixel.x == 0:
			pixel.x = size.x - 1
		pixel.x -= 1
		
		if get_pixel_3d_location_v(pixel) is Vector3:
			return pixel


func _get_right_neighbor(pixel: Vector2i):
	while true:
		if pixel.x == size.x - 1:
			pixel.x = 0
		pixel.x += 1
		
		if get_pixel_3d_location_v(pixel) is Vector3:
			return pixel


func _get_top_neighbor(pixel: Vector2i):
	while true:
		if pixel.y == 0:
			return null
		pixel.y -= 1
		
		if get_pixel_3d_location_v(pixel) is Vector3:
			return pixel


func _get_bottom_neighbor(pixel: Vector2i):
	while true:
		if pixel.y == size.y - 1:
			return null
		pixel.y += 1
		if get_pixel_3d_location_v(pixel) is Vector3:
			return pixel
