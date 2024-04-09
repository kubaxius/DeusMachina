class_name PlanetGenerator extends Node

@export var settings: GeneratorSettings

@onready var texture_baker = %TextureBaker
@onready var baker_material: ShaderMaterial = texture_baker.material


var sea_dist_map: Image
var height_map: Image

func _ready():
	generate()


func send_data_to_continent_shader(material: ShaderMaterial) -> void:
	material.set_shader_parameter("SHAPES_PER_CONTINENT", settings.shapes_per_continent)
	material.set_shader_parameter("CONTINENTS_NUMBER", settings.number_of_continents)
	material.set_shader_parameter("TRANSFORM_COMPONENTS", settings.continents_transform_data)
	material.set_shader_parameter("SHAPE_DATA", settings.continents_shape_data)


func generate():
	send_data_to_continent_shader(baker_material)
	sea_dist_map = await texture_baker.get_map(texture_baker.MAP.SEA_DIST)
	height_map = await texture_baker.get_map(texture_baker.MAP.HEIGHT)
