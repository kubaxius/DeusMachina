extends Marker3D

@export_range(0, 1, 0.1) var movement_speed = 0.2
@export_range(0, 100, 1) var sensitivity = 20
@export_range(0, 5, 0.1) var zoom_amount: float = 1
@export var max_zoom_dist: float = 1000
@export var min_zoom_dist: float = 1
## Base for zoom exponential function.
@export var zoom_base = 1.5

@onready var h_gimbal: Node3D = $HGimbal
@onready var v_gimbal: Node3D = $HGimbal/VGimbal
@onready var camera: Camera3D = %Camera

var current_zoom_exponent = 0
var movement_vector := Vector3.ZERO

func _ready():
	current_zoom_exponent = log(camera.position.z)/log(zoom_base)


func _unhandled_input(event):
	handle_rotation_input(event)
	handle_zoom_input(event)
	handle_movement_input()


func _physics_process(_delta):
	position += movement_vector
	var desired_height = $GroundDetector.get_desired_height()
	position.y = lerp(position.y, desired_height, 0.3)


func handle_rotation_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("rotate_camera"):
			rotate_camera(Vector2(-event.relative.x, -event.relative.y))


func handle_zoom_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		zoom(-zoom_amount)
	
	if event.is_action_pressed("zoom_out"):
		zoom(zoom_amount)


func handle_movement_input() -> void:
	var mv = InputUtils.get_movement_vector()
	mv = mv.rotated(Vector3.UP, camera.global_rotation.y)
	movement_vector = mv * movement_speed


# rotate camera around point of interest
func rotate_camera(v: Vector2) -> void:
	v_gimbal.rotate_x(v.y/(101 - sensitivity))
	h_gimbal.rotate_y(v.x/(101 - sensitivity))
	v_gimbal.rotation.x = clamp(v_gimbal.rotation.x, -PI/2, PI/2)


# zoom is exponential
func zoom(amount: float) -> void:
	current_zoom_exponent += amount
	var new_pos_z = pow(zoom_base, current_zoom_exponent)
	
	if new_pos_z > max_zoom_dist or new_pos_z < min_zoom_dist:
		current_zoom_exponent -= amount
		return
	
	camera.position.z = new_pos_z
