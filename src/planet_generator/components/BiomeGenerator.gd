# Biome Generator
extends Generator


var biome_painter_shader: Shader = \
preload("res://planet_generator/shaders/biome_painter.gdshader")

@onready var biomes: Array = get_biome_settings()



func get_biome_settings() -> Array:
	var biome_paths = Utils.get_all_file_paths("res://planet/biomes")
	
	var all_settings = []
	for path in biome_paths:
		all_settings.append(ResourceLoader.load(path))
	
	return all_settings


func get_biome_cells() -> Array[BiomeCell]:
	var mesh := IcoSphereMesh.new()
	mesh.edge_count = 10
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	
	var points: Array[BiomeCell] = []
	for vertex_id in range(mdt.get_vertex_count()):
		var bop = BiomeCell.new()
		bop.id = vertex_id
		var pos = mdt.get_vertex(vertex_id).normalized()
		bop.position = planet.get_point(pos)
		points.append(bop)
	
	# connect neighbors
	for vertex_id in range(mdt.get_vertex_count()):
		var edges = mdt.get_vertex_edges(vertex_id)
		for edge_id in range(edges.size()):
			for i in range(2):
				var vertex_edge_id = mdt.get_edge_vertex(edge_id, i)
				if vertex_edge_id != vertex_id:
					if not points[vertex_id].neighbors.has(points[vertex_edge_id]):
						points[vertex_id].neighbors.append(points[vertex_edge_id])
	
	return points


func set_biome(cell: BiomeCell):
	var weights = []
	for biome: Biome in biomes:
		weights.append(biome.calculate_weight(cell, settings.rng))
	
	cell.biome = Utils.weighted_choice(biomes, weights, settings.rng)


func generate_biome_map():
	var biome_cells_w_sea = get_biome_cells()
	var biome_cells = []
	
	var i = 0
	for biome_cell: BiomeCell in biome_cells_w_sea:
		if not biome_cell.position.is_sea:
			i += 1
			if i == 10:
				print(biome_cell.position)
			biome_cells.append(biome_cell)
	
	assert(biome_cells.size() <= 2000)
	
	for biome_cell: BiomeCell in biome_cells:
		set_biome(biome_cell)
	
	
	var biome_cell_colors = []
	for biome_cell in biome_cells:
		biome_cell_colors.append(Vector3(biome_cell.biome.color.r, biome_cell.biome.color.g, biome_cell.biome.color.b))
	
	var biome_cell_positions = []
	for biome_cell in biome_cells:
		biome_cell_positions.append(biome_cell.position.position_3d)
	
	var material = ShaderMaterial.new()
	material.shader = biome_painter_shader
	
	material.set_shader_parameter("SEA_MAP", ImageTexture.create_from_image(planet.sea_map))
	material.set_shader_parameter("BIOME_CELL_NUMBER", biome_cells.size())
	material.set_shader_parameter("BIOME_CELL_COLORS", PackedVector3Array(biome_cell_colors))
	material.set_shader_parameter("BIOME_CELL_POSITIONS", PackedVector3Array(biome_cell_positions))
	material.set_shader_parameter("NOISE_SHIFT", settings.noise_shift)
	planet.biome_map = await texture_baker.get_image(material)


func _generate():
	await generate_biome_map()
