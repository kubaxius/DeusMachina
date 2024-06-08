class_name PlanetGenerator extends Node

@export var settings: GeneratorSettings

@onready var texture_baker: TextureBaker = %TextureBaker
@onready var state_chart: StateChart = %StateChart

signal finished_generation

var planet := Planet.new()


func _ready():
	await get_tree().create_timer(0.1).timeout
	start()


func start():
	state_chart.send_event("generation_started")


func setup():
	planet.axial_tilt = settings.axial_tilt
	planet.sea_level = settings.sea_level
	settings.reset_rng()


func save_file():
	ResourceSaver.save(planet, "user://test_planet.tres")


func send_data_to_generator_shader(material: ShaderMaterial) -> void:
	var continent_shape_data = planet.get_continents_shape_data()
	material.set_shader_parameter("SHAPES_PER_CONTINENT", settings.shapes_per_continent)
	material.set_shader_parameter("CONTINENTS_NUMBER", settings.number_of_continents)
	material.set_shader_parameter("TRANSFORM_COMPONENTS", continent_shape_data.transforms)
	material.set_shader_parameter("SHAPE_TYPES", continent_shape_data.types)
	material.set_shader_parameter("SHAPE_SCALES", continent_shape_data.scales)
	material.set_shader_parameter("SEA_LEVEL", settings.sea_level)
	material.set_shader_parameter("NOISE_SHIFT", settings.noise_shift)


func _on_setup_state_entered():
	await setup()
	state_chart.send_event("finished")


func _on_finished_state_entered():
	finished_generation.emit()
