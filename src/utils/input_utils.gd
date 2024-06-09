class_name InputUtils extends Node


static func get_movement_vector() -> Vector3:
	var movement_vector = Vector3.ZERO
	if Input.is_action_pressed("move_forward"):
		movement_vector.z += -1
	if Input.is_action_pressed("move_backward"):
		movement_vector.z += 1
	if Input.is_action_pressed("move_left"):
		movement_vector.x += -1
	if Input.is_action_pressed("move_right"):
		movement_vector.x += 1
	
	movement_vector = movement_vector.normalized()
	
	if Input.is_action_pressed("action_sprint"):
		movement_vector = movement_vector * 2
	
	return movement_vector
