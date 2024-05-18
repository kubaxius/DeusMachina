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
	settings.reset_rng()


func save_file():
	ResourceSaver.save(planet, "user://test_planet.tres")


func _on_setup_state_entered():
	await setup()
	state_chart.send_event("finished")


func _on_finished_state_entered():
	finished_generation.emit()
