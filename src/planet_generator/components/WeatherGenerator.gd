# Weather Generator
extends Generator


var humidity_generator_shader: Shader = \
preload("res://planet_generator/shaders/humidity_generator.gdshader")
var sunlight_calculator_shader: Shader = \
preload("res://planet_generator/shaders/sunlight_generator.gdshader")



func _generate():
	await get_tree().create_timer(1).timeout
