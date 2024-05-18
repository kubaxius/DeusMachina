extends Control


func _ready():
	hide()


func _unhandled_input(event):
	if event.is_action_released("open_debug_menu"):
		print("Debug Menu")
		visible = !visible
