## Planet/Point ##
class_name PlanetPoint extends Node3D

static var GlobeTools = preload("res://utils/globe_tools.gd")


var position_3d: Vector3:
	get:
		return position
	set(pos):
		position = pos

var position_stereo: Vector2:
	get: 
		return GlobeTools.vector3_to_stereo(position)
	set(pos):
		position = GlobeTools.stereo_to_vector3(pos)


func _init(pos:Vector3):
	position = pos.normalized()

