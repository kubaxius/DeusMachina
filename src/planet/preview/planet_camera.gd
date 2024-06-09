extends Camera3D

@export_range(0, 100, 1) var sensitivity = 20
@export_range(0, 20, 1) var zoom_amount = 3

@onready var h_gimbal: Node3D = get_parent().get_parent()
@onready var v_gimbal: Node3D = get_parent()


func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("main_click"):
			v_gimbal.rotate_x(-event.relative.y/(101 - sensitivity))
			h_gimbal.rotate_y(-event.relative.x/(101 - sensitivity))
			v_gimbal.rotation.x = clamp(v_gimbal.rotation.x, -PI/2, PI/2)


func _process(_delta):
	if Input.is_action_pressed("zoom_in"):
		position.z -= zoom_amount * 0.1
	
	if Input.is_action_pressed("zoom_out"):
		position.z += zoom_amount * 0.1
