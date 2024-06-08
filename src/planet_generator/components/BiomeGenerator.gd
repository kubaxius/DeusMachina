# Biome Generator
extends Generator


class BiomeCellSet:
	var size:
		get:
			return cells.size()
	var cells: Array[BiomeCell] = []
	var positions: Array[Vector3] = []
	var colors: Array[Vector3] = []
	var ids: Array[Vector3] = []


@export var subdiv_count: int = 10

var biome_painter_shader: Shader = \
preload("res://planet_generator/shaders/biome_painter.gdshader")

@onready var biomes: Array[Biome] = get_biome_settings()
@onready var sea_id: Color = get_sea_id()

func get_biome_settings() -> Array[Biome]:
	var biome_paths = Utils.get_all_file_paths("res://planet/biomes")
	
	var biome_settings: Array[Biome] = []
	for path in biome_paths:
		biome_settings.append(ResourceLoader.load(path))
	
	biome_settings = assign_biome_ids(biome_settings)
	
	return biome_settings


func assign_biome_ids(biome_settings: Array[Biome]) -> Array[Biome]:
	for i in biome_settings.size():
		var id = (float(i)/biome_settings.size()) * 16_500_000
		# shift to move out of alpha channel
		id = int(id) << 8
		# set alpha channel to 1
		id = id | 255
		biome_settings[i].id = Color.hex(id)
	
	return biome_settings


func get_sea_id() -> Color:
	for biome in biomes:
		if biome.name == "Sea":
			biome.used = true
			return biome.id
	return Color.BLACK


func create_biome_cell(vertex_id: int, mdt: MeshDataTool) -> BiomeCell:
	var bop = BiomeCell.new()
	bop.id = vertex_id
	var pos = mdt.get_vertex(vertex_id).normalized()
	bop.position = planet.get_point(pos)
	
	return bop


func connect_biome_cell_neighbors(vertex_id: int,\
			mdt: MeshDataTool, points: Array[BiomeCell]) -> Array[BiomeCell]:
	var edges = mdt.get_vertex_edges(vertex_id)
	for edge_id in range(edges.size()):
		for i in range(2):
			var vertex_edge_id = mdt.get_edge_vertex(edge_id, i)
			if vertex_edge_id != vertex_id:
				if not points[vertex_id].neighbors.has(points[vertex_edge_id]):
					points[vertex_id].neighbors.append(points[vertex_edge_id])
	return points


func get_cells() -> Array[BiomeCell]:
	var mesh := IcoSphereMesh.new()
	mesh.edge_count = subdiv_count
	var mdt = MeshDataTool.new()
	mdt.create_from_surface(mesh, 0)
	
	var points: Array[BiomeCell] = []
	for vertex_id in range(mdt.get_vertex_count()):
		points.append(create_biome_cell(vertex_id, mdt))
	
	# connect neighbors
	for vertex_id in range(mdt.get_vertex_count()):
		points = connect_biome_cell_neighbors(vertex_id, mdt, points)
	
	return points


func get_cells_on_land() -> Array[BiomeCell]:
	var cells_w_sea = get_cells()
	var cells: Array[BiomeCell] = []
	
	for biome_cell: BiomeCell in cells_w_sea:
		if not biome_cell.position.is_sea:
			cells.append(biome_cell)
	
	return cells


func set_biome(cell: BiomeCell):
	var weights = []
	for biome: Biome in biomes:
		weights.append(biome.calculate_weight(cell, settings.rng))
	
	cell.biome = Utils.weighted_choice(biomes, weights, settings.rng)
	cell.biome.used = true


func generate_biome_cell_set() -> BiomeCellSet:
	var biome_cell_set := BiomeCellSet.new()
	biome_cell_set.cells = get_cells_on_land()
	
	#assert(biome_cell_set.size <= 2000)
	
	for biome_cell in biome_cell_set.cells:
		set_biome(biome_cell)
		biome_cell_set.colors.append(Utils.color_to_vec3(biome_cell.biome.color))
		biome_cell_set.positions.append(biome_cell.position.position_3d)
		biome_cell_set.ids.append(Utils.color_to_vec3(biome_cell.biome.id))
	
	return biome_cell_set

# TODO: Make it possible to send more than 2000 Biome Points
func send_data_to_biome_shader(material: ShaderMaterial, biome_cell_set: BiomeCellSet):
	material.set_shader_parameter("NOISE_SHIFT", settings.noise_shift)
	material.set_shader_parameter("SEA_MAP", ImageTexture.create_from_image(planet.sea_map))
	material.set_shader_parameter("SEA_ID", Utils.color_to_vec3(sea_id))
	material.set_shader_parameter("BIOME_CELL_NUMBER", biome_cell_set.size)
	material.set_shader_parameter("BIOME_CELL_IDS", PackedVector3Array(biome_cell_set.ids))
	material.set_shader_parameter("BIOME_CELL_POSITIONS", PackedVector3Array(biome_cell_set.positions))


func generate_biome_map():
	var biome_cell_set := generate_biome_cell_set()
	
	var material = ShaderMaterial.new()
	material.shader = biome_painter_shader
	
	send_data_to_biome_shader(material, biome_cell_set)
	
	planet.biome_map = await texture_baker.get_image(material)


func save_biome_list():
	for biome in biomes:
		if biome.used:
			planet.biome_list.append(biome)


func _generate():
	await generate_biome_map()
	save_biome_list()
