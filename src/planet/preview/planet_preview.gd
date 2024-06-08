extends SubViewport

@export_node_path("PlanetGenerator") var planet_generator_path
@onready var planet_generator = get_node(planet_generator_path) 

var planet: Planet:
	set(p):
		%PreviewGlobe.planet = p


func print_point_data_on_click():
	if Input.is_action_just_pressed("main_click") and planet is Planet:
		var col := Utils.project_camera_ray($HGimbal/VGimbal/Camera3D,\
				$PreviewGlobe.get_world_3d(), get_viewport())
		if not col.is_empty():
			var pos = col.position
			var planet_point := planet.get_point(pos)
			print(planet_point)


func _on_planet_generator_finished_generation():
	planet = planet_generator.planet


func _process(_delta):
	print_point_data_on_click()
