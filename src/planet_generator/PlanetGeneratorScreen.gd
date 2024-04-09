extends Control

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			print("dupa")
			var image = await $PlanetGenerator.texture_baker.get_map($PlanetGenerator.texture_baker.MAP.SEA_DIST)
			%Preview2D.texture = ImageTexture.create_from_image(image)
			await get_tree().create_timer(1).timeout
			image = await $PlanetGenerator.texture_baker.get_map($PlanetGenerator.texture_baker.MAP.HEIGHT)
			%Preview2D.texture = ImageTexture.create_from_image(image)
			
