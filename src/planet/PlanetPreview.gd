extends SubViewport

@export_node_path("PlanetGenerator") var planet_generator_path
@onready var planet_generator = get_node(planet_generator_path) 

var planet: Planet
var current_map_id: int = 0

func print_point_data_on_click():
	if Input.is_action_just_pressed("main_click") and planet is Planet:
		var col := Utils.project_camera_ray($HGimbal/VGimbal/Camera3D, $PreviewGlobe.get_world_3d(), get_viewport())
		if not col.is_empty():
			var pos = col.position
			var planet_point := planet.get_point(pos)
			print(planet_point)


func change_preview(type: Planet.MapType):
	var mat := StandardMaterial3D.new()
	%PreviewGlobe.set_surface_override_material(0, mat)
	var image = planet.get_map(type)
	mat.albedo_texture = ImageTexture.create_from_image(image)


func next_map_preview():
	current_map_id += 1
	if current_map_id >= Planet.MapType.size():
		current_map_id = 0
	change_preview(current_map_id)


func _on_planet_generator_finished_generation():
	planet = planet_generator.planet
	change_preview(Planet.MapType.SEA)


func _process(_delta):
	print_point_data_on_click()
	if Input.is_action_just_pressed("action_jump") and planet is Planet:
		next_map_preview()
