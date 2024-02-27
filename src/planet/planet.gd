## Planet ##
extends Node3D

@onready var uv_to_3d = _load_uv_map()


func _ready():
	pass


func _load_uv_map():
	var text = FileAccess.open("res://planet/uv_to_3d.arr", FileAccess.READ).get_as_text()
	var uv_3d = str_to_var(text)
	return uv_3d

