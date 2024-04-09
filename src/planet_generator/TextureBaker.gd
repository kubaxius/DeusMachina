extends SubViewport

enum MAP{SEA_DIST, HEIGHT}

@onready var material: ShaderMaterial :
	set(mat):
		%UnwrappedGlobe.set_surface_override_material(0, mat)
	get:
		return %UnwrappedGlobe.get_active_material(0)


func _get_image():
	await RenderingServer.frame_post_draw
	return get_texture().get_image()


func get_map(type: MAP) -> Image:
	%UnwrappedGlobe.set_instance_shader_parameter("STATE", type)
	render_target_update_mode = SubViewport.UPDATE_ONCE
	return await _get_image()
