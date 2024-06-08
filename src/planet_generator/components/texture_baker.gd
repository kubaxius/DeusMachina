class_name TextureBaker extends SubViewport

# TODO: Make it so that you will be able to set output image size.

func _get_image() -> Image:
	await RenderingServer.frame_post_draw
	var image = get_texture().get_image()
	#image.flip_y()
	#image.flip_x()
	return image


func _setup_sphere(material: ShaderMaterial) -> void:
	%UnwrappedGlobe.set_surface_override_material(0, material)
	%UnwrappedGlobe.show()
	%Texture.hide()


func _setup_texture(material: ShaderMaterial) -> void:
	%Texture.material = material
	%UnwrappedGlobe.hide()
	%Texture.show()


func get_image(material: ShaderMaterial) -> Image:
	match material.shader.get_mode():
		Shader.MODE_SPATIAL:
			_setup_sphere(material)
		Shader.MODE_CANVAS_ITEM:
			_setup_texture(material)
	render_target_update_mode = SubViewport.UPDATE_ONCE
	return await _get_image()
