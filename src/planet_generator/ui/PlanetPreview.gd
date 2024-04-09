extends SubViewport

@export_node_path("PlanetGenerator") var planet_generator

func _ready():
	#get_node(planet_generator).send_data_to_continent_shader(%PreviewGlobe.get_active_material(0))
	var mat := StandardMaterial3D.new()
	%PreviewGlobe.set_surface_override_material(0, mat)
	await get_tree().create_timer(1).timeout
	mat.albedo_texture = ImageTexture.create_from_image(get_node(planet_generator).height_map)
	await get_tree().create_timer(1).timeout
	mat.albedo_texture = ImageTexture.create_from_image(get_node(planet_generator).sea_dist_map)
