extends Control


func _ready():
	hide()


func _unhandled_input(event):
	if event.is_action_pressed("open_debug_menu"):
		print("Debug Menu")
		visible = !visible
