extends Node3D

@export_range(0, 20) var max_depth = 2

var triangles = []

func _ready():
	_generate_big_triangles()
	draw_lines()

func _generate_big_triangles():
	var v_top = PlanetPoint.new(Vector3(0,0,1))
	var v_bot = PlanetPoint.new(Vector3(0,0,-1))
	var v_left = PlanetPoint.new(Vector3(-1,0,0))
	var v_right = PlanetPoint.new(Vector3(1,0,0))
	var v_front = PlanetPoint.new(Vector3(0,1,0))
	var v_back = PlanetPoint.new(Vector3(0,-1,0))
	triangles.append(PlanetTriangle.new(v_top, v_left, v_front, max_depth))
	triangles.append(PlanetTriangle.new(v_top, v_front, v_right, max_depth))
	triangles.append(PlanetTriangle.new(v_top, v_right, v_back, max_depth))
	triangles.append(PlanetTriangle.new(v_top, v_back, v_left, max_depth))
	triangles.append(PlanetTriangle.new(v_bot, v_left, v_front, max_depth))
	triangles.append(PlanetTriangle.new(v_bot, v_front, v_right, max_depth))
	triangles.append(PlanetTriangle.new(v_bot, v_right, v_back, max_depth))
	triangles.append(PlanetTriangle.new(v_bot, v_back, v_left, max_depth))


func get_triangle(point:PlanetPoint):
	for triangle:PlanetTriangle in triangles:
		if triangle.is_point_inside(point):
			return triangle


func highlight_triangle(camera):
	var intersection = Utils.project_camera_ray(camera, get_world_3d(), get_viewport())
	if not intersection.is_empty():
		pass
		#print(get_triangle(PlanetPoint.new(intersection.position)))


func draw_lines():
	$Draw3D.circle_normal(Vector3.ZERO, Vector3.UP, 1.01)
	$Draw3D.circle_normal(Vector3.ZERO, Vector3.LEFT, 1.01)
	$Draw3D.circle_normal(Vector3.ZERO, Vector3.FORWARD, 1.01)
	for triangle in triangles:
		for args in triangle.get_args_for_arc_drawing():
			$Draw3D.callv("arc", args)
