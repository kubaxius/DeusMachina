extends Sprite2D

var points := []


func draw_dot(loc: Vector2i, col := Color.WHITE):
	points.append([loc, col])
	get_parent().set_update_mode(SubViewport.UPDATE_ONCE)


func _draw():
	for point in points:
		draw_circle(point[0], 1, point[1])
