class_name PlanetGenerator extends Node

@export var settings: GeneratorSettings

@onready var texture_baker: TextureBaker = %TextureBaker

# HACK: You will have to create much better ones.
var landmass_generator_shader: Shader = preload("res://planet_generator/shaders/landmass_generator.gdshader")
var humidity_generator_shader: Shader = preload("res://planet_generator/shaders/humidity_generator.gdshader")


enum MAP{COLOR, SEA, HEIGHT}
var sea_map: Image
var height_map: Image
var humidity_map: Image

func _ready():
	generate()


func send_data_to_continent_shader(material: ShaderMaterial) -> void:
	material.set_shader_parameter("SHAPES_PER_CONTINENT", settings.shapes_per_continent)
	material.set_shader_parameter("CONTINENTS_NUMBER", settings.number_of_continents)
	material.set_shader_parameter("TRANSFORM_COMPONENTS", settings.continents_transform_data)
	material.set_shader_parameter("SHAPE_DATA", settings.continents_shape_data)
	material.set_shader_parameter("SEA_LEVEL", settings.sea_level)


func generate_sea_map():
	var material = ShaderMaterial.new()
	material.shader = landmass_generator_shader
	send_data_to_continent_shader(material)
	
	material.set_shader_parameter("MODE", MAP.SEA)
	sea_map = await texture_baker.get_image(material)


func generate_height_map():
	var material = ShaderMaterial.new()
	material.shader = landmass_generator_shader
	send_data_to_continent_shader(material)
	
	material.set_shader_parameter("MODE", MAP.HEIGHT)
	height_map = await texture_baker.get_image(material)


func generate_humidity_map():
	var material = ShaderMaterial.new()
	
	material.shader = humidity_generator_shader
	material.set_shader_parameter("SEA_MAP", ImageTexture.create_from_image(sea_map))
	humidity_map = await texture_baker.get_image(material)


func generate():
	settings.regenerate_data()
	
	await generate_sea_map()
	await generate_height_map()
	await generate_humidity_map()
