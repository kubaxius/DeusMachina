# Geology Generator
extends Generator


# HACK: You will have to create much better ones.
var landmass_generator_shader: Shader = \
preload("res://planet_generator/shaders/landmass_generator.gdshader")
var sea_dist_shader: Shader = \
preload("res://planet_generator/shaders/sea_dist_shader.gdshader")

enum Map{COLOR, SEA, HEIGHT}


func generate_continent_data():
	for i in settings.number_of_continents:
		var new_continent = Continent.new()
		
		# north cape
		if i == 0 and settings.polar_capes:
			new_continent.setup(planet, settings,
						planet.get_point(Vector3.UP))
		# south cape
		elif i == 1 and settings.polar_capes:
			new_continent.setup(planet, settings,
						planet.get_point(Vector3.DOWN))
		# rest of the continents
		else:
			new_continent.setup(planet, settings)
			
		planet.continents.append(new_continent)


func generate_sea_map():
	var material = ShaderMaterial.new()
	material.shader = landmass_generator_shader
	main_generator.send_data_to_generator_shader(material)
	material.set_shader_parameter("MODE", Map.SEA)
	
	planet.sea_map = await texture_baker.get_image(material)


func generate_height_map():
	var material = ShaderMaterial.new()
	material.shader = landmass_generator_shader
	main_generator.send_data_to_generator_shader(material)
	material.set_shader_parameter("MODE", Map.HEIGHT)
	
	planet.height_map = await texture_baker.get_image(material)


func generate_sea_dist_map():
	var material = ShaderMaterial.new()
	material.shader = sea_dist_shader
	main_generator.send_data_to_generator_shader(material)
	
	material.set_shader_parameter("SEA_MAP", ImageTexture.create_from_image(planet.sea_map))
	planet.sea_dist_map = await texture_baker.get_image(material)




func _generate():
	generate_continent_data()
	await generate_sea_map()
	await generate_sea_dist_map()
	await generate_height_map()
