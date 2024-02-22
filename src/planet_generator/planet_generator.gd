### Planet Generator ###
extends Node3D

const Delaunay = preload("res://addons/gdDelaunay/Delaunay.gd")
const GlobeTools = preload("res://utils/globe_tools.gd")

@export var gen_seed = 2137
@export var map_size = Vector2i(4096, 2048)

@onready var rng := RandomNumberGenerator.new()
@onready var globe_mesh := $Globe/Globe
@onready var material:ShaderMaterial = globe_mesh.get_surface_override_material(0)
@onready var camera := find_child("Camera")
@onready var draw_viewport := $DrawViewport
@onready var current_map := $DrawViewport/Noise


func _ready():
	UvPosition.set_mesh(globe_mesh)
	$DrawViewport.size = map_size
	rng.seed = gen_seed
	
	generate_noise_texture()
	
	var delaunay = Delaunay.new()
	var points = get_random_points_on_a_sphere(10)
	
	var stereo_points = GlobeTools.array_vector3_to_stereo(points)
	for point in stereo_points:
		delaunay.add_point(point)
	
	var triangles = delaunay.triangulate()
	for triangle:Delaunay.Triangle in triangles:
		draw_line(GlobeTools.stereo_to_vector3(triangle.edge_ab.a), GlobeTools.stereo_to_vector3(triangle.edge_ab.b))
		draw_line(GlobeTools.stereo_to_vector3(triangle.edge_ca.a), GlobeTools.stereo_to_vector3(triangle.edge_ca.b))
		draw_line(GlobeTools.stereo_to_vector3(triangle.edge_bc.a), GlobeTools.stereo_to_vector3(triangle.edge_bc.b))


func _physics_process(_delta):
	_draw_with_mouse()
	material.set_shader_parameter("SplatMapTexture", draw_viewport.get_texture())


func _load_uv_3d_map():
	var text = FileAccess.open("res://planet/uv_to_3d.arr", FileAccess.READ).get_as_text()

	var uv_3d = str_to_var(text)
	return uv_3d


func _draw_with_mouse():
	var space_state = get_world_3d().direct_space_state
	var mouse_position = get_viewport().get_mouse_position()
	
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_end = ray_origin + camera.project_ray_normal(mouse_position) * 2000
	
	var intersection = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(ray_origin, ray_end))
	
	if not intersection.is_empty():
		if Input.is_action_pressed("break_block"):
			var uv = UvPosition.get_uv_coords(intersection.position, intersection.normal)
			if uv:
				draw_viewport.move_brush(uv * Vector2(map_size))


func get_random_vector():
	return Vector3(rng.randfn(), rng.randfn(), rng.randfn()).normalized()


func vector_to_intersection(vector: Vector3):
	var space_state := get_world_3d().direct_space_state
	
	var starting_point = vector.normalized() * 26
	var query = PhysicsRayQueryParameters3D.create(starting_point, globe_mesh.global_position)
	var intersection = space_state.intersect_ray(query)
	
	return intersection


func generate_random_lines(number = 2):
	for i in number:
		var from = get_random_vector()
		var to = get_random_vector()
		
		draw_line(from, to, 50)
		draw_dot(vector_to_intersection(from), Color.GREEN_YELLOW)
		draw_dot(vector_to_intersection(to), Color.BLUE)


func generate_noise_texture():
	var uv_3d = _load_uv_3d_map()
	var noise := FastNoiseLite.new()
	noise.seed = gen_seed
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.1
	noise.fractal_octaves = 1
	
	var image := Image.create(1024, 512, false, Image.FORMAT_RGB8)
	
	for x in uv_3d.size():
		for y in uv_3d[x].size():
			if typeof(uv_3d[x][y]) == TYPE_VECTOR3:
				var noise_val = noise.get_noise_3dv(uv_3d[x][y])
				var color = Color(noise_val, noise_val, noise_val)
				image.set_pixel(x, y, color)
	
	image.resize(map_size.x, map_size.y)
	
	$DrawViewport/Noise.texture = ImageTexture.create_from_image(image)


func draw_dot(where, col = Color.WHITE):
	if where is Vector3:
		where = vector_to_intersection(where)
	
	var uv = UvPosition.get_uv_coords(where.position, where.normal)
	if uv:
		current_map.draw_dot(uv * Vector2(map_size), col)


func draw_line(from:Vector3, to:Vector3, density := 50):
	from = from.normalized()
	to = to.normalized()
	
	#that's also distance on a sphere of radius 1
	var angle = from.angle_to(to)
	
	if from.angle_to(to) == PI:
		print("Impossible Line!")
		return false
	
	var steps_number = density * angle
	var step_size = 1/steps_number
	
	for i in range(0, steps_number + 1):
		var step = step_size * i * angle
		var vector = from.rotated(from.cross(to).normalized(), step)
		draw_dot(vector)


func get_random_points_on_a_sphere(number):
	var return_array = []
	
	for i in number:
		return_array.append(get_random_vector())
	
	return return_array
