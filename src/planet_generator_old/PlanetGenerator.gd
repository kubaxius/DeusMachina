### Planet Generator ###
extends Node3D

const GlobeTools = preload("res://utils/globe_tools.gd")

@export var gen_seed = 2137
@export var map_size = Vector2i(4096, 2048)

@onready var rng := RandomNumberGenerator.new()
@onready var globe_mesh := $Planet/Globe
@onready var material:ShaderMaterial = globe_mesh.get_surface_override_material(0)
@onready var camera := find_child("Camera")
@onready var draw_viewport := $DrawViewport
@onready var current_map := $DrawViewport/HeightMap


func _ready():
	UvPosition.set_mesh(globe_mesh)
	$DrawViewport.size = map_size
	rng.seed = gen_seed
	
	current_map.texture = generate_noise_texture($PixelCollider.uv1k, map_size)
	impress_shape_on_sprite(current_map, $Test)
	
	#var delaunay = Delaunay.new()
	#var points = get_random_points_on_a_sphere(10)
	#
	#var stereo_points = GlobeTools.array_vector3_to_stereo(points)
	#for point in stereo_points:
		#delaunay.add_point(point)
	
	#var triangles = delaunay.triangulate()
	#for triangle:Delaunay.Triangle in triangles:
		#draw_line(GlobeTools.stereo_to_vector3(triangle.edge_ab.a), GlobeTools.stereo_to_vector3(triangle.edge_ab.b))
		#draw_line(GlobeTools.stereo_to_vector3(triangle.edge_ca.a), GlobeTools.stereo_to_vector3(triangle.edge_ca.b))
		#draw_line(GlobeTools.stereo_to_vector3(triangle.edge_bc.a), GlobeTools.stereo_to_vector3(triangle.edge_bc.b))


func _physics_process(_delta):
	material.set_shader_parameter("SplatMapTexture", draw_viewport.get_texture())


func vector_to_intersection(vector: Vector3):
	var space_state := get_world_3d().direct_space_state
	
	var starting_point = vector.normalized() * 1.2
	var query = PhysicsRayQueryParameters3D.create(starting_point, globe_mesh.global_position)
	var intersection = space_state.intersect_ray(query)
	
	return intersection


func generate_noise_texture(uv_3d, size: Vector2i):
	var noise := FastNoiseLite.new()
	noise.seed = gen_seed
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.5
	noise.fractal_octaves = 1
	
	var image := Image.create(1024, 512, false, Image.FORMAT_RGB8)
	
	for x in uv_3d.size.x:
		for y in uv_3d.size.y:
			if typeof(uv_3d.map[x][y]) == TYPE_VECTOR3:
				var noise_val = noise.get_noise_3dv(uv_3d.map[x][y])
				var color = Color(noise_val, noise_val, noise_val)
				image.set_pixel(x, y, color)
	
	image.resize(size.x, size.y)
	#image.bump_map_to_normal_map(10)
	
	return ImageTexture.create_from_image(image)


func impress_shape_on_sprite(sprite: Sprite2D, shape: Area3D):
	
	var image = sprite.texture.get_image()
	image.resize(1024, 512)
	
	for pixel in $PixelCollider.get_pixels_inside_area(shape, $PixelCollider.UV1K):
		image.set_pixel(pixel.x, pixel.y, Color.WHITE)
	
	image.resize(map_size.x, map_size.y)
	sprite.texture = ImageTexture.create_from_image(image)


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

